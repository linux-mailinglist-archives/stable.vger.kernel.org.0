Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D215A4E34
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 15:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiH2Neb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 09:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiH2Ne3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 09:34:29 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA8387099
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:28 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b5so10219570wrr.5
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=W5+CNNPqIzEffO04b/3qwvJL37tvJFodCJplY3pSnfo=;
        b=ONfN71Cpk+oTAl6/dlHl8RCHiIXpJni1JNTszNFiiaPOA4C4c3coovY+HZwmEyYyAP
         2f34WObd+km5FkI1UnzvHkTHAH3sLvY8+1H3xjOlpQPkPWSpCLOjB4ybw8ZlOt4pW7/H
         vuexhTvGWQkDrzznGM/fKTlLaQGEtaXOdlmhqfW/MP9w2ddIiJ31b3ur8wSuvFDl9FeX
         hGm+KlqtUOmVSxpCJcOFm51hC2mTL9iEs5TbBJPT3cmqxgpu7qFwql62nYAqFFyp2H90
         FC4vxjRjJtZHw9Tg805aogqfgHXwscNo0O2CnCTZt1X/97SlYLbBhJ07QRnwSaI8PRTC
         2Jtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=W5+CNNPqIzEffO04b/3qwvJL37tvJFodCJplY3pSnfo=;
        b=tbDC5HRojJ6zGvgA1WfWR+SnvLEN0EN+rsmVSJkzvPjQpCrLMlQ5t1nb2j3UBHl32M
         Qcwgf+J36Qs76K3PzElzTIYGqd5vlvoWCkX8gdWBF/0ubL4ufX0jgon1d/L400gMvB1e
         SuQ1EuifWFt0HnEsJTGMF0Y4eV80/wC1Jrp+yC2NEh74hsrNSXU4Pj9pAa4ShucOACcw
         chCykPsLyXfyA/FKMFVgi1tWq+7xVF0ak0GqoOv5KbGhZlt1p3lK80P5tyEWoDHfObcN
         OZRuQDwCVXZWPriQi+R4qIlYBRWf4YDgMAya9/CYInwf6IrWfCseLNTT988PAWcfdznX
         TRsA==
X-Gm-Message-State: ACgBeo2NitQULvWxkLNz1IkjGFEa4E3rW/RqE07sXPkqd2D2pmB0R66+
        zwSwo8Mgdh7gwwaLaG1Sy675NfsRjMs=
X-Google-Smtp-Source: AA6agR5dmVgYlKcrDKwudIae+/gUOPLMAbe6SjPfOIFr7/28ughyoqR449TcBtGki071DSi9L2SSHg==
X-Received: by 2002:a05:6000:1a88:b0:225:5f70:9a1 with SMTP id f8-20020a0560001a8800b002255f7009a1mr6206410wry.209.1661780067084;
        Mon, 29 Aug 2022 06:34:27 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id bn6-20020a056000060600b00222ed7ea203sm4897361wrb.100.2022.08.29.06.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 06:34:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 06/13] io_uring: inline io_poll_complete
Date:   Mon, 29 Aug 2022 14:30:17 +0100
Message-Id: <acf073d1684c8bb956f5d26a5744430411863ad9.1661594698.git.asml.silence@gmail.com>
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

[ upstream commmit eb6e6f0690c846f7de46181bab3954c12c96e11e ]

Inline io_poll_complete(), it's simple and doesn't have any particular
purpose.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/933d7ee3e4450749a2d892235462c8f18d030293.1633373302.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6e80876d8894..39d39dfaa55a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5441,16 +5441,6 @@ static bool __io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	return !(flags & IORING_CQE_F_MORE);
 }
 
-static inline bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
-	__must_hold(&req->ctx->completion_lock)
-{
-	bool done;
-
-	done = __io_poll_complete(req, mask);
-	io_commit_cqring(req->ctx);
-	return done;
-}
-
 static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5904,7 +5894,8 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (mask) { /* no async, we'd stolen it */
 		ipt.error = 0;
-		done = io_poll_complete(req, mask);
+		done = __io_poll_complete(req, mask);
+		io_commit_cqring(req->ctx);
 	}
 	spin_unlock(&ctx->completion_lock);
 
-- 
2.37.2

