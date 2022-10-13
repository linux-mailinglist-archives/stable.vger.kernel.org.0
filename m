Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE1F5FCFAC
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiJMAUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiJMATw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:19:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997B718C964;
        Wed, 12 Oct 2022 17:17:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6B1E616CF;
        Thu, 13 Oct 2022 00:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AFAC43470;
        Thu, 13 Oct 2022 00:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620255;
        bh=CsHxDoZ+/dYYLqL/Nt4EJ0X73AKDJKUYh5A/bZrTH2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cYRfO4EmIw3RplBvIN5myAxpro2sFzssJNrjadi1lu/J1nJTSDmqvBn57OZjDPYb+
         LdpyUt2C5CjtK9FiG0bq8u16VMFOkFvy66+uI+ctJ/0Kgth4FXauhSbwPAO3Ez4W+X
         688qy/P1NcMMYobA5Ajso35nbCUJuu1L8RhohPXhDj4FgPP3XZMN4Au2kwaeBy/aTg
         9BGh7hwKRYPMWYUzL4fNf2sU/HbmA/5e8qI4Fy6oZrvawMKLkiLJNdJk1S/dIkJZz/
         Yj/KVxzsyfCIZKvAtVi+pjXj2M0FPa5NufbbG8XOL4ZYNLOc24/zWnaz9Jnpse5YPV
         4n6jy7jjyBlyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 44/67] io_uring: fix CQE reordering
Date:   Wed, 12 Oct 2022 20:15:25 -0400
Message-Id: <20221013001554.1892206-44-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001554.1892206-1-sashal@kernel.org>
References: <20221013001554.1892206-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit aa1df3a360a0c50e0f0086a785d75c2785c29967 ]

Overflowing CQEs may result in reordering, which is buggy in case of
links, F_MORE and so on. If we guarantee that we don't reorder for
the unlikely event of a CQ ring overflow, then we can further extend
this to not have to terminate multishot requests if it happens. For
other operations, like zerocopy sends, we have no choice but to honor
CQE ordering.

Reported-by: Dylan Yudaken <dylany@fb.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/ec3bc55687b0768bbe20fb62d7d06cfced7d7e70.1663892031.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 12 ++++++++++--
 io_uring/io_uring.h | 12 +++++++++---
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 242d896c00f3..13af6b56ebd2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -567,7 +567,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 
 	io_cq_lock(ctx);
 	while (!list_empty(&ctx->cq_overflow_list)) {
-		struct io_uring_cqe *cqe = io_get_cqe(ctx);
+		struct io_uring_cqe *cqe = io_get_cqe_overflow(ctx, true);
 		struct io_overflow_cqe *ocqe;
 
 		if (!cqe && !force)
@@ -694,12 +694,19 @@ bool io_req_cqe_overflow(struct io_kiocb *req)
  * control dependency is enough as we're using WRITE_ONCE to
  * fill the cq entry
  */
-struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx)
+struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow)
 {
 	struct io_rings *rings = ctx->rings;
 	unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
 	unsigned int free, queued, len;
 
+	/*
+	 * Posting into the CQ when there are pending overflowed CQEs may break
+	 * ordering guarantees, which will affect links, F_MORE users and more.
+	 * Force overflow the completion.
+	 */
+	if (!overflow && (ctx->check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT)))
+		return NULL;
 
 	/* userspace may cheat modifying the tail, be safe and do min */
 	queued = min(__io_cqring_events(ctx), ctx->cq_entries);
@@ -2228,6 +2235,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 	do {
 		io_cqring_overflow_flush(ctx);
+
 		if (io_cqring_events(ctx) >= min_events)
 			return 0;
 		if (!io_run_task_work())
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2f73f83af960..45809ae6f64e 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -24,7 +24,7 @@ enum {
 	IOU_STOP_MULTISHOT	= -ECANCELED,
 };
 
-struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx);
+struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow);
 bool io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(void);
 void io_req_complete_failed(struct io_kiocb *req, s32 res);
@@ -91,7 +91,8 @@ static inline void io_cq_lock(struct io_ring_ctx *ctx)
 
 void io_cq_unlock_post(struct io_ring_ctx *ctx);
 
-static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
+static inline struct io_uring_cqe *io_get_cqe_overflow(struct io_ring_ctx *ctx,
+						       bool overflow)
 {
 	if (likely(ctx->cqe_cached < ctx->cqe_sentinel)) {
 		struct io_uring_cqe *cqe = ctx->cqe_cached;
@@ -103,7 +104,12 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 		return cqe;
 	}
 
-	return __io_get_cqe(ctx);
+	return __io_get_cqe(ctx, overflow);
+}
+
+static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
+{
+	return io_get_cqe_overflow(ctx, false);
 }
 
 static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
-- 
2.35.1

