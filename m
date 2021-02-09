Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A5C3147B0
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 05:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhBIEwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 23:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhBIEwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 23:52:30 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BD1C06178C
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 20:51:49 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id lg21so29292821ejb.3
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 20:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xi83M1slqcltCzGHOBrGfIyKm/mN4UMohf4bfSCTu/A=;
        b=Jvu8kL9zC7mYW+Kn7WVkmg9NaMlSx3A+mqFMNUHTtEXlvkBV/71MJjhzh7pPOvT2L/
         bOLIKfU+G2o8xLMJ36PnnWhaWEfw6r54vS2zBmywbXj0b8NOkxpseiaxf2KRlqdReNkB
         EdAJyreCeg4WQLmAI908QgQqrUbeFX2Rb8yrky9EZgdyht0C46GGHZOXQBAFwOLFCmyW
         7fq9HkAFxmmyndRLZaMODd7WZMdgX3TEriD50RSu1qh18xAkh1FvV4+ZiCwNqJyV46/Y
         7GcrtjIpSp3+AG9suPuhBT8fzkrnMLj0nBupxjRf2St+Fk/utqSLVnssorEQGsoHEm0h
         9Jcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xi83M1slqcltCzGHOBrGfIyKm/mN4UMohf4bfSCTu/A=;
        b=sDBTjkEve1nURXcAlv0J18Ak3u6kOXNI3t8mR3+/Vk2WC11lbQobKBiTrZobQacG6X
         XXxkdqyRq/+y/Z0EFgEMaLOZdFNKwrSlANWgQuI5iRY5ZRunwXgMJkxBKKHMpnceloSd
         Vk4oFjX2anDbIzUCfv1xnLki6gR0WFl05a9c2sjI/qT0IWy3YOXO7lNbjVZybuyxl+9b
         735O9tvul+jxGr2VMqIoKqn4Xdupqc3nfDs6zvLZoQNYUz4UgGRjTJXKd7xe2YgPJS03
         Tma611GGsSFAkTNZqk83YL7YUnOXXicgdjfziATaWr6INUcIrA0qar2FQyUipaYgtCDm
         eGkQ==
X-Gm-Message-State: AOAM532FxEKT0RPKV8HSRKHXUCgaiRFo4yDejMnaN7HRodoxssmisJ5C
        vZhl5FMknUPkAfykup7ZgqSLGi8Yypc=
X-Google-Smtp-Source: ABdhPJxbohUWEfa5rymuVddAXOplq86ZRWwGWp8GBD62vkBzkArOmhlVf/W+8DZqJChQ7lKacGN4vw==
X-Received: by 2002:a17:906:688f:: with SMTP id n15mr20584824ejr.71.1612846308201;
        Mon, 08 Feb 2021 20:51:48 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id g9sm9973445ejp.55.2021.02.08.20.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 20:51:47 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/16] io_uring: pass files into kill timeouts/poll
Date:   Tue,  9 Feb 2021 04:47:38 +0000
Message-Id: <31743a2f1ca3e27f52e1b678147fb2022c2d85a1.1612845821.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612845821.git.asml.silence@gmail.com>
References: <cover.1612845821.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6b81928d4ca8668513251f9c04cdcb9d38ef51c7 ]

Make io_poll_remove_all() and io_kill_timeouts() to match against files
as well. A preparation patch, effectively not used by now.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b8c413830722..0a9f938ac3a1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1508,14 +1508,15 @@ static bool io_task_match(struct io_kiocb *req, struct task_struct *tsk)
 /*
  * Returns true if we found and killed one or more timeouts
  */
-static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk)
+static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
+			     struct files_struct *files)
 {
 	struct io_kiocb *req, *tmp;
 	int canceled = 0;
 
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
-		if (io_task_match(req, tsk)) {
+		if (io_match_task(req, tsk, files)) {
 			io_kill_timeout(req);
 			canceled++;
 		}
@@ -5312,7 +5313,8 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 /*
  * Returns true if we found and killed one or more poll requests
  */
-static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk)
+static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
+			       struct files_struct *files)
 {
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
@@ -5324,7 +5326,7 @@ static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk)
 
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
-			if (io_task_match(req, tsk))
+			if (io_match_task(req, tsk, files))
 				posted += io_poll_remove_one(req);
 		}
 	}
@@ -8485,8 +8487,8 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	mutex_unlock(&ctx->uring_lock);
 
-	io_kill_timeouts(ctx, NULL);
-	io_poll_remove_all(ctx, NULL);
+	io_kill_timeouts(ctx, NULL, NULL);
+	io_poll_remove_all(ctx, NULL, NULL);
 
 	if (ctx->io_wq)
 		io_wq_cancel_cb(ctx->io_wq, io_cancel_ctx_cb, ctx, true);
@@ -8721,8 +8723,8 @@ static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 			}
 		}
 
-		ret |= io_poll_remove_all(ctx, task);
-		ret |= io_kill_timeouts(ctx, task);
+		ret |= io_poll_remove_all(ctx, task, NULL);
+		ret |= io_kill_timeouts(ctx, task, NULL);
 		if (!ret)
 			break;
 		io_run_task_work();
-- 
2.24.0

