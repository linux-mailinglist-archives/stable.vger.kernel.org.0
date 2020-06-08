Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E6D1F2F5D
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgFHXKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728720AbgFHXKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:10:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDC03208C7;
        Mon,  8 Jun 2020 23:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657837;
        bh=wksmgPnNwuVecvuMyghSK6yEBXhOXlfzIvgZODHm3XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UP7+48USk+3ZAr9hoY8SNoj1Brnu0oT1t81qkeHtSR5E4uzuieCveiJC7HAPQHXtY
         wq8XKuuUVHkGKhDxtCAuScictlAUV8XLm4ETJA84QVCc7jz9b2kxOvzINkhypDGD14
         6HXBXail0oLj8hZBtnrX+SVi1cC96kYe7/E4ik18=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 206/274] io_uring: allow POLL_ADD with double poll_wait() users
Date:   Mon,  8 Jun 2020 19:04:59 -0400
Message-Id: <20200608230607.3361041-206-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 18bceab101adde8f38de76016bc77f3f25cf22f4 ]

Some file descriptors use separate waitqueues for their f_ops->poll()
handler, most commonly one for read and one for write. The io_uring
poll implementation doesn't work with that, as the 2nd poll_wait()
call will cause the io_uring poll request to -EINVAL.

This affects (at least) tty devices and /dev/random as well. This is a
big problem for event loops where some file descriptors work, and others
don't.

With this fix, io_uring handles multiple waitqueues.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 218 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 146 insertions(+), 72 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 03147b6694fd..dd90c3fcd4f5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4096,27 +4096,6 @@ struct io_poll_table {
 	int error;
 };
 
-static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
-			    struct wait_queue_head *head)
-{
-	if (unlikely(poll->head)) {
-		pt->error = -EINVAL;
-		return;
-	}
-
-	pt->error = 0;
-	poll->head = head;
-	add_wait_queue(head, &poll->wait);
-}
-
-static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
-			       struct poll_table_struct *p)
-{
-	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
-
-	__io_queue_proc(&pt->req->apoll->poll, pt, head);
-}
-
 static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 			   __poll_t mask, task_work_func_t func)
 {
@@ -4170,6 +4149,144 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 	return false;
 }
 
+static void io_poll_remove_double(struct io_kiocb *req)
+{
+	struct io_poll_iocb *poll = (struct io_poll_iocb *) req->io;
+
+	lockdep_assert_held(&req->ctx->completion_lock);
+
+	if (poll && poll->head) {
+		struct wait_queue_head *head = poll->head;
+
+		spin_lock(&head->lock);
+		list_del_init(&poll->wait.entry);
+		if (poll->wait.private)
+			refcount_dec(&req->refs);
+		poll->head = NULL;
+		spin_unlock(&head->lock);
+	}
+}
+
+static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_poll_remove_double(req);
+	req->poll.done = true;
+	io_cqring_fill_event(req, error ? error : mangle_poll(mask));
+	io_commit_cqring(ctx);
+}
+
+static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (io_poll_rewait(req, &req->poll)) {
+		spin_unlock_irq(&ctx->completion_lock);
+		return;
+	}
+
+	hash_del(&req->hash_node);
+	io_poll_complete(req, req->result, 0);
+	req->flags |= REQ_F_COMP_LOCKED;
+	io_put_req_find_next(req, nxt);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	io_cqring_ev_posted(ctx);
+}
+
+static void io_poll_task_func(struct callback_head *cb)
+{
+	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct io_kiocb *nxt = NULL;
+
+	io_poll_task_handler(req, &nxt);
+	if (nxt) {
+		struct io_ring_ctx *ctx = nxt->ctx;
+
+		mutex_lock(&ctx->uring_lock);
+		__io_queue_sqe(nxt, NULL);
+		mutex_unlock(&ctx->uring_lock);
+	}
+}
+
+static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
+			       int sync, void *key)
+{
+	struct io_kiocb *req = wait->private;
+	struct io_poll_iocb *poll = (struct io_poll_iocb *) req->io;
+	__poll_t mask = key_to_poll(key);
+
+	/* for instances that support it check for an event match first: */
+	if (mask && !(mask & poll->events))
+		return 0;
+
+	if (req->poll.head) {
+		bool done;
+
+		spin_lock(&req->poll.head->lock);
+		done = list_empty(&req->poll.wait.entry);
+		if (!done)
+			list_del_init(&req->poll.wait.entry);
+		spin_unlock(&req->poll.head->lock);
+		if (!done)
+			__io_async_wake(req, poll, mask, io_poll_task_func);
+	}
+	refcount_dec(&req->refs);
+	return 1;
+}
+
+static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
+			      wait_queue_func_t wake_func)
+{
+	poll->head = NULL;
+	poll->done = false;
+	poll->canceled = false;
+	poll->events = events;
+	INIT_LIST_HEAD(&poll->wait.entry);
+	init_waitqueue_func_entry(&poll->wait, wake_func);
+}
+
+static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
+			    struct wait_queue_head *head)
+{
+	struct io_kiocb *req = pt->req;
+
+	/*
+	 * If poll->head is already set, it's because the file being polled
+	 * uses multiple waitqueues for poll handling (eg one for read, one
+	 * for write). Setup a separate io_poll_iocb if this happens.
+	 */
+	if (unlikely(poll->head)) {
+		/* already have a 2nd entry, fail a third attempt */
+		if (req->io) {
+			pt->error = -EINVAL;
+			return;
+		}
+		poll = kmalloc(sizeof(*poll), GFP_ATOMIC);
+		if (!poll) {
+			pt->error = -ENOMEM;
+			return;
+		}
+		io_init_poll_iocb(poll, req->poll.events, io_poll_double_wake);
+		refcount_inc(&req->refs);
+		poll->wait.private = req;
+		req->io = (void *) poll;
+	}
+
+	pt->error = 0;
+	poll->head = head;
+	add_wait_queue(head, &poll->wait);
+}
+
+static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
+			       struct poll_table_struct *p)
+{
+	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
+
+	__io_queue_proc(&pt->req->apoll->poll, pt, head);
+}
+
 static void io_async_task_func(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
@@ -4245,18 +4362,13 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 	bool cancel = false;
 
 	poll->file = req->file;
-	poll->head = NULL;
-	poll->done = poll->canceled = false;
-	poll->events = mask;
+	io_init_poll_iocb(poll, mask, wake_func);
+	poll->wait.private = req;
 
 	ipt->pt._key = mask;
 	ipt->req = req;
 	ipt->error = -EINVAL;
 
-	INIT_LIST_HEAD(&poll->wait.entry);
-	init_waitqueue_func_entry(&poll->wait, wake_func);
-	poll->wait.private = req;
-
 	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
 
 	spin_lock_irq(&ctx->completion_lock);
@@ -4287,6 +4399,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
 	__poll_t mask, ret;
+	bool had_io;
 
 	if (!req->file || !file_can_poll(req->file))
 		return false;
@@ -4301,6 +4414,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 
 	req->flags |= REQ_F_POLLED;
 	memcpy(&apoll->work, &req->work, sizeof(req->work));
+	had_io = req->io != NULL;
 
 	get_task_struct(current);
 	req->task = current;
@@ -4320,7 +4434,9 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 					io_async_wake);
 	if (ret) {
 		ipt.error = 0;
-		apoll->poll.done = true;
+		/* only remove double add if we did it here */
+		if (!had_io)
+			io_poll_remove_double(req);
 		spin_unlock_irq(&ctx->completion_lock);
 		memcpy(&req->work, &apoll->work, sizeof(req->work));
 		kfree(apoll);
@@ -4353,6 +4469,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 	bool do_complete;
 
 	if (req->opcode == IORING_OP_POLL_ADD) {
+		io_poll_remove_double(req);
 		do_complete = __io_poll_remove_one(req, &req->poll);
 	} else {
 		struct async_poll *apoll = req->apoll;
@@ -4453,49 +4570,6 @@ static int io_poll_remove(struct io_kiocb *req)
 	return 0;
 }
 
-static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	req->poll.done = true;
-	io_cqring_fill_event(req, error ? error : mangle_poll(mask));
-	io_commit_cqring(ctx);
-}
-
-static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_poll_iocb *poll = &req->poll;
-
-	if (io_poll_rewait(req, poll)) {
-		spin_unlock_irq(&ctx->completion_lock);
-		return;
-	}
-
-	hash_del(&req->hash_node);
-	io_poll_complete(req, req->result, 0);
-	req->flags |= REQ_F_COMP_LOCKED;
-	io_put_req_find_next(req, nxt);
-	spin_unlock_irq(&ctx->completion_lock);
-
-	io_cqring_ev_posted(ctx);
-}
-
-static void io_poll_task_func(struct callback_head *cb)
-{
-	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
-	struct io_kiocb *nxt = NULL;
-
-	io_poll_task_handler(req, &nxt);
-	if (nxt) {
-		struct io_ring_ctx *ctx = nxt->ctx;
-
-		mutex_lock(&ctx->uring_lock);
-		__io_queue_sqe(nxt, NULL);
-		mutex_unlock(&ctx->uring_lock);
-	}
-}
-
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			void *key)
 {
-- 
2.25.1

