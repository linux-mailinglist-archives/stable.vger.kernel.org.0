Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6562E3E11
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502256AbgL1OXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:23:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502766AbgL1OXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:23:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E43022D03;
        Mon, 28 Dec 2020 14:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165371;
        bh=pEuBK8ujUagU0dlJy7WscqftfQKL9i6gUUDLsClTPjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzzbt/ER4m1RCeP0j+nxJz0VLCOgYXluLU0USOQyGa+33fskuy4NFUh5u/ONRI8j+
         CegSio90tr27jVOzGvQZGmUa05CYikE7qKyKO5Ftejy8PQH+OFjRSpcFdhCQqfcEdL
         U3yw0npbd5kSaw3Vs5L0TuoNxDWjhRL/FivBDvsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 506/717] io_uring: fix racy IOPOLL flush overflow
Date:   Mon, 28 Dec 2020 13:48:24 +0100
Message-Id: <20201228125045.202569307@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 634578f800652035debba3098d8ab0d21af7c7a5 ]

It's not safe to call io_cqring_overflow_flush() for IOPOLL mode without
hodling uring_lock, because it does synchronisation differently. Make
sure we have it.

As for io_ring_exit_work(), we don't even need it there because
io_ring_ctx_wait_and_kill() already set force flag making all overflowed
requests to be dropped.

Cc: <stable@vger.kernel.org> # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0621f581943cd..b9d3209a5f9de 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8369,8 +8369,6 @@ static void io_ring_exit_work(struct work_struct *work)
 	 * as nobody else will be looking for them.
 	 */
 	do {
-		if (ctx->rings)
-			io_cqring_overflow_flush(ctx, true, NULL, NULL);
 		io_iopoll_try_reap_events(ctx);
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 	io_ring_ctx_free(ctx);
@@ -8380,6 +8378,8 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
+	if (ctx->rings)
+		io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	mutex_unlock(&ctx->uring_lock);
 
 	io_kill_timeouts(ctx, NULL);
@@ -8389,8 +8389,6 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_wq_cancel_all(ctx->io_wq);
 
 	/* if we failed setting up the ctx, we might not have any rings */
-	if (ctx->rings)
-		io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	io_iopoll_try_reap_events(ctx);
 	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
 
@@ -8654,7 +8652,9 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	}
 
 	io_cancel_defer_files(ctx, task, files);
+	io_ring_submit_lock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
 	io_cqring_overflow_flush(ctx, true, task, files);
+	io_ring_submit_unlock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
 
 	while (__io_uring_cancel_task_requests(ctx, task, files)) {
 		io_run_task_work();
@@ -8956,8 +8956,10 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	 */
 	ret = 0;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		io_ring_submit_lock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
 		if (!list_empty_careful(&ctx->cq_overflow_list))
 			io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		io_ring_submit_unlock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT)
-- 
2.27.0



