Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB29C1D0EB2
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387470AbgEMJuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:50:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732874AbgEMJuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:50:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7244120740;
        Wed, 13 May 2020 09:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363421;
        bh=w+jFkQaVDdl4qhCvMrCzX1P0zXla7bqFZdiLNyQgpf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTCZyscApU/wqwUrvGt57+rnffeiuKE8ySUNh7b0jOZDs7mV5jW8pJwUAer19PbSm
         64XtASTjOmuAoC/hQJkp8WIV+OLETkh83PduKU8TImVxDPrq6NYtAEK0QLbKOHj/y2
         /2j/lW2WalzcdxQRr6F6q9RYI7eyb1bRLMwkPK/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Vlad Dmitriev <vvd@fb.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 67/90] iocost: protect iocg->abs_vdebt with iocg->waitq.lock
Date:   Wed, 13 May 2020 11:45:03 +0200
Message-Id: <20200513094416.415699535@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 0b80f9866e6bbfb905140ed8787ff2af03652c0c upstream.

abs_vdebt is an atomic_64 which tracks how much over budget a given cgroup
is and controls the activation of use_delay mechanism. Once a cgroup goes
over budget from forced IOs, it has to pay it back with its future budget.
The progress guarantee on debt paying comes from the iocg being active -
active iocgs are processed by the periodic timer, which ensures that as time
passes the debts dissipate and the iocg returns to normal operation.

However, both iocg activation and vdebt handling are asynchronous and a
sequence like the following may happen.

1. The iocg is in the process of being deactivated by the periodic timer.

2. A bio enters ioc_rqos_throttle(), calls iocg_activate() which returns
   without anything because it still sees that the iocg is already active.

3. The iocg is deactivated.

4. The bio from #2 is over budget but needs to be forced. It increases
   abs_vdebt and goes over the threshold and enables use_delay.

5. IO control is enabled for the iocg's subtree and now IOs are attributed
   to the descendant cgroups and the iocg itself no longer issues IOs.

This leaves the iocg with stuck abs_vdebt - it has debt but inactive and no
further IOs which can activate it. This can end up unduly punishing all the
descendants cgroups.

The usual throttling path has the same issue - the iocg must be active while
throttled to ensure that future event will wake it up - and solves the
problem by synchronizing the throttling path with a spinlock. abs_vdebt
handling is another form of overage handling and shares a lot of
characteristics including the fact that it isn't in the hottest path.

This patch fixes the above and other possible races by strictly
synchronizing abs_vdebt and use_delay handling with iocg->waitq.lock.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Vlad Dmitriev <vvd@fb.com>
Cc: stable@vger.kernel.org # v5.4+
Fixes: e1518f63f246 ("blk-iocost: Don't let merges push vtime into the future")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-iocost.c             |  117 ++++++++++++++++++++++++-----------------
 tools/cgroup/iocost_monitor.py |    7 ++
 2 files changed, 77 insertions(+), 47 deletions(-)

--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -469,7 +469,7 @@ struct ioc_gq {
 	 */
 	atomic64_t			vtime;
 	atomic64_t			done_vtime;
-	atomic64_t			abs_vdebt;
+	u64				abs_vdebt;
 	u64				last_vtime;
 
 	/*
@@ -1145,7 +1145,7 @@ static void iocg_kick_waitq(struct ioc_g
 	struct iocg_wake_ctx ctx = { .iocg = iocg };
 	u64 margin_ns = (u64)(ioc->period_us *
 			      WAITQ_TIMER_MARGIN_PCT / 100) * NSEC_PER_USEC;
-	u64 abs_vdebt, vdebt, vshortage, expires, oexpires;
+	u64 vdebt, vshortage, expires, oexpires;
 	s64 vbudget;
 	u32 hw_inuse;
 
@@ -1155,18 +1155,15 @@ static void iocg_kick_waitq(struct ioc_g
 	vbudget = now->vnow - atomic64_read(&iocg->vtime);
 
 	/* pay off debt */
-	abs_vdebt = atomic64_read(&iocg->abs_vdebt);
-	vdebt = abs_cost_to_cost(abs_vdebt, hw_inuse);
+	vdebt = abs_cost_to_cost(iocg->abs_vdebt, hw_inuse);
 	if (vdebt && vbudget > 0) {
 		u64 delta = min_t(u64, vbudget, vdebt);
 		u64 abs_delta = min(cost_to_abs_cost(delta, hw_inuse),
-				    abs_vdebt);
+				    iocg->abs_vdebt);
 
 		atomic64_add(delta, &iocg->vtime);
 		atomic64_add(delta, &iocg->done_vtime);
-		atomic64_sub(abs_delta, &iocg->abs_vdebt);
-		if (WARN_ON_ONCE(atomic64_read(&iocg->abs_vdebt) < 0))
-			atomic64_set(&iocg->abs_vdebt, 0);
+		iocg->abs_vdebt -= abs_delta;
 	}
 
 	/*
@@ -1222,12 +1219,18 @@ static bool iocg_kick_delay(struct ioc_g
 	u64 expires, oexpires;
 	u32 hw_inuse;
 
+	lockdep_assert_held(&iocg->waitq.lock);
+
 	/* debt-adjust vtime */
 	current_hweight(iocg, NULL, &hw_inuse);
-	vtime += abs_cost_to_cost(atomic64_read(&iocg->abs_vdebt), hw_inuse);
+	vtime += abs_cost_to_cost(iocg->abs_vdebt, hw_inuse);
 
-	/* clear or maintain depending on the overage */
-	if (time_before_eq64(vtime, now->vnow)) {
+	/*
+	 * Clear or maintain depending on the overage. Non-zero vdebt is what
+	 * guarantees that @iocg is online and future iocg_kick_delay() will
+	 * clear use_delay. Don't leave it on when there's no vdebt.
+	 */
+	if (!iocg->abs_vdebt || time_before_eq64(vtime, now->vnow)) {
 		blkcg_clear_delay(blkg);
 		return false;
 	}
@@ -1261,9 +1264,12 @@ static enum hrtimer_restart iocg_delay_t
 {
 	struct ioc_gq *iocg = container_of(timer, struct ioc_gq, delay_timer);
 	struct ioc_now now;
+	unsigned long flags;
 
+	spin_lock_irqsave(&iocg->waitq.lock, flags);
 	ioc_now(iocg->ioc, &now);
 	iocg_kick_delay(iocg, &now, 0);
+	spin_unlock_irqrestore(&iocg->waitq.lock, flags);
 
 	return HRTIMER_NORESTART;
 }
@@ -1371,14 +1377,13 @@ static void ioc_timer_fn(struct timer_li
 	 * should have woken up in the last period and expire idle iocgs.
 	 */
 	list_for_each_entry_safe(iocg, tiocg, &ioc->active_iocgs, active_list) {
-		if (!waitqueue_active(&iocg->waitq) &&
-		    !atomic64_read(&iocg->abs_vdebt) && !iocg_is_idle(iocg))
+		if (!waitqueue_active(&iocg->waitq) && iocg->abs_vdebt &&
+		    !iocg_is_idle(iocg))
 			continue;
 
 		spin_lock(&iocg->waitq.lock);
 
-		if (waitqueue_active(&iocg->waitq) ||
-		    atomic64_read(&iocg->abs_vdebt)) {
+		if (waitqueue_active(&iocg->waitq) || iocg->abs_vdebt) {
 			/* might be oversleeping vtime / hweight changes, kick */
 			iocg_kick_waitq(iocg, &now);
 			iocg_kick_delay(iocg, &now, 0);
@@ -1721,28 +1726,49 @@ static void ioc_rqos_throttle(struct rq_
 	 * tests are racy but the races aren't systemic - we only miss once
 	 * in a while which is fine.
 	 */
-	if (!waitqueue_active(&iocg->waitq) &&
-	    !atomic64_read(&iocg->abs_vdebt) &&
+	if (!waitqueue_active(&iocg->waitq) && !iocg->abs_vdebt &&
 	    time_before_eq64(vtime + cost, now.vnow)) {
 		iocg_commit_bio(iocg, bio, cost);
 		return;
 	}
 
 	/*
-	 * We're over budget.  If @bio has to be issued regardless,
-	 * remember the abs_cost instead of advancing vtime.
-	 * iocg_kick_waitq() will pay off the debt before waking more IOs.
+	 * We activated above but w/o any synchronization. Deactivation is
+	 * synchronized with waitq.lock and we won't get deactivated as long
+	 * as we're waiting or has debt, so we're good if we're activated
+	 * here. In the unlikely case that we aren't, just issue the IO.
+	 */
+	spin_lock_irq(&iocg->waitq.lock);
+
+	if (unlikely(list_empty(&iocg->active_list))) {
+		spin_unlock_irq(&iocg->waitq.lock);
+		iocg_commit_bio(iocg, bio, cost);
+		return;
+	}
+
+	/*
+	 * We're over budget. If @bio has to be issued regardless, remember
+	 * the abs_cost instead of advancing vtime. iocg_kick_waitq() will pay
+	 * off the debt before waking more IOs.
+	 *
 	 * This way, the debt is continuously paid off each period with the
-	 * actual budget available to the cgroup.  If we just wound vtime,
-	 * we would incorrectly use the current hw_inuse for the entire
-	 * amount which, for example, can lead to the cgroup staying
-	 * blocked for a long time even with substantially raised hw_inuse.
+	 * actual budget available to the cgroup. If we just wound vtime, we
+	 * would incorrectly use the current hw_inuse for the entire amount
+	 * which, for example, can lead to the cgroup staying blocked for a
+	 * long time even with substantially raised hw_inuse.
+	 *
+	 * An iocg with vdebt should stay online so that the timer can keep
+	 * deducting its vdebt and [de]activate use_delay mechanism
+	 * accordingly. We don't want to race against the timer trying to
+	 * clear them and leave @iocg inactive w/ dangling use_delay heavily
+	 * penalizing the cgroup and its descendants.
 	 */
 	if (bio_issue_as_root_blkg(bio) || fatal_signal_pending(current)) {
-		atomic64_add(abs_cost, &iocg->abs_vdebt);
+		iocg->abs_vdebt += abs_cost;
 		if (iocg_kick_delay(iocg, &now, cost))
 			blkcg_schedule_throttle(rqos->q,
 					(bio->bi_opf & REQ_SWAP) == REQ_SWAP);
+		spin_unlock_irq(&iocg->waitq.lock);
 		return;
 	}
 
@@ -1759,20 +1785,6 @@ static void ioc_rqos_throttle(struct rq_
 	 * All waiters are on iocg->waitq and the wait states are
 	 * synchronized using waitq.lock.
 	 */
-	spin_lock_irq(&iocg->waitq.lock);
-
-	/*
-	 * We activated above but w/o any synchronization.  Deactivation is
-	 * synchronized with waitq.lock and we won't get deactivated as
-	 * long as we're waiting, so we're good if we're activated here.
-	 * In the unlikely case that we are deactivated, just issue the IO.
-	 */
-	if (unlikely(list_empty(&iocg->active_list))) {
-		spin_unlock_irq(&iocg->waitq.lock);
-		iocg_commit_bio(iocg, bio, cost);
-		return;
-	}
-
 	init_waitqueue_func_entry(&wait.wait, iocg_wake_fn);
 	wait.wait.private = current;
 	wait.bio = bio;
@@ -1804,6 +1816,7 @@ static void ioc_rqos_merge(struct rq_qos
 	struct ioc_now now;
 	u32 hw_inuse;
 	u64 abs_cost, cost;
+	unsigned long flags;
 
 	/* bypass if disabled or for root cgroup */
 	if (!ioc->enabled || !iocg->level)
@@ -1823,15 +1836,28 @@ static void ioc_rqos_merge(struct rq_qos
 		iocg->cursor = bio_end;
 
 	/*
-	 * Charge if there's enough vtime budget and the existing request
-	 * has cost assigned.  Otherwise, account it as debt.  See debt
-	 * handling in ioc_rqos_throttle() for details.
+	 * Charge if there's enough vtime budget and the existing request has
+	 * cost assigned.
 	 */
 	if (rq->bio && rq->bio->bi_iocost_cost &&
-	    time_before_eq64(atomic64_read(&iocg->vtime) + cost, now.vnow))
+	    time_before_eq64(atomic64_read(&iocg->vtime) + cost, now.vnow)) {
 		iocg_commit_bio(iocg, bio, cost);
-	else
-		atomic64_add(abs_cost, &iocg->abs_vdebt);
+		return;
+	}
+
+	/*
+	 * Otherwise, account it as debt if @iocg is online, which it should
+	 * be for the vast majority of cases. See debt handling in
+	 * ioc_rqos_throttle() for details.
+	 */
+	spin_lock_irqsave(&iocg->waitq.lock, flags);
+	if (likely(!list_empty(&iocg->active_list))) {
+		iocg->abs_vdebt += abs_cost;
+		iocg_kick_delay(iocg, &now, cost);
+	} else {
+		iocg_commit_bio(iocg, bio, cost);
+	}
+	spin_unlock_irqrestore(&iocg->waitq.lock, flags);
 }
 
 static void ioc_rqos_done_bio(struct rq_qos *rqos, struct bio *bio)
@@ -2001,7 +2027,6 @@ static void ioc_pd_init(struct blkg_poli
 	iocg->ioc = ioc;
 	atomic64_set(&iocg->vtime, now.vnow);
 	atomic64_set(&iocg->done_vtime, now.vnow);
-	atomic64_set(&iocg->abs_vdebt, 0);
 	atomic64_set(&iocg->active_period, atomic64_read(&ioc->cur_period));
 	INIT_LIST_HEAD(&iocg->active_list);
 	iocg->hweight_active = HWEIGHT_WHOLE;
--- a/tools/cgroup/iocost_monitor.py
+++ b/tools/cgroup/iocost_monitor.py
@@ -159,7 +159,12 @@ class IocgStat:
         else:
             self.inflight_pct = 0
 
-        self.debt_ms = iocg.abs_vdebt.counter.value_() / VTIME_PER_USEC / 1000
+        # vdebt used to be an atomic64_t and is now u64, support both
+        try:
+            self.debt_ms = iocg.abs_vdebt.counter.value_() / VTIME_PER_USEC / 1000
+        except:
+            self.debt_ms = iocg.abs_vdebt.value_() / VTIME_PER_USEC / 1000
+
         self.use_delay = blkg.use_delay.counter.value_()
         self.delay_ms = blkg.delay_nsec.counter.value_() / 1_000_000
 


