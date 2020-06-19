Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5691520129B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404153AbgFSPxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:53:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392544AbgFSPWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:22:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EBD221548;
        Fri, 19 Jun 2020 15:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580135;
        bh=DqbIC+qFwTwJvEUr9A+FWIEILOijxXRKAeWP716pKv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ix0ZVMlcZbILK9unuNf+Gk69olYkxYfcP1ox7EEYgr2PvWSurhZwPV3i3p/iOV3Qa
         VCJxQYHSQ7+c/Bd7G0W0IXpXItAmbjxvQkSZkHbhlHxsmlDZy171QV1WvuClNtBjY/
         kmIIhS0+HbIYk6j96y3KI+RMwGjpUvqLSeTRg094=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 135/376] exit: Move preemption fixup up, move blocking operations down
Date:   Fri, 19 Jun 2020 16:30:53 +0200
Message-Id: <20200619141716.727303755@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ce2a75bc0ade..d56fe51bdf07 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -708,8 +708,12 @@ void __noreturn do_exit(long code)
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
 
@@ -727,6 +731,16 @@ void __noreturn do_exit(long code)
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
@@ -744,13 +758,6 @@ void __noreturn do_exit(long code)
 
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



