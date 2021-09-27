Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BB0419C44
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237184AbhI0R0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237231AbhI0RYr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:24:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A3066124B;
        Mon, 27 Sep 2021 17:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762952;
        bh=CkVxm4qE455LDkYcWn6RAzTDGpCIyo60uvJ1XDLToko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFebB4mZPbE8V7X0DxXGxI9Bck0JKZaOqut9dVKbX1bxOeCKtaZj+p1NOF7+EfSfD
         PH0ozhYuJiC4QCzj+YOhZQ7Q0I0yBRt4/X90yIcxnLOPLsHyNpGxXIEpXrUemUCalO
         I3jiV2bEqHLa0Pt9TxtboCWyBIrMAc2HYmCBMMHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 112/162] io_uring: fix race between poll completion and cancel_hash insertion
Date:   Mon, 27 Sep 2021 19:02:38 +0200
Message-Id: <20210927170237.331624373@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Xu <haoxu@linux.alibaba.com>

[ Upstream commit bd99c71bd14072ce2920f6d0c2fe43df072c653c ]

If poll arming and poll completion runs in parallel, there maybe races.
For instance, run io_poll_add in iowq and io_poll_task_func in original
context, then:

  iowq                                      original context
  io_poll_add
    vfs_poll
     (interruption happens
      tw queued to original
      context)                              io_poll_task_func
                                              generate cqe
                                              del from cancel_hash[]
    if !poll.done
      insert to cancel_hash[]

The entry left in cancel_hash[], similar case for fast poll.
Fix it by set poll.done = true when del from cancel_hash[].

Fixes: 5082620fb2ca ("io_uring: terminate multishot poll for CQ ring overflow")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
Link: https://lore.kernel.org/r/20210922101238.7177-2-haoxu@linux.alibaba.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 754d59f734d8..27a1c813f1e1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4968,10 +4968,8 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	}
 	if (req->poll.events & EPOLLONESHOT)
 		flags = 0;
-	if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
-		req->poll.done = true;
+	if (!io_cqring_fill_event(ctx, req->user_data, error, flags))
 		flags = 0;
-	}
 	if (flags & IORING_CQE_F_MORE)
 		ctx->cq_extra++;
 
@@ -4993,6 +4991,7 @@ static void io_poll_task_func(struct io_kiocb *req)
 		if (done) {
 			io_poll_remove_double(req);
 			hash_del(&req->hash_node);
+			req->poll.done = true;
 		} else {
 			req->result = 0;
 			add_wait_queue(req->poll.head, &req->poll.wait);
@@ -5126,6 +5125,7 @@ static void io_async_task_func(struct io_kiocb *req)
 
 	hash_del(&req->hash_node);
 	io_poll_remove_double(req);
+	apoll->poll.done = true;
 	spin_unlock_irq(&ctx->completion_lock);
 
 	if (!READ_ONCE(apoll->poll.canceled))
-- 
2.33.0



