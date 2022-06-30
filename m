Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2C1561CD2
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236761AbiF3OKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236759AbiF3OKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:10:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEC779728;
        Thu, 30 Jun 2022 06:55:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77610B82AEE;
        Thu, 30 Jun 2022 13:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3DFC34115;
        Thu, 30 Jun 2022 13:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597320;
        bh=bC4dbYqaiI9cHdVVOeiAurkri0bMBe9DGGDutSfc0fQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTso+POVxVG00B+RyKmxOHw/7qEXk/wjXuUI03XAFY8n9F3Tfuqxz+dAcZmoVzJox
         tYwbuC7uTPwub1CbDxt8fOfGBeKGtMe/i88/JNwvoxsvvvfpQpNg3CXwv183+CIWrA
         Vtc52cV0q7MIgwgC7djFIkqbejEIT8jEk0sLabIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.15 28/28] io_uring: fix not locked access to fixed buf table
Date:   Thu, 30 Jun 2022 15:47:24 +0200
Message-Id: <20220630133233.758061530@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
References: <20220630133232.926711493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 05b538c1765f8d14a71ccf5f85258dcbeaf189f7 upstream.

We can look inside the fixed buffer table only while holding
->uring_lock, however in some cases we don't do the right async prep for
IORING_OP_{WRITE,READ}_FIXED ending up with NULL req->imu forcing making
an io-wq worker to try to resolve the fixed buffer without proper
locking.

Move req->imu setup into early req init paths, i.e. io_prep_rw(), which
is called unconditionally for rw requests and under uring_lock.

Fixes: 634d00df5e1cf ("io_uring: add full-fledged dynamic buffers support")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2932,15 +2932,24 @@ static int io_prep_rw(struct io_kiocb *r
 		kiocb->ki_complete = io_complete_rw;
 	}
 
+	/* used for fixed read/write too - just read unconditionally */
+	req->buf_index = READ_ONCE(sqe->buf_index);
+	req->imu = NULL;
+
 	if (req->opcode == IORING_OP_READ_FIXED ||
 	    req->opcode == IORING_OP_WRITE_FIXED) {
-		req->imu = NULL;
+		struct io_ring_ctx *ctx = req->ctx;
+		u16 index;
+
+		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
+			return -EFAULT;
+		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
+		req->imu = ctx->user_bufs[index];
 		io_req_set_rsrc_node(req);
 	}
 
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
-	req->buf_index = READ_ONCE(sqe->buf_index);
 	return 0;
 }
 
@@ -3066,18 +3075,9 @@ static int __io_import_fixed(struct io_k
 
 static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_mapped_ubuf *imu = req->imu;
-	u16 index, buf_index = req->buf_index;
-
-	if (likely(!imu)) {
-		if (unlikely(buf_index >= ctx->nr_user_bufs))
-			return -EFAULT;
-		index = array_index_nospec(buf_index, ctx->nr_user_bufs);
-		imu = READ_ONCE(ctx->user_bufs[index]);
-		req->imu = imu;
-	}
-	return __io_import_fixed(req, rw, iter, imu);
+	if (WARN_ON_ONCE(!req->imu))
+		return -EFAULT;
+	return __io_import_fixed(req, rw, iter, req->imu);
 }
 
 static void io_ring_submit_unlock(struct io_ring_ctx *ctx, bool needs_lock)


