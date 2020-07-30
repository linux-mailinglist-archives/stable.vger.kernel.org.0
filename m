Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F273232E8D
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbgG3IVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729097AbgG3IFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:05:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB64D20672;
        Thu, 30 Jul 2020 08:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096306;
        bh=3xc/Jfcni14QamrIzlNIEFDMD8rbCoE7t4SQ5Kx/ZgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjiu+tsEj8ZYfZNxqvACG+h/5RWmw8i+Qc2eg9nqwnMx0M+xV4VFuzB6cnQXJDeBV
         HlKDETk861SI5gpycYfI0kEjObKUkZ1QcF8KknhPJzl/iRoX8stIFXUFYxm86nQjg0
         wzthMb4gz+MpvkJLAndul5PVvWOoQCgXvh9vR/yc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.7 19/20] io_uring: ensure double poll additions work with both request types
Date:   Thu, 30 Jul 2020 10:04:09 +0200
Message-Id: <20200730074421.438448757@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.533211699@linuxfoundation.org>
References: <20200730074420.533211699@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 807abcb0883439af5ead73f3308310453b97b624 upstream.

The double poll additions were centered around doing POLL_ADD on file
descriptors that use more than one waitqueue (typically one for read,
one for write) when being polled. However, it can also end up being
triggered for when we use poll triggered retry. For that case, we cannot
safely use req->io, as that could be used by the request type itself.

Add a second io_poll_iocb pointer in the structure we allocate for poll
based retry, and ensure we use the right one from the two paths.

Fixes: 18bceab101ad ("io_uring: allow POLL_ADD with double poll_wait() users")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   47 ++++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -581,6 +581,7 @@ enum {
 
 struct async_poll {
 	struct io_poll_iocb	poll;
+	struct io_poll_iocb	*double_poll;
 	struct io_wq_work	work;
 };
 
@@ -4220,9 +4221,9 @@ static bool io_poll_rewait(struct io_kio
 	return false;
 }
 
-static void io_poll_remove_double(struct io_kiocb *req)
+static void io_poll_remove_double(struct io_kiocb *req, void *data)
 {
-	struct io_poll_iocb *poll = (struct io_poll_iocb *) req->io;
+	struct io_poll_iocb *poll = data;
 
 	lockdep_assert_held(&req->ctx->completion_lock);
 
@@ -4242,7 +4243,7 @@ static void io_poll_complete(struct io_k
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_poll_remove_double(req);
+	io_poll_remove_double(req, req->io);
 	req->poll.done = true;
 	io_cqring_fill_event(req, error ? error : mangle_poll(mask));
 	io_commit_cqring(ctx);
@@ -4285,21 +4286,21 @@ static int io_poll_double_wake(struct wa
 			       int sync, void *key)
 {
 	struct io_kiocb *req = wait->private;
-	struct io_poll_iocb *poll = (struct io_poll_iocb *) req->io;
+	struct io_poll_iocb *poll = req->apoll->double_poll;
 	__poll_t mask = key_to_poll(key);
 
 	/* for instances that support it check for an event match first: */
 	if (mask && !(mask & poll->events))
 		return 0;
 
-	if (req->poll.head) {
+	if (poll && poll->head) {
 		bool done;
 
-		spin_lock(&req->poll.head->lock);
-		done = list_empty(&req->poll.wait.entry);
+		spin_lock(&poll->head->lock);
+		done = list_empty(&poll->wait.entry);
 		if (!done)
-			list_del_init(&req->poll.wait.entry);
-		spin_unlock(&req->poll.head->lock);
+			list_del_init(&poll->wait.entry);
+		spin_unlock(&poll->head->lock);
 		if (!done)
 			__io_async_wake(req, poll, mask, io_poll_task_func);
 	}
@@ -4319,7 +4320,8 @@ static void io_init_poll_iocb(struct io_
 }
 
 static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
-			    struct wait_queue_head *head)
+			    struct wait_queue_head *head,
+			    struct io_poll_iocb **poll_ptr)
 {
 	struct io_kiocb *req = pt->req;
 
@@ -4330,7 +4332,7 @@ static void __io_queue_proc(struct io_po
 	 */
 	if (unlikely(poll->head)) {
 		/* already have a 2nd entry, fail a third attempt */
-		if (req->io) {
+		if (*poll_ptr) {
 			pt->error = -EINVAL;
 			return;
 		}
@@ -4342,7 +4344,7 @@ static void __io_queue_proc(struct io_po
 		io_init_poll_iocb(poll, req->poll.events, io_poll_double_wake);
 		refcount_inc(&req->refs);
 		poll->wait.private = req;
-		req->io = (void *) poll;
+		*poll_ptr = poll;
 	}
 
 	pt->error = 0;
@@ -4354,8 +4356,9 @@ static void io_async_queue_proc(struct f
 			       struct poll_table_struct *p)
 {
 	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
+	struct async_poll *apoll = pt->req->apoll;
 
-	__io_queue_proc(&pt->req->apoll->poll, pt, head);
+	__io_queue_proc(&apoll->poll, pt, head, &apoll->double_poll);
 }
 
 static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
@@ -4409,6 +4412,7 @@ static void io_async_task_func(struct ca
 	memcpy(&req->work, &apoll->work, sizeof(req->work));
 
 	if (canceled) {
+		kfree(apoll->double_poll);
 		kfree(apoll);
 		io_cqring_ev_posted(ctx);
 end_req:
@@ -4426,6 +4430,7 @@ end_req:
 	__io_queue_sqe(req, NULL);
 	mutex_unlock(&ctx->uring_lock);
 
+	kfree(apoll->double_poll);
 	kfree(apoll);
 }
 
@@ -4497,7 +4502,6 @@ static bool io_arm_poll_handler(struct i
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
 	__poll_t mask, ret;
-	bool had_io;
 
 	if (!req->file || !file_can_poll(req->file))
 		return false;
@@ -4509,10 +4513,10 @@ static bool io_arm_poll_handler(struct i
 	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 	if (unlikely(!apoll))
 		return false;
+	apoll->double_poll = NULL;
 
 	req->flags |= REQ_F_POLLED;
 	memcpy(&apoll->work, &req->work, sizeof(req->work));
-	had_io = req->io != NULL;
 
 	get_task_struct(current);
 	req->task = current;
@@ -4531,12 +4535,10 @@ static bool io_arm_poll_handler(struct i
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
 	if (ret) {
-		ipt.error = 0;
-		/* only remove double add if we did it here */
-		if (!had_io)
-			io_poll_remove_double(req);
+		io_poll_remove_double(req, apoll->double_poll);
 		spin_unlock_irq(&ctx->completion_lock);
 		memcpy(&req->work, &apoll->work, sizeof(req->work));
+		kfree(apoll->double_poll);
 		kfree(apoll);
 		return false;
 	}
@@ -4567,11 +4569,13 @@ static bool io_poll_remove_one(struct io
 	bool do_complete;
 
 	if (req->opcode == IORING_OP_POLL_ADD) {
-		io_poll_remove_double(req);
+		io_poll_remove_double(req, req->io);
 		do_complete = __io_poll_remove_one(req, &req->poll);
 	} else {
 		struct async_poll *apoll = req->apoll;
 
+		io_poll_remove_double(req, apoll->double_poll);
+
 		/* non-poll requests have submit ref still */
 		do_complete = __io_poll_remove_one(req, &apoll->poll);
 		if (do_complete) {
@@ -4582,6 +4586,7 @@ static bool io_poll_remove_one(struct io
 			 * final reference.
 			 */
 			memcpy(&req->work, &apoll->work, sizeof(req->work));
+			kfree(apoll->double_poll);
 			kfree(apoll);
 		}
 	}
@@ -4682,7 +4687,7 @@ static void io_poll_queue_proc(struct fi
 {
 	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
 
-	__io_queue_proc(&pt->req->poll, pt, head);
+	__io_queue_proc(&pt->req->poll, pt, head, (struct io_poll_iocb **) &pt->req->io);
 }
 
 static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)


