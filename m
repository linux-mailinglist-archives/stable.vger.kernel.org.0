Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35AA24B2FC
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgHTJkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:40:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728528AbgHTJjy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:39:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1068120724;
        Thu, 20 Aug 2020 09:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916393;
        bh=Gg3oWIb0/zP90iPrxCGJb9xOYntD8LGYauQMYinlA4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xTyjkyCPzsejjALckBdBPCqNQ79pSoN0SNsQ52v2xNiruY/IfsiR81hl8PjDoQqnk
         0ZCfSYuWHNiEE+j1PmZYDEaEYc1taRU/VJQ6VOJofKr9gCjzbt2Lf02MK/tyeV3b4F
         C0eBKOZgDs4OOoQDG7S/1miJbIUWxez0AcoDR9TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 112/204] sched/uclamp: Protect uclamp fast path code with static key
Date:   Thu, 20 Aug 2020 11:20:09 +0200
Message-Id: <20200820091611.909886972@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

[ Upstream commit 46609ce227039fd192e0ecc7d940bed587fd2c78 ]

There is a report that when uclamp is enabled, a netperf UDP test
regresses compared to a kernel compiled without uclamp.

https://lore.kernel.org/lkml/20200529100806.GA3070@suse.de/

While investigating the root cause, there were no sign that the uclamp
code is doing anything particularly expensive but could suffer from bad
cache behavior under certain circumstances that are yet to be
understood.

https://lore.kernel.org/lkml/20200616110824.dgkkbyapn3io6wik@e107158-lin/

To reduce the pressure on the fast path anyway, add a static key that is
by default will skip executing uclamp logic in the
enqueue/dequeue_task() fast path until it's needed.

As soon as the user start using util clamp by:

	1. Changing uclamp value of a task with sched_setattr()
	2. Modifying the default sysctl_sched_util_clamp_{min, max}
	3. Modifying the default cpu.uclamp.{min, max} value in cgroup

We flip the static key now that the user has opted to use util clamp.
Effectively re-introducing uclamp logic in the enqueue/dequeue_task()
fast path. It stays on from that point forward until the next reboot.

This should help minimize the effect of util clamp on workloads that
don't need it but still allow distros to ship their kernels with uclamp
compiled in by default.

SCHED_WARN_ON() in uclamp_rq_dec_id() was removed since now we can end
up with unbalanced call to uclamp_rq_dec_id() if we flip the key while
a task is running in the rq. Since we know it is harmless we just
quietly return if we attempt a uclamp_rq_dec_id() when
rq->uclamp[].bucket[].tasks is 0.

In schedutil, we introduce a new uclamp_is_enabled() helper which takes
the static key into account to ensure RT boosting behavior is retained.

The following results demonstrates how this helps on 2 Sockets Xeon E5
2x10-Cores system.

                                   nouclamp                 uclamp      uclamp-static-key
Hmean     send-64         162.43 (   0.00%)      157.84 *  -2.82%*      163.39 *   0.59%*
Hmean     send-128        324.71 (   0.00%)      314.78 *  -3.06%*      326.18 *   0.45%*
Hmean     send-256        641.55 (   0.00%)      628.67 *  -2.01%*      648.12 *   1.02%*
Hmean     send-1024      2525.28 (   0.00%)     2448.26 *  -3.05%*     2543.73 *   0.73%*
Hmean     send-2048      4836.14 (   0.00%)     4712.08 *  -2.57%*     4867.69 *   0.65%*
Hmean     send-3312      7540.83 (   0.00%)     7425.45 *  -1.53%*     7621.06 *   1.06%*
Hmean     send-4096      9124.53 (   0.00%)     8948.82 *  -1.93%*     9276.25 *   1.66%*
Hmean     send-8192     15589.67 (   0.00%)    15486.35 *  -0.66%*    15819.98 *   1.48%*
Hmean     send-16384    26386.47 (   0.00%)    25752.25 *  -2.40%*    26773.74 *   1.47%*

The perf diff between nouclamp and uclamp-static-key when uclamp is
disabled in the fast path:

     8.73%     -1.55%  [kernel.kallsyms]        [k] try_to_wake_up
     0.07%     +0.04%  [kernel.kallsyms]        [k] deactivate_task
     0.13%     -0.02%  [kernel.kallsyms]        [k] activate_task

The diff between nouclamp and uclamp-static-key when uclamp is enabled
in the fast path:

     8.73%     -0.72%  [kernel.kallsyms]        [k] try_to_wake_up
     0.13%     +0.39%  [kernel.kallsyms]        [k] activate_task
     0.07%     +0.38%  [kernel.kallsyms]        [k] deactivate_task

Fixes: 69842cba9ace ("sched/uclamp: Add CPU's clamp buckets refcounting")
Reported-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://lkml.kernel.org/r/20200630112123.12076-3-qais.yousef@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c              | 74 +++++++++++++++++++++++++++++++-
 kernel/sched/cpufreq_schedutil.c |  2 +-
 kernel/sched/sched.h             | 47 +++++++++++++++++++-
 3 files changed, 119 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1bae86fc128b2..49b5c5cf9271d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -793,6 +793,26 @@ unsigned int sysctl_sched_uclamp_util_max = SCHED_CAPACITY_SCALE;
 /* All clamps are required to be less or equal than these values */
 static struct uclamp_se uclamp_default[UCLAMP_CNT];
 
+/*
+ * This static key is used to reduce the uclamp overhead in the fast path. It
+ * primarily disables the call to uclamp_rq_{inc, dec}() in
+ * enqueue/dequeue_task().
+ *
+ * This allows users to continue to enable uclamp in their kernel config with
+ * minimum uclamp overhead in the fast path.
+ *
+ * As soon as userspace modifies any of the uclamp knobs, the static key is
+ * enabled, since we have an actual users that make use of uclamp
+ * functionality.
+ *
+ * The knobs that would enable this static key are:
+ *
+ *   * A task modifying its uclamp value with sched_setattr().
+ *   * An admin modifying the sysctl_sched_uclamp_{min, max} via procfs.
+ *   * An admin modifying the cgroup cpu.uclamp.{min, max}
+ */
+DEFINE_STATIC_KEY_FALSE(sched_uclamp_used);
+
 /* Integer rounded range for each bucket */
 #define UCLAMP_BUCKET_DELTA DIV_ROUND_CLOSEST(SCHED_CAPACITY_SCALE, UCLAMP_BUCKETS)
 
@@ -989,10 +1009,38 @@ static inline void uclamp_rq_dec_id(struct rq *rq, struct task_struct *p,
 
 	lockdep_assert_held(&rq->lock);
 
+	/*
+	 * If sched_uclamp_used was enabled after task @p was enqueued,
+	 * we could end up with unbalanced call to uclamp_rq_dec_id().
+	 *
+	 * In this case the uc_se->active flag should be false since no uclamp
+	 * accounting was performed at enqueue time and we can just return
+	 * here.
+	 *
+	 * Need to be careful of the following enqeueue/dequeue ordering
+	 * problem too
+	 *
+	 *	enqueue(taskA)
+	 *	// sched_uclamp_used gets enabled
+	 *	enqueue(taskB)
+	 *	dequeue(taskA)
+	 *	// Must not decrement bukcet->tasks here
+	 *	dequeue(taskB)
+	 *
+	 * where we could end up with stale data in uc_se and
+	 * bucket[uc_se->bucket_id].
+	 *
+	 * The following check here eliminates the possibility of such race.
+	 */
+	if (unlikely(!uc_se->active))
+		return;
+
 	bucket = &uc_rq->bucket[uc_se->bucket_id];
+
 	SCHED_WARN_ON(!bucket->tasks);
 	if (likely(bucket->tasks))
 		bucket->tasks--;
+
 	uc_se->active = false;
 
 	/*
@@ -1020,6 +1068,15 @@ static inline void uclamp_rq_inc(struct rq *rq, struct task_struct *p)
 {
 	enum uclamp_id clamp_id;
 
+	/*
+	 * Avoid any overhead until uclamp is actually used by the userspace.
+	 *
+	 * The condition is constructed such that a NOP is generated when
+	 * sched_uclamp_used is disabled.
+	 */
+	if (!static_branch_unlikely(&sched_uclamp_used))
+		return;
+
 	if (unlikely(!p->sched_class->uclamp_enabled))
 		return;
 
@@ -1035,6 +1092,15 @@ static inline void uclamp_rq_dec(struct rq *rq, struct task_struct *p)
 {
 	enum uclamp_id clamp_id;
 
+	/*
+	 * Avoid any overhead until uclamp is actually used by the userspace.
+	 *
+	 * The condition is constructed such that a NOP is generated when
+	 * sched_uclamp_used is disabled.
+	 */
+	if (!static_branch_unlikely(&sched_uclamp_used))
+		return;
+
 	if (unlikely(!p->sched_class->uclamp_enabled))
 		return;
 
@@ -1144,8 +1210,10 @@ int sysctl_sched_uclamp_handler(struct ctl_table *table, int write,
 		update_root_tg = true;
 	}
 
-	if (update_root_tg)
+	if (update_root_tg) {
+		static_branch_enable(&sched_uclamp_used);
 		uclamp_update_root_tg();
+	}
 
 	/*
 	 * We update all RUNNABLE tasks only when task groups are in use.
@@ -1210,6 +1278,8 @@ static void __setscheduler_uclamp(struct task_struct *p,
 	if (likely(!(attr->sched_flags & SCHED_FLAG_UTIL_CLAMP)))
 		return;
 
+	static_branch_enable(&sched_uclamp_used);
+
 	if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP_MIN) {
 		uclamp_se_set(&p->uclamp_req[UCLAMP_MIN],
 			      attr->sched_util_min, true);
@@ -7306,6 +7376,8 @@ static ssize_t cpu_uclamp_write(struct kernfs_open_file *of, char *buf,
 	if (req.ret)
 		return req.ret;
 
+	static_branch_enable(&sched_uclamp_used);
+
 	mutex_lock(&uclamp_mutex);
 	rcu_read_lock();
 
diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 7fbaee24c824f..dc6835bc64907 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -210,7 +210,7 @@ unsigned long schedutil_cpu_util(int cpu, unsigned long util_cfs,
 	unsigned long dl_util, util, irq;
 	struct rq *rq = cpu_rq(cpu);
 
-	if (!IS_BUILTIN(CONFIG_UCLAMP_TASK) &&
+	if (!uclamp_is_used() &&
 	    type == FREQUENCY_UTIL && rt_rq_is_runnable(&rq->rt)) {
 		return max;
 	}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1f58677a8f233..2a52710d2f526 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -863,6 +863,8 @@ struct uclamp_rq {
 	unsigned int value;
 	struct uclamp_bucket bucket[UCLAMP_BUCKETS];
 };
+
+DECLARE_STATIC_KEY_FALSE(sched_uclamp_used);
 #endif /* CONFIG_UCLAMP_TASK */
 
 /*
@@ -2355,12 +2357,35 @@ static inline void cpufreq_update_util(struct rq *rq, unsigned int flags) {}
 #ifdef CONFIG_UCLAMP_TASK
 unsigned long uclamp_eff_value(struct task_struct *p, enum uclamp_id clamp_id);
 
+/**
+ * uclamp_rq_util_with - clamp @util with @rq and @p effective uclamp values.
+ * @rq:		The rq to clamp against. Must not be NULL.
+ * @util:	The util value to clamp.
+ * @p:		The task to clamp against. Can be NULL if you want to clamp
+ *		against @rq only.
+ *
+ * Clamps the passed @util to the max(@rq, @p) effective uclamp values.
+ *
+ * If sched_uclamp_used static key is disabled, then just return the util
+ * without any clamping since uclamp aggregation at the rq level in the fast
+ * path is disabled, rendering this operation a NOP.
+ *
+ * Use uclamp_eff_value() if you don't care about uclamp values at rq level. It
+ * will return the correct effective uclamp value of the task even if the
+ * static key is disabled.
+ */
 static __always_inline
 unsigned long uclamp_rq_util_with(struct rq *rq, unsigned long util,
 				  struct task_struct *p)
 {
-	unsigned long min_util = READ_ONCE(rq->uclamp[UCLAMP_MIN].value);
-	unsigned long max_util = READ_ONCE(rq->uclamp[UCLAMP_MAX].value);
+	unsigned long min_util;
+	unsigned long max_util;
+
+	if (!static_branch_likely(&sched_uclamp_used))
+		return util;
+
+	min_util = READ_ONCE(rq->uclamp[UCLAMP_MIN].value);
+	max_util = READ_ONCE(rq->uclamp[UCLAMP_MAX].value);
 
 	if (p) {
 		min_util = max(min_util, uclamp_eff_value(p, UCLAMP_MIN));
@@ -2377,6 +2402,19 @@ unsigned long uclamp_rq_util_with(struct rq *rq, unsigned long util,
 
 	return clamp(util, min_util, max_util);
 }
+
+/*
+ * When uclamp is compiled in, the aggregation at rq level is 'turned off'
+ * by default in the fast path and only gets turned on once userspace performs
+ * an operation that requires it.
+ *
+ * Returns true if userspace opted-in to use uclamp and aggregation at rq level
+ * hence is active.
+ */
+static inline bool uclamp_is_used(void)
+{
+	return static_branch_likely(&sched_uclamp_used);
+}
 #else /* CONFIG_UCLAMP_TASK */
 static inline
 unsigned long uclamp_rq_util_with(struct rq *rq, unsigned long util,
@@ -2384,6 +2422,11 @@ unsigned long uclamp_rq_util_with(struct rq *rq, unsigned long util,
 {
 	return util;
 }
+
+static inline bool uclamp_is_used(void)
+{
+	return false;
+}
 #endif /* CONFIG_UCLAMP_TASK */
 
 #ifdef arch_scale_freq_capacity
-- 
2.25.1



