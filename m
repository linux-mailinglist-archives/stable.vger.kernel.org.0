Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEEA3F6381
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbhHXQ44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:56:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229670AbhHXQ44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:56:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FDC1611AF;
        Tue, 24 Aug 2021 16:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824171;
        bh=hHG7jhc/GCFrYNzx6Y2tXesC+3qSJu3AeT0cMgmSfn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fw6iOYnP3QeI/eslzkcZ2UeTOsQMPsF6f62GsA5mDpAFgjl2O2y+azehfkHkNoybo
         fVQ1PSCP/9+qTpOjAaOsI0Nw4R23dbjoub3yE2zl0wyGJ5PhKROEVAMzXzPiz/fL8f
         5UUn23c3x7RTqSMTHLDq/Y8qDqyJ08X5pjxVIUVMBxN/OlNY+HeijHIoiK+U7d7m3Y
         7re6egtWlAR2VI3dp1YJzvXBDvPBJ0xJeiqLkfkaPdmYSnsJBiYbL3KyB2pohqvlzH
         IicSeiFXq7E4OrpDBgMGygrlLfH0+5dbJQaVCy5Ucnj81tfWpA4IJEcftlPlbN8YGb
         +eVRc9dznYCaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 002/127] io_uring: Use WRITE_ONCE() when writing to sq_flags
Date:   Tue, 24 Aug 2021 12:54:02 -0400
Message-Id: <20210824165607.709387-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

[ Upstream commit 20c0b380f971e7d48f5d978bc27d827f7eabb21a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f23ff39f7697..0a5f105c657c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1482,7 +1482,8 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	if (all_flushed) {
 		clear_bit(0, &ctx->sq_check_overflow);
 		clear_bit(0, &ctx->cq_check_overflow);
-		ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
+		WRITE_ONCE(ctx->rings->sq_flags,
+			   ctx->rings->sq_flags & ~IORING_SQ_CQ_OVERFLOW);
 	}
 
 	if (posted)
@@ -1562,7 +1563,9 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	if (list_empty(&ctx->cq_overflow_list)) {
 		set_bit(0, &ctx->sq_check_overflow);
 		set_bit(0, &ctx->cq_check_overflow);
-		ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
+		WRITE_ONCE(ctx->rings->sq_flags,
+			   ctx->rings->sq_flags | IORING_SQ_CQ_OVERFLOW);
+
 	}
 	ocqe->cqe.user_data = user_data;
 	ocqe->cqe.res = res;
@@ -6790,14 +6793,16 @@ static inline void io_ring_set_wakeup_flag(struct io_ring_ctx *ctx)
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
 
-- 
2.30.2

