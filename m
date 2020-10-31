Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77E72A16D8
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbgJaLkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727385AbgJaLkq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:40:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D61420719;
        Sat, 31 Oct 2020 11:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144446;
        bh=p0XT68h0Mei8BYXd1WcCkIhpTs1B7gWCRgc7R6YQYCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMg3nJZO7AXMPXG3NSUXfRLCVmizpG+ZqMix0CBWfbWSVbodT+KCH+57d3fxI8LJe
         rJGD/b9biIdmG1zanQCFM6TmWufUmBXIub/1I7nvsHXuGsxIUBxKIMw5WtbWH/B9Zp
         HUOBN7Iw3n0TxOpmoTRBKo/NvdpHn1uZugBZOl7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 06/70] io_uring: unconditionally grab req->task
Date:   Sat, 31 Oct 2020 12:35:38 +0100
Message-Id: <20201031113459.798371952@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
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
 fs/io_uring.c |   26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -550,7 +550,6 @@ enum {
 	REQ_F_NO_FILE_TABLE_BIT,
 	REQ_F_QUEUE_TIMEOUT_BIT,
 	REQ_F_WORK_INITIALIZED_BIT,
-	REQ_F_TASK_PINNED_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -608,8 +607,6 @@ enum {
 	REQ_F_QUEUE_TIMEOUT	= BIT(REQ_F_QUEUE_TIMEOUT_BIT),
 	/* io_wq_work is initialized */
 	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
-	/* req->task is refcounted */
-	REQ_F_TASK_PINNED	= BIT(REQ_F_TASK_PINNED_BIT),
 };
 
 struct async_poll {
@@ -924,21 +921,6 @@ struct sock *io_uring_get_socket(struct
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
-/* not idempotent -- it doesn't clear REQ_F_TASK_PINNED */
-static void __io_put_req_task(struct io_kiocb *req)
-{
-	if (req->flags & REQ_F_TASK_PINNED)
-		put_task_struct(req->task);
-}
-
 static void io_file_put_work(struct work_struct *work);
 
 /*
@@ -1455,7 +1437,7 @@ static void __io_req_aux_free(struct io_
 	kfree(req->io);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
-	__io_put_req_task(req);
+	put_task_struct(req->task);
 	io_req_work_drop_env(req);
 }
 
@@ -1765,7 +1747,7 @@ static inline bool io_req_multi_free(str
 	if ((req->flags & REQ_F_LINK_HEAD) || io_is_fallback_req(req))
 		return false;
 
-	if (req->file || req->io)
+	if (req->file || req->io || req->task)
 		rb->need_iter++;
 
 	rb->reqs[rb->to_free++] = req;
@@ -4584,7 +4566,6 @@ static bool io_arm_poll_handler(struct i
 	if (req->flags & REQ_F_WORK_INITIALIZED)
 		memcpy(&apoll->work, &req->work, sizeof(req->work));
 
-	io_get_req_task(req);
 	req->apoll = apoll;
 	INIT_HLIST_NODE(&req->hash_node);
 
@@ -4774,8 +4755,6 @@ static int io_poll_add_prep(struct io_ki
 
 	events = READ_ONCE(sqe->poll_events);
 	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
-
-	io_get_req_task(req);
 	return 0;
 }
 
@@ -6057,6 +6036,7 @@ static int io_init_req(struct io_ring_ct
 	/* one is dropped after submission, the other at completion */
 	refcount_set(&req->refs, 2);
 	req->task = current;
+	get_task_struct(req->task);
 	req->result = 0;
 
 	if (unlikely(req->opcode >= IORING_OP_LAST))


