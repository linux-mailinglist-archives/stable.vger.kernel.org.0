Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBD23CAB9A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244890AbhGOTU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245064AbhGOTTP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:19:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EAEA613F2;
        Thu, 15 Jul 2021 19:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376442;
        bh=5JIVYpka/8B06HYh8T3fYIDyW9P6b7DJtITXlW+WJeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMkWkl/9B8DLjDz2ykB7x2Y01zoq55NhnrcXRy6+2vTAID/uB9iOgMR6q31aR0xrQ
         93mYtjVcUhmdH745gcKB9sIXPif3Hy+pEv3Rq/fwrJycsfyogeHginNy+0QBLspigF
         pLSVscQVkXo4QiIPMaFGlu91FVTxI7YMaviXoOR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, stable@kernel.org
Subject: [PATCH 5.13 258/266] s390/signal: switch to using vdso for sigreturn and syscall restart
Date:   Thu, 15 Jul 2021 20:40:13 +0200
Message-Id: <20210715182652.859757404@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit df29a7440c4b5c65765c8f60396b3b13063e24e9 upstream.

with generic entry, there's a bug when it comes to restarting of signals.
The failing sequence is:

a) a signal is coming in, and no handler is registered, so the lower
   part of arch_do_signal_or_restart() in arch/s390/kernel/signal.c
   sets PIF_SYSCALL_RESTART.

b) a second signal gets pending while the kernel is still in the exit
   loop, and for that one, a handler exists.

c) The first part of arch_do_signal_or_restart() is called. That part
   calls handle_signal(), which sets up stack + registers for handling
   the signal.

d) __do_syscall() in arch/s390/kernel/syscall.c checks for
   PIF_SYSCALL_RESTART right before leaving to userspace. If it is set,
   it restart's the syscall. However, the registers are already setup
   for handling a signal from c). The syscall is now restarted with the
   wrong arguments.

Change the code to:

- use vdso for syscall_restart() instead of PIF_SYSCALL_RESTART because
  we cannot rewind and go back to userspace on s390 because the system call
  number might be encoded in the svc instruction.
- for all other syscalls we rewind the PSW and return to userspace.

Cc: <stable@kernel.org> # v5.12+ d57778feb987: s390/vdso: always enable vdso
Cc: <stable@kernel.org> # v5.12+ 686341f2548b: s390/vdso64: add sigreturn,rt_sigreturn and restart_syscall
Cc: <stable@kernel.org> # v5.12+ 43e1f76b0b69: s390/vdso: rename VDSO64_LBASE to VDSO_LBASE
Cc: <stable@kernel.org> # v5.12+ 779df2248739: s390/vdso: add minimal compat vdso
Cc: <stable@kernel.org> # v5.12+
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/compat_signal.c |   13 +++----------
 arch/s390/kernel/process.c       |    6 ++++++
 arch/s390/kernel/signal.c        |   39 ++++++++++++++++++---------------------
 arch/s390/kernel/syscall.c       |    4 ++++
 4 files changed, 31 insertions(+), 31 deletions(-)

--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -28,6 +28,7 @@
 #include <linux/uaccess.h>
 #include <asm/lowcore.h>
 #include <asm/switch_to.h>
+#include <asm/vdso.h>
 #include "compat_linux.h"
 #include "compat_ptrace.h"
 #include "entry.h"
@@ -118,7 +119,6 @@ static int restore_sigregs32(struct pt_r
 	fpregs_load((_s390_fp_regs *) &user_sregs.fpregs, &current->thread.fpu);
 
 	clear_pt_regs_flag(regs, PIF_SYSCALL); /* No longer in a system call */
-	clear_pt_regs_flag(regs, PIF_SYSCALL_RESTART);
 	return 0;
 }
 
@@ -304,11 +304,7 @@ static int setup_frame32(struct ksignal
 		restorer = (unsigned long __force)
 			ksig->ka.sa.sa_restorer | PSW32_ADDR_AMODE;
 	} else {
-		/* Signal frames without vectors registers are short ! */
-		__u16 __user *svc = (void __user *) frame + frame_size - 2;
-		if (__put_user(S390_SYSCALL_OPCODE | __NR_sigreturn, svc))
-			return -EFAULT;
-		restorer = (unsigned long __force) svc | PSW32_ADDR_AMODE;
+		restorer = VDSO32_SYMBOL(current, sigreturn);
         }
 
 	/* Set up registers for signal handler */
@@ -371,10 +367,7 @@ static int setup_rt_frame32(struct ksign
 		restorer = (unsigned long __force)
 			ksig->ka.sa.sa_restorer | PSW32_ADDR_AMODE;
 	} else {
-		__u16 __user *svc = &frame->svc_insn;
-		if (__put_user(S390_SYSCALL_OPCODE | __NR_rt_sigreturn, svc))
-			return -EFAULT;
-		restorer = (unsigned long __force) svc | PSW32_ADDR_AMODE;
+		restorer = VDSO32_SYMBOL(current, rt_sigreturn);
 	}
 
 	/* Create siginfo on the signal stack */
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -166,6 +166,12 @@ int copy_thread(unsigned long clone_flag
 			p->thread.acrs[1] = (unsigned int)tls;
 		}
 	}
+	/*
+	 * s390 stores the svc return address in arch_data when calling
+	 * sigreturn()/restart_syscall() via vdso. 1 means no valid address
+	 * stored.
+	 */
+	p->restart_block.arch_data = 1;
 	return 0;
 }
 
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -32,6 +32,7 @@
 #include <linux/uaccess.h>
 #include <asm/lowcore.h>
 #include <asm/switch_to.h>
+#include <asm/vdso.h>
 #include "entry.h"
 
 /*
@@ -171,7 +172,6 @@ static int restore_sigregs(struct pt_reg
 	fpregs_load(&user_sregs.fpregs, &current->thread.fpu);
 
 	clear_pt_regs_flag(regs, PIF_SYSCALL); /* No longer in a system call */
-	clear_pt_regs_flag(regs, PIF_SYSCALL_RESTART);
 	return 0;
 }
 
@@ -334,15 +334,10 @@ static int setup_frame(int sig, struct k
 
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
+	if (ka->sa.sa_flags & SA_RESTORER)
 		restorer = (unsigned long) ka->sa.sa_restorer;
-	} else {
-		/* Signal frame without vector registers are short ! */
-		__u16 __user *svc = (void __user *) frame + frame_size - 2;
-		if (__put_user(S390_SYSCALL_OPCODE | __NR_sigreturn, svc))
-			return -EFAULT;
-		restorer = (unsigned long) svc;
-	}
+	else
+		restorer = VDSO64_SYMBOL(current, sigreturn);
 
 	/* Set up registers for signal handler */
 	regs->gprs[14] = restorer;
@@ -397,14 +392,10 @@ static int setup_rt_frame(struct ksignal
 
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+	if (ksig->ka.sa.sa_flags & SA_RESTORER)
 		restorer = (unsigned long) ksig->ka.sa.sa_restorer;
-	} else {
-		__u16 __user *svc = &frame->svc_insn;
-		if (__put_user(S390_SYSCALL_OPCODE | __NR_rt_sigreturn, svc))
-			return -EFAULT;
-		restorer = (unsigned long) svc;
-	}
+	else
+		restorer = VDSO64_SYMBOL(current, rt_sigreturn);
 
 	/* Create siginfo on the signal stack */
 	if (copy_siginfo_to_user(&frame->info, &ksig->info))
@@ -501,7 +492,7 @@ void arch_do_signal_or_restart(struct pt
 		}
 		/* No longer in a system call */
 		clear_pt_regs_flag(regs, PIF_SYSCALL);
-		clear_pt_regs_flag(regs, PIF_SYSCALL_RESTART);
+
 		rseq_signal_deliver(&ksig, regs);
 		if (is_compat_task())
 			handle_signal32(&ksig, oldset, regs);
@@ -517,14 +508,20 @@ void arch_do_signal_or_restart(struct pt
 		switch (regs->gprs[2]) {
 		case -ERESTART_RESTARTBLOCK:
 			/* Restart with sys_restart_syscall */
-			regs->int_code = __NR_restart_syscall;
-			fallthrough;
+			regs->gprs[2] = regs->orig_gpr2;
+			current->restart_block.arch_data = regs->psw.addr;
+			if (is_compat_task())
+				regs->psw.addr = VDSO32_SYMBOL(current, restart_syscall);
+			else
+				regs->psw.addr = VDSO64_SYMBOL(current, restart_syscall);
+			if (test_thread_flag(TIF_SINGLE_STEP))
+				clear_thread_flag(TIF_PER_TRAP);
+			break;
 		case -ERESTARTNOHAND:
 		case -ERESTARTSYS:
 		case -ERESTARTNOINTR:
-			/* Restart system call with magic TIF bit. */
 			regs->gprs[2] = regs->orig_gpr2;
-			set_pt_regs_flag(regs, PIF_SYSCALL_RESTART);
+			regs->psw.addr = __rewind_psw(regs->psw, regs->int_code >> 16);
 			if (test_thread_flag(TIF_SINGLE_STEP))
 				clear_thread_flag(TIF_PER_TRAP);
 			break;
--- a/arch/s390/kernel/syscall.c
+++ b/arch/s390/kernel/syscall.c
@@ -121,6 +121,10 @@ void do_syscall(struct pt_regs *regs)
 
 	regs->gprs[2] = nr;
 
+	if (nr == __NR_restart_syscall && !(current->restart_block.arch_data & 1)) {
+		regs->psw.addr = current->restart_block.arch_data;
+		current->restart_block.arch_data = 1;
+	}
 	nr = syscall_enter_from_user_mode_work(regs, nr);
 
 	/*


