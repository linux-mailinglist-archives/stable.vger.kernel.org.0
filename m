Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9FC2E4137
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439411AbgL1PDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:03:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439849AbgL1OMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36ED02063A;
        Mon, 28 Dec 2020 14:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164699;
        bh=14uTw111GyeL+dWcdEzV0CgjyY0Czhgw3ueJofuF2NA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KhAAIc9Es94xslov9u4n/t5zx6pG7hfpjADXtDPehlxPkrqSdEvCKMh1KeflKB3IR
         mJzmSd52VSSO2V0IETAfTXRctYK3XjfiFhxz8IWwFsSs0+RVIDj4Lvu09Peu4AJIWb
         Za/TJeNIybFBiaTSMCvM2rjXoM4XT5d1A2Dn5BGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 266/717] SUNRPC: rpc_wake_up() should wake up tasks in the correct order
Date:   Mon, 28 Dec 2020 13:44:24 +0100
Message-Id: <20201228125033.755429585@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index f06d7c315017c..cf702a5f7fe5d 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -675,6 +675,23 @@ struct rpc_task *rpc_wake_up_next(struct rpc_wait_queue *queue)
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
@@ -683,25 +700,28 @@ EXPORT_SYMBOL_GPL(rpc_wake_up_next);
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
@@ -712,23 +732,8 @@ EXPORT_SYMBOL_GPL(rpc_wake_up);
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



