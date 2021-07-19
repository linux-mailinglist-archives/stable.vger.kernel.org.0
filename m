Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F0A3CE364
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242460AbhGSPhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347618AbhGSPfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9B9461476;
        Mon, 19 Jul 2021 16:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711151;
        bh=z/idJtO2fmAysfEbqmeI2yUnBZjCz+JhCMR8s1FpOgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMzoYiLBoP3NTF7EuaXz6pgdZWDqi6SKMSmXJCBJXfhOeu0AS/B8dTKfhi2xdNY8m
         RPZWqvavmq/81MQXsCApvWOes02LdrNTBd4t25qBRb2KCz3HwmqR+1pXLT5sLKLe6X
         9kDU6j8o887983A8s2LI89IrGYq/if8Mttk+0rxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 247/351] io_uring: inline __tctx_task_work()
Date:   Mon, 19 Jul 2021 16:53:13 +0200
Message-Id: <20210719144953.113930098@linuxfoundation.org>
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

[ Upstream commit 3f18407dc6f2db0968daaa36c39a772c2c9f8ea7 ]

Inline __tctx_task_work() into tctx_task_work() in preparation for
further optimisations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f9c05c4bc9763af7bd8e25ebc3c5f7b6f69148f8.1623949695.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 67 ++++++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 36 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ab1dcf69217f..262e6748c88a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1883,48 +1883,43 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx)
 	percpu_ref_put(&ctx->refs);
 }
 
-static bool __tctx_task_work(struct io_uring_task *tctx)
-{
-	struct io_ring_ctx *ctx = NULL;
-	struct io_wq_work_list list;
-	struct io_wq_work_node *node;
-
-	if (wq_list_empty(&tctx->task_list))
-		return false;
-
-	spin_lock_irq(&tctx->task_lock);
-	list = tctx->task_list;
-	INIT_WQ_LIST(&tctx->task_list);
-	spin_unlock_irq(&tctx->task_lock);
-
-	node = list.first;
-	while (node) {
-		struct io_wq_work_node *next = node->next;
-		struct io_kiocb *req;
-
-		req = container_of(node, struct io_kiocb, io_task_work.node);
-		if (req->ctx != ctx) {
-			ctx_flush_and_put(ctx);
-			ctx = req->ctx;
-			percpu_ref_get(&ctx->refs);
-		}
-
-		req->task_work.func(&req->task_work);
-		node = next;
-	}
-
-	ctx_flush_and_put(ctx);
-	return list.first != NULL;
-}
-
 static void tctx_task_work(struct callback_head *cb)
 {
-	struct io_uring_task *tctx = container_of(cb, struct io_uring_task, task_work);
+	struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
+						  task_work);
 
 	clear_bit(0, &tctx->task_state);
 
-	while (__tctx_task_work(tctx))
+	while (!wq_list_empty(&tctx->task_list)) {
+		struct io_ring_ctx *ctx = NULL;
+		struct io_wq_work_list list;
+		struct io_wq_work_node *node;
+
+		spin_lock_irq(&tctx->task_lock);
+		list = tctx->task_list;
+		INIT_WQ_LIST(&tctx->task_list);
+		spin_unlock_irq(&tctx->task_lock);
+
+		node = list.first;
+		while (node) {
+			struct io_wq_work_node *next = node->next;
+			struct io_kiocb *req = container_of(node, struct io_kiocb,
+							    io_task_work.node);
+
+			if (req->ctx != ctx) {
+				ctx_flush_and_put(ctx);
+				ctx = req->ctx;
+				percpu_ref_get(&ctx->refs);
+			}
+			req->task_work.func(&req->task_work);
+			node = next;
+		}
+
+		ctx_flush_and_put(ctx);
+		if (!list.first)
+			break;
 		cond_resched();
+	}
 }
 
 static int io_req_task_work_add(struct io_kiocb *req)
-- 
2.30.2



