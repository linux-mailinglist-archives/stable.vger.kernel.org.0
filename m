Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2419A4FD64D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377572AbiDLHue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359403AbiDLHnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:43:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61F32CE07;
        Tue, 12 Apr 2022 00:22:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 921BFB81B60;
        Tue, 12 Apr 2022 07:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD16C385A1;
        Tue, 12 Apr 2022 07:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748155;
        bh=WEz9tVLQClCMzp5STv/SjoKUKS0mGeZVPlc6NoCTe5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qj4MeQVnXL4nw4ruwm96aWe0+NrsuNCcc/U6xfTbkr7Gr31DZgiQaMQH+MoT7d0r8
         eIyk3S0X8jFDjBgsaPzc1BVczM5zOJexPZLBRhzEKdHXa2IE5pAzJqHZPkS/+7z0Te
         +BgVK/UbBkwerppV/0tJzzVeUaHBoC4eoiFmcPZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 340/343] io_uring: move read/write file prep state into actual opcode handler
Date:   Tue, 12 Apr 2022 08:32:38 +0200
Message-Id: <20220412063001.129759703@linuxfoundation.org>
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

commit 584b0180f0f4d67d7145950fe68c625f06c88b10 upstream.

In preparation for not necessarily having a file assigned at prep time,
defer any initialization associated with the file to when the opcode
handler is run.

Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |  119 ++++++++++++++++++++++++++++++----------------------------
 1 file changed, 62 insertions(+), 57 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -560,7 +560,8 @@ struct io_rw {
 	/* NOTE: kiocb has the file as the first member, so don't do it here */
 	struct kiocb			kiocb;
 	u64				addr;
-	u64				len;
+	u32				len;
+	u32				flags;
 };
 
 struct io_connect {
@@ -2984,50 +2985,11 @@ static inline bool io_file_supports_nowa
 
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
-	if (kiocb->ki_pos == -1) {
-		if (!(file->f_mode & FMODE_STREAM)) {
-			req->flags |= REQ_F_CUR_POS;
-			kiocb->ki_pos = file->f_pos;
-		} else {
-			kiocb->ki_pos = 0;
-		}
-	}
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
@@ -3043,6 +3005,7 @@ static int io_prep_rw(struct io_kiocb *r
 	req->imu = NULL;
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
+	req->rw.flags = READ_ONCE(sqe->rw_flags);
 	req->buf_index = READ_ONCE(sqe->buf_index);
 	return 0;
 }
@@ -3523,13 +3486,6 @@ static inline int io_rw_prep_async(struc
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
@@ -3617,6 +3573,58 @@ static bool need_read_all(struct io_kioc
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
+	if (kiocb->ki_pos == -1) {
+		if (!(file->f_mode & FMODE_STREAM)) {
+			req->flags |= REQ_F_CUR_POS;
+			kiocb->ki_pos = file->f_pos;
+		} else {
+			kiocb->ki_pos = 0;
+		}
+	}
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
@@ -3641,6 +3649,9 @@ static int io_read(struct io_kiocb *req,
 		iov_iter_restore(&s->iter, &s->iter_state);
 		iovec = NULL;
 	}
+	ret = io_rw_init_file(req, FMODE_READ);
+	if (unlikely(ret))
+		return ret;
 	req->result = iov_iter_count(&s->iter);
 
 	if (force_nonblock) {
@@ -3739,14 +3750,6 @@ out_free:
 	return 0;
 }
 
-static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
-		return -EBADF;
-	req->rw.kiocb.ki_hint = ki_hint_validate(file_write_hint(req->file));
-	return io_prep_rw(req, sqe);
-}
-
 static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw_state __s, *s = &__s;
@@ -3766,6 +3769,9 @@ static int io_write(struct io_kiocb *req
 		iov_iter_restore(&s->iter, &s->iter_state);
 		iovec = NULL;
 	}
+	ret = io_rw_init_file(req, FMODE_WRITE);
+	if (unlikely(ret))
+		return ret;
 	req->result = iov_iter_count(&s->iter);
 
 	if (force_nonblock) {
@@ -6501,11 +6507,10 @@ static int io_req_prep(struct io_kiocb *
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


