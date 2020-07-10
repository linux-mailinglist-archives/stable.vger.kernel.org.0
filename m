Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279E621B5D6
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 15:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgGJNHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 09:07:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgGJNHL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 09:07:11 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 253282077D;
        Fri, 10 Jul 2020 13:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594386430;
        bh=6hqWKhwopvNh8McOXsr4biewZT1rCi9y+XBPrJC/RVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=utftJ7LBbRM6i4bOL8lFYOnzN0w572EEhYAtbuLr2k7Gt+r50nMhQcZ/uSBd4dCqs
         GrSPi80xcIyQyN0GfPzV7SZFo0Y3RH1uhl40B+9V22ELqbyQXyHPLo+cE586eYPo0H
         LjyzcsUDVPYf7M2cnU0mDO/att/YVndrmCMfVxF8=
From:   Will Deacon <will@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     catalin.marinas@arm.com, Will Deacon <will@kernel.org>,
        kernel-team@android.com, Mark Rutland <mark.rutland@arm.com>,
        Luis Machado <luis.machado@linaro.org>,
        Keno Fischer <keno@juliacomputing.com>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v3 1/7] arm64: ptrace: Consistently use pseudo-singlestep exceptions
Date:   Fri, 10 Jul 2020 14:06:56 +0100
Message-Id: <20200710130702.30658-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200710130702.30658-1-will@kernel.org>
References: <20200710130702.30658-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Although the arm64 single-step state machine can be fast-forwarded in
cases where we wish to generate a SIGTRAP without actually executing an
instruction, this has two major limitations outside of simply skipping
an instruction due to emulation.

1. Stepping out of a ptrace signal stop into a signal handler where
   SIGTRAP is blocked. Fast-forwarding the stepping state machine in
   this case will result in a forced SIGTRAP, with the handler reset to
   SIG_DFL.

2. The hardware implicitly fast-forwards the state machine when executing
   an SVC instruction for issuing a system call. This can interact badly
   with subsequent ptrace stops signalled during the execution of the
   system call (e.g. SYSCALL_EXIT or seccomp traps), as they may corrupt
   the stepping state by updating the PSTATE for the tracee.

Resolve both of these issues by injecting a pseudo-singlestep exception
on entry to a signal handler and also on return to userspace following a
system call.

Cc: <stable@vger.kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Luis Machado <luis.machado@linaro.org>
Reported-by: Keno Fischer <keno@juliacomputing.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/thread_info.h |  1 +
 arch/arm64/kernel/ptrace.c           | 25 +++++++++++++++++++------
 arch/arm64/kernel/signal.c           | 11 ++---------
 arch/arm64/kernel/syscall.c          |  2 +-
 4 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 6ea8b6a26ae9..5e784e16ee89 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -93,6 +93,7 @@ void arch_release_task_struct(struct task_struct *tsk);
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_FSCHECK		(1 << TIF_FSCHECK)
+#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_32BIT		(1 << TIF_32BIT)
 #define _TIF_SVE		(1 << TIF_SVE)
 
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 68b7f34a08f5..057d4aa1af4d 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1818,12 +1818,23 @@ static void tracehook_report_syscall(struct pt_regs *regs,
 	saved_reg = regs->regs[regno];
 	regs->regs[regno] = dir;
 
-	if (dir == PTRACE_SYSCALL_EXIT)
+	if (dir == PTRACE_SYSCALL_ENTER) {
+		if (tracehook_report_syscall_entry(regs))
+			forget_syscall(regs);
+		regs->regs[regno] = saved_reg;
+	} else if (!test_thread_flag(TIF_SINGLESTEP)) {
 		tracehook_report_syscall_exit(regs, 0);
-	else if (tracehook_report_syscall_entry(regs))
-		forget_syscall(regs);
+		regs->regs[regno] = saved_reg;
+	} else {
+		regs->regs[regno] = saved_reg;
 
-	regs->regs[regno] = saved_reg;
+		/*
+		 * Signal a pseudo-step exception since we are stepping but
+		 * tracer modifications to the registers may have rewound the
+		 * state machine.
+		 */
+		tracehook_report_syscall_exit(regs, 1);
+	}
 }
 
 int syscall_trace_enter(struct pt_regs *regs)
@@ -1851,12 +1862,14 @@ int syscall_trace_enter(struct pt_regs *regs)
 
 void syscall_trace_exit(struct pt_regs *regs)
 {
+	unsigned long flags = READ_ONCE(current_thread_info()->flags);
+
 	audit_syscall_exit(regs);
 
-	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
+	if (flags & _TIF_SYSCALL_TRACEPOINT)
 		trace_sys_exit(regs, regs_return_value(regs));
 
-	if (test_thread_flag(TIF_SYSCALL_TRACE))
+	if (flags & (_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP))
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_EXIT);
 
 	rseq_syscall(regs);
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 801d56cdf701..3b4f31f35e45 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -800,7 +800,6 @@ static void setup_restart_syscall(struct pt_regs *regs)
  */
 static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
-	struct task_struct *tsk = current;
 	sigset_t *oldset = sigmask_to_save();
 	int usig = ksig->sig;
 	int ret;
@@ -824,14 +823,8 @@ static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 	 */
 	ret |= !valid_user_regs(&regs->user_regs, current);
 
-	/*
-	 * Fast forward the stepping logic so we step into the signal
-	 * handler.
-	 */
-	if (!ret)
-		user_fastforward_single_step(tsk);
-
-	signal_setup_done(ret, ksig, 0);
+	/* Step into the signal handler if we are stepping */
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
 
 /*
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 5f5b868292f5..7c14466a12af 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -139,7 +139,7 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	if (!has_syscall_work(flags) && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
 		local_daif_mask();
 		flags = current_thread_info()->flags;
-		if (!has_syscall_work(flags)) {
+		if (!has_syscall_work(flags) && !(flags & _TIF_SINGLESTEP)) {
 			/*
 			 * We're off to userspace, where interrupts are
 			 * always enabled after we restore the flags from
-- 
2.27.0.383.g050319c2ae-goog

