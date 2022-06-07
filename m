Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190235408AE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242695AbiFGSDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351048AbiFGSBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:01:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC8514E95C;
        Tue,  7 Jun 2022 10:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF600B80B66;
        Tue,  7 Jun 2022 17:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEC8C385A5;
        Tue,  7 Jun 2022 17:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623829;
        bh=1ilTt5GHefp7stKEvj8SnueLaHcFUsjXKe4JL/6AACM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UK+OVgn8aTv6pYHzytCOFiXSLyyd2hPxl/lBXRG/rINOFh4cAXo04ncbF7u8+90Lo
         XxeSosEGRTB6oXdxWDkX3AFRWFQdZ2rr2RDKy5ub3H/UBSrrsC9mFW3OwxNkDAziIL
         itdobKxqFb3lPr/sJx6N6/RDwTXExUitbpdwU2GY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Jia <jiahao.os@bytedance.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/667] sched/core: Avoid obvious double update_rq_clock warning
Date:   Tue,  7 Jun 2022 18:56:12 +0200
Message-Id: <20220607164938.032461830@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Jia <jiahao.os@bytedance.com>

[ Upstream commit 2679a83731d51a744657f718fc02c3b077e47562 ]

When we use raw_spin_rq_lock() to acquire the rq lock and have to
update the rq clock while holding the lock, the kernel may issue
a WARN_DOUBLE_CLOCK warning.

Since we directly use raw_spin_rq_lock() to acquire rq lock instead of
rq_lock(), there is no corresponding change to rq->clock_update_flags.
In particular, we have obtained the rq lock of other CPUs, the
rq->clock_update_flags of this CPU may be RQCF_UPDATED at this time, and
then calling update_rq_clock() will trigger the WARN_DOUBLE_CLOCK warning.

So we need to clear RQCF_UPDATED of rq->clock_update_flags to avoid
the WARN_DOUBLE_CLOCK warning.

For the sched_rt_period_timer() and migrate_task_rq_dl() cases
we simply replace raw_spin_rq_lock()/raw_spin_rq_unlock() with
rq_lock()/rq_unlock().

For the {pull,push}_{rt,dl}_task() cases, we add the
double_rq_clock_clear_update() function to clear RQCF_UPDATED of
rq->clock_update_flags, and call double_rq_clock_clear_update()
before double_lock_balance()/double_rq_lock() returns to avoid the
WARN_DOUBLE_CLOCK warning.

Some call trace reports:
Call Trace 1:
 <IRQ>
 sched_rt_period_timer+0x10f/0x3a0
 ? enqueue_top_rt_rq+0x110/0x110
 __hrtimer_run_queues+0x1a9/0x490
 hrtimer_interrupt+0x10b/0x240
 __sysvec_apic_timer_interrupt+0x8a/0x250
 sysvec_apic_timer_interrupt+0x9a/0xd0
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20

Call Trace 2:
 <TASK>
 activate_task+0x8b/0x110
 push_rt_task.part.108+0x241/0x2c0
 push_rt_tasks+0x15/0x30
 finish_task_switch+0xaa/0x2e0
 ? __switch_to+0x134/0x420
 __schedule+0x343/0x8e0
 ? hrtimer_start_range_ns+0x101/0x340
 schedule+0x4e/0xb0
 do_nanosleep+0x8e/0x160
 hrtimer_nanosleep+0x89/0x120
 ? hrtimer_init_sleeper+0x90/0x90
 __x64_sys_nanosleep+0x96/0xd0
 do_syscall_64+0x34/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Call Trace 3:
 <TASK>
 deactivate_task+0x93/0xe0
 pull_rt_task+0x33e/0x400
 balance_rt+0x7e/0x90
 __schedule+0x62f/0x8e0
 do_task_dead+0x3f/0x50
 do_exit+0x7b8/0xbb0
 do_group_exit+0x2d/0x90
 get_signal+0x9df/0x9e0
 ? preempt_count_add+0x56/0xa0
 ? __remove_hrtimer+0x35/0x70
 arch_do_signal_or_restart+0x36/0x720
 ? nanosleep_copyout+0x39/0x50
 ? do_nanosleep+0x131/0x160
 ? audit_filter_inodes+0xf5/0x120
 exit_to_user_mode_prepare+0x10f/0x1e0
 syscall_exit_to_user_mode+0x17/0x30
 do_syscall_64+0x40/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Call Trace 4:
 update_rq_clock+0x128/0x1a0
 migrate_task_rq_dl+0xec/0x310
 set_task_cpu+0x84/0x1e4
 try_to_wake_up+0x1d8/0x5c0
 wake_up_process+0x1c/0x30
 hrtimer_wakeup+0x24/0x3c
 __hrtimer_run_queues+0x114/0x270
 hrtimer_interrupt+0xe8/0x244
 arch_timer_handler_phys+0x30/0x50
 handle_percpu_devid_irq+0x88/0x140
 generic_handle_domain_irq+0x40/0x60
 gic_handle_irq+0x48/0xe0
 call_on_irq_stack+0x2c/0x60
 do_interrupt_handler+0x80/0x84

Steps to reproduce:
1. Enable CONFIG_SCHED_DEBUG when compiling the kernel
2. echo 1 > /sys/kernel/debug/clear_warn_once
   echo "WARN_DOUBLE_CLOCK" > /sys/kernel/debug/sched/features
   echo "NO_RT_PUSH_IPI" > /sys/kernel/debug/sched/features
3. Run some rt/dl tasks that periodically work and sleep, e.g.
Create 2*n rt or dl (90% running) tasks via rt-app (on a system
with n CPUs), and Dietmar Eggemann reports Call Trace 4 when running
on PREEMPT_RT kernel.

Signed-off-by: Hao Jia <jiahao.os@bytedance.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lore.kernel.org/r/20220430085843.62939-2-jiahao.os@bytedance.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c     |  6 +++---
 kernel/sched/deadline.c |  5 +++--
 kernel/sched/rt.c       |  5 +++--
 kernel/sched/sched.h    | 28 ++++++++++++++++++++++++----
 4 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 779f3198b17d..838623b68031 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -531,10 +531,10 @@ void double_rq_lock(struct rq *rq1, struct rq *rq2)
 		swap(rq1, rq2);
 
 	raw_spin_rq_lock(rq1);
-	if (__rq_lockp(rq1) == __rq_lockp(rq2))
-		return;
+	if (__rq_lockp(rq1) != __rq_lockp(rq2))
+		raw_spin_rq_lock_nested(rq2, SINGLE_DEPTH_NESTING);
 
-	raw_spin_rq_lock_nested(rq2, SINGLE_DEPTH_NESTING);
+	double_rq_clock_clear_update(rq1, rq2);
 }
 #endif
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 1f811b375bf0..fffcb1aa77b7 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1720,6 +1720,7 @@ select_task_rq_dl(struct task_struct *p, int cpu, int flags)
 
 static void migrate_task_rq_dl(struct task_struct *p, int new_cpu __maybe_unused)
 {
+	struct rq_flags rf;
 	struct rq *rq;
 
 	if (READ_ONCE(p->__state) != TASK_WAKING)
@@ -1731,7 +1732,7 @@ static void migrate_task_rq_dl(struct task_struct *p, int new_cpu __maybe_unused
 	 * from try_to_wake_up(). Hence, p->pi_lock is locked, but
 	 * rq->lock is not... So, lock it
 	 */
-	raw_spin_rq_lock(rq);
+	rq_lock(rq, &rf);
 	if (p->dl.dl_non_contending) {
 		update_rq_clock(rq);
 		sub_running_bw(&p->dl, &rq->dl);
@@ -1747,7 +1748,7 @@ static void migrate_task_rq_dl(struct task_struct *p, int new_cpu __maybe_unused
 			put_task_struct(p);
 	}
 	sub_rq_bw(&p->dl, &rq->dl);
-	raw_spin_rq_unlock(rq);
+	rq_unlock(rq, &rf);
 }
 
 static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 2758cf5f7987..8007d087a57f 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -885,6 +885,7 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 		int enqueue = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
 		struct rq *rq = rq_of_rt_rq(rt_rq);
+		struct rq_flags rf;
 		int skip;
 
 		/*
@@ -899,7 +900,7 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 		if (skip)
 			continue;
 
-		raw_spin_rq_lock(rq);
+		rq_lock(rq, &rf);
 		update_rq_clock(rq);
 
 		if (rt_rq->rt_time) {
@@ -937,7 +938,7 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 
 		if (enqueue)
 			sched_rt_rq_enqueue(rt_rq);
-		raw_spin_rq_unlock(rq);
+		rq_unlock(rq, &rf);
 	}
 
 	if (!throttled && (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF))
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4f432826933d..d30dc55e6cee 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2489,6 +2489,24 @@ unsigned long arch_scale_freq_capacity(int cpu)
 }
 #endif
 
+#ifdef CONFIG_SCHED_DEBUG
+/*
+ * In double_lock_balance()/double_rq_lock(), we use raw_spin_rq_lock() to
+ * acquire rq lock instead of rq_lock(). So at the end of these two functions
+ * we need to call double_rq_clock_clear_update() to clear RQCF_UPDATED of
+ * rq->clock_update_flags to avoid the WARN_DOUBLE_CLOCK warning.
+ */
+static inline void double_rq_clock_clear_update(struct rq *rq1, struct rq *rq2)
+{
+	rq1->clock_update_flags &= (RQCF_REQ_SKIP|RQCF_ACT_SKIP);
+	/* rq1 == rq2 for !CONFIG_SMP, so just clear RQCF_UPDATED once. */
+#ifdef CONFIG_SMP
+	rq2->clock_update_flags &= (RQCF_REQ_SKIP|RQCF_ACT_SKIP);
+#endif
+}
+#else
+static inline void double_rq_clock_clear_update(struct rq *rq1, struct rq *rq2) {}
+#endif
 
 #ifdef CONFIG_SMP
 
@@ -2554,14 +2572,15 @@ static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
 	__acquires(busiest->lock)
 	__acquires(this_rq->lock)
 {
-	if (__rq_lockp(this_rq) == __rq_lockp(busiest))
-		return 0;
-
-	if (likely(raw_spin_rq_trylock(busiest)))
+	if (__rq_lockp(this_rq) == __rq_lockp(busiest) ||
+	    likely(raw_spin_rq_trylock(busiest))) {
+		double_rq_clock_clear_update(this_rq, busiest);
 		return 0;
+	}
 
 	if (rq_order_less(this_rq, busiest)) {
 		raw_spin_rq_lock_nested(busiest, SINGLE_DEPTH_NESTING);
+		double_rq_clock_clear_update(this_rq, busiest);
 		return 0;
 	}
 
@@ -2655,6 +2674,7 @@ static inline void double_rq_lock(struct rq *rq1, struct rq *rq2)
 	BUG_ON(rq1 != rq2);
 	raw_spin_rq_lock(rq1);
 	__acquire(rq2->lock);	/* Fake it out ;) */
+	double_rq_clock_clear_update(rq1, rq2);
 }
 
 /*
-- 
2.35.1



