function five_in_a_row

    axis equal
    axis([-10,10,-10,10])
    set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
    set(gca,'color',[0.8392,0.7216,0.3804])
    hold on

    set(gcf,'WindowButtonDownFcn',@buttondown)

global winner;
global turn;
global checher_board
global black;
global white;
global postion;

init()
    function init()

        delete(findobj('tag','piece'));
        delete(findobj('tag','redcross'));
        delete(findobj('type','line'));
        delete(findobj('type','patch'));
        
        %棋盘绘制：
        x1=[-9,-9,-8,-8,-7,-7,-6,-6,-5,-5,-4,-4,-3,-3,-2,-2,-1,-1,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9];
        y1=[-9,9,9,-9,-9,9,9,-9,-9,9,9,-9,-9,9,9,-9,-9,9,9,-9,-9,9,9,-9,-9,9,9,-9,-9,9,9,-9,-9,9,9,-9,-9,9];
        x2=[-9,9,9,-9,-9];
        y2=[9,9,-9,-9,9];
        x3=[-9.2,9.2,9.2,-9.2,-9.2];
        y3=[9.2,9.2,-9.2,-9.2,9.2];
        x4=[-6,-6,-6,0,0,0,6,6,6];
        y4=[6,0,-6,6,0,-6,6,0,-6];
        plot(x1,y1,'k')
        plot(y1,x1,'k')
        plot(x2,y2,'k','LineWidth',2)
        plot(x3,y3,'k')
        scatter(gca,x4,y4,30,'k','filled')
        
        winner=0;postion=[0 0];turn=1;
        black=[20,20];white=[-20,-20];
        black(1,:)=[];white(1,:)=[];
        checher_board=zeros(19,19);
        
    end

    function buttondown(~,~)
        xy=get(gca,'CurrentPoint');
        xp=xy(1,2);yp=xy(1,1);
        pos=[yp,xp];
        pos=round(pos);
        if all(abs(pos)<=9)
            postion=round(pos);
            if strcmp(get(gcf,'SelectionType'),'normal'),place();end
            if strcmp(get(gcf,'SelectionType'),'extend'),init();end
            redraw()
        end
    end

    function place()
        if checher_board(postion(1)+10,postion(2)+10)==0&&winner==0
            if(turn == 1)
                    checher_board(postion(1)+10,postion(2)+10)=1;
                    black=[black;postion];
                    turn=0;
            elseif (turn == 0)
                    checher_board(postion(1)+10,postion(2)+10)=-1;
                    white=[white;postion];
                    turn=1;
            end
        end     
    end

    function redraw(~,~)
        if winner==0
            plotblack=scatter(gca,black(:,1),black(:,2),150,'k','filled','tag','piece');
            plotwhite=scatter(gca,white(:,1),white(:,2),150,'w','filled','tag','piece');
            plotpostion=scatter(gca,postion(1,1),postion(1,2),150,'rx','tag','redcross');
            set(plotblack,'XData',black(:,1),'YData',black(:,2))
            set(plotwhite,'XData',white(:,1),'YData',white(:,2))
            set(plotpostion,'XData',postion(:,1),'YData',postion(:,2))
        judge()
        end
    end

    function judge(~,~)
        case1=checher_board+[zeros(19,1),checher_board(:,1:18)]...
                                +[zeros(19,2),checher_board(:,1:17)]...
                                +[checher_board(:,2:end),zeros(19,1)]...
                                +[checher_board(:,3:end),zeros(19,2)];
        case2=checher_board+[zeros(1,19);checher_board(1:18,:)]...
                                +[zeros(2,19);checher_board(1:17,:)]...
                                +[checher_board(2:end,:);zeros(1,19)]...
                                +[checher_board(3:end,:);zeros(2,19)];
        case3=checher_board+[zeros(1,19);[zeros(18,1),checher_board(1:18,1:18)]]...
                                +[zeros(2,19);[zeros(17,2),checher_board(1:17,1:17)]]...
                                +[[checher_board(2:end,2:end),zeros(18,1)];zeros(1,19)]...
                                +[[checher_board(3:end,3:end),zeros(17,2)];zeros(2,19)];
        case4=checher_board+[[zeros(18,1),checher_board(2:end,1:18)];zeros(1,19)]...
                                +[[zeros(17,2),checher_board(3:end,1:17)];zeros(2,19)]...
                                +[zeros(1,19);[checher_board(1:18,2:end),zeros(18,1)]]...
                                +[zeros(2,19);[checher_board(1:17,3:end),zeros(17,2)]];
        switch 1
            case any(any(case1==5))||any(any(case1==-5))
                winner=any(any(case1==5))-any(any(case1==-5));
                [pos_x,pos_y]=find(case1(:,:)==winner*5);
                endpoint=[pos_x(1),pos_y(1);pos_x(1),pos_y(1)]+[0 2;0 -2];
            case any(any(case2==5))||any(any(case2==-5))
                winner=any(any(case2==5))-any(any(case2==-5));
                [pos_x,pos_y]=find(case2(:,:)==winner*5);
                endpoint=[pos_x(1),pos_y(1);pos_x(1),pos_y(1)]+[2 0;-2 0];
            case any(any(case3==5))||any(any(case3==-5))
                winner=any(any(case3==5))-any(any(case3==-5));
                [pos_x,pos_y]=find(case3(:,:)==winner*5);
                endpoint=[pos_x(1),pos_y(1);pos_x(1),pos_y(1)]+[2 2;-2 -2];
            case any(any(case4==5))||any(any(case4==-5))
                winner=any(any(case4==5))-any(any(case4==-5));
                [pos_x,pos_y]=find(case4(:,:)==winner*5);
                endpoint=[pos_x(1),pos_y(1);pos_x(1),pos_y(1)]+[2 -2;-2 2];
        end
        if winner ==1
            plot(endpoint(:,1)-10,endpoint(:,2)-10,'color',[0.8 0 0],'linewidth',2,'tag','clues')
            delete(findobj('tag','redcross'))
        end
    end
end

