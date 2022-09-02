Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E685AAEFD
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbiIBMco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236430AbiIBMbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:31:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62BBE1AB7;
        Fri,  2 Sep 2022 05:27:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30499B82A99;
        Fri,  2 Sep 2022 12:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CD1C433C1;
        Fri,  2 Sep 2022 12:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121616;
        bh=AClEHJ539pESV5C/kiQ6Dr8lUzujxS4TSprFNaTcZ0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKWquPQ8D0kvbwsTpJAxa4K0UxUTKp7XPL1Crqgkk3tRv2fz0DOSGke6KyMFKTdOy
         LXPLWIY/xkJRNG9JPm6ccsg/zlKjQ1qAF+lrW9m+1+d/ncNFLII8Yfc6HQzp9ZSare
         uXl3/l0ufV5y/O38IjuOMMuB8yEaUOK7NXhF29ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "srivatsab@vmware.com, srivatsa@csail.mit.edu, akaher@vmware.com,
        amakhalov@vmware.com, vsirnapalli@vmware.com, sturlapati@vmware.com,
        bordoloih@vmware.com, keerthanak@vmware.com, Ankit Jain" 
        <ankitja@vmware.com>, Glenn Elliott <glenn@aurora.tech>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ankit Jain <ankitja@vmware.com>
Subject: [PATCH 5.4 10/77] sched/deadline: Fix priority inheritance with multiple scheduling classes
Date:   Fri,  2 Sep 2022 14:18:19 +0200
Message-Id: <20220902121403.961350037@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juri Lelli <juri.lelli@redhat.com>

commit 2279f540ea7d05f22d2f0c4224319330228586bc upstream.

Glenn reported that "an application [he developed produces] a BUG in
deadline.c when a SCHED_DEADLINE task contends with CFS tasks on nested
PTHREAD_PRIO_INHERIT mutexes.  I believe the bug is triggered when a CFS
task that was boosted by a SCHED_DEADLINE task boosts another CFS task
(nested priority inheritance).

 ------------[ cut here ]------------
 kernel BUG at kernel/sched/deadline.c:1462!
 invalid opcode: 0000 [#1] PREEMPT SMP
 CPU: 12 PID: 19171 Comm: dl_boost_bug Tainted: ...
 Hardware name: ...
 RIP: 0010:enqueue_task_dl+0x335/0x910
 Code: ...
 RSP: 0018:ffffc9000c2bbc68 EFLAGS: 00010002
 RAX: 0000000000000009 RBX: ffff888c0af94c00 RCX: ffffffff81e12500
 RDX: 000000000000002e RSI: ffff888c0af94c00 RDI: ffff888c10b22600
 RBP: ffffc9000c2bbd08 R08: 0000000000000009 R09: 0000000000000078
 R10: ffffffff81e12440 R11: ffffffff81e1236c R12: ffff888bc8932600
 R13: ffff888c0af94eb8 R14: ffff888c10b22600 R15: ffff888bc8932600
 FS:  00007fa58ac55700(0000) GS:ffff888c10b00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007fa58b523230 CR3: 0000000bf44ab003 CR4: 00000000007606e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  ? intel_pstate_update_util_hwp+0x13/0x170
  rt_mutex_setprio+0x1cc/0x4b0
  task_blocks_on_rt_mutex+0x225/0x260
  rt_spin_lock_slowlock_locked+0xab/0x2d0
  rt_spin_lock_slowlock+0x50/0x80
  hrtimer_grab_expiry_lock+0x20/0x30
  hrtimer_cancel+0x13/0x30
  do_nanosleep+0xa0/0x150
  hrtimer_nanosleep+0xe1/0x230
  ? __hrtimer_init_sleeper+0x60/0x60
  __x64_sys_nanosleep+0x8d/0xa0
  do_syscall_64+0x4a/0x100
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 RIP: 0033:0x7fa58b52330d
 ...
 ---[ end trace 0000000000000002 ]—

He also provided a simple reproducer creating the situation below:

 So the execution order of locking steps are the following
 (N1 and N2 are non-deadline tasks. D1 is a deadline task. M1 and M2
 are mutexes that are enabled * with priority inheritance.)

 Time moves forward as this timeline goes down:

 N1              N2               D1
 |               |                |
 |               |                |
 Lock(M1)        |                |
 |               |                |
 |             Lock(M2)           |
 |               |                |
 |               |              Lock(M2)
 |               |                |
 |             Lock(M1)           |
 |             (!!bug triggered!) |

Daniel reported a similar situation as well, by just letting ksoftirqd
run with DEADLINE (and eventually block on a mutex).

Problem is that boosted entities (Priority Inheritance) use static
DEADLINE parameters of the top priority waiter. However, there might be
cases where top waiter could be a non-DEADLINE entity that is currently
boosted by a DEADLINE entity from a different lock chain (i.e., nested
priority chains involving entities of non-DEADLINE classes). In this
case, top waiter static DEADLINE parameters could be null (initialized
to 0 at fork()) and replenish_dl_entity() would hit a BUG().

Fix this by keeping track of the original donor and using its parameters
when a task is boosted.

Reported-by: Glenn Elliott <glenn@aurora.tech>
Reported-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Link: https://lkml.kernel.org/r/20201117061432.517340-1-juri.lelli@redhat.com
[Ankit: Regenerated the patch for v5.4.y]
Signed-off-by: Ankit Jain <ankitja@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched.h   |   10 ++++
 kernel/sched/core.c     |   11 ++---
 kernel/sched/deadline.c |   97 ++++++++++++++++++++++++++----------------------
 3 files changed, 68 insertions(+), 50 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -544,7 +544,6 @@ struct sched_dl_entity {
 	 * overruns.
 	 */
 	unsigned int			dl_throttled      : 1;
-	unsigned int			dl_boosted        : 1;
 	unsigned int			dl_yielded        : 1;
 	unsigned int			dl_non_contending : 1;
 	unsigned int			dl_overrun	  : 1;
@@ -563,6 +562,15 @@ struct sched_dl_entity {
 	 * time.
 	 */
 	struct hrtimer inactive_timer;
+
+#ifdef CONFIG_RT_MUTEXES
+	/*
+	 * Priority Inheritance. When a DEADLINE scheduling entity is boosted
+	 * pi_se points to the donor, otherwise points to the dl_se it belongs
+	 * to (the original one/itself).
+	 */
+	struct sched_dl_entity *pi_se;
+#endif
 };
 
 #ifdef CONFIG_UCLAMP_TASK
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4554,20 +4554,21 @@ void rt_mutex_setprio(struct task_struct
 		if (!dl_prio(p->normal_prio) ||
 		    (pi_task && dl_prio(pi_task->prio) &&
 		     dl_entity_preempt(&pi_task->dl, &p->dl))) {
-			p->dl.dl_boosted = 1;
+			p->dl.pi_se = pi_task->dl.pi_se;
 			queue_flag |= ENQUEUE_REPLENISH;
-		} else
-			p->dl.dl_boosted = 0;
+		} else {
+			p->dl.pi_se = &p->dl;
+		}
 		p->sched_class = &dl_sched_class;
 	} else if (rt_prio(prio)) {
 		if (dl_prio(oldprio))
-			p->dl.dl_boosted = 0;
+			p->dl.pi_se = &p->dl;
 		if (oldprio < prio)
 			queue_flag |= ENQUEUE_HEAD;
 		p->sched_class = &rt_sched_class;
 	} else {
 		if (dl_prio(oldprio))
-			p->dl.dl_boosted = 0;
+			p->dl.pi_se = &p->dl;
 		if (rt_prio(oldprio))
 			p->rt.timeout = 0;
 		p->sched_class = &fair_sched_class;
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -43,6 +43,28 @@ static inline int on_dl_rq(struct sched_
 	return !RB_EMPTY_NODE(&dl_se->rb_node);
 }
 
+#ifdef CONFIG_RT_MUTEXES
+static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
+{
+	return dl_se->pi_se;
+}
+
+static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
+{
+	return pi_of(dl_se) != dl_se;
+}
+#else
+static inline struct sched_dl_entity *pi_of(struct sched_dl_entity *dl_se)
+{
+	return dl_se;
+}
+
+static inline bool is_dl_boosted(struct sched_dl_entity *dl_se)
+{
+	return false;
+}
+#endif
+
 #ifdef CONFIG_SMP
 static inline struct dl_bw *dl_bw_of(int i)
 {
@@ -657,7 +679,7 @@ static inline void setup_new_dl_entity(s
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
-	WARN_ON(dl_se->dl_boosted);
+	WARN_ON(is_dl_boosted(dl_se));
 	WARN_ON(dl_time_before(rq_clock(rq), dl_se->deadline));
 
 	/*
@@ -695,21 +717,20 @@ static inline void setup_new_dl_entity(s
  * could happen are, typically, a entity voluntarily trying to overcome its
  * runtime, or it just underestimated it during sched_setattr().
  */
-static void replenish_dl_entity(struct sched_dl_entity *dl_se,
-				struct sched_dl_entity *pi_se)
+static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
-	BUG_ON(pi_se->dl_runtime <= 0);
+	BUG_ON(pi_of(dl_se)->dl_runtime <= 0);
 
 	/*
 	 * This could be the case for a !-dl task that is boosted.
 	 * Just go with full inherited parameters.
 	 */
 	if (dl_se->dl_deadline == 0) {
-		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
-		dl_se->runtime = pi_se->dl_runtime;
+		dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
+		dl_se->runtime = pi_of(dl_se)->dl_runtime;
 	}
 
 	if (dl_se->dl_yielded && dl_se->runtime > 0)
@@ -722,8 +743,8 @@ static void replenish_dl_entity(struct s
 	 * arbitrary large.
 	 */
 	while (dl_se->runtime <= 0) {
-		dl_se->deadline += pi_se->dl_period;
-		dl_se->runtime += pi_se->dl_runtime;
+		dl_se->deadline += pi_of(dl_se)->dl_period;
+		dl_se->runtime += pi_of(dl_se)->dl_runtime;
 	}
 
 	/*
@@ -737,8 +758,8 @@ static void replenish_dl_entity(struct s
 	 */
 	if (dl_time_before(dl_se->deadline, rq_clock(rq))) {
 		printk_deferred_once("sched: DL replenish lagged too much\n");
-		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
-		dl_se->runtime = pi_se->dl_runtime;
+		dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
+		dl_se->runtime = pi_of(dl_se)->dl_runtime;
 	}
 
 	if (dl_se->dl_yielded)
@@ -771,8 +792,7 @@ static void replenish_dl_entity(struct s
  * task with deadline equal to period this is the same of using
  * dl_period instead of dl_deadline in the equation above.
  */
-static bool dl_entity_overflow(struct sched_dl_entity *dl_se,
-			       struct sched_dl_entity *pi_se, u64 t)
+static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
 {
 	u64 left, right;
 
@@ -794,9 +814,9 @@ static bool dl_entity_overflow(struct sc
 	 * of anything below microseconds resolution is actually fiction
 	 * (but still we want to give the user that illusion >;).
 	 */
-	left = (pi_se->dl_deadline >> DL_SCALE) * (dl_se->runtime >> DL_SCALE);
+	left = (pi_of(dl_se)->dl_deadline >> DL_SCALE) * (dl_se->runtime >> DL_SCALE);
 	right = ((dl_se->deadline - t) >> DL_SCALE) *
-		(pi_se->dl_runtime >> DL_SCALE);
+		(pi_of(dl_se)->dl_runtime >> DL_SCALE);
 
 	return dl_time_before(right, left);
 }
@@ -881,24 +901,23 @@ static inline bool dl_is_implicit(struct
  * Please refer to the comments update_dl_revised_wakeup() function to find
  * more about the Revised CBS rule.
  */
-static void update_dl_entity(struct sched_dl_entity *dl_se,
-			     struct sched_dl_entity *pi_se)
+static void update_dl_entity(struct sched_dl_entity *dl_se)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
 	if (dl_time_before(dl_se->deadline, rq_clock(rq)) ||
-	    dl_entity_overflow(dl_se, pi_se, rq_clock(rq))) {
+	    dl_entity_overflow(dl_se, rq_clock(rq))) {
 
 		if (unlikely(!dl_is_implicit(dl_se) &&
 			     !dl_time_before(dl_se->deadline, rq_clock(rq)) &&
-			     !dl_se->dl_boosted)){
+			     !is_dl_boosted(dl_se))) {
 			update_dl_revised_wakeup(dl_se, rq);
 			return;
 		}
 
-		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
-		dl_se->runtime = pi_se->dl_runtime;
+		dl_se->deadline = rq_clock(rq) + pi_of(dl_se)->dl_deadline;
+		dl_se->runtime = pi_of(dl_se)->dl_runtime;
 	}
 }
 
@@ -997,7 +1016,7 @@ static enum hrtimer_restart dl_task_time
 	 * The task might have been boosted by someone else and might be in the
 	 * boosting/deboosting path, its not throttled.
 	 */
-	if (dl_se->dl_boosted)
+	if (is_dl_boosted(dl_se))
 		goto unlock;
 
 	/*
@@ -1025,7 +1044,7 @@ static enum hrtimer_restart dl_task_time
 	 * but do not enqueue -- wait for our wakeup to do that.
 	 */
 	if (!task_on_rq_queued(p)) {
-		replenish_dl_entity(dl_se, dl_se);
+		replenish_dl_entity(dl_se);
 		goto unlock;
 	}
 
@@ -1115,7 +1134,7 @@ static inline void dl_check_constrained_
 
 	if (dl_time_before(dl_se->deadline, rq_clock(rq)) &&
 	    dl_time_before(rq_clock(rq), dl_next_period(dl_se))) {
-		if (unlikely(dl_se->dl_boosted || !start_dl_timer(p)))
+		if (unlikely(is_dl_boosted(dl_se) || !start_dl_timer(p)))
 			return;
 		dl_se->dl_throttled = 1;
 		if (dl_se->runtime > 0)
@@ -1246,7 +1265,7 @@ throttle:
 			dl_se->dl_overrun = 1;
 
 		__dequeue_task_dl(rq, curr, 0);
-		if (unlikely(dl_se->dl_boosted || !start_dl_timer(curr)))
+		if (unlikely(is_dl_boosted(dl_se) || !start_dl_timer(curr)))
 			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
 
 		if (!is_leftmost(curr, &rq->dl))
@@ -1440,8 +1459,7 @@ static void __dequeue_dl_entity(struct s
 }
 
 static void
-enqueue_dl_entity(struct sched_dl_entity *dl_se,
-		  struct sched_dl_entity *pi_se, int flags)
+enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 {
 	BUG_ON(on_dl_rq(dl_se));
 
@@ -1452,9 +1470,9 @@ enqueue_dl_entity(struct sched_dl_entity
 	 */
 	if (flags & ENQUEUE_WAKEUP) {
 		task_contending(dl_se, flags);
-		update_dl_entity(dl_se, pi_se);
+		update_dl_entity(dl_se);
 	} else if (flags & ENQUEUE_REPLENISH) {
-		replenish_dl_entity(dl_se, pi_se);
+		replenish_dl_entity(dl_se);
 	} else if ((flags & ENQUEUE_RESTORE) &&
 		  dl_time_before(dl_se->deadline,
 				 rq_clock(rq_of_dl_rq(dl_rq_of_se(dl_se))))) {
@@ -1471,19 +1489,7 @@ static void dequeue_dl_entity(struct sch
 
 static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 {
-	struct task_struct *pi_task = rt_mutex_get_top_task(p);
-	struct sched_dl_entity *pi_se = &p->dl;
-
-	/*
-	 * Use the scheduling parameters of the top pi-waiter task if:
-	 * - we have a top pi-waiter which is a SCHED_DEADLINE task AND
-	 * - our dl_boosted is set (i.e. the pi-waiter's (absolute) deadline is
-	 *   smaller than our deadline OR we are a !SCHED_DEADLINE task getting
-	 *   boosted due to a SCHED_DEADLINE pi-waiter).
-	 * Otherwise we keep our runtime and deadline.
-	 */
-	if (pi_task && dl_prio(pi_task->normal_prio) && p->dl.dl_boosted) {
-		pi_se = &pi_task->dl;
+	if (is_dl_boosted(&p->dl)) {
 		/*
 		 * Because of delays in the detection of the overrun of a
 		 * thread's runtime, it might be the case that a thread
@@ -1516,7 +1522,7 @@ static void enqueue_task_dl(struct rq *r
 		 * the throttle.
 		 */
 		p->dl.dl_throttled = 0;
-		BUG_ON(!p->dl.dl_boosted || flags != ENQUEUE_REPLENISH);
+		BUG_ON(!is_dl_boosted(&p->dl) || flags != ENQUEUE_REPLENISH);
 		return;
 	}
 
@@ -1553,7 +1559,7 @@ static void enqueue_task_dl(struct rq *r
 		return;
 	}
 
-	enqueue_dl_entity(&p->dl, pi_se, flags);
+	enqueue_dl_entity(&p->dl, flags);
 
 	if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
 		enqueue_pushable_dl_task(rq, p);
@@ -2722,11 +2728,14 @@ void __dl_clear_params(struct task_struc
 	dl_se->dl_bw			= 0;
 	dl_se->dl_density		= 0;
 
-	dl_se->dl_boosted		= 0;
 	dl_se->dl_throttled		= 0;
 	dl_se->dl_yielded		= 0;
 	dl_se->dl_non_contending	= 0;
 	dl_se->dl_overrun		= 0;
+
+#ifdef CONFIG_RT_MUTEXES
+	dl_se->pi_se			= dl_se;
+#endif
 }
 
 bool dl_param_changed(struct task_struct *p, const struct sched_attr *attr)


