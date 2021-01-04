Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402192E99F8
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbhADQFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:05:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729091AbhADQDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:03:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 092862245C;
        Mon,  4 Jan 2021 16:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776184;
        bh=+5kp/6j33OLmu6miCw7AecR6CM8H+7zPqlyEF1lYGXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pUbtnXaaTKNbzKSwbt6aSbTaDvh1VQIWF94+ocPJpQ0zgqHwyS2buvcSt6BxcZL+u
         yE7Y7C7YDtlMa0Tkkfx/Ci6jDgHodgXQceQwI6xk0Gtq5qWxxDhlxo9TKp5be3k8U0
         8MDcRn6A+8ZK3H/lG5Nblg9jo4KvZ+QCsS/bKR/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 59/63] io_uring: remove racy overflow list fast checks
Date:   Mon,  4 Jan 2021 16:57:52 +0100
Message-Id: <20210104155711.666098637@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 9cd2be519d05ee78876d55e8e902b7125f78b74f ]

list_empty_careful() is not racy only if some conditions are met, i.e.
no re-adds after del_init. io_cqring_overflow_flush() does list_move(),
so it's actually racy.

Remove those checks, we have ->cq_check_overflow for the fast path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e28eedab5365f..1f798c5c4213e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1636,8 +1636,6 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	LIST_HEAD(list);
 
 	if (!force) {
-		if (list_empty_careful(&ctx->cq_overflow_list))
-			return true;
 		if ((ctx->cached_cq_tail - READ_ONCE(rings->cq.head) ==
 		    rings->cq_ring_entries))
 			return false;
@@ -6579,8 +6577,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
 	if (test_bit(0, &ctx->sq_check_overflow)) {
-		if (!list_empty(&ctx->cq_overflow_list) &&
-		    !io_cqring_overflow_flush(ctx, false, NULL, NULL))
+		if (!io_cqring_overflow_flush(ctx, false, NULL, NULL))
 			return -EBUSY;
 	}
 
-- 
2.27.0



