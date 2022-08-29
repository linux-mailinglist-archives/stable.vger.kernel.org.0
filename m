Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525595A4E2E
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 15:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiH2Ne1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 09:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiH2NeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 09:34:25 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09BFF58B
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:23 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id ay39-20020a05600c1e2700b003a5503a80cfso4448987wmb.2
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=WoZpaFjrF5scwku9KrklH0gJn8ngBFDZN5TCX28Z/O4=;
        b=HIkDwXUlRK2vweGXnhvBdLG/SUDfAhHSn8VCVsckjakcxm/rVTC5sb4QWznZEgaehU
         8qRaRSrXZsYlVCYwHPgWidwvWsf/VBVqiJxPoiA/0aq9U3B5L64SQMOJ75akdK6GXtl0
         CVs3uxJmZFI2pWOddCLrxnDWxCSm6eudX+npitBqBUAvJ/57trmwqJ2NTBT8252BXVvm
         k93jeRlGZsg/tVwM/EicvYcXPEm2HJpYgh+wcAESem5KuPwY3oO343qEsLWnVIKSo9SX
         rl26AZiw7VE6I+dJSa+6uz33HMkY7lUw8QuPOl8hwUvk4YGsJM2rvweEq99sdooNrq83
         EZxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=WoZpaFjrF5scwku9KrklH0gJn8ngBFDZN5TCX28Z/O4=;
        b=L1AzctvnGSU5RyPooolGxW7VBlXeGWklXE8FX7/rub5QPninrSYKPFOXc7uPh6Kl9s
         ebXs+cF5Q5U3U4lOTqm3m/XC45/2WDqm9+NMoX16/sTWS83KjrMQqgMxHkCEiI7zI/Nw
         hEZ/8K/64YSc6UjWlcYNpo3TWydGOAK4HCmbll8paZWZAridqc3Hu+utdfDssG6qnb8s
         t9sNVWirCI9JyDHRf/xoy1tRnBmRlww828StoB5x10R4Huji5ujj8mUSC7pO2Q9GCLT0
         C5hXCLzspr01U0HP/pZ5/QpA0D6TdjGjDwGoepof0fMZeVXet9pODMHpY/uMNOUGFYw1
         3Ujg==
X-Gm-Message-State: ACgBeo3paHgjg3NwJIDWIiTPpifuTWGaTBexhEx+W608irIS5WhxX5FR
        l779tPNLnO8vkj6SSYvInDOPIw5Kpj0=
X-Google-Smtp-Source: AA6agR5kfE7rw7lFwij6HFIn7qfoZngOr4E+NoNvY1AOiBSWj2xiswLVAIUcyf3+Yw2aUHiWW3lCAQ==
X-Received: by 2002:a05:600c:2193:b0:3a5:346f:57d0 with SMTP id e19-20020a05600c219300b003a5346f57d0mr6748494wme.124.1661780061929;
        Mon, 29 Aug 2022 06:34:21 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id bn6-20020a056000060600b00222ed7ea203sm4897361wrb.100.2022.08.29.06.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 06:34:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 01/13] io_uring: correct fill events helpers types
Date:   Mon, 29 Aug 2022 14:30:12 +0100
Message-Id: <284e9d099964bf88fd0a97ff6cda636d51858a30.1661594698.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1661594698.git.asml.silence@gmail.com>
References: <cover.1661594698.git.asml.silence@gmail.com>
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

[ upstream commit 54daa9b2d80ab35824464b35a99f716e1cdf2ccb ]

CQE result is a 32-bit integer, so the functions generating CQEs are
better to accept not long but ints. Convert io_cqring_fill_event() and
other helpers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/7ca6f15255e9117eae28adcac272744cae29b113.1633373302.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9bff14c5e2b2..b5718278ae61 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1080,7 +1080,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 
 static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-				 long res, unsigned int cflags);
+				 s32 res, u32 cflags);
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req);
 static void io_dismantle_req(struct io_kiocb *req);
@@ -1763,7 +1763,7 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
 }
 
 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
-				     long res, unsigned int cflags)
+				     s32 res, u32 cflags)
 {
 	struct io_overflow_cqe *ocqe;
 
@@ -1791,7 +1791,7 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 }
 
 static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-					  long res, unsigned int cflags)
+					  s32 res, u32 cflags)
 {
 	struct io_uring_cqe *cqe;
 
@@ -1814,13 +1814,13 @@ static inline bool __io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data
 
 /* not as hot to bloat with inlining */
 static noinline bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
-					  long res, unsigned int cflags)
+					  s32 res, u32 cflags)
 {
 	return __io_cqring_fill_event(ctx, user_data, res, cflags);
 }
 
-static void io_req_complete_post(struct io_kiocb *req, long res,
-				 unsigned int cflags)
+static void io_req_complete_post(struct io_kiocb *req, s32 res,
+				 u32 cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -1861,8 +1861,8 @@ static inline bool io_req_needs_clean(struct io_kiocb *req)
 	return req->flags & IO_REQ_CLEAN_FLAGS;
 }
 
-static void io_req_complete_state(struct io_kiocb *req, long res,
-				  unsigned int cflags)
+static inline void io_req_complete_state(struct io_kiocb *req, s32 res,
+					 u32 cflags)
 {
 	if (io_req_needs_clean(req))
 		io_clean_op(req);
@@ -1872,7 +1872,7 @@ static void io_req_complete_state(struct io_kiocb *req, long res,
 }
 
 static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
-				     long res, unsigned cflags)
+				     s32 res, u32 cflags)
 {
 	if (issue_flags & IO_URING_F_COMPLETE_DEFER)
 		io_req_complete_state(req, res, cflags);
@@ -1880,12 +1880,12 @@ static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
 		io_req_complete_post(req, res, cflags);
 }
 
-static inline void io_req_complete(struct io_kiocb *req, long res)
+static inline void io_req_complete(struct io_kiocb *req, s32 res)
 {
 	__io_req_complete(req, 0, res, 0);
 }
 
-static void io_req_complete_failed(struct io_kiocb *req, long res)
+static void io_req_complete_failed(struct io_kiocb *req, s32 res)
 {
 	req_set_fail(req);
 	io_req_complete_post(req, res, 0);
@@ -2707,7 +2707,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 static void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
 	unsigned int cflags = io_put_rw_kbuf(req);
-	long res = req->result;
+	int res = req->result;
 
 	if (*locked) {
 		struct io_ring_ctx *ctx = req->ctx;
-- 
2.37.2

