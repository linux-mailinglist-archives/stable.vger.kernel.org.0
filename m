Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D7631DA13
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 14:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbhBQNST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 08:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbhBQNSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 08:18:14 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B15C061756;
        Wed, 17 Feb 2021 05:17:33 -0800 (PST)
Date:   Wed, 17 Feb 2021 13:17:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1613567851;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ApmEGfWSdfLwWtPCWhMvgsk3uqD3dLDXeXnwrO8kjHY=;
        b=Aw7cXupl09o20sVipGeaahHLeDi/BBQ1hIfPXe1fwkJYflWd+VgZtXwlkzb4vQraRI1VcW
        eI/ydAVNk2SOrYc7Mhqr2sJhzkSEJxbI3+0hYi+/JeiEMWKfqcqw8XqiGUVQrwDzRz283H
        CZDbGMaee+VdaEPITzy7wEtUrg4QPvEvrGcQjDhWvAGJLTeCdcgkHxzlK3sO1cLfnkYTj+
        xW5Lmij6F93PxYgomhtG67wqHoQb41kjK2Nce8f+WjBYGJ4iyD2Ru3xasn0eiIpwOmjZwG
        RlIEQx6fjWJyog+VoBmthu5HgsvQHxDViDf5HyxMao6eT3xaWf02bU6Dmtl0mw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1613567851;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ApmEGfWSdfLwWtPCWhMvgsk3uqD3dLDXeXnwrO8kjHY=;
        b=SrBFFLmfyQxalaT0ThcifE8KpyQwJjOiRJ9boGAsKUOZ2CxTSeplWVyUcZa8Ao5ZtVq1KH
        saUkt1Gs4Hgd/LCg==
From:   "tip-bot2 for Frederic Weisbecker" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/core] entry: Explicitly flush pending rcuog wakeup before
 last rescheduling point
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210131230548.32970-5-frederic@kernel.org>
References: <20210131230548.32970-5-frederic@kernel.org>
MIME-Version: 1.0
Message-ID: <161356785106.20312.6122282234763949644.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/core branch of tip:

Commit-ID:     47b8ff194c1fd73d58dc339b597d466fe48c8958
Gitweb:        https://git.kernel.org/tip/47b8ff194c1fd73d58dc339b597d466fe48c8958
Author:        Frederic Weisbecker <frederic@kernel.org>
AuthorDate:    Mon, 01 Feb 2021 00:05:47 +01:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Wed, 17 Feb 2021 14:12:43 +01:00

entry: Explicitly flush pending rcuog wakeup before last rescheduling point

Following the idle loop model, cleanly check for pending rcuog wakeup
before the last rescheduling point on resuming to user mode. This
way we can avoid to do it from rcu_user_enter() with the last resort
self-IPI hack that enforces rescheduling.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
