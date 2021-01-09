Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B352EFCFC
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 03:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbhAICG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 21:06:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbhAICG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 21:06:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDFDC23AA8;
        Sat,  9 Jan 2021 02:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610157946;
        bh=1SrBTlbPzwqTruhS60yTCVOH5SjTUATV2RzaG5lWSgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=td22Phc4eRAflXnP8TT3AyoVYzQq7GiKGreDRwkxOaEMscBkDWrkwDOM79Lor+6oS
         e9kc/bsLYoapFPi5yCnaYSTG69IFjJYpmpPmITqCH8oPuSnwfp42rLddHTemL5jECF
         iM7anToMEedQpVqNK+rPEZnHZzix32DV3gyOK+9Qb8i2qFltnPfxH26sG/nuNfytH9
         t9DcRgeGyBRVcblXAnquvpqGu0qwpsLB27r7VH77+Pvn43LRDi1tRxmEanFf1NIGB5
         KWqcCTLqE+Knmxj4wTOpjYmxpvUC9icfgkbiExLdD3/arta4/V9BpuYrqy0mjXJhAA
         Mp7hAzBHnIqhA==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [RFC PATCH 2/8] rcu: Pull deferred rcuog wake up to rcu_eqs_enter() callers
Date:   Sat,  9 Jan 2021 03:05:30 +0100
Message-Id: <20210109020536.127953-3-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109020536.127953-1-frederic@kernel.org>
References: <20210109020536.127953-1-frederic@kernel.org>
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
Cc: Ingo Molnar<mingo@kernel.org>
---
 kernel/rcu/tree.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index fef90c467670..b9fff18d14d9 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -643,7 +643,6 @@ static noinstr void rcu_eqs_enter(bool user)
 	instrumentation_begin();
 	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, atomic_read(&rdp->dynticks));
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
-	do_nocb_deferred_wakeup(rdp);
 	rcu_prepare_for_idle();
 	rcu_preempt_deferred_qs(current);
 
@@ -671,7 +670,10 @@ static noinstr void rcu_eqs_enter(bool user)
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
@@ -690,7 +692,10 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
  */
 noinstr void rcu_user_enter(void)
 {
+	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
+
 	lockdep_assert_irqs_disabled();
+	do_nocb_deferred_wakeup(rdp);
 	rcu_eqs_enter(true);
 }
 #endif /* CONFIG_NO_HZ_FULL */
-- 
2.25.1

