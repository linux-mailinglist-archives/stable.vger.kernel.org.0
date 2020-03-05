Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B88F17AEBC
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 20:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgCETHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 14:07:14 -0500
Received: from foss.arm.com ([217.140.110.172]:52704 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgCETHN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 14:07:13 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AF7030E;
        Thu,  5 Mar 2020 11:07:13 -0800 (PST)
Received: from [192.168.0.7] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E3B13F6CF;
        Thu,  5 Mar 2020 11:07:11 -0800 (PST)
Subject: Re: [PATCH] sched/fair: fix enqueue_task_fair warning
To:     Vincent Guittot <vincent.guittot@linaro.org>, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com, rostedt@goodmis.org,
        bsegall@google.com, mgorman@suse.de, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com
Cc:     stable@vger.kernel.org
References: <20200305172921.22743-1-vincent.guittot@linaro.org>
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
Message-ID: <e31aa232-bc7e-a7b9-5b6a-a1131ac88164@arm.com>
Date:   Thu, 5 Mar 2020 20:07:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200305172921.22743-1-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/03/2020 18:29, Vincent Guittot wrote:
> When a cfs rq is throttled, the latter and its child are removed from the
> leaf list but their nr_running is not changed which includes staying higher
> than 1. When a task is enqueued in this throttled branch, the cfs rqs must
> be added back in order to ensure correct ordering in the list but this can
> only happens if nr_running == 1.
> When cfs bandwidth is used, we call unconditionnaly list_add_leaf_cfs_rq()
> when enqueuing an entity to make sure that the complete branch will be
> added.
> 
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: stable@vger.kernel.org #v5.1+
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index fcc968669aea..bdc5bb72ab31 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4117,6 +4117,7 @@ static inline void check_schedstat_required(void)
>  #endif
>  }
>  
> +static inline bool cfs_bandwidth_used(void);
>  
>  /*
>   * MIGRATION
> @@ -4195,10 +4196,16 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>  		__enqueue_entity(cfs_rq, se);
>  	se->on_rq = 1;
>  
> -	if (cfs_rq->nr_running == 1) {
> +	/*
> +	 * When bandwidth control is enabled, cfs might have been removed because of
> +	 * a parent been throttled but cfs->nr_running > 1. Try to add it
> +	 * unconditionnally.
> +	 */
> +	if (cfs_rq->nr_running == 1 || cfs_bandwidth_used())
>  		list_add_leaf_cfs_rq(cfs_rq);
> +
> +	if (cfs_rq->nr_running == 1)
>  		check_enqueue_throttle(cfs_rq);
> -	}
>  }
>  
>  static void __clear_buddies_last(struct sched_entity *se)

I experimented with an rt-app based setup on Arm64 Juno (6 CPUs):

cgroupv1 hierarchy A/B/C, all CFS bw controlled (30,000/100,000)

I create A/B/C outside rt-app so I can have rt-app runs with an already
existing taskgroup hierarchy. There is a 4 secs gap between consecutive
rt-app runs.

The rt-app files contains 6 periodic CFS tasks (25,000/100,000) running
in /A/B/C, /A/B, /A (3 rt-app task phases).

I get w/ the patch (and the debug patch applied to unthrottle_cfs_rq()):

root@juno:~#
[  409.236925] CPU1 path=/A/B on_list=1 nr_running=1 throttled=1
[  409.242682] CPU1 path=/A on_list=0 nr_running=0 throttled=1
[  409.248260] CPU1 path=/ on_list=1 nr_running=0 throttled=0
[  409.253748] ------------[ cut here ]------------
[  409.258365] rq->tmp_alone_branch != &rq->leaf_cfs_rq_list
[  409.258382] WARNING: CPU: 1 PID: 0 at kernel/sched/fair.c:380
unthrottle_cfs_rq+0x21c/0x2a8
...
[  409.275196] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.6.0-rc3-dirty #62
[  409.281990] Hardware name: ARM Juno development board (r0) (DT)
...
[  409.384644] Call trace:
[  409.387089]  unthrottle_cfs_rq+0x21c/0x2a8
[  409.391188]  distribute_cfs_runtime+0xf4/0x198
[  409.395634]  sched_cfs_period_timer+0x134/0x240
[  409.400168]  __hrtimer_run_queues+0x10c/0x3c0
[  409.404527]  hrtimer_interrupt+0xd4/0x250
[  409.408539]  tick_handle_oneshot_broadcast+0x17c/0x208
[  409.413683]  sp804_timer_interrupt+0x30/0x40

If I add the following snippet the issue goes away:

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e9fd5379bb7e..5e03be046aba 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4627,11 +4627,17 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 			break;
 	}

-	assert_list_leaf_cfs_rq(rq);
-
 	if (!se)
 		add_nr_running(rq, task_delta);

+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+
+		list_add_leaf_cfs_rq(cfs_rq);
+	}
+
+	assert_list_leaf_cfs_rq(rq);
+
 	/* Determine whether we need to wake up potentially idle CPU: */
 	if (rq->curr == rq->idle && rq->cfs.nr_running)
 		resched_curr(rq);
