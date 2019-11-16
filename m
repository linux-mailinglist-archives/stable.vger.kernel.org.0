Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91CB2FF2AE
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfKPQUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:20:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728951AbfKPPoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:44:25 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19A9020815;
        Sat, 16 Nov 2019 15:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919064;
        bh=mWW3zUmpWqa8PsbRflRCuBiivAf9/7lamvMNjRLzUvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D8KYDIXPgrdwqNyb+ZWF3InfmVqKiOyO7jsio7B5wHCJ6lOiyCG0SYrl0lhy5f5+m
         n06Y3FCbVh9XKCLOcSFHW4wpDnXJJSKbrB1JSHs07iiyzNY0l13jemR40I0YNLXsHr
         uvkxOlXWlz+mFCmIrQm02E9TKWaZh9aBE3Edtztw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianchao Wang <jianchao.w.wang@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 136/237] block: fix the DISCARD request merge
Date:   Sat, 16 Nov 2019 10:39:31 -0500
Message-Id: <20191116154113.7417-136-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianchao Wang <jianchao.w.wang@oracle.com>

[ Upstream commit 69840466086d2248898020a08dda52732686c4e6 ]

There are two cases when handle DISCARD merge.
If max_discard_segments == 1, the bios/requests need to be contiguous
to merge. If max_discard_segments > 1, it takes every bio as a range
and different range needn't to be contiguous.

But now, attempt_merge screws this up. It always consider contiguity
for DISCARD for the case max_discard_segments > 1 and cannot merge
contiguous DISCARD for the case max_discard_segments == 1, because
rq_attempt_discard_merge always returns false in this case.
This patch fixes both of the two cases above.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c | 46 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2e042190a4f1c..1dced51de1c6c 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -669,6 +669,31 @@ static void blk_account_io_merge(struct request *req)
 		part_stat_unlock();
 	}
 }
+/*
+ * Two cases of handling DISCARD merge:
+ * If max_discard_segments > 1, the driver takes every bio
+ * as a range and send them to controller together. The ranges
+ * needn't to be contiguous.
+ * Otherwise, the bios/requests will be handled as same as
+ * others which should be contiguous.
+ */
+static inline bool blk_discard_mergable(struct request *req)
+{
+	if (req_op(req) == REQ_OP_DISCARD &&
+	    queue_max_discard_segments(req->q) > 1)
+		return true;
+	return false;
+}
+
+enum elv_merge blk_try_req_merge(struct request *req, struct request *next)
+{
+	if (blk_discard_mergable(req))
+		return ELEVATOR_DISCARD_MERGE;
+	else if (blk_rq_pos(req) + blk_rq_sectors(req) == blk_rq_pos(next))
+		return ELEVATOR_BACK_MERGE;
+
+	return ELEVATOR_NO_MERGE;
+}
 
 /*
  * For non-mq, this has to be called with the request spinlock acquired.
@@ -686,12 +711,6 @@ static struct request *attempt_merge(struct request_queue *q,
 	if (req_op(req) != req_op(next))
 		return NULL;
 
-	/*
-	 * not contiguous
-	 */
-	if (blk_rq_pos(req) + blk_rq_sectors(req) != blk_rq_pos(next))
-		return NULL;
-
 	if (rq_data_dir(req) != rq_data_dir(next)
 	    || req->rq_disk != next->rq_disk
 	    || req_no_special_merge(next))
@@ -715,11 +734,19 @@ static struct request *attempt_merge(struct request_queue *q,
 	 * counts here. Handle DISCARDs separately, as they
 	 * have separate settings.
 	 */
-	if (req_op(req) == REQ_OP_DISCARD) {
+
+	switch (blk_try_req_merge(req, next)) {
+	case ELEVATOR_DISCARD_MERGE:
 		if (!req_attempt_discard_merge(q, req, next))
 			return NULL;
-	} else if (!ll_merge_requests_fn(q, req, next))
+		break;
+	case ELEVATOR_BACK_MERGE:
+		if (!ll_merge_requests_fn(q, req, next))
+			return NULL;
+		break;
+	default:
 		return NULL;
+	}
 
 	/*
 	 * If failfast settings disagree or any of the two is already
@@ -843,8 +870,7 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 
 enum elv_merge blk_try_merge(struct request *rq, struct bio *bio)
 {
-	if (req_op(rq) == REQ_OP_DISCARD &&
-	    queue_max_discard_segments(rq->q) > 1)
+	if (blk_discard_mergable(rq))
 		return ELEVATOR_DISCARD_MERGE;
 	else if (blk_rq_pos(rq) + blk_rq_sectors(rq) == bio->bi_iter.bi_sector)
 		return ELEVATOR_BACK_MERGE;
-- 
2.20.1

