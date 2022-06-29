Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0F4560C53
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 00:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiF2WbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 18:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiF2WbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 18:31:18 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FF912087
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 15:31:17 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id h23so35314531ejj.12
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 15:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0sCsnPs6h8QBNvhPJ49adLhH8rezM9eztnQhrSClw7k=;
        b=TKJvysBeQKCjyIDQlQ6c6mhEO8H7FhtTtKEtAnQUl1Msh/H5AjPdBm7TcguneGNhaX
         yiiOLdzPbejOI8NRI0J1lrMphSeb6dtTiA9l1oMudBS0dXlTkh30YP/pIEmVclPea1T7
         FknWzhs6qXGi79g8IY+a2NYSU1pK6GAyw0ESx5uw9nf39mpya5lRcev/nE5NK300JUeE
         T7uTUMAQIf8Z+ffqK3s/hOLmmvBLuRoreGlBfRmC+ZXqMmKDmcJgtH9X/8L/R18HMKpJ
         gM3y732nuQmyw4HYhiayjeBhISB8p0+NNYGvlRMHh/iljDR3oDNJiS3dPDhuoM5lOtqi
         /9OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0sCsnPs6h8QBNvhPJ49adLhH8rezM9eztnQhrSClw7k=;
        b=kXyNsLH6wDBh0JxNq6RvOnzfF2Hj/effR0BGjh62SieCNNs6t2/HD6RiWh1msJYGJo
         dKQE2qpdFZ2z8bDOGTtL+PCfKiE56Fd2+kCg+GGhC+V8TiEQAnX0e7vEt08AwqRUgsiy
         sfM21td86xsHIF02CkEwNBjFo72xHZilYnfPn4DlIZg5qkG7vdTRPyA3MWXod6meDOKE
         65XfTxh2T/fstZjU7Cv0HmSkD/yepoHKYTENdNIu5MqzSbDPqS4E//2t3NOKpHU4RAST
         Twea7Xq8kVl9eB5RdCtjxGJ634oMeYiJqL25ZYdGsSniKPzMRBasAaCjLXSH0sFFjkLC
         vtxg==
X-Gm-Message-State: AJIora8dyCuT4Q3CQOcPwXpEl6PUDGfTfcsEqdIWi3mIF77EPwSYy3uR
        avQjyw21qDXD/w2wWPOuw0a/uBEleXZ8rw==
X-Google-Smtp-Source: AGRyM1ulJMm4VwviEryu25U14pEX+V2c8vwBWHkrFqo/0XuMPp1xtQ1XafB2X5dtE71FqtZACizkVw==
X-Received: by 2002:a17:907:97d0:b0:726:ccd3:1757 with SMTP id js16-20020a17090797d000b00726ccd31757mr5569822ejc.399.1656541875582;
        Wed, 29 Jun 2022 15:31:15 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id q21-20020aa7d455000000b0042fb3badd48sm11959032edr.9.2022.06.29.15.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 15:31:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.18] io_uring: fix not locked access to fixed buf table
Date:   Wed, 29 Jun 2022 23:31:08 +0100
Message-Id: <67671a1e90ba08e43ddc36fad434d1bf9640400e.1656527999.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commit 05b538c1765f8d14a71ccf5f85258dcbeaf189f7 ]

We can look inside the fixed buffer table only while holding
->uring_lock, however in some cases we don't do the right async prep for
IORING_OP_{WRITE,READ}_FIXED ending up with NULL req->imu forcing making
an io-wq worker to try to resolve the fixed buffer without proper
locking.

Move req->imu setup into early req init paths, i.e. io_prep_rw(), which
is called unconditionally for rw requests and under uring_lock.

Fixes: 634d00df5e1cf ("io_uring: add full-fledged dynamic buffers support")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 68aab48838e4..fba15c42266c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3187,6 +3187,21 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	int ret;
 
 	kiocb->ki_pos = READ_ONCE(sqe->off);
+	/* used for fixed read/write too - just read unconditionally */
+	req->buf_index = READ_ONCE(sqe->buf_index);
+	req->imu = NULL;
+
+	if (req->opcode == IORING_OP_READ_FIXED ||
+	    req->opcode == IORING_OP_WRITE_FIXED) {
+		struct io_ring_ctx *ctx = req->ctx;
+		u16 index;
+
+		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
+			return -EFAULT;
+		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
+		req->imu = ctx->user_bufs[index];
+		io_req_set_rsrc_node(req, ctx, 0);
+	}
 
 	ioprio = READ_ONCE(sqe->ioprio);
 	if (ioprio) {
@@ -3199,11 +3214,9 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		kiocb->ki_ioprio = get_current_ioprio();
 	}
 
-	req->imu = NULL;
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
 	req->rw.flags = READ_ONCE(sqe->rw_flags);
-	req->buf_index = READ_ONCE(sqe->buf_index);
 	return 0;
 }
 
@@ -3335,20 +3348,9 @@ static int __io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter
 static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter,
 			   unsigned int issue_flags)
 {
-	struct io_mapped_ubuf *imu = req->imu;
-	u16 index, buf_index = req->buf_index;
-
-	if (likely(!imu)) {
-		struct io_ring_ctx *ctx = req->ctx;
-
-		if (unlikely(buf_index >= ctx->nr_user_bufs))
-			return -EFAULT;
-		io_req_set_rsrc_node(req, ctx, issue_flags);
-		index = array_index_nospec(buf_index, ctx->nr_user_bufs);
-		imu = READ_ONCE(ctx->user_bufs[index]);
-		req->imu = imu;
-	}
-	return __io_import_fixed(req, rw, iter, imu);
+	if (WARN_ON_ONCE(!req->imu))
+		return -EFAULT;
+	return __io_import_fixed(req, rw, iter, req->imu);
 }
 
 static void io_ring_submit_unlock(struct io_ring_ctx *ctx, bool needs_lock)
-- 
2.36.1

