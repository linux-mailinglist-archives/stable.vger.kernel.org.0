Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791EC4EF406
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347910AbiDAOwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349432AbiDAOp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:45:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C378829B7E9;
        Fri,  1 Apr 2022 07:36:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2B5060A3D;
        Fri,  1 Apr 2022 14:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141E6C340EE;
        Fri,  1 Apr 2022 14:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823760;
        bh=6n70/9P3Qkc1dL6XTNTYG+wCIEIMgtMfG83rJLvg8Fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWH0LXK13QLWeqvRYlzgokLDi0nWBVtzk7qOGGjTVSIRq9+FvBq1O/inqlDBr299c
         nmY5D2jRTGsmeLv1WlfFmyzgzGlagWyHlwb/ONXck5iQL+BIMY+HcDUCh0aBTue2DM
         glMqlNFdVgc8onU4UNyVSDZoh/e9um2OGTUO1azG2bglWEFQgWi6ET8bll2gKsJjH9
         XMbAlppyc+RP6rHfFFW6Pm7cEi6r690ZIy4iQ7DFdoOtAU+h2xk877FSCU2fMO5zuk
         2xFj/ed64Mn82HmSwVWoHuyKiTlwIyc6QBKM0MJStzbKmijplMgAoN9or7ofi43pSJ
         Up87CBOrZPQqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 067/109] scsi: pm8001: Fix tag leaks on error
Date:   Fri,  1 Apr 2022 10:32:14 -0400
Message-Id: <20220401143256.1950537-67-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 4c8f04b1905cd4b776d0b720463c091545478ef7 ]

In pm8001_chip_set_dev_state_req(), pm8001_chip_fw_flash_update_req(),
pm80xx_chip_phy_ctl_req() and pm8001_chip_reg_dev_req() add missing calls
to pm8001_tag_free() to free the allocated tag when pm8001_mpi_build_cmd()
fails.

Similarly, in pm8001_exec_internal_task_abort(), if the chip ->task_abort
method fails, the tag allocated for the abort request task must be
freed. Add the missing call to pm8001_tag_free().

Link: https://lore.kernel.org/r/20220220031810.738362-22-damien.lemoal@opensource.wdc.com
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 9 +++++++++
 drivers/scsi/pm8001/pm8001_sas.c | 2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c | 9 +++++++--
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 7cc1aa0b1f5a..5325da0e35f7 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4489,6 +4489,9 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 		SAS_ADDR_SIZE);
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
+
 	return rc;
 }
 
@@ -4901,6 +4904,9 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,
 	ccb->ccb_tag = tag;
 	rc = pm8001_chip_fw_flash_update_build(pm8001_ha, &flash_update_info,
 		tag);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
+
 	return rc;
 }
 
@@ -5005,6 +5011,9 @@ pm8001_chip_set_dev_state_req(struct pm8001_hba_info *pm8001_ha,
 	payload.nds = cpu_to_le32(state);
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
+
 	return rc;
 
 }
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index c0b45b8a513d..2a9ea08c7fe6 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -831,10 +831,10 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 
 		res = PM8001_CHIP_DISP->task_abort(pm8001_ha,
 			pm8001_dev, flag, task_tag, ccb_tag);
-
 		if (res) {
 			del_timer(&task->slow_task->timer);
 			pm8001_dbg(pm8001_ha, FAIL, "Executing internal task failed\n");
+			pm8001_tag_free(pm8001_ha, ccb_tag);
 			goto ex_err;
 		}
 		wait_for_completion(&task->slow_task->completion);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 39f8ae733103..531870552636 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4909,8 +4909,13 @@ static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 	payload.tag = cpu_to_le32(tag);
 	payload.phyop_phyid =
 		cpu_to_le32(((phy_op & 0xFF) << 8) | (phyId & 0xFF));
-	return pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
-			sizeof(payload), 0);
+
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+				  sizeof(payload), 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
+
+	return rc;
 }
 
 static u32 pm80xx_chip_is_our_interrupt(struct pm8001_hba_info *pm8001_ha)
-- 
2.34.1

