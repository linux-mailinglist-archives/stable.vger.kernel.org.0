Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3483ED3BD
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 14:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbhHPMNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 08:13:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229836AbhHPMNt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 08:13:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 279BD63249;
        Mon, 16 Aug 2021 12:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629115998;
        bh=JBDnvM2Rb9CHm3ibfwVd2+ODwVyPRvpIG0C7yfp2zYI=;
        h=Subject:To:Cc:From:Date:From;
        b=lu9KTTp3DmNeySneLzO1rN6D34Pv8gRYESCb9HbTRZ9hDKPHaIKcp5cMcrtvulVBB
         pNPwBZDV/pqvTAiR7k1xXMswPXJf5zQzvy6U663W7YegufRD/X3P0FrtlyAUPhI25s
         KcUqB0ak+2BjC9+1E7RfYfwfsLjV1stHVNvtIhTA=
Subject: FAILED: patch "[PATCH] io_uring: Use WRITE_ONCE() when writing to sq_flags" failed to apply to 5.13-stable tree
To:     namit@vmware.com, asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Aug 2021 14:13:06 +0200
Message-ID: <162911598652205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 20c0b380f971e7d48f5d978bc27d827f7eabb21a Mon Sep 17 00:00:00 2001
From: Nadav Amit <namit@vmware.com>
Date: Sat, 7 Aug 2021 17:13:42 -0700
Subject: [PATCH] io_uring: Use WRITE_ONCE() when writing to sq_flags

The compiler should be forbidden from any strange optimization for async
writes to user visible data-structures. Without proper protection, the
compiler can cause write-tearing or invent writes that would confuse the
userspace.

However, there are writes to sq_flags which are not protected by
WRITE_ONCE(). Use WRITE_ONCE() for these writes.

This is purely a theoretical issue. Presumably, any compiler is very
unlikely to do such optimizations.

Fixes: 75b28affdd6a ("io_uring: allocate the two rings together")
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Nadav Amit <namit@vmware.com>
Link: https://lore.kernel.org/r/20210808001342.964634-3-namit@vmware.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1093df3977b8..ca064486cb41 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1500,7 +1500,8 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	all_flushed = list_empty(&ctx->cq_overflow_list);
 	if (all_flushed) {
 		clear_bit(0, &ctx->check_cq_overflow);
-		ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
+		WRITE_ONCE(ctx->rings->sq_flags,
+			   ctx->rings->sq_flags & ~IORING_SQ_CQ_OVERFLOW);
 	}
 
 	if (posted)
@@ -1579,7 +1580,9 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	}
 	if (list_empty(&ctx->cq_overflow_list)) {
 		set_bit(0, &ctx->check_cq_overflow);
-		ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
+		WRITE_ONCE(ctx->rings->sq_flags,
+			   ctx->rings->sq_flags | IORING_SQ_CQ_OVERFLOW);
+
 	}
 	ocqe->cqe.user_data = user_data;
 	ocqe->cqe.res = res;
@@ -6804,14 +6807,16 @@ static inline void io_ring_set_wakeup_flag(struct io_ring_ctx *ctx)
 {
 	/* Tell userspace we may need a wakeup call */
 	spin_lock_irq(&ctx->completion_lock);
-	ctx->rings->sq_flags |= IORING_SQ_NEED_WAKEUP;
+	WRITE_ONCE(ctx->rings->sq_flags,
+		   ctx->rings->sq_flags | IORING_SQ_NEED_WAKEUP);
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
 static inline void io_ring_clear_wakeup_flag(struct io_ring_ctx *ctx)
 {
 	spin_lock_irq(&ctx->completion_lock);
-	ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
+	WRITE_ONCE(ctx->rings->sq_flags,
+		   ctx->rings->sq_flags & ~IORING_SQ_NEED_WAKEUP);
 	spin_unlock_irq(&ctx->completion_lock);
 }
 

