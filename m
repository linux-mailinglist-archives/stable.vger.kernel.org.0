Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7962641A7DC
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239301AbhI1F7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:59:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239194AbhI1F6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35B986113E;
        Tue, 28 Sep 2021 05:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808601;
        bh=Sf9hFfqy1pxav/vDmfZR82eXOWm7Npj4S2p0TxCUt4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/40uumZ1UT6gS/l09RoV5K6DnD8rY4iIklniOLON/MagsW0mStIrfeTdePnbTRob
         34NSH+laZZ5hDZJ2o3XCLIVwBZS+/EPV9QFevi5mg+1njrxbODyHK+yyUv9uoyg//C
         okSZ6WYwnQW0fOIilZeX4dD8igiVllpd7ZEbBIQ+QY0ovLv0MGvkBV9Ci1BCJ7CWfw
         dWSdPPZJ1hXAB85NcaT5/4VglhL5FBoFZHhR1akDBEJDihsfjnL3lKCegLT9Ieov2V
         OXhNzTm0kq9CJaO+y6j8j5B9iQJh10IB6xo/2b8oLP3C1Je7a6Rvgbn2uLRW1yh/H4
         CY+sOE7hokOhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Yu Kuai <yukuai3@huawei.com>,
        tj@kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 38/40] block: don't call rq_qos_ops->done_bio if the bio isn't tracked
Date:   Tue, 28 Sep 2021 01:55:22 -0400
Message-Id: <20210928055524.172051-38-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit a647a524a46736786c95cdb553a070322ca096e3 ]

rq_qos framework is only applied on request based driver, so:

1) rq_qos_done_bio() needn't to be called for bio based driver

2) rq_qos_done_bio() needn't to be called for bio which isn't tracked,
such as bios ended from error handling code.

Especially in bio_endio():

1) request queue is referred via bio->bi_bdev->bd_disk->queue, which
may be gone since request queue refcount may not be held in above two
cases

2) q->rq_qos may be freed in blk_cleanup_queue() when calling into
__rq_qos_done_bio()

Fix the potential kernel panic by not calling rq_qos_ops->done_bio if
the bio isn't tracked. This way is safe because both ioc_rqos_done_bio()
and blkcg_iolatency_done_bio() are nop if the bio isn't tracked.

Reported-by: Yu Kuai <yukuai3@huawei.com>
Cc: tj@kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20210924110704.1541818-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index d95e3456ba0c..52548c487883 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1396,7 +1396,7 @@ void bio_endio(struct bio *bio)
 	if (!bio_integrity_endio(bio))
 		return;
 
-	if (bio->bi_bdev)
+	if (bio->bi_bdev && bio_flagged(bio, BIO_TRACKED))
 		rq_qos_done_bio(bio->bi_bdev->bd_disk->queue, bio);
 
 	if (bio->bi_bdev && bio_flagged(bio, BIO_TRACE_COMPLETION)) {
-- 
2.33.0

