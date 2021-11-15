Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBDC450CD2
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238328AbhKORob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:44:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:54896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238574AbhKORmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:42:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DB1363244;
        Mon, 15 Nov 2021 17:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997257;
        bh=+HyW3jFR8/EdW6DEw9/OuVym9+rQMFtOIpWINHF0u3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x4HYioAEB0tXowKYsXuVJD3/KgotNswRnF4j5uiDnRQKMua+k/rE0cIWPkn18raXw
         GX1cMX/zqkQdTVWE1VVnx9hSuwDUhcubw+FO6tow86HLkJPsKb6hVqsGfuxN1nTjhK
         92JWPwk9pjKZVXxzAx6D5nogR//Vno7uNHDr/n1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/575] block: schedule queue restart after BLK_STS_ZONE_RESOURCE
Date:   Mon, 15 Nov 2021 17:56:40 +0100
Message-Id: <20211115165346.229918629@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 9586e67b911c95ba158fcc247b230e9c2d718623 ]

When dispatching a zone append write request to a SCSI zoned block device,
if the target zone of the request is already locked, the device driver will
return BLK_STS_ZONE_RESOURCE and the request will be pushed back to the
hctx dipatch queue. The queue will be marked as RESTART in
dd_finish_request() and restarted in __blk_mq_free_request(). However, this
restart applies to the hctx of the completed request. If the requeued
request is on a different hctx, dispatch will no be retried until another
request is submitted or the next periodic queue run triggers, leading to up
to 30 seconds latency for the requeued request.

Fix this problem by scheduling a queue restart similarly to the
BLK_STS_RESOURCE case or when we cannot get the budget.

Also, consolidate the checks into the "need_resource" variable to simplify
the condition.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Niklas Cassel <Niklas.Cassel@wdc.com>
Link: https://lore.kernel.org/r/20211026165127.4151055-1-naohiro.aota@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index eed9a4c1519df..69cc552c3dfc9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1327,6 +1327,7 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *hctx, struct list_head *list,
 	int errors, queued;
 	blk_status_t ret = BLK_STS_OK;
 	LIST_HEAD(zone_list);
+	bool needs_resource = false;
 
 	if (list_empty(list))
 		return false;
@@ -1372,6 +1373,8 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *hctx, struct list_head *list,
 			queued++;
 			break;
 		case BLK_STS_RESOURCE:
+			needs_resource = true;
+			fallthrough;
 		case BLK_STS_DEV_RESOURCE:
 			blk_mq_handle_dev_resource(rq, list);
 			goto out;
@@ -1382,6 +1385,7 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *hctx, struct list_head *list,
 			 * accept.
 			 */
 			blk_mq_handle_zone_resource(rq, &zone_list);
+			needs_resource = true;
 			break;
 		default:
 			errors++;
@@ -1408,7 +1412,6 @@ out:
 		/* For non-shared tags, the RESTART check will suffice */
 		bool no_tag = prep == PREP_DISPATCH_NO_TAG &&
 			(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED);
-		bool no_budget_avail = prep == PREP_DISPATCH_NO_BUDGET;
 
 		blk_mq_release_budgets(q, nr_budgets);
 
@@ -1448,14 +1451,16 @@ out:
 		 * If driver returns BLK_STS_RESOURCE and SCHED_RESTART
 		 * bit is set, run queue after a delay to avoid IO stalls
 		 * that could otherwise occur if the queue is idle.  We'll do
-		 * similar if we couldn't get budget and SCHED_RESTART is set.
+		 * similar if we couldn't get budget or couldn't lock a zone
+		 * and SCHED_RESTART is set.
 		 */
 		needs_restart = blk_mq_sched_needs_restart(hctx);
+		if (prep == PREP_DISPATCH_NO_BUDGET)
+			needs_resource = true;
 		if (!needs_restart ||
 		    (no_tag && list_empty_careful(&hctx->dispatch_wait.entry)))
 			blk_mq_run_hw_queue(hctx, true);
-		else if (needs_restart && (ret == BLK_STS_RESOURCE ||
-					   no_budget_avail))
+		else if (needs_restart && needs_resource)
 			blk_mq_delay_run_hw_queue(hctx, BLK_MQ_RESOURCE_DELAY);
 
 		blk_mq_update_dispatch_busy(hctx, true);
-- 
2.33.0



