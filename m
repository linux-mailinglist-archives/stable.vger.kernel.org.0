Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1918106CFB
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbfKVK4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:56:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728201AbfKVK4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:56:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 561EF20706;
        Fri, 22 Nov 2019 10:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420197;
        bh=PHp0p/TS5kS23Aiz6xzSGVKi2LLkz2X5Kf+nG5lJukM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N5RrOpKgAtU2mcSJ+w2hAk0zYql367ImnF2BRzgFmfRSSO7onEY+EjFgd8Mr96eW2
         vFwFog7qHnCokovbotFW2ab3nWpoe+yEgTzUiAZABJHXvtJn9/NCfOkScq/K1MkhP9
         m6rCfVY1Itl7+nECvVLVX8677eizTn2U5XQqDolY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 025/220] SUNRPC: Fix priority queue fairness
Date:   Fri, 22 Nov 2019 11:26:30 +0100
Message-Id: <20191122100914.283665562@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit f42f7c283078ce3c1e8368b140e270755b1ae313 ]

Fix up the priority queue to not batch by owner, but by queue, so that
we allow '1 << priority' elements to be dequeued before switching to
the next priority queue.
The owner field is still used to wake up requests in round robin order
by owner to avoid single processes hogging the RPC layer by loading the
queues.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/sched.h |   2 -
 net/sunrpc/sched.c           | 109 +++++++++++++++++------------------
 2 files changed, 54 insertions(+), 57 deletions(-)

diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index 592653becd914..ad2e243f3f032 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -188,7 +188,6 @@ struct rpc_timer {
 struct rpc_wait_queue {
 	spinlock_t		lock;
 	struct list_head	tasks[RPC_NR_PRIORITY];	/* task queue for each priority level */
-	pid_t			owner;			/* process id of last task serviced */
 	unsigned char		maxpriority;		/* maximum priority (0 if queue is not a priority queue) */
 	unsigned char		priority;		/* current priority */
 	unsigned char		nr;			/* # tasks remaining for cookie */
@@ -204,7 +203,6 @@ struct rpc_wait_queue {
  * from a single cookie.  The aim is to improve
  * performance of NFS operations such as read/write.
  */
-#define RPC_BATCH_COUNT			16
 #define RPC_IS_PRIORITY(q)		((q)->maxpriority > 0)
 
 /*
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 3fe5d60ab0e2c..e2808586c9e61 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -99,64 +99,78 @@ __rpc_add_timer(struct rpc_wait_queue *queue, struct rpc_task *task)
 	list_add(&task->u.tk_wait.timer_list, &queue->timer_list.list);
 }
 
-static void rpc_rotate_queue_owner(struct rpc_wait_queue *queue)
-{
-	struct list_head *q = &queue->tasks[queue->priority];
-	struct rpc_task *task;
-
-	if (!list_empty(q)) {
-		task = list_first_entry(q, struct rpc_task, u.tk_wait.list);
-		if (task->tk_owner == queue->owner)
-			list_move_tail(&task->u.tk_wait.list, q);
-	}
-}
-
 static void rpc_set_waitqueue_priority(struct rpc_wait_queue *queue, int priority)
 {
 	if (queue->priority != priority) {
-		/* Fairness: rotate the list when changing priority */
-		rpc_rotate_queue_owner(queue);
 		queue->priority = priority;
+		queue->nr = 1U << priority;
 	}
 }
 
-static void rpc_set_waitqueue_owner(struct rpc_wait_queue *queue, pid_t pid)
-{
-	queue->owner = pid;
-	queue->nr = RPC_BATCH_COUNT;
-}
-
 static void rpc_reset_waitqueue_priority(struct rpc_wait_queue *queue)
 {
 	rpc_set_waitqueue_priority(queue, queue->maxpriority);
-	rpc_set_waitqueue_owner(queue, 0);
 }
 
 /*
- * Add new request to a priority queue.
+ * Add a request to a queue list
  */
-static void __rpc_add_wait_queue_priority(struct rpc_wait_queue *queue,
-		struct rpc_task *task,
-		unsigned char queue_priority)
+static void
+__rpc_list_enqueue_task(struct list_head *q, struct rpc_task *task)
 {
-	struct list_head *q;
 	struct rpc_task *t;
 
-	INIT_LIST_HEAD(&task->u.tk_wait.links);
-	if (unlikely(queue_priority > queue->maxpriority))
-		queue_priority = queue->maxpriority;
-	if (queue_priority > queue->priority)
-		rpc_set_waitqueue_priority(queue, queue_priority);
-	q = &queue->tasks[queue_priority];
 	list_for_each_entry(t, q, u.tk_wait.list) {
 		if (t->tk_owner == task->tk_owner) {
-			list_add_tail(&task->u.tk_wait.list, &t->u.tk_wait.links);
+			list_add_tail(&task->u.tk_wait.links,
+					&t->u.tk_wait.links);
+			/* Cache the queue head in task->u.tk_wait.list */
+			task->u.tk_wait.list.next = q;
+			task->u.tk_wait.list.prev = NULL;
 			return;
 		}
 	}
+	INIT_LIST_HEAD(&task->u.tk_wait.links);
 	list_add_tail(&task->u.tk_wait.list, q);
 }
 
+/*
+ * Remove request from a queue list
+ */
+static void
+__rpc_list_dequeue_task(struct rpc_task *task)
+{
+	struct list_head *q;
+	struct rpc_task *t;
+
+	if (task->u.tk_wait.list.prev == NULL) {
+		list_del(&task->u.tk_wait.links);
+		return;
+	}
+	if (!list_empty(&task->u.tk_wait.links)) {
+		t = list_first_entry(&task->u.tk_wait.links,
+				struct rpc_task,
+				u.tk_wait.links);
+		/* Assume __rpc_list_enqueue_task() cached the queue head */
+		q = t->u.tk_wait.list.next;
+		list_add_tail(&t->u.tk_wait.list, q);
+		list_del(&task->u.tk_wait.links);
+	}
+	list_del(&task->u.tk_wait.list);
+}
+
+/*
+ * Add new request to a priority queue.
+ */
+static void __rpc_add_wait_queue_priority(struct rpc_wait_queue *queue,
+		struct rpc_task *task,
+		unsigned char queue_priority)
+{
+	if (unlikely(queue_priority > queue->maxpriority))
+		queue_priority = queue->maxpriority;
+	__rpc_list_enqueue_task(&queue->tasks[queue_priority], task);
+}
+
 /*
  * Add new request to wait queue.
  *
@@ -194,13 +208,7 @@ static void __rpc_add_wait_queue(struct rpc_wait_queue *queue,
  */
 static void __rpc_remove_wait_queue_priority(struct rpc_task *task)
 {
-	struct rpc_task *t;
-
-	if (!list_empty(&task->u.tk_wait.links)) {
-		t = list_entry(task->u.tk_wait.links.next, struct rpc_task, u.tk_wait.list);
-		list_move(&t->u.tk_wait.list, &task->u.tk_wait.list);
-		list_splice_init(&task->u.tk_wait.links, &t->u.tk_wait.links);
-	}
+	__rpc_list_dequeue_task(task);
 }
 
 /*
@@ -212,7 +220,8 @@ static void __rpc_remove_wait_queue(struct rpc_wait_queue *queue, struct rpc_tas
 	__rpc_disable_timer(queue, task);
 	if (RPC_IS_PRIORITY(queue))
 		__rpc_remove_wait_queue_priority(task);
-	list_del(&task->u.tk_wait.list);
+	else
+		list_del(&task->u.tk_wait.list);
 	queue->qlen--;
 	dprintk("RPC: %5u removed from queue %p \"%s\"\n",
 			task->tk_pid, queue, rpc_qname(queue));
@@ -493,17 +502,9 @@ static struct rpc_task *__rpc_find_next_queued_priority(struct rpc_wait_queue *q
 	 * Service a batch of tasks from a single owner.
 	 */
 	q = &queue->tasks[queue->priority];
-	if (!list_empty(q)) {
-		task = list_entry(q->next, struct rpc_task, u.tk_wait.list);
-		if (queue->owner == task->tk_owner) {
-			if (--queue->nr)
-				goto out;
-			list_move_tail(&task->u.tk_wait.list, q);
-		}
-		/*
-		 * Check if we need to switch queues.
-		 */
-		goto new_owner;
+	if (!list_empty(q) && --queue->nr) {
+		task = list_first_entry(q, struct rpc_task, u.tk_wait.list);
+		goto out;
 	}
 
 	/*
@@ -515,7 +516,7 @@ static struct rpc_task *__rpc_find_next_queued_priority(struct rpc_wait_queue *q
 		else
 			q = q - 1;
 		if (!list_empty(q)) {
-			task = list_entry(q->next, struct rpc_task, u.tk_wait.list);
+			task = list_first_entry(q, struct rpc_task, u.tk_wait.list);
 			goto new_queue;
 		}
 	} while (q != &queue->tasks[queue->priority]);
@@ -525,8 +526,6 @@ static struct rpc_task *__rpc_find_next_queued_priority(struct rpc_wait_queue *q
 
 new_queue:
 	rpc_set_waitqueue_priority(queue, (unsigned int)(q - &queue->tasks[0]));
-new_owner:
-	rpc_set_waitqueue_owner(queue, task->tk_owner);
 out:
 	return task;
 }
-- 
2.20.1



