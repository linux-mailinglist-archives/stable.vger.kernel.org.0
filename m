Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103D432E8EF
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbhCEM3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:29:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:38480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230491AbhCEM3X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:29:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B7C165019;
        Fri,  5 Mar 2021 12:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947363;
        bh=mUUw0aQtWnNeSeIwEvMCzhEijvdKxmJQJJlHsrePJPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7+07604eREO6Tur16919DS+WP48wTHXsrcjymIGEb0Yu0VOzNIjXQyvh7iiu2da7
         W0g8zxddMSdNSwnUsuex71f7JuCfgbzGdWtAwiFy0xkL1sxyhjl1tNgz6TmdGO7n/K
         lS1QH7BspX3lQ0hWPHfcga5TecG9jY2KE6siVC5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frederic Weisbecker <frederic@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/102] entry: Explicitly flush pending rcuog wakeup before last rescheduling point
Date:   Fri,  5 Mar 2021 13:20:57 +0100
Message-Id: <20210305120905.162067333@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 47b8ff194c1fd73d58dc339b597d466fe48c8958 ]

Following the idle loop model, cleanly check for pending rcuog wakeup
before the last rescheduling point on resuming to user mode. This
way we can avoid to do it from rcu_user_enter() with the last resort
self-IPI hack that enforces rescheduling.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210131230548.32970-5-frederic@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/entry/common.c |  7 +++++++
 kernel/rcu/tree.c     | 12 +++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index e9e2df3f3f9e..fcc7e93401d5 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -174,6 +174,10 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 		 * enabled above.
 		 */
 		local_irq_disable_exit_to_user();
+
+		/* Check if any of the above work has queued a deferred wakeup */
+		rcu_nocb_flush_deferred_wakeup();
+
 		ti_work = READ_ONCE(current_thread_info()->flags);
 	}
 
@@ -187,6 +191,9 @@ static void exit_to_user_mode_prepare(struct pt_regs *regs)
 
 	lockdep_assert_irqs_disabled();
 
+	/* Flush pending rcuog wakeup before the last need_resched() check */
+	rcu_nocb_flush_deferred_wakeup();
+
 	if (unlikely(ti_work & EXIT_TO_USER_MODE_WORK))
 		ti_work = exit_to_user_mode_loop(regs, ti_work);
 
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index f137a599941b..0d8a2e2df221 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -699,13 +699,15 @@ noinstr void rcu_user_enter(void)
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
2.30.1



