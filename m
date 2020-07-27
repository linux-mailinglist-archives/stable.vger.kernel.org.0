Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F289F22ED43
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 15:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgG0N1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 09:27:46 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:37219 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726139AbgG0N1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 09:27:45 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id D7C711942244;
        Mon, 27 Jul 2020 09:27:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 27 Jul 2020 09:27:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=dqLVsk
        Hss3DS3JiUQUOWY3uFxsd8adKLSYrzI5Mc1Lo=; b=nJK+28kyUsf4eseXQR4j6v
        cd2rM/VI3TzH/FwKtxPGt65RB39apKbO3B2yLBqD46hBPCJIYzvMjLAzqZVSc/4r
        hpplxkBGFaXfX6FDayKVUwnHTReE7mH1TLhh8WKVrVTeakSApZRu4DouYfN7ofyn
        CfeQdM5L0VgIBBIvk0DFHN8p2za1+Mr34LC4YODXe7GYWyvcIt3C3YUbeokwAJXj
        Mykc9cDmtflpFEWG4GLQwjErCATWJ04obzNj19x7czUJ+E2FIbUHH/zGspM3rQz9
        4C2mA5Zw5fTN+kQl3E/22CQuclYYymbjjQt1Mb/XBZoBTxSY208rbny86Gzje5Hg
        ==
X-ME-Sender: <xms:T9YeX_mhEtrf4_xphWdiPg8D9BFME6Ei16JNfS_YNmwrKByxIPC3BQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedriedtgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:T9YeXy3J9h7PIfBHY7C_1AOL_KEuKGs9qfgFSeoG-FHFdqKNcjNkdA>
    <xmx:T9YeX1purloEscJwQtMGD0BWVIqQQ-IQcewit0SrgJsQvV74ESCyvA>
    <xmx:T9YeX3lERV9oiSpTagLZda-WSS7HlpeQr5r_kDn6QIaJKtRlVuft6g>
    <xmx:T9YeX-DyTUuOw0nT_omt22W4uK_4ug1XxezFCry7r4IjYQz6yOgbiw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3A3E9328005A;
        Mon, 27 Jul 2020 09:27:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: ensure double poll additions work with both request" failed to apply to 5.7-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jul 2020 15:27:39 +0200
Message-ID: <159585645969173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 807abcb0883439af5ead73f3308310453b97b624 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 17 Jul 2020 17:09:27 -0600
Subject: [PATCH] io_uring: ensure double poll additions work with both request
 types

The double poll additions were centered around doing POLL_ADD on file
descriptors that use more than one waitqueue (typically one for read,
one for write) when being polled. However, it can also end up being
triggered for when we use poll triggered retry. For that case, we cannot
safely use req->io, as that could be used by the request type itself.

Add a second io_poll_iocb pointer in the structure we allocate for poll
based retry, and ensure we use the right one from the two paths.

Fixes: 18bceab101ad ("io_uring: allow POLL_ADD with double poll_wait() users")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 74bc4a04befa..53232ac3da17 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -605,6 +605,7 @@ enum {
 
 struct async_poll {
 	struct io_poll_iocb	poll;
+	struct io_poll_iocb	*double_poll;
 	struct io_wq_work	work;
 };
 
@@ -4159,9 +4160,9 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 	return false;
 }
 
-static void io_poll_remove_double(struct io_kiocb *req)
+static void io_poll_remove_double(struct io_kiocb *req, void *data)
 {
-	struct io_poll_iocb *poll = (struct io_poll_iocb *) req->io;
+	struct io_poll_iocb *poll = data;
 
 	lockdep_assert_held(&req->ctx->completion_lock);
 
@@ -4181,7 +4182,7 @@ static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_poll_remove_double(req);
+	io_poll_remove_double(req, req->io);
 	req->poll.done = true;
 	io_cqring_fill_event(req, error ? error : mangle_poll(mask));
 	io_commit_cqring(ctx);
@@ -4224,21 +4225,21 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
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
@@ -4258,7 +4259,8 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
 }
 
 static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
-			    struct wait_queue_head *head)
+			    struct wait_queue_head *head,
+			    struct io_poll_iocb **poll_ptr)
 {
 	struct io_kiocb *req = pt->req;
 
@@ -4269,7 +4271,7 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 	 */
 	if (unlikely(poll->head)) {
 		/* already have a 2nd entry, fail a third attempt */
-		if (req->io) {
+		if (*poll_ptr) {
 			pt->error = -EINVAL;
 			return;
 		}
@@ -4281,7 +4283,7 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 		io_init_poll_iocb(poll, req->poll.events, io_poll_double_wake);
 		refcount_inc(&req->refs);
 		poll->wait.private = req;
-		req->io = (void *) poll;
+		*poll_ptr = poll;
 	}
 
 	pt->error = 0;
@@ -4293,8 +4295,9 @@ static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
 			       struct poll_table_struct *p)
 {
 	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
+	struct async_poll *apoll = pt->req->apoll;
 
-	__io_queue_proc(&pt->req->apoll->poll, pt, head);
+	__io_queue_proc(&apoll->poll, pt, head, &apoll->double_poll);
 }
 
 static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
@@ -4344,11 +4347,13 @@ static void io_async_task_func(struct callback_head *cb)
 		}
 	}
 
+	io_poll_remove_double(req, apoll->double_poll);
 	spin_unlock_irq(&ctx->completion_lock);
 
 	/* restore ->work in case we need to retry again */
 	if (req->flags & REQ_F_WORK_INITIALIZED)
 		memcpy(&req->work, &apoll->work, sizeof(req->work));
+	kfree(apoll->double_poll);
 	kfree(apoll);
 
 	if (!canceled) {
@@ -4436,7 +4441,6 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
 	__poll_t mask, ret;
-	bool had_io;
 
 	if (!req->file || !file_can_poll(req->file))
 		return false;
@@ -4448,11 +4452,11 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 	if (unlikely(!apoll))
 		return false;
+	apoll->double_poll = NULL;
 
 	req->flags |= REQ_F_POLLED;
 	if (req->flags & REQ_F_WORK_INITIALIZED)
 		memcpy(&apoll->work, &req->work, sizeof(req->work));
-	had_io = req->io != NULL;
 
 	io_get_req_task(req);
 	req->apoll = apoll;
@@ -4470,13 +4474,11 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
 	if (ret) {
-		ipt.error = 0;
-		/* only remove double add if we did it here */
-		if (!had_io)
-			io_poll_remove_double(req);
+		io_poll_remove_double(req, apoll->double_poll);
 		spin_unlock_irq(&ctx->completion_lock);
 		if (req->flags & REQ_F_WORK_INITIALIZED)
 			memcpy(&req->work, &apoll->work, sizeof(req->work));
+		kfree(apoll->double_poll);
 		kfree(apoll);
 		return false;
 	}
@@ -4507,11 +4509,13 @@ static bool io_poll_remove_one(struct io_kiocb *req)
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
@@ -4524,6 +4528,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 			if (req->flags & REQ_F_WORK_INITIALIZED)
 				memcpy(&req->work, &apoll->work,
 				       sizeof(req->work));
+			kfree(apoll->double_poll);
 			kfree(apoll);
 		}
 	}
@@ -4624,7 +4629,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 {
 	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
 
-	__io_queue_proc(&pt->req->poll, pt, head);
+	__io_queue_proc(&pt->req->poll, pt, head, (struct io_poll_iocb **) &pt->req->io);
 }
 
 static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)

