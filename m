Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64106810D1
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237102AbjA3OHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237099AbjA3OHE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:07:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7133B644
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:07:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38E936102D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39979C433D2;
        Mon, 30 Jan 2023 14:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087622;
        bh=tPpC3oTeTUOvpksg8hiU7270p4ewTdGdTk6rEf+rkS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEoaAS2IqHZNFZ8D73BkwGpyHA/+s6SLkmkJt1GN1npL0WhRVp0OI3HkY1dhZFfsE
         /YOJuIcXaOD80wY0Bxp6K4pghZa9X4sg+RXXyGvQOi72wtnaBwaG2HLWMUntmARTqI
         9hWDZLVQqmKitVmp7qvT5RBD2g5bJjF/hc741X0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 240/313] io_uring: inline io_req_task_work_add()
Date:   Mon, 30 Jan 2023 14:51:15 +0100
Message-Id: <20230130134347.867056593@linuxfoundation.org>
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

[ Upstream commit e52d2e583e4ad1d5d0b804d79c2b8752eb0e5ceb ]

__io_req_task_work_add() is huge but marked inline, that makes compilers
to generate lots of garbage. Inline the wrapper caller
io_req_task_work_add() instead.

before and after:
   text    data     bss     dec     hex filename
  47347   16248       8   63603    f873 io_uring/io_uring.o
   text    data     bss     dec     hex filename
  45303   16248       8   61559    f077 io_uring/io_uring.o

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/26dc8c28ca0160e3269ef3e55c5a8b917c4d4450.1668162751.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: ef5c600adb1d ("io_uring: always prep_async for drain requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 7 +------
 io_uring/io_uring.h | 7 ++++++-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cea5de98c423..b4f9707730b8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1133,7 +1133,7 @@ static void io_req_local_work_add(struct io_kiocb *req)
 	percpu_ref_put(&ctx->refs);
 }
 
-static inline void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
+void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
 {
 	struct io_uring_task *tctx = req->task->io_uring;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1165,11 +1165,6 @@ static inline void __io_req_task_work_add(struct io_kiocb *req, bool allow_local
 	}
 }
 
-void io_req_task_work_add(struct io_kiocb *req)
-{
-	__io_req_task_work_add(req, true);
-}
-
 static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 {
 	struct llist_node *node;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 4334cd30c423..56ecc1550476 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -51,9 +51,9 @@ static inline bool io_req_ffs_set(struct io_kiocb *req)
 	return req->flags & REQ_F_FIXED_FILE;
 }
 
+void __io_req_task_work_add(struct io_kiocb *req, bool allow_local);
 bool io_is_uring_fops(struct file *file);
 bool io_alloc_async_data(struct io_kiocb *req);
-void io_req_task_work_add(struct io_kiocb *req);
 void io_req_tw_post_queue(struct io_kiocb *req, s32 res, u32 cflags);
 void io_req_task_queue(struct io_kiocb *req);
 void io_queue_iowq(struct io_kiocb *req, bool *dont_use);
@@ -83,6 +83,11 @@ bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
 
+static inline void io_req_task_work_add(struct io_kiocb *req)
+{
+	__io_req_task_work_add(req, true);
+}
+
 #define io_for_each_link(pos, head) \
 	for (pos = (head); pos; pos = pos->link)
 
-- 
2.39.0



