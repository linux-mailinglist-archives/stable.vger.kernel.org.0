Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC6DA1762
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 12:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfH2KuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 06:50:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727620AbfH2KuQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 06:50:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E741233A1;
        Thu, 29 Aug 2019 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075816;
        bh=7b65reXVFw1RYJf9RpdWTCouvQR5rD8v4dzt/bdk5c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdjDp6vWV38lSL1T69GDy39+vlL/saIIo+hCmC+Yt1KUW0ooSiXGsBX9b27xx2ZUL
         oLSg5jiOPTjL65s86Py1ZRyt0fM2uDqac+MW/mXLgab8PTxhNc8fJ3ZIije3+SBCoP
         BoNwOLQuRrT+PB08lym4qqiRysmv2jOWPRGt0Zp8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Bo <bo.liu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/29] Blk-iolatency: warn on negative inflight IO counter
Date:   Thu, 29 Aug 2019 06:49:45 -0400
Message-Id: <20190829105009.2265-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105009.2265-1-sashal@kernel.org>
References: <20190829105009.2265-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Bo <bo.liu@linux.alibaba.com>

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

