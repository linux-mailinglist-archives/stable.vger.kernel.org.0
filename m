Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D701B201239
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392144AbgFSPuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393310AbgFSPYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:24:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA55721582;
        Fri, 19 Jun 2020 15:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580285;
        bh=f+n3YMgXkXs0rG8/627tgOrkqDoU7zLPOV3wFV3zpm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmQQpvAch0FhDg6oc9HHlLVu9h4A3q1RI8Ab8Zb13KO8MRoq37CHZ27EhwuR5wdpy
         Wlal//VI/uY3Gh0t5cIjSktgE8IENasbIITA4bTUn7mN9fAWicvSSSeM5IaOS0A09e
         72GYz+OuKZNz4gy5/+w85Gu9JUesFJiKoZBlg4Vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 192/376] io_uring: allow POLL_ADD with double poll_wait() users
Date:   Fri, 19 Jun 2020 16:31:50 +0200
Message-Id: <20200619141719.442278514@linuxfoundation.org>
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
index 07d9414268f1..2d5f81a1bf9c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4106,27 +4106,6 @@ struct io_poll_table {
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
@@ -4180,6 +4159,144 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
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
@@ -4255,18 +4372,13 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
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
@@ -4297,6 +4409,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
 	__poll_t mask, ret;
+	bool had_io;
 
 	if (!req->file || !file_can_poll(req->file))
 		return false;
@@ -4311,6 +4424,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 
 	req->flags |= REQ_F_POLLED;
 	memcpy(&apoll->work, &req->work, sizeof(req->work));
+	had_io = req->io != NULL;
 
 	get_task_struct(current);
 	req->task = current;
@@ -4330,7 +4444,9 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
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
@@ -4363,6 +4479,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 	bool do_complete;
 
 	if (req->opcode == IORING_OP_POLL_ADD) {
+		io_poll_remove_double(req);
 		do_complete = __io_poll_remove_one(req, &req->poll);
 	} else {
 		struct async_poll *apoll = req->apoll;
@@ -4463,49 +4580,6 @@ static int io_poll_remove(struct io_kiocb *req)
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



