Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1806161162
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 12:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgBQLsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 06:48:36 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41587 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728754AbgBQLsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 06:48:36 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 46CE221FFC;
        Mon, 17 Feb 2020 06:48:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 06:48:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=O0bLG+
        csCnH5zhgrpdA7mFglviUBJfw6bAL44YVLsX4=; b=oEPm5TQOs5aq3LexDUGFY0
        cjy6KT+KcNus97zKsrdEuBuYGbjo3vV3f+Fb7aG4A41pr6+HRfrVlS5Dg9VkJPtR
        hS8u0K6z0dxwUwRijiNOmG9RFIU4fJ6vkmh50CSXLpA3QLphH0fnUKcoAUQQlRpZ
        0DEH83UXhMdxgVenAnLC05rx88SUw/PW6G3HUIvunERJx2Aj7sfQvmavylZ4twR5
        9JST7uSQoK0Hv9pmab8a4o4BEPD9RqzfNc5M8sdC7fyLz9RVVq0Y3vVTvJF4wi4y
        +72vIzm9FWeIEBVyhb6+Dte4lHCzvja8VS34ZQy+8ngVYVelwZivEc5CckzNAB4A
        ==
X-ME-Sender: <xms:kn1KXmL9xnXjdta3DIVZBBUmvx1QerGCEiK9Sr6ws4IU_0kyz0rxbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:kn1KXmztiSKPUy5jmoPooTS7g8cfeVHGgT0-yCBUMxtJ5R2f7FqDjg>
    <xmx:kn1KXrL02kFWMjWvThNq_QlBS2-pnvGIaC3RjLrzgsAG3FwxwvmsEQ>
    <xmx:kn1KXu5G-UbAjSvmU9WsGbMDsZ8gKo-BGNw4NLsO3Jzu9aZWUOMXRA>
    <xmx:k31KXk1wF8exkdPaRwVBBMImBDkP2kMbl1b5JUuqq1yHET5zn63DwQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 376783060BE4;
        Mon, 17 Feb 2020 06:48:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: prune request from overflow list on flush" failed to apply to 5.5-stable tree
To:     axboe@kernel.dk, carter.li@eoitek.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 12:48:31 +0100
Message-ID: <1581940111189240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2ca10259b4189a433c309054496dd6af1415f992 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 13 Feb 2020 17:17:35 -0700
Subject: [PATCH] io_uring: prune request from overflow list on flush
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Carter reported an issue where he could produce a stall on ring exit,
when we're cleaning up requests that match the given file table. For
this particular test case, a combination of a few things caused the
issue:

- The cq ring was overflown
- The request being canceled was in the overflow list

The combination of the above means that the cq overflow list holds a
reference to the request. The request is canceled correctly, but since
the overflow list holds a reference to it, the final put won't happen.
Since the final put doesn't happen, the request remains in the inflight.
Hence we never finish the cancelation flush.

Fix this by removing requests from the overflow list if we're canceling
them.

Cc: stable@vger.kernel.org # 5.5
Reported-by: Carter Li 李通洲 <carter.li@eoitek.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6d4e20d59729..5a826017ebb8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -481,6 +481,7 @@ enum {
 	REQ_F_TIMEOUT_NOSEQ_BIT,
 	REQ_F_COMP_LOCKED_BIT,
 	REQ_F_NEED_CLEANUP_BIT,
+	REQ_F_OVERFLOW_BIT,
 };
 
 enum {
@@ -521,6 +522,8 @@ enum {
 	REQ_F_COMP_LOCKED	= BIT(REQ_F_COMP_LOCKED_BIT),
 	/* needs cleanup */
 	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
+	/* in overflow list */
+	REQ_F_OVERFLOW		= BIT(REQ_F_OVERFLOW_BIT),
 };
 
 /*
@@ -1103,6 +1106,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		req = list_first_entry(&ctx->cq_overflow_list, struct io_kiocb,
 						list);
 		list_move(&req->list, &list);
+		req->flags &= ~REQ_F_OVERFLOW;
 		if (cqe) {
 			WRITE_ONCE(cqe->user_data, req->user_data);
 			WRITE_ONCE(cqe->res, req->result);
@@ -1155,6 +1159,7 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 			set_bit(0, &ctx->sq_check_overflow);
 			set_bit(0, &ctx->cq_check_overflow);
 		}
+		req->flags |= REQ_F_OVERFLOW;
 		refcount_inc(&req->refs);
 		req->result = res;
 		list_add_tail(&req->list, &ctx->cq_overflow_list);
@@ -6463,6 +6468,29 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 		if (!cancel_req)
 			break;
 
+		if (cancel_req->flags & REQ_F_OVERFLOW) {
+			spin_lock_irq(&ctx->completion_lock);
+			list_del(&cancel_req->list);
+			cancel_req->flags &= ~REQ_F_OVERFLOW;
+			if (list_empty(&ctx->cq_overflow_list)) {
+				clear_bit(0, &ctx->sq_check_overflow);
+				clear_bit(0, &ctx->cq_check_overflow);
+			}
+			spin_unlock_irq(&ctx->completion_lock);
+
+			WRITE_ONCE(ctx->rings->cq_overflow,
+				atomic_inc_return(&ctx->cached_cq_overflow));
+
+			/*
+			 * Put inflight ref and overflow ref. If that's
+			 * all we had, then we're done with this request.
+			 */
+			if (refcount_sub_and_test(2, &cancel_req->refs)) {
+				io_put_req(cancel_req);
+				continue;
+			}
+		}
+
 		io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
 		io_put_req(cancel_req);
 		schedule();

