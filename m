Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC3513FFEE
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbgAPXq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:46:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:49634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390881AbgAPXV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A63E2087E;
        Thu, 16 Jan 2020 23:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216917;
        bh=KnNF++O83Xcivapna5ZWxJ3A/nCVJ2nlj6WaYyZBObc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JG4l0MhdL6qrS9D0QEDOHURKZn32BtDxJbBXJ07uoaYlwtzk+Tb7SUCDTiGcF5ZaU
         /nS6H1HUhHwTsc7EF152yVcgij6DKelSUtxNqY01INMUFZp0xsLRn8CzEORiXc73cB
         Jv+8jMCJloVcTeT0UixXQmc1SfhsUHMPXHDqQfj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.4 047/203] syscalls/x86: Wire up COMPAT_SYSCALL_DEFINE0
Date:   Fri, 17 Jan 2020 00:16:04 +0100
Message-Id: <20200116231748.097040033@linuxfoundation.org>
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

From: Andy Lutomirski <luto@kernel.org>

commit cf3b83e19d7c928e05a5d193c375463182c6029a upstream.

x86 has special handling for COMPAT_SYSCALL_DEFINEx, but there was
no override for COMPAT_SYSCALL_DEFINE0.  Wire it up so that we can
use it for rt_sigreturn.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H . Peter Anvin <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20191008224049.115427-3-samitolvanen@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/syscall_wrapper.h |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/syscall_wrapper.h
+++ b/arch/x86/include/asm/syscall_wrapper.h
@@ -28,13 +28,21 @@
  * kernel/sys_ni.c and SYS_NI in kernel/time/posix-stubs.c to cover this
  * case as well.
  */
+#define __IA32_COMPAT_SYS_STUB0(x, name)				\
+	asmlinkage long __ia32_compat_sys_##name(const struct pt_regs *regs);\
+	ALLOW_ERROR_INJECTION(__ia32_compat_sys_##name, ERRNO);		\
+	asmlinkage long __ia32_compat_sys_##name(const struct pt_regs *regs)\
+	{								\
+		return __se_compat_sys_##name();			\
+	}
+
 #define __IA32_COMPAT_SYS_STUBx(x, name, ...)				\
 	asmlinkage long __ia32_compat_sys##name(const struct pt_regs *regs);\
 	ALLOW_ERROR_INJECTION(__ia32_compat_sys##name, ERRNO);		\
 	asmlinkage long __ia32_compat_sys##name(const struct pt_regs *regs)\
 	{								\
 		return __se_compat_sys##name(SC_IA32_REGS_TO_ARGS(x,__VA_ARGS__));\
-	}								\
+	}
 
 #define __IA32_SYS_STUBx(x, name, ...)					\
 	asmlinkage long __ia32_sys##name(const struct pt_regs *regs);	\
@@ -76,15 +84,24 @@
  * of the x86-64-style parameter ordering of x32 syscalls. The syscalls common
  * with x86_64 obviously do not need such care.
  */
+#define __X32_COMPAT_SYS_STUB0(x, name, ...)				\
+	asmlinkage long __x32_compat_sys_##name(const struct pt_regs *regs);\
+	ALLOW_ERROR_INJECTION(__x32_compat_sys_##name, ERRNO);		\
+	asmlinkage long __x32_compat_sys_##name(const struct pt_regs *regs)\
+	{								\
+		return __se_compat_sys_##name();\
+	}
+
 #define __X32_COMPAT_SYS_STUBx(x, name, ...)				\
 	asmlinkage long __x32_compat_sys##name(const struct pt_regs *regs);\
 	ALLOW_ERROR_INJECTION(__x32_compat_sys##name, ERRNO);		\
 	asmlinkage long __x32_compat_sys##name(const struct pt_regs *regs)\
 	{								\
 		return __se_compat_sys##name(SC_X86_64_REGS_TO_ARGS(x,__VA_ARGS__));\
-	}								\
+	}
 
 #else /* CONFIG_X86_X32 */
+#define __X32_COMPAT_SYS_STUB0(x, name)
 #define __X32_COMPAT_SYS_STUBx(x, name, ...)
 #endif /* CONFIG_X86_X32 */
 
@@ -95,6 +112,17 @@
  * mapping of registers to parameters, we need to generate stubs for each
  * of them.
  */
+#define COMPAT_SYSCALL_DEFINE0(name)					\
+	static long __se_compat_sys_##name(void);			\
+	static inline long __do_compat_sys_##name(void);		\
+	__IA32_COMPAT_SYS_STUB0(x, name)				\
+	__X32_COMPAT_SYS_STUB0(x, name)					\
+	static long __se_compat_sys_##name(void)			\
+	{								\
+		return __do_compat_sys_##name();			\
+	}								\
+	static inline long __do_compat_sys_##name(void)
+
 #define COMPAT_SYSCALL_DEFINEx(x, name, ...)					\
 	static long __se_compat_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__));	\
 	static inline long __do_compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));\


