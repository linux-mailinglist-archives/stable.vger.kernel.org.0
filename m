Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6C659A10C
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352242AbiHSQ0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352633AbiHSQYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:24:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA7A118C80;
        Fri, 19 Aug 2022 09:03:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E4B2612DF;
        Fri, 19 Aug 2022 16:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5505EC433B5;
        Fri, 19 Aug 2022 16:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924986;
        bh=qxtEZ+r7qfVL9lR4c/NeDUUueNS0X5awlWOiSShLVJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqStogk32P85OHnDHKCtiKqTKWN84W9s7taaoA9KrFlIjxYp8WkwoB4NQoi2euoXY
         QsY+vT4KCLph0l5MtgPHI7BjjfpIKD5TL1McLUPxm4NCQpMhXVdVBdZ3ZahqTJ6fms
         jjM2FM6w1cQqdEzZJGzMLlMQATOmC7XYE0/7FQog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Loehle <cloehle@hyperstone.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 317/545] mmc: block: Add single read for 4k sector cards
Date:   Fri, 19 Aug 2022 17:41:27 +0200
Message-Id: <20220819153843.538516223@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Christian Loehle <CLoehle@hyperstone.com>

[ Upstream commit b3fa3e6dccc465969721b8bd2824213bd235efeb ]

Cards with 4k native sector size may only be read 4k-aligned,
accommodate for this in the single read recovery and use it.

Fixes: 81196976ed946 (mmc: block: Add blk-mq support)
Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Link: https://lore.kernel.org/r/cf4f316274c5474586d0d99b17db4a4c@hyperstone.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/block.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 70eb3d03937f..66a00b7c751f 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -169,7 +169,7 @@ static inline int mmc_blk_part_switch(struct mmc_card *card,
 				      unsigned int part_type);
 static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
 			       struct mmc_card *card,
-			       int disable_multi,
+			       int recovery_mode,
 			       struct mmc_queue *mq);
 static void mmc_blk_hsq_req_done(struct mmc_request *mrq);
 
@@ -1247,7 +1247,7 @@ static void mmc_blk_eval_resp_error(struct mmc_blk_request *brq)
 }
 
 static void mmc_blk_data_prep(struct mmc_queue *mq, struct mmc_queue_req *mqrq,
-			      int disable_multi, bool *do_rel_wr_p,
+			      int recovery_mode, bool *do_rel_wr_p,
 			      bool *do_data_tag_p)
 {
 	struct mmc_blk_data *md = mq->blkdata;
@@ -1311,12 +1311,12 @@ static void mmc_blk_data_prep(struct mmc_queue *mq, struct mmc_queue_req *mqrq,
 			brq->data.blocks--;
 
 		/*
-		 * After a read error, we redo the request one sector
+		 * After a read error, we redo the request one (native) sector
 		 * at a time in order to accurately determine which
 		 * sectors can be read successfully.
 		 */
-		if (disable_multi)
-			brq->data.blocks = 1;
+		if (recovery_mode)
+			brq->data.blocks = queue_physical_block_size(mq->queue) >> 9;
 
 		/*
 		 * Some controllers have HW issues while operating
@@ -1533,7 +1533,7 @@ static int mmc_blk_cqe_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 
 static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
 			       struct mmc_card *card,
-			       int disable_multi,
+			       int recovery_mode,
 			       struct mmc_queue *mq)
 {
 	u32 readcmd, writecmd;
@@ -1542,7 +1542,7 @@ static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
 	struct mmc_blk_data *md = mq->blkdata;
 	bool do_rel_wr, do_data_tag;
 
-	mmc_blk_data_prep(mq, mqrq, disable_multi, &do_rel_wr, &do_data_tag);
+	mmc_blk_data_prep(mq, mqrq, recovery_mode, &do_rel_wr, &do_data_tag);
 
 	brq->mrq.cmd = &brq->cmd;
 
@@ -1633,7 +1633,7 @@ static int mmc_blk_fix_state(struct mmc_card *card, struct request *req)
 
 #define MMC_READ_SINGLE_RETRIES	2
 
-/* Single sector read during recovery */
+/* Single (native) sector read during recovery */
 static void mmc_blk_read_single(struct mmc_queue *mq, struct request *req)
 {
 	struct mmc_queue_req *mqrq = req_to_mmc_queue_req(req);
@@ -1641,6 +1641,7 @@ static void mmc_blk_read_single(struct mmc_queue *mq, struct request *req)
 	struct mmc_card *card = mq->card;
 	struct mmc_host *host = card->host;
 	blk_status_t error = BLK_STS_OK;
+	size_t bytes_per_read = queue_physical_block_size(mq->queue);
 
 	do {
 		u32 status;
@@ -1675,13 +1676,13 @@ static void mmc_blk_read_single(struct mmc_queue *mq, struct request *req)
 		else
 			error = BLK_STS_OK;
 
-	} while (blk_update_request(req, error, 512));
+	} while (blk_update_request(req, error, bytes_per_read));
 
 	return;
 
 error_exit:
 	mrq->data->bytes_xfered = 0;
-	blk_update_request(req, BLK_STS_IOERR, 512);
+	blk_update_request(req, BLK_STS_IOERR, bytes_per_read);
 	/* Let it try the remaining request again */
 	if (mqrq->retries > MMC_MAX_RETRIES - 1)
 		mqrq->retries = MMC_MAX_RETRIES - 1;
@@ -1822,10 +1823,9 @@ static void mmc_blk_mq_rw_recovery(struct mmc_queue *mq, struct request *req)
 		return;
 	}
 
-	/* FIXME: Missing single sector read for large sector size */
-	if (!mmc_large_sector(card) && rq_data_dir(req) == READ &&
-	    brq->data.blocks > 1) {
-		/* Read one sector at a time */
+	if (rq_data_dir(req) == READ && brq->data.blocks >
+			queue_physical_block_size(mq->queue) >> 9) {
+		/* Read one (native) sector at a time */
 		mmc_blk_read_single(mq, req);
 		return;
 	}
-- 
2.35.1



