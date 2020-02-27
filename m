Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4445B171C6A
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388488AbgB0OLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:11:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388318AbgB0OLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:11:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA22F246AD;
        Thu, 27 Feb 2020 14:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812706;
        bh=P6ve4YLl/tTD98oyYfZFuy1vti5trftE7wEQ/bg91sA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kqm2AP8E6hZWN4XnbDjdGcwnmXh7MezjwSz5ueseccNovLggDpwfIEy1z2dBfu87A
         JKqoZvWsWcfTOf5qs+awd9EvChpy/aejkn3NTKki/LuTdF/HOxt4/H1M/jErs85gkG
         5BzzAiPBXpaT3m1WvffXjX74GicYxjhofeFX84jY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 121/135] io_uring: fix __io_iopoll_check deadlock in io_sq_thread
Date:   Thu, 27 Feb 2020 14:37:41 +0100
Message-Id: <20200227132247.269204084@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

commit c7849be9cc2dd2754c48ddbaca27c2de6d80a95d upstream.

Since commit a3a0e43fd770 ("io_uring: don't enter poll loop if we have
CQEs pending"), if we already events pending, we won't enter poll loop.
In case SETUP_IOPOLL and SETUP_SQPOLL are both enabled, if app has
been terminated and don't reap pending events which are already in cq
ring, and there are some reqs in poll_list, io_sq_thread will enter
__io_iopoll_check(), and find pending events, then return, this loop
will never have a chance to exit.

I have seen this issue in fio stress tests, to fix this issue, let
io_sq_thread call io_iopoll_getevents() with argument 'min' being zero,
and remove __io_iopoll_check().

Fixes: a3a0e43fd770 ("io_uring: don't enter poll loop if we have CQEs pending")
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -882,11 +882,17 @@ static void io_iopoll_reap_events(struct
 	mutex_unlock(&ctx->uring_lock);
 }
 
-static int __io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
-			    long min)
+static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
+			   long min)
 {
 	int iters = 0, ret = 0;
 
+	/*
+	 * We disallow the app entering submit/complete with polling, but we
+	 * still need to lock the ring to prevent racing with polled issue
+	 * that got punted to a workqueue.
+	 */
+	mutex_lock(&ctx->uring_lock);
 	do {
 		int tmin = 0;
 
@@ -922,21 +928,6 @@ static int __io_iopoll_check(struct io_r
 		ret = 0;
 	} while (min && !*nr_events && !need_resched());
 
-	return ret;
-}
-
-static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
-			   long min)
-{
-	int ret;
-
-	/*
-	 * We disallow the app entering submit/complete with polling, but we
-	 * still need to lock the ring to prevent racing with polled issue
-	 * that got punted to a workqueue.
-	 */
-	mutex_lock(&ctx->uring_lock);
-	ret = __io_iopoll_check(ctx, nr_events, min);
 	mutex_unlock(&ctx->uring_lock);
 	return ret;
 }
@@ -2721,7 +2712,7 @@ static int io_sq_thread(void *data)
 				 */
 				mutex_lock(&ctx->uring_lock);
 				if (!list_empty(&ctx->poll_list))
-					__io_iopoll_check(ctx, &nr_events, 0);
+					io_iopoll_getevents(ctx, &nr_events, 0);
 				else
 					inflight = 0;
 				mutex_unlock(&ctx->uring_lock);


