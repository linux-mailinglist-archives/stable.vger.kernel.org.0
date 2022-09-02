Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3005AB0DF
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238347AbiIBM7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238559AbiIBM7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:59:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873E86566D;
        Fri,  2 Sep 2022 05:40:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51B07B82AA3;
        Fri,  2 Sep 2022 12:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A44C433D6;
        Fri,  2 Sep 2022 12:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121870;
        bh=rzOgIZZWdpCTyq64HY1ag4uSWjHGb9DsGx3w7MOT8DM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kA1i3TDQAy5+XSNV/0PNL9X6G/LGHJTYuSvD47fRmaUM3UJyy0ZsELuCFMQKr8tb7
         BjZUAwc0pCiYApPF78EYA3WxuVR9V5PG5+t41PyNxI9IOCLxbnNs1kH0A8lIc+RD0d
         ew6JgA0r6fNZK3qYvK4/BmKmxKSHg3clYfkqCsF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 14/73] io_uring: move common poll bits
Date:   Fri,  2 Sep 2022 14:18:38 +0200
Message-Id: <20220902121404.906439146@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ upstream commmit 5641897a5e8fb8abeb07e89c71a788d3db3ec75e ]

Move some poll helpers/etc up, we'll need them there shortly

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/6c5c3dba24c86aad5cd389a54a8c7412e6a0621d.1639605189.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   74 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 37 insertions(+), 37 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5318,6 +5318,43 @@ struct io_poll_table {
 	int error;
 };
 
+static struct io_poll_iocb *io_poll_get_double(struct io_kiocb *req)
+{
+	/* pure poll stashes this in ->async_data, poll driven retry elsewhere */
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return req->async_data;
+	return req->apoll->double_poll;
+}
+
+static struct io_poll_iocb *io_poll_get_single(struct io_kiocb *req)
+{
+	if (req->opcode == IORING_OP_POLL_ADD)
+		return &req->poll;
+	return &req->apoll->poll;
+}
+
+static void io_poll_req_insert(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct hlist_head *list;
+
+	list = &ctx->cancel_hash[hash_long(req->user_data, ctx->cancel_hash_bits)];
+	hlist_add_head(&req->hash_node, list);
+}
+
+static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
+			      wait_queue_func_t wake_func)
+{
+	poll->head = NULL;
+	poll->done = false;
+	poll->canceled = false;
+#define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
+	/* mask in events that we always want/need */
+	poll->events = events | IO_POLL_UNMASK;
+	INIT_LIST_HEAD(&poll->wait.entry);
+	init_waitqueue_func_entry(&poll->wait, wake_func);
+}
+
 static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 			   __poll_t mask, io_req_tw_func_t func)
 {
@@ -5366,21 +5403,6 @@ static bool io_poll_rewait(struct io_kio
 	return false;
 }
 
-static struct io_poll_iocb *io_poll_get_double(struct io_kiocb *req)
-{
-	/* pure poll stashes this in ->async_data, poll driven retry elsewhere */
-	if (req->opcode == IORING_OP_POLL_ADD)
-		return req->async_data;
-	return req->apoll->double_poll;
-}
-
-static struct io_poll_iocb *io_poll_get_single(struct io_kiocb *req)
-{
-	if (req->opcode == IORING_OP_POLL_ADD)
-		return &req->poll;
-	return &req->apoll->poll;
-}
-
 static void io_poll_remove_double(struct io_kiocb *req)
 	__must_hold(&req->ctx->completion_lock)
 {
@@ -5505,19 +5527,6 @@ static int io_poll_double_wake(struct wa
 	return 1;
 }
 
-static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
-			      wait_queue_func_t wake_func)
-{
-	poll->head = NULL;
-	poll->done = false;
-	poll->canceled = false;
-#define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
-	/* mask in events that we always want/need */
-	poll->events = events | IO_POLL_UNMASK;
-	INIT_LIST_HEAD(&poll->wait.entry);
-	init_waitqueue_func_entry(&poll->wait, wake_func);
-}
-
 static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 			    struct wait_queue_head *head,
 			    struct io_poll_iocb **poll_ptr)
@@ -5612,15 +5621,6 @@ static int io_async_wake(struct wait_que
 	return __io_async_wake(req, poll, key_to_poll(key), io_async_task_func);
 }
 
-static void io_poll_req_insert(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	struct hlist_head *list;
-
-	list = &ctx->cancel_hash[hash_long(req->user_data, ctx->cancel_hash_bits)];
-	hlist_add_head(&req->hash_node, list);
-}
-
 static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 				      struct io_poll_iocb *poll,
 				      struct io_poll_table *ipt, __poll_t mask,


