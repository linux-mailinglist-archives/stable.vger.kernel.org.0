Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83AF26F267
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730403AbgIRC6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbgIRCGP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:06:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42EAE2396D;
        Fri, 18 Sep 2020 02:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394775;
        bh=gFGlF0h2VuYpy/qPOGf96RRiUKzZithOp0hfL1m5Q98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxUYDKW4ufWxT8eHdmwVOo/Og/s+3XrTGQUc3eJrifCm529JmbpTB+m1FT+Aqu4vM
         Iq6X6AXAeelH530wtHSTq3ct/F6a9WKOPM3lroBuixkhOQn7CshPIbl0MrxZYy0zjp
         zECY6aGlWbc8n3FUOCh4kpslH9KZEsFH2oFFu1pY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Turner <pjt@google.com>, Ben Segall <bsegall@google.com>,
        Josh Don <joshdon@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Phil Auld <pauld@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 249/330] sched/fair: Eliminate bandwidth race between throttling and distribution
Date:   Thu, 17 Sep 2020 21:59:49 -0400
Message-Id: <20200918020110.2063155-249-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Turner <pjt@google.com>

[ Upstream commit e98fa02c4f2ea4991dae422ac7e34d102d2f0599 ]

There is a race window in which an entity begins throttling before quota
is added to the pool, but does not finish throttling until after we have
finished with distribute_cfs_runtime(). This entity is not observed by
distribute_cfs_runtime() because it was not on the throttled list at the
time that distribution was running. This race manifests as rare
period-length statlls for such entities.

Rather than heavy-weight the synchronization with the progress of
distribution, we can fix this by aborting throttling if bandwidth has
become available. Otherwise, we immediately add the entity to the
throttled list so that it can be observed by a subsequent distribution.

Additionally, we can remove the case of adding the throttled entity to
the head of the throttled list, and simply always add to the tail.
Thanks to 26a8b12747c97, distribute_cfs_runtime() no longer holds onto
its own pool of runtime. This means that if we do hit the !assign and
distribute_running case, we know that distribution is about to end.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Ben Segall <bsegall@google.com>
Signed-off-by: Josh Don <joshdon@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Link: https://lkml.kernel.org/r/20200410225208.109717-2-joshdon@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 79 +++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 32 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 20bf1f66733ac..b02a83ff40687 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4383,16 +4383,16 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 }
 
 /* returns 0 on failure to allocate runtime */
-static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+static int __assign_cfs_rq_runtime(struct cfs_bandwidth *cfs_b,
+				   struct cfs_rq *cfs_rq, u64 target_runtime)
 {
-	struct task_group *tg = cfs_rq->tg;
-	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
-	u64 amount = 0, min_amount;
+	u64 min_amount, amount = 0;
+
+	lockdep_assert_held(&cfs_b->lock);
 
 	/* note: this is a positive sum as runtime_remaining <= 0 */
-	min_amount = sched_cfs_bandwidth_slice() - cfs_rq->runtime_remaining;
+	min_amount = target_runtime - cfs_rq->runtime_remaining;
 
-	raw_spin_lock(&cfs_b->lock);
 	if (cfs_b->quota == RUNTIME_INF)
 		amount = min_amount;
 	else {
@@ -4404,13 +4404,25 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 			cfs_b->idle = 0;
 		}
 	}
-	raw_spin_unlock(&cfs_b->lock);
 
 	cfs_rq->runtime_remaining += amount;
 
 	return cfs_rq->runtime_remaining > 0;
 }
 
+/* returns 0 on failure to allocate runtime */
+static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
+{
+	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
+	int ret;
+
+	raw_spin_lock(&cfs_b->lock);
+	ret = __assign_cfs_rq_runtime(cfs_b, cfs_rq, sched_cfs_bandwidth_slice());
+	raw_spin_unlock(&cfs_b->lock);
+
+	return ret;
+}
+
 static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec)
 {
 	/* dock delta_exec before expiring quota (as it could span periods) */
@@ -4499,13 +4511,33 @@ static int tg_throttle_down(struct task_group *tg, void *data)
 	return 0;
 }
 
-static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
+static bool throttle_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	struct rq *rq = rq_of(cfs_rq);
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 	struct sched_entity *se;
 	long task_delta, idle_task_delta, dequeue = 1;
-	bool empty;
+
+	raw_spin_lock(&cfs_b->lock);
+	/* This will start the period timer if necessary */
+	if (__assign_cfs_rq_runtime(cfs_b, cfs_rq, 1)) {
+		/*
+		 * We have raced with bandwidth becoming available, and if we
+		 * actually throttled the timer might not unthrottle us for an
+		 * entire period. We additionally needed to make sure that any
+		 * subsequent check_cfs_rq_runtime calls agree not to throttle
+		 * us, as we may commit to do cfs put_prev+pick_next, so we ask
+		 * for 1ns of runtime rather than just check cfs_b.
+		 */
+		dequeue = 0;
+	} else {
+		list_add_tail_rcu(&cfs_rq->throttled_list,
+				  &cfs_b->throttled_cfs_rq);
+	}
+	raw_spin_unlock(&cfs_b->lock);
+
+	if (!dequeue)
+		return false;  /* Throttle no longer required. */
 
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
@@ -4534,29 +4566,13 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	if (!se)
 		sub_nr_running(rq, task_delta);
 
-	cfs_rq->throttled = 1;
-	cfs_rq->throttled_clock = rq_clock(rq);
-	raw_spin_lock(&cfs_b->lock);
-	empty = list_empty(&cfs_b->throttled_cfs_rq);
-
-	/*
-	 * Add to the _head_ of the list, so that an already-started
-	 * distribute_cfs_runtime will not see us. If disribute_cfs_runtime is
-	 * not running add to the tail so that later runqueues don't get starved.
-	 */
-	if (cfs_b->distribute_running)
-		list_add_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
-	else
-		list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
-
 	/*
-	 * If we're the first throttled task, make sure the bandwidth
-	 * timer is running.
+	 * Note: distribution will already see us throttled via the
+	 * throttled-list.  rq->lock protects completion.
 	 */
-	if (empty)
-		start_cfs_bandwidth(cfs_b);
-
-	raw_spin_unlock(&cfs_b->lock);
+	cfs_rq->throttled = 1;
+	cfs_rq->throttled_clock = rq_clock(rq);
+	return true;
 }
 
 void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
@@ -4915,8 +4931,7 @@ static bool check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 	if (cfs_rq_throttled(cfs_rq))
 		return true;
 
-	throttle_cfs_rq(cfs_rq);
-	return true;
+	return throttle_cfs_rq(cfs_rq);
 }
 
 static enum hrtimer_restart sched_cfs_slack_timer(struct hrtimer *timer)
-- 
2.25.1

