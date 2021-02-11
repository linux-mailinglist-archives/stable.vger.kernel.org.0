Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E31C318DE7
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhBKPNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:13:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:48940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhBKPFQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:05:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1797064E92;
        Thu, 11 Feb 2021 15:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055794;
        bh=ngdDiRYZvdAYFJ4HNKZllQP5UAl/wFpBhYihJg39oNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08rYDYv8m+WSO/7VmDije7bkefYIqNimm91SB3JkyhMp8f7s/B1AnJnpXFFf0Gfpc
         rBDtrAhxTaRfjj79qf2LiqyphJuHWKS8MaTcaXn6RXjUj4w/PknUmXql5xA8Xs2qVE
         itNRfRl1Q0s0tAqsz0C9umTW46/Vj1snm4HTHKTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.10 10/54] io_uring: replace inflight_wait with tctx->wait
Date:   Thu, 11 Feb 2021 16:01:54 +0100
Message-Id: <20210211150153.326935464@linuxfoundation.org>
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

[ Upstream commit c98de08c990e190fc7cc3aaf8079b4a0674c6425 ]

As tasks now cancel only theirs requests, and inflight_wait is awaited
only in io_uring_cancel_files(), which should be called with ->in_idle
set, instead of keeping a separate inflight_wait use tctx->wait.

That will add some spurious wakeups but actually is safer from point of
not hanging the task.

e.g.
task1                   | IRQ
                        | *start* io_complete_rw_common(link)
                        |        link: req1 -> req2 -> req3(with files)
*cancel_files()         |
io_wq_cancel(), etc.    |
                        | put_req(link), adds to io-wq req2
schedule()              |

So, task1 will never try to cancel req2 or req3. If req2 is
long-standing (e.g. read(empty_pipe)), this may hang.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -286,7 +286,6 @@ struct io_ring_ctx {
 		struct list_head	timeout_list;
 		struct list_head	cq_overflow_list;
 
-		wait_queue_head_t	inflight_wait;
 		struct io_uring_sqe	*sq_sqes;
 	} ____cacheline_aligned_in_smp;
 
@@ -1220,7 +1219,6 @@ static struct io_ring_ctx *io_ring_ctx_a
 	INIT_LIST_HEAD(&ctx->iopoll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
-	init_waitqueue_head(&ctx->inflight_wait);
 	spin_lock_init(&ctx->inflight_lock);
 	INIT_LIST_HEAD(&ctx->inflight_list);
 	INIT_DELAYED_WORK(&ctx->file_put_work, io_file_put_work);
@@ -5894,6 +5892,7 @@ static int io_req_defer(struct io_kiocb
 static void io_req_drop_files(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_uring_task *tctx = req->task->io_uring;
 	unsigned long flags;
 
 	if (req->work.flags & IO_WQ_WORK_FILES) {
@@ -5905,8 +5904,8 @@ static void io_req_drop_files(struct io_
 	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	req->flags &= ~REQ_F_INFLIGHT;
 	req->work.flags &= ~IO_WQ_WORK_FILES;
-	if (waitqueue_active(&ctx->inflight_wait))
-		wake_up(&ctx->inflight_wait);
+	if (atomic_read(&tctx->in_idle))
+		wake_up(&tctx->wait);
 }
 
 static void __io_clean_op(struct io_kiocb *req)
@@ -8605,8 +8604,8 @@ static void io_uring_cancel_files(struct
 			break;
 		}
 		if (found)
-			prepare_to_wait(&ctx->inflight_wait, &wait,
-						TASK_UNINTERRUPTIBLE);
+			prepare_to_wait(&task->io_uring->wait, &wait,
+					TASK_UNINTERRUPTIBLE);
 		spin_unlock_irq(&ctx->inflight_lock);
 
 		/* We need to keep going until we don't find a matching req */
@@ -8619,7 +8618,7 @@ static void io_uring_cancel_files(struct
 		/* cancellations _may_ trigger task work */
 		io_run_task_work();
 		schedule();
-		finish_wait(&ctx->inflight_wait, &wait);
+		finish_wait(&task->io_uring->wait, &wait);
 	}
 }
 


