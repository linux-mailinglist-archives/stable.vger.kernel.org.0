Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32C4C13E1B6
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgAPQv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:51:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:34188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728949AbgAPQv2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:51:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FD9720663;
        Thu, 16 Jan 2020 16:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193487;
        bh=tMM4vuW8BwZlY/dsuLuN6VvJxbKVaz39QDVpoI8TcFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSo42jKNlBvoOMSDQG5LXy9gDN+H4VVIOORnO1Alkvqhl5LjFPBqhVVfHtQXN8Cff
         gwTkYtLnxenPMSCEGLghHyuMWwyT+c23phiAFtuLc0OgSfDfTwVFGq2I5hqYps4ryr
         kaSovxIdG4lc6dIwsI+5NQeRSiP1yCQg37I6AtDs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bean Huo <beanhuo@micron.com>, avri.altman@wdc.com,
        Can Guo <cang@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 089/205] scsi: ufs: delete redundant function ufshcd_def_desc_sizes()
Date:   Thu, 16 Jan 2020 11:41:04 -0500
Message-Id: <20200116164300.6705-89-sashal@kernel.org>
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

From: Bean Huo <beanhuo@micron.com>

[ Upstream commit 059efd847a4097c67817782d8ff65397e369e69b ]

There is no need to call ufshcd_def_desc_sizes() in ufshcd_init(), since
descriptor lengths will be checked and initialized later in
ufshcd_init_desc_sizes().

Fixes: a4b0e8a4e92b1b(scsi: ufs: Factor out ufshcd_read_desc_param)
Link: https://lore.kernel.org/r/BN7PR08MB5684A3ACE214C3D4792CE729DB610@BN7PR08MB5684.namprd08.prod.outlook.com
Signed-off-by: Bean Huo <beanhuo@micron.com>
Acked-by: Avri Altman <avri.altman.wdc.com>
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 25a6a25b17a2..1e38bb967871 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6779,23 +6779,13 @@ static void ufshcd_init_desc_sizes(struct ufs_hba *hba)
 		&hba->desc_size.geom_desc);
 	if (err)
 		hba->desc_size.geom_desc = QUERY_DESC_GEOMETRY_DEF_SIZE;
+
 	err = ufshcd_read_desc_length(hba, QUERY_DESC_IDN_HEALTH, 0,
 		&hba->desc_size.hlth_desc);
 	if (err)
 		hba->desc_size.hlth_desc = QUERY_DESC_HEALTH_DEF_SIZE;
 }
 
-static void ufshcd_def_desc_sizes(struct ufs_hba *hba)
-{
-	hba->desc_size.dev_desc = QUERY_DESC_DEVICE_DEF_SIZE;
-	hba->desc_size.pwr_desc = QUERY_DESC_POWER_DEF_SIZE;
-	hba->desc_size.interc_desc = QUERY_DESC_INTERCONNECT_DEF_SIZE;
-	hba->desc_size.conf_desc = QUERY_DESC_CONFIGURATION_DEF_SIZE;
-	hba->desc_size.unit_desc = QUERY_DESC_UNIT_DEF_SIZE;
-	hba->desc_size.geom_desc = QUERY_DESC_GEOMETRY_DEF_SIZE;
-	hba->desc_size.hlth_desc = QUERY_DESC_HEALTH_DEF_SIZE;
-}
-
 static struct ufs_ref_clk ufs_ref_clk_freqs[] = {
 	{19200000, REF_CLK_FREQ_19_2_MHZ},
 	{26000000, REF_CLK_FREQ_26_MHZ},
@@ -8283,9 +8273,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	hba->mmio_base = mmio_base;
 	hba->irq = irq;
 
-	/* Set descriptor lengths to specification defaults */
-	ufshcd_def_desc_sizes(hba);
-
 	err = ufshcd_hba_init(hba);
 	if (err)
 		goto out_error;
-- 
2.20.1

