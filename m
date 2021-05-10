Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE731378943
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239270AbhEJL0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237995AbhEJLQo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:16:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19A9A613AE;
        Mon, 10 May 2021 11:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645117;
        bh=3ThluYPddbKx1TJni2JSHepmAl9thjYwUvhf5Ex/G9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRhaSSmAfgTFXXIfWRQo9Vh/FHdpKQsPiRP7s70fNMARrAm2FSV1kWfMiO3oRyNWG
         M4DzaGsCoXsbMzPG813k0hbGSKG2ctDQnGj9eXrU6jeii11nHTdZlCrdJfTqheWVx7
         FRsJ4UtpTNkQwxzjyORB/ESNQlLVHzx4/s89F16I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.12 359/384] io_uring: remove extra sqpoll submission halting
Date:   Mon, 10 May 2021 12:22:28 +0200
Message-Id: <20210510102026.589198889@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 3b763ba1c77da5806e4fdc5684285814fe970c98 upstream.

SQPOLL task won't submit requests for a context that is currently dying,
so no need to remove ctx from sqd_list prior the main loop of
io_ring_exit_work(). Kill it, will be removed by io_sq_thread_finish()
and only brings confusion and lockups.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f220c2b786ba0f9499bebc9f3cd9714d29efb6a5.1618752958.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6710,6 +6710,10 @@ static int __io_sq_thread(struct io_ring
 		if (!list_empty(&ctx->iopoll_list))
 			io_do_iopoll(ctx, &nr_events, 0);
 
+		/*
+		 * Don't submit if refs are dying, good for io_uring_register(),
+		 * but also it is relied upon by io_ring_exit_work()
+		 */
 		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)) &&
 		    !(ctx->flags & IORING_SETUP_R_DISABLED))
 			ret = io_submit_sqes(ctx, to_submit);
@@ -8576,14 +8580,6 @@ static void io_ring_exit_work(struct wor
 	struct io_tctx_node *node;
 	int ret;
 
-	/* prevent SQPOLL from submitting new requests */
-	if (ctx->sq_data) {
-		io_sq_thread_park(ctx->sq_data);
-		list_del_init(&ctx->sqd_list);
-		io_sqd_update_thread_idle(ctx->sq_data);
-		io_sq_thread_unpark(ctx->sq_data);
-	}
-
 	/*
 	 * If we're doing polled IO and end up having requests being
 	 * submitted async (out-of-line), then completions can come in while


