Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6E9309F55
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 00:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhAaXGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 18:06:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229646AbhAaXGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 31 Jan 2021 18:06:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C32164E2B;
        Sun, 31 Jan 2021 23:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612134356;
        bh=PHJ+cn82IwzdHiWA0YBzy3kVog5hf1vR0OxGqFUsMro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+ZaLC1tgFnyqsmBcWu0VpbE3pS9egdTcYMOex7SGIJkIe9z6TFcVbTRV5GNc+KQh
         dk23NUsVk+k5UEx5ex691cIX9ERner5o2g2Xiafakf3KgdS4FZetsMw7RnXG7gsetp
         r9XTQouHywhMAbt0Q65+GHR5JLtCwZoeC+IhJnzdRSCrWxCt0eaAPAJICMhdAhD2pF
         zuYnApLAYV/rdT22cQUbzQ+m4EibhHIGM3WJ5oglN1lpsyAS7tUs24mF43Fw1UKap7
         rEl+As5NcvyiKpfoK3/ICTqSXH2ELiP6DbmJo2R4VuOj+d5JRqyezF1xTCtefSwSQL
         KAxRW9O5fRQ4Q==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 1/5] rcu: Pull deferred rcuog wake up to rcu_eqs_enter() callers
Date:   Mon,  1 Feb 2021 00:05:44 +0100
Message-Id: <20210131230548.32970-2-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210131230548.32970-1-frederic@kernel.org>
References: <20210131230548.32970-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Deferred wakeup of rcuog kthreads upon RCU idle mode entry is going to
be handled differently whether initiated by idle, user or guest. Prepare
with pulling that control up to rcu_eqs_enter() callers.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
---
 kernel/rcu/tree.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 40e5e3dd253e..63032e5620b9 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -644,7 +644,6 @@ static noinstr void rcu_eqs_enter(bool user)
 	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, atomic_read(&rdp->dynticks));
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
 	rdp = this_cpu_ptr(&rcu_data);
-	do_nocb_deferred_wakeup(rdp);
 	rcu_prepare_for_idle();
 	rcu_preempt_deferred_qs(current);
 
@@ -672,7 +671,10 @@ static noinstr void rcu_eqs_enter(bool user)
  */
 void rcu_idle_enter(void)
 {
+	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
+
 	lockdep_assert_irqs_disabled();
+	do_nocb_deferred_wakeup(rdp);
 	rcu_eqs_enter(false);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
@@ -691,7 +693,14 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
  */
 noinstr void rcu_user_enter(void)
 {
+	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
+
 	lockdep_assert_irqs_disabled();
+
+	instrumentation_begin();
+	do_nocb_deferred_wakeup(rdp);
+	instrumentation_end();
+
 	rcu_eqs_enter(true);
 }
 #endif /* CONFIG_NO_HZ_FULL */
-- 
2.25.1

