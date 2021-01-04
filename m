Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E232B2EA0EA
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 00:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbhADXdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 18:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727157AbhADXdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 18:33:39 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B697C061793;
        Mon,  4 Jan 2021 15:32:59 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id g25so659455wmh.1;
        Mon, 04 Jan 2021 15:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wMfUh98z+VGMs2bSBZIO9m9BSA88/71FTBw/qxyvyaE=;
        b=jEExgnxQ5gIc6EAc0Mm80cIgl4lhubCXXYRzc2zG6QtgDYLu4v574Zp7+Y4xvfmirf
         h+UPto8VEKcE+DyNPfvCjMpK425AQRkptGxVlWZDZKTw3xumCOoPXRTUqVB4MfQlAgC8
         tkz+BsUt9peknTcGMvxbCpr13SLjGbAJo7M65vwFKyLsCTaEyCOGDEWieAbGpbLu3r4m
         Gek9CkBDItiEkw/bl8DiSLQp39AMgfS2EwM+zs5HeCQg6BSMFplEvWBdG7fGzrx4u7Fs
         GOtdlwmzU7mIOz5YYjlAL2oPI8/Fb27oA8aMcppcaNp5W5vKXzPujrjnlwafwlqRcMfi
         Z9yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wMfUh98z+VGMs2bSBZIO9m9BSA88/71FTBw/qxyvyaE=;
        b=mw5sv+h74tV1SFeEqVI7RyEC2TX4Fr7bVzAkwdIG/+u7weXhwcj48Guf+o5Hud0Zzj
         G97DJWTCBpyn9YyP/uWzgE3oHTK3ak/gI0VPXQZI+LQ7IvVyXrFO3Kz5ShoRRSKhxWPw
         CQvyK9ItPPukza/j1++vNhl+MqdJ2+pAW0woAhszRB90TxSEYcdzZzHT184kW/P/HSzY
         l495Z3m9bg7LPr3U8OKulIkqbrtduVhEWP6tZ+bMDe2T98bUqSnRdmHb+I1a1ToIRS8/
         6E1YFwziuzxrY6IXgIV4w5N35VbydESUtzVzp2xFOdbPJGVWIOpL8kgZB32gwJbpxVlf
         x8ig==
X-Gm-Message-State: AOAM5334eiJ+pPIyTnrauAG6HIdab49g2+IdXCdXdHSDUtWMwcUiISWg
        V8ZRyr7pqrAPiFNNx8xAEStSB85v48dV8g==
X-Google-Smtp-Source: ABdhPJytrc0zapfEEnpan21eBiRQb/8LcKD3chQwDFYdX6lrjsxUnJ9OZEepwOYBNnHKDOtAp2JscQ==
X-Received: by 2002:a1c:356:: with SMTP id 83mr569694wmd.31.1609792813149;
        Mon, 04 Jan 2021 12:40:13 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id w21sm734483wmi.45.2021.01.04.12.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 12:40:12 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v3 1/2] io_uring: synchronise IOPOLL on task_submit fail
Date:   Mon,  4 Jan 2021 20:36:35 +0000
Message-Id: <0351c665bf51ffc766fbd295f58532b3a0986863.1609789890.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609789890.git.asml.silence@gmail.com>
References: <cover.1609789890.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

io_req_task_submit() might be called for IOPOLL, do the fail path under
uring_lock to comply with IOPOLL synchronisation based solely on it.

Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca46f314640b..5be33fd8b6bc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2126,15 +2126,16 @@ static void io_req_task_cancel(struct callback_head *cb)
 static void __io_req_task_submit(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	bool fail;
 
-	if (!__io_sq_thread_acquire_mm(ctx) &&
-	    !__io_sq_thread_acquire_files(ctx)) {
-		mutex_lock(&ctx->uring_lock);
+	fail = __io_sq_thread_acquire_mm(ctx) ||
+		__io_sq_thread_acquire_files(ctx);
+	mutex_lock(&ctx->uring_lock);
+	if (!fail)
 		__io_queue_sqe(req, NULL);
-		mutex_unlock(&ctx->uring_lock);
-	} else {
+	else
 		__io_req_task_cancel(req, -EFAULT);
-	}
+	mutex_unlock(&ctx->uring_lock);
 }
 
 static void io_req_task_submit(struct callback_head *cb)
-- 
2.24.0

