Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23581378944
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239268AbhEJL0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238001AbhEJLQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:16:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEF086145F;
        Mon, 10 May 2021 11:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645120;
        bh=4weyI2ArTiQuE0mY3q09ZkgP2yQ9TSeaOtuvSOCOMRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xfZhqwr1Pu4Q/7gTjIiCIbV3LGFJ/0OppRZ+vgV0Zs6hrw8+9fTRYE7iZ6FQzGYOp
         5OEm+p6Xb7coEPOOCwD6OR9HrCT6Z4UHCQMdnQCwyx7P/B6PA0ag0qjQpdXYEab7k1
         QqVqbvFzB4xw4Cv3mG/yICvZqPxyKGZulqxlBqnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Hassila <joj@mac.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.12 360/384] io_uring: fix shared sqpoll cancellation hangs
Date:   Mon, 10 May 2021 12:22:29 +0200
Message-Id: <20210510102026.620273379@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 734551df6f9bedfbefcd113ede665945e9de0b99 upstream.

[  736.982891] INFO: task iou-sqp-4294:4295 blocked for more than 122 seconds.
[  736.982897] Call Trace:
[  736.982901]  schedule+0x68/0xe0
[  736.982903]  io_uring_cancel_sqpoll+0xdb/0x110
[  736.982908]  io_sqpoll_cancel_cb+0x24/0x30
[  736.982911]  io_run_task_work_head+0x28/0x50
[  736.982913]  io_sq_thread+0x4e3/0x720

We call io_uring_cancel_sqpoll() one by one for each ctx either in
sq_thread() itself or via task works, and it's intended to cancel all
requests of a specified context. However the function uses per-task
counters to track the number of inflight requests, so it counts more
requests than available via currect io_uring ctx and goes to sleep for
them to appear (e.g. from IRQ), that will never happen.

Cancel a bit more than before, i.e. all ctxs that share sqpoll
and continue to use shared counters. Don't forget that we should not
remove ctx from the list before running that task_work sqpoll-cancel,
otherwise the function wouldn't be able to find the context and will
hang.

Reported-by: Joakim Hassila <joj@mac.com>
Reported-by: Jens Axboe <axboe@kernel.dk>
Fixes: 37d1e2e3642e2 ("io_uring: move SQPOLL thread io-wq forked worker")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1bded7e6c6b32e0bae25fce36be2868e46b116a0.1618752958.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1008,7 +1008,7 @@ static void io_uring_del_task_file(unsig
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 struct files_struct *files);
-static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx);
+static void io_uring_cancel_sqpoll(struct io_sq_data *sqd);
 static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node);
 static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
 			struct io_ring_ctx *ctx);
@@ -6836,15 +6836,14 @@ static int io_sq_thread(void *data)
 		timeout = jiffies + sqd->sq_thread_idle;
 	}
 
-	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-		io_uring_cancel_sqpoll(ctx);
+	io_uring_cancel_sqpoll(sqd);
 	sqd->thread = NULL;
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 		io_ring_set_wakeup_flag(ctx);
-	mutex_unlock(&sqd->lock);
-
 	io_run_task_work();
 	io_run_task_work_head(&sqd->park_task_work);
+	mutex_unlock(&sqd->lock);
+
 	complete(&sqd->exited);
 	do_exit(0);
 }
@@ -8931,11 +8930,11 @@ static s64 tctx_inflight(struct io_uring
 static void io_sqpoll_cancel_cb(struct callback_head *cb)
 {
 	struct io_tctx_exit *work = container_of(cb, struct io_tctx_exit, task_work);
-	struct io_ring_ctx *ctx = work->ctx;
-	struct io_sq_data *sqd = ctx->sq_data;
+	struct io_sq_data *sqd = work->ctx->sq_data;
 
 	if (sqd->thread)
-		io_uring_cancel_sqpoll(ctx);
+		io_uring_cancel_sqpoll(sqd);
+	list_del_init(&work->ctx->sqd_list);
 	complete(&work->completion);
 }
 
@@ -8946,7 +8945,6 @@ static void io_sqpoll_cancel_sync(struct
 	struct task_struct *task;
 
 	io_sq_thread_park(sqd);
-	list_del_init(&ctx->sqd_list);
 	io_sqd_update_thread_idle(sqd);
 	task = sqd->thread;
 	if (task) {
@@ -8954,6 +8952,8 @@ static void io_sqpoll_cancel_sync(struct
 		init_task_work(&work.task_work, io_sqpoll_cancel_cb);
 		io_task_work_add_head(&sqd->park_task_work, &work.task_work);
 		wake_up_process(task);
+	} else {
+		list_del_init(&ctx->sqd_list);
 	}
 	io_sq_thread_unpark(sqd);
 
@@ -8987,14 +8987,14 @@ void __io_uring_files_cancel(struct file
 }
 
 /* should only be called by SQPOLL task */
-static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
+static void io_uring_cancel_sqpoll(struct io_sq_data *sqd)
 {
-	struct io_sq_data *sqd = ctx->sq_data;
 	struct io_uring_task *tctx = current->io_uring;
+	struct io_ring_ctx *ctx;
 	s64 inflight;
 	DEFINE_WAIT(wait);
 
-	WARN_ON_ONCE(!sqd || ctx->sq_data->thread != current);
+	WARN_ON_ONCE(!sqd || sqd->thread != current);
 
 	atomic_inc(&tctx->in_idle);
 	do {
@@ -9002,7 +9002,8 @@ static void io_uring_cancel_sqpoll(struc
 		inflight = tctx_inflight(tctx);
 		if (!inflight)
 			break;
-		io_uring_try_cancel_requests(ctx, current, NULL);
+		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+			io_uring_try_cancel_requests(ctx, current, NULL);
 
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
 		/*


