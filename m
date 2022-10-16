Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9088D600383
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 23:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJPVpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 17:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiJPVpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 17:45:13 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B1632074
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 14:45:11 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id 13so21083476ejn.3
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 14:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mtfLHf4OHU1GYJB3DtZRaqAPI4ieoi5EqL3We5xhRFE=;
        b=iYrbYamF2DTT9uWQ5XxyJ0/dJvd3cH7P1e//DQudp5SLP2hrrRHYbkkEjTc/E0uSOp
         Eb/2PeeFUVmuOwJH5EuhfXDXNnrrVpYj4Pmk0fJB0cia18WCnZ9gcyzcZptoERSMB+2X
         7c3G4x/pui7WISRLa1a66hh+i9tu9m1r1uD4FpWqDHYqyimTJ20je0ylOcTE+9nIw7Gv
         e7QT83Xjwn9k3M1hwh08rb/EvwgIDuqS1k7rwClwpWCydkLPM2ZKo/e2oIrdj7xVSNNM
         DQwFbfk+13glZOMHHXQ3NReYLl89DxqdZHI2lj1VQYNvmdBMlT/8eB392cHCz7vRfzGp
         vokQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mtfLHf4OHU1GYJB3DtZRaqAPI4ieoi5EqL3We5xhRFE=;
        b=MjMjz5MvV/2gu4Af9rbkYC4+ld51v2t4QCq7MDHvVe/B2EUiph/qT7alB+AiqD1cC1
         Cd8sL+dM8/dYl+t6HaJoGftBfoBacj/GU7AYq97eVyTuTYFz8MBNgLwtMWqYUOYxWn0R
         ITAE0K9s20fH7iXNTGP5bTH2AK0kTdsxNuh3wbFEq85pl4VQkwFs1z/hl7AhjgHShWeP
         hRdewCM93LhCD5PTPogxjnm8y/lqZ9Lon10/N0oThgF22CK//3M4JfdnSRsre2E4jJ1t
         QpyyK4qAxRfzCgt1mmAyhPUVohh3v5FLviPW70y6YUeG7ZRKjPADhMHARPffd4iJZz5j
         +D+A==
X-Gm-Message-State: ACrzQf1ax9YFuuVwpIQXKHkIo4R/bR9GX8YPufnHMEXj8ajGkljR+eVv
        o7FAruFkVpKfzeBpwQL96kvqgna6NTM=
X-Google-Smtp-Source: AMsMyM5m0QTj+Zba2AY312aLAbL5gxB//NG9OsMiU6u5P+4nbHgMnrsb+Et8tnB+iu7NGqq6xWhtAw==
X-Received: by 2002:a17:907:2bd4:b0:78d:48c9:29b0 with SMTP id gv20-20020a1709072bd400b0078d48c929b0mr6106660ejc.562.1665956709707;
        Sun, 16 Oct 2022 14:45:09 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090676c600b0078c47463277sm5177331ejn.96.2022.10.16.14.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 14:45:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 2/5] io_uring: correct pinned_vm accounting
Date:   Sun, 16 Oct 2022 22:42:55 +0100
Message-Id: <01e0607d0e179bae74e60809bc9e805369205132.1665954636.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1665954636.git.asml.silence@gmail.com>
References: <cover.1665954636.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commit 42b6419d0aba47c5d8644cdc0b68502254671de5 ]

->mm_account should be released only after we free all registered
buffers, otherwise __io_sqe_buffers_unregister() will see a NULL
->mm_account and skip locked_vm accounting.

Cc: <Stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/6d798f65ed4ab8db3664c4d3397d4af16ca98846.1664849932.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1b0e83fdea7a..2da7a490d1c7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9302,11 +9302,6 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
 
-	if (ctx->mm_account) {
-		mmdrop(ctx->mm_account);
-		ctx->mm_account = NULL;
-	}
-
 	/* __io_rsrc_put_work() may need uring_lock to progress, wait w/o it */
 	io_wait_rsrc_data(ctx->buf_data);
 	io_wait_rsrc_data(ctx->file_data);
@@ -9342,6 +9337,11 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 #endif
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
+	if (ctx->mm_account) {
+		mmdrop(ctx->mm_account);
+		ctx->mm_account = NULL;
+	}
+
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
 
-- 
2.38.0

