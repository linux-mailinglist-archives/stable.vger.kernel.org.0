Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7F26003EF
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 00:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiJPWdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 18:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiJPWdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 18:33:47 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637CC28E0B
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:33:46 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id d26so21168286ejc.8
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f+ihA93Yd1s8IYxB3RO4gGBNd3B65+Ou1tjE2Uq0SIk=;
        b=LWCbzEs9Hp/3YR/BmbCwaC+SV27YvinMo12f9exOhTLZGPW8SKFmyg0i6mPP5b+iFR
         rt0lhVUgXC8NVmxOYGiUsPq7Wik1u7vjvtzy3iyx5GYyfqkibmnklz4f6D12T9p5EoWe
         3AGrXHX3Th5jwZ412mVIRxZbAqz8RjuI6IlPPGI5dhU5IwFR3rbQNjRR2ypQPepXmqQg
         q+XybNWUgsjXAR8Oc3v6iuWRTDoRQFujRON7xZJnbVOmk+6Zcbg7lpDv9VC47urHA1GS
         OETPfl0rompYlEtCcqd/IUhP1idHSolg7pzdv8o2+N2klPIl/B9hbuKaQF5D4NuCUhqx
         2hCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f+ihA93Yd1s8IYxB3RO4gGBNd3B65+Ou1tjE2Uq0SIk=;
        b=FQ6auN54AJNblnUFG0uCY1KZ3cMCIWuqi/bDS668AeWDKG9JVEBzJkALGMQFszi58N
         b2iS8hjfbK9oDd7qkpypjQNMmR2HjrvA38E6loSVuVYxVLaq0VzP8hUqVvsLjRWIDLAG
         NoDmEiOonIPIZeqt9tk7Lx8oBTPyczx3tIQ6YfRw5HiY8ndsOq/rdB9xoiLngg5DOlYN
         Rhsav24iSV2vKzhnU+QhXHpgBRjjCG00pZYKxTOZnSIYY6ut/ALLC8tsEBh7P5YDSccu
         Dl07Vt6wKPB5mN0lOtSvHhjfOzjqvKqhmUdpH9Bs9Mevd/0yFCuLHViq7aRaOpJC6Poj
         H8FQ==
X-Gm-Message-State: ACrzQf3Wf50ZG+aRwd9+jpR4HKuADBg8WfkeWGyvfnmny1NTT8EoBD34
        7PkQVV6vUpcyRZHq3Wl6t0DXYvIBf9A=
X-Google-Smtp-Source: AMsMyM4DfqwgFAKSjytUzzsJwyCakUU/mfBnTq5EHSFv+pGMaxDN8v2qV6MHzDwP5lkrrCzLoPRv+Q==
X-Received: by 2002:a17:907:72c1:b0:783:34ce:87b9 with SMTP id du1-20020a17090772c100b0078334ce87b9mr6422640ejc.115.1665959624657;
        Sun, 16 Oct 2022 15:33:44 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id jt3-20020a170906dfc300b0078db5bddd9csm5193496ejc.22.2022.10.16.15.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 15:33:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.10 1/2] io_uring: correct pinned_vm accounting
Date:   Sun, 16 Oct 2022 23:31:25 +0100
Message-Id: <24dd0e2b9c4cdcff826a5370a68ad7a953ecb648.1665959215.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1665959215.git.asml.silence@gmail.com>
References: <cover.1665959215.git.asml.silence@gmail.com>
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
 fs/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9654b60a06a5..b82a446d5e59 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8436,8 +8436,6 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (ctx->sqo_task) {
 		put_task_struct(ctx->sqo_task);
 		ctx->sqo_task = NULL;
-		mmdrop(ctx->mm_account);
-		ctx->mm_account = NULL;
 	}
 
 #ifdef CONFIG_BLK_CGROUP
@@ -8456,6 +8454,11 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	}
 #endif
 
+	if (ctx->mm_account) {
+		mmdrop(ctx->mm_account);
+		ctx->mm_account = NULL;
+	}
+
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
 
-- 
2.38.0

