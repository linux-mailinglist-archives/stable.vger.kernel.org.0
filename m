Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE63395EE7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhEaOFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:05:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233179AbhEaODM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:03:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 152136194F;
        Mon, 31 May 2021 13:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468253;
        bh=1/KlnCRWtF0vKGhkPgGjzun0pYQzldw/2erBmmt1otM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqJpYngtkqQQ8iGsk9eKLYsT6YX/vITP85QG7mDhH07SfS/ZcUe+2plF+hTeFuGeB
         DhhNFRxF69ZbQJvwaKQ7T9dVRHOf5u+Cdi0wIvKHvLLFmEZd4yVivkiPZhtSZ/Mspy
         avwuUwk+ee8dLq+ZHEl9mD+lByPww9/M1Ud8HlO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ajish Koshy <ajish.koshy@microchip.com>,
        Viswas G <viswas.g@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/252] scsi: pm80xx: Fix drives missing during rmmod/insmod loop
Date:   Mon, 31 May 2021 15:13:59 +0200
Message-Id: <20210531130703.916733392@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajish Koshy <ajish.koshy@microchip.com>

[ Upstream commit d1acd81bd6eb685aa9fef25624fb36d297f6404e ]

When driver is loaded after rmmod some drives are not showing up during
discovery.

SATA drives are directly attached to the controller connected phys.  During
device discovery, the IDENTIFY command (qc timeout (cmd 0xec)) is timing out
during revalidation. This will trigger abort from host side and controller
successfully aborts the command and returns success. Post this successful
abort response ATA library decides to mark the disk as NODEV.

To overcome this, inside pm8001_scan_start() after phy_start() call, add get
start response and wait for few milliseconds to trigger next phy start.
This millisecond delay will give sufficient time for the controller state
machine to accept next phy start.

Link: https://lore.kernel.org/r/20210505120103.24497-1-ajish.koshy@microchip.com
Signed-off-by: Ajish Koshy <ajish.koshy@microchip.com>
Signed-off-by: Viswas G <viswas.g@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c  | 10 ++++++----
 drivers/scsi/pm8001/pm8001_init.c |  2 +-
 drivers/scsi/pm8001/pm8001_sas.c  |  7 ++++++-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 12 ++++++------
 4 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 355d1c5f2194..2114d2dd3501 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3703,11 +3703,13 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 	case HW_EVENT_PHY_START_STATUS:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_START_STATUS status = %x\n",
 			   status);
-		if (status == 0) {
+		if (status == 0)
 			phy->phy_state = 1;
-			if (pm8001_ha->flags == PM8001F_RUN_TIME &&
-					phy->enable_completion != NULL)
-				complete(phy->enable_completion);
+
+		if (pm8001_ha->flags == PM8001F_RUN_TIME &&
+				phy->enable_completion != NULL) {
+			complete(phy->enable_completion);
+			phy->enable_completion = NULL;
 		}
 		break;
 	case HW_EVENT_SAS_PHY_UP:
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 7657d68e12d5..0c0c886c7371 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1139,8 +1139,8 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 		goto err_out_shost;
 	}
 	list_add_tail(&pm8001_ha->list, &hba_list);
-	scsi_scan_host(pm8001_ha->shost);
 	pm8001_ha->flags = PM8001F_RUN_TIME;
+	scsi_scan_host(pm8001_ha->shost);
 	return 0;
 
 err_out_shost:
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 474468df2a78..39de9a9360d3 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -264,12 +264,17 @@ void pm8001_scan_start(struct Scsi_Host *shost)
 	int i;
 	struct pm8001_hba_info *pm8001_ha;
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	DECLARE_COMPLETION_ONSTACK(completion);
 	pm8001_ha = sha->lldd_ha;
 	/* SAS_RE_INITIALIZATION not available in SPCv/ve */
 	if (pm8001_ha->chip_id == chip_8001)
 		PM8001_CHIP_DISP->sas_re_init_req(pm8001_ha);
-	for (i = 0; i < pm8001_ha->chip->n_phy; ++i)
+	for (i = 0; i < pm8001_ha->chip->n_phy; ++i) {
+		pm8001_ha->phy[i].enable_completion = &completion;
 		PM8001_CHIP_DISP->phy_start_req(pm8001_ha, i);
+		wait_for_completion(&completion);
+		msleep(300);
+	}
 }
 
 int pm8001_scan_finished(struct Scsi_Host *shost, unsigned long time)
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 27b354860a16..a203a4fc2674 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3432,13 +3432,13 @@ static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	pm8001_dbg(pm8001_ha, INIT,
 		   "phy start resp status:0x%x, phyid:0x%x\n",
 		   status, phy_id);
-	if (status == 0) {
+	if (status == 0)
 		phy->phy_state = PHY_LINK_DOWN;
-		if (pm8001_ha->flags == PM8001F_RUN_TIME &&
-				phy->enable_completion != NULL) {
-			complete(phy->enable_completion);
-			phy->enable_completion = NULL;
-		}
+
+	if (pm8001_ha->flags == PM8001F_RUN_TIME &&
+			phy->enable_completion != NULL) {
+		complete(phy->enable_completion);
+		phy->enable_completion = NULL;
 	}
 	return 0;
 
-- 
2.30.2



