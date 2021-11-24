Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFCA45C693
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352411AbhKXOKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:53830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351734AbhKXOGn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:06:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DCBC61A8C;
        Wed, 24 Nov 2021 13:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759563;
        bh=dKaYYIVMpX/0XKkjaoH7bSiik9pm5y0edqovy2lDJC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=egpKmPUYN3xrwsViYBNWhw0UjvOt0JL1pyM/Efb8b1JJHucftSjelgveHcci0Woi6
         Vikfb52g6VSw7BvQuZZTT4CqJtok6yyne1WJM2ZBfMhJf5vcV19eO1Q8ogsSNcqmRm
         FBoAJoBm+jhrOBuJrXpHKQwoxhoIXzMm45/VXQzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Backlund <tmb@iki.fi>
Subject: [PATCH 5.15 264/279] signal: Replace force_sigsegv(SIGSEGV) with force_fatal_sig(SIGSEGV)
Date:   Wed, 24 Nov 2021 12:59:11 +0100
Message-Id: <20211124115727.823982416@linuxfoundation.org>
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

commit e21294a7aaae32c5d7154b187113a04db5852e37 upstream.

Now that force_fatal_sig exists it is unnecessary and a bit confusing
to use force_sigsegv in cases where the simpler force_fatal_sig is
wanted.  So change every instance we can to make the code clearer.

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Link: https://lkml.kernel.org/r/877de7jrev.fsf@disp2133
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Backlund <tmb@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arc/kernel/process.c       |    2 +-
 arch/m68k/kernel/traps.c        |    2 +-
 arch/powerpc/kernel/signal_32.c |    2 +-
 arch/powerpc/kernel/signal_64.c |    4 ++--
 arch/s390/kernel/traps.c        |    2 +-
 arch/um/kernel/trap.c           |    2 +-
 arch/x86/kernel/vm86_32.c       |    2 +-
 fs/exec.c                       |    2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

--- a/arch/arc/kernel/process.c
+++ b/arch/arc/kernel/process.c
@@ -294,7 +294,7 @@ int elf_check_arch(const struct elf32_hd
 	eflags = x->e_flags;
 	if ((eflags & EF_ARC_OSABI_MSK) != EF_ARC_OSABI_CURRENT) {
 		pr_err("ABI mismatch - you need newer toolchain\n");
-		force_sigsegv(SIGSEGV);
+		force_fatal_sig(SIGSEGV);
 		return 0;
 	}
 
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -1145,7 +1145,7 @@ asmlinkage void set_esp0(unsigned long s
  */
 asmlinkage void fpsp040_die(void)
 {
-	force_sigsegv(SIGSEGV);
+	force_fatal_sig(SIGSEGV);
 }
 
 #ifdef CONFIG_M68KFPU_EMU
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -1063,7 +1063,7 @@ SYSCALL_DEFINE3(swapcontext, struct ucon
 	 * We kill the task with a SIGSEGV in this situation.
 	 */
 	if (do_setcontext(new_ctx, regs, 0)) {
-		force_sigsegv(SIGSEGV);
+		force_fatal_sig(SIGSEGV);
 		return -EFAULT;
 	}
 
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -704,7 +704,7 @@ SYSCALL_DEFINE3(swapcontext, struct ucon
 	 */
 
 	if (__get_user_sigset(&set, &new_ctx->uc_sigmask)) {
-		force_sigsegv(SIGSEGV);
+		force_fatal_sig(SIGSEGV);
 		return -EFAULT;
 	}
 	set_current_blocked(&set);
@@ -713,7 +713,7 @@ SYSCALL_DEFINE3(swapcontext, struct ucon
 		return -EFAULT;
 	if (__unsafe_restore_sigcontext(current, NULL, 0, &new_ctx->uc_mcontext)) {
 		user_read_access_end();
-		force_sigsegv(SIGSEGV);
+		force_fatal_sig(SIGSEGV);
 		return -EFAULT;
 	}
 	user_read_access_end();
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -84,7 +84,7 @@ static void default_trap_handler(struct
 {
 	if (user_mode(regs)) {
 		report_user_fault(regs, SIGSEGV, 0);
-		force_sigsegv(SIGSEGV);
+		force_fatal_sig(SIGSEGV);
 	} else
 		die(regs, "Unknown program exception");
 }
--- a/arch/um/kernel/trap.c
+++ b/arch/um/kernel/trap.c
@@ -158,7 +158,7 @@ static void bad_segv(struct faultinfo fi
 
 void fatal_sigsegv(void)
 {
-	force_sigsegv(SIGSEGV);
+	force_fatal_sig(SIGSEGV);
 	do_signal(&current->thread.regs);
 	/*
 	 * This is to tell gcc that we're not returning - do_signal
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -162,7 +162,7 @@ Efault_end:
 	user_access_end();
 Efault:
 	pr_alert("could not access userspace vm86 info\n");
-	force_sigsegv(SIGSEGV);
+	force_fatal_sig(SIGSEGV);
 	goto exit_vm86;
 }
 
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1852,7 +1852,7 @@ out:
 	 * SIGSEGV.
 	 */
 	if (bprm->point_of_no_return && !fatal_signal_pending(current))
-		force_sigsegv(SIGSEGV);
+		force_fatal_sig(SIGSEGV);
 
 out_unmark:
 	current->fs->in_exec = 0;


