Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F04031686B
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 14:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhBJNyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 08:54:39 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:59984 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbhBJNyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 08:54:18 -0500
Date:   Wed, 10 Feb 2021 13:53:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612965212;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gu+rSzKDLRHILgIbO0+dMVAtnPwGKMpYH/OzZEr+IT0=;
        b=Xwtk+PtmyWxPKssQEW8W/U/TIHIT6D1C49w3e2EEu1bv4/iHQNF2921aZbAwyYPfX3O86i
        Ou2AkzhXib9zaZ50xFjC+LEiXIJPo8g4gEMn2o+FstRBltC0Cw9o4f8ZwdUaIoy5dQq/wW
        akWl3EhDsqOb+FrN1QNtgwv6p8+toJ6j5NtzUwvP64f73MELAtigmvMMls2+45Ln2JRX1K
        YM/j2RU43sS9DqtjZD7D/HarYDByQcN02w1I6i1ihFKgxpRCrpa61qjNvAzSNXfs2BOmTq
        Zgc66q6Pg7zjYbIDPnt7+yix7sNxblQ+9C3XI32PkLjmOrNXYHjcfM2crx6wQQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612965212;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gu+rSzKDLRHILgIbO0+dMVAtnPwGKMpYH/OzZEr+IT0=;
        b=TD/zyN5oAH2/IpxoneEPUHVZPQnSA7pwAZEcD6603X0aIcDaZ88j0tPrz04PEGrnpQm1Q3
        zRPafHJu7c9HNNDQ==
From:   "tip-bot2 for Frederic Weisbecker" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/core] entry: Explicitly flush pending rcuog wakeup before
 last rescheduling point
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210131230548.32970-5-frederic@kernel.org>
References: <20210131230548.32970-5-frederic@kernel.org>
MIME-Version: 1.0
Message-ID: <161296521206.23325.9333553348675177477.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/core branch of tip:

Commit-ID:     2c910e0753dc424dfdeb1f8e230ad8f187a744a7
Gitweb:        https://git.kernel.org/tip/2c910e0753dc424dfdeb1f8e230ad8f187a744a7
Author:        Frederic Weisbecker <frederic@kernel.org>
AuthorDate:    Mon, 01 Feb 2021 00:05:47 +01:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Wed, 10 Feb 2021 14:44:51 +01:00

entry: Explicitly flush pending rcuog wakeup before last rescheduling point

Following the idle loop model, cleanly check for pending rcuog wakeup
before the last rescheduling point on resuming to user mode. This
way we can avoid to do it from rcu_user_enter() with the last resort
self-IPI hack that enforces rescheduling.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210131230548.32970-5-frederic@kernel.org
---
 kernel/entry/common.c |  7 +++++++
 kernel/rcu/tree.c     | 12 +++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index f09cae3..8442e5c 100644
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
index 4b1e5bd..2ebc211 100644
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
