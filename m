Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D72329189
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242298AbhCAU1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:27:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242980AbhCAUVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:21:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA027653F7;
        Mon,  1 Mar 2021 18:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621885;
        bh=xl0JcdjQOWgQaG+smQNz32yLrDoXo1nF7/FpfEsKmaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tImNKuyd3Y+G18OzNa2C5PNlzTzonOfzh6sCEN86YdRhC/1Iqc/TH2/AmN0dbFBe+
         3Dyaiz3gam+U77/xjgkZvxYV8Kq4Iv4CctDpgXyIQAdoaAPu1JDw5ww150Gws1Wv6P
         xSAIxqUYV304S9kGZ/AI/0uGY9x1Zva572L/ZCEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frederic Weisbecker <frederic@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.11 679/775] entry: Explicitly flush pending rcuog wakeup before last rescheduling point
Date:   Mon,  1 Mar 2021 17:14:07 +0100
Message-Id: <20210301161234.938370886@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

commit 47b8ff194c1fd73d58dc339b597d466fe48c8958 upstream.

Following the idle loop model, cleanly check for pending rcuog wakeup
before the last rescheduling point on resuming to user mode. This
way we can avoid to do it from rcu_user_enter() with the last resort
self-IPI hack that enforces rescheduling.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210131230548.32970-5-frederic@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/entry/common.c |    7 +++++++
 kernel/rcu/tree.c     |   12 +++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -184,6 +184,10 @@ static unsigned long exit_to_user_mode_l
 		 * enabled above.
 		 */
 		local_irq_disable_exit_to_user();
+
+		/* Check if any of the above work has queued a deferred wakeup */
+		rcu_nocb_flush_deferred_wakeup();
+
 		ti_work = READ_ONCE(current_thread_info()->flags);
 	}
 
@@ -197,6 +201,9 @@ static void exit_to_user_mode_prepare(st
 
 	lockdep_assert_irqs_disabled();
 
+	/* Flush pending rcuog wakeup before the last need_resched() check */
+	rcu_nocb_flush_deferred_wakeup();
+
 	if (unlikely(ti_work & EXIT_TO_USER_MODE_WORK))
 		ti_work = exit_to_user_mode_loop(regs, ti_work);
 
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


