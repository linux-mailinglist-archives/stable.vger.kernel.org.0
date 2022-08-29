Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD0D5A4E31
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 15:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiH2Ne2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 09:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiH2Ne1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 09:34:27 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE54F58B
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:25 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id az24-20020a05600c601800b003a842e4983cso1943757wmb.0
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=GV2/gHTS2NsMgzqsy4VvsVTBidlJR61A1ZATMX3u/Uo=;
        b=BXHRyiuFD3BsG5KuB/16G8kLX4DE7RFrJlw0I9WVSSGAcNV8u3nOF/zF/lNSkda03q
         VeGlysyE0TRSo3JWw8tE/4sYOTk2qB/DpVb7j7kvSAXQjY6/2osCV2UoI3P63Kay7Ua4
         ahTCY8Qvmo1yg51yOT16ZFZmFNwO0obhjo6hq2lUm30/g+KPbIXdJBdEkQP5ZGqNdQYc
         wjDx6dNsLEoOoJExDCiMkdHS/+JrjAtZs2l2Y6fghCQ8HwPxzkU3oIePHR7tbl/cC5Gp
         3paLorX00+5t0lLFzvOn5Vfb4xNQLQYvVAm+hyAUmTQvlQw0MaBmcDGkZKLU5G4dpyHm
         lJYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=GV2/gHTS2NsMgzqsy4VvsVTBidlJR61A1ZATMX3u/Uo=;
        b=ftPqp2hjSBDlRfRn7I2TECED284+1msm69brIJuaor1PUV/EVQsTFLoMip9zh/6Ci9
         6qIT6L8+INHZG7LD2XCXCHzxJphwFWF1c6A2vEY7ILWUGjPt1MHHXmBnyB1RNjt/0ylO
         Tw8Iui9DTa17th2i+bdDL/JmIj7ndvRPnpET4Rtwr1iON31Rx0YkmO/bPFCSTJNacnoy
         91j8fGS2j7L7olcz8FKkwOchb46p6FDY+Dstryyf1AWdWr6xxHXFbYyy918c9a7IdMqY
         8Xw3Jht8O2cc0r4qKMfbh4o9iFdKvDOR8R0e5cH5uZ6zXjUm2MCnvffiEFlIeXi7+RuF
         4SdQ==
X-Gm-Message-State: ACgBeo3M/gMCblYqtg9KHm/6MxfHbEHj0m92//FKTxgAdLIHaZXcarWk
        yyJXJMxwAJG9wvLlgIvBkvKI93U6rL0=
X-Google-Smtp-Source: AA6agR6WeYGCYggDKHeFa2aQeBazbBLborv0lY7ITTQ4KkCSLkRIym7oO97JPM4oJXKhYacynT+YDw==
X-Received: by 2002:a05:600c:22cd:b0:3a6:7b62:3778 with SMTP id 13-20020a05600c22cd00b003a67b623778mr6942941wmg.45.1661780063957;
        Mon, 29 Aug 2022 06:34:23 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id bn6-20020a056000060600b00222ed7ea203sm4897361wrb.100.2022.08.29.06.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 06:34:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 03/13] io_uring: refactor poll update
Date:   Mon, 29 Aug 2022 14:30:14 +0100
Message-Id: <decb6e4ea41a43485fcdd1853cca4af0bd3ed526.1661594698.git.asml.silence@gmail.com>
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

[ upstream commmit 2bbb146d96f4b45e17d6aeede300796bc1a96d68 ]

Clean up io_poll_update() and unify cancellation paths for remove and
update.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/5937138b6265a1285220e2fab1b28132c1d73ce3.1639605189.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 62 +++++++++++++++++++++------------------------------
 1 file changed, 26 insertions(+), 36 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7812a8e81f3e..7d58da54664b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5925,61 +5925,51 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *preq;
 	bool completing;
-	int ret;
+	int ret2, ret = 0;
 
 	spin_lock(&ctx->completion_lock);
 	preq = io_poll_find(ctx, req->poll_update.old_user_data, true);
 	if (!preq) {
 		ret = -ENOENT;
-		goto err;
-	}
-
-	if (!req->poll_update.update_events && !req->poll_update.update_user_data) {
-		completing = true;
-		ret = io_poll_remove_one(preq) ? 0 : -EALREADY;
-		goto err;
+fail:
+		spin_unlock(&ctx->completion_lock);
+		goto out;
 	}
-
+	io_poll_remove_double(preq);
 	/*
 	 * Don't allow racy completion with singleshot, as we cannot safely
 	 * update those. For multishot, if we're racing with completion, just
 	 * let completion re-add it.
 	 */
-	io_poll_remove_double(preq);
 	completing = !__io_poll_remove_one(preq, &preq->poll, false);
 	if (completing && (preq->poll.events & EPOLLONESHOT)) {
 		ret = -EALREADY;
-		goto err;
-	}
-	/* we now have a detached poll request. reissue. */
-	ret = 0;
-err:
-	if (ret < 0) {
-		spin_unlock(&ctx->completion_lock);
-		req_set_fail(req);
-		io_req_complete(req, ret);
-		return 0;
-	}
-	/* only mask one event flags, keep behavior flags */
-	if (req->poll_update.update_events) {
-		preq->poll.events &= ~0xffff;
-		preq->poll.events |= req->poll_update.events & 0xffff;
-		preq->poll.events |= IO_POLL_UNMASK;
+		goto fail;
 	}
-	if (req->poll_update.update_user_data)
-		preq->user_data = req->poll_update.new_user_data;
 	spin_unlock(&ctx->completion_lock);
 
-	/* complete update request, we're done with it */
-	io_req_complete(req, ret);
-
-	if (!completing) {
-		ret = io_poll_add(preq, issue_flags);
-		if (ret < 0) {
-			req_set_fail(preq);
-			io_req_complete(preq, ret);
+	if (req->poll_update.update_events || req->poll_update.update_user_data) {
+		/* only mask one event flags, keep behavior flags */
+		if (req->poll_update.update_events) {
+			preq->poll.events &= ~0xffff;
+			preq->poll.events |= req->poll_update.events & 0xffff;
+			preq->poll.events |= IO_POLL_UNMASK;
 		}
+		if (req->poll_update.update_user_data)
+			preq->user_data = req->poll_update.new_user_data;
+
+		ret2 = io_poll_add(preq, issue_flags);
+		/* successfully updated, don't complete poll request */
+		if (!ret2)
+			goto out;
 	}
+	req_set_fail(preq);
+	io_req_complete(preq, -ECANCELED);
+out:
+	if (ret < 0)
+		req_set_fail(req);
+	/* complete update request, we're done with it */
+	io_req_complete(req, ret);
 	return 0;
 }
 
-- 
2.37.2

