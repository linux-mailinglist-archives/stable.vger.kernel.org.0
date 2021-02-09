Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45CC3147AF
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 05:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhBIEwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 23:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhBIEwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 23:52:30 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C41C06178B
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 20:51:48 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id w2so29213008ejk.13
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 20:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tq00WglnuuSBa0sXsEQ7TSq+dFTnfHw/bnd9JGFw0oc=;
        b=ksRaUcnnr4Le6HEa7vPDrly30TFtRk551bhvw1AjUNIlQy6l0daqERf+Y6hGZnijRK
         S2dZohyh43wahXQhSS+lY3dq0Hc/7m1EOPxCHn88PcfKozBm+Ud/8w0wVF4yZFVdskHd
         0Pejocbda2ySQoXWMpLMddblVFrrry7ewFimbc9fLhoG3GBfcz7Ippp2mOdYl+5R+xSP
         IIe1EPpj8mXaCZe5kB1+PV6gCy7jVV7g5zxaffTrOvssQwH390eMod9vtAml8VeSlLqB
         Ysa0MKt1OA/8wPYdNWZuHKPA6h38Mmv/iQCD0kIBOdfMPLQ18pcFsw3txY9R2kzgIPIp
         68CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tq00WglnuuSBa0sXsEQ7TSq+dFTnfHw/bnd9JGFw0oc=;
        b=fUo7oBHkWVvc64kVvZqjVjeCztk+VNYTvV+pcq/MrJTrz2dSBP3i26YN24914BlJas
         kcjFk47lw3mPzzAhzk7SHHJxpozNaoLRXENkTkA2zlQbVfiD9Js0QZ4omgBg4Xj/rIJF
         cb1Tr0W0bROUF5wjW5wZIdQBxkDFEU73AV42h6HIAVNzHHCnEcK8aNCjMcY3MdfR2t8g
         UVYBhQswfpksULA9ZQA3//Cb44A/Z0rJ4P3MB1GEwO7A7purXRcIDI7cthlsKx+XGq+D
         T4d9jC6Dh8yAcLH/5zcM8tdMtXy5sFLqyFBpSN0Ubc4/dfRU2EnIq8sNKllVOXmhDFto
         gEzg==
X-Gm-Message-State: AOAM530mBgFmTk2JGqvd9mQa3xrNO4pGP0Y21u/aI0jp8x2xVurFFMq0
        qEWS504ZerWVtjr63wtVk/RhWP+xC8U=
X-Google-Smtp-Source: ABdhPJzzueM3EYnpgwhDxoZZDOXtHyOuOkSHwYi0IOJduEkPeX3UTZ1P07k7PLpIBkFvVXGud6NnuA==
X-Received: by 2002:a17:906:2353:: with SMTP id m19mr20773416eja.13.1612846307167;
        Mon, 08 Feb 2021 20:51:47 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id g9sm9973445ejp.55.2021.02.08.20.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 20:51:46 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/16] io_uring: don't iterate io_uring_cancel_files()
Date:   Tue,  9 Feb 2021 04:47:37 +0000
Message-Id: <509b0588dfa044d9f835bcc8a53d847b5e26de3e.1612845821.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612845821.git.asml.silence@gmail.com>
References: <cover.1612845821.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b52fda00dd9df8b4a6de5784df94f9617f6133a1 ]

io_uring_cancel_files() guarantees to cancel all matching requests,
that's not necessary to do that in a loop. Move it up in the callchain
into io_uring_cancel_task_requests().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 71bdd288c396..b8c413830722 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8654,16 +8654,10 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 	}
 }
 
-/*
- * Returns true if we found and killed one or more files pinning requests
- */
-static bool io_uring_cancel_files(struct io_ring_ctx *ctx,
+static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct task_struct *task,
 				  struct files_struct *files)
 {
-	if (list_empty_careful(&ctx->inflight_list))
-		return false;
-
 	while (!list_empty_careful(&ctx->inflight_list)) {
 		struct io_kiocb *cancel_req = NULL, *req;
 		DEFINE_WAIT(wait);
@@ -8698,8 +8692,6 @@ static bool io_uring_cancel_files(struct io_ring_ctx *ctx,
 		schedule();
 		finish_wait(&ctx->inflight_wait, &wait);
 	}
-
-	return true;
 }
 
 static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
@@ -8710,15 +8702,12 @@ static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 	return io_task_match(req, task);
 }
 
-static bool __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
-					    struct task_struct *task,
-					    struct files_struct *files)
+static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
+					    struct task_struct *task)
 {
-	bool ret;
-
-	ret = io_uring_cancel_files(ctx, task, files);
-	if (!files) {
+	while (1) {
 		enum io_wq_cancel cret;
+		bool ret = false;
 
 		cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, task, true);
 		if (cret != IO_WQ_CANCEL_NOTFOUND)
@@ -8734,9 +8723,11 @@ static bool __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 
 		ret |= io_poll_remove_all(ctx, task);
 		ret |= io_kill_timeouts(ctx, task);
+		if (!ret)
+			break;
+		io_run_task_work();
+		cond_resched();
 	}
-
-	return ret;
 }
 
 static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
@@ -8771,11 +8762,10 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 
 	io_cancel_defer_files(ctx, task, files);
 	io_cqring_overflow_flush(ctx, true, task, files);
+	io_uring_cancel_files(ctx, task, files);
 
-	while (__io_uring_cancel_task_requests(ctx, task, files)) {
-		io_run_task_work();
-		cond_resched();
-	}
+	if (!files)
+		__io_uring_cancel_task_requests(ctx, task);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);
-- 
2.24.0

