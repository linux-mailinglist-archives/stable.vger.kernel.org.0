Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966C7318DFA
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbhBKPTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:19:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229668AbhBKPNU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:13:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43B6E64EE5;
        Thu, 11 Feb 2021 15:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055852;
        bh=rkIc3vByrTGCily6WR43f/XhQgkZVZ1vVjDGp04B97Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b102Yzb8rBfdQppZ1lyFgARATzWXZAFR9nKaiCyayAAzWf6KMQOBWkvk84nPBKLXf
         WaWnMe8121xSW8A0PS09cS1LMNgUtccAkgE9yRJBERE6YnyxmPfqCpOpT7RQgmbPd8
         UbBzW1kWqBuKCIquYepxOZd6H06jKx1xYPon3GUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.10 05/54] io_uring: always batch cancel in *cancel_files()
Date:   Thu, 11 Feb 2021 16:01:49 +0100
Message-Id: <20210211150153.119399670@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit f6edbabb8359798c541b0776616c5eab3a840d3d ]

Instead of iterating over each request and cancelling it individually in
io_uring_cancel_files(), try to cancel all matching requests and use
->inflight_list only to check if there anything left.

In many cases it should be faster, and we can reuse a lot of code from
task cancellation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io-wq.c    |   10 ----
 fs/io-wq.h    |    1 
 fs/io_uring.c |  139 ++++++++--------------------------------------------------
 3 files changed, 20 insertions(+), 130 deletions(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1078,16 +1078,6 @@ enum io_wq_cancel io_wq_cancel_cb(struct
 	return IO_WQ_CANCEL_NOTFOUND;
 }
 
-static bool io_wq_io_cb_cancel_data(struct io_wq_work *work, void *data)
-{
-	return work == data;
-}
-
-enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork)
-{
-	return io_wq_cancel_cb(wq, io_wq_io_cb_cancel_data, (void *)cwork, false);
-}
-
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 {
 	int ret = -ENOMEM, node;
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -130,7 +130,6 @@ static inline bool io_wq_is_hashed(struc
 }
 
 void io_wq_cancel_all(struct io_wq *wq);
-enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork);
 
 typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
 
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1496,15 +1496,6 @@ static void io_kill_timeout(struct io_ki
 	}
 }
 
-static bool io_task_match(struct io_kiocb *req, struct task_struct *tsk)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	if (!tsk || req->task == tsk)
-		return true;
-	return (ctx->flags & IORING_SETUP_SQPOLL);
-}
-
 /*
  * Returns true if we found and killed one or more timeouts
  */
@@ -8524,112 +8515,31 @@ static int io_uring_release(struct inode
 	return 0;
 }
 
-/*
- * Returns true if 'preq' is the link parent of 'req'
- */
-static bool io_match_link(struct io_kiocb *preq, struct io_kiocb *req)
-{
-	struct io_kiocb *link;
-
-	if (!(preq->flags & REQ_F_LINK_HEAD))
-		return false;
-
-	list_for_each_entry(link, &preq->link_list, link_list) {
-		if (link == req)
-			return true;
-	}
-
-	return false;
-}
-
-/*
- * We're looking to cancel 'req' because it's holding on to our files, but
- * 'req' could be a link to another request. See if it is, and cancel that
- * parent request if so.
- */
-static bool io_poll_remove_link(struct io_ring_ctx *ctx, struct io_kiocb *req)
-{
-	struct hlist_node *tmp;
-	struct io_kiocb *preq;
-	bool found = false;
-	int i;
-
-	spin_lock_irq(&ctx->completion_lock);
-	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
-		struct hlist_head *list;
-
-		list = &ctx->cancel_hash[i];
-		hlist_for_each_entry_safe(preq, tmp, list, hash_node) {
-			found = io_match_link(preq, req);
-			if (found) {
-				io_poll_remove_one(preq);
-				break;
-			}
-		}
-	}
-	spin_unlock_irq(&ctx->completion_lock);
-	return found;
-}
-
-static bool io_timeout_remove_link(struct io_ring_ctx *ctx,
-				   struct io_kiocb *req)
-{
-	struct io_kiocb *preq;
-	bool found = false;
-
-	spin_lock_irq(&ctx->completion_lock);
-	list_for_each_entry(preq, &ctx->timeout_list, timeout.list) {
-		found = io_match_link(preq, req);
-		if (found) {
-			__io_timeout_cancel(preq);
-			break;
-		}
-	}
-	spin_unlock_irq(&ctx->completion_lock);
-	return found;
-}
+struct io_task_cancel {
+	struct task_struct *task;
+	struct files_struct *files;
+};
 
-static bool io_cancel_link_cb(struct io_wq_work *work, void *data)
+static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_task_cancel *cancel = data;
 	bool ret;
 
-	if (req->flags & REQ_F_LINK_TIMEOUT) {
+	if (cancel->files && (req->flags & REQ_F_LINK_TIMEOUT)) {
 		unsigned long flags;
 		struct io_ring_ctx *ctx = req->ctx;
 
 		/* protect against races with linked timeouts */
 		spin_lock_irqsave(&ctx->completion_lock, flags);
-		ret = io_match_link(req, data);
+		ret = io_match_task(req, cancel->task, cancel->files);
 		spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	} else {
-		ret = io_match_link(req, data);
+		ret = io_match_task(req, cancel->task, cancel->files);
 	}
 	return ret;
 }
 
-static void io_attempt_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
-{
-	enum io_wq_cancel cret;
-
-	/* cancel this particular work, if it's running */
-	cret = io_wq_cancel_work(ctx->io_wq, &req->work);
-	if (cret != IO_WQ_CANCEL_NOTFOUND)
-		return;
-
-	/* find links that hold this pending, cancel those */
-	cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_link_cb, req, true);
-	if (cret != IO_WQ_CANCEL_NOTFOUND)
-		return;
-
-	/* if we have a poll link holding this pending, cancel that */
-	if (io_poll_remove_link(ctx, req))
-		return;
-
-	/* final option, timeout link is holding this req pending */
-	io_timeout_remove_link(ctx, req);
-}
-
 static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 				  struct task_struct *task,
 				  struct files_struct *files)
@@ -8661,8 +8571,10 @@ static void io_uring_cancel_files(struct
 				  struct files_struct *files)
 {
 	while (!list_empty_careful(&ctx->inflight_list)) {
-		struct io_kiocb *cancel_req = NULL, *req;
+		struct io_task_cancel cancel = { .task = task, .files = NULL, };
+		struct io_kiocb *req;
 		DEFINE_WAIT(wait);
+		bool found = false;
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
@@ -8670,25 +8582,21 @@ static void io_uring_cancel_files(struct
 			    (req->work.flags & IO_WQ_WORK_FILES) &&
 			    req->work.identity->files != files)
 				continue;
-			/* req is being completed, ignore */
-			if (!refcount_inc_not_zero(&req->refs))
-				continue;
-			cancel_req = req;
+			found = true;
 			break;
 		}
-		if (cancel_req)
+		if (found)
 			prepare_to_wait(&ctx->inflight_wait, &wait,
 						TASK_UNINTERRUPTIBLE);
 		spin_unlock_irq(&ctx->inflight_lock);
 
 		/* We need to keep going until we don't find a matching req */
-		if (!cancel_req)
+		if (!found)
 			break;
-		/* cancel this request, or head link requests */
-		io_attempt_cancel(ctx, cancel_req);
-		io_cqring_overflow_flush(ctx, true, task, files);
 
-		io_put_req(cancel_req);
+		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
+		io_poll_remove_all(ctx, task, files);
+		io_kill_timeouts(ctx, task, files);
 		/* cancellations _may_ trigger task work */
 		io_run_task_work();
 		schedule();
@@ -8696,22 +8604,15 @@ static void io_uring_cancel_files(struct
 	}
 }
 
-static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
-{
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-	struct task_struct *task = data;
-
-	return io_task_match(req, task);
-}
-
 static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 					    struct task_struct *task)
 {
 	while (1) {
+		struct io_task_cancel cancel = { .task = task, .files = NULL, };
 		enum io_wq_cancel cret;
 		bool ret = false;
 
-		cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, task, true);
+		cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
 		if (cret != IO_WQ_CANCEL_NOTFOUND)
 			ret = true;
 


