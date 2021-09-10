Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDE840619D
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbhIJAnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232646AbhIJATC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13316610A3;
        Fri, 10 Sep 2021 00:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233063;
        bh=R7ov86etid4d199Hqd8/9xnm8bRV4UfwtJEkzTFOiz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRDzJNiBhBO3tGjwOumv15dddI/dzKWOYD4jtiY+chB1q3uilV5W5FAigfFX3Y+vE
         Rxxa2Yn0SZoV0Q3bZIFtBcdhjVkMJlNL70y8i8z5xGHCjSXMH904ajXlxVv1NwWVIU
         D+EzjmKpZPX1IxIoGb7F+OsUb/lt0T2NgdG/7rP2YA48I0D4pNj2FsgzCvYvbx6lwN
         X4tVxM035xtgMYef5m2Amn4R41W1MEIPMIxGxOcCFa3vTS4nbXETNkubN9Gl6pjz9j
         THVopoZcpZCKP1SJRD9y1ZPjH4YzA5fO7TtIjIX43D3Np6/LUcofDJOHO/DY22rNY5
         ZoLPtakNpmcHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jun Miao <jun.miao@windriver.com>,
        Jianwei Hu <jianwei.hu@windriver.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 76/99] selftests/x86: Fix error: variably modified 'altstack_data' at file scope
Date:   Thu,  9 Sep 2021 20:15:35 -0400
Message-Id: <20210910001558.173296-76-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jun Miao <jun.miao@windriver.com>

[ Upstream commit a051b2e56f2aa287b37ab0134a8af852f84e3f8e ]

A glibc 2.34 feature adds support for variable MINSIGSTKSZ and SIGSTKSZ.
When _DYNAMIC_STACK_SIZE_SOURCE or _GNU_SOURCE are defined, MINSIGSTKSZ
and SIGSTKSZ are no longer constant on Linux. glibc 2.34 flags code paths
assuming MINSIGSTKSZ or SIGSTKSZ are constant. Fix these error in x86 test.

Feature description and build error:

NEWS for version 2.34
=====================
Major new features:
 * Add _SC_MINSIGSTKSZ and _SC_SIGSTKSZ.  When _DYNAMIC_STACK_SIZE_SOURCE
   or _GNU_SOURCE are defined, MINSIGSTKSZ and SIGSTKSZ are no longer
   constant on Linux.  MINSIGSTKSZ is redefined to sysconf(_SC_MINSIGSTKSZ)
   and SIGSTKSZ is redefined to sysconf (_SC_SIGSTKSZ).  This supports
   dynamic sized register sets for modern architectural features like
   Arm SVE.
=====================

If _SC_SIGSTKSZ_SOURCE or _GNU_SOURCE are defined, MINSIGSTKSZ and SIGSTKSZ
are redefined as:

/* Default stack size for a signal handler: sysconf (SC_SIGSTKSZ).  */
 # undef SIGSTKSZ
 # define SIGSTKSZ sysconf (_SC_SIGSTKSZ)

/* Minimum stack size for a signal handler: SIGSTKSZ.  */
 # undef MINSIGSTKSZ
 # define MINSIGSTKSZ SIGSTKSZ

Compilation will fail if the source assumes constant MINSIGSTKSZ or
SIGSTKSZ.

Build error with the GNU C Library 2.34:
DEBUG:	| sigreturn.c:150:13: error: variably modified 'altstack_data' at file scope
| sigreturn.c:150:13: error: variably modified 'altstack_data' at file scope
DEBUG:	|   150 | static char altstack_data[SIGSTKSZ];
|   150 | static char altstack_data[SIGSTKSZ];
DEBUG:	|       |             ^~~~~~~~~~~~~

DEBUG:  | single_step_syscall.c:60:22: error: variably modified 'altstack_data' at file scope
DEBUG:  |   60 | static unsigned char altstack_data[SIGSTKSZ];
DEBUG:  |      |                      ^~~~~~~~~~~~~

Fixed commit log to improve formatting and clarity:
Shuah Khan <skhan@linuxfoundation.org>

Link: https://sourceware.org/pipermail/libc-alpha/2021-January/121996.html
Link: https://sourceware.org/pipermail/libc-alpha/2021-August/129718.html
Suggested-by: Jianwei Hu <jianwei.hu@windriver.com>
Signed-off-by: Jun Miao <jun.miao@windriver.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/x86/mov_ss_trap.c         | 4 ++--
 tools/testing/selftests/x86/sigreturn.c           | 7 +++----
 tools/testing/selftests/x86/single_step_syscall.c | 4 ++--
 tools/testing/selftests/x86/syscall_arg_fault.c   | 7 +++----
 4 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/x86/mov_ss_trap.c b/tools/testing/selftests/x86/mov_ss_trap.c
index 6da0ac3f0135..cc3de6ff9fba 100644
--- a/tools/testing/selftests/x86/mov_ss_trap.c
+++ b/tools/testing/selftests/x86/mov_ss_trap.c
@@ -47,7 +47,6 @@
 unsigned short ss;
 extern unsigned char breakpoint_insn[];
 sigjmp_buf jmpbuf;
-static unsigned char altstack_data[SIGSTKSZ];
 
 static void enable_watchpoint(void)
 {
@@ -250,13 +249,14 @@ int main()
 	if (sigsetjmp(jmpbuf, 1) == 0) {
 		printf("[RUN]\tMOV SS; SYSENTER\n");
 		stack_t stack = {
-			.ss_sp = altstack_data,
+			.ss_sp = malloc(sizeof(char) * SIGSTKSZ),
 			.ss_size = SIGSTKSZ,
 		};
 		if (sigaltstack(&stack, NULL) != 0)
 			err(1, "sigaltstack");
 		sethandler(SIGSEGV, handle_and_longjmp, SA_RESETHAND | SA_ONSTACK);
 		nr = SYS_getpid;
+		free(stack.ss_sp);
 		/* Clear EBP first to make sure we segfault cleanly. */
 		asm volatile ("xorl %%ebp, %%ebp; mov %[ss], %%ss; SYSENTER" : "+a" (nr)
 			      : [ss] "m" (ss) : "flags", "rcx"
diff --git a/tools/testing/selftests/x86/sigreturn.c b/tools/testing/selftests/x86/sigreturn.c
index 57c4f67f16ef..5d7961a5f7f6 100644
--- a/tools/testing/selftests/x86/sigreturn.c
+++ b/tools/testing/selftests/x86/sigreturn.c
@@ -138,9 +138,6 @@ static unsigned short LDT3(int idx)
 	return (idx << 3) | 7;
 }
 
-/* Our sigaltstack scratch space. */
-static char altstack_data[SIGSTKSZ];
-
 static void sethandler(int sig, void (*handler)(int, siginfo_t *, void *),
 		       int flags)
 {
@@ -771,7 +768,8 @@ int main()
 	setup_ldt();
 
 	stack_t stack = {
-		.ss_sp = altstack_data,
+		/* Our sigaltstack scratch space. */
+		.ss_sp = malloc(sizeof(char) * SIGSTKSZ),
 		.ss_size = SIGSTKSZ,
 	};
 	if (sigaltstack(&stack, NULL) != 0)
@@ -872,5 +870,6 @@ int main()
 	total_nerrs += test_nonstrict_ss();
 #endif
 
+	free(stack.ss_sp);
 	return total_nerrs ? 1 : 0;
 }
diff --git a/tools/testing/selftests/x86/single_step_syscall.c b/tools/testing/selftests/x86/single_step_syscall.c
index 120ac741fe44..9a30f443e928 100644
--- a/tools/testing/selftests/x86/single_step_syscall.c
+++ b/tools/testing/selftests/x86/single_step_syscall.c
@@ -57,7 +57,6 @@ static void clearhandler(int sig)
 
 static volatile sig_atomic_t sig_traps, sig_eflags;
 sigjmp_buf jmpbuf;
-static unsigned char altstack_data[SIGSTKSZ];
 
 #ifdef __x86_64__
 # define REG_IP REG_RIP
@@ -210,7 +209,7 @@ int main()
 		unsigned long nr = SYS_getpid;
 		printf("[RUN]\tSet TF and check SYSENTER\n");
 		stack_t stack = {
-			.ss_sp = altstack_data,
+			.ss_sp = malloc(sizeof(char) * SIGSTKSZ),
 			.ss_size = SIGSTKSZ,
 		};
 		if (sigaltstack(&stack, NULL) != 0)
@@ -219,6 +218,7 @@ int main()
 			   SA_RESETHAND | SA_ONSTACK);
 		sethandler(SIGILL, print_and_longjmp, SA_RESETHAND);
 		set_eflags(get_eflags() | X86_EFLAGS_TF);
+		free(stack.ss_sp);
 		/* Clear EBP first to make sure we segfault cleanly. */
 		asm volatile ("xorl %%ebp, %%ebp; SYSENTER" : "+a" (nr) :: "flags", "rcx"
 #ifdef __x86_64__
diff --git a/tools/testing/selftests/x86/syscall_arg_fault.c b/tools/testing/selftests/x86/syscall_arg_fault.c
index bff474b5efc6..461fa41a4d02 100644
--- a/tools/testing/selftests/x86/syscall_arg_fault.c
+++ b/tools/testing/selftests/x86/syscall_arg_fault.c
@@ -17,9 +17,6 @@
 
 #include "helpers.h"
 
-/* Our sigaltstack scratch space. */
-static unsigned char altstack_data[SIGSTKSZ];
-
 static void sethandler(int sig, void (*handler)(int, siginfo_t *, void *),
 		       int flags)
 {
@@ -104,7 +101,8 @@ static void sigill(int sig, siginfo_t *info, void *ctx_void)
 int main()
 {
 	stack_t stack = {
-		.ss_sp = altstack_data,
+		/* Our sigaltstack scratch space. */
+		.ss_sp = malloc(sizeof(char) * SIGSTKSZ),
 		.ss_size = SIGSTKSZ,
 	};
 	if (sigaltstack(&stack, NULL) != 0)
@@ -233,5 +231,6 @@ int main()
 	set_eflags(get_eflags() & ~X86_EFLAGS_TF);
 #endif
 
+	free(stack.ss_sp);
 	return 0;
 }
-- 
2.30.2

