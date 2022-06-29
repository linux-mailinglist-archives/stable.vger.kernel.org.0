Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5D3560C54
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 00:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiF2Wdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 18:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiF2Wdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 18:33:50 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233861CB15
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 15:33:49 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id d2so23663597ejy.1
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 15:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SrpqlhqgYAuTzurYJ3VdkfE2wli3hLxXf5UyPZRd0Fc=;
        b=fQ0GKnuvW/gOmvryJWR624ImJFUzobLNZU71ZqkOBpBr/b/nB2kxck/VaWyOw57Qgn
         qqMI07TF5+QVEbOv+WgbRwdKPVrIA++IRjsaWodm+7hP5GukcUZ5zFNkTrGGDeaOEdPQ
         xpSSJn9+dsdH3rWUwx2hVx3MuS/2/okI+hj+yQyw6qRFXwhW6tg8b5r6VGRNQc+UYgI4
         7BSlSCirEy/zUHik4BWDaIzZq2dsHw9FLfXqz4/T5QXSjB01hEDmN575KR8VUZ39gtJr
         Jf2cK0Z1wbwNL3CSiEBZLmvJN0kMeQidlEvkbC3Y4QytXOnExxQly2hKk3m/3oEryAHO
         zocg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SrpqlhqgYAuTzurYJ3VdkfE2wli3hLxXf5UyPZRd0Fc=;
        b=q/VV2Cj7tBZ2QLolTR+oR4kaiQG9/jjd5rxAQjPRox6ss3nQtW/8501sP3RXHqjGvK
         4EuMNPb0HVEcQGdQQdjOhHIHtmg8nnlXc5mEpuKYKvE8oQgV8/OopZzmzIg9rxLJ0zQe
         03/D7s1VsIy+XSC2zpvA3sMSwPfAwdNplOYXTtpzvf43GJfRxumNry5t1VCKackglV3b
         q4rr4cwA7jnsZ/zum4rhLBVgb4fv2ajoJRVh9NemMz+2as0dWvSzI5LXmz2HxEN7GXmJ
         NaZFX2FevIX7MQruNGvX6IWUTK+SA7CZa8wJ1uSQP9kmtKLWjT0SdJucu5x/zZD099Gd
         +UnA==
X-Gm-Message-State: AJIora8cqej7IQT0ONaNXiz9DzOkxF+D4n7ruROf1dYoIMCmQdYFIbK5
        SO1F+cC45Ri7seyDTasyGlApP/YAlEI65w==
X-Google-Smtp-Source: AGRyM1sq7KLa4RtLjjM1250GDhhpJGb7DoOr46KSXO5muOklUfWjEeAFXk+1xYJf0IJIRLsuWFoXqQ==
X-Received: by 2002:a17:906:d54f:b0:726:2c7c:c0f9 with SMTP id cr15-20020a170906d54f00b007262c7cc0f9mr5649849ejc.441.1656542027451;
        Wed, 29 Jun 2022 15:33:47 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k13-20020a170906a38d00b006fed787478asm8327657ejz.92.2022.06.29.15.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 15:33:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15] io_uring: fix not locked access to fixed buf table
Date:   Wed, 29 Jun 2022 23:33:36 +0100
Message-Id: <38d217692f3247110ce26e60b01f4eadd866757b.1656541986.git.asml.silence@gmail.com>
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
 fs/io_uring.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index be2176575353..a8470a98f84d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2932,15 +2932,24 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		kiocb->ki_complete = io_complete_rw;
 	}
 
+	/* used for fixed read/write too - just read unconditionally */
+	req->buf_index = READ_ONCE(sqe->buf_index);
+	req->imu = NULL;
+
 	if (req->opcode == IORING_OP_READ_FIXED ||
 	    req->opcode == IORING_OP_WRITE_FIXED) {
-		req->imu = NULL;
+		struct io_ring_ctx *ctx = req->ctx;
+		u16 index;
+
+		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
+			return -EFAULT;
+		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
+		req->imu = ctx->user_bufs[index];
 		io_req_set_rsrc_node(req);
 	}
 
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
-	req->buf_index = READ_ONCE(sqe->buf_index);
 	return 0;
 }
 
@@ -3066,18 +3075,9 @@ static int __io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter
 
 static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_mapped_ubuf *imu = req->imu;
-	u16 index, buf_index = req->buf_index;
-
-	if (likely(!imu)) {
-		if (unlikely(buf_index >= ctx->nr_user_bufs))
-			return -EFAULT;
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

