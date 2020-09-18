Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491B726F2E1
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbgIRDCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727517AbgIRCFV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:05:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C762E23770;
        Fri, 18 Sep 2020 02:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394720;
        bh=LIWOTdfHIdT6uVuD6J6B7XN5ftruP8Of0smGsGAHIvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXqNIsqOsCooXzT6ohJ9cEJned5WaLe8xhBISR/AshEpS0U1JeFxGGogLPTGreoMf
         uv21H82pQjGKTJA0SZ3mFO4AkEsmq2znvpFItWvCKOcJ38HSEuik+ZVKDJphQ4vtsn
         SxfzIDBV6W37JtWTaFjcGj/88SZR6EQFmUEFpO8k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 204/330] perf: Use new infrastructure to fix deadlocks in execve
Date:   Thu, 17 Sep 2020 21:59:04 -0400
Message-Id: <20200918020110.2063155-204-sashal@kernel.org>
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

From: Bernd Edlinger <bernd.edlinger@hotmail.de>

[ Upstream commit 6914303824bb572278568330d72fc1f8f9814e67 ]

This changes perf_event_set_clock to use the new exec_update_mutex
instead of cred_guard_mutex.

This should be safe, as the credentials are only used for reading.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index db1f5aa755f22..47646050efa0c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1253,7 +1253,7 @@ static void put_ctx(struct perf_event_context *ctx)
  * function.
  *
  * Lock order:
- *    cred_guard_mutex
+ *    exec_update_mutex
  *	task_struct::perf_event_mutex
  *	  perf_event_context::mutex
  *	    perf_event::child_mutex;
@@ -11002,14 +11002,14 @@ SYSCALL_DEFINE5(perf_event_open,
 	}
 
 	if (task) {
-		err = mutex_lock_interruptible(&task->signal->cred_guard_mutex);
+		err = mutex_lock_interruptible(&task->signal->exec_update_mutex);
 		if (err)
 			goto err_task;
 
 		/*
 		 * Reuse ptrace permission checks for now.
 		 *
-		 * We must hold cred_guard_mutex across this and any potential
+		 * We must hold exec_update_mutex across this and any potential
 		 * perf_install_in_context() call for this new event to
 		 * serialize against exec() altering our credentials (and the
 		 * perf_event_exit_task() that could imply).
@@ -11298,7 +11298,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	mutex_unlock(&ctx->mutex);
 
 	if (task) {
-		mutex_unlock(&task->signal->cred_guard_mutex);
+		mutex_unlock(&task->signal->exec_update_mutex);
 		put_task_struct(task);
 	}
 
@@ -11334,7 +11334,7 @@ err_alloc:
 		free_event(event);
 err_cred:
 	if (task)
-		mutex_unlock(&task->signal->cred_guard_mutex);
+		mutex_unlock(&task->signal->exec_update_mutex);
 err_task:
 	if (task)
 		put_task_struct(task);
@@ -11639,7 +11639,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 /*
  * When a child task exits, feed back event values to parent events.
  *
- * Can be called with cred_guard_mutex held when called from
+ * Can be called with exec_update_mutex held when called from
  * install_exec_creds().
  */
 void perf_event_exit_task(struct task_struct *child)
-- 
2.25.1

