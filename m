Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C16134444E
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhCVM70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:59:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232881AbhCVM5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:57:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91D24619C2;
        Mon, 22 Mar 2021 12:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417348;
        bh=R0AD4JARSP+UaJ6DoAJhOPWN4PUtJCj7ZHwK9Tf/0AY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dCuFV3ELPqXngISQpZGhE1HCGbLSPqTe77xL9nV4WsUiSfCKtQa5eOsyTw44T4os9
         P2dVSu8PqTxs9RiXmlXVhM6EeV7OEP3CyJlWNS4LCNECd4Oz9i14N3xjNtVKII8snB
         OzHESF+YMumISMelse/9BCdfEFzgIB02/pSLL8es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kratochvil <jan.kratochvil@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.14 39/43] x86: Introduce TS_COMPAT_RESTART to fix get_nr_restart_syscall()
Date:   Mon, 22 Mar 2021 13:29:20 +0100
Message-Id: <20210322121921.284199713@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.053255560@linuxfoundation.org>
References: <20210322121920.053255560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit 8c150ba2fb5995c84a7a43848250d444a3329a7d upstream.

The comment in get_nr_restart_syscall() says:

	 * The problem is that we can get here when ptrace pokes
	 * syscall-like values into regs even if we're not in a syscall
	 * at all.

Yes, but if not in a syscall then the

	status & (TS_COMPAT|TS_I386_REGS_POKED)

check below can't really help:

	- TS_COMPAT can't be set

	- TS_I386_REGS_POKED is only set if regs->orig_ax was changed by
	  32bit debugger; and even in this case get_nr_restart_syscall()
	  is only correct if the tracee is 32bit too.

Suppose that a 64bit debugger plays with a 32bit tracee and

	* Tracee calls sleep(2)	// TS_COMPAT is set
	* User interrupts the tracee by CTRL-C after 1 sec and does
	  "(gdb) call func()"
	* gdb saves the regs by PTRACE_GETREGS
	* does PTRACE_SETREGS to set %rip='func' and %orig_rax=-1
	* PTRACE_CONT		// TS_COMPAT is cleared
	* func() hits int3.
	* Debugger catches SIGTRAP.
	* Restore original regs by PTRACE_SETREGS.
	* PTRACE_CONT

get_nr_restart_syscall() wrongly returns __NR_restart_syscall==219, the
tracee calls ia32_sys_call_table[219] == sys_madvise.

Add the sticky TS_COMPAT_RESTART flag which survives after return to user
mode. It's going to be removed in the next step again by storing the
information in the restart block. As a further cleanup it might be possible
to remove also TS_I386_REGS_POKED with that.

Test-case:

  $ cvs -d :pserver:anoncvs:anoncvs@sourceware.org:/cvs/systemtap co ptrace-tests
  $ gcc -o erestartsys-trap-debuggee ptrace-tests/tests/erestartsys-trap-debuggee.c --m32
  $ gcc -o erestartsys-trap-debugger ptrace-tests/tests/erestartsys-trap-debugger.c -lutil
  $ ./erestartsys-trap-debugger
  Unexpected: retval 1, errno 22
  erestartsys-trap-debugger: ptrace-tests/tests/erestartsys-trap-debugger.c:421

Fixes: 609c19a385c8 ("x86/ptrace: Stop setting TS_COMPAT in ptrace code")
Reported-by: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210201174709.GA17895@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/thread_info.h |   14 +++++++++++++-
 arch/x86/kernel/signal.c           |   24 +-----------------------
 2 files changed, 14 insertions(+), 24 deletions(-)

--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -238,10 +238,22 @@ static inline int arch_within_stack_fram
  */
 #define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
 
+#ifndef __ASSEMBLY__
 #ifdef CONFIG_COMPAT
 #define TS_I386_REGS_POKED	0x0004	/* regs poked by 32-bit ptracer */
+#define TS_COMPAT_RESTART	0x0008
+
+#define arch_set_restart_data	arch_set_restart_data
+
+static inline void arch_set_restart_data(struct restart_block *restart)
+{
+	struct thread_info *ti = current_thread_info();
+	if (ti->status & TS_COMPAT)
+		ti->status |= TS_COMPAT_RESTART;
+	else
+		ti->status &= ~TS_COMPAT_RESTART;
+}
 #endif
-#ifndef __ASSEMBLY__
 
 #ifdef CONFIG_X86_32
 #define in_ia32_syscall() true
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -769,30 +769,8 @@ handle_signal(struct ksignal *ksig, stru
 
 static inline unsigned long get_nr_restart_syscall(const struct pt_regs *regs)
 {
-	/*
-	 * This function is fundamentally broken as currently
-	 * implemented.
-	 *
-	 * The idea is that we want to trigger a call to the
-	 * restart_block() syscall and that we want in_ia32_syscall(),
-	 * in_x32_syscall(), etc. to match whatever they were in the
-	 * syscall being restarted.  We assume that the syscall
-	 * instruction at (regs->ip - 2) matches whatever syscall
-	 * instruction we used to enter in the first place.
-	 *
-	 * The problem is that we can get here when ptrace pokes
-	 * syscall-like values into regs even if we're not in a syscall
-	 * at all.
-	 *
-	 * For now, we maintain historical behavior and guess based on
-	 * stored state.  We could do better by saving the actual
-	 * syscall arch in restart_block or (with caveats on x32) by
-	 * checking if regs->ip points to 'int $0x80'.  The current
-	 * behavior is incorrect if a tracer has a different bitness
-	 * than the tracee.
-	 */
 #ifdef CONFIG_IA32_EMULATION
-	if (current_thread_info()->status & (TS_COMPAT|TS_I386_REGS_POKED))
+	if (current_thread_info()->status & TS_COMPAT_RESTART)
 		return __NR_ia32_restart_syscall;
 #endif
 #ifdef CONFIG_X86_X32_ABI


