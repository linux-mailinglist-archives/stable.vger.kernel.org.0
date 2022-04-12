Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49AB94FD39A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 11:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351922AbiDLHXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353040AbiDLHOq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:14:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC2B326F2;
        Mon, 11 Apr 2022 23:55:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B26BB81B35;
        Tue, 12 Apr 2022 06:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55E8C385A1;
        Tue, 12 Apr 2022 06:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746546;
        bh=bWbmMtCwHDj7WBYZ7MqbFUn8n+43IBiBL0oK60/Kaac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mXBYZ/aPWgxtkWB/2ETvNZnnwq3MwxVEmAnYcX3XOKM+G8iLckzYhsWwpHqufUIqd
         kj4kwLfeWhat5fXKMywohkldvHjXuq1x9Z9xtVr0DTDZ0wk2ibkRvANgdNj2DngzHv
         jXZkAUAC7RIceJinZhZMNDhmVP6ysb/8+OceI/UY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kevin Barnett <kevin.barnett@microchip.com>,
        Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>,
        Don Brace <don.brace@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 045/285] scsi: smartpqi: Fix kdump issue when controller is locked up
Date:   Tue, 12 Apr 2022 08:28:22 +0200
Message-Id: <20220412062944.976618062@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>

[ Upstream commit 3ada501d602abf02353445c03bb3258146445d90 ]

Avoid dropping into shell if the controller is in locked up state.

Driver issues SIS soft reset to bring back the controller to SIS mode while
OS boots into kdump mode.

If the controller is in lockup state, SIS soft reset does not work.

Since the controller lockup code has not been cleared, driver considers the
firmware is no longer up and running. Driver returns back an error code to
OS and the kdump fails.

Link: https://lore.kernel.org/r/164375212337.440833.11955356190354940369.stgit@brunhilda.pdev.net
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 39 ++++++++++++++++-----------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 2db9f874cc51..f3749e508673 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7855,6 +7855,21 @@ static int pqi_force_sis_mode(struct pqi_ctrl_info *ctrl_info)
 	return pqi_revert_to_sis_mode(ctrl_info);
 }
 
+static void pqi_perform_lockup_action(void)
+{
+	switch (pqi_lockup_action) {
+	case PANIC:
+		panic("FATAL: Smart Family Controller lockup detected");
+		break;
+	case REBOOT:
+		emergency_restart();
+		break;
+	case NONE:
+	default:
+		break;
+	}
+}
+
 static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
@@ -7879,8 +7894,15 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	 * commands.
 	 */
 	rc = sis_wait_for_ctrl_ready(ctrl_info);
-	if (rc)
+	if (rc) {
+		if (reset_devices) {
+			dev_err(&ctrl_info->pci_dev->dev,
+				"kdump init failed with error %d\n", rc);
+			pqi_lockup_action = REBOOT;
+			pqi_perform_lockup_action();
+		}
 		return rc;
+	}
 
 	/*
 	 * Get the controller properties.  This allows us to determine
@@ -8605,21 +8627,6 @@ static int pqi_ofa_ctrl_restart(struct pqi_ctrl_info *ctrl_info, unsigned int de
 	return pqi_ctrl_init_resume(ctrl_info);
 }
 
-static void pqi_perform_lockup_action(void)
-{
-	switch (pqi_lockup_action) {
-	case PANIC:
-		panic("FATAL: Smart Family Controller lockup detected");
-		break;
-	case REBOOT:
-		emergency_restart();
-		break;
-	case NONE:
-	default:
-		break;
-	}
-}
-
 static struct pqi_raid_error_info pqi_ctrl_offline_raid_error_info = {
 	.data_out_result = PQI_DATA_IN_OUT_HARDWARE_ERROR,
 	.status = SAM_STAT_CHECK_CONDITION,
-- 
2.35.1



