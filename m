Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F580600384
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 23:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiJPVpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 17:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiJPVpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 17:45:13 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B082F3B8
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 14:45:12 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z97so13553370ede.8
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 14:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lxZGauP5P46PgzbXhPd0V/Eo64zwUXum5Bih9cfxJPE=;
        b=QxP2bjctaRihkAvSbIsPxtkaqWrnvg1exTXQC0600x8VU0opLPeIatq7UzSHHypbb2
         5xBT6QURrEORnvcS1sfR4CGot7baXYhCyUpBkFOmunPoDOgGU6GieC1YjapdAPysJYAA
         FWkWIq7H4E+vp5olXJyN4G/EVSScZj+MZ30kTF2DvgI0N3zLEzv0jdHBk5PxMlY9DJRM
         VkjfBxOUOH1diIJC1pIwRZedx8QbtDWg/jRN+QRStf7mgnX5/gfegHYIrozowNsPq+NU
         wItz3ZqhSZqxaTfdh2xir5F8+tR+uWc9GmXp9elFIIzzivwmarUSwRqBo29VPoQnuIDS
         OOlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lxZGauP5P46PgzbXhPd0V/Eo64zwUXum5Bih9cfxJPE=;
        b=w6cm7Jg7ee9iWdM0oh6Il0J2RoP4hSuRRK/Y3DjWMO/2XU7B7pmwEwSPcu7RFBW97x
         WFROz2O9kuovJ7xnkVy6N3o8kPSPvwFjCC6EL8ZWpGDaljQFQwx6Vw259RF7bJnHuOFm
         TJPnyN2FiOEDSfKdZ7CIsxYrK7wDzmoAX8wr2qnvWre8Me4gUNn+Y3PD3H99dENftbeA
         AKJ1nvM4APHSf9bqsGPRtUykQ3Ql9COa4aDhwFgNMeG1Ofuhb4Wmm0PQ8GfZ0O5vadvc
         CgFRZb2dgw8mEt1ujsXG8wBEdYXn3gNmc7mjlsXjB8aFO3eN7+1Hv+O0NiTtv4Mfc4ZO
         dIPA==
X-Gm-Message-State: ACrzQf02KgneseT+A3Du7XHM/FP0Yy5IUTwBDg93MtwJqwdUFNd3t3q3
        ilfbvGvfpC/koSXeh14fQTK78eoAT1o=
X-Google-Smtp-Source: AMsMyM5xhKyce8Bl9CpmeEfm9ogFz9NpiyW70PoiNZuDl1URKryFjzYB4bsqwitblSYfiUHFyW41wg==
X-Received: by 2002:a05:6402:3709:b0:459:279e:fdc6 with SMTP id ek9-20020a056402370900b00459279efdc6mr7628355edb.338.1665956710561;
        Sun, 16 Oct 2022 14:45:10 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090676c600b0078c47463277sm5177331ejn.96.2022.10.16.14.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 14:45:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 3/5] io_uring/rw: fix short rw error handling
Date:   Sun, 16 Oct 2022 22:42:56 +0100
Message-Id: <6592121a38f7ee5834ce0691b1f85d54fcea3cfa.1665954636.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1665954636.git.asml.silence@gmail.com>
References: <cover.1665954636.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commit 89473c1a9205760c4fa6d158058da7b594a815f0 ]

We have a couple of problems, first reports of unexpected link breakage
for reads when cqe->res indicates that the IO was done in full. The
reason here is partial IO with retries.

TL;DR; we compare the result in __io_complete_rw_common() against
req->cqe.res, but req->cqe.res doesn't store the full length but rather
the length left to be done. So, when we pass the full corrected result
via kiocb_done() -> __io_complete_rw_common(), it fails.

The second problem is that we don't try to correct res in
io_complete_rw(), which, for instance, might be a problem for O_DIRECT
but when a prefix of data was cached in the page cache. We also
definitely don't want to pass a corrected result into io_rw_done().

The fix here is to leave __io_complete_rw_common() alone, always pass
not corrected result into it and fix it up as the last step just before
actually finishing the I/O.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2da7a490d1c7..c0d1948fb5a6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2701,6 +2701,20 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	return false;
 }
 
+static inline unsigned io_fixup_rw_res(struct io_kiocb *req, unsigned res)
+{
+	struct io_async_rw *io = req->async_data;
+
+	/* add previously done IO, if any */
+	if (io && io->bytes_done > 0) {
+		if (res < 0)
+			res = io->bytes_done;
+		else
+			res += io->bytes_done;
+	}
+	return res;
+}
+
 static void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
 	unsigned int cflags = io_put_rw_kbuf(req);
@@ -2724,7 +2738,7 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 {
 	if (__io_complete_rw_common(req, res))
 		return;
-	__io_req_complete(req, issue_flags, req->result, io_put_rw_kbuf(req));
+	__io_req_complete(req, issue_flags, io_fixup_rw_res(req, res), io_put_rw_kbuf(req));
 }
 
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
@@ -2733,7 +2747,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 
 	if (__io_complete_rw_common(req, res))
 		return;
-	req->result = res;
+	req->result = io_fixup_rw_res(req, res);
 	req->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(req);
 }
@@ -2979,15 +2993,6 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 		       unsigned int issue_flags)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
-	struct io_async_rw *io = req->async_data;
-
-	/* add previously done IO, if any */
-	if (io && io->bytes_done > 0) {
-		if (ret < 0)
-			ret = io->bytes_done;
-		else
-			ret += io->bytes_done;
-	}
 
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = kiocb->ki_pos;
@@ -3004,6 +3009,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 			unsigned int cflags = io_put_rw_kbuf(req);
 			struct io_ring_ctx *ctx = req->ctx;
 
+			ret = io_fixup_rw_res(req, ret);
 			req_set_fail(req);
 			if (!(issue_flags & IO_URING_F_NONBLOCK)) {
 				mutex_lock(&ctx->uring_lock);
-- 
2.38.0

