Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B284E6810B3
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237046AbjA3OFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237072AbjA3OFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:05:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7823D11670
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:05:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1503A61034
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2887CC433D2;
        Mon, 30 Jan 2023 14:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087548;
        bh=olP8qaEoHY4JxM9omDC91K4yhdjk4v7OkoiIzzGVBoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLJwyfdxvVupaKrV0TAWG+8LDkitAX1uX/takptFKyAGW/Pt/M25kkUWqbEtrZMvX
         eYoPzGmdwsi+egF/rKQPWn5P+ebOunX8JlgNpALiRugtZZGBsQMdxjMk3gGIx7SyoM
         9VOhL5U3G9d4tRHX7V6pusseDR3qfAXUQb7hUkRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 245/313] io_uring: inline __io_req_complete_put()
Date:   Mon, 30 Jan 2023 14:51:20 +0100
Message-Id: <20230130134348.110369907@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit fa18fa2272c7469e470dcb7bf838ea50a25494ca ]

Inline __io_req_complete_put() into io_req_complete_post(), there are no
other users.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1923a4dfe80fa877f859a22ed3df2d5fc8ecf02b.1669203009.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: ef5c600adb1d ("io_uring: always prep_async for drain requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 50f959ffb55c..13a60f51b283 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -823,15 +823,19 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx,
 	return filled;
 }
 
-static void __io_req_complete_put(struct io_kiocb *req)
+void io_req_complete_post(struct io_kiocb *req)
 {
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_cq_lock(ctx);
+	if (!(req->flags & REQ_F_CQE_SKIP))
+		__io_fill_cqe_req(ctx, req);
+
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
 	 */
 	if (req_ref_put_and_test(req)) {
-		struct io_ring_ctx *ctx = req->ctx;
-
 		if (req->flags & IO_REQ_LINK_FLAGS) {
 			if (req->flags & IO_DISARM_MASK)
 				io_disarm_next(req);
@@ -852,16 +856,6 @@ static void __io_req_complete_put(struct io_kiocb *req)
 		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
 		ctx->locked_free_nr++;
 	}
-}
-
-void io_req_complete_post(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	io_cq_lock(ctx);
-	if (!(req->flags & REQ_F_CQE_SKIP))
-		__io_fill_cqe_req(ctx, req);
-	__io_req_complete_put(req);
 	io_cq_unlock_post(ctx);
 }
 
-- 
2.39.0



