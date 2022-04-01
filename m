Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3434EF3FC
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349555AbiDAO46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352143AbiDAOt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:49:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E75C292DAE;
        Fri,  1 Apr 2022 07:41:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 352ED611BC;
        Fri,  1 Apr 2022 14:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC630C2BBE4;
        Fri,  1 Apr 2022 14:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824022;
        bh=fGD5iJdC6D5RFyUz1FPQvYZjYGUGy6/NKYeb4gNSH+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXNC53CzuZ7T+BIvZb93hnCdgyerCx7sj6YUM7bAZsKgkuNPUEVjX4m3Jr75R3dff
         CXC/E1A2NxoeYUxApTAkNCL992EaXyhM3h/PE9xl1hzHk/Md1D8jjlwQoGL6cii8FJ
         4t8YkJxr8J5ho0XMgVgzDaaC4CCELjw1bomx6/YeVOWCwGuUFrH/xc40SYofO0LmkA
         91jo0tyf9gZ6IBRTj+doC+TSJo+nAvCuEd4AtvzITNuwRxeknyA8L3Ecff1XKU2k6c
         3BoOVPcHwEhvGLDxvCtsoEzphakdAfXdx9VH9uAdlGEybq4VhLydVUTP1tdJnNZh8B
         GN+y3esCYgG8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 56/98] scsi: pm8001: Fix tag leaks on error
Date:   Fri,  1 Apr 2022 10:37:00 -0400
Message-Id: <20220401143742.1952163-56-sashal@kernel.org>
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
index 7e8cb377cb65..d0e8e6c2f87d 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4485,6 +4485,9 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 		SAS_ADDR_SIZE);
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
+
 	return rc;
 }
 
@@ -4897,6 +4900,9 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,
 	ccb->ccb_tag = tag;
 	rc = pm8001_chip_fw_flash_update_build(pm8001_ha, &flash_update_info,
 		tag);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
+
 	return rc;
 }
 
@@ -5001,6 +5007,9 @@ pm8001_chip_set_dev_state_req(struct pm8001_hba_info *pm8001_ha,
 	payload.nds = cpu_to_le32(state);
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
+
 	return rc;
 
 }
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 491cecbbe1aa..5fb08acbc0e5 100644
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
index 287887d8d729..e3d80918d21e 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4901,8 +4901,13 @@ static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
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

