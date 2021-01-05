Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33182EA29A
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbhAEBEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:04:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:39950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728424AbhAEBBU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 20:01:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95C10229F0;
        Tue,  5 Jan 2021 00:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808385;
        bh=FBgstoEEKVyr2nuJZvtfhaCS25jzMQm6sUNZHQEI/aQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJiV2hFWET+KyZ5VTrhDqSFIMqu/CtHpmn9+w0Q55W7cRJK5OTjYLxbDbV8kbyDFI
         FbcLV6Dc1f55StE3O81Eaufg76V4NkId+46+Mdk99RuQD/A2TSnO5Ssp7Art3iIsdb
         6NCV5upuPjmVaCEPvbcUvBnZG+yn5000JnUJKeM0Qsb30hPyEOzT6AC/V6UW1IoChl
         /Vkqct0Po7mvRpjM60JvKVq0IiHIPLSTU5gBwHnbKVgA0/No90CQOjMI1Nxl0Ts4o2
         GT1rHRk8De2mN+PfrUds8C/DhylKx5zyMQyC2zR5vuNinZPD9h7pk1lgTqTVjVcVu4
         Ng4s+WabygUlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@google.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/17] scsi: ufs: Clear UAC for FFU and RPMB LUNs
Date:   Mon,  4 Jan 2021 19:59:15 -0500
Message-Id: <20210105005915.3954208-17-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210105005915.3954208-1-sashal@kernel.org>
References: <20210105005915.3954208-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

[ Upstream commit 4f3e900b628226011a5f71c19e53b175c014eb58 ]

In order to conduct FFU or RPMB operations, UFS needs to clear UNIT
ATTENTION condition. Clear it explicitly so that we get no failures during
initialization.

Link: https://lore.kernel.org/r/20201117165839.1643377-4-jaegeuk@kernel.org
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 70 +++++++++++++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h |  1 +
 2 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ec7005bcf61d8..a6382e688082d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7095,7 +7095,6 @@ static inline void ufshcd_blk_pm_runtime_init(struct scsi_device *sdev)
 static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 {
 	int ret = 0;
-	struct scsi_device *sdev_rpmb;
 	struct scsi_device *sdev_boot;
 
 	hba->sdev_ufs_device = __scsi_add_device(hba->host, 0, 0,
@@ -7108,14 +7107,14 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 	ufshcd_blk_pm_runtime_init(hba->sdev_ufs_device);
 	scsi_device_put(hba->sdev_ufs_device);
 
-	sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
+	hba->sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), NULL);
-	if (IS_ERR(sdev_rpmb)) {
-		ret = PTR_ERR(sdev_rpmb);
+	if (IS_ERR(hba->sdev_rpmb)) {
+		ret = PTR_ERR(hba->sdev_rpmb);
 		goto remove_sdev_ufs_device;
 	}
-	ufshcd_blk_pm_runtime_init(sdev_rpmb);
-	scsi_device_put(sdev_rpmb);
+	ufshcd_blk_pm_runtime_init(hba->sdev_rpmb);
+	scsi_device_put(hba->sdev_rpmb);
 
 	sdev_boot = __scsi_add_device(hba->host, 0, 0,
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_BOOT_WLUN), NULL);
@@ -7639,6 +7638,63 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	return ret;
 }
 
+static int
+ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp);
+
+static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
+{
+	struct scsi_device *sdp;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (wlun == UFS_UPIU_UFS_DEVICE_WLUN)
+		sdp = hba->sdev_ufs_device;
+	else if (wlun == UFS_UPIU_RPMB_WLUN)
+		sdp = hba->sdev_rpmb;
+	else
+		BUG_ON(1);
+	if (sdp) {
+		ret = scsi_device_get(sdp);
+		if (!ret && !scsi_device_online(sdp)) {
+			ret = -ENODEV;
+			scsi_device_put(sdp);
+		}
+	} else {
+		ret = -ENODEV;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	if (ret)
+		goto out_err;
+
+	ret = ufshcd_send_request_sense(hba, sdp);
+	scsi_device_put(sdp);
+out_err:
+	if (ret)
+		dev_err(hba->dev, "%s: UAC clear LU=%x ret = %d\n",
+				__func__, wlun, ret);
+	return ret;
+}
+
+static int ufshcd_clear_ua_wluns(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	if (!hba->wlun_dev_clr_ua)
+		goto out;
+
+	ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_UFS_DEVICE_WLUN);
+	if (!ret)
+		ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_RPMB_WLUN);
+	if (!ret)
+		hba->wlun_dev_clr_ua = false;
+out:
+	if (ret)
+		dev_err(hba->dev, "%s: Failed to clear UAC WLUNS ret = %d\n",
+				__func__, ret);
+	return ret;
+}
+
 /**
  * ufshcd_probe_hba - probe hba to detect device and initialize
  * @hba: per-adapter instance
@@ -7758,6 +7814,8 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 		pm_runtime_put_sync(hba->dev);
 		ufshcd_exit_clk_scaling(hba);
 		ufshcd_hba_exit(hba);
+	} else {
+		ufshcd_clear_ua_wluns(hba);
 	}
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e0f00a42371c5..c9fadb6270238 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -683,6 +683,7 @@ struct ufs_hba {
 	 * "UFS device" W-LU.
 	 */
 	struct scsi_device *sdev_ufs_device;
+	struct scsi_device *sdev_rpmb;
 
 	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
 	enum uic_link_state uic_link_state;
-- 
2.27.0

