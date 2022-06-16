Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7D854E180
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 15:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiFPNKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 09:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376830AbiFPNJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 09:09:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409DE19C3B
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 06:09:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D886C61C14
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 13:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF51CC34114;
        Thu, 16 Jun 2022 13:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655384997;
        bh=bFWv/ahGXm2ceixGze2HHWHnV2XbMreovPBlB315/84=;
        h=Subject:To:Cc:From:Date:From;
        b=dvVDw9DBqrKi/T9dsPRu5YC9r0QAMuiPwgRSwDli015DeqySupWYJmisnDImMhNpm
         IY+dgMp9/8KgURsdIqefnC2k7h7P3Q+02oATlk3mmPeXxpvdNsXPtvVrISkfkPXAae
         oX0QwiqMLb0RZ9rJMKc9JThQMcq4w+4zb5aTCEtU=
Subject: FAILED: patch "[PATCH] io_uring: reinstate the inflight tracking" failed to apply to 5.18-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Jun 2022 15:09:54 +0200
Message-ID: <1655384994105244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9cae36a094e7e9d6e5fe8b6dcd4642138b3eb0c7 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Wed, 1 Jun 2022 23:57:02 -0600
Subject: [PATCH] io_uring: reinstate the inflight tracking

After some debugging, it was realized that we really do still need the
old inflight tracking for any file type that has io_uring_fops assigned.
If we don't, then trivial circular references will mean that we never get
the ctx cleaned up and hence it'll leak.

Just bring back the inflight tracking, which then also means we can
eliminate the conditional dropping of the file when task_work is queued.

Fixes: d5361233e9ab ("io_uring: drop the old style inflight file tracking")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 495353437228..2a9b9a24fc22 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -112,7 +112,8 @@
 			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
-				REQ_F_POLLED | REQ_F_CREDS | REQ_F_ASYNC_DATA)
+				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
+				REQ_F_ASYNC_DATA)
 
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
 				 IO_REQ_CLEAN_FLAGS)
@@ -540,6 +541,7 @@ struct io_uring_task {
 	const struct io_ring_ctx *last;
 	struct io_wq		*io_wq;
 	struct percpu_counter	inflight;
+	atomic_t		inflight_tracked;
 	atomic_t		in_idle;
 
 	spinlock_t		task_lock;
@@ -1356,8 +1358,6 @@ static void io_clean_op(struct io_kiocb *req);
 static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 					     unsigned issue_flags);
 static struct file *io_file_get_normal(struct io_kiocb *req, int fd);
-static void io_drop_inflight_file(struct io_kiocb *req);
-static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags);
 static void io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
@@ -1760,9 +1760,29 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 			  bool cancel_all)
 	__must_hold(&req->ctx->timeout_lock)
 {
+	struct io_kiocb *req;
+
 	if (task && head->task != task)
 		return false;
-	return cancel_all;
+	if (cancel_all)
+		return true;
+
+	io_for_each_link(req, head) {
+		if (req->flags & REQ_F_INFLIGHT)
+			return true;
+	}
+	return false;
+}
+
+static bool io_match_linked(struct io_kiocb *head)
+{
+	struct io_kiocb *req;
+
+	io_for_each_link(req, head) {
+		if (req->flags & REQ_F_INFLIGHT)
+			return true;
+	}
+	return false;
 }
 
 /*
@@ -1772,9 +1792,24 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 static bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			       bool cancel_all)
 {
+	bool matched;
+
 	if (task && head->task != task)
 		return false;
-	return cancel_all;
+	if (cancel_all)
+		return true;
+
+	if (head->flags & REQ_F_LINK_TIMEOUT) {
+		struct io_ring_ctx *ctx = head->ctx;
+
+		/* protect against races with linked timeouts */
+		spin_lock_irq(&ctx->timeout_lock);
+		matched = io_match_linked(head);
+		spin_unlock_irq(&ctx->timeout_lock);
+	} else {
+		matched = io_match_linked(head);
+	}
+	return matched;
 }
 
 static inline bool req_has_async_data(struct io_kiocb *req)
@@ -1930,6 +1965,14 @@ static inline bool io_req_ffs_set(struct io_kiocb *req)
 	return req->flags & REQ_F_FIXED_FILE;
 }
 
+static inline void io_req_track_inflight(struct io_kiocb *req)
+{
+	if (!(req->flags & REQ_F_INFLIGHT)) {
+		req->flags |= REQ_F_INFLIGHT;
+		atomic_inc(&current->io_uring->inflight_tracked);
+	}
+}
+
 static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
 {
 	if (WARN_ON_ONCE(!req->link))
@@ -2991,8 +3034,6 @@ static void __io_req_task_work_add(struct io_kiocb *req,
 	unsigned long flags;
 	bool running;
 
-	io_drop_inflight_file(req);
-
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	wq_list_add_tail(&req->io_task_work.node, list);
 	running = tctx->task_running;
@@ -6914,10 +6955,6 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 
 		if (!req->cqe.res) {
 			struct poll_table_struct pt = { ._key = req->apoll_events };
-			unsigned flags = locked ? 0 : IO_URING_F_UNLOCKED;
-
-			if (unlikely(!io_assign_file(req, flags)))
-				return -EBADF;
 			req->cqe.res = vfs_poll(req->file, &pt) & req->apoll_events;
 		}
 
@@ -8325,6 +8362,11 @@ static void io_clean_op(struct io_kiocb *req)
 		kfree(req->apoll);
 		req->apoll = NULL;
 	}
+	if (req->flags & REQ_F_INFLIGHT) {
+		struct io_uring_task *tctx = req->task->io_uring;
+
+		atomic_dec(&tctx->inflight_tracked);
+	}
 	if (req->flags & REQ_F_CREDS)
 		put_cred(req->creds);
 	if (req->flags & REQ_F_ASYNC_DATA) {
@@ -8631,19 +8673,6 @@ static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 	return file;
 }
 
-/*
- * Drop the file for requeue operations. Only used of req->file is the
- * io_uring descriptor itself.
- */
-static void io_drop_inflight_file(struct io_kiocb *req)
-{
-	if (unlikely(req->flags & REQ_F_INFLIGHT)) {
-		fput(req->file);
-		req->file = NULL;
-		req->flags &= ~REQ_F_INFLIGHT;
-	}
-}
-
 static struct file *io_file_get_normal(struct io_kiocb *req, int fd)
 {
 	struct file *file = fget(fd);
@@ -8652,7 +8681,7 @@ static struct file *io_file_get_normal(struct io_kiocb *req, int fd)
 
 	/* we don't allow fixed io_uring files */
 	if (file && file->f_op == &io_uring_fops)
-		req->flags |= REQ_F_INFLIGHT;
+		io_req_track_inflight(req);
 	return file;
 }
 
@@ -10416,6 +10445,7 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
 	xa_init(&tctx->xa);
 	init_waitqueue_head(&tctx->wait);
 	atomic_set(&tctx->in_idle, 0);
+	atomic_set(&tctx->inflight_tracked, 0);
 	task->io_uring = tctx;
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
@@ -11647,7 +11677,7 @@ static __cold void io_uring_clean_tctx(struct io_uring_task *tctx)
 static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 {
 	if (tracked)
-		return 0;
+		return atomic_read(&tctx->inflight_tracked);
 	return percpu_counter_sum(&tctx->inflight);
 }
 

