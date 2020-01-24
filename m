Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEC8B147B31
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732311AbgAXJlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732273AbgAXJli (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:41:38 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC874214DB;
        Fri, 24 Jan 2020 09:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858897;
        bh=IqcEnoa0m9WxUpsSqFPhQNy2NQ8Zp/Lkojade5w8z4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYxf6Qx299c/bRS/FyS7/uW4eAhGM8QAkAFiEETeRlAvQiWoX1fxHD7rYNnOLzgaq
         4d2j32/5UG+yEAEjW+ir/2awS4djumb1sTPEiGgoIVl0Use3p2f5Tv7kMGFBzWKukR
         lmMx6ouRfodBPjxYP9CR3chEHXWXfonmxBUGnQR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, avri.altman@wdc.com
Subject: [PATCH 5.4 071/102] scsi: ufs: delete redundant function ufshcd_def_desc_sizes()
Date:   Fri, 24 Jan 2020 10:31:12 +0100
Message-Id: <20200124092817.335596567@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 25a6a25b17a28..1e38bb967871d 100644
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



