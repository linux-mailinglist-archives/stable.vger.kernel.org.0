Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D635519AF
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243122AbiFTMyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243037AbiFTMyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:54:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E0713D05;
        Mon, 20 Jun 2022 05:54:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1D95B811A5;
        Mon, 20 Jun 2022 12:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2971C3411B;
        Mon, 20 Jun 2022 12:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729640;
        bh=ZWtcHloOu6ofyAaoiLZjNBR4ku6v8PDGWroEVzoiiTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zb7WO5yXsiSeMrApoNZPB6xFhbezsU+hc+FAX13gtTI5+oFK71Gv5g6oKMTfYWcUG
         ePaCeCgs4jG6R3sj22v319Z5LR7WQ1clKQeR9ud8dFTUWiw09WBe1Din0axIvZ7o1X
         MLoOMGX0a+kifeuVXhNDNVWxKciS6tCMfhnb0igs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.18 004/141] io_uring: reinstate the inflight tracking
Date:   Mon, 20 Jun 2022 14:49:02 +0200
Message-Id: <20220620124729.645732782@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jens Axboe <axboe@kernel.dk>

commit 9cae36a094e7e9d6e5fe8b6dcd4642138b3eb0c7 upstream.

After some debugging, it was realized that we really do still need the
old inflight tracking for any file type that has io_uring_fops assigned.
If we don't, then trivial circular references will mean that we never get
the ctx cleaned up and hence it'll leak.

Just bring back the inflight tracking, which then also means we can
eliminate the conditional dropping of the file when task_work is queued.

Fixes: d5361233e9ab ("io_uring: drop the old style inflight file tracking")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   82 +++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 56 insertions(+), 26 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -111,7 +111,8 @@
 			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
-				REQ_F_POLLED | REQ_F_CREDS | REQ_F_ASYNC_DATA)
+				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
+				REQ_F_ASYNC_DATA)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
@@ -493,6 +494,7 @@ struct io_uring_task {
 	const struct io_ring_ctx *last;
 	struct io_wq		*io_wq;
 	struct percpu_counter	inflight;
+	atomic_t		inflight_tracked;
 	atomic_t		in_idle;
 
 	spinlock_t		task_lock;
@@ -1186,8 +1188,6 @@ static void io_clean_op(struct io_kiocb
 static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 					     unsigned issue_flags);
 static inline struct file *io_file_get_normal(struct io_kiocb *req, int fd);
-static void io_drop_inflight_file(struct io_kiocb *req);
-static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags);
 static void __io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
@@ -1435,9 +1435,29 @@ static bool io_match_task(struct io_kioc
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
@@ -1447,9 +1467,24 @@ static bool io_match_task(struct io_kioc
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
@@ -1608,6 +1643,14 @@ static inline bool io_req_ffs_set(struct
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
@@ -2516,8 +2559,6 @@ static void io_req_task_work_add(struct
 
 	WARN_ON_ONCE(!tctx);
 
-	io_drop_inflight_file(req);
-
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	if (priority)
 		wq_list_add_tail(&req->io_task_work.node, &tctx->prior_task_list);
@@ -5869,10 +5910,6 @@ static int io_poll_check_events(struct i
 
 		if (!req->result) {
 			struct poll_table_struct pt = { ._key = req->apoll_events };
-			unsigned flags = locked ? 0 : IO_URING_F_UNLOCKED;
-
-			if (unlikely(!io_assign_file(req, flags)))
-				return -EBADF;
 			req->result = vfs_poll(req->file, &pt) & req->apoll_events;
 		}
 
@@ -7097,6 +7134,11 @@ static void io_clean_op(struct io_kiocb
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
@@ -7393,19 +7435,6 @@ out:
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
@@ -7414,7 +7443,7 @@ static struct file *io_file_get_normal(s
 
 	/* we don't allow fixed io_uring files */
 	if (file && file->f_op == &io_uring_fops)
-		req->flags |= REQ_F_INFLIGHT;
+		io_req_track_inflight(req);
 	return file;
 }
 
@@ -9211,6 +9240,7 @@ static __cold int io_uring_alloc_task_co
 	xa_init(&tctx->xa);
 	init_waitqueue_head(&tctx->wait);
 	atomic_set(&tctx->in_idle, 0);
+	atomic_set(&tctx->inflight_tracked, 0);
 	task->io_uring = tctx;
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
@@ -10402,7 +10432,7 @@ static __cold void io_uring_clean_tctx(s
 static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 {
 	if (tracked)
-		return 0;
+		return atomic_read(&tctx->inflight_tracked);
 	return percpu_counter_sum(&tctx->inflight);
 }
 


