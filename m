Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20772E64DE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390873AbgL1Pxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:53:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:37220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390757AbgL1Nh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:37:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB9942072C;
        Mon, 28 Dec 2020 13:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162630;
        bh=zRaxgOSMWQ1QxiCdSjYePYYnmU0RFJSGGcRQu2LSqjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2K3c5B5RnfJJMrxk8MkKn2ag4j5qkNy0OoCa5PQcA8Erhi4xP7D8jMvwbp4t9E5rc
         ri9lyvanX/+GoDtE6mhDag2BkOECp6JczbmC6XGx8QdAc7b5e7yqNhRm+/cMf03rUU
         sLYB2nWmjgwRASZP+MO53qmO8HfGP+iiQ0sqCQmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/453] block: factor out requeue handling from dispatch code
Date:   Mon, 28 Dec 2020 13:44:15 +0100
Message-Id: <20201228124938.177936298@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit c92a41031a6d57395889b5c87cea359220a24d2a ]

Factor out the requeue handling from the dispatch code, this will make
subsequent addition of different requeueing schemes easier.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b748d1e63f9c8..c0efd3e278da6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1205,6 +1205,23 @@ static void blk_mq_update_dispatch_busy(struct blk_mq_hw_ctx *hctx, bool busy)
 
 #define BLK_MQ_RESOURCE_DELAY	3		/* ms units */
 
+static void blk_mq_handle_dev_resource(struct request *rq,
+				       struct list_head *list)
+{
+	struct request *next =
+		list_first_entry_or_null(list, struct request, queuelist);
+
+	/*
+	 * If an I/O scheduler has been configured and we got a driver tag for
+	 * the next request already, free it.
+	 */
+	if (next)
+		blk_mq_put_driver_tag(next);
+
+	list_add(&rq->queuelist, list);
+	__blk_mq_requeue_request(rq);
+}
+
 /*
  * Returns true if we did some work AND can potentially do more.
  */
@@ -1274,17 +1291,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 
 		ret = q->mq_ops->queue_rq(hctx, &bd);
 		if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE) {
-			/*
-			 * If an I/O scheduler has been configured and we got a
-			 * driver tag for the next request already, free it
-			 * again.
-			 */
-			if (!list_empty(list)) {
-				nxt = list_first_entry(list, struct request, queuelist);
-				blk_mq_put_driver_tag(nxt);
-			}
-			list_add(&rq->queuelist, list);
-			__blk_mq_requeue_request(rq);
+			blk_mq_handle_dev_resource(rq, list);
 			break;
 		}
 
-- 
2.27.0



