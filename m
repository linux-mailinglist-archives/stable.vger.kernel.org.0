Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C73245C3EC
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347893AbhKXNon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:44:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353546AbhKXNn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:43:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 956AE611C2;
        Wed, 24 Nov 2021 12:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758733;
        bh=LHLmtHHxNON37J30lEUt/suRrSCcr8e07XUGISB8KHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+wNSw6nE5EzLWEKwmV8ZZV4YLMwnETgOl9rKBkx3xPVKYSQlP/x5S7qXprGnZama
         VfcImyl5MFnRLoxVNXIV1WPnhRroeQ8hnRY4Vc87Z6Gd0wBNj8BpPW1BlRB+RogoRm
         46mRr6okTDei9jn/G6K6UDXUbTSkWR68agot5Bxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Ajish Koshy <Ajish.Koshy@microchip.com>,
        Viswas G <Viswas.G@microchip.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/279] scsi: pm80xx: Fix memory leak during rmmod
Date:   Wed, 24 Nov 2021 12:54:59 +0100
Message-Id: <20211124115719.174452731@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e18f2b60371db..f40a41f450d9b 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -517,6 +517,7 @@ struct pm8001_hba_info {
 	u32			iomb_size; /* SPC and SPCV IOMB size */
 	struct pm8001_device	*devices;
 	struct pm8001_ccb_info	*ccb_info;
+	u32			ccb_count;
 #ifdef PM8001_USE_MSIX
 	int			number_of_intr;/*will be used in remove()*/
 	char			intr_drvname[PM8001_MAX_MSIX_VEC]
-- 
2.33.0



