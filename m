Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2FA313FD12
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388255AbgAPXVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:21:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390856AbgAPXVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F4C220684;
        Thu, 16 Jan 2020 23:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216898;
        bh=128e+somJDcJtHvjLzOsfEVT1tUN9JSWtlTuDdHk/RY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjV4ezNyPJo5eyCRxAtn1HYTdE+4WviVc5e6odkHMCApVg6/mGMIEVGMdHu3tARas
         /dbPfK9NG15RYcCXqyRR8B+Qr/EfwnAm8txChvKYjSQJVhis8GBimVTiGs9L0f+tMU
         zI40uTotfJLC7gnQLX4FYDhNU+ADWzvSk3ZMInP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.4 049/203] syscalls/x86: Use the correct function type for sys_ni_syscall
Date:   Fri, 17 Jan 2020 00:16:06 +0100
Message-Id: <20200116231748.274095943@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

commit f48f01a92cca09e86d46c91d8edf9d5a71c61727 upstream.

Use the correct function type for sys_ni_syscall() in system
call tables to fix indirect call mismatches with Control-Flow
Integrity (CFI) checking.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H . Peter Anvin <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20191008224049.115427-5-samitolvanen@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/syscall_32.c            |    8 +++-----
 arch/x86/entry/syscall_64.c            |   14 ++++++++++----
 arch/x86/entry/syscalls/syscall_32.tbl |    4 ++--
 3 files changed, 15 insertions(+), 11 deletions(-)

--- a/arch/x86/entry/syscall_32.c
+++ b/arch/x86/entry/syscall_32.c
@@ -10,13 +10,11 @@
 #ifdef CONFIG_IA32_EMULATION
 /* On X86_64, we use struct pt_regs * to pass parameters to syscalls */
 #define __SYSCALL_I386(nr, sym, qual) extern asmlinkage long sym(const struct pt_regs *);
-
-/* this is a lie, but it does not hurt as sys_ni_syscall just returns -EINVAL */
-extern asmlinkage long sys_ni_syscall(const struct pt_regs *);
-
+#define __sys_ni_syscall __ia32_sys_ni_syscall
 #else /* CONFIG_IA32_EMULATION */
 #define __SYSCALL_I386(nr, sym, qual) extern asmlinkage long sym(unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long);
 extern asmlinkage long sys_ni_syscall(unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long);
+#define __sys_ni_syscall sys_ni_syscall
 #endif /* CONFIG_IA32_EMULATION */
 
 #include <asm/syscalls_32.h>
@@ -29,6 +27,6 @@ __visible const sys_call_ptr_t ia32_sys_
 	 * Smells like a compiler bug -- it doesn't work
 	 * when the & below is removed.
 	 */
-	[0 ... __NR_syscall_compat_max] = &sys_ni_syscall,
+	[0 ... __NR_syscall_compat_max] = &__sys_ni_syscall,
 #include <asm/syscalls_32.h>
 };
--- a/arch/x86/entry/syscall_64.c
+++ b/arch/x86/entry/syscall_64.c
@@ -4,11 +4,17 @@
 #include <linux/linkage.h>
 #include <linux/sys.h>
 #include <linux/cache.h>
+#include <linux/syscalls.h>
 #include <asm/asm-offsets.h>
 #include <asm/syscall.h>
 
-/* this is a lie, but it does not hurt as sys_ni_syscall just returns -EINVAL */
-extern asmlinkage long sys_ni_syscall(const struct pt_regs *);
+extern asmlinkage long sys_ni_syscall(void);
+
+SYSCALL_DEFINE0(ni_syscall)
+{
+	return sys_ni_syscall();
+}
+
 #define __SYSCALL_64(nr, sym, qual) extern asmlinkage long sym(const struct pt_regs *);
 #define __SYSCALL_X32(nr, sym, qual) __SYSCALL_64(nr, sym, qual)
 #include <asm/syscalls_64.h>
@@ -23,7 +29,7 @@ asmlinkage const sys_call_ptr_t sys_call
 	 * Smells like a compiler bug -- it doesn't work
 	 * when the & below is removed.
 	 */
-	[0 ... __NR_syscall_max] = &sys_ni_syscall,
+	[0 ... __NR_syscall_max] = &__x64_sys_ni_syscall,
 #include <asm/syscalls_64.h>
 };
 
@@ -40,7 +46,7 @@ asmlinkage const sys_call_ptr_t x32_sys_
 	 * Smells like a compiler bug -- it doesn't work
 	 * when the & below is removed.
 	 */
-	[0 ... __NR_syscall_x32_max] = &sys_ni_syscall,
+	[0 ... __NR_syscall_x32_max] = &__x64_sys_ni_syscall,
 #include <asm/syscalls_64.h>
 };
 
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -124,7 +124,7 @@
 110	i386	iopl			sys_iopl			__ia32_sys_iopl
 111	i386	vhangup			sys_vhangup			__ia32_sys_vhangup
 112	i386	idle
-113	i386	vm86old			sys_vm86old			sys_ni_syscall
+113	i386	vm86old			sys_vm86old			__ia32_sys_ni_syscall
 114	i386	wait4			sys_wait4			__ia32_compat_sys_wait4
 115	i386	swapoff			sys_swapoff			__ia32_sys_swapoff
 116	i386	sysinfo			sys_sysinfo			__ia32_compat_sys_sysinfo
@@ -177,7 +177,7 @@
 163	i386	mremap			sys_mremap			__ia32_sys_mremap
 164	i386	setresuid		sys_setresuid16			__ia32_sys_setresuid16
 165	i386	getresuid		sys_getresuid16			__ia32_sys_getresuid16
-166	i386	vm86			sys_vm86			sys_ni_syscall
+166	i386	vm86			sys_vm86			__ia32_sys_ni_syscall
 167	i386	query_module
 168	i386	poll			sys_poll			__ia32_sys_poll
 169	i386	nfsservctl


