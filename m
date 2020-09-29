Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB67627C89B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbgI2MDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:03:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729123AbgI2Lif (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:38:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A95A2083B;
        Tue, 29 Sep 2020 11:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379514;
        bh=LIWOTdfHIdT6uVuD6J6B7XN5ftruP8Of0smGsGAHIvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I3VfvTyGbNAXs+ll3I8rn+C4to7n6nu7ek1Ry0zzPUMyJHQfQc3+1mVbCRZEieDDV
         0z9iuunqHMUg/qtU16PpM8PQqSz72Idt8RU3kbsLoU+R0paWYCjQ6RKkSW38J7yhbO
         LGtMq0jJ5gBHqtRsyq8P7tpZ2jsT/OjllYlVP2Kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernd Edlinger <bernd.edlinger@hotmail.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 198/388] perf: Use new infrastructure to fix deadlocks in execve
Date:   Tue, 29 Sep 2020 12:58:49 +0200
Message-Id: <20200929110020.065159423@linuxfoundation.org>
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



