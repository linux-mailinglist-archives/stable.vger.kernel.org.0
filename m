Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8789C2ED289
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbhAGOeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:34:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729694AbhAGOd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 881762054F;
        Thu,  7 Jan 2021 14:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029995;
        bh=VdFGYdGHXccxjEfKMloHEAKw+mi60xUy/1XNS57HknM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYvBMBA1nr0wkV2k1/5s/+46k5yYQv723Mb4B9vWOmdRGJ5GaOMYZSowoPi5b/Wup
         MW+BUrKykYgDT3qRTsoOCXk+eQTdIbu68nVwWKf0H30af6s2RubuppMwYC9lyxN0Ny
         NemBYsenvPrB80FsWCMZXxos/sUPgHJzTWuMALIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+db9cdf3dd1f64252c6ef@syzkaller.appspotmail.com,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/20] perf: Break deadlock involving exec_update_mutex
Date:   Thu,  7 Jan 2021 15:34:11 +0100
Message-Id: <20210107143054.675898906@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
References: <20210107143052.392839477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: peterz@infradead.org <peterz@infradead.org>

[ Upstream commit 78af4dc949daaa37b3fcd5f348f373085b4e858f ]

Syzbot reported a lock inversion involving perf. The sore point being
perf holding exec_update_mutex() for a very long time, specifically
across a whole bunch of filesystem ops in pmu::event_init() (uprobes)
and anon_inode_getfile().

This then inverts against procfs code trying to take
exec_update_mutex.

Move the permission checks later, such that we need to hold the mutex
over less code.

Reported-by: syzbot+db9cdf3dd1f64252c6ef@syzkaller.appspotmail.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 46 ++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index dc568ca295bdc..7e9a398fc3cb0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11720,24 +11720,6 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_task;
 	}
 
-	if (task) {
-		err = mutex_lock_interruptible(&task->signal->exec_update_mutex);
-		if (err)
-			goto err_task;
-
-		/*
-		 * Preserve ptrace permission check for backwards compatibility.
-		 *
-		 * We must hold exec_update_mutex across this and any potential
-		 * perf_install_in_context() call for this new event to
-		 * serialize against exec() altering our credentials (and the
-		 * perf_event_exit_task() that could imply).
-		 */
-		err = -EACCES;
-		if (!perfmon_capable() && !ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS))
-			goto err_cred;
-	}
-
 	if (flags & PERF_FLAG_PID_CGROUP)
 		cgroup_fd = pid;
 
@@ -11745,7 +11727,7 @@ SYSCALL_DEFINE5(perf_event_open,
 				 NULL, NULL, cgroup_fd);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
-		goto err_cred;
+		goto err_task;
 	}
 
 	if (is_sampling_event(event)) {
@@ -11864,6 +11846,24 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_context;
 	}
 
+	if (task) {
+		err = mutex_lock_interruptible(&task->signal->exec_update_mutex);
+		if (err)
+			goto err_file;
+
+		/*
+		 * Preserve ptrace permission check for backwards compatibility.
+		 *
+		 * We must hold exec_update_mutex across this and any potential
+		 * perf_install_in_context() call for this new event to
+		 * serialize against exec() altering our credentials (and the
+		 * perf_event_exit_task() that could imply).
+		 */
+		err = -EACCES;
+		if (!perfmon_capable() && !ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS))
+			goto err_cred;
+	}
+
 	if (move_group) {
 		gctx = __perf_event_ctx_lock_double(group_leader, ctx);
 
@@ -12039,7 +12039,10 @@ err_locked:
 	if (move_group)
 		perf_event_ctx_unlock(group_leader, gctx);
 	mutex_unlock(&ctx->mutex);
-/* err_file: */
+err_cred:
+	if (task)
+		mutex_unlock(&task->signal->exec_update_mutex);
+err_file:
 	fput(event_file);
 err_context:
 	perf_unpin_context(ctx);
@@ -12051,9 +12054,6 @@ err_alloc:
 	 */
 	if (!event_file)
 		free_event(event);
-err_cred:
-	if (task)
-		mutex_unlock(&task->signal->exec_update_mutex);
 err_task:
 	if (task)
 		put_task_struct(task);
-- 
2.27.0



