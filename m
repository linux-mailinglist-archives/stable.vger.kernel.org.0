Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D664EF39F
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349905AbiDAO6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349368AbiDAOzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:55:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7C93334B;
        Fri,  1 Apr 2022 07:43:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 466D5B823EB;
        Fri,  1 Apr 2022 14:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14029C34111;
        Fri,  1 Apr 2022 14:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824213;
        bh=RYGyEI6MkST0Y+glRhBSRLGQeLbeO3s8JoQoCSpU9e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IW9R2W3X1FkRMWi7ZgAsRfeXZ/MGlPuXWbZSPvu8PErqlFf5XyjUqb/RUdCvDSUJu
         mvx8tb83/QITEIaXkiw2TNT7V4apP/G9MNAkpHhhRawXH7E/jdvHCaIdXAsqn5K/9I
         ntj267CoCtHVrN+mpyfcOxBf20EMOkFgaASoQ/aSxSCQZqIxm4M8kKd8HIkCeiGoOS
         JTI/FZEIzxh1eK6JmUEKEa/PpUwpdLZkg7aUV13ys+Zlmc7JMBotdaYOs0orPOEwwR
         TcxoGbzXcav3obvuU5qocHdSvJbDZxHoObl9jkuqMK2/1vaGLkj28gH4H52spCgxDl
         QSwP6Bivi5ncA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Snitzer <snitzer@redhat.com>, Zhang Yi <yi.zhang@huawei.com>,
        Sasha Levin <sashal@kernel.org>, agk@redhat.com,
        snitzer@kernel.org, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.10 31/65] dm: requeue IO if mapping table not yet available
Date:   Fri,  1 Apr 2022 10:41:32 -0400
Message-Id: <20220401144206.1953700-31-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

[ Upstream commit fa247089de9936a46e290d4724cb5f0b845600f5 ]

Update both bio-based and request-based DM to requeue IO if the
mapping table not available.

This race of IO being submitted before the DM device ready is so
narrow, yet possible for initial table load given that the DM device's
request_queue is created prior, that it best to requeue IO to handle
this unlikely case.

Reported-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-rq.c |  7 ++++++-
 drivers/md/dm.c    | 11 +++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index b1e867feb4f6..4833f4b20b2c 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -492,8 +492,13 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	if (unlikely(!ti)) {
 		int srcu_idx;
-		struct dm_table *map = dm_get_live_table(md, &srcu_idx);
+		struct dm_table *map;
 
+		map = dm_get_live_table(md, &srcu_idx);
+		if (unlikely(!map)) {
+			dm_put_live_table(md, srcu_idx);
+			return BLK_STS_RESOURCE;
+		}
 		ti = dm_table_find_target(map, 0);
 		dm_put_live_table(md, srcu_idx);
 	}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6030cba5b038..2836d44094ab 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1692,15 +1692,10 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
 	struct dm_table *map;
 
 	map = dm_get_live_table(md, &srcu_idx);
-	if (unlikely(!map)) {
-		DMERR_LIMIT("%s: mapping table unavailable, erroring io",
-			    dm_device_name(md));
-		bio_io_error(bio);
-		goto out;
-	}
 
-	/* If suspended, queue this IO for later */
-	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))) {
+	/* If suspended, or map not yet available, queue this IO for later */
+	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) ||
+	    unlikely(!map)) {
 		if (bio->bi_opf & REQ_NOWAIT)
 			bio_wouldblock_error(bio);
 		else if (bio->bi_opf & REQ_RAHEAD)
-- 
2.34.1

