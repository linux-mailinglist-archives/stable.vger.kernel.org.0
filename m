Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D5C304AA0
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbhAZFBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:01:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:37502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731158AbhAYSvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DF552083E;
        Mon, 25 Jan 2021 18:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600675;
        bh=4xlM1I/vK0Zb5Neahpka7frgpb4IyD1ETQ1CY5n6wIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLTMsNw/VvlnFb37JjiGsRdGrSKcZsoNnHq4T6TF1nDYAYzXnyLVjopKCnlrczdrs
         ow5stpSs/1ieuYZf3ace1U10eNTUeEEI7d6ScklWrTZOCIGl4BkeiRSFEe/57t30zR
         Uq1k2YSfj84vXLI132fDzGSiC9YVzn7/XkSdGZ6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/199] arm64: entry: remove redundant IRQ flag tracing
Date:   Mon, 25 Jan 2021 19:38:32 +0100
Message-Id: <20210125183220.070116605@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit df06824767cc9a32fbdb0e3d3b7e169292a5b5fe ]

All EL0 returns go via ret_to_user(), which masks IRQs and notifies
lockdep and tracing before calling into do_notify_resume(). Therefore,
there's no need for do_notify_resume() to call trace_hardirqs_off(), and
the comment is stale. The call is simply redundant.

In ret_to_user() we call exit_to_user_mode(), which notifies lockdep and
tracing the IRQs will be enabled in userspace, so there's no need for
el0_svc_common() to call trace_hardirqs_on() before returning. Further,
at the start of ret_to_user() we call trace_hardirqs_off(), so not only
is this redundant, but it is immediately undone.

In addition to being redundant, the trace_hardirqs_on() in
el0_svc_common() leaves lockdep inconsistent with the hardware state,
and is liable to cause issues for any C code or instrumentation
between this and the call to trace_hardirqs_off() which undoes it in
ret_to_user().

This patch removes the redundant tracing calls and associated stale
comments.

Fixes: 23529049c684 ("arm64: entry: fix non-NMI user<->kernel transitions")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20210107145310.44616-1-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/signal.c  | 7 -------
 arch/arm64/kernel/syscall.c | 9 +--------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index a8184cad88907..50852992752b0 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -914,13 +914,6 @@ static void do_signal(struct pt_regs *regs)
 asmlinkage void do_notify_resume(struct pt_regs *regs,
 				 unsigned long thread_flags)
 {
-	/*
-	 * The assembly code enters us with IRQs off, but it hasn't
-	 * informed the tracing code of that for efficiency reasons.
-	 * Update the trace code with the current status.
-	 */
-	trace_hardirqs_off();
-
 	do {
 		/* Check valid user FS if needed */
 		addr_limit_user_check();
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index f8f758e4a3064..6fa8cfb8232aa 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -165,15 +165,8 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	if (!has_syscall_work(flags) && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
 		local_daif_mask();
 		flags = current_thread_info()->flags;
-		if (!has_syscall_work(flags) && !(flags & _TIF_SINGLESTEP)) {
-			/*
-			 * We're off to userspace, where interrupts are
-			 * always enabled after we restore the flags from
-			 * the SPSR.
-			 */
-			trace_hardirqs_on();
+		if (!has_syscall_work(flags) && !(flags & _TIF_SINGLESTEP))
 			return;
-		}
 		local_daif_restore(DAIF_PROCCTX);
 	}
 
-- 
2.27.0



