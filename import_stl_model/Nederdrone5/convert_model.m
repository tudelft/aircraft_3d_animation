clearvars;
close all;
% Add path to stlTools
% You can download the package for free from: 
% https://es.mathworks.com/matlabcentral/fileexchange/51200-stltools
addpath('./stlTools');
% Set the name of the mat file containing all the info of the 3D model
MatFileName = 'Nederdrone5.mat';
% Define the list of parts which will be part of the rigid aircraft body
rigid_body_list   = {'V5 Nederdrone.stl'};
% Define the color of each part
rigid_body_colors = {0.8 * [1, 1, 1]};
% Define the transparency of each part
alphas            = [              1];
% Define the model ofset to center the A/C Center of Gravity
offset_3d_model   = [0,0,0]; %[8678.85, -15.48, 606.68];
% Define the controls 
ControlsFieldNames = {...
'model'              'label',             'color',                             'rot_point',            'rot_vect', 'max_deflection'};
Controls = {                                                                                                       
% 'FP_Right.stl',       'FP_R',   0.3*[0.8, 0.8, 1], [5719,   996.6,  600.0]-offset_3d_model,            [0,  1, 0], [-30, +30];
% 'FP_Left.stl',        'FP_L',   0.3*[0.8, 0.8, 1], [5719,  -996.6,  600.0]-offset_3d_model,            [0,  1, 0], [-30, +30];
% 'LE_Left.stl',        'LE_L',   0.3*[0.8, 0.8, 1], [9267, -2493.0,  380.2]-offset_3d_model,  [0.7849, -0.6197, 0], [ -1, +30];
% 'LE_right.stl',       'LE_R',   0.3*[0.8, 0.8, 1], [9267, +2493.0,  380.2]-offset_3d_model, [-0.7849, -0.7197, 0], [ -1, +30];
% 'Rudder.stl',          'RUD',   0.3*[0.8, 0.8, 1], [12930,    0.0, 1387.0]-offset_3d_model,            [0, 0, -1], [-30, +30];
% 'Elevon_Left.stl',  'FLAP_L',   0.3*[0.8, 0.8, 1], [11260, -860.9,  368.3]-offset_3d_model,  [+0.0034, 0.9999, 0], [-30, +30];
% 'Elevon_Right.stl', 'FLAP_R',   0.3*[0.8, 0.8, 1], [11260, +860.9,  368.3]-offset_3d_model,  [-0.0034, 0.9999, 0], [-30, +30];
};


% Definition of the Model3D data structure
% Rigid body parts
for i = 1:length(rigid_body_list)
    Model3D.Aircraft(i).model = rigid_body_list{i};
    Model3D.Aircraft(i).color = rigid_body_colors{i};
    Model3D.Aircraft(i).alpha = alphas(i);
    % Read the *.stl file
   [Model3D.Aircraft(i).stl_data.vertices, Model3D.Aircraft(i).stl_data.faces, ~, Model3D.Aircraft(i).label] = stlRead(rigid_body_list{i});
    Model3D.Aircraft(i).stl_data.vertices  = Model3D.Aircraft(i).stl_data.vertices - offset_3d_model;
end
% Controls parts
% for i = 1:size(Controls, 1)
%     for j = 1:size(Controls, 2)
%         Model3D.Control(i).(ControlsFieldNames{j}) = Controls{i, j};
%     end
%     % Read the *.stl file
%     [Model3D.Control(i).stl_data.vertices, Model3D.Control(i).stl_data.faces, ~, ~] = stlRead( Model3D.Control(i).model);
%     Model3D.Control(i).stl_data.vertices = Model3D.Control(i).stl_data.vertices - offset_3d_model;
% end


%% Check the results
% Get maximum dimension to plot the circles afterwards
AC_DIMENSION = max(max(sqrt(sum(Model3D.Aircraft(1).stl_data.vertices.^2,2))));
% for i=1:length(Model3D.Control)
%     AC_DIMENSION = max(AC_DIMENSION,max(max(sqrt(sum(Model3D.Control(i).stl_data.vertices.^2,2)))));
% end
% Define the figure properties
AX = axes('position',[0.0 0.0 1 1]);
axis off
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[scrsz(3)/40 scrsz(4)/12 scrsz(3)/2*1.0 scrsz(3)/2.2*1.0],'Visible','on');
set(AX,'color','none');
axis('equal')
hold on;
cameratoolbar('Show')
% Plot objects
% -------------------------------------------------------------------------
% Plot airframe
for i = 1:length(Model3D.Aircraft)
    AV = patch(Model3D.Aircraft(i).stl_data,  'FaceColor',        Model3D.Aircraft(i).color, ...
        'EdgeColor',        'none',        ...
        'FaceLighting',     'gouraud',     ...
        'AmbientStrength',   0.15);
end
% CONT(length(Model3D.Control))=0;
% Plot controls
% for i=1:length(Model3D.Control)
%     CONT(i) = patch(Model3D.Control(i).stl_data,  'FaceColor',        Model3D.Control(i).color, ...
%         'EdgeColor',        'none',        ...
%         'FaceLighting',     'gouraud',     ...
%         'AmbientStrength',  0.15);
%     % Plot the rotation point and the rotation axis of each control
%     % (double-check correct implementation and rotation direction of each
%     % control surface)
%     p = Model3D.Control(i).rot_point;
%     vect = Model3D.Control(i).rot_vect;
%     plot3(p(1)+[0, AC_DIMENSION*vect(1)/2], p(2)+[0, AC_DIMENSION*vect(2)/2], p(3)+[0, AC_DIMENSION*vect(3)/2], 'b-o', 'MarkerSize', 10, 'LineWidth', 2);
% end
% Fixing the axes scaling and setting a nice view angle
axis('equal');
axis([-1 1 -1 1 -1 1] * 2.0 * AC_DIMENSION)
set(gcf,'Color',[1 1 1])
axis off
view([30 10])
zoom(2.0);
% Add a camera light, and tone down the specular highlighting
camlight('left');
material('dull');