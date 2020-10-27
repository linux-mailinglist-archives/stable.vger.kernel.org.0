Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0686529B6C0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797621AbgJ0PYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797615AbgJ0PYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:24:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F0082064B;
        Tue, 27 Oct 2020 15:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812277;
        bh=g/0VCHNjrw7aowlzmfftEZwmcK77V5J8l6kr8r6zoYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVdovynu0PsmD8TIdfyHMjjf/qy/6gL5HUmTsOTqeLy2cJz9e3rE5Ikm76XhzEXZx
         AaW5RFmNSe7aliwlpOZf9GWnN5b1Xbfry9CfhUSdMPMBWWPry99CtWqVdRrf0l+hP3
         7X2m/Ds4bDqwtDeVnNixAml4RHF5jvRKpEeSZx/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 153/757] selftests/seccomp: Refactor arch register macros to avoid xtensa special case
Date:   Tue, 27 Oct 2020 14:46:43 +0100
Message-Id: <20201027135457.780967650@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit a6a4d78419a04095221ec2b518edefb080218d55 ]

To avoid an xtensa special-case, refactor all arch register macros to
take the register variable instead of depending on the macro expanding
as a struct member name.

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/lkml/20200912110820.597135-2-keescook@chromium.org
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 97 +++++++++----------
 1 file changed, 47 insertions(+), 50 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 9dc13be8fe5f5..e2f38507a0621 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -1667,64 +1667,64 @@ TEST_F(TRACE_poke, getpid_runs_normally)
 }
 
 #if defined(__x86_64__)
-# define ARCH_REGS	struct user_regs_struct
-# define SYSCALL_NUM	orig_rax
-# define SYSCALL_RET	rax
+# define ARCH_REGS		struct user_regs_struct
+# define SYSCALL_NUM(_regs)	(_regs).orig_rax
+# define SYSCALL_RET(_regs)	(_regs).rax
 #elif defined(__i386__)
-# define ARCH_REGS	struct user_regs_struct
-# define SYSCALL_NUM	orig_eax
-# define SYSCALL_RET	eax
+# define ARCH_REGS		struct user_regs_struct
+# define SYSCALL_NUM(_regs)	(_regs).orig_eax
+# define SYSCALL_RET(_regs)	(_regs).eax
 #elif defined(__arm__)
-# define ARCH_REGS	struct pt_regs
-# define SYSCALL_NUM	ARM_r7
-# define SYSCALL_RET	ARM_r0
+# define ARCH_REGS		struct pt_regs
+# define SYSCALL_NUM(_regs)	(_regs).ARM_r7
+# define SYSCALL_RET(_regs)	(_regs).ARM_r0
 #elif defined(__aarch64__)
-# define ARCH_REGS	struct user_pt_regs
-# define SYSCALL_NUM	regs[8]
-# define SYSCALL_RET	regs[0]
+# define ARCH_REGS		struct user_pt_regs
+# define SYSCALL_NUM(_regs)	(_regs).regs[8]
+# define SYSCALL_RET(_regs)	(_regs).regs[0]
 #elif defined(__riscv) && __riscv_xlen == 64
-# define ARCH_REGS	struct user_regs_struct
-# define SYSCALL_NUM	a7
-# define SYSCALL_RET	a0
+# define ARCH_REGS		struct user_regs_struct
+# define SYSCALL_NUM(_regs)	(_regs).a7
+# define SYSCALL_RET(_regs)	(_regs).a0
 #elif defined(__csky__)
-# define ARCH_REGS	struct pt_regs
-#if defined(__CSKYABIV2__)
-# define SYSCALL_NUM	regs[3]
-#else
-# define SYSCALL_NUM	regs[9]
-#endif
-# define SYSCALL_RET	a0
+# define ARCH_REGS		struct pt_regs
+#  if defined(__CSKYABIV2__)
+#   define SYSCALL_NUM(_regs)	(_regs).regs[3]
+#  else
+#   define SYSCALL_NUM(_regs)	(_regs).regs[9]
+#  endif
+# define SYSCALL_RET(_regs)	(_regs).a0
 #elif defined(__hppa__)
-# define ARCH_REGS	struct user_regs_struct
-# define SYSCALL_NUM	gr[20]
-# define SYSCALL_RET	gr[28]
+# define ARCH_REGS		struct user_regs_struct
+# define SYSCALL_NUM(_regs)	(_regs).gr[20]
+# define SYSCALL_RET(_regs)	(_regs).gr[28]
 #elif defined(__powerpc__)
-# define ARCH_REGS	struct pt_regs
-# define SYSCALL_NUM	gpr[0]
-# define SYSCALL_RET	gpr[3]
+# define ARCH_REGS		struct pt_regs
+# define SYSCALL_NUM(_regs)	(_regs).gpr[0]
+# define SYSCALL_RET(_regs)	(_regs).gpr[3]
 #elif defined(__s390__)
-# define ARCH_REGS     s390_regs
-# define SYSCALL_NUM   gprs[2]
-# define SYSCALL_RET   gprs[2]
+# define ARCH_REGS		s390_regs
+# define SYSCALL_NUM(_regs)	(_regs).gprs[2]
+# define SYSCALL_RET(_regs)	(_regs).gprs[2]
 # define SYSCALL_NUM_RET_SHARE_REG
 #elif defined(__mips__)
-# define ARCH_REGS	struct pt_regs
-# define SYSCALL_NUM	regs[2]
-# define SYSCALL_SYSCALL_NUM regs[4]
-# define SYSCALL_RET	regs[2]
+# define ARCH_REGS		struct pt_regs
+# define SYSCALL_NUM(_regs)	(_regs).regs[2]
+# define SYSCALL_SYSCALL_NUM	regs[4]
+# define SYSCALL_RET(_regs)	(_regs).regs[2]
 # define SYSCALL_NUM_RET_SHARE_REG
 #elif defined(__xtensa__)
-# define ARCH_REGS	struct user_pt_regs
-# define SYSCALL_NUM	syscall
+# define ARCH_REGS		struct user_pt_regs
+# define SYSCALL_NUM(_regs)	(_regs).syscall
 /*
  * On xtensa syscall return value is in the register
  * a2 of the current window which is not fixed.
  */
-#define SYSCALL_RET(reg) a[(reg).windowbase * 4 + 2]
+#define SYSCALL_RET(_regs)	(_regs).a[(_regs).windowbase * 4 + 2]
 #elif defined(__sh__)
-# define ARCH_REGS	struct pt_regs
-# define SYSCALL_NUM	gpr[3]
-# define SYSCALL_RET	gpr[0]
+# define ARCH_REGS		struct pt_regs
+# define SYSCALL_NUM(_regs)	(_regs).gpr[3]
+# define SYSCALL_RET(_regs)	(_regs).gpr[0]
 #else
 # error "Do not know how to find your architecture's registers and syscalls"
 #endif
@@ -1773,10 +1773,10 @@ int get_syscall(struct __test_metadata *_metadata, pid_t tracee)
 #endif
 
 #if defined(__mips__)
-	if (regs.SYSCALL_NUM == __NR_O32_Linux)
+	if (SYSCALL_NUM(regs) == __NR_O32_Linux)
 		return regs.SYSCALL_SYSCALL_NUM;
 #endif
-	return regs.SYSCALL_NUM;
+	return SYSCALL_NUM(regs);
 }
 
 /* Architecture-specific syscall changing routine. */
@@ -1799,14 +1799,14 @@ void change_syscall(struct __test_metadata *_metadata,
 	defined(__s390__) || defined(__hppa__) || defined(__riscv) || \
 	defined(__xtensa__) || defined(__csky__) || defined(__sh__)
 	{
-		regs.SYSCALL_NUM = syscall;
+		SYSCALL_NUM(regs) = syscall;
 	}
 #elif defined(__mips__)
 	{
-		if (regs.SYSCALL_NUM == __NR_O32_Linux)
+		if (SYSCALL_NUM(regs) == __NR_O32_Linux)
 			regs.SYSCALL_SYSCALL_NUM = syscall;
 		else
-			regs.SYSCALL_NUM = syscall;
+			SYSCALL_NUM(regs) = syscall;
 	}
 
 #elif defined(__arm__)
@@ -1840,11 +1840,8 @@ void change_syscall(struct __test_metadata *_metadata,
 	if (syscall == -1)
 #ifdef SYSCALL_NUM_RET_SHARE_REG
 		TH_LOG("Can't modify syscall return on this architecture");
-
-#elif defined(__xtensa__)
-		regs.SYSCALL_RET(regs) = result;
 #else
-		regs.SYSCALL_RET = result;
+		SYSCALL_RET(regs) = result;
 #endif
 
 #ifdef HAVE_GETREGS
-- 
2.25.1



