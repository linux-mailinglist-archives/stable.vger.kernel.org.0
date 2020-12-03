Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA61B2CD7D9
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 14:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436518AbgLCNaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 08:30:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:47984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436463AbgLCNaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 08:30:05 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 12/39] scsi: ufs: Fix unexpected values from ufshcd_read_desc_param()
Date:   Thu,  3 Dec 2020 08:28:06 -0500
Message-Id: <20201203132834.930999-12-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203132834.930999-1-sashal@kernel.org>
References: <20201203132834.930999-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit 1699f980d87fb678a669490462cf0b9517c1fb47 ]

WB-related sysfs entries can be accessed even when an UFS device does not
support the feature. The descriptors which are not supported by the UFS
device may be wrongly reported when they are accessed from their
corrsponding sysfs entries. Fix it by adding a sanity check of parameter
offset against the actual decriptor length.

Link: https://lore.kernel.org/r/1603346348-14149-1-git-send-email-cang@codeaurora.org
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Acked-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9dd32bb0ff2be..cbcdd79a1f76f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3163,13 +3163,19 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 	/* Get the length of descriptor */
 	ufshcd_map_desc_id_to_length(hba, desc_id, &buff_len);
 	if (!buff_len) {
-		dev_err(hba->dev, "%s: Failed to get desc length", __func__);
+		dev_err(hba->dev, "%s: Failed to get desc length\n", __func__);
+		return -EINVAL;
+	}
+
+	if (param_offset >= buff_len) {
+		dev_err(hba->dev, "%s: Invalid offset 0x%x in descriptor IDN 0x%x, length 0x%x\n",
+			__func__, param_offset, desc_id, buff_len);
 		return -EINVAL;
 	}
 
 	/* Check whether we need temp memory */
 	if (param_offset != 0 || param_size < buff_len) {
-		desc_buf = kmalloc(buff_len, GFP_KERNEL);
+		desc_buf = kzalloc(buff_len, GFP_KERNEL);
 		if (!desc_buf)
 			return -ENOMEM;
 	} else {
@@ -3183,14 +3189,14 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 					desc_buf, &buff_len);
 
 	if (ret) {
-		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d, desc_index %d, param_offset %d, ret %d",
+		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d, desc_index %d, param_offset %d, ret %d\n",
 			__func__, desc_id, desc_index, param_offset, ret);
 		goto out;
 	}
 
 	/* Sanity check */
 	if (desc_buf[QUERY_DESC_DESC_TYPE_OFFSET] != desc_id) {
-		dev_err(hba->dev, "%s: invalid desc_id %d in descriptor header",
+		dev_err(hba->dev, "%s: invalid desc_id %d in descriptor header\n",
 			__func__, desc_buf[QUERY_DESC_DESC_TYPE_OFFSET]);
 		ret = -EINVAL;
 		goto out;
@@ -3200,12 +3206,12 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 	buff_len = desc_buf[QUERY_DESC_LENGTH_OFFSET];
 	ufshcd_update_desc_length(hba, desc_id, desc_index, buff_len);
 
-	/* Check wherher we will not copy more data, than available */
-	if (is_kmalloc && (param_offset + param_size) > buff_len)
-		param_size = buff_len - param_offset;
-
-	if (is_kmalloc)
+	if (is_kmalloc) {
+		/* Make sure we don't copy more data than available */
+		if (param_offset + param_size > buff_len)
+			param_size = buff_len - param_offset;
 		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
+	}
 out:
 	if (is_kmalloc)
 		kfree(desc_buf);
-- 
2.27.0

