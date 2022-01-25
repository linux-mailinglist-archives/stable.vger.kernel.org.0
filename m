Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674C849B007
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 10:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244442AbiAYJZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 04:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573005AbiAYJSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 04:18:36 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B682C06176A
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 01:14:54 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id e9so3581915ljq.1
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 01:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qrgiZGQ6iDovOpvrU32QRk7eljkxoPWyGy5MexT9X4I=;
        b=Yz2JeNHhq5XcFshwTR7g5n40VgZtU4lRAtDEj/GojdZK5RxjDf23wQ/pzu5acf+Dy8
         2Ugx0biQWhmmP2vWA7xGO7oOFi+maeNvwfeVrjg6zFJhNpWMw5y46Pbrvs8pcI7UPkcO
         mmuYSf03AAL49jlQiQXGb7HK2595dtPejQBGbHBaVmpuN+2sXyWTC3EdB2UMZlOIKtNi
         aNz9lN7EEAVxXmBlCi4zbmNEJPG+weJ+ejVUm3QStQzw+lzV3u+badZWBTwf+qEtIuxl
         IxB2VpHQMu/pMR/3KXXRX0UjZ8qsInINtLA4+1c8J0nvMvn02/1Nt5VVEUCBzwuORlDH
         /PrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qrgiZGQ6iDovOpvrU32QRk7eljkxoPWyGy5MexT9X4I=;
        b=ByjFRxqaCVNxovXKe9lrsqiP7NsNfR5bsL1VH6r47n6SwSPJnQbhxxyCacnQa1iyG+
         s3+hvgC5eVnjMyWEPDJLL91hSItw189U7xPXwaeGOWS27vaGfkSm7c6922y0ZM8ekCIP
         8baU1T2R5pX004YW90cdv1BEK+NEZ/WGRQV6mzlxzJK1UlaPjPwR4feyvv+Jkq/edUir
         vlBs8AywEmjKpq0o6GPOz7+x2HvJ1PCHKTi0sKHJEA58OLbFsSwx+2ty2HAkALcmVIis
         hvLl7Sc6t15nECdFnxI1VABuZpMh9tcoGJ8KMyEW/oueP4k0WlE/+rALACssycDNZa1v
         xUDg==
X-Gm-Message-State: AOAM533ZXj/A65tnUPjRDEVcmkHzya/rlZViMufhu7DvdEB6BofkDdQi
        tjmBMSsQE83MI/mFx/bbuYhsYUNNPrMcSe1IO11g5g==
X-Google-Smtp-Source: ABdhPJzeq/FzwGiCeBTJHEg6r95G1ZdhTdmrdSjD6Yutu6gLbJJWNcXh4b7oAOFsB95LEsMJlk6By0jWGzJ/zBOV8kg=
X-Received: by 2002:a2e:6a13:: with SMTP id f19mr8258334ljc.365.1643102092835;
 Tue, 25 Jan 2022 01:14:52 -0800 (PST)
MIME-Version: 1.0
References: <20220120200139.118978-1-tadeusz.struk@linaro.org> <20220125011804.mhlhdenbjluzqkgf@oracle.com>
In-Reply-To: <20220125011804.mhlhdenbjluzqkgf@oracle.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Tue, 25 Jan 2022 10:14:41 +0100
Message-ID: <CAKfTPtB7UvUG3C_xiHL-V6eDfDOAkpzFWa0_QQeeRAQG7PovXQ@mail.gmail.com>
Subject: Re: [PATCH v2] sched/fair: Fix fault in reweight_entity
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>, peterz@infradead.org,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Zhang Qiao <zhangqiao22@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 at 02:18, Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
>
> Hi,
>
> On Thu, Jan 20, 2022 at 12:01:39PM -0800, Tadeusz Struk wrote:
> > Syzbot found a GPF in reweight_entity(). This has been bisected to commit
> > 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")
> >
> > There is a race between sched_post_fork() and setpriority(PRIO_PGRP)
> > within a thread group that causes a null-ptr-deref in reweight_entity()
> > in CFS. The scenario is that the main process spawns number of new
> > threads, which then call setpriority(PRIO_PGRP, 0, prio), wait, and exit.
> > For each of the new threads the copy_process() gets invoked, which adds
> > the new task_struct to the group, and eventually calls sched_post_fork() for it.
> >
> > In the above scenario there is a possibility that setpriority(PRIO_PGRP)
> > and set_one_prio() will be called for a thread in the group that is just
> > being created by copy_process(), and for which the sched_post_fork() has
> > not been executed yet. This will trigger a null pointer dereference in
> > reweight_entity(), as it will try to access the run queue pointer, which
> > hasn't been set.
>
> It's kinda strange that p->se.cfs_rq is NULLed in __sched_fork().
> AFAICT, that lets set_task_rq_fair() distinguish between fork and other
> paths per ad936d8658fd, but it's causing this problem now and it's not
> the only way that set_task_rq_fair() could tell the difference.
>
> We might be able to get rid of the NULL assignment instead of adding
> code to detect it.  Maybe something like this, against today's mainline?
> set_task_rq_fair() would rely on TASK_NEW instead of NULL.
>
> Haven't thought it all the way through, so could be missing something.
> Will think more

Could we use :
set_load_weight(p, !(p->__state & TASK_NEW));
instead of
set_load_weight(p, true);
in set_user_nice and __setscheduler_params.

The current always true value forces the update of the weight of the
cfs_rq of the task which is not already set in this case

>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 848eaa0efe0ea..9a5b264c5dc10 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4241,10 +4241,6 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
>         p->se.vruntime                  = 0;
>         INIT_LIST_HEAD(&p->se.group_node);
>
> -#ifdef CONFIG_FAIR_GROUP_SCHED
> -       p->se.cfs_rq                    = NULL;
> -#endif
> -
>  #ifdef CONFIG_SCHEDSTATS
>         /* Even if schedstat is disabled, there should not be garbage */
>         memset(&p->stats, 0, sizeof(p->stats));
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 5146163bfabb9..7aff3b603220d 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3339,15 +3339,19 @@ static inline void update_tg_load_avg(struct cfs_rq *cfs_rq)
>   * caller only guarantees p->pi_lock is held; no other assumptions,
>   * including the state of rq->lock, should be made.
>   */
> -void set_task_rq_fair(struct sched_entity *se,
> -                     struct cfs_rq *prev, struct cfs_rq *next)
> +void set_task_rq_fair(struct task_struct *p, struct cfs_rq *next)
>  {
> +       struct sched_entity *se = &p->se;
> +       struct cfs_rq *prev = se->cfs_rq;
>         u64 p_last_update_time;
>         u64 n_last_update_time;
>
>         if (!sched_feat(ATTACH_AGE_LOAD))
>                 return;
>
> +       if (p->__state == TASK_NEW)
> +               return;
> +
>         /*
>          * We are supposed to update the task to "current" time, then its up to
>          * date and ready to go to new CPU/cfs_rq. But we have difficulty in
> @@ -3355,7 +3359,7 @@ void set_task_rq_fair(struct sched_entity *se,
>          * time. This will result in the wakee task is less decayed, but giving
>          * the wakee more load sounds not bad.
>          */
> -       if (!(se->avg.last_update_time && prev))
> +       if (!se->avg.last_update_time)
>                 return;
>
>  #ifndef CONFIG_64BIT
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index de53be9057390..a6f749f136ee1 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -514,11 +514,10 @@ extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
>  extern int sched_group_set_idle(struct task_group *tg, long idle);
>
>  #ifdef CONFIG_SMP
> -extern void set_task_rq_fair(struct sched_entity *se,
> -                            struct cfs_rq *prev, struct cfs_rq *next);
> +extern void set_task_rq_fair(struct task_struct *p, struct cfs_rq *next);
>  #else /* !CONFIG_SMP */
> -static inline void set_task_rq_fair(struct sched_entity *se,
> -                            struct cfs_rq *prev, struct cfs_rq *next) { }
> +static inline void set_task_rq_fair(struct task_struct *p,
> +                                   struct cfs_rq *next) {}
>  #endif /* CONFIG_SMP */
>  #endif /* CONFIG_FAIR_GROUP_SCHED */
>
> @@ -1910,7 +1909,7 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
>  #endif
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> -       set_task_rq_fair(&p->se, p->se.cfs_rq, tg->cfs_rq[cpu]);
> +       set_task_rq_fair(p, tg->cfs_rq[cpu]);
>         p->se.cfs_rq = tg->cfs_rq[cpu];
>         p->se.parent = tg->se[cpu];
>  #endif
