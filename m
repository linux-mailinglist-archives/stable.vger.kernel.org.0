Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86C333E051
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 22:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhCPVRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 17:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbhCPVRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 17:17:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF32C061756;
        Tue, 16 Mar 2021 14:17:08 -0700 (PDT)
Date:   Tue, 16 Mar 2021 21:17:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615929425;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w+ElagURH1gmaM8b92iEvfWRXDIPmYdOtcE2VlxkqlI=;
        b=rrEgJpUrtAw8+6ALVScfdf7c0ZKeak4h1TXBKWGEEZnzkMduNL04+4TWaM+omEjNcjqEyY
        OiKLLogyLJPFtU3OVkGultFL58uZI90sB0V8/PYBQu/c3LPDd+HPT99sp60KizvP9Wi+aR
        IUBtcs7Xo1IiQLrzFuTgglEXvJHaPp5tLDioSpdX+C14ArxNBcBzPNSWWa1sa+71ldqp6y
        rCzYp4uf0m+ZUu4OtXCZCiVmV8LUGG23JHuH9jXlXlfXnOyhSQaqdcfcv5Ed5sPloetI6+
        JukA+WsKiVD3lWktut4embhSR3jrijI6U8zjUuB711/sU50/VUnX8vjqCI7M9Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615929425;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w+ElagURH1gmaM8b92iEvfWRXDIPmYdOtcE2VlxkqlI=;
        b=DN8bBIkZGxdwzNi+fFVe5qoM7LWb7985beAc5lfNaCcix6H16Z1DilM7QZ0BxZitvvfIhd
        YLTZcwD/U0EHkrDw==
From:   "tip-bot2 for Oleg Nesterov" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86: Introduce TS_COMPAT_RESTART to fix
 get_nr_restart_syscall()
Cc:     Jan Kratochvil <jan.kratochvil@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210201174709.GA17895@redhat.com>
References: <20210201174709.GA17895@redhat.com>
MIME-Version: 1.0
Message-ID: <161592942471.398.9962549253199373067.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     8c150ba2fb5995c84a7a43848250d444a3329a7d
Gitweb:        https://git.kernel.org/tip/8c150ba2fb5995c84a7a43848250d444a3329a7d
Author:        Oleg Nesterov <oleg@redhat.com>
AuthorDate:    Mon, 01 Feb 2021 18:47:09 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 16 Mar 2021 22:13:11 +01:00

x86: Introduce TS_COMPAT_RESTART to fix get_nr_restart_syscall()

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

---
 arch/x86/include/asm/thread_info.h | 14 +++++++++++++-
 arch/x86/kernel/signal.c           | 24 +-----------------------
 2 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index c2dc29e..30d1d18 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -214,10 +214,22 @@ static inline int arch_within_stack_frames(const void * const stack,
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
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index ea794a0..6c26d2c 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -766,30 +766,8 @@ handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 
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
