Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B7F615906
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiKBDDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbiKBDDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:03:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAEA2314E
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:02:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E257FB82063
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F90C433D6;
        Wed,  2 Nov 2022 03:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358168;
        bh=sBPP9SSDJ7pdWImptvHVjR7RLGBrDaanMr9Z7VaSAAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJMzbwa0mg/N5oI+rZSCCkFXT7eAQG41EK/Da0ULgB9d+8RxEN3RKGX5tSFqDODv7
         JvF7e43hvC6QhW20QYf+9XOJBt47m4Yrqgm+QMBJkTGV8vHvb8Sr4Wx9J0bpmNrPY9
         S38WSyHLVDDUvwuPWB9JY62lTpm+l6hfpJ3mchls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christian Loehle <cloehle@hyperstone.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 053/132] mmc: block: Remove error check of hw_reset on reset
Date:   Wed,  2 Nov 2022 03:32:39 +0100
Message-Id: <20221102022101.008771918@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Löhle <CLoehle@hyperstone.com>

commit 406e14808ee695cbae1eafa5fd3ac563c29470ab upstream.

Before switching back to the right partition in mmc_blk_reset there used
to be a check if hw_reset was even supported. This return value
was removed, so there is no reason to check. Furthermore ensure
part_curr is not falsely set to a valid value on reset or
partition switch error.

As part of this change the code paths of mmc_blk_reset calls were checked
to ensure no commands are issued after a failed mmc_blk_reset directly
without going through the block layer.

Fixes: fefdd3c91e0a ("mmc: core: Drop superfluous validations in mmc_hw|sw_reset()")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/e91be6199d04414a91e20611c81bfe1d@hyperstone.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |   44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -133,6 +133,7 @@ struct mmc_blk_data {
 	 * track of the current selected device partition.
 	 */
 	unsigned int	part_curr;
+#define MMC_BLK_PART_INVALID	UINT_MAX	/* Unknown partition active */
 	int	area_type;
 
 	/* debugfs files (only in main mmc_blk_data) */
@@ -984,9 +985,16 @@ static unsigned int mmc_blk_data_timeout
 	return ms;
 }
 
+/*
+ * Attempts to reset the card and get back to the requested partition.
+ * Therefore any error here must result in cancelling the block layer
+ * request, it must not be reattempted without going through the mmc_blk
+ * partition sanity checks.
+ */
 static int mmc_blk_reset(struct mmc_blk_data *md, struct mmc_host *host,
 			 int type)
 {
+	struct mmc_blk_data *main_md = dev_get_drvdata(&host->card->dev);
 	int err;
 
 	if (md->reset_done & type)
@@ -994,23 +1002,22 @@ static int mmc_blk_reset(struct mmc_blk_
 
 	md->reset_done |= type;
 	err = mmc_hw_reset(host);
+	/*
+	 * A successful reset will leave the card in the main partition, but
+	 * upon failure it might not be, so set it to MMC_BLK_PART_INVALID
+	 * in that case.
+	 */
+	main_md->part_curr = err ? MMC_BLK_PART_INVALID : main_md->part_type;
+	if (err)
+		return err;
 	/* Ensure we switch back to the correct partition */
-	if (err) {
-		struct mmc_blk_data *main_md =
-			dev_get_drvdata(&host->card->dev);
-		int part_err;
-
-		main_md->part_curr = main_md->part_type;
-		part_err = mmc_blk_part_switch(host->card, md->part_type);
-		if (part_err) {
-			/*
-			 * We have failed to get back into the correct
-			 * partition, so we need to abort the whole request.
-			 */
-			return -ENODEV;
-		}
-	}
-	return err;
+	if (mmc_blk_part_switch(host->card, md->part_type))
+		/*
+		 * We have failed to get back into the correct
+		 * partition, so we need to abort the whole request.
+		 */
+		return -ENODEV;
+	return 0;
 }
 
 static inline void mmc_blk_reset_success(struct mmc_blk_data *md, int type)
@@ -1855,8 +1862,9 @@ static void mmc_blk_mq_rw_recovery(struc
 		return;
 
 	/* Reset before last retry */
-	if (mqrq->retries + 1 == MMC_MAX_RETRIES)
-		mmc_blk_reset(md, card->host, type);
+	if (mqrq->retries + 1 == MMC_MAX_RETRIES &&
+	    mmc_blk_reset(md, card->host, type))
+		return;
 
 	/* Command errors fail fast, so use all MMC_MAX_RETRIES */
 	if (brq->sbc.error || brq->cmd.error)


