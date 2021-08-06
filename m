Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4333E25C3
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbhHFIWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244317AbhHFIVC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:21:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84CA2611F0;
        Fri,  6 Aug 2021 08:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628238047;
        bh=iZNNAozg/6jwFOgDG0HAn/Bsks/1S6gkhjtd3zl6Yuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/58NJY5YWarCR/LYV7M01NMegEpfK/z4DwL11qFGPQkIb+cpFzcpZON9CetRiFSn
         Wh5FJCrmxYEWl3Ps6g1LM6xbscRyoIQNCEBpvFmpcU2ivsQf1R5gs8STz2b+h91Qn1
         vRFotsX5OAUlKTOIeb+4wVR3i6SLi3oMy60MqiGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 30/35] io_uring: never attempt iopoll reissue from release path
Date:   Fri,  6 Aug 2021 10:17:13 +0200
Message-Id: <20210806081114.717223967@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d465e9997157..86f609fa761c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2252,7 +2252,7 @@ static inline bool io_run_task_work(void)
  * Find and free completed poll iocbs
  */
 static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
-			       struct list_head *done)
+			       struct list_head *done, bool resubmit)
 {
 	struct req_batch rb;
 	struct io_kiocb *req;
@@ -2267,7 +2267,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
 
-		if (READ_ONCE(req->result) == -EAGAIN &&
+		if (READ_ONCE(req->result) == -EAGAIN && resubmit &&
 		    !(req->flags & REQ_F_DONT_REISSUE)) {
 			req->iopoll_completed = 0;
 			req_ref_get(req);
@@ -2291,7 +2291,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 }
 
 static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
-			long min)
+			long min, bool resubmit)
 {
 	struct io_kiocb *req, *tmp;
 	LIST_HEAD(done);
@@ -2334,7 +2334,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	}
 
 	if (!list_empty(&done))
-		io_iopoll_complete(ctx, nr_events, &done);
+		io_iopoll_complete(ctx, nr_events, &done, resubmit);
 
 	return ret;
 }
@@ -2352,7 +2352,7 @@ static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 	while (!list_empty(&ctx->iopoll_list)) {
 		unsigned int nr_events = 0;
 
-		io_do_iopoll(ctx, &nr_events, 0);
+		io_do_iopoll(ctx, &nr_events, 0, false);
 
 		/* let it sleep and repeat later if can't complete a request */
 		if (nr_events == 0)
@@ -2410,7 +2410,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 			if (list_empty(&ctx->iopoll_list))
 				break;
 		}
-		ret = io_do_iopoll(ctx, &nr_events, min);
+		ret = io_do_iopoll(ctx, &nr_events, min, true);
 	} while (!ret && nr_events < min && !need_resched());
 out:
 	mutex_unlock(&ctx->uring_lock);
@@ -6804,7 +6804,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 
 		mutex_lock(&ctx->uring_lock);
 		if (!list_empty(&ctx->iopoll_list))
-			io_do_iopoll(ctx, &nr_events, 0);
+			io_do_iopoll(ctx, &nr_events, 0, true);
 
 		/*
 		 * Don't submit if refs are dying, good for io_uring_register(),
-- 
2.30.2



