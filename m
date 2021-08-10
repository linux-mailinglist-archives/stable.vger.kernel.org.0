Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0483E809C
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbhHJRvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236528AbhHJRt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:49:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D83B611C6;
        Tue, 10 Aug 2021 17:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617303;
        bh=39IUHEWndYNT5AxJNyem4W9Ti1yoxGFQQqNsZK7wuy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TKVcw6d1Zl9+wRI4z/W1d37XoLaMknCFCUSf4hg9l3gTVzc0fSTfXUJw54yFfgw1+
         brIfLtxegn4UUvzQadv0Zj3e/VJZWrOA75yC7WjZSZ5IRa8XA/lJeam53QF0F1+F+E
         eudypf8ODCF4uaQn0ZPW+Wt8N2aRIwDl/LKt03l4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, He Zhe <zhe.he@windriver.com>,
        weiyuchen <weiyuchen3@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 5.10 135/135] arm64: fix compat syscall return truncation
Date:   Tue, 10 Aug 2021 19:31:09 +0200
Message-Id: <20210810173000.392301176@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit e30e8d46cf605d216a799a28c77b8a41c328613a upstream.

Due to inconsistencies in the way we manipulate compat GPRs, we have a
few issues today:

* For audit and tracing, where error codes are handled as a (native)
  long, negative error codes are expected to be sign-extended to the
  native 64-bits, or they may fail to be matched correctly. Thus a
  syscall which fails with an error may erroneously be identified as
  failing.

* For ptrace, *all* compat return values should be sign-extended for
  consistency with 32-bit arm, but we currently only do this for
  negative return codes.

* As we may transiently set the upper 32 bits of some compat GPRs while
  in the kernel, these can be sampled by perf, which is somewhat
  confusing. This means that where a syscall returns a pointer above 2G,
  this will be sign-extended, but will not be mistaken for an error as
  error codes are constrained to the inclusive range [-4096, -1] where
  no user pointer can exist.

To fix all of these, we must consistently use helpers to get/set the
compat GPRs, ensuring that we never write the upper 32 bits of the
return code, and always sign-extend when reading the return code.  This
patch does so, with the following changes:

* We re-organise syscall_get_return_value() to always sign-extend for
  compat tasks, and reimplement syscall_get_error() atop. We update
  syscall_trace_exit() to use syscall_get_return_value().

* We consistently use syscall_set_return_value() to set the return
  value, ensureing the upper 32 bits are never set unexpectedly.

* As the core audit code currently uses regs_return_value() rather than
  syscall_get_return_value(), we special-case this for
  compat_user_mode(regs) such that this will do the right thing. Going
  forward, we should try to move the core audit code over to
  syscall_get_return_value().

Cc: <stable@vger.kernel.org>
Reported-by: He Zhe <zhe.he@windriver.com>
Reported-by: weiyuchen <weiyuchen3@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20210802104200.21390-1-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
[Mark: trivial conflict resolution for v5.10.y]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/ptrace.h  |   12 +++++++++++-
 arch/arm64/include/asm/syscall.h |   19 ++++++++++---------
 arch/arm64/kernel/ptrace.c       |    2 +-
 arch/arm64/kernel/signal.c       |    3 ++-
 arch/arm64/kernel/syscall.c      |    9 +++------
 5 files changed, 27 insertions(+), 18 deletions(-)

--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -316,7 +316,17 @@ static inline unsigned long kernel_stack
 
 static inline unsigned long regs_return_value(struct pt_regs *regs)
 {
-	return regs->regs[0];
+	unsigned long val = regs->regs[0];
+
+	/*
+	 * Audit currently uses regs_return_value() instead of
+	 * syscall_get_return_value(). Apply the same sign-extension here until
+	 * audit is updated to use syscall_get_return_value().
+	 */
+	if (compat_user_mode(regs))
+		val = sign_extend64(val, 31);
+
+	return val;
 }
 
 static inline void regs_set_return_value(struct pt_regs *regs, unsigned long rc)
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -29,22 +29,23 @@ static inline void syscall_rollback(stru
 	regs->regs[0] = regs->orig_x0;
 }
 
-
-static inline long syscall_get_error(struct task_struct *task,
-				     struct pt_regs *regs)
+static inline long syscall_get_return_value(struct task_struct *task,
+					    struct pt_regs *regs)
 {
-	unsigned long error = regs->regs[0];
+	unsigned long val = regs->regs[0];
 
 	if (is_compat_thread(task_thread_info(task)))
-		error = sign_extend64(error, 31);
+		val = sign_extend64(val, 31);
 
-	return IS_ERR_VALUE(error) ? error : 0;
+	return val;
 }
 
-static inline long syscall_get_return_value(struct task_struct *task,
-					    struct pt_regs *regs)
+static inline long syscall_get_error(struct task_struct *task,
+				     struct pt_regs *regs)
 {
-	return regs->regs[0];
+	unsigned long error = syscall_get_return_value(task, regs);
+
+	return IS_ERR_VALUE(error) ? error : 0;
 }
 
 static inline void syscall_set_return_value(struct task_struct *task,
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1823,7 +1823,7 @@ void syscall_trace_exit(struct pt_regs *
 	audit_syscall_exit(regs);
 
 	if (flags & _TIF_SYSCALL_TRACEPOINT)
-		trace_sys_exit(regs, regs_return_value(regs));
+		trace_sys_exit(regs, syscall_get_return_value(current, regs));
 
 	if (flags & (_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP))
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_EXIT);
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -29,6 +29,7 @@
 #include <asm/unistd.h>
 #include <asm/fpsimd.h>
 #include <asm/ptrace.h>
+#include <asm/syscall.h>
 #include <asm/signal32.h>
 #include <asm/traps.h>
 #include <asm/vdso.h>
@@ -890,7 +891,7 @@ static void do_signal(struct pt_regs *re
 		     retval == -ERESTART_RESTARTBLOCK ||
 		     (retval == -ERESTARTSYS &&
 		      !(ksig.ka.sa.sa_flags & SA_RESTART)))) {
-			regs->regs[0] = -EINTR;
+			syscall_set_return_value(current, regs, -EINTR, 0);
 			regs->pc = continue_addr;
 		}
 
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -50,10 +50,7 @@ static void invoke_syscall(struct pt_reg
 		ret = do_ni_syscall(regs, scno);
 	}
 
-	if (is_compat_task())
-		ret = lower_32_bits(ret);
-
-	regs->regs[0] = ret;
+	syscall_set_return_value(current, regs, 0, ret);
 }
 
 static inline bool has_syscall_work(unsigned long flags)
@@ -128,7 +125,7 @@ static void el0_svc_common(struct pt_reg
 		 * syscall. do_notify_resume() will send a signal to userspace
 		 * before the syscall is restarted.
 		 */
-		regs->regs[0] = -ERESTARTNOINTR;
+		syscall_set_return_value(current, regs, -ERESTARTNOINTR, 0);
 		return;
 	}
 
@@ -149,7 +146,7 @@ static void el0_svc_common(struct pt_reg
 		 * anyway.
 		 */
 		if (scno == NO_SYSCALL)
-			regs->regs[0] = -ENOSYS;
+			syscall_set_return_value(current, regs, -ENOSYS, 0);
 		scno = syscall_trace_enter(regs);
 		if (scno == NO_SYSCALL)
 			goto trace_exit;


