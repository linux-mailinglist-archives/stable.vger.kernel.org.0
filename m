Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A853DD970
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbhHBOAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235909AbhHBN7H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:59:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 383B1610FD;
        Mon,  2 Aug 2021 13:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912526;
        bh=Z6C+iaBIA7e0xMzMq2365IxgphhBS5NSUy7RdbSHsGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ULvDV4KVPYW7gQE0LSnK1mH16PbTwVdIBe0Vlxkld21ITQPRmGQ2b9fbK3NU7gS7B
         kcK6C0t5u/z/9Zqd2vCjDwF/RLWqD5buySx1lBFOQj9MhLuPSmqOBCERk/WC5xO4cp
         7+/bo3dD7kva8vSij58q6DA9zlnFPLhE9rVcdQUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 033/104] io_uring: fix poll requests leaking second poll entries
Date:   Mon,  2 Aug 2021 15:44:30 +0200
Message-Id: <20210802134345.107815242@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Xu <haoxu@linux.alibaba.com>

commit a890d01e4ee016978776e45340e521b3bbbdf41f upstream.

For pure poll requests, it doesn't remove the second poll wait entry
when it's done, neither after vfs_poll() or in the poll completion
handler. We should remove the second poll wait entry.
And we use io_poll_remove_double() rather than io_poll_remove_waitqs()
since the latter has some redundant logic.

Fixes: 88e41cf928a6 ("io_uring: add multishot mode for IORING_OP_POLL_ADD")
Cc: stable@vger.kernel.org # 5.13+
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
Link: https://lore.kernel.org/r/20210728030322.12307-1-haoxu@linux.alibaba.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4924,7 +4924,6 @@ static bool io_poll_complete(struct io_k
 	if (req->poll.events & EPOLLONESHOT)
 		flags = 0;
 	if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
-		io_poll_remove_waitqs(req);
 		req->poll.done = true;
 		flags = 0;
 	}
@@ -4948,6 +4947,7 @@ static void io_poll_task_func(struct cal
 
 		done = io_poll_complete(req, req->result);
 		if (done) {
+			io_poll_remove_double(req);
 			hash_del(&req->hash_node);
 		} else {
 			req->result = 0;
@@ -5136,7 +5136,7 @@ static __poll_t __io_arm_poll_handler(st
 		ipt->error = -EINVAL;
 
 	spin_lock_irq(&ctx->completion_lock);
-	if (ipt->error)
+	if (ipt->error || (mask && (poll->events & EPOLLONESHOT)))
 		io_poll_remove_double(req);
 	if (likely(poll->head)) {
 		spin_lock(&poll->head->lock);
@@ -5207,7 +5207,6 @@ static bool io_arm_poll_handler(struct i
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
 	if (ret || ipt.error) {
-		io_poll_remove_double(req);
 		spin_unlock_irq(&ctx->completion_lock);
 		return false;
 	}


