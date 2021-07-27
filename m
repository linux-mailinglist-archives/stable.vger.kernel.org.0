Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940C23D769E
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbhG0NaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:30:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236737AbhG0NUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D05861AAA;
        Tue, 27 Jul 2021 13:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391974;
        bh=YEbs7QOvzC/3+hS/9IhpZG2Zf4XkPa+k8PjsN8tmi+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1j0qfQ7FQKaXUPZUajNogLV4uKLYFRuQnmTklsq882d7xV59BB+n/PK4n0vl5mS+
         6ZPgx6EbGbpOoelWQnDiOQcZc9kkVO9jPPaxUDVbevpx2ta7DSYciRwKFH3X+jEJOl
         SLpVFcbYXAWiBnMN7KKk8zmYZPDWxvu6leYt7Z3qKes2kjDf6eaVnP8i+lKa8aUefh
         oIvIbq9OR1+H1YzM4IAvuwOU9lufy6V0HvDQEpjld005wsKWOwXJ/DU4fkqNwDcpdh
         mrI2rvgu0c+h6AWcVvwu/kdm8fYcVaMno4Xl0B1yFr26svMsxvwax2Og1ZoNwBq7qa
         jM6HSIK83/MtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 19/21] io_uring: never attempt iopoll reissue from release path
Date:   Tue, 27 Jul 2021 09:19:06 -0400
Message-Id: <20210727131908.834086-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131908.834086-1-sashal@kernel.org>
References: <20210727131908.834086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 3c30ef0f78cfb36fdb13753794b0384cf7e37cc9 ]

There are two reasons why this shouldn't be done:

1) Ring is exiting, and we're canceling requests anyway. Any request
   should be canceled anyway. In theory, this could iterate for a
   number of times if someone else is also driving the target block
   queue into request starvation, however the likelihood of this
   happening is miniscule.

2) If the original task decided to pass the ring to another task, then
   we don't want to be reissuing from this context as it may be an
   unrelated task or context. No assumptions should be made about
   the context in which ->release() is run. This can only happen for pure
   read/write, and we'll get -EFAULT on them anyway.

Link: https://lore.kernel.org/io-uring/YPr4OaHv0iv0KTOc@zeniv-ca.linux.org.uk/
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index eeea6b8c8bee..7ae6043e7909 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2240,7 +2240,7 @@ static inline bool io_run_task_work(void)
  * Find and free completed poll iocbs
  */
 static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
-			       struct list_head *done)
+			       struct list_head *done, bool resubmit)
 {
 	struct req_batch rb;
 	struct io_kiocb *req;
@@ -2255,7 +2255,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
 
-		if (READ_ONCE(req->result) == -EAGAIN &&
+		if (READ_ONCE(req->result) == -EAGAIN && resubmit &&
 		    !(req->flags & REQ_F_DONT_REISSUE)) {
 			req->iopoll_completed = 0;
 			req_ref_get(req);
@@ -2279,7 +2279,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 }
 
 static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
-			long min)
+			long min, bool resubmit)
 {
 	struct io_kiocb *req, *tmp;
 	LIST_HEAD(done);
@@ -2322,7 +2322,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	}
 
 	if (!list_empty(&done))
-		io_iopoll_complete(ctx, nr_events, &done);
+		io_iopoll_complete(ctx, nr_events, &done, resubmit);
 
 	return ret;
 }
@@ -2340,7 +2340,7 @@ static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 	while (!list_empty(&ctx->iopoll_list)) {
 		unsigned int nr_events = 0;
 
-		io_do_iopoll(ctx, &nr_events, 0);
+		io_do_iopoll(ctx, &nr_events, 0, false);
 
 		/* let it sleep and repeat later if can't complete a request */
 		if (nr_events == 0)
@@ -2398,7 +2398,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 			if (list_empty(&ctx->iopoll_list))
 				break;
 		}
-		ret = io_do_iopoll(ctx, &nr_events, min);
+		ret = io_do_iopoll(ctx, &nr_events, min, true);
 	} while (!ret && nr_events < min && !need_resched());
 out:
 	mutex_unlock(&ctx->uring_lock);
@@ -6781,7 +6781,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 
 		mutex_lock(&ctx->uring_lock);
 		if (!list_empty(&ctx->iopoll_list))
-			io_do_iopoll(ctx, &nr_events, 0);
+			io_do_iopoll(ctx, &nr_events, 0, true);
 
 		/*
 		 * Don't submit if refs are dying, good for io_uring_register(),
-- 
2.30.2

