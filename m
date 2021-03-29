Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C78B34DACD
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhC2WXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:23:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232038AbhC2WWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C2EC61997;
        Mon, 29 Mar 2021 22:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056540;
        bh=oUcZmOxZ/BovAOKSzoOf23OC5uVxKRv3KlFb4/d5FcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lg6/Q8y5SWmQ42DLk13/ziRl2ObWh7BgCMtiwxUbAGUt+3JvMx+gvNNH3CXBQc4VO
         itYXV4psM1+vYWSTgwC9tlEVCJsK+ikBRdijWa5aBGkqU/uofkSkxfFssnZB3zjXRg
         g7eQigcX8hwmW6HNdr9OLuE68cShasIVGY4YKcrGV9OJN/d2gybQTMIGSKlou3QWur
         jtOsHsj3/RcfoitemBUsR7kzbusWK6zUH35jX/GbgTOrDSg83jItSopygEG8Btt+cJ
         6G8vnzNL7LCFwEy0iNJUxzFy4i3osj/R/k2uKu2BdvA8RawJM0f9HC2B54b1faFzyI
         oAStHAUz2HxSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 37/38] io_uring: fix timeout cancel return code
Date:   Mon, 29 Mar 2021 18:21:32 -0400
Message-Id: <20210329222133.2382393-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 1ee4160c73b2102a52bc97a4128a89c34821414f ]

When we cancel a timeout we should emit a sensible return code, like
-ECANCELED but not 0, otherwise it may trick users.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/7b0ad1065e3bd1994722702bd0ba9e7bc9b0683b.1616696997.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ef078182e7ca..c85e8ed4a20f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1594,7 +1594,7 @@ static void io_queue_async_work(struct io_kiocb *req)
 		io_queue_linked_timeout(link);
 }
 
-static void io_kill_timeout(struct io_kiocb *req)
+static void io_kill_timeout(struct io_kiocb *req, int status)
 {
 	struct io_timeout_data *io = req->async_data;
 	int ret;
@@ -1604,7 +1604,7 @@ static void io_kill_timeout(struct io_kiocb *req)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-		io_cqring_fill_event(req, 0);
+		io_cqring_fill_event(req, status);
 		io_put_req_deferred(req, 1);
 	}
 }
@@ -1621,7 +1621,7 @@ static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
 		if (io_match_task(req, tsk, files)) {
-			io_kill_timeout(req);
+			io_kill_timeout(req, -ECANCELED);
 			canceled++;
 		}
 	}
@@ -1673,7 +1673,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 			break;
 
 		list_del_init(&req->timeout.list);
-		io_kill_timeout(req);
+		io_kill_timeout(req, 0);
 	} while (!list_empty(&ctx->timeout_list));
 
 	ctx->cq_last_tm_flush = seq;
-- 
2.30.1

