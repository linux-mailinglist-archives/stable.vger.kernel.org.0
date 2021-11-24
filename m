Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582CE45C696
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348003AbhKXOKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:55688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354212AbhKXOGu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:06:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8209E61139;
        Wed, 24 Nov 2021 13:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759570;
        bh=ueG7dGSsgNOlLWhPQBSdzR0kfgDRfhTAP25hJGFmHMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DL5pwghUs7UD/TefDvR6Th5Syx32qPXZPOnM4TOw685CvKjt1fSP0dmrxLThNTuPo
         Kg3ZSMJtSBeLRt96KmLOhQMc2IGPbC81QqtSBed5u0Oh7MLPTkzt7C3FuM/fFCfAii
         2cSIMQQgXLMRqByonBD0gdlsBLby5WIX9Yp7FsOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyle Huey <me@kylehuey.com>,
        kernel test robot <oliver.sang@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Kyle Huey <khuey@kylehuey.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Backlund <tmb@iki.fi>
Subject: [PATCH 5.15 266/279] signal: Replace force_fatal_sig with force_exit_sig when in doubt
Date:   Wed, 24 Nov 2021 12:59:13 +0100
Message-Id: <20211124115727.891978287@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit fcb116bc43c8c37c052530ead79872f8b2615711 upstream.

Recently to prevent issues with SECCOMP_RET_KILL and similar signals
being changed before they are delivered SA_IMMUTABLE was added.

Unfortunately this broke debuggers[1][2] which reasonably expect
to be able to trap synchronous SIGTRAP and SIGSEGV even when
the target process is not configured to handle those signals.

Add force_exit_sig and use it instead of force_fatal_sig where
historically the code has directly called do_exit.  This has the
implementation benefits of going through the signal exit path
(including generating core dumps) without the danger of allowing
userspace to ignore or change these signals.

This avoids userspace regressions as older kernels exited with do_exit
which debuggers also can not intercept.

In the future is should be possible to improve the quality of
implementation of the kernel by changing some of these force_exit_sig
calls to force_fatal_sig.  That can be done where it matters on
a case-by-case basis with careful analysis.

Reported-by: Kyle Huey <me@kylehuey.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
[1] https://lkml.kernel.org/r/CAP045AoMY4xf8aC_4QU_-j7obuEPYgTcnQQP3Yxk=2X90jtpjw@mail.gmail.com
[2] https://lkml.kernel.org/r/20211117150258.GB5403@xsang-OptiPlex-9020
Fixes: 00b06da29cf9 ("signal: Add SA_IMMUTABLE to ensure forced siganls do not get changed")
Fixes: a3616a3c0272 ("signal/m68k: Use force_sigsegv(SIGSEGV) in fpsp040_die")
Fixes: 83a1f27ad773 ("signal/powerpc: On swapcontext failure force SIGSEGV")
Fixes: 9bc508cf0791 ("signal/s390: Use force_sigsegv in default_trap_handler")
Fixes: 086ec444f866 ("signal/sparc32: In setup_rt_frame and setup_fram use force_fatal_sig")
Fixes: c317d306d550 ("signal/sparc32: Exit with a fatal signal when try_to_clear_window_buffer fails")
Fixes: 695dd0d634df ("signal/x86: In emulate_vsyscall force a signal instead of calling do_exit")
Fixes: 1fbd60df8a85 ("signal/vm86_32: Properly send SIGSEGV when the vm86 state cannot be saved.")
Fixes: 941edc5bf174 ("exit/syscall_user_dispatch: Send ordinary signals on failure")
Link: https://lkml.kernel.org/r/871r3dqfv8.fsf_-_@email.froward.int.ebiederm.org
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Kees Cook <keescook@chromium.org>
Tested-by: Kyle Huey <khuey@kylehuey.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Backlund <tmb@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/m68k/kernel/traps.c              |    2 +-
 arch/powerpc/kernel/signal_32.c       |    2 +-
 arch/powerpc/kernel/signal_64.c       |    4 ++--
 arch/s390/kernel/traps.c              |    2 +-
 arch/sparc/kernel/signal_32.c         |    4 ++--
 arch/sparc/kernel/windows.c           |    2 +-
 arch/x86/entry/vsyscall/vsyscall_64.c |    2 +-
 arch/x86/kernel/vm86_32.c             |    2 +-
 include/linux/sched/signal.h          |    1 +
 kernel/entry/syscall_user_dispatch.c  |    4 ++--
 kernel/signal.c                       |   13 +++++++++++++
 11 files changed, 26 insertions(+), 12 deletions(-)

--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -1145,7 +1145,7 @@ asmlinkage void set_esp0(unsigned long s
  */
 asmlinkage void fpsp040_die(void)
 {
-	force_fatal_sig(SIGSEGV);
+	force_exit_sig(SIGSEGV);
 }
 
 #ifdef CONFIG_M68KFPU_EMU
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -1063,7 +1063,7 @@ SYSCALL_DEFINE3(swapcontext, struct ucon
 	 * We kill the task with a SIGSEGV in this situation.
 	 */
 	if (do_setcontext(new_ctx, regs, 0)) {
-		force_fatal_sig(SIGSEGV);
+		force_exit_sig(SIGSEGV);
 		return -EFAULT;
 	}
 
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -704,7 +704,7 @@ SYSCALL_DEFINE3(swapcontext, struct ucon
 	 */
 
 	if (__get_user_sigset(&set, &new_ctx->uc_sigmask)) {
-		force_fatal_sig(SIGSEGV);
+		force_exit_sig(SIGSEGV);
 		return -EFAULT;
 	}
 	set_current_blocked(&set);
@@ -713,7 +713,7 @@ SYSCALL_DEFINE3(swapcontext, struct ucon
 		return -EFAULT;
 	if (__unsafe_restore_sigcontext(current, NULL, 0, &new_ctx->uc_mcontext)) {
 		user_read_access_end();
-		force_fatal_sig(SIGSEGV);
+		force_exit_sig(SIGSEGV);
 		return -EFAULT;
 	}
 	user_read_access_end();
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -84,7 +84,7 @@ static void default_trap_handler(struct
 {
 	if (user_mode(regs)) {
 		report_user_fault(regs, SIGSEGV, 0);
-		force_fatal_sig(SIGSEGV);
+		force_exit_sig(SIGSEGV);
 	} else
 		die(regs, "Unknown program exception");
 }
--- a/arch/sparc/kernel/signal_32.c
+++ b/arch/sparc/kernel/signal_32.c
@@ -244,7 +244,7 @@ static int setup_frame(struct ksignal *k
 		get_sigframe(ksig, regs, sigframe_size);
 
 	if (invalid_frame_pointer(sf, sigframe_size)) {
-		force_fatal_sig(SIGILL);
+		force_exit_sig(SIGILL);
 		return -EINVAL;
 	}
 
@@ -336,7 +336,7 @@ static int setup_rt_frame(struct ksignal
 	sf = (struct rt_signal_frame __user *)
 		get_sigframe(ksig, regs, sigframe_size);
 	if (invalid_frame_pointer(sf, sigframe_size)) {
-		force_fatal_sig(SIGILL);
+		force_exit_sig(SIGILL);
 		return -EINVAL;
 	}
 
--- a/arch/sparc/kernel/windows.c
+++ b/arch/sparc/kernel/windows.c
@@ -122,7 +122,7 @@ void try_to_clear_window_buffer(struct p
 		if ((sp & 7) ||
 		    copy_to_user((char __user *) sp, &tp->reg_window[window],
 				 sizeof(struct reg_window32))) {
-			force_fatal_sig(SIGILL);
+			force_exit_sig(SIGILL);
 			return;
 		}
 	}
--- a/arch/x86/entry/vsyscall/vsyscall_64.c
+++ b/arch/x86/entry/vsyscall/vsyscall_64.c
@@ -226,7 +226,7 @@ bool emulate_vsyscall(unsigned long erro
 	if ((!tmp && regs->orig_ax != syscall_nr) || regs->ip != address) {
 		warn_bad_vsyscall(KERN_DEBUG, regs,
 				  "seccomp tried to change syscall nr or ip");
-		force_fatal_sig(SIGSYS);
+		force_exit_sig(SIGSYS);
 		return true;
 	}
 	regs->orig_ax = -1;
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -162,7 +162,7 @@ Efault_end:
 	user_access_end();
 Efault:
 	pr_alert("could not access userspace vm86 info\n");
-	force_fatal_sig(SIGSEGV);
+	force_exit_sig(SIGSEGV);
 	goto exit_vm86;
 }
 
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -339,6 +339,7 @@ extern __must_check bool do_notify_paren
 extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int);
 extern void force_fatal_sig(int);
+extern void force_exit_sig(int);
 extern int send_sig(int, struct task_struct *, int);
 extern int zap_other_threads(struct task_struct *p);
 extern struct sigqueue *sigqueue_alloc(void);
--- a/kernel/entry/syscall_user_dispatch.c
+++ b/kernel/entry/syscall_user_dispatch.c
@@ -48,7 +48,7 @@ bool syscall_user_dispatch(struct pt_reg
 		 * the selector is loaded by userspace.
 		 */
 		if (unlikely(__get_user(state, sd->selector))) {
-			force_fatal_sig(SIGSEGV);
+			force_exit_sig(SIGSEGV);
 			return true;
 		}
 
@@ -56,7 +56,7 @@ bool syscall_user_dispatch(struct pt_reg
 			return false;
 
 		if (state != SYSCALL_DISPATCH_FILTER_BLOCK) {
-			force_fatal_sig(SIGSYS);
+			force_exit_sig(SIGSYS);
 			return true;
 		}
 	}
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1671,6 +1671,19 @@ void force_fatal_sig(int sig)
 	force_sig_info_to_task(&info, current, HANDLER_SIG_DFL);
 }
 
+void force_exit_sig(int sig)
+{
+	struct kernel_siginfo info;
+
+	clear_siginfo(&info);
+	info.si_signo = sig;
+	info.si_errno = 0;
+	info.si_code = SI_KERNEL;
+	info.si_pid = 0;
+	info.si_uid = 0;
+	force_sig_info_to_task(&info, current, HANDLER_EXIT);
+}
+
 /*
  * When things go south during signal handling, we
  * will force a SIGSEGV. And if the signal that caused


