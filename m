Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F00E13FFF6
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731041AbgAPXqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:46:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390857AbgAPXVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95F35206D9;
        Thu, 16 Jan 2020 23:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216901;
        bh=uCgsCD/PC8upsUFz8l4cub7gwgwpAiMz3Y8qPsgJln0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+nRt6OMvuiakbes7GAgo/rVURrJaR4DKaKJbJQjXB+VVaPE0/I/9MZNkY7Fp0Mg/
         4hWyRxAVAjEZrgvt5O+INKAeoJ/MJHaATQZWrM0RbqjfgcQ/XEGnQbex6eJ3G79xnI
         QoDCIWdnsTkfEMAjDHxgYbRJr+ion51+256VuluY=
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
Subject: [PATCH 5.4 050/203] syscalls/x86: Fix function types in COND_SYSCALL
Date:   Fri, 17 Jan 2020 00:16:07 +0100
Message-Id: <20200116231748.356024867@linuxfoundation.org>
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

commit 6e4847640c6aebcaa2d9b3686cecc91b41f09269 upstream.

Define a weak function in COND_SYSCALL instead of a weak alias to
sys_ni_syscall(), which has an incompatible type. This fixes indirect
call mismatches with Control-Flow Integrity (CFI) checking.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H . Peter Anvin <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20191008224049.115427-6-samitolvanen@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/syscall_wrapper.h |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/syscall_wrapper.h
+++ b/arch/x86/include/asm/syscall_wrapper.h
@@ -6,6 +6,8 @@
 #ifndef _ASM_X86_SYSCALL_WRAPPER_H
 #define _ASM_X86_SYSCALL_WRAPPER_H
 
+struct pt_regs;
+
 /* Mapping of registers to parameters for syscalls on x86-64 and x32 */
 #define SC_X86_64_REGS_TO_ARGS(x, ...)					\
 	__MAP(x,__SC_ARGS						\
@@ -64,9 +66,15 @@
 	SYSCALL_ALIAS(__ia32_sys_##sname, __x64_sys_##sname);		\
 	asmlinkage long __x64_sys_##sname(const struct pt_regs *__unused)
 
-#define COND_SYSCALL(name)						\
-	cond_syscall(__x64_sys_##name);					\
-	cond_syscall(__ia32_sys_##name)
+#define COND_SYSCALL(name)							\
+	asmlinkage __weak long __x64_sys_##name(const struct pt_regs *__unused)	\
+	{									\
+		return sys_ni_syscall();					\
+	}									\
+	asmlinkage __weak long __ia32_sys_##name(const struct pt_regs *__unused)\
+	{									\
+		return sys_ni_syscall();					\
+	}
 
 #define SYS_NI(name)							\
 	SYSCALL_ALIAS(__x64_sys_##name, sys_ni_posix_timers);		\
@@ -218,7 +226,11 @@
 #endif
 
 #ifndef COND_SYSCALL
-#define COND_SYSCALL(name) cond_syscall(__x64_sys_##name)
+#define COND_SYSCALL(name) 							\
+	asmlinkage __weak long __x64_sys_##name(const struct pt_regs *__unused)	\
+	{									\
+		return sys_ni_syscall();					\
+	}
 #endif
 
 #ifndef SYS_NI
@@ -230,7 +242,6 @@
  * For VSYSCALLS, we need to declare these three syscalls with the new
  * pt_regs-based calling convention for in-kernel use.
  */
-struct pt_regs;
 asmlinkage long __x64_sys_getcpu(const struct pt_regs *regs);
 asmlinkage long __x64_sys_gettimeofday(const struct pt_regs *regs);
 asmlinkage long __x64_sys_time(const struct pt_regs *regs);


