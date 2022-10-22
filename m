Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4DCF608587
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiJVHen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiJVHe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:34:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D3610B9;
        Sat, 22 Oct 2022 00:34:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CBC260ADA;
        Sat, 22 Oct 2022 07:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFB4C433C1;
        Sat, 22 Oct 2022 07:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424058;
        bh=4JYcccYrPbaiYI/ym+uHOnTSOSvp7iMYJl+Av0/3swQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvjQKuNIorfqgjF9dwDBeyQzd86t5UaIsybI5vFqQzxD36c1mPwwgTc3I9YyyjQg8
         t7+1cA9v68/soja/gPR3UIQoni/0sMZUOndz0qVewxomW9Vcpbdgtmi/qcjDnp7xVJ
         CoiTDb/7CywSlg93Lwx7CjpqEJlQ+NZmsve8Q3Xo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stable@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.19 015/717] io_uring: correct pinned_vm accounting
Date:   Sat, 22 Oct 2022 09:18:14 +0200
Message-Id: <20221022072417.741102098@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 42b6419d0aba47c5d8644cdc0b68502254671de5 upstream.

->mm_account should be released only after we free all registered
buffers, otherwise __io_sqe_buffers_unregister() will see a NULL
->mm_account and skip locked_vm accounting.

Cc: <Stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/6d798f65ed4ab8db3664c4d3397d4af16ca98846.1664849932.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -10711,12 +10711,6 @@ static void io_flush_apoll_cache(struct
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
-
-	if (ctx->mm_account) {
-		mmdrop(ctx->mm_account);
-		ctx->mm_account = NULL;
-	}
-
 	io_rsrc_refs_drop(ctx);
 	/* __io_rsrc_put_work() may need uring_lock to progress, wait w/o it */
 	io_wait_rsrc_data(ctx->buf_data);
@@ -10755,6 +10749,10 @@ static __cold void io_ring_ctx_free(stru
 #endif
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
+	if (ctx->mm_account) {
+		mmdrop(ctx->mm_account);
+		ctx->mm_account = NULL;
+	}
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
 


