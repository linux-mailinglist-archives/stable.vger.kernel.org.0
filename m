Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8FA2D9F7D
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502272AbgLNRhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:37:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502252AbgLNRhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:37 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 049/105] scsi: ufs: Fix unexpected values from ufshcd_read_desc_param()
Date:   Mon, 14 Dec 2020 18:28:23 +0100
Message-Id: <20201214172557.638954344@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



