Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB584ECA5C
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 19:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349195AbiC3RQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 13:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349193AbiC3RQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 13:16:08 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA6F13F8C
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 10:14:22 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id z7so25573525iom.1
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 10:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=29td3uHNqzr9Pa54h/jcLjQl505LyDtx3vEc2mRzNGU=;
        b=rYELJYq+QuQVoVo2V2xPwgW0v8RUNJYveNSOUZLrfZHc8nBIiTB139PNwfIJ4YLSnm
         WgGjjU66DXQ7QGrCf04uKf1Gnnnkd3/repxV+3Qse3iiQsVdo24iMfy4YVOwrlX8iMd+
         IceOb+gOmMCuZAY3LZQ9XZC6s9ZT56w8TIj2v7UKbx2R+0L/iR5XbHcIH5tlcmXaEnko
         9ytaSEFucoMfzdP5MgF+qju+B6Wr7fG5GXtRysLJFTCNZlqwvDX0/LzDOcqyWi+ueQVP
         liB8cwCGCQ+1eXhZb/MxyXty2PZRSl3oMEIMbHirEhCs/b/Q0Zyenw7OaQ4gBvBWpdFX
         IO2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=29td3uHNqzr9Pa54h/jcLjQl505LyDtx3vEc2mRzNGU=;
        b=V8FLlVPhy4hvCeBzsDat/1VnMntsVKtBVuRpkFAvgk/0MNudFizgJCht3B7cWLwXKu
         knfJmixGy6VGnS70ZbhdpRDK+Yqx1RR9X7C77ctWX1AwJyLI/r+ZRBcAddq2TXGP2QvP
         keig9WucFmQcakg8b1/5K2teXr7VXgVLtK8nFHac7LVlR7g85SwfBUWIyOwnTYWfGc9B
         gaLDR3eFCBlkWzIH4ni9E0SJoNuA6aoSLAwH1MBHNrBaY6Hn7w0L8watMPoVw60o1qG0
         h77eWYsdV5GAb8zdFT80496S1POgpU1nGlzj0q0L2+NZKzdx6fYIsbGrApQzePY/nNWV
         bCyQ==
X-Gm-Message-State: AOAM530lO52vE+IdJ65kPxWR5/SNelEDOM89Q3oKatSL9WLNoL8xs959
        GqFr9mJO+8/9Y43DybK28pebohbu09ad8MHR
X-Google-Smtp-Source: ABdhPJyqGXorDoYR5TnHJVict5mLFfLSNbejIoTeZKZw9efCjS4V0izIPolUieCGgToEcMAPSRmiVg==
X-Received: by 2002:a02:944e:0:b0:31a:2e9:bfa6 with SMTP id a72-20020a02944e000000b0031a02e9bfa6mr417760jai.277.1648660462054;
        Wed, 30 Mar 2022 10:14:22 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b24-20020a5d8d98000000b006409ad493fbsm11588920ioj.21.2022.03.30.10.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 10:14:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 2/5] io_uring: defer splice/tee file validity check until command issue
Date:   Wed, 30 Mar 2022 11:14:13 -0600
Message-Id: <20220330171416.152538-3-axboe@kernel.dk>
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

In preparation for not using the file at prep time, defer checking if this
file refers to a valid io_uring instance until issue time.

This also means we can get rid of the cleanup flag for splice and tee.

Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 49 +++++++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3d0dbcd2f69c..0b89f35378fa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -655,10 +655,10 @@ struct io_epoll {
 
 struct io_splice {
 	struct file			*file_out;
-	struct file			*file_in;
 	loff_t				off_out;
 	loff_t				off_in;
 	u64				len;
+	int				splice_fd_in;
 	unsigned int			flags;
 };
 
@@ -1688,14 +1688,6 @@ static void io_prep_async_work(struct io_kiocb *req)
 		if (def->unbound_nonreg_file)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
-
-	switch (req->opcode) {
-	case IORING_OP_SPLICE:
-	case IORING_OP_TEE:
-		if (!S_ISREG(file_inode(req->splice.file_in)->i_mode))
-			req->work.flags |= IO_WQ_WORK_UNBOUND;
-		break;
-	}
 }
 
 static void io_prep_async_link(struct io_kiocb *req)
@@ -4369,18 +4361,11 @@ static int __io_splice_prep(struct io_kiocb *req,
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
-	sp->file_in = NULL;
 	sp->len = READ_ONCE(sqe->len);
 	sp->flags = READ_ONCE(sqe->splice_flags);
-
 	if (unlikely(sp->flags & ~valid_flags))
 		return -EINVAL;
-
-	sp->file_in = io_file_get(req->ctx, req, READ_ONCE(sqe->splice_fd_in),
-				  (sp->flags & SPLICE_F_FD_IN_FIXED));
-	if (!sp->file_in)
-		return -EBADF;
-	req->flags |= REQ_F_NEED_CLEANUP;
+	sp->splice_fd_in = READ_ONCE(sqe->splice_fd_in);
 	return 0;
 }
 
@@ -4395,20 +4380,27 @@ static int io_tee_prep(struct io_kiocb *req,
 static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_splice *sp = &req->splice;
-	struct file *in = sp->file_in;
 	struct file *out = sp->file_out;
 	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
+	struct file *in;
 	long ret = 0;
 
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
+
+	in = io_file_get(req->ctx, req, sp->splice_fd_in,
+				  (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (!in) {
+		ret = -EBADF;
+		goto done;
+	}
+
 	if (sp->len)
 		ret = do_tee(in, out, sp->len, flags);
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
 		io_put_file(in);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-
+done:
 	if (ret != sp->len)
 		req_set_fail(req);
 	io_req_complete(req, ret);
@@ -4427,15 +4419,22 @@ static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_splice *sp = &req->splice;
-	struct file *in = sp->file_in;
 	struct file *out = sp->file_out;
 	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
 	loff_t *poff_in, *poff_out;
+	struct file *in;
 	long ret = 0;
 
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
+	in = io_file_get(req->ctx, req, sp->splice_fd_in,
+				  (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (!in) {
+		ret = -EBADF;
+		goto done;
+	}
+
 	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
 	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
 
@@ -4444,8 +4443,7 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
 		io_put_file(in);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-
+done:
 	if (ret != sp->len)
 		req_set_fail(req);
 	io_req_complete(req, ret);
@@ -7165,11 +7163,6 @@ static void io_clean_op(struct io_kiocb *req)
 			kfree(io->free_iov);
 			break;
 			}
-		case IORING_OP_SPLICE:
-		case IORING_OP_TEE:
-			if (!(req->splice.flags & SPLICE_F_FD_IN_FIXED))
-				io_put_file(req->splice.file_in);
-			break;
 		case IORING_OP_OPENAT:
 		case IORING_OP_OPENAT2:
 			if (req->open.filename)
-- 
2.35.1

