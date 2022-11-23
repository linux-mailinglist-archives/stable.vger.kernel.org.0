Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6461635804
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238239AbiKWJtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236610AbiKWJtB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:49:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E9111A724
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:46:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B952661B91
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2A9C433B5;
        Wed, 23 Nov 2022 09:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196764;
        bh=V4gVvRvmo0xjL8AeNN/q0if05nknZP0mi7pIcTVbnF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HD0ypTh8MG5RqaSau6I2LGVnmmX7Q+X5VVArGNGPx8jfcerXZfWeb1chTPnT3lJ0G
         ftTE7cFqAqKxzMZ8sbocRJVCh8ZZGpRB+hjUa1klzxHD8iEWMs0pI/6tHdCduP8kVq
         GK30i5a1HWou/mf7ISoOJSUyT0IpgLBzb7k1W9bE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dylan Yudaken <dylany@meta.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 118/314] io_uring: calculate CQEs from the user visible value
Date:   Wed, 23 Nov 2022 09:49:23 +0100
Message-Id: <20221123084630.860899497@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dylan Yudaken <dylany@meta.com>

[ Upstream commit 0fc8c2acbfc789a977a50a4a9812a8e4b37958ce ]

io_cqring_wait (and it's wake function io_has_work) used cached_cq_tail in
order to calculate the number of CQEs. cached_cq_tail is set strictly
before the user visible rings->cq.tail

However as far as userspace is concerned,  if io_uring_enter(2) is called
with a minimum number of events, they will verify by checking
rings->cq.tail.

It is therefore possible for io_uring_enter(2) to return early with fewer
events visible to the user.

Instead make the wait functions read from the user visible value, so there
will be no discrepency.

This is triggered eventually by the following reproducer:

struct io_uring_sqe *sqe;
struct io_uring_cqe *cqe;
unsigned int cqe_ready;
struct io_uring ring;
int ret, i;

ret = io_uring_queue_init(N, &ring, 0);
assert(!ret);
while(true) {
	for (i = 0; i < N; i++) {
		sqe = io_uring_get_sqe(&ring);
		io_uring_prep_nop(sqe);
		sqe->flags |= IOSQE_ASYNC;
	}
	ret = io_uring_submit(&ring);
	assert(ret == N);

	do {
		ret = io_uring_wait_cqes(&ring, &cqe, N, NULL, NULL);
	} while(ret == -EINTR);
	cqe_ready = io_uring_cq_ready(&ring);
	assert(!ret);
	assert(cqe_ready == N);
	io_uring_cq_advance(&ring, N);
}

Fixes: ad3eb2c89fb2 ("io_uring: split overflow state into SQ and CQ side")
Signed-off-by: Dylan Yudaken <dylany@meta.com>
Link: https://lore.kernel.org/r/20221108153016.1854297-1-dylany@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d29f397f095e..f347e81e2d98 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -171,6 +171,11 @@ static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
 	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
 }
 
+static inline unsigned int __io_cqring_events_user(struct io_ring_ctx *ctx)
+{
+	return READ_ONCE(ctx->rings->cq.tail) - READ_ONCE(ctx->rings->cq.head);
+}
+
 static bool io_match_linked(struct io_kiocb *head)
 {
 	struct io_kiocb *req;
@@ -2163,7 +2168,7 @@ struct io_wait_queue {
 static inline bool io_should_wake(struct io_wait_queue *iowq)
 {
 	struct io_ring_ctx *ctx = iowq->ctx;
-	int dist = ctx->cached_cq_tail - (int) iowq->cq_tail;
+	int dist = READ_ONCE(ctx->rings->cq.tail) - (int) iowq->cq_tail;
 
 	/*
 	 * Wake up if we have enough events, or if a timeout occurred since we
@@ -2240,7 +2245,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	do {
 		io_cqring_overflow_flush(ctx);
 
-		if (io_cqring_events(ctx) >= min_events)
+		/* if user messes with these they will just get an early return */
+		if (__io_cqring_events_user(ctx) >= min_events)
 			return 0;
 		if (!io_run_task_work())
 			break;
-- 
2.35.1



