Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE8B2EFD04
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 03:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbhAICHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 21:07:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbhAICHD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 21:07:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5449B23A9B;
        Sat,  9 Jan 2021 02:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610157953;
        bh=JV1534qKdNdXiG675FUGgE+Nz8wK9zsXkCHXh1nZizc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drl43+zVX0KqpUq9BrF1GpSdmkuWQMlFTKvcGqHkgii0KRulkbRdjzebacM9Miyl6
         FThUSOKZeANzDjugEfkods3Xf5dkLBchzWYJW/18kOvu0llCnYuhdn6MxF998D45nN
         zvB+WN0eDwe3Jv8aspSBSUovfkhSb128/5Rvj+83UnNCcURPW/wgiJ6emsGfdthCQ7
         FlqH3yJm46O43uzA0XSOCQtH0fJHWhSXQEeVJtJLJyBR6Xz4r/HAfmHkP2JxL1H8k1
         0LdMFMl0V6QUcQXkjBYRxuJ2YsLB3ugMVDqgGxQorRoIJNEaGOAB4paI5Z5srdTHCe
         1KAhk2pA/vtHQ==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [RFC PATCH 5/8] entry: Explicitly flush pending rcuog wakeup before last rescheduling points
Date:   Sat,  9 Jan 2021 03:05:33 +0100
Message-Id: <20210109020536.127953-6-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109020536.127953-1-frederic@kernel.org>
References: <20210109020536.127953-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following the idle loop model, cleanly check for pending rcuog wakeup
before the last rescheduling point on resuming to user mode. This
way we can avoid to do it from rcu_user_enter() with the last resort
self-IPI hack that enforces rescheduling.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar<mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/entry/common.c |  6 ++++++
 kernel/rcu/tree.c     | 12 +++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index 378341642f94..8f3292b5f9b7 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -178,6 +178,9 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 		/* Architecture specific TIF work */
 		arch_exit_to_user_mode_work(regs, ti_work);
 
+		/* Check if any of the above work has queued a deferred wakeup */
+		rcu_nocb_flush_deferred_wakeup();
+
 		/*
 		 * Disable interrupts and reevaluate the work flags as they
 		 * might have changed while interrupts and preemption was
@@ -197,6 +200,9 @@ static void exit_to_user_mode_prepare(struct pt_regs *regs)
 
 	lockdep_assert_irqs_disabled();
 
+	/* Flush pending rcuog wakeup before the last need_resched() check */
+	rcu_nocb_flush_deferred_wakeup();
+
 	if (unlikely(ti_work & EXIT_TO_USER_MODE_WORK))
 		ti_work = exit_to_user_mode_loop(regs, ti_work);
 
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 2920dfc9f58c..3c4c0d5cea65 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -705,12 +705,14 @@ noinstr void rcu_user_enter(void)
 
 	lockdep_assert_irqs_disabled();
 	/*
-	 * We may be past the last rescheduling opportunity in the entry code.
-	 * Trigger a self IPI that will fire and reschedule once we resume to
-	 * user/guest mode.
+	 * Other than generic entry implementation, we may be past the last
+	 * rescheduling opportunity in the entry code. Trigger a self IPI
+	 * that will fire and reschedule once we resume in user/guest mode.
 	 */
-	if (do_nocb_deferred_wakeup(rdp) && need_resched())
-		irq_work_queue(this_cpu_ptr(&late_wakeup_work));
+	if (!IS_ENABLED(CONFIG_GENERIC_ENTRY) || (current->flags & PF_VCPU)) {
+		if (do_nocb_deferred_wakeup(rdp) && need_resched())
+			irq_work_queue(this_cpu_ptr(&late_wakeup_work));
+	}
 
 	rcu_eqs_enter(true);
 }
-- 
2.25.1

