Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0067932AF05
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhCCAO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:14:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:39614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1443476AbhCBL5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 06:57:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 787CD64F16;
        Tue,  2 Mar 2021 11:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686142;
        bh=lJRnnl7zW0U/qSD4/YLZ7F3hQipUFBP0Yzf7bmNyQGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5F+R159ba0PjNi8eZZKhpxC+npzPi6nONhvXwW+blk3+ioS9dzNSfeBt8BWNtjKA
         Tc0fyznNm0goYFx1KkAo7Y8IU3OaXnzWGC218LrtrrqGqRqDgnp3sejzvCndQMZZoy
         Sj8A3BDOWZ9V1byFLKkAicqWyf165Vdg/ZE6ndRqkMmraZVUVoR2vHt2ujr1T25Sgg
         GmhN++6OOEPFCOP+B1c6lyDG2biD3Gh/JrWbB5d320DtkOhvXDdcW6pYD1H7A9WdRc
         DBWYBet1HSjjbk+LsOtvtk2vIR3HUxF4PUTFc7pt6T1F13dY2mTJ/wW0zfcLm0Btw0
         jdx2BjyfyyEhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 05/52] scsi: ufs: WB is only available on LUN #0 to #7
Date:   Tue,  2 Mar 2021 06:54:46 -0500
Message-Id: <20210302115534.61800-5-sashal@kernel.org>
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

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit a2fca52ee640a04112ed9d9a137c940ea6ad288e ]

Kernel stack violation when getting unit_descriptor/wb_buf_alloc_units from
rpmb LUN. The reason is that the unit descriptor length is different per
LU.

The length of Normal LU is 45 while the one of rpmb LU is 35.

int ufshcd_read_desc_param(struct ufs_hba *hba, ...)
{
	param_offset=41;
	param_size=4;
	buff_len=45;
	...
	buff_len=35 by rpmb LU;

	if (is_kmalloc) {
		/* Make sure we don't copy more data than available */
		if (param_offset + param_size > buff_len)
			param_size = buff_len - param_offset;
			--> param_size = 250;
		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
		--> memcpy(param_read_buf, desc_buf+41, 250);

[  141.868974][ T9174] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: wb_buf_alloc_units_show+0x11c/0x11c
	}
}

Link: https://lore.kernel.org/r/20210111095927.1830311-1-jaegeuk@kernel.org
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-sysfs.c | 3 ++-
 drivers/scsi/ufs/ufs.h       | 6 ++++--
 drivers/scsi/ufs/ufshcd.c    | 2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 08e72b7eef6a..50e90416262b 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -792,7 +792,8 @@ static ssize_t _pname##_show(struct device *dev,			\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
 	struct ufs_hba *hba = shost_priv(sdev->host);			\
 	u8 lun = ufshcd_scsi_to_upiu_lun(sdev->lun);			\
-	if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun))		\
+	if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun,		\
+				_duname##_DESC_PARAM##_puname))		\
 		return -EINVAL;						\
 	return ufs_sysfs_read_desc_param(hba, QUERY_DESC_IDN_##_duname,	\
 		lun, _duname##_DESC_PARAM##_puname, buf, _size);	\
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 14dfda735adf..580aa56965d0 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -552,13 +552,15 @@ struct ufs_dev_info {
  * @return: true if the lun has a matching unit descriptor, false otherwise
  */
 static inline bool ufs_is_valid_unit_desc_lun(struct ufs_dev_info *dev_info,
-		u8 lun)
+		u8 lun, u8 param_offset)
 {
 	if (!dev_info || !dev_info->max_lu_supported) {
 		pr_err("Max General LU supported by UFS isn't initialized\n");
 		return false;
 	}
-
+	/* WB is available only for the logical unit from 0 to 7 */
+	if (param_offset == UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS)
+		return lun < UFS_UPIU_MAX_WB_LUN_ID;
 	return lun == UFS_UPIU_RPMB_WLUN || (lun < dev_info->max_lu_supported);
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2a715f13fe1d..48cbd4f294dd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3425,7 +3425,7 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 	 * Unit descriptors are only available for general purpose LUs (LUN id
 	 * from 0 to 7) and RPMB Well known LU.
 	 */
-	if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun))
+	if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun, param_offset))
 		return -EOPNOTSUPP;
 
 	return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
-- 
2.30.1

