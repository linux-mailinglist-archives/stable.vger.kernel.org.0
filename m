Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 696085A6991
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbiH3RU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiH3RU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:20:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B021400A;
        Tue, 30 Aug 2022 10:19:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60D83B81CD3;
        Tue, 30 Aug 2022 17:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC57C433D7;
        Tue, 30 Aug 2022 17:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661879982;
        bh=5QvKRRAHDIo7HHKgbgxqt8ycMrr/leXRZbEgZYnHQDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBCtEKRyajrUYKTPT9hUtsMNgrSjio1kOmLhu98UH/W6hGZ/GKwBBUxvQEHFJEnFo
         UzPZKMR+gmqgY1aZ7O5YsKC03U4VqfDOcDQrOt1wWnq02CoZeIGHt8/jgiBiFpsl9J
         72oIT2611LRuRG19P90hwaUVNWFQpQTQx+Fd4W75d5iPRvh84tlR6S9anT/GhoE+Z3
         Nl+Mzgo5/tFG0pfhfpofb5mdJ9yGpePu0VeNH4pUMQScFU8xxnX74+d5qtvJC9jl/T
         Ad2ZPsXBBQmUqOaxrDpAb51K81nivPgQlCMw9AqlmN/QZEje4stNpxXusZNpOFHsdB
         hVboHQHkHOKHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        matthias.bgg@gmail.com, beanhuo@micron.com, avri.altman@wdc.com,
        adrian.hunter@intel.com, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 14/33] scsi: ufs: core: Reduce the power mode change timeout
Date:   Tue, 30 Aug 2022 13:18:05 -0400
Message-Id: <20220830171825.580603-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 8f2c96420c6ec3dcb18c8be923e24c6feaa5ccf6 ]

The current power mode change timeout (180 s) is so large that it can cause
a watchdog timer to fire. Reduce the power mode change timeout to 10
seconds.

Link: https://lore.kernel.org/r/20220811234401.1957911-1-bvanassche@acm.org
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a51ca56a0ebe7..829da9cb14a86 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8723,6 +8723,8 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_device *sdp;
 	unsigned long flags;
 	int ret, retries;
+	unsigned long deadline;
+	int32_t remaining;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->ufs_device_wlun;
@@ -8755,9 +8757,14 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
+	deadline = jiffies + 10 * HZ;
 	for (retries = 3; retries > 0; --retries) {
+		ret = -ETIMEDOUT;
+		remaining = deadline - jiffies;
+		if (remaining <= 0)
+			break;
 		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-				START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
+				   remaining / HZ, 0, 0, RQF_PM, NULL);
 		if (!scsi_status_is_check_condition(ret) ||
 				!scsi_sense_valid(&sshdr) ||
 				sshdr.sense_key != UNIT_ATTENTION)
-- 
2.35.1

