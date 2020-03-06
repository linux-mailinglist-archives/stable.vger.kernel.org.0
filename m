Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6CB17B909
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 10:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgCFJM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 04:12:28 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42284 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgCFJM2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 04:12:28 -0500
Received: by mail-lf1-f65.google.com with SMTP id t21so1277234lfe.9
        for <stable@vger.kernel.org>; Fri, 06 Mar 2020 01:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w+MBr2XOJp369zIh9acbrg6Jln3yOnAZ/d3wvHcuhIs=;
        b=YJNSEoTAI/WrxhMtNHCO8rRbBJMxUaNuKJH3FqxHYb54Qu23y4xrhOO5bvtEz2FHkz
         6qQC2pFopQNVRsAEZEqVEwqTsqTHlfXjvEeIdECR70lwmZHu2XBBVg+lelBHmWNSwgO5
         Qv6GigDPNjL2qQMnHNyyX1Fxon+lcy1rw+6n9bAAea9WQTSv+QN6ej8nNjnNlmsKbaJa
         jUaxR8W2spVmB7om+WzlgHkFq2umA1ST/y/vZVj219InjwzcI+1u3zMi8mDGU76GoLpC
         IvfcKLwba58Ile+sKcL6s4d28UDZ5qLSlL0IKq/qPzWAu5CWlgx1tRE8y0EH4T8YwOTp
         Lsqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w+MBr2XOJp369zIh9acbrg6Jln3yOnAZ/d3wvHcuhIs=;
        b=awY09s+2SjazowWbgRU2f34bCZUX467Rcah4wF1e2nIc7U651iLgvK/z0LbgHCmq1r
         3nv3rCGAb8YVaY8LRe91IlrshJjFVL6nIkqTFHDMnU48WctZRdkpUrv/odu+zNG+TtIf
         IbCVsrm7kg1sN2iI0PASrqo9hhwO4xuBSweUmo9Q0rVoR8YvtHRys/L/ye5bfnef2V23
         Ui+LFfx9K2Yadva+cb/AePb3G3WEEzGvQWEvz2OeiQ9AdwMvI5d5PcyOVO0xdBV/Lfbw
         1jLeZjKUHERhrAz+lCMRqmxB5vuW/wo0RquD/wqzp6avc0MiIxB7M2rSecc+wYpLRm4S
         HPKg==
X-Gm-Message-State: ANhLgQ2VweUuKfwf1xLgodY5vGhpi8udJAMy0iZ8J9ol2DF75V/vGTij
        lmkuuM1jBWYlDEtJPMpaADC7/NDqin5cNPDmxYSY0A==
X-Google-Smtp-Source: ADFU+vtOu/2gUEQj4Qoa5+/zPNnscM0oTYTHASvT6kmxPQWY3UVInJ9ZFFlTUIr6qgaOa7jxtwEofnlL1X8+S51nLh4=
X-Received: by 2002:ac2:5492:: with SMTP id t18mr1356778lfk.184.1583485945142;
 Fri, 06 Mar 2020 01:12:25 -0800 (PST)
MIME-Version: 1.0
References: <20200305172921.22743-1-vincent.guittot@linaro.org> <e31aa232-bc7e-a7b9-5b6a-a1131ac88164@arm.com>
In-Reply-To: <e31aa232-bc7e-a7b9-5b6a-a1131ac88164@arm.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Fri, 6 Mar 2020 10:12:13 +0100
Message-ID: <CAKfTPtAqg+CGNBHF53dXp4BcmtucgW4k4skQ1x1jxuyo0PDaMg@mail.gmail.com>
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

On Thu, 5 Mar 2020 at 20:07, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
>
> On 05/03/2020 18:29, Vincent Guittot wrote:
> > When a cfs rq is throttled, the latter and its child are removed from the
> > leaf list but their nr_running is not changed which includes staying higher
> > than 1. When a task is enqueued in this throttled branch, the cfs rqs must
> > be added back in order to ensure correct ordering in the list but this can
> > only happens if nr_running == 1.
> > When cfs bandwidth is used, we call unconditionnaly list_add_leaf_cfs_rq()
> > when enqueuing an entity to make sure that the complete branch will be
> > added.
> >
> > Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > Cc: stable@vger.kernel.org #v5.1+
> > Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> > ---
> >  kernel/sched/fair.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index fcc968669aea..bdc5bb72ab31 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -4117,6 +4117,7 @@ static inline void check_schedstat_required(void)
> >  #endif
> >  }
> >
> > +static inline bool cfs_bandwidth_used(void);
> >
> >  /*
> >   * MIGRATION
> > @@ -4195,10 +4196,16 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
> >               __enqueue_entity(cfs_rq, se);
> >       se->on_rq = 1;
> >
> > -     if (cfs_rq->nr_running == 1) {
> > +     /*
> > +      * When bandwidth control is enabled, cfs might have been removed because of
> > +      * a parent been throttled but cfs->nr_running > 1. Try to add it
> > +      * unconditionnally.
> > +      */
> > +     if (cfs_rq->nr_running == 1 || cfs_bandwidth_used())
> >               list_add_leaf_cfs_rq(cfs_rq);
> > +
> > +     if (cfs_rq->nr_running == 1)
> >               check_enqueue_throttle(cfs_rq);
> > -     }
> >  }
> >
> >  static void __clear_buddies_last(struct sched_entity *se)
>
> I experimented with an rt-app based setup on Arm64 Juno (6 CPUs):
>
> cgroupv1 hierarchy A/B/C, all CFS bw controlled (30,000/100,000)
>
> I create A/B/C outside rt-app so I can have rt-app runs with an already
> existing taskgroup hierarchy. There is a 4 secs gap between consecutive
> rt-app runs.
>
> The rt-app files contains 6 periodic CFS tasks (25,000/100,000) running
> in /A/B/C, /A/B, /A (3 rt-app task phases).
>
> I get w/ the patch (and the debug patch applied to unthrottle_cfs_rq()):
>
> root@juno:~#
> [  409.236925] CPU1 path=/A/B on_list=1 nr_running=1 throttled=1
> [  409.242682] CPU1 path=/A on_list=0 nr_running=0 throttled=1
> [  409.248260] CPU1 path=/ on_list=1 nr_running=0 throttled=0
> [  409.253748] ------------[ cut here ]------------
> [  409.258365] rq->tmp_alone_branch != &rq->leaf_cfs_rq_list
> [  409.258382] WARNING: CPU: 1 PID: 0 at kernel/sched/fair.c:380
> unthrottle_cfs_rq+0x21c/0x2a8
> ...
> [  409.275196] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.6.0-rc3-dirty #62
> [  409.281990] Hardware name: ARM Juno development board (r0) (DT)
> ...
> [  409.384644] Call trace:
> [  409.387089]  unthrottle_cfs_rq+0x21c/0x2a8
> [  409.391188]  distribute_cfs_runtime+0xf4/0x198
> [  409.395634]  sched_cfs_period_timer+0x134/0x240
> [  409.400168]  __hrtimer_run_queues+0x10c/0x3c0
> [  409.404527]  hrtimer_interrupt+0xd4/0x250
> [  409.408539]  tick_handle_oneshot_broadcast+0x17c/0x208
> [  409.413683]  sp804_timer_interrupt+0x30/0x40
>
> If I add the following snippet the issue goes away:
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index e9fd5379bb7e..5e03be046aba 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4627,11 +4627,17 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
>                         break;
>         }
>
> -       assert_list_leaf_cfs_rq(rq);
> -
>         if (!se)
>                 add_nr_running(rq, task_delta);
>
> +       for_each_sched_entity(se) {
> +               cfs_rq = cfs_rq_of(se);
> +
> +               list_add_leaf_cfs_rq(cfs_rq);
> +       }

Yes make sense.

> +
> +       assert_list_leaf_cfs_rq(rq);
> +
>         /* Determine whether we need to wake up potentially idle CPU: */
>         if (rq->curr == rq->idle && rq->cfs.nr_running)
>                 resched_curr(rq);
