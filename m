Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7AC99A76
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391065AbfHVRNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:13:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390609AbfHVRJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:00 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E03E6235EE;
        Thu, 22 Aug 2019 17:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493740;
        bh=tnBCKsNOXpc/So9mge9o69O10x6UKsl/NYQ+QplWqDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rc8ieB9oz2nZ+45Pr0z1kZPIw3tSIvIzPKMIMyRxy2iT3PTCL0bw+XjKACWLmepPc
         fG1kuwztEayBvwjVesfqEm6ud2YwByzKlHufAJIN90tBpNh0kWlHWVWInOzRJUxA7D
         kZlutXbMOmteod23OdygaKYVGJmuXS++iHBfIxVQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 085/135] arm64: Make debug exception handlers visible from RCU
Date:   Thu, 22 Aug 2019 13:07:21 -0400
Message-Id: <20190822170811.13303-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit d8bb6718c4db9bcd075dde7ff55d46091ccfae15 ]

Make debug exceptions visible from RCU so that synchronize_rcu()
correctly track the debug exception handler.

This also introduces sanity checks for user-mode exceptions as same
as x86's ist_enter()/ist_exit().

The debug exception can interrupt in idle task. For example, it warns
if we put a kprobe on a function called from idle task as below.
The warning message showed that the rcu_read_lock() caused this
problem. But actually, this means the RCU is lost the context which
is already in NMI/IRQ.

  /sys/kernel/debug/tracing # echo p default_idle_call >> kprobe_events
  /sys/kernel/debug/tracing # echo 1 > events/kprobes/enable
  /sys/kernel/debug/tracing # [  135.122237]
  [  135.125035] =============================
  [  135.125310] WARNING: suspicious RCU usage
  [  135.125581] 5.2.0-08445-g9187c508bdc7 #20 Not tainted
  [  135.125904] -----------------------------
  [  135.126205] include/linux/rcupdate.h:594 rcu_read_lock() used illegally while idle!
  [  135.126839]
  [  135.126839] other info that might help us debug this:
  [  135.126839]
  [  135.127410]
  [  135.127410] RCU used illegally from idle CPU!
  [  135.127410] rcu_scheduler_active = 2, debug_locks = 1
  [  135.128114] RCU used illegally from extended quiescent state!
  [  135.128555] 1 lock held by swapper/0/0:
  [  135.128944]  #0: (____ptrval____) (rcu_read_lock){....}, at: call_break_hook+0x0/0x178
  [  135.130499]
  [  135.130499] stack backtrace:
  [  135.131192] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.2.0-08445-g9187c508bdc7 #20
  [  135.131841] Hardware name: linux,dummy-virt (DT)
  [  135.132224] Call trace:
  [  135.132491]  dump_backtrace+0x0/0x140
  [  135.132806]  show_stack+0x24/0x30
  [  135.133133]  dump_stack+0xc4/0x10c
  [  135.133726]  lockdep_rcu_suspicious+0xf8/0x108
  [  135.134171]  call_break_hook+0x170/0x178
  [  135.134486]  brk_handler+0x28/0x68
  [  135.134792]  do_debug_exception+0x90/0x150
  [  135.135051]  el1_dbg+0x18/0x8c
  [  135.135260]  default_idle_call+0x0/0x44
  [  135.135516]  cpu_startup_entry+0x2c/0x30
  [  135.135815]  rest_init+0x1b0/0x280
  [  135.136044]  arch_call_rest_init+0x14/0x1c
  [  135.136305]  start_kernel+0x4d4/0x500
  [  135.136597]

So make debug exception visible to RCU can fix this warning.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Acked-by: Paul E. McKenney <paulmck@linux.ibm.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/fault.c | 57 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 49 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 2d115016feb42..414b8e0f19e0e 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -800,6 +800,53 @@ void __init hook_debug_fault_code(int nr,
 	debug_fault_info[nr].name	= name;
 }
 
+/*
+ * In debug exception context, we explicitly disable preemption despite
+ * having interrupts disabled.
+ * This serves two purposes: it makes it much less likely that we would
+ * accidentally schedule in exception context and it will force a warning
+ * if we somehow manage to schedule by accident.
+ */
+static void debug_exception_enter(struct pt_regs *regs)
+{
+	/*
+	 * Tell lockdep we disabled irqs in entry.S. Do nothing if they were
+	 * already disabled to preserve the last enabled/disabled addresses.
+	 */
+	if (interrupts_enabled(regs))
+		trace_hardirqs_off();
+
+	if (user_mode(regs)) {
+		RCU_LOCKDEP_WARN(!rcu_is_watching(), "entry code didn't wake RCU");
+	} else {
+		/*
+		 * We might have interrupted pretty much anything.  In
+		 * fact, if we're a debug exception, we can even interrupt
+		 * NMI processing. We don't want this code makes in_nmi()
+		 * to return true, but we need to notify RCU.
+		 */
+		rcu_nmi_enter();
+	}
+
+	preempt_disable();
+
+	/* This code is a bit fragile.  Test it. */
+	RCU_LOCKDEP_WARN(!rcu_is_watching(), "exception_enter didn't work");
+}
+NOKPROBE_SYMBOL(debug_exception_enter);
+
+static void debug_exception_exit(struct pt_regs *regs)
+{
+	preempt_enable_no_resched();
+
+	if (!user_mode(regs))
+		rcu_nmi_exit();
+
+	if (interrupts_enabled(regs))
+		trace_hardirqs_on();
+}
+NOKPROBE_SYMBOL(debug_exception_exit);
+
 #ifdef CONFIG_ARM64_ERRATUM_1463225
 DECLARE_PER_CPU(int, __in_cortex_a76_erratum_1463225_wa);
 
@@ -840,12 +887,7 @@ asmlinkage void __exception do_debug_exception(unsigned long addr_if_watchpoint,
 	if (cortex_a76_erratum_1463225_debug_handler(regs))
 		return;
 
-	/*
-	 * Tell lockdep we disabled irqs in entry.S. Do nothing if they were
-	 * already disabled to preserve the last enabled/disabled addresses.
-	 */
-	if (interrupts_enabled(regs))
-		trace_hardirqs_off();
+	debug_exception_enter(regs);
 
 	if (user_mode(regs) && !is_ttbr0_addr(pc))
 		arm64_apply_bp_hardening();
@@ -855,7 +897,6 @@ asmlinkage void __exception do_debug_exception(unsigned long addr_if_watchpoint,
 				 inf->sig, inf->code, (void __user *)pc, esr);
 	}
 
-	if (interrupts_enabled(regs))
-		trace_hardirqs_on();
+	debug_exception_exit(regs);
 }
 NOKPROBE_SYMBOL(do_debug_exception);
-- 
2.20.1

