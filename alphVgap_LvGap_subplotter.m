clear all;

step=10;
nev=50;

directory_name=uigetdir;

%This portion of code, using uigetdir, finds the files which we use to read out information
%about the matrix describing H2 and H3. we look at angular momentum and the
%energy coefficients here

for j= 1:step+1
    files=dir(directory_name);
    file_name=files(3*(j-1)+7,1).name;
    a1=(j-1)/step;
    fullname = fullfile(directory_name,file_name);
    fileID = fopen(fullname,'r');
    formatSpec = '%f';
    sizeA=[1 inf];
    A = fscanf(fileID,formatSpec,sizeA);
    fclose(fileID);
    [dimr,dimc]=size(A);
    
    files=dir(directory_name);
    file_name=files(3*(j-1)+5,1).name;
    a1=(j-1)/step;
    fullname = fullfile(directory_name,file_name);
    fileID = fopen(fullname,'r');
    formatSpec = '%f';
    sizeB=[1 inf];
    B = round(fscanf(fileID,formatSpec,sizeA));
    fclose(fileID);
    for i=1:dimc
        gap(i,j)=A(i)-A(1);
        gapp(i,j)=A(i)-A(1);
        l(i,j)=B(i);
        ll(i,j)=B(i);
        alph(i,j)=(j-1)/step;
    end
end

%we are finding the maximum angular momentum so that we can sort based on
%angular momentum

lmaxh2=max(ll(:,11));
lmaxh1=max(l(:,1));
[nrow ncol]=size(gap);
nele=nrow*ncol;
alph = reshape(transpose(alph),[nele, 1]);
l=reshape(transpose(l),[nele, 1]);
gap=reshape(transpose(gap),[nele,1]);
alg = [l gap alph];

%builds a matrice with alpha, angular momentum, and gap calculations

for i = 1:(nele-(step+1))
   alg(i,1)=alg(i+(step+1),1);
   alg(i,2)=alg(i+(step+1),2);
end

lmax=max(alg(:,1));
c=max(alg(:,2));

%We sort matrix by gap and angular momentum so we can plot latter

for i=1:3
    for j = 0:lmax
        newclr(j+1,i) = rand;
    end
end

%Loop which plots angular momentum versus gap for H3

figure
subplot(1,3,1)
hold on;
for i = 2 :nrow
    for j= 0:lmaxh1
        if ll(i,1) == j
           h(j+1)=scatter(ll(i,1),gapp(i,1),25,newclr(j+1),'o','filled');
        else
        end
    end
end
box on;
ylabel('\Delta A.U.','FontSize',18, 'FontName', 'Times New Roman')
xlabel('$H_{3}$','FontSize',18, 'FontName', 'Times New Roman','Interpreter','latex')
ylim([-0.01 c+0.01*c]);
xlim([0 lmax]);
set(gca,'FontName','Times New Roman','FontSize',18,'LineWidth',1)
hold off;

%Plots alpha vers gap

subplot(1,3,2)
hold on;
for i =1 :nele
    for j= 0:lmax
        if alg(i,1) == j
            h(j+1)=scatter(alg(i,3),alg(i,2),18,newclr(j+1),'o','filled');
        else
        end
    end
end
xlabel('$\alpha$','FontSize',18, 'FontName', 'Times New Roman','Interpreter','latex')
ylim([-0.01 c+0.01*c]);
set(gca,'FontName','Times New Roman','FontSize',18,'LineWidth',1)
box on;

%plots angular momenta versus gap for H2

subplot(1,3,3)
hold on;
for i = 2 :nrow
    for j= 0:lmaxh2
        if ll(i,ncol) == j
            h(j+1)=scatter(ll(i,ncol),gapp(i,ncol),25,newclr(j+1),'o','filled');
        else
        end
    end
end
ylim([-0.01 c+0.01*c]);
xlim([0 lmax]);
hold off;

%this creates a legend which correctly maps the color of each value of
%angular momenta to the correct trend line

for i= 0:lmax
   legmat(i+1) =  {strcat('L= ',num2str(i))};
end

%the below commands make the graph look pretty

box on;
c=max(alg(:,2));
set(gca,'FontName','Times New Roman','FontSize',18,'LineWidth',1);
xlabel('$H_{2}$','FontSize',18, 'FontName', 'Times New Roman','Interpreter','latex')



