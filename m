Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B4A3CCBA2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 01:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbhGRX56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 19:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbhGRX54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Jul 2021 19:57:56 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355FDC061762
        for <stable@vger.kernel.org>; Sun, 18 Jul 2021 16:54:56 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id i94so19623299wri.4
        for <stable@vger.kernel.org>; Sun, 18 Jul 2021 16:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UszeBgxH2DDSwH8vZaJMkXZPARX31U5GtujpEGVSoi4=;
        b=fUyJGGhELRbPZIlpMeA7DSsV5kuWKwoU+9FqLiL4rt6xgzQiU+n/fb+yvKFDObdgeq
         8PnUQHB0HkUXI1boZB7rZisw2P0YLNCWzIz73Jb5NSUpyiiKYVrtuGeqvV6T18IZztCX
         U+LYfYqZ7X6iWiaBYjSal3QT4MbIQfKuhEZfBmH8dSEB0oX5cr+Gnskim//KwhPGzoGH
         MHAzJB2mujEGyk72tCnFeX1LzfJwBz7bovX6XJWeFYqNoGXlFSxPXRXrNL4+TpuOzOJQ
         cpViajV+XnRjFZVl2q9AtsPF0ogq5bKEvh78ORLEdUQBa+xYlZ7aHiLUl7ZbDzlTalH+
         q1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UszeBgxH2DDSwH8vZaJMkXZPARX31U5GtujpEGVSoi4=;
        b=SLdvA37cRokDGXiF7DBMFpZgBGiu6LWdt0ck3Ejm1Sj74yfyW5gpwRjpjPPKfZv4FV
         VU/Vos25Uu0zu31JEyG91tnPGYrZp+2rx/wHlh062ObAe1FVRXt8M0m1TMEPEve3m0CU
         ZnCM5Vl56Kl0okjuAmiEPxp0//F6uz0KGWC3Ql3FVcmDICHwIRZ1sYdL4ZdRpOv1NDs5
         qXVMKRKLeC9I7wCCKf/Kl6WY3zbbjpNyx7k2L5M9uSVsF6oO5Y3JGaWpbm0WbbzSMK4/
         BLyoZCz78pBQGoRyjh3H47MVnDIyot2/w/keukR343QYGH6Fo2iuAeSWdQWuI1Vwli9b
         GTPA==
X-Gm-Message-State: AOAM533WPmDaSfez8OyTfWHJLVkjZ6hjrv0bxPsEupGqaCu+vpaeb91U
        QM2GCbwUw4GkUqmjHq5jS2qqc1A8fTAUHA==
X-Google-Smtp-Source: ABdhPJypvHj6+RT8cauaPpoYNLa10uytCmxY6gGOuV2c6zd+PoZ+0B0EuSJeGYlO/S526DJCjDQI7w==
X-Received: by 2002:a5d:464b:: with SMTP id j11mr26746132wrs.356.1626652494659;
        Sun, 18 Jul 2021 16:54:54 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.101])
        by smtp.gmail.com with ESMTPSA id p18sm18098200wmg.46.2021.07.18.16.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jul 2021 16:54:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: put link timeout req consistently
Date:   Mon, 19 Jul 2021 00:54:22 +0100
Message-Id: <6122708161f73ad0027ee2accd755cd848742dc8.1626651114.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1626651114.git.asml.silence@gmail.com>
References: <cover.1626651114.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit df9727affa058f4f18e388b30247650f8ae13cd8 ]

Don't put linked timeout req in io_async_find_and_cancel() but do it in
io_link_timeout_fn(), so we have only one point for that and won't have
to do it differently as it's now (put vs put_deferred). Btw, improve a
bit io_async_find_and_cancel()'s locking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/d75b70957f245275ab7cba83e0ac9c1b86aae78a.1617287883.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 58ac04cca587..930c5d5a2b0b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5727,12 +5727,9 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	int ret;
 
 	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
-	if (ret != -ENOENT) {
-		spin_lock_irqsave(&ctx->completion_lock, flags);
-		goto done;
-	}
-
 	spin_lock_irqsave(&ctx->completion_lock, flags);
+	if (ret != -ENOENT)
+		goto done;
 	ret = io_timeout_cancel(ctx, sqe_addr);
 	if (ret != -ENOENT)
 		goto done;
@@ -5747,7 +5744,6 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req(req);
 }
 
 static int io_async_cancel_prep(struct io_kiocb *req,
@@ -6310,8 +6306,8 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 		io_put_req_deferred(req, 1);
 	} else {
 		io_req_complete_post(req, -ETIME, 0);
-		io_put_req_deferred(req, 1);
 	}
+	io_put_req_deferred(req, 1);
 	return HRTIMER_NORESTART;
 }
 
-- 
2.32.0

