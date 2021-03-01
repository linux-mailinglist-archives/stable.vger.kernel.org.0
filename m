Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294C2328E31
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241462AbhCATZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:25:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241412AbhCATVp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:21:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D75E16508B;
        Mon,  1 Mar 2021 17:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619763;
        bh=f3TkFY0KQpzexNS5dp8NrxNlByYqCA9zqKe+seOjUJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBA/Tyeb9Nx4BA4TAUkHLb1XeQpWAHa9HraDvB8Bl677ofBqBptnhWic4aCnUksv4
         T1NUGfx+fTKc2vxDsPnS2CJbj6+n8tdmHMvUkpQEcs/ryhpNDuwrjir4NtMjImCEOi
         KWDruNYMtYEmzDK9fowJuglRBFB1H/GwiCNh4tsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.10 573/663] rcu/nocb: Perform deferred wake up before last idles need_resched() check
Date:   Mon,  1 Mar 2021 17:13:41 +0100
Message-Id: <20210301161210.216696443@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

commit 43789ef3f7d61aa7bed0cb2764e588fc990c30ef upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rcupdate.h |    2 ++
 kernel/rcu/tree.c        |    3 ---
 kernel/rcu/tree_plugin.h |    5 +++++
 kernel/sched/idle.c      |    1 +
 4 files changed, 8 insertions(+), 3 deletions(-)

--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -110,8 +110,10 @@ static inline void rcu_user_exit(void) {
 
 #ifdef CONFIG_RCU_NOCB_CPU
 void rcu_init_nohz(void);
+void rcu_nocb_flush_deferred_wakeup(void);
 #else /* #ifdef CONFIG_RCU_NOCB_CPU */
 static inline void rcu_init_nohz(void) { }
+static inline void rcu_nocb_flush_deferred_wakeup(void) { }
 #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
 
 /**
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -663,10 +663,7 @@ static noinstr void rcu_eqs_enter(bool u
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
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2187,6 +2187,11 @@ static void do_nocb_deferred_wakeup(stru
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
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -285,6 +285,7 @@ static void do_idle(void)
 		}
 
 		arch_cpu_idle_enter();
+		rcu_nocb_flush_deferred_wakeup();
 
 		/*
 		 * In poll mode we reenable interrupts and spin. Also if we


