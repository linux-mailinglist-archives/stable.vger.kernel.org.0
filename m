Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953443222F2
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 01:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhBWALB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 19:11:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230135AbhBWAK7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 19:10:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 796A964E41;
        Tue, 23 Feb 2021 00:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614039019;
        bh=B0nVAxpVgwOX731NwahddkyjFhakiND+1zYrY9l5YD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNf/m4X2qE6nOwKC5vYG15+vodFaRNCuEEkao5WfzG+htJjDLu74ZQKQLwJbAUOFQ
         X5lNcmaPYMgqTFOV6LMAO03/Dv3DnusKU8U5TeHTWHjAQTY5Gc8vtFMfNSnLrVF2Up
         kzZ0pVL3ttA/4B4FGEJb1hQMuorbREB3ernqJIZyyq7gs1mQ8DFRYo5gYa+4eGEeaY
         c2ZSJAgkcK5E3R6UeSXyoT0Gj7GwBcTQaNJmlXU98PPYsfW5p15+TXNkslo50si33b
         jmMpGhMOqYvUgn6SgTM0xbJdy14XIgBZKfxUlhL49t5uccHLeWjGMHSoXS09MSCNO+
         KWh0F3G1Unuag==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 01/13] rcu/nocb: Fix potential missed nocb_timer rearm
Date:   Tue, 23 Feb 2021 01:09:59 +0100
Message-Id: <20210223001011.127063-2-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223001011.127063-1-frederic@kernel.org>
References: <20210223001011.127063-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Two situations can cause a missed nocb timer rearm:

1) rdp(CPU A) queues its nocb timer. The grace period elapses before
   the timer get a chance to fire. The nocb_gp kthread is awaken by
   rdp(CPU B). The nocb_cb kthread for rdp(CPU A) is awaken and
   process the callbacks, again before the nocb_timer for CPU A get a
   chance to fire. rdp(CPU A) queues a callback and wakes up nocb_gp
   kthread, cancelling the pending nocb_timer without resetting the
   corresponding nocb_defer_wakeup.

2) The "nocb_bypass_timer" ends up calling wake_nocb_gp() which deletes
   the pending "nocb_timer" (note they are not the same timers) for the
   given rdp without resetting the matching state stored in nocb_defer
   wakeup.

On both situations, a future call_rcu() on that rdp may be fooled and
think the timer is armed when it's not, missing a deferred nocb_gp
wakeup.

Case 1) is very unlikely due to timing constraint (the timer fires after
1 jiffy) but still possible in theory. Case 2) is more likely to happen.
But in any case such scenario require the CPU to spend a long time
within a kernel thread without exiting to idle or user space, which is
a pretty exotic behaviour.

Fix this with resetting rdp->nocb_defer_wakeup everytime we disarm the
timer.

Fixes: d1b222c6be1f (rcu/nocb: Add bypass callback queueing)
Cc: Stable <stable@vger.kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/rcu/tree_plugin.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 2ec9d7f55f99..dd0dc66c282d 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1720,7 +1720,11 @@ static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
 		rcu_nocb_unlock_irqrestore(rdp, flags);
 		return false;
 	}
-	del_timer(&rdp->nocb_timer);
+
+	if (READ_ONCE(rdp->nocb_defer_wakeup) > RCU_NOCB_WAKE_NOT) {
+		WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
+		del_timer(&rdp->nocb_timer);
+	}
 	rcu_nocb_unlock_irqrestore(rdp, flags);
 	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
 	if (force || READ_ONCE(rdp_gp->nocb_gp_sleep)) {
@@ -2349,7 +2353,6 @@ static bool do_nocb_deferred_wakeup_common(struct rcu_data *rdp)
 		return false;
 	}
 	ndw = READ_ONCE(rdp->nocb_defer_wakeup);
-	WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
 	ret = wake_nocb_gp(rdp, ndw == RCU_NOCB_WAKE_FORCE, flags);
 	trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("DeferredWake"));
 
-- 
2.25.1

