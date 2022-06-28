Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD4855D00F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243340AbiF1CTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243349AbiF1CTO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:19:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A975A17E21;
        Mon, 27 Jun 2022 19:19:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44B2E617DB;
        Tue, 28 Jun 2022 02:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3051C341CD;
        Tue, 28 Jun 2022 02:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382752;
        bh=SVjIUq468ZnkreE+5CnjX830DKpi6K2VxXz1oYBEyvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rn6u6QlxLBnmRNY35IZnY6ItdgcwojK2IcrNULdcPkP1u9i98Q3quXvWVyu5vSMSE
         lPPv/o8jfPKAmFpUIo3leXW37ErEKHbuRqEtzOadimDhou+2X0TLEbDPCLYf6R6Cnq
         wmI3Lt5BuoutKRUOQvX5pwzxcjUsGm/LiKV5nNFodV88t8c37mJ7C9Ymi8KNPjXRla
         BwFAJEzsnTvZqHBDCp63XlFF7EcwWiYJcCokF1lfWiu3vlI33pWWYznpj1DFmJJ8ON
         jbuHAy0lS/6uvu2/Qre6R2na8HSEKT7SOefGkubFPsp9BB/l4eHMnWdqDTSAcATyys
         t5g3FNjCr0XOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        matthias.bgg@gmail.com, beanhuo@micron.com, avri.altman@wdc.com,
        daejun7.park@samsung.com, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 14/53] scsi: ufs: Simplify ufshcd_clear_cmd()
Date:   Mon, 27 Jun 2022 22:18:00 -0400
Message-Id: <20220628021839.594423-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit da8badd7d3583f447eac2ab65a332f2d773deca1 ]

Remove the local variable 'err'. This patch does not change any
functionality.

Link: https://lore.kernel.org/r/20220613214442.212466-2-bvanassche@acm.org
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4c9eb4be449c..8f26c4c09c66 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2856,7 +2856,6 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 static int
 ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
 {
-	int err = 0;
 	unsigned long flags;
 	u32 mask = 1 << tag;
 
@@ -2869,11 +2868,8 @@ ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
 	 * wait for h/w to clear corresponding bit in door-bell.
 	 * max. wait is 1 sec.
 	 */
-	err = ufshcd_wait_for_register(hba,
-			REG_UTP_TRANSFER_REQ_DOOR_BELL,
-			mask, ~mask, 1000, 1000);
-
-	return err;
+	return ufshcd_wait_for_register(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL,
+					mask, ~mask, 1000, 1000);
 }
 
 static int
-- 
2.35.1

