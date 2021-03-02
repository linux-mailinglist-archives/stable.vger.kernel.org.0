Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA7A32AF04
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhCCAOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:14:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:38730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383603AbhCBL4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 06:56:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27F5564F14;
        Tue,  2 Mar 2021 11:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686139;
        bh=Cd0eVel9AGZGGertR3fyXI4RXhCQuYVAsF2IOVW2H00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2B3gwYdOng46a8niq2RGSfuewLWcC6FPhTbMbh5xtnRBr5mBt+hljwYqnmHqeVOB
         MHS6fRTZAunSwArc6P3uJL6KxCts3jBsHs490C8N82rhXAwmLUhv06mEYr/+nXsbSb
         1idd6li1X33QbSq3/CgSg/JMTQsDrAW0rVa5AgnecszTEJPrRGe+vunn4pVa2rWUtw
         ql2iNfy5HCM0q9vBK72/BhvcfRpRpTRxghe1yoa4+3SeqqrNqFN1qaoDI49ccrk2uq
         COLrxheVEheRsM84xJyhujvMHMEsAsp+UpIayVi+NNxxMtfiluSK+AOrM7zmhFlqUF
         Qy5+IQd0ZWlgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 03/52] scsi: ufs: Add a quirk to permit overriding UniPro defaults
Date:   Tue,  2 Mar 2021 06:54:44 -0500
Message-Id: <20210302115534.61800-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kiwoong Kim <kwmad.kim@samsung.com>

[ Upstream commit b1d0d2eb89d4e3a25b212a9d836587503537067e ]

The UniPro specification states that attribute IDs of the following
parameters are vendor-specific so some SoCs could have no regions at the
defined addresses:

 - DME_LocalFC0ProtectionTimeOutVal
 - DME_LocalTC0ReplayTimeOutVal
 - DME_LocalAFC0ReqTimeOutVal

In addition, the following parameters should be set considering the
compatibility between host and device.

 - PA_PWRMODEUSERDATA0
 - PA_PWRMODEUSERDATA1
 - PA_PWRMODEUSERDATA2
 - PA_PWRMODEUSERDATA3
 - PA_PWRMODEUSERDATA4
 - PA_PWRMODEUSERDATA5

Introduce a quirk to allow vendor drivers to override the UniPro defaults.

Link: https://lore.kernel.org/r/1fedd3dea0ccc980913a5995a10510d86a5b01b9.1608513782.git.kwmad.kim@samsung.com
Acked-by: Avri Altman <Avri.Altman@wdc.com>
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 40 ++++++++++++++++++++-------------------
 drivers/scsi/ufs/ufshcd.h |  6 ++++++
 2 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fb32d122f2e3..2a715f13fe1d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4218,25 +4218,27 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HSSERIES),
 						pwr_mode->hs_rate);
 
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0),
-			DL_FC0ProtectionTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1),
-			DL_TC0ReplayTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2),
-			DL_AFC0ReqTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA3),
-			DL_FC1ProtectionTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA4),
-			DL_TC1ReplayTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA5),
-			DL_AFC1ReqTimeOutVal_Default);
-
-	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalFC0ProtectionTimeOutVal),
-			DL_FC0ProtectionTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalTC0ReplayTimeOutVal),
-			DL_TC0ReplayTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalAFC0ReqTimeOutVal),
-			DL_AFC0ReqTimeOutVal_Default);
+	if (!(hba->quirks & UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING)) {
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0),
+				DL_FC0ProtectionTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1),
+				DL_TC0ReplayTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2),
+				DL_AFC0ReqTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA3),
+				DL_FC1ProtectionTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA4),
+				DL_TC1ReplayTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA5),
+				DL_AFC1ReqTimeOutVal_Default);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalFC0ProtectionTimeOutVal),
+				DL_FC0ProtectionTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalTC0ReplayTimeOutVal),
+				DL_TC0ReplayTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalAFC0ReqTimeOutVal),
+				DL_AFC0ReqTimeOutVal_Default);
+	}
 
 	ret = ufshcd_uic_change_pwr_mode(hba, pwr_mode->pwr_rx << 4
 			| pwr_mode->pwr_tx);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index aa9ea3552323..85f9d0fbfbd9 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -551,6 +551,12 @@ enum ufshcd_quirks {
 	 */
 	UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL		= 1 << 12,
 
+	/*
+	 * This quirk needs to disable unipro timeout values
+	 * before power mode change
+	 */
+	UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING = 1 << 13,
+
 };
 
 enum ufshcd_caps {
-- 
2.30.1

