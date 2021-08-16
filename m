Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990213ED5B1
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237619AbhHPNNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:13:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239073AbhHPNLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:11:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78A756115A;
        Mon, 16 Aug 2021 13:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119419;
        bh=3k+UUubSjurMudvGsguk6lM9uMs8Ax/hcYc0WJ+QNcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zRR8w98FLgYMtVxOLcIvSqodWG5vOmOrLwgkKOIT1gZnLBNthqVAWk6D0y5vKFRC1
         z/di5/YOD+13jmGQSf8vySMQlglWSLmz1K79BPcaP2fcpFev+WwLGdp04rM4O0KGiL
         9RyHyu2hth8X9RHRJ4CNZrhIrfBSETH3fPyw0mvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 019/151] io_uring: fix ctx-exit io_rsrc_put_work() deadlock
Date:   Mon, 16 Aug 2021 15:00:49 +0200
Message-Id: <20210816125444.709763001@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 43597aac1f87230cb565ab354d331682f13d3c7a upstream.

__io_rsrc_put_work() might need ->uring_lock, so nobody should wait for
rsrc nodes holding the mutex. However, that's exactly what
io_ring_ctx_free() does with io_wait_rsrc_data().

Split it into rsrc wait + dealloc, and move the first one out of the
lock.

Cc: stable@vger.kernel.org
Fixes: b60c8dce33895 ("io_uring: preparation for rsrc tagging")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/0130c5c2693468173ec1afab714e0885d2c9c363.1628559783.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8614,13 +8614,10 @@ static void io_req_caches_free(struct io
 	mutex_unlock(&ctx->uring_lock);
 }
 
-static bool io_wait_rsrc_data(struct io_rsrc_data *data)
+static void io_wait_rsrc_data(struct io_rsrc_data *data)
 {
-	if (!data)
-		return false;
-	if (!atomic_dec_and_test(&data->refs))
+	if (data && !atomic_dec_and_test(&data->refs))
 		wait_for_completion(&data->done);
-	return true;
 }
 
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)
@@ -8632,10 +8629,14 @@ static void io_ring_ctx_free(struct io_r
 		ctx->mm_account = NULL;
 	}
 
+	/* __io_rsrc_put_work() may need uring_lock to progress, wait w/o it */
+	io_wait_rsrc_data(ctx->buf_data);
+	io_wait_rsrc_data(ctx->file_data);
+
 	mutex_lock(&ctx->uring_lock);
-	if (io_wait_rsrc_data(ctx->buf_data))
+	if (ctx->buf_data)
 		__io_sqe_buffers_unregister(ctx);
-	if (io_wait_rsrc_data(ctx->file_data))
+	if (ctx->file_data)
 		__io_sqe_files_unregister(ctx);
 	if (ctx->rings)
 		__io_cqring_overflow_flush(ctx, true);


