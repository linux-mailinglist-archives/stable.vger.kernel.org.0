Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770EB5A4E32
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 15:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiH2Nea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 09:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiH2Ne1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 09:34:27 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FE5422F3
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:26 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id k17so4270666wmr.2
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 06:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=4gCMBt7gKxoKMRc38jVk4wGEfVHD8UdPM1sL3OAMvJY=;
        b=n3GVfwhYCuIUMm+UYb+3xFRjD5UudJBFYcnogisSUFoh02AIX52T4J4zSFzC7GXiM3
         VjgNkZQ4RJ0BHz+99SWDQmbbaJpVGg8PcKQvFEyvegqoQPNytM+RuuPvH7viU58CCDU9
         OfVfHfiLbkfWCAlf3ZGxuHnPnJN5X2Z2v4DmZu2wwr9c2qMV4awaiii5g5P0WVxcfYg+
         J6MOJVps7KjOgzBRzXvAeb92k9U/CTKFqUMaH9EhXmL+BwsO9NdnkxMD42t0ef8VVHSx
         JSGjWx6G/437Elw45UCleRpyyPXEsTRshdzNHkCuqukY5MMoHYt/rwDkxNfunpw6d1wj
         Fybw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=4gCMBt7gKxoKMRc38jVk4wGEfVHD8UdPM1sL3OAMvJY=;
        b=2PgqfVsaUDiFcS9SIW95AvAVi7nHut3Gf30D4Z4gvchMsvjuDDhtWYUVsyLR69uniC
         xvjjtzcYRd6oH2M8ADeXlT+DUFWGVYE9qSR1Nt5pu67AygLl8ZnF554MKhJx49h3mC1b
         vebH+RJW3I8HHrpVRkfbM0vZyzswsWfgyrDSHXSOOnzVUR5m8wgyW0WV/ISkzSAnvwio
         W3HbTQX4xwTeyv/snec44/kIu0aSrnUmnHzyxwuR3fuw5h8paNKhX2xSwrIMjajie19P
         H6/3NUfgt1/+0UhG8tku1O7r8yb7z+nhXGSVHIQ2Nleb6A0Mc7NBAuyzm82uzB4QBs3W
         75pw==
X-Gm-Message-State: ACgBeo1dIbYpuzRgH8bcuZeWalfays9v+ZGxSY0+EFAxzjNZIYiJbHZb
        bw+uE2s29n8t9Wqr3EU03ws5sm6e+nA=
X-Google-Smtp-Source: AA6agR5TnfZuFu9Ac3J8WeA3FmObK9VJJ58iemCGTHeEkGSjE0+us6G8t4AAC0FK5Vj3Psih9a2vUA==
X-Received: by 2002:a05:600c:501f:b0:3a5:54ff:625f with SMTP id n31-20020a05600c501f00b003a554ff625fmr7056227wmr.5.1661780064964;
        Mon, 29 Aug 2022 06:34:24 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id bn6-20020a056000060600b00222ed7ea203sm4897361wrb.100.2022.08.29.06.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 06:34:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 04/13] io_uring: move common poll bits
Date:   Mon, 29 Aug 2022 14:30:15 +0100
Message-Id: <6d53d9981de4757a8624d97917f3a2bed7c145ad.1661594698.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1661594698.git.asml.silence@gmail.com>
References: <cover.1661594698.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commmit 5641897a5e8fb8abeb07e89c71a788d3db3ec75e ]

Move some poll helpers/etc up, we'll need them there shortly

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/6c5c3dba24c86aad5cd389a54a8c7412e6a0621d.1639605189.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 74 +++++++++++++++++++++++++--------------------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7d58da54664b..8fa257b62ba7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5312,6 +5312,43 @@ struct io_poll_table {
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
@@ -5360,21 +5397,6 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
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
@@ -5499,19 +5521,6 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
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
@@ -5606,15 +5615,6 @@ static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
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
-- 
2.37.2

