Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B90560AD11
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbiJXORn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237190AbiJXOQH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:16:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0923A64D8;
        Mon, 24 Oct 2022 05:55:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C35961350;
        Mon, 24 Oct 2022 12:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588E8C433C1;
        Mon, 24 Oct 2022 12:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616127;
        bh=1HKoA20yZ1RA4LqmUTNBHh0p4auKpm9/eOH07oDCRqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Quq9yBF6SrqhSqJjP+/fYkpO5DzbFaiQVMXMnqDTamjHgSkhpGJOP7TPs6uqoaEr1
         9ZvNp17dXpnrvWK9+oJCpfbGcWW29e8t10dq9mwiU6Gvyf+KYyvg+eDnteqdSL18O1
         oy2SQ8DxCSqppMujr//YZIlFuvBbNb1KwW7zl7bA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 512/530] io_uring: correct pinned_vm accounting
Date:   Mon, 24 Oct 2022 13:34:16 +0200
Message-Id: <20221024113108.207176381@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ upstream commit 42b6419d0aba47c5d8644cdc0b68502254671de5 ]

->mm_account should be released only after we free all registered
buffers, otherwise __io_sqe_buffers_unregister() will see a NULL
->mm_account and skip locked_vm accounting.

Cc: <Stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/6d798f65ed4ab8db3664c4d3397d4af16ca98846.1664849932.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9303,11 +9303,6 @@ static void io_ring_ctx_free(struct io_r
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
@@ -9343,6 +9338,11 @@ static void io_ring_ctx_free(struct io_r
 #endif
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
+	if (ctx->mm_account) {
+		mmdrop(ctx->mm_account);
+		ctx->mm_account = NULL;
+	}
+
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
 


