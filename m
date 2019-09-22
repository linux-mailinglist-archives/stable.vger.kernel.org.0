Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB604BA4D4
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407763AbfIVSwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407390AbfIVSwN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:52:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 553DA21A4A;
        Sun, 22 Sep 2019 18:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178332;
        bh=qTwtcy1Ta8YSY8K/jZ41J8Mqdfo7BZtUs1cpxrNIHl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYMEoLqwBKNGYEgaRbvzVu+d/kvMbrEhlGauyM9qIt7UwMgFHRXttg24q+o+TfW6o
         bL6I/YX59nwzml1f2q7Si+reBvM07IsIL5/YugYweOHCC7M4yid8IKW/V2s0+ACVCi
         WvKTQJlIPWln6YkV0WMSLPUJd2g+DHD+h4bP9dNg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 095/185] arm64: entry: Move ct_user_exit before any other exception
Date:   Sun, 22 Sep 2019 14:47:53 -0400
Message-Id: <20190922184924.32534-95-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

[ Upstream commit 2671828c3ff4ffadf777f793a1f3232d6e51394a ]

When taking an SError or Debug exception from EL0, we run the C
handler for these exceptions before updating the context tracking
code and unmasking lower priority interrupts.

When booting with nohz_full lockdep tells us we got this wrong:
| =============================
| WARNING: suspicious RCU usage
| 5.3.0-rc2-00010-gb4b5e9dcb11b-dirty #11271 Not tainted
| -----------------------------
| include/linux/rcupdate.h:643 rcu_read_unlock() used illegally wh!
|
| other info that might help us debug this:
|
|
| RCU used illegally from idle CPU!
| rcu_scheduler_active = 2, debug_locks = 1
| RCU used illegally from extended quiescent state!
| 1 lock held by a.out/432:
|  #0: 00000000c7a79515 (rcu_read_lock){....}, at: brk_handler+0x00
|
| stack backtrace:
| CPU: 1 PID: 432 Comm: a.out Not tainted 5.3.0-rc2-00010-gb4b5e9d1
| Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno De8
| Call trace:
|  dump_backtrace+0x0/0x140
|  show_stack+0x14/0x20
|  dump_stack+0xbc/0x104
|  lockdep_rcu_suspicious+0xf8/0x108
|  brk_handler+0x164/0x1b0
|  do_debug_exception+0x11c/0x278
|  el0_dbg+0x14/0x20

Moving the ct_user_exit calls to be before do_debug_exception() means
they are also before trace_hardirqs_off() has been updated. Add a new
ct_user_exit_irqoff macro to avoid the context-tracking code using
irqsave/restore before we've updated trace_hardirqs_off(). To be
consistent, do this everywhere.

The C helper is called enter_from_user_mode() to match x86 in the hope
we can merge them into kernel/context_tracking.c later.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: 6c81fe7925cc4c42 ("arm64: enable context tracking")
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/exception.h |  2 ++
 arch/arm64/kernel/entry.S          | 36 ++++++++++++++++--------------
 arch/arm64/kernel/traps.c          |  9 ++++++++
 3 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/exception.h b/arch/arm64/include/asm/exception.h
index ed57b760f38cf..a17393ff66774 100644
--- a/arch/arm64/include/asm/exception.h
+++ b/arch/arm64/include/asm/exception.h
@@ -30,4 +30,6 @@ static inline u32 disr_to_esr(u64 disr)
 	return esr;
 }
 
+asmlinkage void enter_from_user_mode(void);
+
 #endif	/* __ASM_EXCEPTION_H */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 320a30dbe35ef..84a822748c84e 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -30,9 +30,9 @@
  * Context tracking subsystem.  Used to instrument transitions
  * between user and kernel mode.
  */
-	.macro ct_user_exit
+	.macro ct_user_exit_irqoff
 #ifdef CONFIG_CONTEXT_TRACKING
-	bl	context_tracking_user_exit
+	bl	enter_from_user_mode
 #endif
 	.endm
 
@@ -792,8 +792,8 @@ el0_cp15:
 	/*
 	 * Trapped CP15 (MRC, MCR, MRRC, MCRR) instructions
 	 */
+	ct_user_exit_irqoff
 	enable_daif
-	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
 	bl	do_cp15instr
@@ -805,8 +805,8 @@ el0_da:
 	 * Data abort handling
 	 */
 	mrs	x26, far_el1
+	ct_user_exit_irqoff
 	enable_daif
-	ct_user_exit
 	clear_address_tag x0, x26
 	mov	x1, x25
 	mov	x2, sp
@@ -818,11 +818,11 @@ el0_ia:
 	 */
 	mrs	x26, far_el1
 	gic_prio_kentry_setup tmp=x0
+	ct_user_exit_irqoff
 	enable_da_f
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
 #endif
-	ct_user_exit
 	mov	x0, x26
 	mov	x1, x25
 	mov	x2, sp
@@ -832,8 +832,8 @@ el0_fpsimd_acc:
 	/*
 	 * Floating Point or Advanced SIMD access
 	 */
+	ct_user_exit_irqoff
 	enable_daif
-	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
 	bl	do_fpsimd_acc
@@ -842,8 +842,8 @@ el0_sve_acc:
 	/*
 	 * Scalable Vector Extension access
 	 */
+	ct_user_exit_irqoff
 	enable_daif
-	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
 	bl	do_sve_acc
@@ -852,8 +852,8 @@ el0_fpsimd_exc:
 	/*
 	 * Floating Point, Advanced SIMD or SVE exception
 	 */
+	ct_user_exit_irqoff
 	enable_daif
-	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
 	bl	do_fpsimd_exc
@@ -868,11 +868,11 @@ el0_sp_pc:
 	 * Stack or PC alignment exception handling
 	 */
 	gic_prio_kentry_setup tmp=x0
+	ct_user_exit_irqoff
 	enable_da_f
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
 #endif
-	ct_user_exit
 	mov	x0, x26
 	mov	x1, x25
 	mov	x2, sp
@@ -882,8 +882,8 @@ el0_undef:
 	/*
 	 * Undefined instruction
 	 */
+	ct_user_exit_irqoff
 	enable_daif
-	ct_user_exit
 	mov	x0, sp
 	bl	do_undefinstr
 	b	ret_to_user
@@ -891,8 +891,8 @@ el0_sys:
 	/*
 	 * System instructions, for trapped cache maintenance instructions
 	 */
+	ct_user_exit_irqoff
 	enable_daif
-	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
 	bl	do_sysinstr
@@ -902,17 +902,18 @@ el0_dbg:
 	 * Debug exception handling
 	 */
 	tbnz	x24, #0, el0_inv		// EL0 only
+	mrs	x24, far_el1
 	gic_prio_kentry_setup tmp=x3
-	mrs	x0, far_el1
+	ct_user_exit_irqoff
+	mov	x0, x24
 	mov	x1, x25
 	mov	x2, sp
 	bl	do_debug_exception
 	enable_da_f
-	ct_user_exit
 	b	ret_to_user
 el0_inv:
+	ct_user_exit_irqoff
 	enable_daif
-	ct_user_exit
 	mov	x0, sp
 	mov	x1, #BAD_SYNC
 	mov	x2, x25
@@ -925,13 +926,13 @@ el0_irq:
 	kernel_entry 0
 el0_irq_naked:
 	gic_prio_irq_setup pmr=x20, tmp=x0
+	ct_user_exit_irqoff
 	enable_da_f
 
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
 #endif
 
-	ct_user_exit
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 	tbz	x22, #55, 1f
 	bl	do_el0_irq_bp_hardening
@@ -958,13 +959,14 @@ ENDPROC(el1_error)
 el0_error:
 	kernel_entry 0
 el0_error_naked:
-	mrs	x1, esr_el1
+	mrs	x25, esr_el1
 	gic_prio_kentry_setup tmp=x2
+	ct_user_exit_irqoff
 	enable_dbg
 	mov	x0, sp
+	mov	x1, x25
 	bl	do_serror
 	enable_da_f
-	ct_user_exit
 	b	ret_to_user
 ENDPROC(el0_error)
 
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 985721a1264c9..b6706a8860371 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -7,9 +7,11 @@
  */
 
 #include <linux/bug.h>
+#include <linux/context_tracking.h>
 #include <linux/signal.h>
 #include <linux/personality.h>
 #include <linux/kallsyms.h>
+#include <linux/kprobes.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
 #include <linux/hardirq.h>
@@ -905,6 +907,13 @@ asmlinkage void do_serror(struct pt_regs *regs, unsigned int esr)
 		nmi_exit();
 }
 
+asmlinkage void enter_from_user_mode(void)
+{
+	CT_WARN_ON(ct_state() != CONTEXT_USER);
+	user_exit_irqoff();
+}
+NOKPROBE_SYMBOL(enter_from_user_mode);
+
 void __pte_error(const char *file, int line, unsigned long val)
 {
 	pr_err("%s:%d: bad pte %016lx.\n", file, line, val);
-- 
2.20.1

