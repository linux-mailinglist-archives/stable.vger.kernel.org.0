Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0352831DA15
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 14:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhBQNSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 08:18:21 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45144 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbhBQNSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 08:18:15 -0500
Date:   Wed, 17 Feb 2021 13:17:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1613567852;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TrF8V5XZ2BF2TROiVSzpaFKYFlOmQ/dwHfVGlesUwgs=;
        b=Z0Po6N5BsvXpsdtx0lc04m6k9S8tfGDm4i/xpK1rs0kf66m9qwB+ZZCkW76NdIWWdCbEL9
        rQa8jlaWqTBxn5gthlVYYxny45SlAd6iS4V2uyWpCda418xUUTPzpSqmzdRsOy6vXhOZTJ
        k7tsnobr0EI1+AAEDOZuqK1mpY9lWAwL4wXF6TlbMmH5glPNX07WExhyZhcQTmZYJyNQdU
        fjg+q0P/5dNpZ6mOHVuT16xPzAdiKPt4jv6nGkuCc+itnq6d/rRC1fDnAKjIBIE4t6lv1H
        rAnEgz9vshn13GK6m7y3wJ0JekZTn1GiPf4YIWky8oRO0P7EyUD/qc4bBqiK0Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1613567852;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TrF8V5XZ2BF2TROiVSzpaFKYFlOmQ/dwHfVGlesUwgs=;
        b=ylVhsX2ZP6Enpl5DYKZpA0v5tAz/NO9wuGoKtcIRx9n2b/xzhP6lBI0k0I1IQHIDYjLzsG
        VgG4gjCzfvYg0cDQ==
From:   "tip-bot2 for Frederic Weisbecker" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/core] rcu/nocb: Perform deferred wake up before last
 idle's need_resched() check
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210131230548.32970-3-frederic@kernel.org>
References: <20210131230548.32970-3-frederic@kernel.org>
MIME-Version: 1.0
Message-ID: <161356785161.20312.14972284804114619107.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/core branch of tip:

Commit-ID:     43789ef3f7d61aa7bed0cb2764e588fc990c30ef
Gitweb:        https://git.kernel.org/tip/43789ef3f7d61aa7bed0cb2764e588fc990c30ef
Author:        Frederic Weisbecker <frederic@kernel.org>
AuthorDate:    Mon, 01 Feb 2021 00:05:45 +01:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Wed, 17 Feb 2021 14:12:43 +01:00

rcu/nocb: Perform deferred wake up before last idle's need_resched() check

Entering RCU idle mode may cause a deferred wake up of an RCU NOCB_GP
kthread (rcuog) to be serviced.

Usually a local wake up happening while running the idle task is handled
in one of the need_resched() checks carefully placed within the idle
loop that can break to the scheduler.

Unfortunately the call to rcu_idle_enter() is already beyond the last
generic need_resched() check and we may halt the CPU with a resched
request unhandled, leaving the task hanging.

Fix this with splitting the rcuog wakeup handling from rcu_idle_enter()
and place it before the last generic need_resched() check in the idle
loop. It is then assumed that no call to call_rcu() will be performed
after that in the idle loop until the CPU is put in low power mode.

Fixes: 96d3fd0d315a (rcu: Break call_rcu() deadlock involving scheduler and perf)
Reported-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210131230548.32970-3-frederic@kernel.org
---
 include/linux/rcupdate.h | 2 ++
 kernel/rcu/tree.c        | 3 ---
 kernel/rcu/tree_plugin.h | 5 +++++
 kernel/sched/idle.c      | 1 +
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index fd02c5f..36c2119 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -110,8 +110,10 @@ static inline void rcu_user_exit(void) { }
 
 #ifdef CONFIG_RCU_NOCB_CPU
 void rcu_init_nohz(void);
+void rcu_nocb_flush_deferred_wakeup(void);
 #else /* #ifdef CONFIG_RCU_NOCB_CPU */
 static inline void rcu_init_nohz(void) { }
+static inline void rcu_nocb_flush_deferred_wakeup(void) { }
 #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
 
 /**
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 63032e5..82838e9 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -671,10 +671,7 @@ static noinstr void rcu_eqs_enter(bool user)
  */
 void rcu_idle_enter(void)
 {
-	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
-
 	lockdep_assert_irqs_disabled();
-	do_nocb_deferred_wakeup(rdp);
 	rcu_eqs_enter(false);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 7e291ce..d5b38c2 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2187,6 +2187,11 @@ static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
 		do_nocb_deferred_wakeup_common(rdp);
 }
 
+void rcu_nocb_flush_deferred_wakeup(void)
+{
+	do_nocb_deferred_wakeup(this_cpu_ptr(&rcu_data));
+}
+
 void __init rcu_init_nohz(void)
 {
 	int cpu;
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 305727e..7199e6f 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -285,6 +285,7 @@ static void do_idle(void)
 		}
 
 		arch_cpu_idle_enter();
+		rcu_nocb_flush_deferred_wakeup();
 
 		/*
 		 * In poll mode we reenable interrupts and spin. Also if we
