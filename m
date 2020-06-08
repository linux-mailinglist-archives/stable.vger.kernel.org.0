Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC361F2805
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732177AbgFHXry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731880AbgFHXZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:25:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B4C320760;
        Mon,  8 Jun 2020 23:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658753;
        bh=0NRgQvXnR9iuxBr1avmwsotDDx0U86a0g9lnkU5EczE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=weNMK7bdaCcYzCZFVABh8qPpJ9dN1KYMubBht0sFGYhhkM1uR2ToR2AMTLWJCYOV9
         HOupbZNEtAM1ffcxWsMrWeQavXJcZskY1jr2H1QiEHNeAfVYd3jV5z7f3GP4KNbhWF
         /dXQDKBvKA8gKMRUyANGHF8s54WDOD8q1z+7EDUE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 38/72] exit: Move preemption fixup up, move blocking operations down
Date:   Mon,  8 Jun 2020 19:24:26 -0400
Message-Id: <20200608232500.3369581-38-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232500.3369581-1-sashal@kernel.org>
References: <20200608232500.3369581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

[ Upstream commit 586b58cac8b4683eb58a1446fbc399de18974e40 ]

With CONFIG_DEBUG_ATOMIC_SLEEP=y and CONFIG_CGROUPS=y, kernel oopses in
non-preemptible context look untidy; after the main oops, the kernel prints
a "sleeping function called from invalid context" report because
exit_signals() -> cgroup_threadgroup_change_begin() -> percpu_down_read()
can sleep, and that happens before the preempt_count_set(PREEMPT_ENABLED)
fixup.

It looks like the same thing applies to profile_task_exit() and
kcov_task_exit().

Fix it by moving the preemption fixup up and the calls to
profile_task_exit() and kcov_task_exit() down.

Fixes: 1dc0fffc48af ("sched/core: Robustify preemption leak checks")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200305220657.46800-1-jannh@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/exit.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index d1baf9c96c3e..8458a81a09e3 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -770,8 +770,12 @@ void __noreturn do_exit(long code)
 	struct task_struct *tsk = current;
 	int group_dead;
 
-	profile_task_exit(tsk);
-	kcov_task_exit(tsk);
+	/*
+	 * We can get here from a kernel oops, sometimes with preemption off.
+	 * Start by checking for critical errors.
+	 * Then fix up important state like USER_DS and preemption.
+	 * Then do everything else.
+	 */
 
 	WARN_ON(blk_needs_flush_plug(tsk));
 
@@ -789,6 +793,16 @@ void __noreturn do_exit(long code)
 	 */
 	set_fs(USER_DS);
 
+	if (unlikely(in_atomic())) {
+		pr_info("note: %s[%d] exited with preempt_count %d\n",
+			current->comm, task_pid_nr(current),
+			preempt_count());
+		preempt_count_set(PREEMPT_ENABLED);
+	}
+
+	profile_task_exit(tsk);
+	kcov_task_exit(tsk);
+
 	ptrace_event(PTRACE_EVENT_EXIT, code);
 
 	validate_creds_for_do_exit(tsk);
@@ -806,13 +820,6 @@ void __noreturn do_exit(long code)
 
 	exit_signals(tsk);  /* sets PF_EXITING */
 
-	if (unlikely(in_atomic())) {
-		pr_info("note: %s[%d] exited with preempt_count %d\n",
-			current->comm, task_pid_nr(current),
-			preempt_count());
-		preempt_count_set(PREEMPT_ENABLED);
-	}
-
 	/* sync mm's RSS info before statistics gathering */
 	if (tsk->mm)
 		sync_mm_rss(tsk->mm);
-- 
2.25.1

