Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2CA4F7B96
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbfKKShn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:37:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728106AbfKKShm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:37:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39AE220659;
        Mon, 11 Nov 2019 18:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497461;
        bh=DEj4yHTZGouOATeaoTylsBxfETrHasFGgKAyFk7h6Pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzpScmOTiIpzZocOTQAYe36r8xKdDvJWkSYQUQ/0h9farQs43LZAIyqVa98FmCwiG
         4c/osz5atD0lBLpGpR3RB8WK20d7FKIqEvzsO+czuSmf7sIAKmM56F10N5ApMQO3Xc
         EqZcV4/uBcODb/unq/zQAJQggMZT+zfCxMzBi4cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chiluk <chiluk+linux@indeed.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Phil Auld <pauld@redhat.com>, Ben Segall <bsegall@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        John Hammond <jhammond@indeed.com>,
        Jonathan Corbet <corbet@lwn.net>, Kyle Anderson <kwa@yelp.com>,
        Gabriel Munos <gmunoz@netflix.com>,
        Peter Oskolkov <posk@posk.io>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Brendan Gregg <bgregg@netflix.com>
Subject: [PATCH 4.14 062/105] sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices
Date:   Mon, 11 Nov 2019 19:28:32 +0100
Message-Id: <20191111181445.047644168@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chiluk <chiluk+linux@indeed.com>

commit de53fd7aedb100f03e5d2231cfce0e4993282425 upstream.

It has been observed, that highly-threaded, non-cpu-bound applications
running under cpu.cfs_quota_us constraints can hit a high percentage of
periods throttled while simultaneously not consuming the allocated
amount of quota. This use case is typical of user-interactive non-cpu
bound applications, such as those running in kubernetes or mesos when
run on multiple cpu cores.

This has been root caused to cpu-local run queue being allocated per cpu
bandwidth slices, and then not fully using that slice within the period.
At which point the slice and quota expires. This expiration of unused
slice results in applications not being able to utilize the quota for
which they are allocated.

The non-expiration of per-cpu slices was recently fixed by
'commit 512ac999d275 ("sched/fair: Fix bandwidth timer clock drift
condition")'. Prior to that it appears that this had been broken since
at least 'commit 51f2176d74ac ("sched/fair: Fix unlocked reads of some
cfs_b->quota/period")' which was introduced in v3.16-rc1 in 2014. That
added the following conditional which resulted in slices never being
expired.

if (cfs_rq->runtime_expires != cfs_b->runtime_expires) {
	/* extend local deadline, drift is bounded above by 2 ticks */
	cfs_rq->runtime_expires += TICK_NSEC;

Because this was broken for nearly 5 years, and has recently been fixed
and is now being noticed by many users running kubernetes
(https://github.com/kubernetes/kubernetes/issues/67577) it is my opinion
that the mechanisms around expiring runtime should be removed
altogether.

This allows quota already allocated to per-cpu run-queues to live longer
than the period boundary. This allows threads on runqueues that do not
use much CPU to continue to use their remaining slice over a longer
period of time than cpu.cfs_period_us. However, this helps prevent the
above condition of hitting throttling while also not fully utilizing
your cpu quota.

This theoretically allows a machine to use slightly more than its
allotted quota in some periods. This overflow would be bounded by the
remaining quota left on each per-cpu runqueueu. This is typically no
more than min_cfs_rq_runtime=1ms per cpu. For CPU bound tasks this will
change nothing, as they should theoretically fully utilize all of their
quota in each period. For user-interactive tasks as described above this
provides a much better user/application experience as their cpu
utilization will more closely match the amount they requested when they
hit throttling. This means that cpu limits no longer strictly apply per
period for non-cpu bound applications, but that they are still accurate
over longer timeframes.

This greatly improves performance of high-thread-count, non-cpu bound
applications with low cfs_quota_us allocation on high-core-count
machines. In the case of an artificial testcase (10ms/100ms of quota on
80 CPU machine), this commit resulted in almost 30x performance
improvement, while still maintaining correct cpu quota restrictions.
That testcase is available at https://github.com/indeedeng/fibtest.

Fixes: 512ac999d275 ("sched/fair: Fix bandwidth timer clock drift condition")
Signed-off-by: Dave Chiluk <chiluk+linux@indeed.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Reviewed-by: Ben Segall <bsegall@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: John Hammond <jhammond@indeed.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kyle Anderson <kwa@yelp.com>
Cc: Gabriel Munos <gmunoz@netflix.com>
Cc: Peter Oskolkov <posk@posk.io>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Brendan Gregg <bgregg@netflix.com>
Link: https://lkml.kernel.org/r/1563900266-19734-2-git-send-email-chiluk+linux@indeed.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/scheduler/sched-bwc.txt |   45 +++++++++++++++++++++
 kernel/sched/fair.c                   |   70 +++-------------------------------
 kernel/sched/sched.h                  |    4 -
 3 files changed, 52 insertions(+), 67 deletions(-)

--- a/Documentation/scheduler/sched-bwc.txt
+++ b/Documentation/scheduler/sched-bwc.txt
@@ -90,6 +90,51 @@ There are two ways in which a group may
 In case b) above, even though the child may have runtime remaining it will not
 be allowed to until the parent's runtime is refreshed.
 
+CFS Bandwidth Quota Caveats
+---------------------------
+Once a slice is assigned to a cpu it does not expire.  However all but 1ms of
+the slice may be returned to the global pool if all threads on that cpu become
+unrunnable. This is configured at compile time by the min_cfs_rq_runtime
+variable. This is a performance tweak that helps prevent added contention on
+the global lock.
+
+The fact that cpu-local slices do not expire results in some interesting corner
+cases that should be understood.
+
+For cgroup cpu constrained applications that are cpu limited this is a
+relatively moot point because they will naturally consume the entirety of their
+quota as well as the entirety of each cpu-local slice in each period. As a
+result it is expected that nr_periods roughly equal nr_throttled, and that
+cpuacct.usage will increase roughly equal to cfs_quota_us in each period.
+
+For highly-threaded, non-cpu bound applications this non-expiration nuance
+allows applications to briefly burst past their quota limits by the amount of
+unused slice on each cpu that the task group is running on (typically at most
+1ms per cpu or as defined by min_cfs_rq_runtime).  This slight burst only
+applies if quota had been assigned to a cpu and then not fully used or returned
+in previous periods. This burst amount will not be transferred between cores.
+As a result, this mechanism still strictly limits the task group to quota
+average usage, albeit over a longer time window than a single period.  This
+also limits the burst ability to no more than 1ms per cpu.  This provides
+better more predictable user experience for highly threaded applications with
+small quota limits on high core count machines. It also eliminates the
+propensity to throttle these applications while simultanously using less than
+quota amounts of cpu. Another way to say this, is that by allowing the unused
+portion of a slice to remain valid across periods we have decreased the
+possibility of wastefully expiring quota on cpu-local silos that don't need a
+full slice's amount of cpu time.
+
+The interaction between cpu-bound and non-cpu-bound-interactive applications
+should also be considered, especially when single core usage hits 100%. If you
+gave each of these applications half of a cpu-core and they both got scheduled
+on the same CPU it is theoretically possible that the non-cpu bound application
+will use up to 1ms additional quota in some periods, thereby preventing the
+cpu-bound application from fully using its quota by that same amount. In these
+instances it will be up to the CFS algorithm (see sched-design-CFS.rst) to
+decide which application is chosen to run, as they will both be runnable and
+have remaining quota. This runtime discrepancy will be made up in the following
+periods when the interactive application idles.
+
 Examples
 --------
 1. Limit a group to 1 CPU worth of runtime.
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4106,8 +4106,6 @@ void __refill_cfs_bandwidth_runtime(stru
 
 	now = sched_clock_cpu(smp_processor_id());
 	cfs_b->runtime = cfs_b->quota;
-	cfs_b->runtime_expires = now + ktime_to_ns(cfs_b->period);
-	cfs_b->expires_seq++;
 }
 
 static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
@@ -4129,8 +4127,7 @@ static int assign_cfs_rq_runtime(struct
 {
 	struct task_group *tg = cfs_rq->tg;
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
-	u64 amount = 0, min_amount, expires;
-	int expires_seq;
+	u64 amount = 0, min_amount;
 
 	/* note: this is a positive sum as runtime_remaining <= 0 */
 	min_amount = sched_cfs_bandwidth_slice() - cfs_rq->runtime_remaining;
@@ -4147,61 +4144,17 @@ static int assign_cfs_rq_runtime(struct
 			cfs_b->idle = 0;
 		}
 	}
-	expires_seq = cfs_b->expires_seq;
-	expires = cfs_b->runtime_expires;
 	raw_spin_unlock(&cfs_b->lock);
 
 	cfs_rq->runtime_remaining += amount;
-	/*
-	 * we may have advanced our local expiration to account for allowed
-	 * spread between our sched_clock and the one on which runtime was
-	 * issued.
-	 */
-	if (cfs_rq->expires_seq != expires_seq) {
-		cfs_rq->expires_seq = expires_seq;
-		cfs_rq->runtime_expires = expires;
-	}
 
 	return cfs_rq->runtime_remaining > 0;
 }
 
-/*
- * Note: This depends on the synchronization provided by sched_clock and the
- * fact that rq->clock snapshots this value.
- */
-static void expire_cfs_rq_runtime(struct cfs_rq *cfs_rq)
-{
-	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
-
-	/* if the deadline is ahead of our clock, nothing to do */
-	if (likely((s64)(rq_clock(rq_of(cfs_rq)) - cfs_rq->runtime_expires) < 0))
-		return;
-
-	if (cfs_rq->runtime_remaining < 0)
-		return;
-
-	/*
-	 * If the local deadline has passed we have to consider the
-	 * possibility that our sched_clock is 'fast' and the global deadline
-	 * has not truly expired.
-	 *
-	 * Fortunately we can check determine whether this the case by checking
-	 * whether the global deadline(cfs_b->expires_seq) has advanced.
-	 */
-	if (cfs_rq->expires_seq == cfs_b->expires_seq) {
-		/* extend local deadline, drift is bounded above by 2 ticks */
-		cfs_rq->runtime_expires += TICK_NSEC;
-	} else {
-		/* global deadline is ahead, expiration has passed */
-		cfs_rq->runtime_remaining = 0;
-	}
-}
-
 static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec)
 {
 	/* dock delta_exec before expiring quota (as it could span periods) */
 	cfs_rq->runtime_remaining -= delta_exec;
-	expire_cfs_rq_runtime(cfs_rq);
 
 	if (likely(cfs_rq->runtime_remaining > 0))
 		return;
@@ -4387,8 +4340,7 @@ void unthrottle_cfs_rq(struct cfs_rq *cf
 		resched_curr(rq);
 }
 
-static u64 distribute_cfs_runtime(struct cfs_bandwidth *cfs_b,
-		u64 remaining, u64 expires)
+static u64 distribute_cfs_runtime(struct cfs_bandwidth *cfs_b, u64 remaining)
 {
 	struct cfs_rq *cfs_rq;
 	u64 runtime;
@@ -4413,7 +4365,6 @@ static u64 distribute_cfs_runtime(struct
 		remaining -= runtime;
 
 		cfs_rq->runtime_remaining += runtime;
-		cfs_rq->runtime_expires = expires;
 
 		/* we check whether we're throttled above */
 		if (cfs_rq->runtime_remaining > 0)
@@ -4438,7 +4389,7 @@ next:
  */
 static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 {
-	u64 runtime, runtime_expires;
+	u64 runtime;
 	int throttled;
 
 	/* no need to continue the timer with no bandwidth constraint */
@@ -4466,8 +4417,6 @@ static int do_sched_cfs_period_timer(str
 	/* account preceding periods in which throttling occurred */
 	cfs_b->nr_throttled += overrun;
 
-	runtime_expires = cfs_b->runtime_expires;
-
 	/*
 	 * This check is repeated as we are holding onto the new bandwidth while
 	 * we unthrottle. This can potentially race with an unthrottled group
@@ -4480,8 +4429,7 @@ static int do_sched_cfs_period_timer(str
 		cfs_b->distribute_running = 1;
 		raw_spin_unlock(&cfs_b->lock);
 		/* we can't nest cfs_b->lock while distributing bandwidth */
-		runtime = distribute_cfs_runtime(cfs_b, runtime,
-						 runtime_expires);
+		runtime = distribute_cfs_runtime(cfs_b, runtime);
 		raw_spin_lock(&cfs_b->lock);
 
 		cfs_b->distribute_running = 0;
@@ -4558,8 +4506,7 @@ static void __return_cfs_rq_runtime(stru
 		return;
 
 	raw_spin_lock(&cfs_b->lock);
-	if (cfs_b->quota != RUNTIME_INF &&
-	    cfs_rq->runtime_expires == cfs_b->runtime_expires) {
+	if (cfs_b->quota != RUNTIME_INF) {
 		cfs_b->runtime += slack_runtime;
 
 		/* we are under rq->lock, defer unthrottling using a timer */
@@ -4591,7 +4538,6 @@ static __always_inline void return_cfs_r
 static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
 {
 	u64 runtime = 0, slice = sched_cfs_bandwidth_slice();
-	u64 expires;
 
 	/* confirm we're still not at a refresh boundary */
 	raw_spin_lock(&cfs_b->lock);
@@ -4608,7 +4554,6 @@ static void do_sched_cfs_slack_timer(str
 	if (cfs_b->quota != RUNTIME_INF && cfs_b->runtime > slice)
 		runtime = cfs_b->runtime;
 
-	expires = cfs_b->runtime_expires;
 	if (runtime)
 		cfs_b->distribute_running = 1;
 
@@ -4617,11 +4562,10 @@ static void do_sched_cfs_slack_timer(str
 	if (!runtime)
 		return;
 
-	runtime = distribute_cfs_runtime(cfs_b, runtime, expires);
+	runtime = distribute_cfs_runtime(cfs_b, runtime);
 
 	raw_spin_lock(&cfs_b->lock);
-	if (expires == cfs_b->runtime_expires)
-		cfs_b->runtime -= min(runtime, cfs_b->runtime);
+	cfs_b->runtime -= min(runtime, cfs_b->runtime);
 	cfs_b->distribute_running = 0;
 	raw_spin_unlock(&cfs_b->lock);
 }
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -280,8 +280,6 @@ struct cfs_bandwidth {
 	ktime_t period;
 	u64 quota, runtime;
 	s64 hierarchical_quota;
-	u64 runtime_expires;
-	int expires_seq;
 
 	short idle, period_active;
 	struct hrtimer period_timer, slack_timer;
@@ -489,8 +487,6 @@ struct cfs_rq {
 
 #ifdef CONFIG_CFS_BANDWIDTH
 	int runtime_enabled;
-	int expires_seq;
-	u64 runtime_expires;
 	s64 runtime_remaining;
 
 	u64 throttled_clock, throttled_clock_task;


