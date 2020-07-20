Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502F422682B
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387721AbgGTQRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388353AbgGTQPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:15:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0F0320684;
        Mon, 20 Jul 2020 16:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261716;
        bh=lfLJuhKtX5oMhl9AFdM4aB72T2TyHglnow2I71FfRj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ps0lP6qx1I6dJr+duF4KW3hOwDe/rAP9CBaxKcvFSn6umfZbaDmNadK5tXHfy/6gv
         rYFDODX6lt+Gb4pLdbPUeik2GS3xlzNB/gZcC9mCtYC3ZCdT3UAiskZur2Dx8FAQ7E
         LTKoQPDBXgj2Ndw0FmN418rfUfC/utJVA5OiTud4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Luis Machado <luis.machado@linaro.org>,
        Keno Fischer <keno@juliacomputing.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.7 217/244] arm64: ptrace: Consistently use pseudo-singlestep exceptions
Date:   Mon, 20 Jul 2020 17:38:08 +0200
Message-Id: <20200720152836.166900890@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit ac2081cdc4d99c57f219c1a6171526e0fa0a6fff upstream.

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
Tested-by: Luis Machado <luis.machado@linaro.org>
Reported-by: Keno Fischer <keno@juliacomputing.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/thread_info.h |    1 +
 arch/arm64/kernel/ptrace.c           |   27 ++++++++++++++++++++-------
 arch/arm64/kernel/signal.c           |   11 ++---------
 arch/arm64/kernel/syscall.c          |    2 +-
 4 files changed, 24 insertions(+), 17 deletions(-)

--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -89,6 +89,7 @@ void arch_release_task_struct(struct tas
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_FSCHECK		(1 << TIF_FSCHECK)
+#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_32BIT		(1 << TIF_32BIT)
 #define _TIF_SVE		(1 << TIF_SVE)
 
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1819,12 +1819,23 @@ static void tracehook_report_syscall(str
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
-
-	regs->regs[regno] = saved_reg;
+		regs->regs[regno] = saved_reg;
+	} else {
+		regs->regs[regno] = saved_reg;
+
+		/*
+		 * Signal a pseudo-step exception since we are stepping but
+		 * tracer modifications to the registers may have rewound the
+		 * state machine.
+		 */
+		tracehook_report_syscall_exit(regs, 1);
+	}
 }
 
 int syscall_trace_enter(struct pt_regs *regs)
@@ -1852,12 +1863,14 @@ int syscall_trace_enter(struct pt_regs *
 
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
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -784,7 +784,6 @@ static void setup_restart_syscall(struct
  */
 static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
-	struct task_struct *tsk = current;
 	sigset_t *oldset = sigmask_to_save();
 	int usig = ksig->sig;
 	int ret;
@@ -808,14 +807,8 @@ static void handle_signal(struct ksignal
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
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -121,7 +121,7 @@ static void el0_svc_common(struct pt_reg
 	if (!has_syscall_work(flags) && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
 		local_daif_mask();
 		flags = current_thread_info()->flags;
-		if (!has_syscall_work(flags)) {
+		if (!has_syscall_work(flags) && !(flags & _TIF_SINGLESTEP)) {
 			/*
 			 * We're off to userspace, where interrupts are
 			 * always enabled after we restore the flags from


