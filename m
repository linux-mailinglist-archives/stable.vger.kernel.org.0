Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D546E4ECA61
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 19:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349200AbiC3RQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 13:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349198AbiC3RQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 13:16:10 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52B32FE47
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 10:14:24 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id e22so25528008ioe.11
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 10:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=scm33YqbtA3/N3tWQJbeiomOawz52heJqvALECw8CrU=;
        b=p4lH5jeWHE98Rr3ilv3SS5Zr6XylcTF7HfPMIZenM8bEn55z5i3GXiJXo206YhU+Fh
         ijUwpMm7bOY+tYSmpPJj+VqJKzxSuvCLtMm4Rm4iNaOjXd5U6kRhizzDFu0w4PO0qGmA
         nSmFQ7HN2QW12qIRKD6iJA3W+FMVZL+Ua0Xb2EoK5jgiN9XR840uwdZe/XRF2et0o4gK
         N5tv3grXDfPyKwMWDY4bDEIij/JX9ixGn1bFa0gwpGWq7rqHe2WHZaZSLt599PsfjhbS
         wocToVaHGEWtMQpSdqyuZu4GlpAMeMAEk5/uzfaeWaaqI5dIhWhlluY5FZztx+70LfZ0
         3wQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=scm33YqbtA3/N3tWQJbeiomOawz52heJqvALECw8CrU=;
        b=vjsA/PI37ejGi82Oa5Qmq6kTNOlqM2RjJ5DfPl/5rAEwmlXv6JUujeCbLPRPnHGtqL
         aMnuymVdQ4YLXyJTC/QnMpq2HTPu7aL3domGPCIh62RBjuKAk+RGrKT2iRGq5goUNODo
         bPwKgcvSbldO1YA7p1xmDrhcOeywfPdgmQHQPfV5ASo59hRy91A4R0aZNis8g5YtV6OV
         19bWsDh6fRTg8X5sSgYLY5auMqD2kei2NYDUZ57g7Of2nJVY7yqlbPFyh/uc3X4ufQ0n
         zDBJkDl0gU60GWUWRJBL5IasnwTfP968OAVHBJ/iKWIrsyEtOnz7yrU2qviGGECC/eR+
         SvLQ==
X-Gm-Message-State: AOAM530EC3/9tCyDoUKvx36A8wq5MEUPQsCVYlQXh7vNusZ5x6mIv5uu
        UtuYOqh8kFBIfUWTkJSU4r5csg4GFzZnq7mJ
X-Google-Smtp-Source: ABdhPJwdX87yuLrRvkGrDzTNyhGKhSHZE3Wn2uM30d1UwT+Rg0ypCcsF7BpaBRIG1C6ClQL2AMF3nA==
X-Received: by 2002:a5e:c012:0:b0:649:ab74:a3c6 with SMTP id u18-20020a5ec012000000b00649ab74a3c6mr12401168iol.182.1648660463980;
        Wed, 30 Mar 2022 10:14:23 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b24-20020a5d8d98000000b006409ad493fbsm11588920ioj.21.2022.03.30.10.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 10:14:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 4/5] io_uring: move read/write file prep state into actual opcode handler
Date:   Wed, 30 Mar 2022 11:14:15 -0600
Message-Id: <20220330171416.152538-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220330171416.152538-1-axboe@kernel.dk>
References: <20220330171416.152538-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In preparation for not necessarily having a file assigned at prep time,
defer any initialization associated with the file to when the opcode
handler is run.

Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 102 ++++++++++++++++++++++++++------------------------
 1 file changed, 53 insertions(+), 49 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 67244ea0af48..84433dc57914 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -593,7 +593,8 @@ struct io_rw {
 	/* NOTE: kiocb has the file as the first member, so don't do it here */
 	struct kiocb			kiocb;
 	u64				addr;
-	u64				len;
+	u32				len;
+	u32				flags;
 };
 
 struct io_connect {
@@ -3177,42 +3178,11 @@ static inline bool io_file_supports_nowait(struct io_kiocb *req)
 
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
@@ -3228,6 +3198,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	req->imu = NULL;
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
+	req->rw.flags = READ_ONCE(sqe->rw_flags);
 	req->buf_index = READ_ONCE(sqe->buf_index);
 	return 0;
 }
@@ -3731,13 +3702,6 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
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
@@ -3825,6 +3789,49 @@ static bool need_read_all(struct io_kiocb *req)
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
@@ -3860,6 +3867,9 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		iov_iter_restore(&s->iter, &s->iter_state);
 		iovec = NULL;
 	}
+	ret = io_rw_init_file(req, FMODE_READ);
+	if (unlikely(ret))
+		return ret;
 	req->result = iov_iter_count(&s->iter);
 
 	if (force_nonblock) {
@@ -3963,14 +3973,6 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -3991,6 +3993,9 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		iov_iter_restore(&s->iter, &s->iter_state);
 		iovec = NULL;
 	}
+	ret = io_rw_init_file(req, FMODE_WRITE);
+	if (unlikely(ret))
+		return ret;
 	req->result = iov_iter_count(&s->iter);
 
 	if (force_nonblock) {
@@ -6973,11 +6978,10 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
-- 
2.35.1

