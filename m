Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E472A451489
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348779AbhKOUKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:10:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344747AbhKOTZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B59C6337E;
        Mon, 15 Nov 2021 19:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003020;
        bh=5cOqaQJbyHoiQgMKotHX0NfJlS6GVCCR+o5CC1fa/9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ff3cwmm2q7uM7fVPXBZk+aQ29xfs/pGWUmlmVFtXn7CmO8y+/Bqy8OGVqw7f8v6c1
         ikK75V98dwIjizPCBuj2zQzNTm97xDyhYn/i7gG9xxEa8BjM6jDDBS2YvAxeJQ+A8W
         I38tt/l4asPcRxmc83XA0S0XmqO0bVPgTakm9Lxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 782/917] scsi: ufs: ufshpb: Properly handle max-single-cmd
Date:   Mon, 15 Nov 2021 18:04:37 +0100
Message-Id: <20211115165455.473946243@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Avri Altman <avri.altman@wdc.com>

[ Upstream commit 9ec5128a8b5631d652ed06b37e0166f337802f90 ]

The spec recommends that for transfer length larger than the max-single-cmd
attribute (bMAX_DATA_SIZE_FOR_HPB_SINGLE_CMD) it is possible to couple
pre-requests with the HPB-READ command.  Being a recommendation, using
pre-requests can be perceived merely as a means of optimization.  A common
practice was to send pre-requests for chunks within some interval, and
leave the READ10 untouched if larger.

Now that the pre-request flows have been removed, all the commands are
single commands.  Properly handle this attribute and do not send HPB-READ
for transfer lengths larger than max-single-cmd.

[mkp: resolve conflict]

Fixes: 09d9e4d04187 ("scsi: ufs: ufshpb: Remove HPB2.0 flows")
Link: https://lore.kernel.org/r/20211031123654.17719-1-avri.altman@wdc.com
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshpb.c | 24 +++++++++++++-----------
 drivers/scsi/ufs/ufshpb.h |  1 -
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 3b1a90b1d82ac..a86d0cc50de21 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -394,8 +394,6 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	if (!ufshpb_is_supported_chunk(hpb, transfer_len))
 		return 0;
 
-	WARN_ON_ONCE(transfer_len > HPB_MULTI_CHUNK_HIGH);
-
 	if (hpb->is_hcm) {
 		/*
 		 * in host control mode, reads are the main source for
@@ -1572,7 +1570,7 @@ static void ufshpb_lu_parameter_init(struct ufs_hba *hba,
 	if (ufshpb_is_legacy(hba))
 		hpb->pre_req_max_tr_len = HPB_LEGACY_CHUNK_HIGH;
 	else
-		hpb->pre_req_max_tr_len = HPB_MULTI_CHUNK_HIGH;
+		hpb->pre_req_max_tr_len = hpb_dev_info->max_hpb_single_cmd;
 
 	hpb->lu_pinned_start = hpb_lu_info->pinned_start;
 	hpb->lu_pinned_end = hpb_lu_info->num_pinned ?
@@ -2582,7 +2580,7 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 {
 	struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
 	int version, ret;
-	u32 max_hpb_single_cmd = HPB_MULTI_CHUNK_LOW;
+	int max_single_cmd;
 
 	hpb_dev_info->control_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
 
@@ -2598,18 +2596,22 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 	if (version == HPB_SUPPORT_LEGACY_VERSION)
 		hpb_dev_info->is_legacy = true;
 
-	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
-		QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD, 0, 0, &max_hpb_single_cmd);
-	if (ret)
-		dev_err(hba->dev, "%s: idn: read max size of single hpb cmd query request failed",
-			__func__);
-	hpb_dev_info->max_hpb_single_cmd = max_hpb_single_cmd;
-
 	/*
 	 * Get the number of user logical unit to check whether all
 	 * scsi_device finish initialization
 	 */
 	hpb_dev_info->num_lu = desc_buf[DEVICE_DESC_PARAM_NUM_LU];
+
+	if (hpb_dev_info->is_legacy)
+		return;
+
+	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+		QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD, 0, 0, &max_single_cmd);
+
+	if (ret)
+		hpb_dev_info->max_hpb_single_cmd = HPB_LEGACY_CHUNK_HIGH;
+	else
+		hpb_dev_info->max_hpb_single_cmd = min(max_single_cmd + 1, HPB_MULTI_CHUNK_HIGH);
 }
 
 void ufshpb_init(struct ufs_hba *hba)
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index f15d8fdbce2ef..b475dbd789883 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -31,7 +31,6 @@
 
 /* hpb support chunk size */
 #define HPB_LEGACY_CHUNK_HIGH			1
-#define HPB_MULTI_CHUNK_LOW			7
 #define HPB_MULTI_CHUNK_HIGH			255
 
 /* hpb vender defined opcode */
-- 
2.33.0



