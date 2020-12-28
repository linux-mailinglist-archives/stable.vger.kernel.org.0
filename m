Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E322E3E1B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502928AbgL1OXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:23:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502922AbgL1OXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:23:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AEA4207B2;
        Mon, 28 Dec 2020 14:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165390;
        bh=WBPwrnMQKvcObH2RsuhW9WupIBbX4ocOY1SQ/Up1nRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDUMi7iA/sf/mT5kBjc1sHKHO8Z9R+E7GyjPnzMzGmS1htz8fw6zSP4PEppUcE0yD
         66zZHY71iMW0KNBq3g4ulq6mHZ8Xr8NCMlzfbTxaGkyOHS5V7sR5P/Col5XbCwDXOv
         3Y4d97+U4hKgwT3k3dLcXTg7QadsPdDF/5oY8nIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 483/717] io_uring: cancel only requests of current task
Date:   Mon, 28 Dec 2020 13:48:01 +0100
Message-Id: <20201228125044.109059952@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit df9923f96717d0aebb0a73adbcf6285fa79e38cb ]

io_uring_cancel_files() cancels all request that match files regardless
of task. There is no real need in that, cancel only requests of the
specified task. That also handles SQPOLL case as it already changes task
to it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 86dac2b2e2763..0621f581943cd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8421,14 +8421,6 @@ static int io_uring_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static bool io_wq_files_match(struct io_wq_work *work, void *data)
-{
-	struct files_struct *files = data;
-
-	return !files || ((work->flags & IO_WQ_WORK_FILES) &&
-				work->identity->files == files);
-}
-
 /*
  * Returns true if 'preq' is the link parent of 'req'
  */
@@ -8566,21 +8558,20 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
  * Returns true if we found and killed one or more files pinning requests
  */
 static bool io_uring_cancel_files(struct io_ring_ctx *ctx,
+				  struct task_struct *task,
 				  struct files_struct *files)
 {
 	if (list_empty_careful(&ctx->inflight_list))
 		return false;
 
-	/* cancel all at once, should be faster than doing it one by one*/
-	io_wq_cancel_cb(ctx->io_wq, io_wq_files_match, files, true);
-
 	while (!list_empty_careful(&ctx->inflight_list)) {
 		struct io_kiocb *cancel_req = NULL, *req;
 		DEFINE_WAIT(wait);
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
-			if (files && (req->work.flags & IO_WQ_WORK_FILES) &&
+			if (req->task == task &&
+			    (req->work.flags & IO_WQ_WORK_FILES) &&
 			    req->work.identity->files != files)
 				continue;
 			/* req is being completed, ignore */
@@ -8623,7 +8614,7 @@ static bool __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 {
 	bool ret;
 
-	ret = io_uring_cancel_files(ctx, files);
+	ret = io_uring_cancel_files(ctx, task, files);
 	if (!files) {
 		enum io_wq_cancel cret;
 
@@ -8662,11 +8653,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 		io_sq_thread_park(ctx->sq_data);
 	}
 
-	if (files)
-		io_cancel_defer_files(ctx, NULL, files);
-	else
-		io_cancel_defer_files(ctx, task, NULL);
-
+	io_cancel_defer_files(ctx, task, files);
 	io_cqring_overflow_flush(ctx, true, task, files);
 
 	while (__io_uring_cancel_task_requests(ctx, task, files)) {
-- 
2.27.0



