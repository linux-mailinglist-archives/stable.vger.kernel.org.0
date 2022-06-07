Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476FC54146C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356695AbiFGUSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376695AbiFGURC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:17:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB2A1CF928;
        Tue,  7 Jun 2022 11:29:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A989B82340;
        Tue,  7 Jun 2022 18:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EDDC385A5;
        Tue,  7 Jun 2022 18:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626585;
        bh=qZM53PJaEz+KQbLaullZG2W4N+NLnXtXuxxsfK5Pj1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRajJLXI3YZUeXShPCKroCKTqp5hBq4XABxeJPyJMIXjAKEAIA5943dwRH0FXIwOY
         Fx912djTOCeShQ5RiZsgGusC46aBBvwK9950Ph/pntUmHkD+HTGwbWI+cNHiA/gEQo
         vfbsqlvBnFf4xhFe8GkYy8WZx7yhH/QtDDKALVfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 390/772] io_uring: cache poll/double-poll state with a request flag
Date:   Tue,  7 Jun 2022 18:59:42 +0200
Message-Id: <20220607165000.505431741@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 91eac1c69c202d9dad8bf717ae5b92db70bfe5cf ]

With commit "io_uring: cache req->apoll->events in req->cflags" applied,
we now have just io_poll_remove_entries() dipping into req->apoll when
it isn't strictly necessary.

Mark poll and double-poll with a flag, so we know if we need to look
at apoll->double_poll. This avoids pulling in those cachelines if we
don't need them. The common case is that the poll wake handler already
removed these entries while hot off the completion path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 26bf488096b2..8711d92f4d71 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -740,6 +740,8 @@ enum {
 	REQ_F_ARM_LTIMEOUT_BIT,
 	REQ_F_ASYNC_DATA_BIT,
 	REQ_F_SKIP_LINK_CQES_BIT,
+	REQ_F_SINGLE_POLL_BIT,
+	REQ_F_DOUBLE_POLL_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -798,6 +800,10 @@ enum {
 	REQ_F_ASYNC_DATA	= BIT(REQ_F_ASYNC_DATA_BIT),
 	/* don't post CQEs while failing linked requests */
 	REQ_F_SKIP_LINK_CQES	= BIT(REQ_F_SKIP_LINK_CQES_BIT),
+	/* single poll may be active */
+	REQ_F_SINGLE_POLL	= BIT(REQ_F_SINGLE_POLL_BIT),
+	/* double poll may active */
+	REQ_F_DOUBLE_POLL	= BIT(REQ_F_DOUBLE_POLL_BIT),
 };
 
 struct async_poll {
@@ -5464,8 +5470,12 @@ static inline void io_poll_remove_entry(struct io_poll_iocb *poll)
 
 static void io_poll_remove_entries(struct io_kiocb *req)
 {
-	struct io_poll_iocb *poll = io_poll_get_single(req);
-	struct io_poll_iocb *poll_double = io_poll_get_double(req);
+	/*
+	 * Nothing to do if neither of those flags are set. Avoid dipping
+	 * into the poll/apoll/double cachelines if we can.
+	 */
+	if (!(req->flags & (REQ_F_SINGLE_POLL | REQ_F_DOUBLE_POLL)))
+		return;
 
 	/*
 	 * While we hold the waitqueue lock and the waitqueue is nonempty,
@@ -5483,9 +5493,10 @@ static void io_poll_remove_entries(struct io_kiocb *req)
 	 * In that case, only RCU prevents the queue memory from being freed.
 	 */
 	rcu_read_lock();
-	io_poll_remove_entry(poll);
-	if (poll_double)
-		io_poll_remove_entry(poll_double);
+	if (req->flags & REQ_F_SINGLE_POLL)
+		io_poll_remove_entry(io_poll_get_single(req));
+	if (req->flags & REQ_F_DOUBLE_POLL)
+		io_poll_remove_entry(io_poll_get_double(req));
 	rcu_read_unlock();
 }
 
@@ -5662,6 +5673,7 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 		if (mask && poll->events & EPOLLONESHOT) {
 			list_del_init(&poll->wait.entry);
 			poll->head = NULL;
+			req->flags &= ~REQ_F_SINGLE_POLL;
 		}
 		__io_poll_execute(req, mask);
 	}
@@ -5698,12 +5710,14 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 			pt->error = -ENOMEM;
 			return;
 		}
+		req->flags |= REQ_F_DOUBLE_POLL;
 		io_init_poll_iocb(poll, first->events, first->wait.func);
 		*poll_ptr = poll;
 		if (req->opcode == IORING_OP_POLL_ADD)
 			req->flags |= REQ_F_ASYNC_DATA;
 	}
 
+	req->flags |= REQ_F_SINGLE_POLL;
 	pt->nr_entries++;
 	poll->head = head;
 	poll->wait.private = req;
-- 
2.35.1



