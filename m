Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B542E3FF5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437893AbgL1OXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:23:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502813AbgL1OXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:23:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9781B20731;
        Mon, 28 Dec 2020 14:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165374;
        bh=WJeUAuTdeT5MrHYibK7LHhElDRROfb2vnw0VRIECb3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JXJLno0kLCntu6oHlM9AMoEmVMHRF95cNr2ubwTnwQgQLC0g0snxMlp/+8sEym2H
         4D/sqzMwoPemb4hxTClv0e7+3Nzsmj83jaaYWLWGjNIFOwjheA4JK/LIemzDYnllb1
         UlncPZsq4iekhxWBLRy6No3ybIL/7IFQJILo4OVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 507/717] io_uring: cancel reqs shouldnt kill overflow list
Date:   Mon, 28 Dec 2020 13:48:25 +0100
Message-Id: <20201228125045.251872226@linuxfoundation.org>
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

[ Upstream commit cda286f0715c82f8117e166afd42cca068876dde ]

io_uring_cancel_task_requests() doesn't imply that the ring is going
away, it may continue to work well after that. The problem is that it
sets ->cq_overflow_flushed effectively disabling the CQ overflow feature

Split setting cq_overflow_flushed from flush, and do the first one only
on exit. It's ok in terms of cancellations because there is a
io_uring->in_idle check in __io_cqring_fill_event().

It also fixes a race with setting ->cq_overflow_flushed in
io_uring_cancel_task_requests, whuch's is not atomic and a part of a
bitmask with other flags. Though, the only other flag that's not set
during init is drain_next, so it's not as bad for sane architectures.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Fixes: 0f2122045b946 ("io_uring: don't rely on weak ->files references")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b9d3209a5f9de..e9219841923cc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1641,10 +1641,6 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 
-	/* if force is set, the ring is going away. always drop after that */
-	if (force)
-		ctx->cq_overflow_flushed = 1;
-
 	cqe = NULL;
 	list_for_each_entry_safe(req, tmp, &ctx->cq_overflow_list, compl.list) {
 		if (tsk && req->task != tsk)
@@ -8378,6 +8374,8 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
+	/* if force is set, the ring is going away. always drop after that */
+	ctx->cq_overflow_flushed = 1;
 	if (ctx->rings)
 		io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	mutex_unlock(&ctx->uring_lock);
-- 
2.27.0



