Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F55136A9AF
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 00:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhDYWfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Apr 2021 18:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbhDYWfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Apr 2021 18:35:39 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106B9C061574;
        Sun, 25 Apr 2021 15:34:59 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h15so1553734wre.11;
        Sun, 25 Apr 2021 15:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zi/QPK0GqftT+MgD38/Kj92k2eFo+KBZHf+PkUdeCTg=;
        b=Gz5ZzZN16NkZLGQTMWFXRPlZl9J4SLGNCTuFb1Y52FXGbERBP+qVtTPb9diCarX/SX
         GhXnGPL1Wc6ooysOTcLQ1WU7oVhkHBxq0FzdYbh/s9rrCF3gBymtgZxr4+ofua/+J4ri
         pUgW60BzQxc5dQ+rcO4gFoinnqNRqJRf/RsRHHGrDf70mTB0GI6hdMT3avfAIdO/PlJm
         8/QfbFjRggk/H7VHCL6HYSk3vZ7TWVdhFj9iG3zPnf0wFMvLp2CRv4Xn5+5hk+ZM8yMl
         J8I9G5Vlks8dTpnnH2a974H6vx1Fv+jSJlhnGkJdcrqhVCLOwg9ZVQhbPHs+eh960xJy
         QsuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zi/QPK0GqftT+MgD38/Kj92k2eFo+KBZHf+PkUdeCTg=;
        b=J9xmm4teAJKq8ItOy5a5xU9yP70kiPTPlEYyVGLg8aZf6lVVmPFvQqwugx19D0Q3bK
         sWIlMPykBNoQ3GJyFZ7gmLfSUA7Ayy3kUkbasQB02nN0Lb1XAFPYBdOenwLqbP0MM0Sy
         faHQug3iQZwwfg8g27iEJuQeJAjovMo8PfxlMaJacz1NXLTKLXKWirA7gWsxmQyw5pML
         1VIEudDwKLlYbVPudiERaFaCFEF2q2zDA8t2NEHo4hT/TD34vVVRlvGdzRwKpgk7lpC9
         GUiMaOPxC/Cc9hKOgp/+T5bOHJdmwTTK4zKZ6Iq8JRaMtJ54DMkfDRTEqFnTcKbh/EEB
         wMMw==
X-Gm-Message-State: AOAM533x2Ifq0QatcRvGCSBMPpRtCdA3HZpvdmX4HLyL7X9wgrHgndJ2
        JCJlyoucrmAXX/de+C47pzBPzqWAm2M=
X-Google-Smtp-Source: ABdhPJzGYCk4zSQQc33S/cEqAnWgkp7nSpHuMHe1VN2b+M8Q+7mOAd2xLhsjhaYqTmx6Tal5z/bNwA==
X-Received: by 2002:a5d:47ad:: with SMTP id 13mr19308756wrb.56.1619390097841;
        Sun, 25 Apr 2021 15:34:57 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id r2sm17353394wrt.79.2021.04.25.15.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 15:34:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: fix work_exit sqpoll cancellations
Date:   Sun, 25 Apr 2021 23:34:45 +0100
Message-Id: <a71a7fe345135d684025bb529d5cb1d8d6b46e10.1619389911.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619389911.git.asml.silence@gmail.com>
References: <cover.1619389911.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After closing an SQPOLL ring, io_ring_exit_work() kicks in and starts
doing cancellations via io_uring_try_cancel_requests(). It will go
through io_uring_try_cancel_iowq(), which uses ctx->tctx_list, but as
SQPOLL task don't have a ctx note, its io-wq won't be reachable and so
is left not cancelled.

It will eventually cancelled when one of the tasks dies, but if a thread
group survives for long and changes rings, it will spawn lots of
unreclaimed resources and live locked works.

Cancel SQPOLL task's io-wq separately in io_ring_exit_work().

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index eef373394ee9..640a4bc77aa6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8678,6 +8678,13 @@ static void io_tctx_exit_cb(struct callback_head *cb)
 	complete(&work->completion);
 }
 
+static bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
+{
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+
+	return req->ctx == data;
+}
+
 static void io_ring_exit_work(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
@@ -8694,6 +8701,17 @@ static void io_ring_exit_work(struct work_struct *work)
 	 */
 	do {
 		io_uring_try_cancel_requests(ctx, NULL, NULL);
+		if (ctx->sq_data) {
+			struct io_sq_data *sqd = ctx->sq_data;
+			struct task_struct *tsk;
+
+			io_sq_thread_park(sqd);
+			tsk = sqd->thread;
+			if (tsk && tsk->io_uring && tsk->io_uring->io_wq)
+				io_wq_cancel_cb(tsk->io_uring->io_wq,
+						io_cancel_ctx_cb, ctx, true);
+			io_sq_thread_unpark(sqd);
+		}
 
 		WARN_ON_ONCE(time_after(jiffies, timeout));
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
@@ -8843,13 +8861,6 @@ static bool io_cancel_defer_files(struct io_ring_ctx *ctx,
 	return true;
 }
 
-static bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
-{
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-
-	return req->ctx == data;
-}
-
 static bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 {
 	struct io_tctx_node *node;
-- 
2.31.1

