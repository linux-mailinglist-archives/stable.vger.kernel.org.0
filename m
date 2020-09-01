Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0072C2598AB
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730906AbgIAQ3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:29:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730824AbgIAPb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:31:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47518205F4;
        Tue,  1 Sep 2020 15:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974317;
        bh=GkwWLyrg0SY/P4gHh/wH7AUIehCk6uU61q5j3nQlCRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mW4rQcCtqGco4ohTiYHyyvw0mWA2LaywmUkRZrp4Un1kwsqOmiNkyU6Xm3CP2v0+l
         sLgX7Ieu5aLKPxLVIBZ3kiJDvc9DeYuOxXjdaj7xaIZxAus+ium6OQRLbJaukjoNLv
         bWLyC2m3I61jd/YdWSkas8ohItJH4+5pX/UTkFBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/214] block: respect queue limit of max discard segment
Date:   Tue,  1 Sep 2020 17:09:39 +0200
Message-Id: <20200901150957.738121289@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 943b40c832beb71115e38a1c4d99b640b5342738 ]

When queue_max_discard_segments(q) is 1, blk_discard_mergable() will
return false for discard request, then normal request merge is applied.
However, only queue_max_segments() is checked, so max discard segment
limit isn't respected.

Check max discard segment limit in the request merge code for fixing
the issue.

Discard request failure of virtio_blk is fixed.

Fixes: 69840466086d ("block: fix the DISCARD request merge")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 93cff719b0661..c874931bae6b5 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -553,10 +553,17 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 }
 EXPORT_SYMBOL(blk_rq_map_sg);
 
+static inline unsigned int blk_rq_get_max_segments(struct request *rq)
+{
+	if (req_op(rq) == REQ_OP_DISCARD)
+		return queue_max_discard_segments(rq->q);
+	return queue_max_segments(rq->q);
+}
+
 static inline int ll_new_hw_segment(struct request *req, struct bio *bio,
 		unsigned int nr_phys_segs)
 {
-	if (req->nr_phys_segments + nr_phys_segs > queue_max_segments(req->q))
+	if (req->nr_phys_segments + nr_phys_segs > blk_rq_get_max_segments(req))
 		goto no_merge;
 
 	if (blk_integrity_merge_bio(req->q, req, bio) == false)
@@ -640,7 +647,7 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 		return 0;
 
 	total_phys_segments = req->nr_phys_segments + next->nr_phys_segments;
-	if (total_phys_segments > queue_max_segments(q))
+	if (total_phys_segments > blk_rq_get_max_segments(req))
 		return 0;
 
 	if (blk_integrity_merge_rq(q, req, next) == false)
-- 
2.25.1



