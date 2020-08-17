Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0CF1247659
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392397AbgHQTgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729660AbgHQP2i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:28:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6248523B6C;
        Mon, 17 Aug 2020 15:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678117;
        bh=Uqy9v9exJLdbF5R32vYNL2jcC8xvFc/Zck+E9tLIs9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0o1ZrBdzoi5DIr48iALy/NoQg45ksuGj/MvSfsFUiiNK6bZWwDWCpSwDwo9i8W8df
         cPcOpOMxfQN6wa9TP/CnPXTUrJr/oqSe5brHegGWbr582HRjxqZaYk5FZkBjniuXZq
         UNvhHGHckzuqa7Pmpv7GTQKYqOaT2NUvfRhteK/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steev Klimaszewski <steev@kali.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 184/464] scsi: ufs: Disable WriteBooster capability for non-supported UFS devices
Date:   Mon, 17 Aug 2020 17:12:17 +0200
Message-Id: <20200817143842.638117050@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit a7f1e69d4974666ea40886ee4801aebb2729ea81 ]

If a UFS device is not qualified to use WriteBooster, either due to wrong
UFS version or device-specific quirks, then the capability in host shall be
disabled to prevent any WriteBooster operations in the future.

Link: https://lore.kernel.org/r/20200625030430.25048-1-stanley.chu@mediatek.com
Fixes: 3d17b9b5ab11 ("scsi: ufs: Add write booster feature support")
Tested-by: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ec93bec8e78d8..e412e43d23821 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6818,20 +6818,30 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 
 static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 {
+	struct ufs_dev_info *dev_info = &hba->dev_info;
 	u8 lun;
 	u32 d_lu_wb_buf_alloc;
 
 	if (!ufshcd_is_wb_allowed(hba))
 		return;
+	/*
+	 * Probe WB only for UFS-2.2 and UFS-3.1 (and later) devices or
+	 * UFS devices with quirk UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES
+	 * enabled
+	 */
+	if (!(dev_info->wspecversion >= 0x310 ||
+	      dev_info->wspecversion == 0x220 ||
+	     (hba->dev_quirks & UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES)))
+		goto wb_disabled;
 
 	if (hba->desc_size.dev_desc < DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 4)
 		goto wb_disabled;
 
-	hba->dev_info.d_ext_ufs_feature_sup =
+	dev_info->d_ext_ufs_feature_sup =
 		get_unaligned_be32(desc_buf +
 				   DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
 
-	if (!(hba->dev_info.d_ext_ufs_feature_sup & UFS_DEV_WRITE_BOOSTER_SUP))
+	if (!(dev_info->d_ext_ufs_feature_sup & UFS_DEV_WRITE_BOOSTER_SUP))
 		goto wb_disabled;
 
 	/*
@@ -6840,17 +6850,17 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 	 * a max of 1 lun would have wb buffer configured.
 	 * Now only shared buffer mode is supported.
 	 */
-	hba->dev_info.b_wb_buffer_type =
+	dev_info->b_wb_buffer_type =
 		desc_buf[DEVICE_DESC_PARAM_WB_TYPE];
 
-	hba->dev_info.b_presrv_uspc_en =
+	dev_info->b_presrv_uspc_en =
 		desc_buf[DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN];
 
-	if (hba->dev_info.b_wb_buffer_type == WB_BUF_MODE_SHARED) {
-		hba->dev_info.d_wb_alloc_units =
+	if (dev_info->b_wb_buffer_type == WB_BUF_MODE_SHARED) {
+		dev_info->d_wb_alloc_units =
 		get_unaligned_be32(desc_buf +
 				   DEVICE_DESC_PARAM_WB_SHARED_ALLOC_UNITS);
-		if (!hba->dev_info.d_wb_alloc_units)
+		if (!dev_info->d_wb_alloc_units)
 			goto wb_disabled;
 	} else {
 		for (lun = 0; lun < UFS_UPIU_MAX_WB_LUN_ID; lun++) {
@@ -6861,7 +6871,7 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 					(u8 *)&d_lu_wb_buf_alloc,
 					sizeof(d_lu_wb_buf_alloc));
 			if (d_lu_wb_buf_alloc) {
-				hba->dev_info.wb_dedicated_lu = lun;
+				dev_info->wb_dedicated_lu = lun;
 				break;
 			}
 		}
@@ -6950,14 +6960,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	ufs_fixup_device_setup(hba);
 
-	/*
-	 * Probe WB only for UFS-3.1 devices or UFS devices with quirk
-	 * UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES enabled
-	 */
-	if (dev_info->wspecversion >= 0x310 ||
-	    dev_info->wspecversion == 0x220 ||
-	    (hba->dev_quirks & UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES))
-		ufshcd_wb_probe(hba, desc_buf);
+	ufshcd_wb_probe(hba, desc_buf);
 
 	/*
 	 * ufshcd_read_string_desc returns size of the string
-- 
2.25.1



