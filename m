Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A45454A656
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352984AbiFNCY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354688AbiFNCXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:23:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F8D40A08;
        Mon, 13 Jun 2022 19:10:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12CEC60B76;
        Tue, 14 Jun 2022 02:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F34C36AFF;
        Tue, 14 Jun 2022 02:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172610;
        bh=e+leZ6zhrBvbbyf5uKQq5Da8htGpVpjP3Bj5RpkC16U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbtakEZS97LpWwPqmiRbRI71NQtnE1S5ygbeWyNbpTA9gUBTXi3FgQlgk0Dcdqf1D
         JXe+U3h1RgqmbqmBLLGqviGGwajZSuF6y76VdhnFOUP0youZaBgY/z1PqYD3qXJCAw
         +BRx2Yl90KmBeBQI2N8nOPmQQk0nsF6bC10nNzJ+L7pjS1VRe2m8WSLvJdlsOf7MpQ
         XEKED9AKNm5s9vQTF7wrJvopNAABmWYqW2mhODfYXB1ACaZNM19Ds0SRZ8gESXmdIb
         H5N3Jktniq8mc/BzPIJ2/G59TbfcbQL+DdV72rKg3f2qWHyuHF3iFk1nHWbElruOMK
         4y6L4pnNaXomw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/18] scsi: ipr: Fix missing/incorrect resource cleanup in error case
Date:   Mon, 13 Jun 2022 22:09:35 -0400
Message-Id: <20220614020941.1100702-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020941.1100702-1-sashal@kernel.org>
References: <20220614020941.1100702-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengguang Xu <cgxu519@mykernel.net>

[ Upstream commit d64c491911322af1dcada98e5b9ee0d87e8c8fee ]

Fix missing resource cleanup (when '(--i) == 0') for error case in
ipr_alloc_mem() and skip incorrect resource cleanup (when '(--i) == 0') for
error case in ipr_request_other_msi_irqs() because variable i started from
1.

Link: https://lore.kernel.org/r/20220529153456.4183738-4-cgxu519@mykernel.net
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ipr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 1b04a8223eb0..c6cde552b995 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9783,7 +9783,7 @@ static int ipr_alloc_mem(struct ipr_ioa_cfg *ioa_cfg)
 					GFP_KERNEL);
 
 		if (!ioa_cfg->hrrq[i].host_rrq)  {
-			while (--i > 0)
+			while (--i >= 0)
 				dma_free_coherent(&pdev->dev,
 					sizeof(u32) * ioa_cfg->hrrq[i].size,
 					ioa_cfg->hrrq[i].host_rrq,
@@ -10056,7 +10056,7 @@ static int ipr_request_other_msi_irqs(struct ipr_ioa_cfg *ioa_cfg,
 			ioa_cfg->vectors_info[i].desc,
 			&ioa_cfg->hrrq[i]);
 		if (rc) {
-			while (--i >= 0)
+			while (--i > 0)
 				free_irq(pci_irq_vector(pdev, i),
 					&ioa_cfg->hrrq[i]);
 			return rc;
-- 
2.35.1

