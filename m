Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9CD27C9B4
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730960AbgI2MMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730133AbgI2Lha (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C508A23B97;
        Tue, 29 Sep 2020 11:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379280;
        bh=aBFx1KcBL6iJWVBlTWXIiK8c5LFnK4N15P9qCKDqaGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tIea4/qjei1J7REHcep/eb1Cn7AxK2F4jJz6ghu/c10IaVrMU119LOVkDphQJn78K
         yxCIPve8EgGBf/0Ub9/klXmnIH9jpa1MsR0oQBSwm70nzdWJ692OoRsPbSmyhjFqXw
         1Lv70wncucvLPQbjJYBdNWukfA+zzendpGFCZL8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/388] xtensa: fix system_call interaction with ptrace
Date:   Tue, 29 Sep 2020 12:56:34 +0200
Message-Id: <20200929110013.548033987@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



