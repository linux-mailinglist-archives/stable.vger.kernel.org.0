Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CC03081D1
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 00:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbhA1X2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 18:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbhA1X2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 18:28:22 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D11EC061574;
        Thu, 28 Jan 2021 15:27:42 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id p15so7064807wrq.8;
        Thu, 28 Jan 2021 15:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0SUklcioMbX2XxFdr8rP2Sid7xI1SGXR5dl7dQ9jye8=;
        b=h2GJ1OpVB32u0K5TG+ANKqO/bdMJSYy9w6/0rIf+U3VHdx+5IHiFjQc2JxqQwALjqM
         O8kbClkugMsjgdkFaAweBFbmYnfPySbMxTKx9s26UKWoL67UUdE2JA9CYwrDMQI/Dd0d
         4lGsY706T1HlCZiijmG/3CfOQaYmZqMkA3gZ4kUH00QkTA3w/NsnPRl2CiRRGCg7Pgs5
         ml5jvXd0N7HnUQ2pCE0RM2tXxhsBWckvfkutfVi4YT+GwQmKcVDH6XI2fpGKNOj13wk0
         eHCL0KZVwEM07mydgiUGoK9WNQ5BtVmE71P6k+wHpNV1EatX0MAO/uZkalNHDZsq8vjr
         8AJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0SUklcioMbX2XxFdr8rP2Sid7xI1SGXR5dl7dQ9jye8=;
        b=PCZOecLVSZhMJDJZC+saYiMDYwvZ+5TYIX1F3kIVBuJFNw6g3kr8jgWlJA5SW6Lp/M
         P03oDwtEoq2qOStpq4k+pR5ptN9WGD1YQ3+1yyb48T7ZlTW5qk8aBVItmtR9149vn0Jv
         ZFISuSi+AwVBMTAJqsWMad/KAlcd7yN1yJ+7MNopmHplhMIQpOc0PmCquEkR7Rqzt1x5
         RkZIHKw69L+oaCKnFkORF2WK43ZNpYAm3CGPZ8NsjhTnwZCFdxrvSBnTaWBZHvUYO2pE
         k41UlSz4f86ne6KsZw11cs4Ia7zreU9N1IhE7gbdMNyDd0//h+GvE8J/hdw977anQols
         AjIw==
X-Gm-Message-State: AOAM533sxr1ioFGlIKicfddafVuY6l6au2LH7aJaHkETe/hIdxtZ/trR
        xpJuQRyl1kqVxs9aOkH8iuY=
X-Google-Smtp-Source: ABdhPJw3zsJFRnDypYz7P4YcOs0KGTNiNLrSolWUM5zvF0H65w7dU+ybPGRSwTdjxi1HjVfN+qTZaA==
X-Received: by 2002:a5d:4e92:: with SMTP id e18mr1539820wru.66.1611876461024;
        Thu, 28 Jan 2021 15:27:41 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.131])
        by smtp.gmail.com with ESMTPSA id v6sm8919587wrx.32.2021.01.28.15.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 15:27:40 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] io_uring: reinforce cancel on flush during exit
Date:   Thu, 28 Jan 2021 23:23:42 +0000
Message-Id: <c2a824f91bae5c5ea9ca2117fb22a2db55965782.1611876031.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

What 84965ff8a84f0 ("io_uring: if we see flush on exit, cancel related tasks")
really wants is to cancel all relevant REQ_F_INFLIGHT requests reliably.
That can be achieved by io_uring_cancel_files(), but we'll miss it
calling io_uring_cancel_task_requests(files=NULL) from io_uring_flush(),
because it will go through __io_uring_cancel_task_requests().

Just always call io_uring_cancel_files() during cancel, it's good enough
for now.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

p.s. fold in, maybe?

 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 12bf7180c0f1..38c6cbe1ab38 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8976,10 +8976,9 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	io_cancel_defer_files(ctx, task, files);
 	io_cqring_overflow_flush(ctx, true, task, files);
 
+	io_uring_cancel_files(ctx, task, files);
 	if (!files)
 		__io_uring_cancel_task_requests(ctx, task);
-	else
-		io_uring_cancel_files(ctx, task, files);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);
-- 
2.24.0

