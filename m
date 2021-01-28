Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EFD307C21
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbhA1RUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:20:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232812AbhA1RSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 12:18:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D17A64E25;
        Thu, 28 Jan 2021 17:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611853985;
        bh=ODAPEU8mEkBB577u6jw8N9nhc90ro0nsWiFFejTP+10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=edcS/ieiloWpWb2wOXM8fzMvZxrDoeqiV0BFb41qeKSxFWhHrLSR7BmVuzcICKnON
         GOE49ugdcWX2G0x15yzrOjjHAK/eq6hYCLu0xlnhva9gh7XuJJy5AWYxxmdwf9rSUT
         znIA7laVeOmHjPu5N4D5Ek2udngOaJl7oOfeQrVLIeAPm4ksWCLkZHf04LM/UQITtm
         RPXlf0pmQh89LGMxKsOuvvJD2WYbB/WDbdEzBzLVEVIfbemKBw0VFtKtsuDEwsXZEJ
         G84sqPeJjUBtsLCGdTEOq804DkQj6e11AFuL/Q9TBR2qq2qYy4z7D+aNK1rblm2wPc
         3ZaA/woMEOldw==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 15/16] rcu/nocb: Prepare for finegrained deferred wakeup
Date:   Thu, 28 Jan 2021 18:12:21 +0100
Message-Id: <20210128171222.131380-16-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128171222.131380-1-frederic@kernel.org>
References: <20210128171222.131380-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Provide a way to tune the deferred wakeup level we want to perform from
a safe wakeup point. Currently those sites are:

* nocb_timer
* user/idle/guest entry
* CPU down
* softirq/rcuc

All of these sites perform the wake up for both RCU_NOCB_WAKE and
RCU_NOCB_WAKE_FORCE.

In order to merge nocb_timer and nocb_bypass_timer together, we plan to
add a new RCU_NOCB_WAKE_BYPASS that really want to be deferred until
a timer fires so that we don't wake up the NOCB-gp kthread too early.

To prepare for that, integrate a wake up level/limit that a callsite is
deemed to perform.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
---
 kernel/rcu/tree.c        |  2 +-
 kernel/rcu/tree.h        |  2 +-
 kernel/rcu/tree_plugin.h | 15 ++++++++-------
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index f74a9ba62c12..e31b1d8fde93 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3813,7 +3813,7 @@ static int rcu_pending(int user)
 	check_cpu_stall(rdp);
 
 	/* Does this CPU need a deferred NOCB wakeup? */
-	if (rcu_nocb_need_deferred_wakeup(rdp))
+	if (rcu_nocb_need_deferred_wakeup(rdp, RCU_NOCB_WAKE))
 		return 1;
 
 	/* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index b280a843bd2c..2510e86265c1 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -433,7 +433,7 @@ static bool rcu_nocb_try_bypass(struct rcu_data *rdp, struct rcu_head *rhp,
 				bool *was_alldone, unsigned long flags);
 static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_empty,
 				 unsigned long flags);
-static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
+static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp, int level);
 static bool do_nocb_deferred_wakeup(struct rcu_data *rdp);
 static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_cpu_nocb_kthread(int cpu);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index b1f76f341c66..162dda3714f1 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2354,13 +2354,14 @@ static int rcu_nocb_cb_kthread(void *arg)
 }
 
 /* Is a deferred wakeup of rcu_nocb_kthread() required? */
-static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
+static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp, int level)
 {
-	return READ_ONCE(rdp->nocb_defer_wakeup) > RCU_NOCB_WAKE_NOT;
+	return READ_ONCE(rdp->nocb_defer_wakeup) >= level;
 }
 
 /* Do a deferred wakeup of rcu_nocb_kthread(). */
-static bool do_nocb_deferred_wakeup_common(struct rcu_data *rdp)
+static bool do_nocb_deferred_wakeup_common(struct rcu_data *rdp,
+					   int level)
 {
 	unsigned long flags;
 	int ndw;
@@ -2369,7 +2370,7 @@ static bool do_nocb_deferred_wakeup_common(struct rcu_data *rdp)
 
 	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
 
-	if (!rcu_nocb_need_deferred_wakeup(rdp_gp)) {
+	if (!rcu_nocb_need_deferred_wakeup(rdp_gp, level)) {
 		raw_spin_unlock_irqrestore(&rdp_gp->nocb_gp_lock, flags);;
 		return false;
 	}
@@ -2385,7 +2386,7 @@ static void do_nocb_deferred_wakeup_timer(struct timer_list *t)
 {
 	struct rcu_data *rdp = from_timer(rdp, t, nocb_timer);
 
-	do_nocb_deferred_wakeup_common(rdp);
+	do_nocb_deferred_wakeup_common(rdp, RCU_NOCB_WAKE);
 }
 
 /*
@@ -2398,8 +2399,8 @@ static bool do_nocb_deferred_wakeup(struct rcu_data *rdp)
 	if (!rdp->nocb_gp_rdp)
 		return false;
 
-	if (rcu_nocb_need_deferred_wakeup(rdp->nocb_gp_rdp))
-		return do_nocb_deferred_wakeup_common(rdp);
+	if (rcu_nocb_need_deferred_wakeup(rdp->nocb_gp_rdp, RCU_NOCB_WAKE))
+		return do_nocb_deferred_wakeup_common(rdp, RCU_NOCB_WAKE);
 	return false;
 }
 
-- 
2.25.1

