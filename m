Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5291E9D142
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 16:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbfHZOC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 10:02:57 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40242 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbfHZOC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 10:02:56 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1i2Fa4-0005AA-H1; Mon, 26 Aug 2019 16:02:48 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id F104F1C0DAE;
        Mon, 26 Aug 2019 16:02:47 +0200 (CEST)
Date:   Mon, 26 Aug 2019 14:02:47 -0000
From:   tip-bot2 for Sebastian Mayr <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] uprobes/x86: Fix detection of 32-bit user mode
Cc:     Sebastian Mayr <me@sam.st>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Dmitry Safonov <dsafonov@virtuozzo.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20190728152617.7308-1-me@sam.st>
References: <20190728152617.7308-1-me@sam.st>
MIME-Version: 1.0
Message-ID: <156682816785.22183.13288779592609885843.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     9212ec7d8357ea630031e89d0d399c761421c83b
Gitweb:        https://git.kernel.org/tip/9212ec7d8357ea630031e89d0d399c761421c83b
Author:        Sebastian Mayr <me@sam.st>
AuthorDate:    Sun, 28 Jul 2019 17:26:17 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Mon, 26 Aug 2019 15:55:09 +02:00

uprobes/x86: Fix detection of 32-bit user mode

32-bit processes running on a 64-bit kernel are not always detected
correctly, causing the process to crash when uretprobes are installed.

The reason for the crash is that in_ia32_syscall() is used to determine the
process's mode, which only works correctly when called from a syscall.

In the case of uretprobes, however, the function is called from a exception
and always returns 'false' on a 64-bit kernel. In consequence this leads to
corruption of the process's return address.

Fix this by using user_64bit_mode() instead of in_ia32_syscall(), which
is correct in any situation.

[ tglx: Add a comment and the following historical info ]

This should have been detected by the rename which happened in commit

  abfb9498ee13 ("x86/entry: Rename is_{ia32,x32}_task() to in_{ia32,x32}_syscall()")

which states in the changelog:

    The is_ia32_task()/is_x32_task() function names are a big misnomer: they
    suggests that the compat-ness of a system call is a task property, which
    is not true, the compatness of a system call purely depends on how it
    was invoked through the system call layer.
    .....

and then it went and blindly renamed every call site.

Sadly enough this was already mentioned here:

   8faaed1b9f50 ("uprobes/x86: Introduce sizeof_long(), cleanup adjust_ret_addr() and
arch_uretprobe_hijack_return_addr()")

where the changelog says:

    TODO: is_ia32_task() is not what we actually want, TS_COMPAT does
    not necessarily mean 32bit. Fortunately syscall-like insns can't be
    probed so it actually works, but it would be better to rename and
    use is_ia32_frame().

and goes all the way back to:

    0326f5a94dde ("uprobes/core: Handle breakpoint and singlestep exceptions")

Oh well. 7+ years until someone actually tried a uretprobe on a 32bit
process on a 64bit kernel....

Fixes: 0326f5a94dde ("uprobes/core: Handle breakpoint and singlestep exceptions")
Signed-off-by: Sebastian Mayr <me@sam.st>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dmitry Safonov <dsafonov@virtuozzo.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190728152617.7308-1-me@sam.st
---
 arch/x86/kernel/uprobes.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index d8359eb..8cd745e 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -508,9 +508,12 @@ struct uprobe_xol_ops {
 	void	(*abort)(struct arch_uprobe *, struct pt_regs *);
 };
 
-static inline int sizeof_long(void)
+static inline int sizeof_long(struct pt_regs *regs)
 {
-	return in_ia32_syscall() ? 4 : 8;
+	/*
+	 * Check registers for mode as in_xxx_syscall() does not apply here.
+	 */
+	return user_64bit_mode(regs) ? 8 : 4;
 }
 
 static int default_pre_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
@@ -521,9 +524,9 @@ static int default_pre_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 
 static int emulate_push_stack(struct pt_regs *regs, unsigned long val)
 {
-	unsigned long new_sp = regs->sp - sizeof_long();
+	unsigned long new_sp = regs->sp - sizeof_long(regs);
 
-	if (copy_to_user((void __user *)new_sp, &val, sizeof_long()))
+	if (copy_to_user((void __user *)new_sp, &val, sizeof_long(regs)))
 		return -EFAULT;
 
 	regs->sp = new_sp;
@@ -556,7 +559,7 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
 		long correction = utask->vaddr - utask->xol_vaddr;
 		regs->ip += correction;
 	} else if (auprobe->defparam.fixups & UPROBE_FIX_CALL) {
-		regs->sp += sizeof_long(); /* Pop incorrect return address */
+		regs->sp += sizeof_long(regs); /* Pop incorrect return address */
 		if (emulate_push_stack(regs, utask->vaddr + auprobe->defparam.ilen))
 			return -ERESTART;
 	}
@@ -675,7 +678,7 @@ static int branch_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	 * "call" insn was executed out-of-line. Just restore ->sp and restart.
 	 * We could also restore ->ip and try to call branch_emulate_op() again.
 	 */
-	regs->sp += sizeof_long();
+	regs->sp += sizeof_long(regs);
 	return -ERESTART;
 }
 
@@ -1056,7 +1059,7 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 unsigned long
 arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs)
 {
-	int rasize = sizeof_long(), nleft;
+	int rasize = sizeof_long(regs), nleft;
 	unsigned long orig_ret_vaddr = 0; /* clear high bits for 32-bit apps */
 
 	if (copy_from_user(&orig_ret_vaddr, (void __user *)regs->sp, rasize))
