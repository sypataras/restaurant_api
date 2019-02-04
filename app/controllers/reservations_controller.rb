class ReservationsController < ApplicationController
  before_action :authenticate_user,  only: [:create]
  before_action :authenticate_rest,  only: [:show]

  def create
    restaurant = Restaurant.by_reserv(reserv_params.delete(:table_id),reserv_params.delete(:shift_id))
    reservation = restaurant.reservations.build(reserv_params)
    if reservation.save
      render json: { success: true, status: 200, message: 'Reservation was created!'}
    else
      json_error_response('Create reservation failed', reservation.errors.messages)
    end
  end

  private

  def reserv_params
    @reserv_params = params.require(:reservation).permit(:start_at, :end_at, :guest_count, :table_id, :shift_id)
    @reserv_params['user_id'] = current_user.id
    @reserv_params
  end
end
