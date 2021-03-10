Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4855C333D9A
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbhCJNYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231880AbhCJNYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3C2F64FD8;
        Wed, 10 Mar 2021 13:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382641;
        bh=LDHNb+sy+gRCdmnRR2NDZyK1SnKkNzS/cHAMj0HLJXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yJX/nlYZV6xAfjH3HBPrzzJ02JpM4RyJCBL6p5y94UTyt3WRirea4xzp443ec7d/d
         8UH+FlpsVBMhLpaII3weA+Inro2jDJTk0B5csGiN02Wqo8DqfRJgRwflW07koYD+jq
         qlb5M1SncgaBhzDMM5aiM9YGptN0WP9bZWr1FJrQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.11 03/36] io_uring: deduplicate core cancellations sequence
Date:   Wed, 10 Mar 2021 14:23:16 +0100
Message-Id: <20210310132320.630933666@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Pavel Begunkov <asml.silence@gmail.com>

commit 9936c7c2bc76a0b2276f6d19de6d1d92f03deeab upstream

Files and task cancellations go over same steps trying to cancel
requests in io-wq, poll, etc. Deduplicate it with a helper.

note: new io_uring_try_cancel_requests() is former
__io_uring_cancel_task_requests() with files passed as an agrument and
flushing overflowed requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   85 +++++++++++++++++++++++++++-------------------------------
 1 file changed, 40 insertions(+), 45 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -996,9 +996,9 @@ enum io_mem_account {
 	ACCT_PINNED,
 };
 
-static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
-					    struct task_struct *task);
-
+static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
+					 struct task_struct *task,
+					 struct files_struct *files);
 static void destroy_fixed_file_ref_node(struct fixed_file_ref_node *ref_node);
 static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
 			struct io_ring_ctx *ctx);
@@ -8780,7 +8780,7 @@ static void io_ring_exit_work(struct wor
 	 * as nobody else will be looking for them.
 	 */
 	do {
-		__io_uring_cancel_task_requests(ctx, NULL);
+		io_uring_try_cancel_requests(ctx, NULL, NULL);
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 	io_ring_ctx_free(ctx);
 }
@@ -8894,6 +8894,40 @@ static void io_cancel_defer_files(struct
 	}
 }
 
+static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
+					 struct task_struct *task,
+					 struct files_struct *files)
+{
+	struct io_task_cancel cancel = { .task = task, .files = files, };
+
+	while (1) {
+		enum io_wq_cancel cret;
+		bool ret = false;
+
+		if (ctx->io_wq) {
+			cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb,
+					       &cancel, true);
+			ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
+		}
+
+		/* SQPOLL thread does its own polling */
+		if (!(ctx->flags & IORING_SETUP_SQPOLL) && !files) {
+			while (!list_empty_careful(&ctx->iopoll_list)) {
+				io_iopoll_try_reap_events(ctx);
+				ret = true;
+			}
+		}
+
+		ret |= io_poll_remove_all(ctx, task, files);
+		ret |= io_kill_timeouts(ctx, task, files);
+		ret |= io_run_task_work();
+		io_cqring_overflow_flush(ctx, true, task, files);
+		if (!ret)
+			break;
+		cond_resched();
+	}
+}
+
 static int io_uring_count_inflight(struct io_ring_ctx *ctx,
 				   struct task_struct *task,
 				   struct files_struct *files)
@@ -8913,7 +8947,6 @@ static void io_uring_cancel_files(struct
 				  struct files_struct *files)
 {
 	while (!list_empty_careful(&ctx->inflight_list)) {
-		struct io_task_cancel cancel = { .task = task, .files = files };
 		DEFINE_WAIT(wait);
 		int inflight;
 
@@ -8921,13 +8954,7 @@ static void io_uring_cancel_files(struct
 		if (!inflight)
 			break;
 
-		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
-		io_poll_remove_all(ctx, task, files);
-		io_kill_timeouts(ctx, task, files);
-		io_cqring_overflow_flush(ctx, true, task, files);
-		/* cancellations _may_ trigger task work */
-		io_run_task_work();
-
+		io_uring_try_cancel_requests(ctx, task, files);
 		prepare_to_wait(&task->io_uring->wait, &wait,
 				TASK_UNINTERRUPTIBLE);
 		if (inflight == io_uring_count_inflight(ctx, task, files))
@@ -8936,37 +8963,6 @@ static void io_uring_cancel_files(struct
 	}
 }
 
-static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
-					    struct task_struct *task)
-{
-	while (1) {
-		struct io_task_cancel cancel = { .task = task, .files = NULL, };
-		enum io_wq_cancel cret;
-		bool ret = false;
-
-		if (ctx->io_wq) {
-			cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb,
-					       &cancel, true);
-			ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
-		}
-
-		/* SQPOLL thread does its own polling */
-		if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
-			while (!list_empty_careful(&ctx->iopoll_list)) {
-				io_iopoll_try_reap_events(ctx);
-				ret = true;
-			}
-		}
-
-		ret |= io_poll_remove_all(ctx, task, NULL);
-		ret |= io_kill_timeouts(ctx, task, NULL);
-		ret |= io_run_task_work();
-		if (!ret)
-			break;
-		cond_resched();
-	}
-}
-
 static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
@@ -8996,11 +8992,10 @@ static void io_uring_cancel_task_request
 	}
 
 	io_cancel_defer_files(ctx, task, files);
-	io_cqring_overflow_flush(ctx, true, task, files);
 
 	io_uring_cancel_files(ctx, task, files);
 	if (!files)
-		__io_uring_cancel_task_requests(ctx, task);
+		io_uring_try_cancel_requests(ctx, task, NULL);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);


