Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3387451EC4
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349078AbhKPAh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344825AbhKOTZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80ADB636D4;
        Mon, 15 Nov 2021 19:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003105;
        bh=K4ne8YE2c/7j1spFSp9l1T/d44YzHGl6QRftd2lQY5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGpCE2ZwUXsf2ynf1R4JQKXMYFk2Pyh/gDKac42mdBxUuuPnjJkGURrWpm7atNpPq
         /hc3mVtrwn6lkeS6VU5RvDUQYOQxOAZUM7sRFcJIemf7RoaPuZA90FPzx1iJGn4XAm
         mUt8JOXm/gUn19Yz0s47O8dNGmznW5xaZgmU66B4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 780/917] scsi: ufs: ufshpb: Use proper power management API
Date:   Mon, 15 Nov 2021 18:04:35 +0100
Message-Id: <20211115165455.394125962@linuxfoundation.org>
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

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit 351b3a849ac7d92449dc75c43db8a857b38387ea ]

In ufshpb, pm_runtime_{get,put}_sync() are used to avoid unwanted runtime
suspend during query requests. Whereas commit b294ff3e3449 ("scsi: ufs:
core: Enable power management for wlun") modified the driver core to use
ufshcd_rpm_{get,put}_sync() APIs.

Switch to these APIs in HPB module as well.

Link: https://lore.kernel.org/r/20210902003534epcms2p1937a0f0eeb48a441cb69f5ef13ff8430@epcms2p1
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshpb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 026a133149dce..46cdfb0dfca94 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2371,11 +2371,11 @@ static int ufshpb_get_lu_info(struct ufs_hba *hba, int lun,
 
 	ufshcd_map_desc_id_to_length(hba, QUERY_DESC_IDN_UNIT, &size);
 
-	pm_runtime_get_sync(hba->dev);
+	ufshcd_rpm_get_sync(hba);
 	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
 					    QUERY_DESC_IDN_UNIT, lun, 0,
 					    desc_buf, &size);
-	pm_runtime_put_sync(hba->dev);
+	ufshcd_rpm_put_sync(hba);
 
 	if (ret) {
 		dev_err(hba->dev,
@@ -2598,10 +2598,10 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 	if (version == HPB_SUPPORT_LEGACY_VERSION)
 		hpb_dev_info->is_legacy = true;
 
-	pm_runtime_get_sync(hba->dev);
+	ufshcd_rpm_get_sync(hba);
 	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 		QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD, 0, 0, &max_hpb_single_cmd);
-	pm_runtime_put_sync(hba->dev);
+	ufshcd_rpm_put_sync(hba);
 
 	if (ret)
 		dev_err(hba->dev, "%s: idn: read max size of single hpb cmd query request failed",
-- 
2.33.0



