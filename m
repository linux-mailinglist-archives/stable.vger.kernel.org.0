Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9910F3E5E44
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241519AbhHJOqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:46:24 -0400
Received: from foss.arm.com ([217.140.110.172]:57154 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241713AbhHJOqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:46:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1290E1FB;
        Tue, 10 Aug 2021 07:46:02 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7CA4C3F70D;
        Tue, 10 Aug 2021 07:46:01 -0700 (PDT)
From:   Mark Rutland <mark.rutland@arm.com>
To:     stable@vger.kernel.org
Cc:     will@kernel.org
Subject: [PATCH 5.4.y] arm64: fix compat syscall return truncation
Date:   Tue, 10 Aug 2021 15:45:53 +0100
Message-Id: <20210810144553.33310-1-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[Mark: trivial conflict resolution for v5.4.y]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/include/asm/ptrace.h  | 12 +++++++++++-
 arch/arm64/include/asm/syscall.h | 19 ++++++++++---------
 arch/arm64/kernel/ptrace.c       |  2 +-
 arch/arm64/kernel/signal.c       |  3 ++-
 arch/arm64/kernel/syscall.c      |  7 ++-----
 5 files changed, 26 insertions(+), 17 deletions(-)

This is a trivial backport, as the original didn't apply cleanly per:

https://lore.kernel.org/r/1628505759100128@kroah.com

Mark.

diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index bf57308fcd63..92b2575b0191 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -299,7 +299,17 @@ static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
 
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
diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
index cfc0672013f6..03e20895453a 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -29,22 +29,23 @@ static inline void syscall_rollback(struct task_struct *task,
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
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 0cfd68577489..8a95a013dfd3 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1868,7 +1868,7 @@ void syscall_trace_exit(struct pt_regs *regs)
 	audit_syscall_exit(regs);
 
 	if (flags & _TIF_SYSCALL_TRACEPOINT)
-		trace_sys_exit(regs, regs_return_value(regs));
+		trace_sys_exit(regs, syscall_get_return_value(current, regs));
 
 	if (flags & (_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP))
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_EXIT);
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index ddb757b2c3e5..f6d3278c1a4e 100644
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
@@ -868,7 +869,7 @@ static void do_signal(struct pt_regs *regs)
 		     retval == -ERESTART_RESTARTBLOCK ||
 		     (retval == -ERESTARTSYS &&
 		      !(ksig.ka.sa.sa_flags & SA_RESTART)))) {
-			regs->regs[0] = -EINTR;
+			syscall_set_return_value(current, regs, -EINTR, 0);
 			regs->pc = continue_addr;
 		}
 
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index f2d2dbbbfca2..091c11521108 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -50,10 +50,7 @@ static void invoke_syscall(struct pt_regs *regs, unsigned int scno,
 		ret = do_ni_syscall(regs, scno);
 	}
 
-	if (is_compat_task())
-		ret = lower_32_bits(ret);
-
-	regs->regs[0] = ret;
+	syscall_set_return_value(current, regs, 0, ret);
 }
 
 static inline bool has_syscall_work(unsigned long flags)
@@ -108,7 +105,7 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	if (has_syscall_work(flags)) {
 		/* set default errno for user-issued syscall(-1) */
 		if (scno == NO_SYSCALL)
-			regs->regs[0] = -ENOSYS;
+			syscall_set_return_value(current, regs, -ENOSYS, 0);
 		scno = syscall_trace_enter(regs);
 		if (scno == NO_SYSCALL)
 			goto trace_exit;
-- 
2.11.0

