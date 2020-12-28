Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E825B2E63A5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405542AbgL1NrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:47:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405353AbgL1NrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:47:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57D912072C;
        Mon, 28 Dec 2020 13:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163187;
        bh=hKcySnxvhB2SuNJhJeHTyiw12Nq9oNGnByAaxfZnXlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tp/Xf/n/8T2dhhT3zzr+27DKekWcGoZf1K+rWUG06hRys6hFkH3lfm76buxdYn7L2
         oj8V5zlsLxUKH0IZf1KckZ2RQ1/6qzeEn2QQ+b6xyTxXj5KEZpFpLC1wiBa2GOz0tt
         xdWIC6e0vxT9Thhe7Fh4tjTBo29g+YbcXuQrZzno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 199/453] SUNRPC: rpc_wake_up() should wake up tasks in the correct order
Date:   Mon, 28 Dec 2020 13:47:15 +0100
Message-Id: <20201228124946.787925110@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e4c72201b6ec3173dfe13fa2e2335a3ad78d4921 ]

Currently, we wake up the tasks by priority queue ordering, which means
that we ignore the batching that is supposed to help with QoS issues.

Fixes: c049f8ea9a0d ("SUNRPC: Remove the bh-safe lock requirement on the rpc_wait_queue->lock")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/sched.c | 65 +++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 53d8b82eda006..7afbf15bcbd9a 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -699,6 +699,23 @@ struct rpc_task *rpc_wake_up_next(struct rpc_wait_queue *queue)
 }
 EXPORT_SYMBOL_GPL(rpc_wake_up_next);
 
+/**
+ * rpc_wake_up_locked - wake up all rpc_tasks
+ * @queue: rpc_wait_queue on which the tasks are sleeping
+ *
+ */
+static void rpc_wake_up_locked(struct rpc_wait_queue *queue)
+{
+	struct rpc_task *task;
+
+	for (;;) {
+		task = __rpc_find_next_queued(queue);
+		if (task == NULL)
+			break;
+		rpc_wake_up_task_queue_locked(queue, task);
+	}
+}
+
 /**
  * rpc_wake_up - wake up all rpc_tasks
  * @queue: rpc_wait_queue on which the tasks are sleeping
@@ -707,25 +724,28 @@ EXPORT_SYMBOL_GPL(rpc_wake_up_next);
  */
 void rpc_wake_up(struct rpc_wait_queue *queue)
 {
-	struct list_head *head;
-
 	spin_lock(&queue->lock);
-	head = &queue->tasks[queue->maxpriority];
+	rpc_wake_up_locked(queue);
+	spin_unlock(&queue->lock);
+}
+EXPORT_SYMBOL_GPL(rpc_wake_up);
+
+/**
+ * rpc_wake_up_status_locked - wake up all rpc_tasks and set their status value.
+ * @queue: rpc_wait_queue on which the tasks are sleeping
+ * @status: status value to set
+ */
+static void rpc_wake_up_status_locked(struct rpc_wait_queue *queue, int status)
+{
+	struct rpc_task *task;
+
 	for (;;) {
-		while (!list_empty(head)) {
-			struct rpc_task *task;
-			task = list_first_entry(head,
-					struct rpc_task,
-					u.tk_wait.list);
-			rpc_wake_up_task_queue_locked(queue, task);
-		}
-		if (head == &queue->tasks[0])
+		task = __rpc_find_next_queued(queue);
+		if (task == NULL)
 			break;
-		head--;
+		rpc_wake_up_task_queue_set_status_locked(queue, task, status);
 	}
-	spin_unlock(&queue->lock);
 }
-EXPORT_SYMBOL_GPL(rpc_wake_up);
 
 /**
  * rpc_wake_up_status - wake up all rpc_tasks and set their status value.
@@ -736,23 +756,8 @@ EXPORT_SYMBOL_GPL(rpc_wake_up);
  */
 void rpc_wake_up_status(struct rpc_wait_queue *queue, int status)
 {
-	struct list_head *head;
-
 	spin_lock(&queue->lock);
-	head = &queue->tasks[queue->maxpriority];
-	for (;;) {
-		while (!list_empty(head)) {
-			struct rpc_task *task;
-			task = list_first_entry(head,
-					struct rpc_task,
-					u.tk_wait.list);
-			task->tk_status = status;
-			rpc_wake_up_task_queue_locked(queue, task);
-		}
-		if (head == &queue->tasks[0])
-			break;
-		head--;
-	}
+	rpc_wake_up_status_locked(queue, status);
 	spin_unlock(&queue->lock);
 }
 EXPORT_SYMBOL_GPL(rpc_wake_up_status);
-- 
2.27.0



