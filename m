Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2086D309F5A
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 00:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhAaXHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 18:07:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhAaXGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 31 Jan 2021 18:06:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00B5764E33;
        Sun, 31 Jan 2021 23:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612134363;
        bh=cKuICB7wZoPDGA7Mqm0x9IOcUKhIiHZ3nTKrwqMxxik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuEbr4fa2rG04PBHHnz1Lf542nz9e3+9+RmuipLguO/8uJJLOcDB114AB1BNTENW9
         w+8+XI7NMUYcNGr8vXaUg3Rg5f6nE284Rby0gAU61h1eW6EFgkvHWeKsKTqV8kwGUn
         eqAumR5uTcdFvlt5V7Ey1aRahV6b1TKuB7kAzV3G4w56CVTMezjjClCqHmiHV62b7F
         YWwdILLmMjnJf3UNqer9gbGF+v3Z8pBJZjOrPKbZx+txycf+b/Nqh+0BRcfB9PeSNj
         dvyVObBFamVm+AWL3yW2xdWVw3Jcgrs0Pdl5DQeGH402dT0gadR6RT4K24iWE6RifC
         KLNqI6mBQVndQ==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4/5] entry: Explicitly flush pending rcuog wakeup before last rescheduling point
Date:   Mon,  1 Feb 2021 00:05:47 +0100
Message-Id: <20210131230548.32970-5-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210131230548.32970-1-frederic@kernel.org>
References: <20210131230548.32970-1-frederic@kernel.org>
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
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/entry/common.c |  7 +++++++
 kernel/rcu/tree.c     | 12 +++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index 378341642f94..7c61460a0867 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -184,6 +184,10 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 		 * enabled above.
 		 */
 		local_irq_disable_exit_to_user();
+
+		/* Check if any of the above work has queued a deferred wakeup */
+		rcu_nocb_flush_deferred_wakeup();
+
 		ti_work = READ_ONCE(current_thread_info()->flags);
 	}
 
@@ -197,6 +201,9 @@ static void exit_to_user_mode_prepare(struct pt_regs *regs)
 
 	lockdep_assert_irqs_disabled();
 
+	/* Flush pending rcuog wakeup before the last need_resched() check */
+	rcu_nocb_flush_deferred_wakeup();
+
 	if (unlikely(ti_work & EXIT_TO_USER_MODE_WORK))
 		ti_work = exit_to_user_mode_loop(regs, ti_work);
 
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 4b1e5bd16492..2ebc211fffcb 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -707,13 +707,15 @@ noinstr void rcu_user_enter(void)
 	lockdep_assert_irqs_disabled();
 
 	/*
-	 * We may be past the last rescheduling opportunity in the entry code.
-	 * Trigger a self IPI that will fire and reschedule once we resume to
-	 * user/guest mode.
+	 * Other than generic entry implementation, we may be past the last
+	 * rescheduling opportunity in the entry code. Trigger a self IPI
+	 * that will fire and reschedule once we resume in user/guest mode.
 	 */
 	instrumentation_begin();
-	if (do_nocb_deferred_wakeup(rdp) && need_resched())
-		irq_work_queue(this_cpu_ptr(&late_wakeup_work));
+	if (!IS_ENABLED(CONFIG_GENERIC_ENTRY) || (current->flags & PF_VCPU)) {
+		if (do_nocb_deferred_wakeup(rdp) && need_resched())
+			irq_work_queue(this_cpu_ptr(&late_wakeup_work));
+	}
 	instrumentation_end();
 
 	rcu_eqs_enter(true);
-- 
2.25.1

