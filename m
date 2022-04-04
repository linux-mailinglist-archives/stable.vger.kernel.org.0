Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E38B4F2192
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 06:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiDECwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 22:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbiDECwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 22:52:02 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3344142BBAF
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 18:59:56 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id kl29so8989367qvb.2
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 18:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oUSkiCIKDszKfMa2Axzg9BrbFIepg9ZI9Q2puU5x6rA=;
        b=IvpqiESKT2bbOm8PxEjnVW7PRd2mEMS1DEOkcc5HHSBoVCS+RNmS2PJEDgd14+Neb8
         bgcpnEaF27WXTCOTVPg5CxRNl4h3vUlaMdkP/55vHT/AvF3Uw+RjCsEkNA5vOBoZp75A
         UEujNWpGtLbFNmrlqWbzO654dPb+Gk9BW/vmDbfmmGfEr9J/FE7ii3tS+fpza1C35Gmw
         QMET71bIjB5to3Qwy2vRn3nq1DVel5jytfHbkr2VctYTnHv6aaGmM0Y0iwwanZNV+FhO
         5cdPyXjTROYHf0KCI4hNy9v5xevAhV3z1ZaV1othnD2FdUAl7yQir9DaiDx8Z2/WdHOo
         bEYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oUSkiCIKDszKfMa2Axzg9BrbFIepg9ZI9Q2puU5x6rA=;
        b=KBFuqNjYSZ/R0oqbmMrti3DkPugDhsj47YkEQHUSL0XZwN6mUMUeiNANUpYR1V4M4b
         s8G9i6AW5AbkDRfDjEXByAXFrDADeRiZobfvBOU2kTU78g20c/zSKGSaQqryF4WiEFep
         WRskfTsG57zp41tJehvvRUPguUh3v9YzJRa6UOrqT0PcQFC7WSLwq7oAk/I/gjWGlz27
         gS3rijFIQrAwVnaXcBCe1m/tZ5JeSM0bOBFTIyjEzaTYKFLHk/um+8y0DOTYnQA1kEyi
         9s46SmY/QmGkHQJ57yzlsp2hrknh/SiVNQdk5gJfQJ+faNUcN8g2inUPR//iw30bQ+9K
         1/gQ==
X-Gm-Message-State: AOAM530sjLd4yIAeenip2RlVfs8MoosbculMO/ZT3pt9CgpOS2Id2QJy
        vYXxXxM1WN9isCHaU4TWjKFDJ9Q4NtlyIQ==
X-Google-Smtp-Source: ABdhPJwofPNRykDB98EX86mbuRhidKD3QC3l8EqNCZttbCCnJV2I5vX+2W8UEML7OhO4P5r/nQ5rYQ==
X-Received: by 2002:a05:6a00:1c9e:b0:4fa:d946:378b with SMTP id y30-20020a056a001c9e00b004fad946378bmr598956pfw.46.1649116596282;
        Mon, 04 Apr 2022 16:56:36 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i7-20020a628707000000b004fa6eb33b02sm13157977pfe.49.2022.04.04.16.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 16:56:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 2/6] io_uring: defer splice/tee file validity check until command issue
Date:   Mon,  4 Apr 2022 17:56:22 -0600
Message-Id: <20220404235626.374753-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404235626.374753-1-axboe@kernel.dk>
References: <20220404235626.374753-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index 9108c56bff5b..0152ef49cf46 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -654,10 +654,10 @@ struct io_epoll {
 
 struct io_splice {
 	struct file			*file_out;
-	struct file			*file_in;
 	loff_t				off_out;
 	loff_t				off_in;
 	u64				len;
+	int				splice_fd_in;
 	unsigned int			flags;
 };
 
@@ -1687,14 +1687,6 @@ static void io_prep_async_work(struct io_kiocb *req)
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
@@ -7176,11 +7174,6 @@ static void io_clean_op(struct io_kiocb *req)
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

