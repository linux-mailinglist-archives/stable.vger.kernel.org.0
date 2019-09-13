Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1F6B1FED
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388368AbfIMNLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:11:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388914AbfIMNLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:11:20 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9006621479;
        Fri, 13 Sep 2019 13:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380280;
        bh=pwSlJlVAaArsZDQaRtxNND4APc/w3WH7PbZa6DaoKQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8G1AHH/W6LG1Op5wLsmYh3K9IVEiTKY45fUoQ9ZPYlKv1sIdwsgGwy+/rZW8vDur
         CxJAUrZlNbilG9I7YYO770kH4REvXo/nznHHUY8sUIGUfxjeGsll3SfA0YJAqFMIfg
         MEtE22T4MfW219O1oZShsY6tAaCHlgNLwqNS3BvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Bo <bo.liu@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 014/190] Blk-iolatency: warn on negative inflight IO counter
Date:   Fri, 13 Sep 2019 14:04:29 +0100
Message-Id: <20190913130600.727296818@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 391f552af213985d3d324c60004475759a7030c5 ]

This is to catch any unexpected negative value of inflight IO counter.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iolatency.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index f4f7c73fb8284..84ecdab41b691 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -560,6 +560,7 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 	u64 now = ktime_to_ns(ktime_get());
 	bool issue_as_root = bio_issue_as_root_blkg(bio);
 	bool enabled = false;
+	int inflight = 0;
 
 	blkg = bio->bi_blkg;
 	if (!blkg)
@@ -585,7 +586,8 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
 		}
 		rqw = &iolat->rq_wait;
 
-		atomic_dec(&rqw->inflight);
+		inflight = atomic_dec_return(&rqw->inflight);
+		WARN_ON_ONCE(inflight < 0);
 		if (iolat->min_lat_nsec == 0)
 			goto next;
 		iolatency_record_time(iolat, &bio->bi_issue, now,
-- 
2.20.1



