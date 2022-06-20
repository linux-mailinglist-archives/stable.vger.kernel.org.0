Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C1E551898
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 14:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242238AbiFTMOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242591AbiFTMOW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:14:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C64118B2B
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 05:14:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABD4E613F8
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 12:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9E2C3411C;
        Mon, 20 Jun 2022 12:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655727259;
        bh=6j1BgUwFvezsSWrboXKMYhtIjNEEyCIIF8dRtwEgZu4=;
        h=Subject:To:Cc:From:Date:From;
        b=R9vhMU8o7VwDPrq1Ga4+h2imevDUh4j7JYYX1BUoaoF6n7D+/GYNO7MM1kub4iJ+v
         HahjfR1NUCWb77UJJaMtz8R1Y1QTkBcksIHpcOOV/P8TTQbhpPZWamwpKRKzDzwvme
         M77TuZQh3XelSDLCYPEohQWILpK/pluJFPKrvrfk=
Subject: FAILED: patch "[PATCH] io_uring: fix not locked access to fixed buf table" failed to apply to 5.15-stable tree
To:     asml.silence@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 14:14:08 +0200
Message-ID: <1655727248167248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 05b538c1765f8d14a71ccf5f85258dcbeaf189f7 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Thu, 9 Jun 2022 08:34:35 +0100
Subject: [PATCH] io_uring: fix not locked access to fixed buf table

We can look inside the fixed buffer table only while holding
->uring_lock, however in some cases we don't do the right async prep for
IORING_OP_{WRITE,READ}_FIXED ending up with NULL req->imu forcing making
an io-wq worker to try to resolve the fixed buffer without proper
locking.

Move req->imu setup into early req init paths, i.e. io_prep_rw(), which
is called unconditionally for rw requests and under uring_lock.

Fixes: 634d00df5e1cf ("io_uring: add full-fledged dynamic buffers support")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index be05f375a776..fd8a1ffe6a1a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3636,6 +3636,20 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	int ret;
 
 	kiocb->ki_pos = READ_ONCE(sqe->off);
+	/* used for fixed read/write too - just read unconditionally */
+	req->buf_index = READ_ONCE(sqe->buf_index);
+
+	if (req->opcode == IORING_OP_READ_FIXED ||
+	    req->opcode == IORING_OP_WRITE_FIXED) {
+		struct io_ring_ctx *ctx = req->ctx;
+		u16 index;
+
+		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
+			return -EFAULT;
+		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
+		req->imu = ctx->user_bufs[index];
+		io_req_set_rsrc_node(req, ctx, 0);
+	}
 
 	ioprio = READ_ONCE(sqe->ioprio);
 	if (ioprio) {
@@ -3648,12 +3662,9 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		kiocb->ki_ioprio = get_current_ioprio();
 	}
 
-	req->imu = NULL;
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
 	req->rw.flags = READ_ONCE(sqe->rw_flags);
-	/* used for fixed read/write too - just read unconditionally */
-	req->buf_index = READ_ONCE(sqe->buf_index);
 	return 0;
 }
 
@@ -3785,20 +3796,9 @@ static int __io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter
 static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter,
 			   unsigned int issue_flags)
 {
-	struct io_mapped_ubuf *imu = req->imu;
-	u16 index, buf_index = req->buf_index;
-
-	if (likely(!imu)) {
-		struct io_ring_ctx *ctx = req->ctx;
-
-		if (unlikely(buf_index >= ctx->nr_user_bufs))
-			return -EFAULT;
-		io_req_set_rsrc_node(req, ctx, issue_flags);
-		index = array_index_nospec(buf_index, ctx->nr_user_bufs);
-		imu = READ_ONCE(ctx->user_bufs[index]);
-		req->imu = imu;
-	}
-	return __io_import_fixed(req, rw, iter, imu);
+	if (WARN_ON_ONCE(!req->imu))
+		return -EFAULT;
+	return __io_import_fixed(req, rw, iter, req->imu);
 }
 
 static int io_buffer_add_list(struct io_ring_ctx *ctx,

