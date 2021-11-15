Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFF24510AF
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242061AbhKOSwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:52:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243054AbhKOSuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:50:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 380116142A;
        Mon, 15 Nov 2021 18:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999739;
        bh=NSc3YVRk+pOlnH6+08VjZrp0JeTcxXEfShAQLz2rXf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3J1cyuEoKFbFgFFLwr3TyrRtQE1CWHPtM94Dp/uP0m2zwWpJYqb9jryN9X4cATPh
         j+TaAxWDJHGZ3ob5DNGsHIq++MKGj/H38a4iHpOTn79lOKG3XaIc9UCpZ4AgzcYK59
         wBxSWUWUWvaujinMeZpi96ayZYtQAREb1COkLvhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 407/849] rcu: Always inline rcu_dynticks_task*_{enter,exit}()
Date:   Mon, 15 Nov 2021 17:58:10 +0100
Message-Id: <20211115165434.033188021@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 7663ad9a5dbcc27f3090e6bfd192c7e59222709f ]

RCU managed to grow a few noinstr violations:

  vmlinux.o: warning: objtool: rcu_dynticks_eqs_enter()+0x0: call to rcu_dynticks_task_trace_enter() leaves .noinstr.text section
  vmlinux.o: warning: objtool: rcu_dynticks_eqs_exit()+0xe: call to rcu_dynticks_task_trace_exit() leaves .noinstr.text section

Fix them by adding __always_inline to the relevant trivial functions.

Also replace the noinstr with __always_inline for the existing
rcu_dynticks_task_*() functions since noinstr would force noinline
them, even when empty, which seems silly.

Fixes: 7d0c9c50c5a1 ("rcu-tasks: Avoid IPIing userspace/idle tasks if kernel is so built")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_plugin.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 6ce104242b23d..591e038e7670d 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2964,7 +2964,7 @@ static void rcu_bind_gp_kthread(void)
 }
 
 /* Record the current task on dyntick-idle entry. */
-static void noinstr rcu_dynticks_task_enter(void)
+static __always_inline void rcu_dynticks_task_enter(void)
 {
 #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
 	WRITE_ONCE(current->rcu_tasks_idle_cpu, smp_processor_id());
@@ -2972,7 +2972,7 @@ static void noinstr rcu_dynticks_task_enter(void)
 }
 
 /* Record no current task on dyntick-idle exit. */
-static void noinstr rcu_dynticks_task_exit(void)
+static __always_inline void rcu_dynticks_task_exit(void)
 {
 #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
 	WRITE_ONCE(current->rcu_tasks_idle_cpu, -1);
@@ -2980,7 +2980,7 @@ static void noinstr rcu_dynticks_task_exit(void)
 }
 
 /* Turn on heavyweight RCU tasks trace readers on idle/user entry. */
-static void rcu_dynticks_task_trace_enter(void)
+static __always_inline void rcu_dynticks_task_trace_enter(void)
 {
 #ifdef CONFIG_TASKS_TRACE_RCU
 	if (IS_ENABLED(CONFIG_TASKS_TRACE_RCU_READ_MB))
@@ -2989,7 +2989,7 @@ static void rcu_dynticks_task_trace_enter(void)
 }
 
 /* Turn off heavyweight RCU tasks trace readers on idle/user exit. */
-static void rcu_dynticks_task_trace_exit(void)
+static __always_inline void rcu_dynticks_task_trace_exit(void)
 {
 #ifdef CONFIG_TASKS_TRACE_RCU
 	if (IS_ENABLED(CONFIG_TASKS_TRACE_RCU_READ_MB))
-- 
2.33.0



