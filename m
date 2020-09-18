Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF12F26F408
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgIRDLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbgIRCCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11F8921734;
        Fri, 18 Sep 2020 02:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394549;
        bh=aBFx1KcBL6iJWVBlTWXIiK8c5LFnK4N15P9qCKDqaGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjgOpr9cs9iGXrLnfqr5TjNZQcIXQr1+qHLrd5Hc4enl8KKpeUh4N3yj0pESMVwM4
         zEx1kRzaois6XnlaLu34M7sgZGNHzX6Fy8n8yQaD+qL0pztbbF0SQmfW5AfwNFL6J7
         bqUNozc3+jmV5i0LG1BRbuGWJcQHeh3yHmSt9e8E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>, Sasha Levin <sashal@kernel.org>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 5.4 066/330] xtensa: fix system_call interaction with ptrace
Date:   Thu, 17 Sep 2020 21:56:46 -0400
Message-Id: <20200918020110.2063155-66-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

[ Upstream commit 02ce94c229251555ac726ecfebe3458ef5905fa9 ]

Don't overwrite return value if system call was cancelled at entry by
ptrace. Return status code from do_syscall_trace_enter so that
pt_regs::syscall doesn't need to be changed to skip syscall.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/kernel/entry.S  |  4 ++--
 arch/xtensa/kernel/ptrace.c | 18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/xtensa/kernel/entry.S b/arch/xtensa/kernel/entry.S
index 59671603c9c62..1f07876ea2ed7 100644
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -1897,6 +1897,7 @@ ENTRY(system_call)
 
 	mov	a6, a2
 	call4	do_syscall_trace_enter
+	beqz	a6, .Lsyscall_exit
 	l32i	a7, a2, PT_SYSCALL
 
 1:
@@ -1911,8 +1912,6 @@ ENTRY(system_call)
 
 	addx4	a4, a7, a4
 	l32i	a4, a4, 0
-	movi	a5, sys_ni_syscall;
-	beq	a4, a5, 1f
 
 	/* Load args: arg0 - arg5 are passed via regs. */
 
@@ -1932,6 +1931,7 @@ ENTRY(system_call)
 
 	s32i	a6, a2, PT_AREG2
 	bnez	a3, 1f
+.Lsyscall_exit:
 	abi_ret(4)
 
 1:
diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
index b964f0b2d8864..145742d70a9f2 100644
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -542,14 +542,28 @@ long arch_ptrace(struct task_struct *child, long request,
 	return ret;
 }
 
-void do_syscall_trace_enter(struct pt_regs *regs)
+void do_syscall_trace_leave(struct pt_regs *regs);
+int do_syscall_trace_enter(struct pt_regs *regs)
 {
+	if (regs->syscall == NO_SYSCALL)
+		regs->areg[2] = -ENOSYS;
+
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
-	    tracehook_report_syscall_entry(regs))
+	    tracehook_report_syscall_entry(regs)) {
+		regs->areg[2] = -ENOSYS;
 		regs->syscall = NO_SYSCALL;
+		return 0;
+	}
+
+	if (regs->syscall == NO_SYSCALL) {
+		do_syscall_trace_leave(regs);
+		return 0;
+	}
 
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
 		trace_sys_enter(regs, syscall_get_nr(current, regs));
+
+	return 1;
 }
 
 void do_syscall_trace_leave(struct pt_regs *regs)
-- 
2.25.1

