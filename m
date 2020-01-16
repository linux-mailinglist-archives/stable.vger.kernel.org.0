Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4F8913E186
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbgAPQr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:47:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729325AbgAPQr4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:47:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD2602081E;
        Thu, 16 Jan 2020 16:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193275;
        bh=kUaCFWyhzUJmucYI60/CvzTz0wLDT+2Y6FB3J2Mcixc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2eFYHLiMk+1NoTC6CXbYeE8WNzWEecmdpHc2Yvg0L3vNVyEAcQgoYCmgZpUCT8TH
         1go/WbxnFdpFO6HksyR7bWc9Cw9ZRGKWb1obM0QC51FTizVy2F193CCFR3qiC5UND3
         +0I3HTTOCBrcQ0TcvjdHtGtrP+aehxNt+0sVBU5Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 063/205] scsi: hisi_sas: Set the BIST init value before enabling BIST
Date:   Thu, 16 Jan 2020 11:40:38 -0500
Message-Id: <20200116164300.6705-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 65a3b8bd56942dc988b8c05615bd3f510a10012b ]

If set the BIST init value after enabling BIST, there may be still some few
error bits. According to the process, need to set the BIST init value
before enabling BIST.

Fixes: 97b151e75861 ("scsi: hisi_sas: Add BIST support for phy loopback")
Link: https://lore.kernel.org/r/1571926105-74636-3-git-send-email-john.garry@huawei.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index ef32ee12f606..c4f76d7c29db 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3022,11 +3022,6 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
 		hisi_sas_phy_write32(hisi_hba, phy_id,
 				     SAS_PHY_BIST_CTRL, reg_val);
 
-		mdelay(100);
-		reg_val |= (CFG_RX_BIST_EN_MSK | CFG_TX_BIST_EN_MSK);
-		hisi_sas_phy_write32(hisi_hba, phy_id,
-				     SAS_PHY_BIST_CTRL, reg_val);
-
 		/* set the bist init value */
 		hisi_sas_phy_write32(hisi_hba, phy_id,
 				     SAS_PHY_BIST_CODE,
@@ -3035,6 +3030,11 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
 				     SAS_PHY_BIST_CODE1,
 				     SAS_PHY_BIST_CODE1_INIT);
 
+		mdelay(100);
+		reg_val |= (CFG_RX_BIST_EN_MSK | CFG_TX_BIST_EN_MSK);
+		hisi_sas_phy_write32(hisi_hba, phy_id,
+				     SAS_PHY_BIST_CTRL, reg_val);
+
 		/* clear error bit */
 		mdelay(100);
 		hisi_sas_phy_read32(hisi_hba, phy_id, SAS_BIST_ERR_CNT);
-- 
2.20.1

