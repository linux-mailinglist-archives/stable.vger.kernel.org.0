Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7ADF2ED272
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbhAGOdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:33:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729300AbhAGOdR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D85DA23356;
        Thu,  7 Jan 2021 14:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029956;
        bh=slFdWulS71efhvL7K91nThrWhi3zCjeNbR2K9ZwXocc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=az7gdiHWjtWSOKPaGq5Enza9LgY2KHgVy9h5GwuFJE5H67kM6YywEnQXGZ8E5Ukpq
         8nB9GyVK04sy1gtRl+lgn/bEktagABzPeBNXMfRr23dyd9JUP8ZeBXR9QMpsNPpq3D
         3u4kMlhpRfZ8G0sntNStmbmUFGmM5XN6R9lw+Bdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+db9cdf3dd1f64252c6ef@syzkaller.appspotmail.com,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/13] perf: Break deadlock involving exec_update_mutex
Date:   Thu,  7 Jan 2021 15:33:28 +0100
Message-Id: <20210107143051.199238545@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143049.929352526@linuxfoundation.org>
References: <20210107143049.929352526@linuxfoundation.org>
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
index 9f7c2da992991..18dbdf248ed81 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11001,24 +11001,6 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_task;
 	}
 
-	if (task) {
-		err = mutex_lock_interruptible(&task->signal->exec_update_mutex);
-		if (err)
-			goto err_task;
-
-		/*
-		 * Reuse ptrace permission checks for now.
-		 *
-		 * We must hold exec_update_mutex across this and any potential
-		 * perf_install_in_context() call for this new event to
-		 * serialize against exec() altering our credentials (and the
-		 * perf_event_exit_task() that could imply).
-		 */
-		err = -EACCES;
-		if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS))
-			goto err_cred;
-	}
-
 	if (flags & PERF_FLAG_PID_CGROUP)
 		cgroup_fd = pid;
 
@@ -11026,7 +11008,7 @@ SYSCALL_DEFINE5(perf_event_open,
 				 NULL, NULL, cgroup_fd);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
-		goto err_cred;
+		goto err_task;
 	}
 
 	if (is_sampling_event(event)) {
@@ -11145,6 +11127,24 @@ SYSCALL_DEFINE5(perf_event_open,
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
+		if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS))
+			goto err_cred;
+	}
+
 	if (move_group) {
 		gctx = __perf_event_ctx_lock_double(group_leader, ctx);
 
@@ -11320,7 +11320,10 @@ err_locked:
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
@@ -11332,9 +11335,6 @@ err_alloc:
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



