Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974AB2464B6
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgHQKnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:43:43 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:40133 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbgHQKnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 06:43:43 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 906841941BD8;
        Mon, 17 Aug 2020 06:43:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 06:43:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9YNqpY
        L2sGwMyh4MoEFWfd/cvQLt0kIHGO0+bfh2JDc=; b=cfL8T+P2Hdy683mya/xlyD
        iMTdiniynVSiqbF37/lfgVMPoDn0nD4xR6XGKgopfwxBHpFIX6n0d8PN1FXoIBWm
        8jClww8t95ck30gSvdVbuNNlHZxpwbgbyFbSBj7jfWFsCG8UFrerFeX79exDgw+/
        KVgAy6/pVewAWJEZX6BkBpkXI1U+47ApbutQTIBvn5F+EEhS6cdyInsKx1eZ00Q+
        d0FevJsqtBZG8j1UEmv3HACs0xSHfyJOmCIc6hh/TlrY6xvyOCKvXBmKDXooxLt+
        WHjXoUy+YXHJDJ2dUjOBtciBogqpxY5r1L2ngRel4emmaz6F49GXriagq0Rmqcnw
        ==
X-ME-Sender: <xms:Xl86XxQIMCYsmkdmsaduRCzRH6xgZ7Ruf0VILRQ5IWqcI2zVdF735A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:Xl86X6yEG3yJ-HjLF16Ik4XKxmyF54AcpPJArDeyLyRMDlBo8ZFMYg>
    <xmx:Xl86X21d2v6r2gyV-yj-RRXdnt9vUzTahyfHMYzYF0a29qWmAuQaBA>
    <xmx:Xl86X5AhSZ5r-Ego2o_wZrg6mfYMU1jqD6ahfrd0WlFCVunvwTFq0w>
    <xmx:Xl86X1vhaeTuUPDpULDTBBsRNRHZdw2rYRcrJvkL_gFcmdAoD7Vn6Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 337143060067;
        Mon, 17 Aug 2020 06:43:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: hold 'ctx' reference around task_work queue +" failed to apply to 5.7-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 12:44:03 +0200
Message-ID: <159766104348155@kroah.com>
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

From 6d816e088c359866f9867057e04f244c608c42fe Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 11 Aug 2020 08:04:14 -0600
Subject: [PATCH] io_uring: hold 'ctx' reference around task_work queue +
 execute

We're holding the request reference, but we need to go one higher
to ensure that the ctx remains valid after the request has finished.
If the ring is closed with pending task_work inflight, and the
given io_kiocb finishes sync during issue, then we need a reference
to the ring itself around the task_work execution cycle.

Cc: stable@vger.kernel.org # v5.7+
Reported-by: syzbot+9b260fc33297966f5a8e@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5488698189da..99582cf5106b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1821,8 +1821,10 @@ static void __io_req_task_submit(struct io_kiocb *req)
 static void io_req_task_submit(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct io_ring_ctx *ctx = req->ctx;
 
 	__io_req_task_submit(req);
+	percpu_ref_put(&ctx->refs);
 }
 
 static void io_req_task_queue(struct io_kiocb *req)
@@ -1830,6 +1832,7 @@ static void io_req_task_queue(struct io_kiocb *req)
 	int ret;
 
 	init_task_work(&req->task_work, io_req_task_submit);
+	percpu_ref_get(&req->ctx->refs);
 
 	ret = io_req_task_work_add(req, &req->task_work);
 	if (unlikely(ret)) {
@@ -2318,6 +2321,8 @@ static void io_rw_resubmit(struct callback_head *cb)
 		refcount_inc(&req->refs);
 		io_queue_async_work(req);
 	}
+
+	percpu_ref_put(&ctx->refs);
 }
 #endif
 
@@ -2330,6 +2335,8 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
 		return false;
 
 	init_task_work(&req->task_work, io_rw_resubmit);
+	percpu_ref_get(&req->ctx->refs);
+
 	ret = io_req_task_work_add(req, &req->task_work);
 	if (!ret)
 		return true;
@@ -3033,6 +3040,8 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 	list_del_init(&wait->entry);
 
 	init_task_work(&req->task_work, io_req_task_submit);
+	percpu_ref_get(&req->ctx->refs);
+
 	/* submit ref gets dropped, acquire a new one */
 	refcount_inc(&req->refs);
 	ret = io_req_task_work_add(req, &req->task_work);
@@ -4565,6 +4574,8 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 
 	req->result = mask;
 	init_task_work(&req->task_work, func);
+	percpu_ref_get(&req->ctx->refs);
+
 	/*
 	 * If this fails, then the task is exiting. When a task exits, the
 	 * work gets canceled, so just cancel this request as well instead
@@ -4652,11 +4663,13 @@ static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
 static void io_poll_task_func(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *nxt = NULL;
 
 	io_poll_task_handler(req, &nxt);
 	if (nxt)
 		__io_req_task_submit(nxt);
+	percpu_ref_put(&ctx->refs);
 }
 
 static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
@@ -4752,6 +4765,7 @@ static void io_async_task_func(struct callback_head *cb)
 
 	if (io_poll_rewait(req, &apoll->poll)) {
 		spin_unlock_irq(&ctx->completion_lock);
+		percpu_ref_put(&ctx->refs);
 		return;
 	}
 
@@ -4767,6 +4781,7 @@ static void io_async_task_func(struct callback_head *cb)
 	else
 		__io_req_task_cancel(req, -ECANCELED);
 
+	percpu_ref_put(&ctx->refs);
 	kfree(apoll->double_poll);
 	kfree(apoll);
 }

