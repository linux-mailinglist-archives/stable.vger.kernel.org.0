Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2844EF305
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348985AbiDAOyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352108AbiDAOtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:49:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A5A292DA2;
        Fri,  1 Apr 2022 07:41:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 720C460A64;
        Fri,  1 Apr 2022 14:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050B6C2BBE4;
        Fri,  1 Apr 2022 14:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824010;
        bh=ZqjFng1BBWMjrqvsY7fCtSykKyUDEeNJsAGxQ8POOOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrQz9p7cD88HZZ1YUQrTayFeuBcZVzN+dhmwnV9oEsfNX0j6kPeU4LRC4UhV8Osjl
         yvn9+/CwDsOGv+aUkdVQTfMrxrl/fY6skf9JhRy/pftShMMpfTRUAWqh0CerfEBQ9o
         ccbQEouEkNuijlIose5jTlFn+BRCFrcj1p2IkumqckrQBkBdMn0kmGCeOTHNcxD1id
         Aezu7/Fmh4OshRcz+jUuAbPmXAvFr0/U+uX9JR7xqnfQR6eksuipPQUkpOe6OcJ3iw
         HoTqfpczPeJIchzuxJukVmIoCNtuSC6s9BqCYYhXSPeeb82qqHMsziek3hjKg+Y5yt
         PsNktSL35p2dw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Snitzer <snitzer@redhat.com>, Zhang Yi <yi.zhang@huawei.com>,
        Sasha Levin <sashal@kernel.org>, agk@redhat.com,
        snitzer@kernel.org, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.15 50/98] dm: requeue IO if mapping table not yet available
Date:   Fri,  1 Apr 2022 10:36:54 -0400
Message-Id: <20220401143742.1952163-50-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
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
index a896dea9750e..53a9b16c7b2e 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -500,8 +500,13 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 
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
index 5f33700d1247..73046fd21e47 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1570,15 +1570,10 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
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

