Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C0D1FFA42
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 19:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732138AbgFRRaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 13:30:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:42174 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732089AbgFRRaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 13:30:07 -0400
Received: from yow-cube1.wrs.com (yow-cube1.wrs.com [128.224.56.98])
        by mail.windriver.com (8.15.2/8.15.2) with ESMTP id 05IHTm8o023501;
        Thu, 18 Jun 2020 10:29:48 -0700 (PDT)
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH] arm64: don't preempt_disable in do_debug_exception
Date:   Thu, 18 Jun 2020 13:29:29 -0400
Message-Id: <1592501369-27645-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit d8bb6718c4db ("arm64: Make debug exception handlers visible
from RCU") debug_exception_enter and exit were added to deal with better
tracking of RCU state - however, in addition to that, but not mentioned
in the commit log, a preempt_disable/enable pair were also added.

Based on the comment (being removed here) it would seem that the pair
were not added to address a specific problem, but just as a proactive,
preventative measure - as in "seemed like a good idea at the time".

The problem is that do_debug_exception() eventually calls out to
generic kernel code like do_force_sig_info() which takes non-raw locks
and on -rt enabled kernels, results in things looking like the following,
since on -rt kernels, it is noticed that preemption is still disabled.

 BUG: sleeping function called from invalid context at kernel/locking/rtmutex.c:975
 in_atomic(): 1, irqs_disabled(): 0, pid: 35658, name: gdbtest
 Preemption disabled at:
 [<ffff000010081578>] do_debug_exception+0x38/0x1a4
 Call trace:
 dump_backtrace+0x0/0x138
 show_stack+0x24/0x30
 dump_stack+0x94/0xbc
 ___might_sleep+0x13c/0x168
 rt_spin_lock+0x40/0x80
 do_force_sig_info+0x30/0xe0
 force_sig_fault+0x64/0x90
 arm64_force_sig_fault+0x50/0x80
 send_user_sigtrap+0x50/0x80
 brk_handler+0x98/0xc8
 do_debug_exception+0x70/0x1a4
 el0_dbg+0x18/0x20

The reproducer was basically an automated gdb test that set a breakpoint
on a simple "hello world" program and then quit gdb once the breakpoint
was hit - i.e. "(gdb) A debugging session is active.  Quit anyway? "

Fixes: d8bb6718c4db ("arm64: Make debug exception handlers visible from RCU")
Cc: stable@vger.kernel.org
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.ibm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/arm64/mm/fault.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 8afb238ff335..4d83ec991b33 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -788,13 +788,6 @@ void __init hook_debug_fault_code(int nr,
 	debug_fault_info[nr].name	= name;
 }
 
-/*
- * In debug exception context, we explicitly disable preemption despite
- * having interrupts disabled.
- * This serves two purposes: it makes it much less likely that we would
- * accidentally schedule in exception context and it will force a warning
- * if we somehow manage to schedule by accident.
- */
 static void debug_exception_enter(struct pt_regs *regs)
 {
 	/*
@@ -816,8 +809,6 @@ static void debug_exception_enter(struct pt_regs *regs)
 		rcu_nmi_enter();
 	}
 
-	preempt_disable();
-
 	/* This code is a bit fragile.  Test it. */
 	RCU_LOCKDEP_WARN(!rcu_is_watching(), "exception_enter didn't work");
 }
@@ -825,8 +816,6 @@ NOKPROBE_SYMBOL(debug_exception_enter);
 
 static void debug_exception_exit(struct pt_regs *regs)
 {
-	preempt_enable_no_resched();
-
 	if (!user_mode(regs))
 		rcu_nmi_exit();
 
-- 
2.7.4

