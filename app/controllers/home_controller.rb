class HomeController < ApplicationController
  def index
    @hash = Gmaps4rails.build_markers(Order.all) do |order, marker|
      marker.lat order[:delivery_latitude]
      marker.lng order[:delivery_longitude]
      marker.infowindow order[:delivery_address]
    end
  end

  def routes
    @orders = Order.all.map{|order| [order[:delivery_latitude], order[:delivery_longitude]]}
    start_point = Order.all.first
    vehicle_data = {
      "vehicles": [
         {
           "vehicle_id": "testing",
           "start_address": {
               "location_id": start_point[:delivery_address],
               "lon": start_point[:delivery_longitude],
               "lat": start_point[:delivery_latitude]
           }
         }
      ],
      "services": Order.vehicle_data
    }
    job_id = Order.get_job_id(vehicle_data)
    routes = Order.get_optimized_routes(job_id)
    @optimizeed_routes = routes['solution']['routes'][0]['activities']
    @hash = Gmaps4rails.build_markers(Order.all) do |order, marker|
      marker.lat order[:delivery_latitude]
      marker.lng order[:delivery_longitude]
      marker.infowindow order[:delivery_address]
    end
  end
end
