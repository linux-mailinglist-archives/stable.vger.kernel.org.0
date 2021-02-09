Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE90B3147BC
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 05:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhBIExh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 23:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbhBIEx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 23:53:27 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521D2C06121E
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 20:52:01 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id f14so29254006ejc.8
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 20:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s61aGjjqahl4JKgzDvB3FLYKY5kavUzgJ00+m2swdPI=;
        b=erBR8uuu5iYfYfCKTlby5qzXm/2MmmyaKmMqF+0aqQxtohYmrr1Y9EU0La19ySU3Zk
         ZrfUXyS66gisq70i/mAP0wdlJB+my4nPFSMczrb+1LiLf9RUbJQIdJZcycC+xuECqAZL
         WU8Q6trL7lzc5UKuuwvz3wCOaP9L9RVDYK5Gzr9QKWGqX8S7w5mbgjUp2xS0OInNqm/a
         ouCr7SIyGo7rtB5k6kfPZRZ+QG2c3Jl2yt7XuB4nIdQGxcKdoSEDUpyKqNj/WUmgR1fb
         ZrjqBx2tJB2iMM+dfG+9cGa7OMrIGY+0/Qw7QwdOxHFAN74QlM4nE5c/DATpZ/zDvbwE
         UvOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s61aGjjqahl4JKgzDvB3FLYKY5kavUzgJ00+m2swdPI=;
        b=Rx2S/pgyhfp49OICTQ7W1QVp8PGNm+b9NvtXdRQuLPrO8cwtB6hY09NCzUBfIl9Lg3
         qQj452ETKoscAI8gf678kzv22LwdVOnDGWp9UAe6I5Mfs8jpc2dCa1VjZIxPt/ez9Gth
         LZqshdEhB+xVepu2pSu1Lf/iY/wh6NIBQETv+5M5c1ssh4osSClOXICh95wXSyivf6lz
         wiYJOyocR8MbfAnCIZcI3TJp4YgSzVaw5z7pvqggsHW96yj/J6M+Pk1pekcagX98+eM4
         sYw3Cp6k9JlYBPd/Y3cOGTGhXhzH9eL1xzNIHxRdub8ZfOzebJuxN1Zx9svspBUgQ8xe
         kKaw==
X-Gm-Message-State: AOAM531OxICqUixRzzis0NprVXwQXzBbn58lzthqCaHYL0HibezxwsVB
        SadBqbtU/yXorasq/bq4SGtfgfLC9FM=
X-Google-Smtp-Source: ABdhPJy3/osHMeTHp1sI3qVp5JSXSr9y6BKkkRCM3xZ6di1XfPKhcaYHanmnXkbEYb74lBVULwX8ZA==
X-Received: by 2002:a17:906:3603:: with SMTP id q3mr15381538ejb.201.1612846319941;
        Mon, 08 Feb 2021 20:51:59 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id g9sm9973445ejp.55.2021.02.08.20.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 20:51:59 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 15/16] io_uring: reinforce cancel on flush during exit
Date:   Tue,  9 Feb 2021 04:47:49 +0000
Message-Id: <d21244b38449a70f59637f73e889e9d022a65217.1612845821.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612845821.git.asml.silence@gmail.com>
References: <cover.1612845821.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3a7efd1ad269ccaf9c1423364d97c9661ba6dafa ]

What 84965ff8a84f0 ("io_uring: if we see flush on exit, cancel related tasks")
really wants is to cancel all relevant REQ_F_INFLIGHT requests reliably.
That can be achieved by io_uring_cancel_files(), but we'll miss it
calling io_uring_cancel_task_requests(files=NULL) from io_uring_flush(),
because it will go through __io_uring_cancel_task_requests().

Just always call io_uring_cancel_files() during cancel, it's good enough
for now.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0bda8cc25845..5eaf3a7badcc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8692,10 +8692,9 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
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

