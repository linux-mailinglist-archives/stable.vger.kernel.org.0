Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2964FD8BD
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377567AbiDLHuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359408AbiDLHnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:43:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A8B2CE0F;
        Tue, 12 Apr 2022 00:22:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1201B81B33;
        Tue, 12 Apr 2022 07:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C65C385A1;
        Tue, 12 Apr 2022 07:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748166;
        bh=/ugomh2UJ0kcIyTrlE75uZzcMyiXZtPHR1TsJtdHc30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rngQ6hL9SrzdfY3jkjg3qgME/T1ETsy1Dw5AB9xq5TkFqcEZnva07jWnarKrPRKhm
         GMynoc2DMzXHbXEOaYBG8D+Aj/iU6YfKp5GdUApk1kRkONm2w9dcbruRHhwhya/wCc
         6NsxksT/g2JB63/8OvmSY9C64OOiqiH/mui3r6H0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c4b9303500a21750b250@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 343/343] io_uring: drop the old style inflight file tracking
Date:   Tue, 12 Apr 2022 08:32:41 +0200
Message-Id: <20220412063001.214326019@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit d5361233e9ab920e135819f73dd8466355f1fddd upstream.

io_uring tracks requests that are referencing an io_uring descriptor to
be able to cancel without worrying about loops in the references. Since
we now assign the file at execution time, the easier approach is to drop
a potentially problematic reference before we punt the request. This
eliminates the need to special case these types of files beyond just
marking them as such, and simplifies cancelation quite a bit.

This also fixes a recent issue where an async punted tee operation would
with the io_uring descriptor as the output file would crash when
attempting to get a reference to the file from the io-wq worker. We
could have worked around that, but this is the much cleaner fix.

Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")
Reported-by: syzbot+c4b9303500a21750b250@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   85 ++++++++++++++++++----------------------------------------
 1 file changed, 27 insertions(+), 58 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -112,8 +112,7 @@
 			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
-				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
-				REQ_F_ASYNC_DATA)
+				REQ_F_POLLED | REQ_F_CREDS | REQ_F_ASYNC_DATA)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
@@ -469,7 +468,6 @@ struct io_uring_task {
 	const struct io_ring_ctx *last;
 	struct io_wq		*io_wq;
 	struct percpu_counter	inflight;
-	atomic_t		inflight_tracked;
 	atomic_t		in_idle;
 
 	spinlock_t		task_lock;
@@ -1131,6 +1129,8 @@ static void io_clean_op(struct io_kiocb
 static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 					     unsigned issue_flags);
 static inline struct file *io_file_get_normal(struct io_kiocb *req, int fd);
+static void io_drop_inflight_file(struct io_kiocb *req);
+static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags);
 static void __io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
@@ -1312,29 +1312,9 @@ static bool io_match_task(struct io_kioc
 			  bool cancel_all)
 	__must_hold(&req->ctx->timeout_lock)
 {
-	struct io_kiocb *req;
-
 	if (task && head->task != task)
 		return false;
-	if (cancel_all)
-		return true;
-
-	io_for_each_link(req, head) {
-		if (req->flags & REQ_F_INFLIGHT)
-			return true;
-	}
-	return false;
-}
-
-static bool io_match_linked(struct io_kiocb *head)
-{
-	struct io_kiocb *req;
-
-	io_for_each_link(req, head) {
-		if (req->flags & REQ_F_INFLIGHT)
-			return true;
-	}
-	return false;
+	return cancel_all;
 }
 
 /*
@@ -1344,24 +1324,9 @@ static bool io_match_linked(struct io_ki
 static bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			       bool cancel_all)
 {
-	bool matched;
-
 	if (task && head->task != task)
 		return false;
-	if (cancel_all)
-		return true;
-
-	if (head->flags & REQ_F_LINK_TIMEOUT) {
-		struct io_ring_ctx *ctx = head->ctx;
-
-		/* protect against races with linked timeouts */
-		spin_lock_irq(&ctx->timeout_lock);
-		matched = io_match_linked(head);
-		spin_unlock_irq(&ctx->timeout_lock);
-	} else {
-		matched = io_match_linked(head);
-	}
-	return matched;
+	return cancel_all;
 }
 
 static inline bool req_has_async_data(struct io_kiocb *req)
@@ -1509,14 +1474,6 @@ static inline bool io_req_ffs_set(struct
 	return req->flags & REQ_F_FIXED_FILE;
 }
 
-static inline void io_req_track_inflight(struct io_kiocb *req)
-{
-	if (!(req->flags & REQ_F_INFLIGHT)) {
-		req->flags |= REQ_F_INFLIGHT;
-		atomic_inc(&current->io_uring->inflight_tracked);
-	}
-}
-
 static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
 {
 	if (WARN_ON_ONCE(!req->link))
@@ -2380,6 +2337,8 @@ static void io_req_task_work_add(struct
 
 	WARN_ON_ONCE(!tctx);
 
+	io_drop_inflight_file(req);
+
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	if (priority)
 		wq_list_add_tail(&req->io_task_work.node, &tctx->prior_task_list);
@@ -5548,7 +5507,10 @@ static int io_poll_check_events(struct i
 		if (!req->result) {
 			struct poll_table_struct pt = { ._key = poll->events };
 
-			req->result = vfs_poll(req->file, &pt) & poll->events;
+			if (unlikely(!io_assign_file(req, IO_URING_F_UNLOCKED)))
+				req->result = -EBADF;
+			else
+				req->result = vfs_poll(req->file, &pt) & poll->events;
 		}
 
 		/* multishot, just fill an CQE and proceed */
@@ -6731,11 +6693,6 @@ static void io_clean_op(struct io_kiocb
 		kfree(req->apoll);
 		req->apoll = NULL;
 	}
-	if (req->flags & REQ_F_INFLIGHT) {
-		struct io_uring_task *tctx = req->task->io_uring;
-
-		atomic_dec(&tctx->inflight_tracked);
-	}
 	if (req->flags & REQ_F_CREDS)
 		put_cred(req->creds);
 	if (req->flags & REQ_F_ASYNC_DATA) {
@@ -7024,6 +6981,19 @@ out:
 	return file;
 }
 
+/*
+ * Drop the file for requeue operations. Only used of req->file is the
+ * io_uring descriptor itself.
+ */
+static void io_drop_inflight_file(struct io_kiocb *req)
+{
+	if (unlikely(req->flags & REQ_F_INFLIGHT)) {
+		fput(req->file);
+		req->file = NULL;
+		req->flags &= ~REQ_F_INFLIGHT;
+	}
+}
+
 static struct file *io_file_get_normal(struct io_kiocb *req, int fd)
 {
 	struct file *file = fget(fd);
@@ -7031,8 +7001,8 @@ static struct file *io_file_get_normal(s
 	trace_io_uring_file_get(req->ctx, fd);
 
 	/* we don't allow fixed io_uring files */
-	if (file && unlikely(file->f_op == &io_uring_fops))
-		io_req_track_inflight(req);
+	if (file && file->f_op == &io_uring_fops)
+		req->flags |= REQ_F_INFLIGHT;
 	return file;
 }
 
@@ -8804,7 +8774,6 @@ static __cold int io_uring_alloc_task_co
 	xa_init(&tctx->xa);
 	init_waitqueue_head(&tctx->wait);
 	atomic_set(&tctx->in_idle, 0);
-	atomic_set(&tctx->inflight_tracked, 0);
 	task->io_uring = tctx;
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
@@ -9942,7 +9911,7 @@ static __cold void io_uring_clean_tctx(s
 static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 {
 	if (tracked)
-		return atomic_read(&tctx->inflight_tracked);
+		return 0;
 	return percpu_counter_sum(&tctx->inflight);
 }
 


