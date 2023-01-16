Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D40266C48A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbjAPP4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbjAPPzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:55:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1039722036
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:55:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DD3F60FD4
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B111DC433EF;
        Mon, 16 Jan 2023 15:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884532;
        bh=V0JfRNaoTLQoPs6LYZBTtab8jAPRvEKnGeBqXGySRwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTqAl657DTsBsFZVQIDjwiepeoTA56ogBl25dLgMYv38yzOpW4rgLrJe8TVouUViJ
         jHColUyH2oQQtwDLaIchB4feuG+k6PMWXk7UaBv22KCP5fIXZ6XLardRUclRzFxZmr
         D9o9DjyEXspwUFzZsrlIBhNk81P/Ktzx2mxJOQl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        syzbot+6c95df01470a47fc3af4@syzkaller.appspotmail.com
Subject: [PATCH 6.1 012/183] io_uring/poll: add hash if ready poll request cant complete inline
Date:   Mon, 16 Jan 2023 16:48:55 +0100
Message-Id: <20230116154803.911635956@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit febb985c06cb6f5fac63598c0bffd4fd823d110d upstream.

If we don't, then we may lose access to it completely, leading to a
request leak. This will eventually stall the ring exit process as
well.

Cc: stable@vger.kernel.org
Fixes: 49f1c68e048f ("io_uring: optimise submission side poll_refs")
Reported-and-tested-by: syzbot+6c95df01470a47fc3af4@syzkaller.appspotmail.com
Link: https://lore.kernel.org/io-uring/0000000000009f829805f1ce87b2@google.com/
Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -549,6 +549,14 @@ static bool io_poll_can_finish_inline(st
 	return pt->owning || io_poll_get_ownership(req);
 }
 
+static void io_poll_add_hash(struct io_kiocb *req)
+{
+	if (req->flags & REQ_F_HASH_LOCKED)
+		io_poll_req_insert_locked(req);
+	else
+		io_poll_req_insert(req);
+}
+
 /*
  * Returns 0 when it's handed over for polling. The caller owns the requests if
  * it returns non-zero, but otherwise should not touch it. Negative values
@@ -607,18 +615,17 @@ static int __io_arm_poll_handler(struct
 
 	if (mask &&
 	   ((poll->events & (EPOLLET|EPOLLONESHOT)) == (EPOLLET|EPOLLONESHOT))) {
-		if (!io_poll_can_finish_inline(req, ipt))
+		if (!io_poll_can_finish_inline(req, ipt)) {
+			io_poll_add_hash(req);
 			return 0;
+		}
 		io_poll_remove_entries(req);
 		ipt->result_mask = mask;
 		/* no one else has access to the req, forget about the ref */
 		return 1;
 	}
 
-	if (req->flags & REQ_F_HASH_LOCKED)
-		io_poll_req_insert_locked(req);
-	else
-		io_poll_req_insert(req);
+	io_poll_add_hash(req);
 
 	if (mask && (poll->events & EPOLLET) &&
 	    io_poll_can_finish_inline(req, ipt)) {


