Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6065FFDBE
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 09:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJPHIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 03:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiJPHIu (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 16 Oct 2022 03:08:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF42A38A13
        for <Stable@vger.kernel.org>; Sun, 16 Oct 2022 00:08:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 912FDB80B71
        for <Stable@vger.kernel.org>; Sun, 16 Oct 2022 07:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C1CC433C1;
        Sun, 16 Oct 2022 07:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665904127;
        bh=Mo2BgkXGsucMyVr1L5dTTI0b6i/4j+cRM8HVCPMx8fc=;
        h=Subject:To:Cc:From:Date:From;
        b=TLz/dn2zPva2HWf21y6YVGCvTvmNIivke0TrsrQnWP+3fyWjOKdFFFAFDwfnr7MOz
         seBpTMdoxFIJMq1qBsxkK0PO43UtcOMXsW4KHXRiTN4MimXHlS0dgIqsAJYVTMZmXF
         IMu+SzfE9zZGaRZtyTR3NCOMb9bUm9hVAZUh4gBs=
Subject: FAILED: patch "[PATCH] io_uring: correct pinned_vm accounting" failed to apply to 5.15-stable tree
To:     asml.silence@gmail.com, Stable@vger.kernel.org, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 09:09:33 +0200
Message-ID: <166590417369215@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

42b6419d0aba ("io_uring: correct pinned_vm accounting")
ed29b0b4fd83 ("io_uring: move to separate directory")
ab4094024784 ("io_uring: optimise rsrc referencing")
a46be971edb6 ("io_uring: optimise io_req_set_rsrc_node()")
d886e185a128 ("io_uring: control ->async_data with a REQ_F flag")
ef05d9ebcc92 ("io_uring: kill off ->inflight_entry field")
d4b7a5ef2b9c ("io_uring: inline completion batching helpers")
3aa83bfb6e5c ("io_uring: add a helper for batch free")
c2b6c6bc4e0d ("io_uring: replace list with stack for req caches")
3ab665b74e59 ("io_uring: remove allocation cache array")
6f33b0bc4ea4 ("io_uring: use slist for completion batching")
c450178d9be9 ("io_uring: dedup CQE flushing non-empty checks")
4b628aeb69cc ("io_uring: kill off ios_left")
4c928904ff77 ("block: move CONFIG_BLOCK guard to top Makefile")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 42b6419d0aba47c5d8644cdc0b68502254671de5 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Tue, 4 Oct 2022 03:19:08 +0100
Subject: [PATCH] io_uring: correct pinned_vm accounting

->mm_account should be released only after we free all registered
buffers, otherwise __io_sqe_buffers_unregister() will see a NULL
->mm_account and skip locked_vm accounting.

Cc: <Stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/6d798f65ed4ab8db3664c4d3397d4af16ca98846.1664849932.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 63f6ce5e5355..ea5cee593bbd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2585,12 +2585,6 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
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
@@ -2633,6 +2627,10 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 	WARN_ON_ONCE(ctx->notif_slots || ctx->nr_notif_slots);
 
+	if (ctx->mm_account) {
+		mmdrop(ctx->mm_account);
+		ctx->mm_account = NULL;
+	}
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
 

