Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97D9359ACA
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhDIKDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:03:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233886AbhDIKA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:00:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03EF0611ED;
        Fri,  9 Apr 2021 09:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962369;
        bh=WoSd683097kphUU08w3/YRFgA6mE8zXqKnxl9kg38lY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wyYbOa7kQwYRZna9x1WTp0Z3Dd5/ze458Y1dSTFI4OgVgelZplh+oAcbs6QbQrozQ
         2a6w2ISCP7WKpURUqtDs0MjCfSB8fmhUFY0z664sYKHS4ZeaiApZd2O2jsdybJMTkX
         M1diN/Jmh1Z8ijEaclJvz5gHRa/OIHsMo+ZVKaiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/41] io_uring: fix timeout cancel return code
Date:   Fri,  9 Apr 2021 11:53:52 +0200
Message-Id: <20210409095305.782146769@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
References: <20210409095304.818847860@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4ccf99cb8cdc..0de27e75460d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1489,7 +1489,7 @@ static void io_queue_async_work(struct io_kiocb *req)
 		io_queue_linked_timeout(link);
 }
 
-static void io_kill_timeout(struct io_kiocb *req)
+static void io_kill_timeout(struct io_kiocb *req, int status)
 {
 	struct io_timeout_data *io = req->async_data;
 	int ret;
@@ -1499,7 +1499,7 @@ static void io_kill_timeout(struct io_kiocb *req)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-		io_cqring_fill_event(req, 0);
+		io_cqring_fill_event(req, status);
 		io_put_req_deferred(req, 1);
 	}
 }
@@ -1516,7 +1516,7 @@ static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
 		if (io_match_task(req, tsk, files)) {
-			io_kill_timeout(req);
+			io_kill_timeout(req, -ECANCELED);
 			canceled++;
 		}
 	}
@@ -1568,7 +1568,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 			break;
 
 		list_del_init(&req->timeout.list);
-		io_kill_timeout(req);
+		io_kill_timeout(req, 0);
 	} while (!list_empty(&ctx->timeout_list));
 
 	ctx->cq_last_tm_flush = seq;
-- 
2.30.2



