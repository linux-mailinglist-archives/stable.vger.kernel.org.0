Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF384FB52E
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 09:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242056AbiDKHrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 03:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243330AbiDKHq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 03:46:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B2BB7C2
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 00:44:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00DC0B810A9
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 07:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408EBC385A3;
        Mon, 11 Apr 2022 07:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649663080;
        bh=XxP8FRyh9LO8uHO8gmkZ96AGnQLqKBQ4MIK/V1Rl1zQ=;
        h=Subject:To:Cc:From:Date:From;
        b=P80knGYpV2wpNO/tOWXB0yfLL9PJf/PrlSy5dE5voBbPJ8xC15uJVFtZF5j2riSjB
         qguDAzY1NdDbvpoLstvmiHMs01hjyfvekTlv3GDlPSb9svTgTpsqLKgsmSU76VEK2I
         3UejHjMr/9z4/+rjJn4VirpU0FOlTn41lv0dMqlg=
Subject: FAILED: patch "[PATCH] io_uring: move read/write file prep state into actual opcode" failed to apply to 5.15-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 09:44:27 +0200
Message-ID: <164966306719476@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 584b0180f0f4d67d7145950fe68c625f06c88b10 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 29 Mar 2022 10:48:05 -0600
Subject: [PATCH] io_uring: move read/write file prep state into actual opcode
 handler

In preparation for not necessarily having a file assigned at prep time,
defer any initialization associated with the file to when the opcode
handler is run.

Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0152ef49cf46..969f65de9972 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -592,7 +592,8 @@ struct io_rw {
 	/* NOTE: kiocb has the file as the first member, so don't do it here */
 	struct kiocb			kiocb;
 	u64				addr;
-	u64				len;
+	u32				len;
+	u32				flags;
 };
 
 struct io_connect {
@@ -3178,42 +3179,11 @@ static inline bool io_file_supports_nowait(struct io_kiocb *req)
 
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	struct kiocb *kiocb = &req->rw.kiocb;
-	struct file *file = req->file;
 	unsigned ioprio;
 	int ret;
 
-	if (!io_req_ffs_set(req))
-		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
-
 	kiocb->ki_pos = READ_ONCE(sqe->off);
-	kiocb->ki_flags = iocb_flags(file);
-	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
-	if (unlikely(ret))
-		return ret;
-
-	/*
-	 * If the file is marked O_NONBLOCK, still allow retry for it if it
-	 * supports async. Otherwise it's impossible to use O_NONBLOCK files
-	 * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
-	 */
-	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
-	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req)))
-		req->flags |= REQ_F_NOWAIT;
-
-	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		if (!(kiocb->ki_flags & IOCB_DIRECT) || !file->f_op->iopoll)
-			return -EOPNOTSUPP;
-
-		kiocb->ki_flags |= IOCB_HIPRI | IOCB_ALLOC_CACHE;
-		kiocb->ki_complete = io_complete_rw_iopoll;
-		req->iopoll_completed = 0;
-	} else {
-		if (kiocb->ki_flags & IOCB_HIPRI)
-			return -EINVAL;
-		kiocb->ki_complete = io_complete_rw;
-	}
 
 	ioprio = READ_ONCE(sqe->ioprio);
 	if (ioprio) {
@@ -3229,6 +3199,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	req->imu = NULL;
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
+	req->rw.flags = READ_ONCE(sqe->rw_flags);
 	req->buf_index = READ_ONCE(sqe->buf_index);
 	return 0;
 }
@@ -3732,13 +3703,6 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 	return 0;
 }
 
-static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	if (unlikely(!(req->file->f_mode & FMODE_READ)))
-		return -EBADF;
-	return io_prep_rw(req, sqe);
-}
-
 /*
  * This is our waitqueue callback handler, registered through __folio_lock_async()
  * when we initially tried to do the IO with the iocb armed our waitqueue.
@@ -3826,6 +3790,49 @@ static bool need_read_all(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
 }
 
+static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
+{
+	struct kiocb *kiocb = &req->rw.kiocb;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct file *file = req->file;
+	int ret;
+
+	if (unlikely(!file || !(file->f_mode & mode)))
+		return -EBADF;
+
+	if (!io_req_ffs_set(req))
+		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
+
+	kiocb->ki_flags = iocb_flags(file);
+	ret = kiocb_set_rw_flags(kiocb, req->rw.flags);
+	if (unlikely(ret))
+		return ret;
+
+	/*
+	 * If the file is marked O_NONBLOCK, still allow retry for it if it
+	 * supports async. Otherwise it's impossible to use O_NONBLOCK files
+	 * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
+	 */
+	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
+	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req)))
+		req->flags |= REQ_F_NOWAIT;
+
+	if (ctx->flags & IORING_SETUP_IOPOLL) {
+		if (!(kiocb->ki_flags & IOCB_DIRECT) || !file->f_op->iopoll)
+			return -EOPNOTSUPP;
+
+		kiocb->ki_flags |= IOCB_HIPRI | IOCB_ALLOC_CACHE;
+		kiocb->ki_complete = io_complete_rw_iopoll;
+		req->iopoll_completed = 0;
+	} else {
+		if (kiocb->ki_flags & IOCB_HIPRI)
+			return -EINVAL;
+		kiocb->ki_complete = io_complete_rw;
+	}
+
+	return 0;
+}
+
 static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw_state __s, *s = &__s;
@@ -3861,6 +3868,9 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		iov_iter_restore(&s->iter, &s->iter_state);
 		iovec = NULL;
 	}
+	ret = io_rw_init_file(req, FMODE_READ);
+	if (unlikely(ret))
+		return ret;
 	req->result = iov_iter_count(&s->iter);
 
 	if (force_nonblock) {
@@ -3964,13 +3974,6 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
-		return -EBADF;
-	return io_prep_rw(req, sqe);
-}
-
 static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw_state __s, *s = &__s;
@@ -3991,6 +3994,9 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		iov_iter_restore(&s->iter, &s->iter_state);
 		iovec = NULL;
 	}
+	ret = io_rw_init_file(req, FMODE_WRITE);
+	if (unlikely(ret))
+		return ret;
 	req->result = iov_iter_count(&s->iter);
 
 	if (force_nonblock) {
@@ -6987,11 +6993,10 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 	case IORING_OP_READ:
-		return io_read_prep(req, sqe);
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITE:
-		return io_write_prep(req, sqe);
+		return io_prep_rw(req, sqe);
 	case IORING_OP_POLL_ADD:
 		return io_poll_add_prep(req, sqe);
 	case IORING_OP_POLL_REMOVE:

