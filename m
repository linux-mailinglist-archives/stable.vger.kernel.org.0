Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD236E67AF
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732338AbfJ0VXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:23:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732334AbfJ0VXU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:23:20 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F0922064A;
        Sun, 27 Oct 2019 21:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211400;
        bh=97MBzUNNqyU+uABWapxiR2K5S7vS+qfj9+fyGXsu65o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PuABERHg+VG27/suFJiaossoJbTwdj6Qp1GPWQFk2JmfFk9KOZGE8YAmOO61WBSAd
         Vsg2obyGC/7cN6lXBsRNbQlRdHuDeBskSQ8080A6Qy7gpm4HjkIOAyodurFIN0tvMW
         G0DMljHyXHeOXoaOc7t6nINC1XtbaTdAhf1cAVGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.3 094/197] io_uring: fix bad inflight accounting for SETUP_IOPOLL|SETUP_SQTHREAD
Date:   Sun, 27 Oct 2019 22:00:12 +0100
Message-Id: <20191027203356.845912397@linuxfoundation.org>
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

commit 2b2ed9750fc9d040b9f6d076afcef6f00b6f1f7c upstream.

We currently assume that submissions from the sqthread are successful,
and if IO polling is enabled, we use that value for knowing how many
completions to look for. But if we overflowed the CQ ring or some
requests simply got errored and already completed, they won't be
available for polling.

For the case of IO polling and SQTHREAD usage, look at the pending
poll list. If it ever hits empty then we know that we don't have
anymore pollable requests inflight. For that case, simply reset
the inflight count to zero.

Reported-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   44 ++++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -816,19 +816,11 @@ static void io_iopoll_reap_events(struct
 	mutex_unlock(&ctx->uring_lock);
 }
 
-static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
-			   long min)
+static int __io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
+			    long min)
 {
-	int iters, ret = 0;
+	int iters = 0, ret = 0;
 
-	/*
-	 * We disallow the app entering submit/complete with polling, but we
-	 * still need to lock the ring to prevent racing with polled issue
-	 * that got punted to a workqueue.
-	 */
-	mutex_lock(&ctx->uring_lock);
-
-	iters = 0;
 	do {
 		int tmin = 0;
 
@@ -864,6 +856,21 @@ static int io_iopoll_check(struct io_rin
 		ret = 0;
 	} while (min && !*nr_events && !need_resched());
 
+	return ret;
+}
+
+static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
+			   long min)
+{
+	int ret;
+
+	/*
+	 * We disallow the app entering submit/complete with polling, but we
+	 * still need to lock the ring to prevent racing with polled issue
+	 * that got punted to a workqueue.
+	 */
+	mutex_lock(&ctx->uring_lock);
+	ret = __io_iopoll_check(ctx, nr_events, min);
 	mutex_unlock(&ctx->uring_lock);
 	return ret;
 }
@@ -2327,7 +2334,20 @@ static int io_sq_thread(void *data)
 			unsigned nr_events = 0;
 
 			if (ctx->flags & IORING_SETUP_IOPOLL) {
-				io_iopoll_check(ctx, &nr_events, 0);
+				/*
+				 * inflight is the count of the maximum possible
+				 * entries we submitted, but it can be smaller
+				 * if we dropped some of them. If we don't have
+				 * poll entries available, then we know that we
+				 * have nothing left to poll for. Reset the
+				 * inflight count to zero in that case.
+				 */
+				mutex_lock(&ctx->uring_lock);
+				if (!list_empty(&ctx->poll_list))
+					__io_iopoll_check(ctx, &nr_events, 0);
+				else
+					inflight = 0;
+				mutex_unlock(&ctx->uring_lock);
 			} else {
 				/*
 				 * Normal IO, just pretend everything completed.


