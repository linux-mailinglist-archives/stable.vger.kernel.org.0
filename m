Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1A644B562
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbhKIWUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:20:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:40468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245446AbhKIWUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:20:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED44B60524;
        Tue,  9 Nov 2021 22:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496233;
        bh=7k1WS9uVJRujblIhvJOmlph87wwIMaxi9obiwhT3fZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhsahzE5mWszKDv9poaXD7Df5DwKfSNvMcCA3qVh9U5FUqNW9oeZsj0ElT4TWAt5R
         0pNyajf/ttcnY/noNh7w66NU2Pr1dFFKP9W8KHFOx5Ybb4sP8dWDcxxt0n+9aI0WvL
         p+ht4iLMItOUVHSptnRiGuhYQLnmOY45YAcA/iOgjrJkn8GhQX21OQso7jlE90j8nA
         VLXTYnioeHdLcpxp3A8j1hIeFEuPgieNaX1cyDcStm27apc+DnQSC5TzadENHTnJQL
         H9sRY/JOj5EIVczzAjnIfSSdqfGpw6WkCAot2DHV4hmSNv8I6jKLd//L9nggL50Bkj
         zjYMAtIC1LNOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ajish Koshy <Ajish.Koshy@microchip.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Viswas G <Viswas.G@microchip.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jinpu.wang@profitbricks.com,
        lindar_liu@usish.com, JBottomley@odin.com, pmchba@pmcs.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 12/82] scsi: pm80xx: Fix memory leak during rmmod
Date:   Tue,  9 Nov 2021 17:15:30 -0500
Message-Id: <20211109221641.1233217-12-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajish Koshy <Ajish.Koshy@microchip.com>

[ Upstream commit 51e6ed83bb4ade7c360551fa4ae55c4eacea354b ]

Driver failed to release all memory allocated. This would lead to memory
leak during driver removal.

Properly free memory when the module is removed.

Link: https://lore.kernel.org/r/20210906170404.5682-5-Ajish.Koshy@microchip.com
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_init.c | 11 +++++++++++
 drivers/scsi/pm8001/pm8001_sas.h  |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 47db7e0beae6f..729d8252028e8 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1198,6 +1198,7 @@ pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha, struct Scsi_Host *shost,
 		goto err_out;
 
 	/* Memory region for ccb_info*/
+	pm8001_ha->ccb_count = ccb_count;
 	pm8001_ha->ccb_info =
 		kcalloc(ccb_count, sizeof(struct pm8001_ccb_info), GFP_KERNEL);
 	if (!pm8001_ha->ccb_info) {
@@ -1259,6 +1260,16 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 			tasklet_kill(&pm8001_ha->tasklet[j]);
 #endif
 	scsi_host_put(pm8001_ha->shost);
+
+	for (i = 0; i < pm8001_ha->ccb_count; i++) {
+		dma_free_coherent(&pm8001_ha->pdev->dev,
+			sizeof(struct pm8001_prd) * PM8001_MAX_DMA_SG,
+			pm8001_ha->ccb_info[i].buf_prd,
+			pm8001_ha->ccb_info[i].ccb_dma_handle);
+	}
+	kfree(pm8001_ha->ccb_info);
+	kfree(pm8001_ha->devices);
+
 	pm8001_free(pm8001_ha);
 	kfree(sha->sas_phy);
 	kfree(sha->sas_port);
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 62d08b535a4b6..f5b6a9d8099e5 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -516,6 +516,7 @@ struct pm8001_hba_info {
 	u32			iomb_size; /* SPC and SPCV IOMB size */
 	struct pm8001_device	*devices;
 	struct pm8001_ccb_info	*ccb_info;
+	u32			ccb_count;
 #ifdef PM8001_USE_MSIX
 	int			number_of_intr;/*will be used in remove()*/
 	char			intr_drvname[PM8001_MAX_MSIX_VEC]
-- 
2.33.0

