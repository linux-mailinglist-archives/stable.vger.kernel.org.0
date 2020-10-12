Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142AF28B734
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730741AbgJLNlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731479AbgJLNk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:40:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C90A22251;
        Mon, 12 Oct 2020 13:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510041;
        bh=rjrl0Ls/mbSxzZlEReEJPOdJnZuvEanliAYtSQJXGaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NRxNY2jWOGxP4QgbTxyBNFVMrbWc3cYr9kKaVUFG9s+LlEae1RX7jr0bEUKdbPBhu
         wseGDXY2rW75mlJZs6RcXKIAlFcY4wyfJ1lZGBjjZmF/wF9pz++tn7M2Y+y1m80BS8
         NwDvnsLJr73ovjVie0YoZ8xjotpQaD/nEnxMVo/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 08/85] io_uring: Fix double list add in io_queue_async_work()
Date:   Mon, 12 Oct 2020 15:26:31 +0200
Message-Id: <20201012132633.262486432@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

If we queue work in io_poll_wake(), it will leads to list double
add. So we should add the list when the callback func is the
io_sq_wq_submit_work.

The following oops was seen:

    list_add double add: new=ffff9ca6a8f1b0e0, prev=ffff9ca62001cee8,
    next=ffff9ca6a8f1b0e0.
    ------------[ cut here ]------------
    kernel BUG at lib/list_debug.c:31!
    Call Trace:
     <IRQ>
     io_poll_wake+0xf3/0x230
     __wake_up_common+0x91/0x170
     __wake_up_common_lock+0x7a/0xc0
     io_commit_cqring+0xea/0x280
     ? blkcg_iolatency_done_bio+0x2b/0x610
     io_cqring_add_event+0x3e/0x60
     io_complete_rw+0x58/0x80
     dio_complete+0x106/0x250
     blk_update_request+0xa0/0x3b0
     blk_mq_end_request+0x1a/0x110
     blk_mq_complete_request+0xd0/0xe0
     nvme_irq+0x129/0x270 [nvme]
     __handle_irq_event_percpu+0x7b/0x190
     handle_irq_event_percpu+0x30/0x80
     handle_irq_event+0x3c/0x60
     handle_edge_irq+0x91/0x1e0
     do_IRQ+0x4d/0xd0
     common_interrupt+0xf/0xf

Fixes: 1c4404efcf2c ("io_uring: make sure async workqueue is canceled on exit")
Reported-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -514,12 +514,14 @@ static inline void io_queue_async_work(s
 		}
 	}
 
-	req->files = current->files;
+	if (req->work.func == io_sq_wq_submit_work) {
+		req->files = current->files;
 
-	spin_lock_irqsave(&ctx->task_lock, flags);
-	list_add(&req->task_list, &ctx->task_list);
-	req->work_task = NULL;
-	spin_unlock_irqrestore(&ctx->task_lock, flags);
+		spin_lock_irqsave(&ctx->task_lock, flags);
+		list_add(&req->task_list, &ctx->task_list);
+		req->work_task = NULL;
+		spin_unlock_irqrestore(&ctx->task_lock, flags);
+	}
 
 	queue_work(ctx->sqo_wq[rw], &req->work);
 }
@@ -668,6 +670,7 @@ static struct io_kiocb *io_get_req(struc
 		state->cur_req++;
 	}
 
+	INIT_LIST_HEAD(&req->task_list);
 	req->file = NULL;
 	req->ctx = ctx;
 	req->flags = 0;


