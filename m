Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3D40101466
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfKSFd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:33:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729534AbfKSFd1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:33:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4715C21783;
        Tue, 19 Nov 2019 05:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141606;
        bh=0vx65RjpRJZQ4ULHxxgE65D1vts6kuf75w99/xFy9+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L96mwMtaV1I6C3NBuvCXBKL4U/cGoUHAS4HhSk2Q3KpU5MYuo5LL3Ibx4eC+Hr8W7
         R6AMzoiIt0odpLMveqFyefj9dIbkEXH339Z4IvWTz9DdAkgroadYhOUH042TbG0jm5
         +JZnVamXB2MWij951hK9l56HxnQ8g2FfIAIU6PGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Sherry Yang <sherryy@android.com>,
        Martijn Coenen <maco@android.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 217/422] android: binder: no outgoing transaction when thread todo has transaction
Date:   Tue, 19 Nov 2019 06:16:54 +0100
Message-Id: <20191119051412.676992843@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sherry Yang <sherryy@android.com>

[ Upstream commit 44b73962cb25f1c8170ea695c4564b05a75e1fd4 ]

When a process dies, failed reply is sent to the sender of any transaction
queued on a dead thread's todo list. The sender asserts that the
received failed reply corresponds to the head of the transaction stack.
This assert can fail if the dead thread is allowed to send outgoing
transactions when there is already a transaction on its todo list,
because this new transaction can end up on the transaction stack of the
original sender. The following steps illustrate how this assertion can
fail.

1. Thread1 sends txn19 to Thread2
   (T1->transaction_stack=txn19, T2->todo+=txn19)
2. Without processing todo list, Thread2 sends txn20 to Thread1
   (T1->todo+=txn20, T2->transaction_stack=txn20)
3. T1 processes txn20 on its todo list
   (T1->transaction_stack=txn20->txn19, T1->todo=<empty>)
4. T2 dies, T2->todo cleanup attempts to send failed reply for txn19, but
   T1->transaction_stack points to txn20 -- assertion failes

Step 2. is the incorrect behavior. When there is a transaction on a
thread's todo list, this thread should not be able to send any outgoing
synchronous transactions. Only the head of the todo list needs to be
checked because only threads that are waiting for proc work can directly
receive work from another thread, and no work is allowed to be queued
on such a thread without waking up the thread. This patch also enforces
that a thread is not waiting for proc work when a work is directly
enqueued to its todo list.

Acked-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Sherry Yang <sherryy@android.com>
Reviewed-by: Martijn Coenen <maco@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/android/binder.c | 44 +++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 6e04e7a707a12..cf4367135a00b 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -822,6 +822,7 @@ static void
 binder_enqueue_deferred_thread_work_ilocked(struct binder_thread *thread,
 					    struct binder_work *work)
 {
+	WARN_ON(!list_empty(&thread->waiting_thread_node));
 	binder_enqueue_work_ilocked(work, &thread->todo);
 }
 
@@ -839,6 +840,7 @@ static void
 binder_enqueue_thread_work_ilocked(struct binder_thread *thread,
 				   struct binder_work *work)
 {
+	WARN_ON(!list_empty(&thread->waiting_thread_node));
 	binder_enqueue_work_ilocked(work, &thread->todo);
 	thread->process_todo = true;
 }
@@ -1270,19 +1272,12 @@ static int binder_inc_node_nilocked(struct binder_node *node, int strong,
 		} else
 			node->local_strong_refs++;
 		if (!node->has_strong_ref && target_list) {
+			struct binder_thread *thread = container_of(target_list,
+						    struct binder_thread, todo);
 			binder_dequeue_work_ilocked(&node->work);
-			/*
-			 * Note: this function is the only place where we queue
-			 * directly to a thread->todo without using the
-			 * corresponding binder_enqueue_thread_work() helper
-			 * functions; in this case it's ok to not set the
-			 * process_todo flag, since we know this node work will
-			 * always be followed by other work that starts queue
-			 * processing: in case of synchronous transactions, a
-			 * BR_REPLY or BR_ERROR; in case of oneway
-			 * transactions, a BR_TRANSACTION_COMPLETE.
-			 */
-			binder_enqueue_work_ilocked(&node->work, target_list);
+			BUG_ON(&thread->todo != target_list);
+			binder_enqueue_deferred_thread_work_ilocked(thread,
+								   &node->work);
 		}
 	} else {
 		if (!internal)
@@ -2733,6 +2728,7 @@ static void binder_transaction(struct binder_proc *proc,
 {
 	int ret;
 	struct binder_transaction *t;
+	struct binder_work *w;
 	struct binder_work *tcomplete;
 	binder_size_t *offp, *off_end, *off_start;
 	binder_size_t off_min;
@@ -2874,6 +2870,29 @@ static void binder_transaction(struct binder_proc *proc,
 			goto err_invalid_target_handle;
 		}
 		binder_inner_proc_lock(proc);
+
+		w = list_first_entry_or_null(&thread->todo,
+					     struct binder_work, entry);
+		if (!(tr->flags & TF_ONE_WAY) && w &&
+		    w->type == BINDER_WORK_TRANSACTION) {
+			/*
+			 * Do not allow new outgoing transaction from a
+			 * thread that has a transaction at the head of
+			 * its todo list. Only need to check the head
+			 * because binder_select_thread_ilocked picks a
+			 * thread from proc->waiting_threads to enqueue
+			 * the transaction, and nothing is queued to the
+			 * todo list while the thread is on waiting_threads.
+			 */
+			binder_user_error("%d:%d new transaction not allowed when there is a transaction on thread todo\n",
+					  proc->pid, thread->pid);
+			binder_inner_proc_unlock(proc);
+			return_error = BR_FAILED_REPLY;
+			return_error_param = -EPROTO;
+			return_error_line = __LINE__;
+			goto err_bad_todo_list;
+		}
+
 		if (!(tr->flags & TF_ONE_WAY) && thread->transaction_stack) {
 			struct binder_transaction *tmp;
 
@@ -3256,6 +3275,7 @@ err_alloc_tcomplete_failed:
 	kfree(t);
 	binder_stats_deleted(BINDER_STAT_TRANSACTION);
 err_alloc_t_failed:
+err_bad_todo_list:
 err_bad_call_stack:
 err_empty_call_stack:
 err_dead_binder:
-- 
2.20.1



