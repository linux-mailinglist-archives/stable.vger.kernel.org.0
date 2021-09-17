Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82DC640EF8C
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243489AbhIQCgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243212AbhIQCgH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:36:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A33A61251;
        Fri, 17 Sep 2021 02:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846086;
        bh=7odiRS9VWzujG2Br0lnv/r2N8vNkgxVyHObhWMRiXmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3OGdTkmoQzI6QbqBhPLZ5BaxLXEysXwC6az5ID1lu4nyeRzDXtjNXb0n14LQB3fo
         hhKO8r5PrBh9i+GoDUOX5yTdW9Ehzz37sB46mwjuwml5jEeY4m72thaw8FZc02OBqN
         a2pOwzH3GdiYP1KSCOEz/STmJg6hyLNQUa0gnfJQcFdXAhzgPeMeI3CLA2ZVNbqPgi
         yCw7CJiAA23JCaDe3EzCn08S1Mz1XiLf1HYZwGj3V92yPT+nwG2ychQ9rLk2WcIG1C
         /Gr07tlpYi0oxGNoZP094fZaa5bbpE3HP/5afA6SLcLrlnG/oMykoXmHoONb6RQN/7
         yq9tpCPyOO8ng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Song Liu <songliubraving@fb.com>,
        Marcin Wanat <marcin.wanat@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 6/8] blk-mq: allow 4x BLK_MAX_REQUEST_COUNT at blk_plug for multiple_queues
Date:   Thu, 16 Sep 2021 22:34:31 -0400
Message-Id: <20210917023437.816574-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023437.816574-1-sashal@kernel.org>
References: <20210917023437.816574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

[ Upstream commit 7f2a6a69f7ced6db8220298e0497cf60482a9d4b ]

Limiting number of request to BLK_MAX_REQUEST_COUNT at blk_plug hurts
performance for large md arrays. [1] shows resync speed of md array drops
for md array with more than 16 HDDs.

Fix this by allowing more request at plug queue. The multiple_queue flag
is used to only apply higher limit to multiple queue cases.

[1] https://lore.kernel.org/linux-raid/CAFDAVznS71BXW8Jxv6k9dXc2iR3ysX3iZRBww_rzA8WifBFxGg@mail.gmail.com/
Tested-by: Marcin Wanat <marcin.wanat@gmail.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9e3fedbaa644..6dcb86c1c985 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2109,6 +2109,18 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
 	}
 }
 
+/*
+ * Allow 4x BLK_MAX_REQUEST_COUNT requests on plug queue for multiple
+ * queues. This is important for md arrays to benefit from merging
+ * requests.
+ */
+static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
+{
+	if (plug->multiple_queues)
+		return BLK_MAX_REQUEST_COUNT * 4;
+	return BLK_MAX_REQUEST_COUNT;
+}
+
 /**
  * blk_mq_submit_bio - Create and send a request to block device.
  * @bio: Bio pointer.
@@ -2202,7 +2214,7 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio)
 		else
 			last = list_entry_rq(plug->mq_list.prev);
 
-		if (request_count >= BLK_MAX_REQUEST_COUNT || (last &&
+		if (request_count >= blk_plug_max_rq_count(plug) || (last &&
 		    blk_rq_bytes(last) >= BLK_PLUG_FLUSH_SIZE)) {
 			blk_flush_plug_list(plug, false);
 			trace_block_plug(q);
-- 
2.30.2

