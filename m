Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FF34521DB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376798AbhKPBHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:07:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245360AbhKOTUM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 042286345B;
        Mon, 15 Nov 2021 18:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001184;
        bh=epHNQsR5h+ibAZrZ4r9fXGTFuVumkpBGfSrRsAbItns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDz2wBrrbMFeOAiqNjHLZ0zHkSmrRjO7B6cAIIdNQM2w4w8f+KYl4Rugs9fLkY2Xh
         k5e1i/sCKFdV5n1JgGo6OmujeunpoqljpJk1eSM6Geij9VgiQ2c+4yMbnyqMfznUxH
         GeXMyV/Jda6sI+dfiAsFPQseFgo4Gzaa/waaoaSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Zary <linux@zary.sk>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@kernel.org
Subject: [PATCH 5.15 060/917] x86/iopl: Fake iopl(3) CLI/STI usage
Date:   Mon, 15 Nov 2021 17:52:35 +0100
Message-Id: <20211115165430.804431442@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit b968e84b509da593c50dc3db679e1d33de701f78 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/insn-eval.h |    1 +
 arch/x86/include/asm/processor.h |    1 +
 arch/x86/kernel/process.c        |    1 +
 arch/x86/kernel/traps.c          |   33 +++++++++++++++++++++++++++++++++
 arch/x86/lib/insn-eval.c         |    2 +-
 5 files changed, 37 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/insn-eval.h
+++ b/arch/x86/include/asm/insn-eval.h
@@ -21,6 +21,7 @@ int insn_get_modrm_rm_off(struct insn *i
 int insn_get_modrm_reg_off(struct insn *insn, struct pt_regs *regs);
 unsigned long insn_get_seg_base(struct pt_regs *regs, int seg_reg_idx);
 int insn_get_code_seg_params(struct pt_regs *regs);
+int insn_get_effective_ip(struct pt_regs *regs, unsigned long *ip);
 int insn_fetch_from_user(struct pt_regs *regs,
 			 unsigned char buf[MAX_INSN_SIZE]);
 int insn_fetch_from_user_inatomic(struct pt_regs *regs,
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -518,6 +518,7 @@ struct thread_struct {
 	 */
 	unsigned long		iopl_emul;
 
+	unsigned int		iopl_warn:1;
 	unsigned int		sig_on_uaccess_err:1;
 
 	/*
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -132,6 +132,7 @@ int copy_thread(unsigned long clone_flag
 	frame->ret_addr = (unsigned long) ret_from_fork;
 	p->thread.sp = (unsigned long) fork_frame;
 	p->thread.io_bitmap = NULL;
+	p->thread.iopl_warn = 0;
 	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 
 #ifdef CONFIG_X86_64
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -528,6 +528,36 @@ static enum kernel_gp_hint get_kernel_gp
 
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
@@ -553,6 +583,9 @@ DEFINE_IDTENTRY_ERRORCODE(exc_general_pr
 	tsk = current;
 
 	if (user_mode(regs)) {
+		if (fixup_iopl_exception(regs))
+			goto exit;
+
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_nr = X86_TRAP_GP;
 
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -1417,7 +1417,7 @@ void __user *insn_get_addr_ref(struct in
 	}
 }
 
-static int insn_get_effective_ip(struct pt_regs *regs, unsigned long *ip)
+int insn_get_effective_ip(struct pt_regs *regs, unsigned long *ip)
 {
 	unsigned long seg_base = 0;
 


