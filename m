Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3F13CE3F9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347305AbhGSPl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348524AbhGSPf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E68066162D;
        Mon, 19 Jul 2021 16:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711238;
        bh=Wkb2rDd2IPG038n4sH3bX2jojvIyVDLy12j6rPi/odI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2wdu60iUACJJNaeFv2wQBK+yo9KDchnpqcYtjxT5Xi0Ifp/X0tzzaFZgBHfPg1vx
         Y/8y/zRKG800+0oT4HNz3PO7GNMXbR91FyIllxnyX22VxD1ODlDDrRUo5SO6X+pr0t
         fx2Cm1eSDsHbZ8pRL1fuIN0JD0JIHkt3vNqejJ/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 245/351] io_uring: dont bounce submit_state cachelines
Date:   Mon, 19 Jul 2021 16:53:11 +0200
Message-Id: <20210719144953.042916439@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit d0acdee296d42e700c16271d9f95085a9c897a53 ]

struct io_submit_state contains struct io_comp_state and so
locked_free_*, that renders cachelines around ->locked_free* being
invalidated on most non-inline completions, that may terrorise caches if
submissions and completions are done by different tasks.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/290cb5412b76892e8631978ee8ab9db0c6290dd5.1621201931.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5d685c92b8fd..bf3566ff9516 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -299,11 +299,8 @@ struct io_sq_data {
 struct io_comp_state {
 	struct io_kiocb		*reqs[IO_COMPL_BATCH];
 	unsigned int		nr;
-	unsigned int		locked_free_nr;
 	/* inline/task_work completion list, under ->uring_lock */
 	struct list_head	free_list;
-	/* IRQ completion list, under ->completion_lock */
-	struct list_head	locked_free_list;
 };
 
 struct io_submit_link {
@@ -382,6 +379,9 @@ struct io_ring_ctx {
 	} ____cacheline_aligned_in_smp;
 
 	struct io_submit_state		submit_state;
+	/* IRQ completion list, under ->completion_lock */
+	struct list_head	locked_free_list;
+	unsigned int		locked_free_nr;
 
 	struct io_rings	*rings;
 
@@ -1193,7 +1193,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_llist_head(&ctx->rsrc_put_llist);
 	INIT_LIST_HEAD(&ctx->tctx_list);
 	INIT_LIST_HEAD(&ctx->submit_state.comp.free_list);
-	INIT_LIST_HEAD(&ctx->submit_state.comp.locked_free_list);
+	INIT_LIST_HEAD(&ctx->locked_free_list);
 	return ctx;
 err:
 	kfree(ctx->dummy_ubuf);
@@ -1590,8 +1590,6 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 	 * free_list cache.
 	 */
 	if (req_ref_put_and_test(req)) {
-		struct io_comp_state *cs = &ctx->submit_state.comp;
-
 		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
 			if (req->flags & (REQ_F_LINK_TIMEOUT | REQ_F_FAIL_LINK))
 				io_disarm_next(req);
@@ -1602,8 +1600,8 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 		}
 		io_dismantle_req(req);
 		io_put_task(req->task, 1);
-		list_add(&req->compl.list, &cs->locked_free_list);
-		cs->locked_free_nr++;
+		list_add(&req->compl.list, &ctx->locked_free_list);
+		ctx->locked_free_nr++;
 	} else {
 		if (!percpu_ref_tryget(&ctx->refs))
 			req = NULL;
@@ -1658,8 +1656,8 @@ static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
 					struct io_comp_state *cs)
 {
 	spin_lock_irq(&ctx->completion_lock);
-	list_splice_init(&cs->locked_free_list, &cs->free_list);
-	cs->locked_free_nr = 0;
+	list_splice_init(&ctx->locked_free_list, &cs->free_list);
+	ctx->locked_free_nr = 0;
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
@@ -1675,7 +1673,7 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 	 * locked cache, grab the lock and move them over to our submission
 	 * side cache.
 	 */
-	if (READ_ONCE(cs->locked_free_nr) > IO_COMPL_BATCH)
+	if (READ_ONCE(ctx->locked_free_nr) > IO_COMPL_BATCH)
 		io_flush_cached_locked_reqs(ctx, cs);
 
 	nr = state->free_reqs;
-- 
2.30.2



