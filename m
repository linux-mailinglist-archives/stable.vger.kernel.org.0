Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72C42E795E
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbgL3NIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:08:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbgL3NFU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C892A224D4;
        Wed, 30 Dec 2020 13:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333429;
        bh=mk8PmzHz1goX0mwz67HLEPYdnwCimSAxUXWHQi5z6lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTCgamtr/6+S6qYx4UBZazWVI0DYkz8nNm8coRUbzkKz6VJNwMlBo/Xyc53PGtSpq
         a9unnZVBG4ZO0B4mr052vg2rR+GyYHhrF3l3KsLcKKzwiBuCwzSmDoAIaEz6DN6v/K
         xnve1JKO3eJqKH1JynHgzN5btndY1lecfZovakJe5UHb0QVzVfVZ0htynrIlSEqH8y
         yoVOP/OJIWJk1cB18Zou8KI6beSbbRwyyN0RUo7PTuTU9yFNLelnFYSVh8jKEhMXgc
         kv0iYhoLP/1VITjlnZUXvEjxy/TQ6cbBzMBdHzUtHf4JCjWyNjyJhmsqQomSVbF64j
         9pakI8k85EX6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 26/31] io_uring: remove racy overflow list fast checks
Date:   Wed, 30 Dec 2020 08:03:08 -0500
Message-Id: <20201230130314.3636961-26-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130314.3636961-1-sashal@kernel.org>
References: <20201230130314.3636961-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 86dac2b2e2763..4b3dbe588d111 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1632,8 +1632,6 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	LIST_HEAD(list);
 
 	if (!force) {
-		if (list_empty_careful(&ctx->cq_overflow_list))
-			return true;
 		if ((ctx->cached_cq_tail - READ_ONCE(rings->cq.head) ==
 		    rings->cq_ring_entries))
 			return false;
@@ -6548,8 +6546,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
 	if (test_bit(0, &ctx->sq_check_overflow)) {
-		if (!list_empty(&ctx->cq_overflow_list) &&
-		    !io_cqring_overflow_flush(ctx, false, NULL, NULL))
+		if (!io_cqring_overflow_flush(ctx, false, NULL, NULL))
 			return -EBUSY;
 	}
 
-- 
2.27.0

