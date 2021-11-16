Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A3B453A17
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239592AbhKPTYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:24:05 -0500
Received: from hosting.gsystem.sk ([212.5.213.30]:40684 "EHLO
        hosting.gsystem.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbhKPTYF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 14:24:05 -0500
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Nov 2021 14:24:05 EST
Received: from gsql.ggedos.sk (off-20.infotel.telecom.sk [212.5.213.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by hosting.gsystem.sk (Postfix) with ESMTPSA id 1FB547A0222;
        Tue, 16 Nov 2021 20:15:24 +0100 (CET)
From:   Ondrej Zary <linux@zary.sk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] v5.10 backport of x86/iopl: Fake iopl(3) CLI/STI usage
Date:   Tue, 16 Nov 2021 20:15:14 +0100
Message-Id: <20211116191514.17854-1-linux@zary.sk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport of the following patch for 5.10-stable:

>>From b968e84b509da593c50dc3db679e1d33de701f78 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Fri, 17 Sep 2021 11:20:04 +0200

Since commit c8137ace5638 ("x86/iopl: Restrict iopl() permission
scope") it's possible to emulate iopl(3) using ioperm(), except for
the CLI/STI usage.

Userspace CLI/STI usage is very dubious (read broken), since any
exception taken during that window can lead to rescheduling anyway (or
worse). The IOPL(2) manpage even states that usage of CLI/STI is highly
discouraged and might even crash the system.

Of course, that won't stop people and HP has the dubious honour of
being the first vendor to be found using this in their hp-health
package.

In order to enable this 'software' to still 'work', have the #GP treat
the CLI/STI instructions as NOPs when iopl(3). Warn the user that
their program is doing dubious things.

Fixes: a24ca9976843 ("x86/iopl: Remove legacy IOPL option")
Reported-by: Ondrej Zary <linux@zary.sk>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20210918090641.GD5106@worktop.programming.kicks-ass.net
Signed-off-by: Ondrej Zary <linux@zary.sk>
---
 arch/x86/include/asm/insn-eval.h |  1 +
 arch/x86/include/asm/processor.h |  1 +
 arch/x86/kernel/process.c        |  1 +
 arch/x86/kernel/traps.c          | 34 ++++++++++++++++++++++++++++++++
 arch/x86/lib/insn-eval.c         |  2 +-
 5 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/insn-eval.h b/arch/x86/include/asm/insn-eval.h
index 98b4dae5e8bc..c1438f9239e4 100644
--- a/arch/x86/include/asm/insn-eval.h
+++ b/arch/x86/include/asm/insn-eval.h
@@ -21,6 +21,7 @@ int insn_get_modrm_rm_off(struct insn *insn, struct pt_regs *regs);
 int insn_get_modrm_reg_off(struct insn *insn, struct pt_regs *regs);
 unsigned long insn_get_seg_base(struct pt_regs *regs, int seg_reg_idx);
 int insn_get_code_seg_params(struct pt_regs *regs);
+unsigned long insn_get_effective_ip(struct pt_regs *regs);
 int insn_fetch_from_user(struct pt_regs *regs,
 			 unsigned char buf[MAX_INSN_SIZE]);
 int insn_fetch_from_user_inatomic(struct pt_regs *regs,
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 50d02db72317..d428d611a43a 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -534,6 +534,7 @@ struct thread_struct {
 	 */
 	unsigned long		iopl_emul;
 
+	unsigned int		iopl_warn:1;
 	unsigned int		sig_on_uaccess_err:1;
 
 	/* Floating point and extended processor state */
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 145a7ac0c19a..0aa1baf9a3af 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -138,6 +138,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
 	frame->ret_addr = (unsigned long) ret_from_fork;
 	p->thread.sp = (unsigned long) fork_frame;
 	p->thread.io_bitmap = NULL;
+	p->thread.iopl_warn = 0;
 	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 143fcb8af38f..2d4ecd50e69b 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -523,6 +523,37 @@ static enum kernel_gp_hint get_kernel_gp_address(struct pt_regs *regs,
 
 #define GPFSTR "general protection fault"
 
+static bool fixup_iopl_exception(struct pt_regs *regs)
+{
+	struct thread_struct *t = &current->thread;
+	unsigned char byte;
+	unsigned long ip;
+
+	if (!IS_ENABLED(CONFIG_X86_IOPL_IOPERM) || t->iopl_emul != 3)
+		return false;
+
+	ip = insn_get_effective_ip(regs);
+	if (!ip)
+		return false;
+
+	if (get_user(byte, (const char __user *)ip))
+		return false;
+
+	if (byte != 0xfa && byte != 0xfb)
+		return false;
+
+	if (!t->iopl_warn && printk_ratelimit()) {
+		pr_err("%s[%d] attempts to use CLI/STI, pretending it's a NOP, ip:%lx",
+		       current->comm, task_pid_nr(current), ip);
+		print_vma_addr(KERN_CONT " in ", ip);
+		pr_cont("\n");
+		t->iopl_warn = 1;
+	}
+
+	regs->ip += 1;
+	return true;
+}
+
 DEFINE_IDTENTRY_ERRORCODE(exc_general_protection)
 {
 	char desc[sizeof(GPFSTR) + 50 + 2*sizeof(unsigned long) + 1] = GPFSTR;
@@ -548,6 +579,9 @@ DEFINE_IDTENTRY_ERRORCODE(exc_general_protection)
 	tsk = current;
 
 	if (user_mode(regs)) {
+		if (fixup_iopl_exception(regs))
+			goto exit;
+
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_nr = X86_TRAP_GP;
 
diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
index bb0b3fe1e0a0..c6a19c88af54 100644
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -1415,7 +1415,7 @@ void __user *insn_get_addr_ref(struct insn *insn, struct pt_regs *regs)
 	}
 }
 
-static unsigned long insn_get_effective_ip(struct pt_regs *regs)
+unsigned long insn_get_effective_ip(struct pt_regs *regs)
 {
 	unsigned long seg_base = 0;
 
-- 
2.20.1

