Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583205930E7
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 16:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbiHOOl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 10:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbiHOOl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 10:41:57 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A091573C;
        Mon, 15 Aug 2022 07:41:55 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id B776537515;
        Mon, 15 Aug 2022 14:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1660574513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UfV7UrK+irne6GAgk+wBFpB/DtHiJX9EFsLGUAqb2oc=;
        b=EhnMpH5BKOHqbs8xeGCnOVw6+0G5OZe6Rpr/ISxuKHe1aC4L+Cuo8/AmPJBLlCB+gTo4t/
        9I2Pmg67OxeHq8NM939vc6VCUizI76SkVeYA3xQM7cXRPPkvS/pI+3x8wzfoEyUD+oWN2K
        8j2xxcpxiph5iXhtzwsFVEkQWGZiV5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1660574513;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UfV7UrK+irne6GAgk+wBFpB/DtHiJX9EFsLGUAqb2oc=;
        b=mDogXZxBHBrBcAEs5GLQP00EbvzxXZDg3S8XmtsksFVNs1rShDdZsCGASwooYRz3qtgJ1E
        3oI+E49ly/rwTVAA==
Received: from suse.de (unknown [10.163.43.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 2476F2C1C6;
        Mon, 15 Aug 2022 14:41:51 +0000 (UTC)
Date:   Mon, 15 Aug 2022 15:41:43 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] sched/all: Change all BUG_ON() instances in the
 scheduler to WARN_ON_ONCE()
Message-ID: <20220815144143.zjsiamw5y22bvgki@suse.de>
References: <20220808073232.8808-1-david@redhat.com>
 <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
 <1a48d71d-41ee-bf39-80d2-0102f4fe9ccb@redhat.com>
 <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
 <YvSsKcAXISmshtHo@gmail.com>
 <CAHk-=wgqW6zQcAW4i-ARJ8KNZZjw6tP3nn0QimyTWO=j+ZKsLA@mail.gmail.com>
 <YvYdbn2GtTlCaand@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <YvYdbn2GtTlCaand@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 12, 2022 at 11:29:18AM +0200, Ingo Molnar wrote:
> From: Ingo Molnar <mingo@kernel.org>
> Date: Thu, 11 Aug 2022 08:54:52 +0200
> Subject: [PATCH] sched/all: Change all BUG_ON() instances in the scheduler to WARN_ON_ONCE()
> 
> There's no good reason to crash a user's system with a BUG_ON(),
> chances are high that they'll never even see the crash message on
> Xorg, and it won't make it into the syslog either.
> 
> By using a WARN_ON_ONCE() we at least give the user a chance to report
> any bugs triggered here - instead of getting silent hangs.
> 
> None of these WARN_ON_ONCE()s are supposed to trigger, ever - so we ignore
> cases where a NULL check is done via a BUG_ON() and we let a NULL
> pointer through after a WARN_ON_ONCE().
> 
> There's one exception: WARN_ON_ONCE() arguments with side-effects,
> such as locking - in this case we use the return value of the
> WARN_ON_ONCE(), such as in:
> 
>  -       BUG_ON(!lock_task_sighand(p, &flags));
>  +       if (WARN_ON_ONCE(!lock_task_sighand(p, &flags)))
>  +               return;
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Link: https://lore.kernel.org/r/YvSsKcAXISmshtHo@gmail.com
> ---
>  kernel/sched/autogroup.c |  3 ++-
>  kernel/sched/core.c      |  2 +-
>  kernel/sched/cpupri.c    |  2 +-
>  kernel/sched/deadline.c  | 26 +++++++++++++-------------
>  kernel/sched/fair.c      | 10 +++++-----
>  kernel/sched/rt.c        |  2 +-
>  kernel/sched/sched.h     |  6 +++---
>  7 files changed, 26 insertions(+), 25 deletions(-)
> 
> diff --git a/kernel/sched/cpupri.c b/kernel/sched/cpupri.c
> index fa9ce9d83683..a286e726eb4b 100644
> --- a/kernel/sched/cpupri.c
> +++ b/kernel/sched/cpupri.c
> @@ -147,7 +147,7 @@ int cpupri_find_fitness(struct cpupri *cp, struct task_struct *p,
>  	int task_pri = convert_prio(p->prio);
>  	int idx, cpu;
>  
> -	BUG_ON(task_pri >= CPUPRI_NR_PRIORITIES);
> +	WARN_ON_ONCE(task_pri >= CPUPRI_NR_PRIORITIES);
>  
>  	for (idx = 0; idx < task_pri; idx++) {
>  

Should the return value be used here to clamp task_pri to
CPUPRI_NR_PRIORITIES? task_pri is used for index which in __cpupri_find
then accesses beyond the end of an array and the future behaviour will be
very unpredictable.

> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 0ab79d819a0d..962b169b05cf 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -2017,7 +2017,7 @@ static struct task_struct *pick_task_dl(struct rq *rq)
>  		return NULL;
>  
>  	dl_se = pick_next_dl_entity(dl_rq);
> -	BUG_ON(!dl_se);
> +	WARN_ON_ONCE(!dl_se);
>  	p = dl_task_of(dl_se);
>  
>  	return p;

It's a somewhat redundant check, it'll NULL pointer dereference shortly
afterwards but it'll be a bit more obvious.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 914096c5b1ae..28f10dccd194 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2600,7 +2600,7 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
>  	if (!join)
>  		return;
>  
> -	BUG_ON(irqs_disabled());
> +	WARN_ON_ONCE(irqs_disabled());
>  	double_lock_irq(&my_grp->lock, &grp->lock);
>  
>  	for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++) {

Recoverable with a goto no_join. It'll be a terrible recovery because
there is no way IRQs should be disabled here. Something else incredibly
bad happened before this would fire.

> @@ -7279,7 +7279,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
>  		return;
>  
>  	find_matching_se(&se, &pse);
> -	BUG_ON(!pse);
> +	WARN_ON_ONCE(!pse);
>  
>  	cse_is_idle = se_is_idle(se);
>  	pse_is_idle = se_is_idle(pse);

Similar to pick_task_dl.

> @@ -10134,7 +10134,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>  		goto out_balanced;
>  	}
>  
> -	BUG_ON(busiest == env.dst_rq);
> +	WARN_ON_ONCE(busiest == env.dst_rq);
>  
>  	schedstat_add(sd->lb_imbalance[idle], env.imbalance);
>  

goto out if it triggers? It'll just continue to be unbalanced.

> @@ -10430,7 +10430,7 @@ static int active_load_balance_cpu_stop(void *data)
>  	 * we need to fix it. Originally reported by
>  	 * Bjorn Helgaas on a 128-CPU setup.
>  	 */
> -	BUG_ON(busiest_rq == target_rq);
> +	WARN_ON_ONCE(busiest_rq == target_rq);
>  
>  	/* Search for an sd spanning us and the target CPU. */
>  	rcu_read_lock();

goto out_unlock if it fires?

For the rest, I didn't see obvious recovery paths that would allow the
system to run predictably. Any of them firing will have unpredictable
consequences (e.g. move_queued_task firing would be fun if it was a per-cpu
kthread). Depending on which warning triggers, the remaining life of the
system may be very short but maybe long enough to be logged even if system
locks up shortly afterwards.

-- 
Mel Gorman
SUSE Labs
