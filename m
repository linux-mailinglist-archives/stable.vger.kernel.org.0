Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF9A4F207C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 02:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbiDEAlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 20:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiDEAls (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 20:41:48 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294EE1FC9D1
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 17:25:55 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-e1dcc0a327so8158787fac.1
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 17:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EoASACADHZW9hyAkhpjT8nEm+Pqkb+q7uqFEp3Yyy4g=;
        b=wgvppesePXFqcNrIe0MZC1hqaBo8qFbli34GNIExbJ6bl+DJzz5OuPJ+3/Fw4RSPpg
         iYrmtuipvHXxCVC/VgTZ7Y/qGrSeWj7T25gwHHQ724M26EQrZOwmtuQ60lLMf7Z59Wbf
         prfeB9euPTKw5bWBCCZs7rheabu9XuKcNMF0SccaJr20UDeODSA7vtsnldSFrUGyRk9o
         ivExC3KIN0IVqyowzKzIAx5T6mrjvChj0DBME2H974bkjhF6M0vMtheByPHPHvBLlmMC
         QCg7WZ4hjMSchsxE7hLrAejGj5WBrx5x1eR5FjigTT4AXD8o6ASf0C6pqrBUjjHC4swJ
         2k2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EoASACADHZW9hyAkhpjT8nEm+Pqkb+q7uqFEp3Yyy4g=;
        b=idbBx83pQzqOOxC+zi13A53DIMyaZFEEcWkjWqq6xCc765I5yelJLqo72k+URFmTjG
         bX4O2/IvizuLNRa10eeGsqvSUUhy7CIp5cBdnuAuAa36s7xjHNjac8NNExFeD18adwJL
         bi9p/saHRt4uGQxtCePfmGKNVowpiIz0d94NXFG4AQkRWtA3gTQlGXmP12E34B6MDeeV
         G8R9Hc0LI5w1sbn2ciBjKng03LE6t7K8lTIIFHdpWojkMoFenbVN61EcgB+hDQWG/RBo
         +C1pUZAYNcLIjOL0TdWR1WXauLFwqGcdNJti4qUbhTebhjzK0j1rzFWyMrk++xvjtMmB
         sjRg==
X-Gm-Message-State: AOAM531aaQTZ/ak5SvbTK35b8VVWv7RIYB6ZCupZKjytShdwYp+PNRNB
        w5zZi2vDgSiJnz2pqdzsW5bj5ADTmhHwOw==
X-Google-Smtp-Source: ABdhPJzToD9wRtFK/uXqTbqi/27R8M++xbxydWgcHSeLIQpDQV794EcehSfpKCxAHG1AyE2aljqrwg==
X-Received: by 2002:a17:90a:cf94:b0:1ca:9374:97fc with SMTP id i20-20020a17090acf9400b001ca937497fcmr910059pju.162.1649116597298;
        Mon, 04 Apr 2022 16:56:37 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i7-20020a628707000000b004fa6eb33b02sm13157977pfe.49.2022.04.04.16.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 16:56:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 3/6] io_uring: move read/write file prep state into actual opcode handler
Date:   Mon,  4 Apr 2022 17:56:23 -0600
Message-Id: <20220404235626.374753-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404235626.374753-1-axboe@kernel.dk>
References: <20220404235626.374753-1-axboe@kernel.dk>
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
 fs/io_uring.c | 101 ++++++++++++++++++++++++++------------------------
 1 file changed, 53 insertions(+), 48 deletions(-)

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
-- 
2.35.1

