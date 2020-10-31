Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0852A1648
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgJaLn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:43:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728089AbgJaLn6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:43:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE66D205F4;
        Sat, 31 Oct 2020 11:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144637;
        bh=/TXfRCesOwt2mBJcIsApgMbbHxHWlFZn5uQn6LveU/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8mVz2/y8+aaVYiYTxcg8iP5qoN+Ho1jEgk63vJlxUbNZ8DolYUg0Qf97SYjNPI9h
         2sqGKDifRzds0BfdKXECvGOoSf53d4HbHk98xkt6iO8KWWVCinfd/aJT9G09FWhl3J
         R6uZqgeMwaJIxbznWsMfwuF+Is9EStTg0kooBcYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 06/74] io_uring: unconditionally grab req->task
Date:   Sat, 31 Oct 2020 12:35:48 +0100
Message-Id: <20201031113500.338131888@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit e3bc8e9dad7f2f83cc807111d4472164c9210153 upstream.

Sometimes we assign a weak reference to it, sometimes we grab a
reference to it. Clean this up and make it unconditional, and drop the
flag related to tracking this state.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   47 +++++++++--------------------------------------
 1 file changed, 9 insertions(+), 38 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -553,7 +553,6 @@ enum {
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_NO_FILE_TABLE_BIT,
 	REQ_F_WORK_INITIALIZED_BIT,
-	REQ_F_TASK_PINNED_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -599,8 +598,6 @@ enum {
 	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
 	/* io_wq_work is initialized */
 	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
-	/* req->task is refcounted */
-	REQ_F_TASK_PINNED	= BIT(REQ_F_TASK_PINNED_BIT),
 };
 
 struct async_poll {
@@ -942,14 +939,6 @@ struct sock *io_uring_get_socket(struct
 }
 EXPORT_SYMBOL(io_uring_get_socket);
 
-static void io_get_req_task(struct io_kiocb *req)
-{
-	if (req->flags & REQ_F_TASK_PINNED)
-		return;
-	get_task_struct(req->task);
-	req->flags |= REQ_F_TASK_PINNED;
-}
-
 static inline void io_clean_op(struct io_kiocb *req)
 {
 	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
@@ -957,13 +946,6 @@ static inline void io_clean_op(struct io
 		__io_clean_op(req);
 }
 
-/* not idempotent -- it doesn't clear REQ_F_TASK_PINNED */
-static void __io_put_req_task(struct io_kiocb *req)
-{
-	if (req->flags & REQ_F_TASK_PINNED)
-		put_task_struct(req->task);
-}
-
 static void io_sq_thread_drop_mm(void)
 {
 	struct mm_struct *mm = current->mm;
@@ -1589,7 +1571,8 @@ static void __io_free_req_finish(struct
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	__io_put_req_task(req);
+	put_task_struct(req->task);
+
 	if (likely(!io_is_fallback_req(req)))
 		kmem_cache_free(req_cachep, req);
 	else
@@ -1916,16 +1899,13 @@ static void io_req_free_batch(struct req
 	if (req->flags & REQ_F_LINK_HEAD)
 		io_queue_next(req);
 
-	if (req->flags & REQ_F_TASK_PINNED) {
-		if (req->task != rb->task) {
-			if (rb->task)
-				put_task_struct_many(rb->task, rb->task_refs);
-			rb->task = req->task;
-			rb->task_refs = 0;
-		}
-		rb->task_refs++;
-		req->flags &= ~REQ_F_TASK_PINNED;
+	if (req->task != rb->task) {
+		if (rb->task)
+			put_task_struct_many(rb->task, rb->task_refs);
+		rb->task = req->task;
+		rb->task_refs = 0;
 	}
+	rb->task_refs++;
 
 	WARN_ON_ONCE(io_dismantle_req(req));
 	rb->reqs[rb->to_free++] = req;
@@ -2550,9 +2530,6 @@ static int io_prep_rw(struct io_kiocb *r
 	if (kiocb->ki_flags & IOCB_NOWAIT)
 		req->flags |= REQ_F_NOWAIT;
 
-	if (kiocb->ki_flags & IOCB_DIRECT)
-		io_get_req_task(req);
-
 	if (force_nonblock)
 		kiocb->ki_flags |= IOCB_NOWAIT;
 
@@ -2564,7 +2541,6 @@ static int io_prep_rw(struct io_kiocb *r
 		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
-		io_get_req_task(req);
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;
@@ -3132,8 +3108,6 @@ static bool io_rw_should_retry(struct io
 	kiocb->ki_flags |= IOCB_WAITQ;
 	kiocb->ki_flags &= ~IOCB_NOWAIT;
 	kiocb->ki_waitq = wait;
-
-	io_get_req_task(req);
 	return true;
 }
 
@@ -4965,7 +4939,6 @@ static bool io_arm_poll_handler(struct i
 	apoll->double_poll = NULL;
 
 	req->flags |= REQ_F_POLLED;
-	io_get_req_task(req);
 	req->apoll = apoll;
 	INIT_HLIST_NODE(&req->hash_node);
 
@@ -5148,8 +5121,6 @@ static int io_poll_add_prep(struct io_ki
 #endif
 	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP |
 		       (events & EPOLLEXCLUSIVE);
-
-	io_get_req_task(req);
 	return 0;
 }
 
@@ -6336,7 +6307,6 @@ static int io_submit_sqe(struct io_kiocb
 			return ret;
 		}
 		trace_io_uring_link(ctx, req, head);
-		io_get_req_task(req);
 		list_add_tail(&req->link_list, &head->link_list);
 
 		/* last request of a link, enqueue the link */
@@ -6461,6 +6431,7 @@ static int io_init_req(struct io_ring_ct
 	/* one is dropped after submission, the other at completion */
 	refcount_set(&req->refs, 2);
 	req->task = current;
+	get_task_struct(req->task);
 	req->result = 0;
 
 	if (unlikely(req->opcode >= IORING_OP_LAST))


