Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB9F6810B2
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbjA3OFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237081AbjA3OFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:05:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F9321958
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:05:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63B146102D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70083C433EF;
        Mon, 30 Jan 2023 14:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087545;
        bh=7KPlJWk0mCQabUy8qLBKYSLQTy3V4deUbiBESu0tVNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gwOexrYeBBAsesN+g9kBuANVUccvbj0uMNHtKSPpjzyzl/8QcUnoo0/CkG7do3Qhv
         NlwK71eoNRu9ddREPcrSbCAJVgm/Wt5DBEgPMMvWDABbZUOgWuCuZbG2oT8C16mD44
         AsngK2TL1zPn20vQ6sf/Wa449qiBM7tkSnAf4iDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 244/313] io_uring: remove io_req_tw_post_queue
Date:   Mon, 30 Jan 2023 14:51:19 +0100
Message-Id: <20230130134348.057749901@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 833b5dfffc26c81835ce38e2a5df9ac5fa142735 ]

Remove io_req_tw_post() and io_req_tw_post_queue(), we can use
io_req_task_complete() instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b9b73c08022c7f1457023ac841f35c0100e70345.1669203009.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: ef5c600adb1d ("io_uring: always prep_async for drain requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 12 ------------
 io_uring/io_uring.h |  8 +++++++-
 io_uring/timeout.c  |  6 +++---
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6b81a0d2d9bc..50f959ffb55c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1236,18 +1236,6 @@ int io_run_local_work(struct io_ring_ctx *ctx)
 	return ret;
 }
 
-static void io_req_tw_post(struct io_kiocb *req, bool *locked)
-{
-	io_req_complete_post(req);
-}
-
-void io_req_tw_post_queue(struct io_kiocb *req, s32 res, u32 cflags)
-{
-	io_req_set_res(req, res, cflags);
-	req->io_task_work.func = io_req_tw_post;
-	io_req_task_work_add(req);
-}
-
 static void io_req_task_cancel(struct io_kiocb *req, bool *locked)
 {
 	/* not needed for normal modes, but SQPOLL depends on it */
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 0cf544ba6656..90b675c65b84 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -53,7 +53,6 @@ static inline bool io_req_ffs_set(struct io_kiocb *req)
 void __io_req_task_work_add(struct io_kiocb *req, bool allow_local);
 bool io_is_uring_fops(struct file *file);
 bool io_alloc_async_data(struct io_kiocb *req);
-void io_req_tw_post_queue(struct io_kiocb *req, s32 res, u32 cflags);
 void io_req_task_queue(struct io_kiocb *req);
 void io_queue_iowq(struct io_kiocb *req, bool *dont_use);
 void io_req_task_complete(struct io_kiocb *req, bool *locked);
@@ -380,4 +379,11 @@ static inline bool io_allowed_run_tw(struct io_ring_ctx *ctx)
 		      ctx->submitter_task == current);
 }
 
+static inline void io_req_queue_tw_complete(struct io_kiocb *req, s32 res)
+{
+	io_req_set_res(req, res, 0);
+	req->io_task_work.func = io_req_task_complete;
+	io_req_task_work_add(req);
+}
+
 #endif
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 16b006bbbb11..4c6a5666541c 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -63,7 +63,7 @@ static bool io_kill_timeout(struct io_kiocb *req, int status)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&timeout->list);
-		io_req_tw_post_queue(req, status, 0);
+		io_req_queue_tw_complete(req, status);
 		return true;
 	}
 	return false;
@@ -161,7 +161,7 @@ void io_disarm_next(struct io_kiocb *req)
 		req->flags &= ~REQ_F_ARM_LTIMEOUT;
 		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
 			io_remove_next_linked(req);
-			io_req_tw_post_queue(link, -ECANCELED, 0);
+			io_req_queue_tw_complete(link, -ECANCELED);
 		}
 	} else if (req->flags & REQ_F_LINK_TIMEOUT) {
 		struct io_ring_ctx *ctx = req->ctx;
@@ -170,7 +170,7 @@ void io_disarm_next(struct io_kiocb *req)
 		link = io_disarm_linked_timeout(req);
 		spin_unlock_irq(&ctx->timeout_lock);
 		if (link)
-			io_req_tw_post_queue(link, -ECANCELED, 0);
+			io_req_queue_tw_complete(link, -ECANCELED);
 	}
 	if (unlikely((req->flags & REQ_F_FAIL) &&
 		     !(req->flags & REQ_F_HARDLINK)))
-- 
2.39.0



