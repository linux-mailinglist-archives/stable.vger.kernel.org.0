Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C191F44F35B
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 14:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbhKMNh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 08:37:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230021AbhKMNh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 08:37:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DF3061056;
        Sat, 13 Nov 2021 13:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636810474;
        bh=qBtisUEZf2QdU8dQtR4qfAB/QKYVJbpXf1RuRgIqWPQ=;
        h=Subject:To:Cc:From:Date:From;
        b=p3jFRX6qBU18R7TLxVNDKMoeh037pzLIvTX9TiA3L5irFN47AnHZ8e8ufQsEThth7
         OeOGsQlhb0dhfanUkqtmTwib1VmMDXq5zzd+HR331n86V1iONpB9hPIX4cqhKemUMg
         XLW+Vqr+XvpGjuFKcc94F3tF/N2yYkEDi1Ob+MAw=
Subject: FAILED: patch "[PATCH] x86/iopl: Fake iopl(3) CLI/STI usage" failed to apply to 5.10-stable tree
To:     peterz@infradead.org, linux@zary.sk, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 14:34:31 +0100
Message-ID: <1636810471246243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b968e84b509da593c50dc3db679e1d33de701f78 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Fri, 17 Sep 2021 11:20:04 +0200
Subject: [PATCH] x86/iopl: Fake iopl(3) CLI/STI usage

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
Cc: stable@kernel.org # v5.5+
Link: https://lkml.kernel.org/r/20210918090641.GD5106@worktop.programming.kicks-ass.net

diff --git a/arch/x86/include/asm/insn-eval.h b/arch/x86/include/asm/insn-eval.h
index 91d7182ad2d6..4ec3613551e3 100644
--- a/arch/x86/include/asm/insn-eval.h
+++ b/arch/x86/include/asm/insn-eval.h
@@ -21,6 +21,7 @@ int insn_get_modrm_rm_off(struct insn *insn, struct pt_regs *regs);
 int insn_get_modrm_reg_off(struct insn *insn, struct pt_regs *regs);
 unsigned long insn_get_seg_base(struct pt_regs *regs, int seg_reg_idx);
 int insn_get_code_seg_params(struct pt_regs *regs);
+int insn_get_effective_ip(struct pt_regs *regs, unsigned long *ip);
 int insn_fetch_from_user(struct pt_regs *regs,
 			 unsigned char buf[MAX_INSN_SIZE]);
 int insn_fetch_from_user_inatomic(struct pt_regs *regs,
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 9ad2acaaae9b..577f342dbfb2 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -518,6 +518,7 @@ struct thread_struct {
 	 */
 	unsigned long		iopl_emul;
 
+	unsigned int		iopl_warn:1;
 	unsigned int		sig_on_uaccess_err:1;
 
 	/*
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1d9463e3096b..f2f733bcb2b9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -132,6 +132,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
 	frame->ret_addr = (unsigned long) ret_from_fork;
 	p->thread.sp = (unsigned long) fork_frame;
 	p->thread.io_bitmap = NULL;
+	p->thread.iopl_warn = 0;
 	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a58800973aed..f3f3034b06f3 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -528,6 +528,36 @@ static enum kernel_gp_hint get_kernel_gp_address(struct pt_regs *regs,
 
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
+	if (insn_get_effective_ip(regs, &ip))
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
@@ -553,6 +583,9 @@ DEFINE_IDTENTRY_ERRORCODE(exc_general_protection)
 	tsk = current;
 
 	if (user_mode(regs)) {
+		if (fixup_iopl_exception(regs))
+			goto exit;
+
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_nr = X86_TRAP_GP;
 
diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
index a1d24fdc07cf..eb3ccffb9b9d 100644
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -1417,7 +1417,7 @@ void __user *insn_get_addr_ref(struct insn *insn, struct pt_regs *regs)
 	}
 }
 
-static int insn_get_effective_ip(struct pt_regs *regs, unsigned long *ip)
+int insn_get_effective_ip(struct pt_regs *regs, unsigned long *ip)
 {
 	unsigned long seg_base = 0;
 

