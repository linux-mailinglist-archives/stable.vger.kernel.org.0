Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23519283AA6
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgJEPfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:35:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728153AbgJEPdn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:33:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2391E2074F;
        Mon,  5 Oct 2020 15:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912022;
        bh=NwGYEABwnhd7tpti8vq+8T6uIXyrxquu/uGiVGjFkM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L4FY7YwQgu2pO3uYAIb5gNPOvAFcy0H0sLSlzd0TJiCKNdYPd5lA36IUou+5lWlNb
         vOOuI+dQOeiyJp6PkngZueRgHxUNoHs8Si0nJiiohaYYcODPrtP1vIkJOfnD1WemZm
         j2Wlc9O1PG+rM1DDdAbatl0r+m4f8cX0kZJCulzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        yangerkun <yangerkun@huawei.com>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 69/85] blk-mq: call commit_rqs while list empty but error happen
Date:   Mon,  5 Oct 2020 17:27:05 +0200
Message-Id: <20201005142118.050721161@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

[ Upstream commit 632bfb6323799c087fcb4108dfe59518609667a7 ]

Blk-mq should call commit_rqs once 'bd.last != true' and no more
request will come(so virtscsi can kick the virtqueue, e.g.). We already
do that in 'blk_mq_dispatch_rq_list/blk_mq_try_issue_list_directly' while
list not empty and 'queued > 0'. However, we can seen the same scene
once the last request in list call queue_rq and return error like
BLK_STS_IOERR which will not requeue the request, and lead that list
empty but need call commit_rqs too(Or the request for virtscsi will stay
timeout until other request kick virtqueue).

We found this problem by do fsstress test with offline/online virtscsi
device repeat quickly.

Fixes: d666ba98f849 ("blk-mq: add mq_ops->commit_rqs()")
Reported-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a366726094a89..8e623e0282757 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1304,6 +1304,11 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 
 	hctx->dispatched[queued_to_index(queued)]++;
 
+	/* If we didn't flush the entire list, we could have told the driver
+	 * there was more coming, but that turned out to be a lie.
+	 */
+	if ((!list_empty(list) || errors) && q->mq_ops->commit_rqs && queued)
+		q->mq_ops->commit_rqs(hctx);
 	/*
 	 * Any items that need requeuing? Stuff them into hctx->dispatch,
 	 * that is where we will continue on next queue run.
@@ -1311,14 +1316,6 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 	if (!list_empty(list)) {
 		bool needs_restart;
 
-		/*
-		 * If we didn't flush the entire list, we could have told
-		 * the driver there was more coming, but that turned out to
-		 * be a lie.
-		 */
-		if (q->mq_ops->commit_rqs && queued)
-			q->mq_ops->commit_rqs(hctx);
-
 		spin_lock(&hctx->lock);
 		list_splice_tail_init(list, &hctx->dispatch);
 		spin_unlock(&hctx->lock);
@@ -1971,6 +1968,7 @@ void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
 		struct list_head *list)
 {
 	int queued = 0;
+	int errors = 0;
 
 	while (!list_empty(list)) {
 		blk_status_t ret;
@@ -1987,6 +1985,7 @@ void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
 				break;
 			}
 			blk_mq_end_request(rq, ret);
+			errors++;
 		} else
 			queued++;
 	}
@@ -1996,7 +1995,8 @@ void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
 	 * the driver there was more coming, but that turned out to
 	 * be a lie.
 	 */
-	if (!list_empty(list) && hctx->queue->mq_ops->commit_rqs && queued)
+	if ((!list_empty(list) || errors) &&
+	     hctx->queue->mq_ops->commit_rqs && queued)
 		hctx->queue->mq_ops->commit_rqs(hctx);
 }
 
-- 
2.25.1



