Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 251EC13FFDB
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390794AbgAPXVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:21:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390793AbgAPXVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC92C2072B;
        Thu, 16 Jan 2020 23:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216877;
        bh=++ojnTPojwk+HgVg78h7H+X+w8TmRkZDj7wnWMjCXaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8Sgr8WDnVBItK8NLxYtql00eWpps7ERmgt7kskYnv1lW1zTgQQDCqW8jA4El9U3o
         QPZNv9iCWGE5DTL39cVWim0n56bS1oLSTABsaLLvwN7jlTAAVO3kzK+EsX22S0KLTU
         uTRmR+JOhuwi198ViqobuYZkS3Lk0/HCwFZQdsbQ=
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
Subject: [PATCH 5.4 048/203] syscalls/x86: Use COMPAT_SYSCALL_DEFINE0 for IA32 (rt_)sigreturn
Date:   Fri, 17 Jan 2020 00:16:05 +0100
Message-Id: <20200116231748.186323489@linuxfoundation.org>
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

commit 00198a6eaf66609de5e4de9163bb42c7ca9dd7b7 upstream.

Use COMPAT_SYSCALL_DEFINE0 to define (rt_)sigreturn() syscalls to
replace sys32_sigreturn() and sys32_rt_sigreturn(). This fixes indirect
call mismatches with Control-Flow Integrity (CFI) checking.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H . Peter Anvin <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20191008224049.115427-4-samitolvanen@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/syscalls/syscall_32.tbl |    4 ++--
 arch/x86/ia32/ia32_signal.c            |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -130,7 +130,7 @@
 116	i386	sysinfo			sys_sysinfo			__ia32_compat_sys_sysinfo
 117	i386	ipc			sys_ipc				__ia32_compat_sys_ipc
 118	i386	fsync			sys_fsync			__ia32_sys_fsync
-119	i386	sigreturn		sys_sigreturn			sys32_sigreturn
+119	i386	sigreturn		sys_sigreturn			__ia32_compat_sys_sigreturn
 120	i386	clone			sys_clone			__ia32_compat_sys_x86_clone
 121	i386	setdomainname		sys_setdomainname		__ia32_sys_setdomainname
 122	i386	uname			sys_newuname			__ia32_sys_newuname
@@ -184,7 +184,7 @@
 170	i386	setresgid		sys_setresgid16			__ia32_sys_setresgid16
 171	i386	getresgid		sys_getresgid16			__ia32_sys_getresgid16
 172	i386	prctl			sys_prctl			__ia32_sys_prctl
-173	i386	rt_sigreturn		sys_rt_sigreturn		sys32_rt_sigreturn
+173	i386	rt_sigreturn		sys_rt_sigreturn		__ia32_compat_sys_rt_sigreturn
 174	i386	rt_sigaction		sys_rt_sigaction		__ia32_compat_sys_rt_sigaction
 175	i386	rt_sigprocmask		sys_rt_sigprocmask		__ia32_compat_sys_rt_sigprocmask
 176	i386	rt_sigpending		sys_rt_sigpending		__ia32_compat_sys_rt_sigpending
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -21,6 +21,7 @@
 #include <linux/personality.h>
 #include <linux/compat.h>
 #include <linux/binfmts.h>
+#include <linux/syscalls.h>
 #include <asm/ucontext.h>
 #include <linux/uaccess.h>
 #include <asm/fpu/internal.h>
@@ -118,7 +119,7 @@ static int ia32_restore_sigcontext(struc
 	return err;
 }
 
-asmlinkage long sys32_sigreturn(void)
+COMPAT_SYSCALL_DEFINE0(sigreturn)
 {
 	struct pt_regs *regs = current_pt_regs();
 	struct sigframe_ia32 __user *frame = (struct sigframe_ia32 __user *)(regs->sp-8);
@@ -144,7 +145,7 @@ badframe:
 	return 0;
 }
 
-asmlinkage long sys32_rt_sigreturn(void)
+COMPAT_SYSCALL_DEFINE0(rt_sigreturn)
 {
 	struct pt_regs *regs = current_pt_regs();
 	struct rt_sigframe_ia32 __user *frame;


