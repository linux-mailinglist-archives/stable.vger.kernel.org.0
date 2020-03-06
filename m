Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38BE317BC4F
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 13:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgCFMHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 07:07:19 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40783 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgCFMHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 07:07:19 -0500
Received: by mail-lf1-f66.google.com with SMTP id p5so1707714lfc.7
        for <stable@vger.kernel.org>; Fri, 06 Mar 2020 04:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4KPUPSTkugtYA0PbEeoVta4pOw/ai16ArIKK838lBEU=;
        b=CqMIIU6OgUcYfP+nO15DqV4Gn+28U4l0XKINHu7YR8cz06yd1dTfyQOySiqK8perVe
         q9cBlZ2hKQbb6Y6/ajVOTatYAlb8vOP2A+OXF4OW7VofwPUW8se8+6H3YntUcm9i03X0
         dhmQuNmiKWxKSbFtmu3Dise3GGTlB0YOpqwp7veoFIANAJ/YXBAnSy0VfnbTKvbDT1un
         de/8n7Nsne1PBues3q5A7DLVutU3rmafGrzSpvI7sWUzRtt1FntXj7ANmZRArJrX4P6N
         v3sBy6cEI8TxFNCkLrLgmFRuuUUbivLim/IAEzmhkO9x3QDAIpTgcMcIbIzsGSY+zlbK
         L3Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4KPUPSTkugtYA0PbEeoVta4pOw/ai16ArIKK838lBEU=;
        b=n8S/MW67AS3wsZcY3owBcNtkylw0mddmiymW7noFiXTz7GJYCHRdrS6LZzTR+bjUlG
         u1cbRRMLMXSnhK7MyVDEPKQ6DeK+gJDQa2DXcWaBTV3FL/L/sX1E9trx0QepQuAgAlFU
         WjWFScBstD1r/t+hZzMEJKNr0uqWE/+Z0MzKBVLjo5NLXp2kXkO1CsjyqvCeKYzs6ffD
         gLKCnhW2Yg8Pqoq6Z3M/FTfnQW7iHWOcUOBSwG3ykUM0N7XJIvM4Owfy6WgzCoihWSrh
         1sRazXyEbG83vJRzez390doPKbMFc9sYA2yXJtiVwlBJvOH5lHyNR3bs5n6trQJnSVn4
         GwWA==
X-Gm-Message-State: ANhLgQ3h4lP/br124lTpqnSMB7Vvz1X+b8/pRrKcQaFnU1md1GVRnp7g
        YsjsKPAnm3rh61JoIYgFnmQPC9zvM7eYQTEPnqoU4A==
X-Google-Smtp-Source: ADFU+vvQ1aR+zpKusZ09dVvP7kf4bC66fgMS07Kbjp8L2S6t2eYS+496jT2rtl2R7T0gZJhh4p4P35QHGaUh8yls+jk=
X-Received: by 2002:a19:c215:: with SMTP id l21mr1732735lfc.95.1583496435711;
 Fri, 06 Mar 2020 04:07:15 -0800 (PST)
MIME-Version: 1.0
References: <20200305172921.22743-1-vincent.guittot@linaro.org>
 <e31aa232-bc7e-a7b9-5b6a-a1131ac88164@arm.com> <CAKfTPtAqg+CGNBHF53dXp4BcmtucgW4k4skQ1x1jxuyo0PDaMg@mail.gmail.com>
In-Reply-To: <CAKfTPtAqg+CGNBHF53dXp4BcmtucgW4k4skQ1x1jxuyo0PDaMg@mail.gmail.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Fri, 6 Mar 2020 13:07:04 +0100
Message-ID: <CAKfTPtB8YrVd=DjPXCs589wCJWT_Jo_dyLQ4WMdEKPTAt5GRvw@mail.gmail.com>
Subject: Re: [PATCH] sched/fair: fix enqueue_task_fair warning
To:     Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "# v4 . 16+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 6 Mar 2020 at 10:12, Vincent Guittot <vincent.guittot@linaro.org> wrote:
>
> On Thu, 5 Mar 2020 at 20:07, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> >
> > On 05/03/2020 18:29, Vincent Guittot wrote:
> > > When a cfs rq is throttled, the latter and its child are removed from the
> > > leaf list but their nr_running is not changed which includes staying higher
> > > than 1. When a task is enqueued in this throttled branch, the cfs rqs must
> > > be added back in order to ensure correct ordering in the list but this can
> > > only happens if nr_running == 1.
> > > When cfs bandwidth is used, we call unconditionnaly list_add_leaf_cfs_rq()
> > > when enqueuing an entity to make sure that the complete branch will be
> > > added.
> > >
> > > Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > > Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > > Cc: stable@vger.kernel.org #v5.1+
> > > Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> > > ---
> > >  kernel/sched/fair.c | 11 +++++++++--
> > >  1 file changed, 9 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > > index fcc968669aea..bdc5bb72ab31 100644
> > > --- a/kernel/sched/fair.c
> > > +++ b/kernel/sched/fair.c
> > > @@ -4117,6 +4117,7 @@ static inline void check_schedstat_required(void)
> > >  #endif
> > >  }
> > >
> > > +static inline bool cfs_bandwidth_used(void);
> > >
> > >  /*
> > >   * MIGRATION
> > > @@ -4195,10 +4196,16 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
> > >               __enqueue_entity(cfs_rq, se);
> > >       se->on_rq = 1;
> > >
> > > -     if (cfs_rq->nr_running == 1) {
> > > +     /*
> > > +      * When bandwidth control is enabled, cfs might have been removed because of
> > > +      * a parent been throttled but cfs->nr_running > 1. Try to add it
> > > +      * unconditionnally.
> > > +      */
> > > +     if (cfs_rq->nr_running == 1 || cfs_bandwidth_used())
> > >               list_add_leaf_cfs_rq(cfs_rq);
> > > +
> > > +     if (cfs_rq->nr_running == 1)
> > >               check_enqueue_throttle(cfs_rq);
> > > -     }
> > >  }
> > >
> > >  static void __clear_buddies_last(struct sched_entity *se)
> >
> > I experimented with an rt-app based setup on Arm64 Juno (6 CPUs):
> >
> > cgroupv1 hierarchy A/B/C, all CFS bw controlled (30,000/100,000)
> >
> > I create A/B/C outside rt-app so I can have rt-app runs with an already
> > existing taskgroup hierarchy. There is a 4 secs gap between consecutive
> > rt-app runs.
> >
> > The rt-app files contains 6 periodic CFS tasks (25,000/100,000) running
> > in /A/B/C, /A/B, /A (3 rt-app task phases).
> >
> > I get w/ the patch (and the debug patch applied to unthrottle_cfs_rq()):
> >
> > root@juno:~#
> > [  409.236925] CPU1 path=/A/B on_list=1 nr_running=1 throttled=1
> > [  409.242682] CPU1 path=/A on_list=0 nr_running=0 throttled=1
> > [  409.248260] CPU1 path=/ on_list=1 nr_running=0 throttled=0
> > [  409.253748] ------------[ cut here ]------------
> > [  409.258365] rq->tmp_alone_branch != &rq->leaf_cfs_rq_list
> > [  409.258382] WARNING: CPU: 1 PID: 0 at kernel/sched/fair.c:380
> > unthrottle_cfs_rq+0x21c/0x2a8
> > ...
> > [  409.275196] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.6.0-rc3-dirty #62
> > [  409.281990] Hardware name: ARM Juno development board (r0) (DT)
> > ...
> > [  409.384644] Call trace:
> > [  409.387089]  unthrottle_cfs_rq+0x21c/0x2a8
> > [  409.391188]  distribute_cfs_runtime+0xf4/0x198
> > [  409.395634]  sched_cfs_period_timer+0x134/0x240
> > [  409.400168]  __hrtimer_run_queues+0x10c/0x3c0
> > [  409.404527]  hrtimer_interrupt+0xd4/0x250
> > [  409.408539]  tick_handle_oneshot_broadcast+0x17c/0x208
> > [  409.413683]  sp804_timer_interrupt+0x30/0x40
> >
> > If I add the following snippet the issue goes away:

If it's fine for you, I'm going to add this in a new version of the patch

> >
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index e9fd5379bb7e..5e03be046aba 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -4627,11 +4627,17 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
> >                         break;
> >         }
> >
> > -       assert_list_leaf_cfs_rq(rq);
> > -
> >         if (!se)
> >                 add_nr_running(rq, task_delta);
> >

will add similar comment  as for enqueue_task_fair

+ /*
+ * The cfs_rq_throttled() breaks in the above iteration can result in
+ * incomplete leaf list maintenance, resulting in triggering the assertion
+ * below.
+ */

> > +       for_each_sched_entity(se) {
> > +               cfs_rq = cfs_rq_of(se);
> > +
> > +               list_add_leaf_cfs_rq(cfs_rq);
> > +       }
>
> Yes make sense.
>
> > +
> > +       assert_list_leaf_cfs_rq(rq);
> > +
> >         /* Determine whether we need to wake up potentially idle CPU: */
> >         if (rq->curr == rq->idle && rq->cfs.nr_running)
> >                 resched_curr(rq);
