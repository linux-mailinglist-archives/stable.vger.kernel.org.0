Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C6E4FD75C
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377563AbiDLHu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359404AbiDLHnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:43:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AA42CE0C;
        Tue, 12 Apr 2022 00:22:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 812FA6153F;
        Tue, 12 Apr 2022 07:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88393C385A1;
        Tue, 12 Apr 2022 07:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748160;
        bh=kdGn1ftJHGVxeTLH7mFW4Oz3PjRaZe085GNp5mTVpXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1pNPmALh01m8N7B/hfXWhYmxGCxDfadT8XhwNa+8DkiAEw7DkUocFumAgrl8C5fSJ
         0c3SNfd2o5X36nmo+vtDa+OAHtH/eZvBZO/SBpg9q0z0+IpVHM3lJao2tuaQePXX97
         GRQPCtT1Yw5+9V8b1AZJCgwCmXVM6hBu4AQmGpyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 341/343] io_uring: propagate issue_flags state down to file assignment
Date:   Tue, 12 Apr 2022 08:32:39 +0200
Message-Id: <20220412063001.158157154@linuxfoundation.org>
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

commit 5106dd6e74ab6c94daac1c357094f11e6934b36f upstream.

We'll need this in a future patch, when we could be assigning the file
after the prep stage. While at it, get rid of the io_file_get() helper,
it just makes the code harder to read.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   82 +++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 47 insertions(+), 35 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1128,8 +1128,9 @@ static int __io_register_rsrc_update(str
 				     struct io_uring_rsrc_update2 *up,
 				     unsigned nr_args);
 static void io_clean_op(struct io_kiocb *req);
-static struct file *io_file_get(struct io_ring_ctx *ctx,
-				struct io_kiocb *req, int fd, bool fixed);
+static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
+					     unsigned issue_flags);
+static inline struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 static void __io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
@@ -1258,13 +1259,20 @@ static void io_rsrc_refs_refill(struct i
 }
 
 static inline void io_req_set_rsrc_node(struct io_kiocb *req,
-					struct io_ring_ctx *ctx)
+					struct io_ring_ctx *ctx,
+					unsigned int issue_flags)
 {
 	if (!req->fixed_rsrc_refs) {
 		req->fixed_rsrc_refs = &ctx->rsrc_node->refs;
-		ctx->rsrc_cached_refs--;
-		if (unlikely(ctx->rsrc_cached_refs < 0))
-			io_rsrc_refs_refill(ctx);
+
+		if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+			lockdep_assert_held(&ctx->uring_lock);
+			ctx->rsrc_cached_refs--;
+			if (unlikely(ctx->rsrc_cached_refs < 0))
+				io_rsrc_refs_refill(ctx);
+		} else {
+			percpu_ref_get(req->fixed_rsrc_refs);
+		}
 	}
 }
 
@@ -3122,7 +3130,8 @@ static int __io_import_fixed(struct io_k
 	return 0;
 }
 
-static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
+static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter,
+			   unsigned int issue_flags)
 {
 	struct io_mapped_ubuf *imu = req->imu;
 	u16 index, buf_index = req->buf_index;
@@ -3132,7 +3141,7 @@ static int io_import_fixed(struct io_kio
 
 		if (unlikely(buf_index >= ctx->nr_user_bufs))
 			return -EFAULT;
-		io_req_set_rsrc_node(req, ctx);
+		io_req_set_rsrc_node(req, ctx, issue_flags);
 		index = array_index_nospec(buf_index, ctx->nr_user_bufs);
 		imu = READ_ONCE(ctx->user_bufs[index]);
 		req->imu = imu;
@@ -3288,7 +3297,7 @@ static struct iovec *__io_import_iovec(i
 	ssize_t ret;
 
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
-		ret = io_import_fixed(req, rw, iter);
+		ret = io_import_fixed(req, rw, iter, issue_flags);
 		if (ret)
 			return ERR_PTR(ret);
 		return NULL;
@@ -4167,8 +4176,10 @@ static int io_tee(struct io_kiocb *req,
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
-	in = io_file_get(req->ctx, req, sp->splice_fd_in,
-				  (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (sp->flags & SPLICE_F_FD_IN_FIXED)
+		in = io_file_get_fixed(req, sp->splice_fd_in, IO_URING_F_UNLOCKED);
+	else
+		in = io_file_get_normal(req, sp->splice_fd_in);
 	if (!in) {
 		ret = -EBADF;
 		goto done;
@@ -4207,8 +4218,10 @@ static int io_splice(struct io_kiocb *re
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
-	in = io_file_get(req->ctx, req, sp->splice_fd_in,
-				  (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (sp->flags & SPLICE_F_FD_IN_FIXED)
+		in = io_file_get_fixed(req, sp->splice_fd_in, IO_URING_F_UNLOCKED);
+	else
+		in = io_file_get_normal(req, sp->splice_fd_in);
 	if (!in) {
 		ret = -EBADF;
 		goto done;
@@ -5513,7 +5526,7 @@ static void io_poll_remove_entries(struc
  * either spurious wakeup or multishot CQE is served. 0 when it's done with
  * the request, then the mask is stored in req->result.
  */
-static int io_poll_check_events(struct io_kiocb *req)
+static int io_poll_check_events(struct io_kiocb *req, bool locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_poll_iocb *poll = io_poll_get_single(req);
@@ -5569,7 +5582,7 @@ static void io_poll_task_func(struct io_
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	ret = io_poll_check_events(req);
+	ret = io_poll_check_events(req, *locked);
 	if (ret > 0)
 		return;
 
@@ -5594,7 +5607,7 @@ static void io_apoll_task_func(struct io
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	ret = io_poll_check_events(req);
+	ret = io_poll_check_events(req, *locked);
 	if (ret > 0)
 		return;
 
@@ -6962,30 +6975,36 @@ static void io_fixed_file_set(struct io_
 	file_slot->file_ptr = file_ptr;
 }
 
-static inline struct file *io_file_get_fixed(struct io_ring_ctx *ctx,
-					     struct io_kiocb *req, int fd)
+static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
+					     unsigned int issue_flags)
 {
-	struct file *file;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct file *file = NULL;
 	unsigned long file_ptr;
 
+	if (issue_flags & IO_URING_F_UNLOCKED)
+		mutex_lock(&ctx->uring_lock);
+
 	if (unlikely((unsigned int)fd >= ctx->nr_user_files))
-		return NULL;
+		goto out;
 	fd = array_index_nospec(fd, ctx->nr_user_files);
 	file_ptr = io_fixed_file_slot(&ctx->file_table, fd)->file_ptr;
 	file = (struct file *) (file_ptr & FFS_MASK);
 	file_ptr &= ~FFS_MASK;
 	/* mask in overlapping REQ_F and FFS bits */
 	req->flags |= (file_ptr << REQ_F_SUPPORT_NOWAIT_BIT);
-	io_req_set_rsrc_node(req, ctx);
+	io_req_set_rsrc_node(req, ctx, 0);
+out:
+	if (issue_flags & IO_URING_F_UNLOCKED)
+		mutex_unlock(&ctx->uring_lock);
 	return file;
 }
 
-static struct file *io_file_get_normal(struct io_ring_ctx *ctx,
-				       struct io_kiocb *req, int fd)
+static struct file *io_file_get_normal(struct io_kiocb *req, int fd)
 {
 	struct file *file = fget(fd);
 
-	trace_io_uring_file_get(ctx, fd);
+	trace_io_uring_file_get(req->ctx, fd);
 
 	/* we don't allow fixed io_uring files */
 	if (file && unlikely(file->f_op == &io_uring_fops))
@@ -6993,15 +7012,6 @@ static struct file *io_file_get_normal(s
 	return file;
 }
 
-static inline struct file *io_file_get(struct io_ring_ctx *ctx,
-				       struct io_kiocb *req, int fd, bool fixed)
-{
-	if (fixed)
-		return io_file_get_fixed(ctx, req, fd);
-	else
-		return io_file_get_normal(ctx, req, fd);
-}
-
 static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
 {
 	struct io_kiocb *prev = req->timeout.prev;
@@ -7249,8 +7259,10 @@ static int io_init_req(struct io_ring_ct
 			blk_start_plug_nr_ios(&state->plug, state->submit_nr);
 		}
 
-		req->file = io_file_get(ctx, req, READ_ONCE(sqe->fd),
-					(sqe_flags & IOSQE_FIXED_FILE));
+		if (req->flags & REQ_F_FIXED_FILE)
+			req->file = io_file_get_fixed(req, READ_ONCE(sqe->fd), 0);
+		else
+			req->file = io_file_get_normal(req, READ_ONCE(sqe->fd));
 		if (unlikely(!req->file))
 			return -EBADF;
 	}


