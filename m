Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC5155C385
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238355AbiF0Lu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238600AbiF0Lsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B2AD51;
        Mon, 27 Jun 2022 04:42:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5724FB80D32;
        Mon, 27 Jun 2022 11:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7447C3411D;
        Mon, 27 Jun 2022 11:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330174;
        bh=J7cTMdkCM5oMYi/ifmTPBuUGMJ5bnPmv/FfH5KlXHTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DrJDHgKa8uORRr9fWZNDg2a10Ij8go8gmpVErn6xpsqUoHlIqG+khBeVUn9JKO/yY
         taIaw3qU0whgZ+vhDiS0Pe65K/epDrMxwhFwlZqLZQoIfFfVvMNcul96PGRPfhUDrL
         lJXEvH67c5UM3YYthi/52Odh95+XnFh/lCe3eQNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 109/181] io_uring: fix req->apoll_events
Date:   Mon, 27 Jun 2022 13:21:22 +0200
Message-Id: <20220627111947.860146768@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit aacf2f9f382c91df73f33317e28a4c34c8038986 ]

apoll_events should be set once in the beginning of poll arming just as
poll->events and not change after. However, currently io_uring resets it
on each __io_poll_execute() for no clear reason. There is also a place
in __io_arm_poll_handler() where we add EPOLLONESHOT to downgrade a
multishot, but forget to do the same thing with ->apoll_events, which is
buggy.

Fixes: 81459350d581e ("io_uring: cache req->apoll->events in req->cflags")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Hao Xu <howeyxu@tencent.com>
Link: https://lore.kernel.org/r/0aef40399ba75b1a4d2c2e85e6e8fd93c02fc6e4.1655814213.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1070d22a1c2b..38ecea726254 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5984,7 +5984,8 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 		io_req_complete_failed(req, ret);
 }
 
-static void __io_poll_execute(struct io_kiocb *req, int mask, __poll_t events)
+static void __io_poll_execute(struct io_kiocb *req, int mask,
+			      __poll_t __maybe_unused events)
 {
 	req->result = mask;
 	/*
@@ -5993,7 +5994,6 @@ static void __io_poll_execute(struct io_kiocb *req, int mask, __poll_t events)
 	 * CPU. We want to avoid pulling in req->apoll->events for that
 	 * case.
 	 */
-	req->apoll_events = events;
 	if (req->opcode == IORING_OP_POLL_ADD)
 		req->io_task_work.func = io_poll_task_func;
 	else
@@ -6143,6 +6143,8 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	io_init_poll_iocb(poll, mask, io_poll_wake);
 	poll->file = req->file;
 
+	req->apoll_events = poll->events;
+
 	ipt->pt._key = mask;
 	ipt->req = req;
 	ipt->error = 0;
@@ -6173,8 +6175,10 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 
 	if (mask) {
 		/* can't multishot if failed, just queue the event we've got */
-		if (unlikely(ipt->error || !ipt->nr_entries))
+		if (unlikely(ipt->error || !ipt->nr_entries)) {
 			poll->events |= EPOLLONESHOT;
+			req->apoll_events |= EPOLLONESHOT;
+		}
 		__io_poll_execute(req, mask, poll->events);
 		return 0;
 	}
@@ -6387,7 +6391,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return -EINVAL;
 
 	io_req_set_refcount(req);
-	req->apoll_events = poll->events = io_poll_parse_events(sqe, flags);
+	poll->events = io_poll_parse_events(sqe, flags);
 	return 0;
 }
 
-- 
2.35.1



