Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3636E67EA
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732764AbfJ0VZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:25:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732136AbfJ0VZc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:25:32 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F47C21783;
        Sun, 27 Oct 2019 21:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211531;
        bh=C/mSX7vY8N1eOip8zq49LLoWltaTLCDefQ7EnzLpoiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqKZ2UTjobWImgtTrpSGXxdcqwkjd+0daEl36Fivifi4AVQbplwdy5GrOvsvXMn5p
         XWNi9I40X5kPIqIwZALtePv9RIKXLScfJaxpDkp2rKlzHSN/8CzDB+r+ggc9T5dMku
         jLE+6rhzEivh986/oSsvWDuqxZVzC4Z2sxiV0u3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 140/197] io_uring: used cached copies of sq->dropped and cq->overflow
Date:   Sun, 27 Oct 2019 22:00:58 +0100
Message-Id: <20191027203359.264971269@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 498ccd9eda49117c34e0041563d0da6ac40e52b8 ]

We currently use the ring values directly, but that can lead to issues
if the application is malicious and changes these values on our behalf.
Created in-kernel cached versions of them, and just overwrite the user
side when we update them. This is similar to how we treat the sq/cq
ring tail/head updates.

Reported-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d447f43d64a24..3c8906494a8e1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -221,6 +221,7 @@ struct io_ring_ctx {
 		unsigned		sq_entries;
 		unsigned		sq_mask;
 		unsigned		sq_thread_idle;
+		unsigned		cached_sq_dropped;
 		struct io_uring_sqe	*sq_sqes;
 
 		struct list_head	defer_list;
@@ -237,6 +238,7 @@ struct io_ring_ctx {
 		/* CQ ring */
 		struct io_cq_ring	*cq_ring;
 		unsigned		cached_cq_tail;
+		atomic_t		cached_cq_overflow;
 		unsigned		cq_entries;
 		unsigned		cq_mask;
 		struct wait_queue_head	cq_wait;
@@ -431,7 +433,8 @@ static inline bool io_sequence_defer(struct io_ring_ctx *ctx,
 	if ((req->flags & (REQ_F_IO_DRAIN|REQ_F_IO_DRAINED)) != REQ_F_IO_DRAIN)
 		return false;
 
-	return req->sequence != ctx->cached_cq_tail + ctx->sq_ring->dropped;
+	return req->sequence != ctx->cached_cq_tail + ctx->sq_ring->dropped
+					+ atomic_read(&ctx->cached_cq_overflow);
 }
 
 static struct io_kiocb *io_get_deferred_req(struct io_ring_ctx *ctx)
@@ -511,9 +514,8 @@ static void io_cqring_fill_event(struct io_ring_ctx *ctx, u64 ki_user_data,
 		WRITE_ONCE(cqe->res, res);
 		WRITE_ONCE(cqe->flags, 0);
 	} else {
-		unsigned overflow = READ_ONCE(ctx->cq_ring->overflow);
-
-		WRITE_ONCE(ctx->cq_ring->overflow, overflow + 1);
+		WRITE_ONCE(ctx->cq_ring->overflow,
+				atomic_inc_return(&ctx->cached_cq_overflow));
 	}
 }
 
@@ -2272,7 +2274,8 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct sqe_submit *s)
 
 	/* drop invalid entries */
 	ctx->cached_sq_head++;
-	ring->dropped++;
+	ctx->cached_sq_dropped++;
+	WRITE_ONCE(ring->dropped, ctx->cached_sq_dropped);
 	return false;
 }
 
-- 
2.20.1



