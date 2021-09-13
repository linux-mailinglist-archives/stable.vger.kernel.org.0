Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646D4409109
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245681AbhIMN5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343576AbhIMNzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:55:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF011619EB;
        Mon, 13 Sep 2021 13:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540146;
        bh=x3XOocFDJPhRSKyMfbyzMZzhWlVTXE03mZE2SOQXT6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2TN7Qz2mdRaZUzGd3o5PaSBmFJ7Plx0STs6tAOK0MAmacaqHH4YmKjm3PCIOHckT
         Al2CrsSmybdQ6bkB0kmDekamdnuyHm9swFXVcNi88G1aCF96MEi23kTumEchi97I7f
         DuKrE41XGc9zzfwdyvpH4qUt8wC/uwEPPALK4Ho8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 071/300] io_uring: refactor io_submit_flush_completions()
Date:   Mon, 13 Sep 2021 15:12:12 +0200
Message-Id: <20210913131111.752783774@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 2a2758f26df519fab011f49d53440382dda8e1a5 ]

struct io_comp_state is always contained in struct io_ring_ctx, don't
pass them into io_submit_flush_completions() separately, it makes the
interface cleaner and simplifies it for the compiler.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/44d6ca57003a82484338e95197024dbd65a1b376.1623949695.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f6ddc7182943..788ba4f3730f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1060,8 +1060,7 @@ static void __io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
 static void io_req_task_queue(struct io_kiocb *req);
-static void io_submit_flush_completions(struct io_comp_state *cs,
-					struct io_ring_ctx *ctx);
+static void io_submit_flush_completions(struct io_ring_ctx *ctx);
 static bool io_poll_remove_waitqs(struct io_kiocb *req);
 static int io_req_prep_async(struct io_kiocb *req);
 
@@ -1901,7 +1900,7 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx)
 		return;
 	if (ctx->submit_state.comp.nr) {
 		mutex_lock(&ctx->uring_lock);
-		io_submit_flush_completions(&ctx->submit_state.comp, ctx);
+		io_submit_flush_completions(ctx);
 		mutex_unlock(&ctx->uring_lock);
 	}
 	percpu_ref_put(&ctx->refs);
@@ -2147,9 +2146,9 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 		list_add(&req->compl.list, &state->comp.free_list);
 }
 
-static void io_submit_flush_completions(struct io_comp_state *cs,
-					struct io_ring_ctx *ctx)
+static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
+	struct io_comp_state *cs = &ctx->submit_state.comp;
 	int i, nr = cs->nr;
 	struct io_kiocb *req;
 	struct req_batch rb;
@@ -6462,7 +6461,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 
 			cs->reqs[cs->nr++] = req;
 			if (cs->nr == ARRAY_SIZE(cs->reqs))
-				io_submit_flush_completions(cs, ctx);
+				io_submit_flush_completions(ctx);
 		} else {
 			io_put_req(req);
 		}
@@ -6676,7 +6675,7 @@ static void io_submit_state_end(struct io_submit_state *state,
 	if (state->link.head)
 		io_queue_sqe(state->link.head);
 	if (state->comp.nr)
-		io_submit_flush_completions(&state->comp, ctx);
+		io_submit_flush_completions(ctx);
 	if (state->plug_started)
 		blk_finish_plug(&state->plug);
 	io_state_file_put(state);
-- 
2.30.2



