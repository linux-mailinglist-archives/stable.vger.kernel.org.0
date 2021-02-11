Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1EC318E81
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhBKP3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:29:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230493AbhBKPYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:24:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88CEA64EE1;
        Thu, 11 Feb 2021 15:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055848;
        bh=6NcTRIFKk4unTxxNvkfJ3ULuqkv+plZ1Alue4N3L8Sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdMLtLN+PC0ufnv9CDCdfA1jy221qgkpY/NwnPeZUbgGn+6Lt76pf7VjfRoArS44V
         ENxRsn4vwW90nU6VsM/ULwQOL707BeZeV5mF9zjvUamXY2/jI+eaw//JnPbyyLHd49
         WEQRFufXlS5QXHcpvt2OK07tcyw/HT57uAyv//6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.10 03/54] io_uring: dont iterate io_uring_cancel_files()
Date:   Thu, 11 Feb 2021 16:01:47 +0100
Message-Id: <20210211150153.042590656@linuxfoundation.org>
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

[ Upstream commit b52fda00dd9df8b4a6de5784df94f9617f6133a1 ]

io_uring_cancel_files() guarantees to cancel all matching requests,
that's not necessary to do that in a loop. Move it up in the callchain
into io_uring_cancel_task_requests().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8654,16 +8654,10 @@ static void io_cancel_defer_files(struct
 	}
 }
 
-/*
- * Returns true if we found and killed one or more files pinning requests
- */
-static bool io_uring_cancel_files(struct io_ring_ctx *ctx,
+static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct task_struct *task,
 				  struct files_struct *files)
 {
-	if (list_empty_careful(&ctx->inflight_list))
-		return false;
-
 	while (!list_empty_careful(&ctx->inflight_list)) {
 		struct io_kiocb *cancel_req = NULL, *req;
 		DEFINE_WAIT(wait);
@@ -8698,8 +8692,6 @@ static bool io_uring_cancel_files(struct
 		schedule();
 		finish_wait(&ctx->inflight_wait, &wait);
 	}
-
-	return true;
 }
 
 static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
@@ -8710,15 +8702,12 @@ static bool io_cancel_task_cb(struct io_
 	return io_task_match(req, task);
 }
 
-static bool __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
-					    struct task_struct *task,
-					    struct files_struct *files)
+static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
+					    struct task_struct *task)
 {
-	bool ret;
-
-	ret = io_uring_cancel_files(ctx, task, files);
-	if (!files) {
+	while (1) {
 		enum io_wq_cancel cret;
+		bool ret = false;
 
 		cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, task, true);
 		if (cret != IO_WQ_CANCEL_NOTFOUND)
@@ -8734,9 +8723,11 @@ static bool __io_uring_cancel_task_reque
 
 		ret |= io_poll_remove_all(ctx, task);
 		ret |= io_kill_timeouts(ctx, task);
+		if (!ret)
+			break;
+		io_run_task_work();
+		cond_resched();
 	}
-
-	return ret;
 }
 
 static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
@@ -8771,11 +8762,10 @@ static void io_uring_cancel_task_request
 
 	io_cancel_defer_files(ctx, task, files);
 	io_cqring_overflow_flush(ctx, true, task, files);
+	io_uring_cancel_files(ctx, task, files);
 
-	while (__io_uring_cancel_task_requests(ctx, task, files)) {
-		io_run_task_work();
-		cond_resched();
-	}
+	if (!files)
+		__io_uring_cancel_task_requests(ctx, task);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);


