Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D3F59392F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242148AbiHOScd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242426AbiHOSbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:31:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DA43340D;
        Mon, 15 Aug 2022 11:21:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B085A60BE9;
        Mon, 15 Aug 2022 18:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EF6C433C1;
        Mon, 15 Aug 2022 18:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587685;
        bh=GvM3E+AZZX7lYhFn5NiVlC4zztilrefSRbhsRU5CcIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxdR84Ookw3ZBT8NAk/2sUiYH9U2A6rTCsZ+1qDNtDRVM2oE6FvK+OlfuPMS3X/zo
         6/1yOMhxjwG/Shn7JZo/xDBzDVpTru5Sy7fUeYiWJe1X3Lb2hjPAAukFSORGKB25oM
         Q1bvAZ0pN/h+dAbVAFm9Df08oF0oTzzDGWDpQGa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/779] scsi: hisi_sas: Use managed PCI functions
Date:   Mon, 15 Aug 2022 19:56:47 +0200
Message-Id: <20220815180344.291473149@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 4f6094f1663e2ed26a940f1842cdaa15c1dd649a ]

Use managed PCI functions such as pcim_enable_device() and
pcim_iomap_regions() to simplify exception handling code.

Link: https://lore.kernel.org/r/1629799260-120116-2-git-send-email-john.garry@huawei.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 15c7451fb30f..fa22cb712be5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -518,6 +518,8 @@ struct hisi_sas_err_record_v3 {
 #define CHNL_INT_STS_INT2_MSK BIT(3)
 #define CHNL_WIDTH 4
 
+#define BAR_NO_V3_HW	5
+
 enum {
 	DSM_FUNC_ERR_HANDLE_MSI = 0,
 };
@@ -4740,15 +4742,15 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct sas_ha_struct *sha;
 	int rc, phy_nr, port_nr, i;
 
-	rc = pci_enable_device(pdev);
+	rc = pcim_enable_device(pdev);
 	if (rc)
 		goto err_out;
 
 	pci_set_master(pdev);
 
-	rc = pci_request_regions(pdev, DRV_NAME);
+	rc = pcim_iomap_regions(pdev, 1 << BAR_NO_V3_HW, DRV_NAME);
 	if (rc)
-		goto err_out_disable_device;
+		goto err_out;
 
 	rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (rc)
@@ -4756,20 +4758,20 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc) {
 		dev_err(dev, "No usable DMA addressing method\n");
 		rc = -ENODEV;
-		goto err_out_regions;
+		goto err_out;
 	}
 
 	shost = hisi_sas_shost_alloc_pci(pdev);
 	if (!shost) {
 		rc = -ENOMEM;
-		goto err_out_regions;
+		goto err_out;
 	}
 
 	sha = SHOST_TO_SAS_HA(shost);
 	hisi_hba = shost_priv(shost);
 	dev_set_drvdata(dev, sha);
 
-	hisi_hba->regs = pcim_iomap(pdev, 5, 0);
+	hisi_hba->regs = pcim_iomap_table(pdev)[BAR_NO_V3_HW];
 	if (!hisi_hba->regs) {
 		dev_err(dev, "cannot map register\n");
 		rc = -ENOMEM;
@@ -4861,10 +4863,6 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_out_ha:
 	hisi_sas_free(hisi_hba);
 	scsi_host_put(shost);
-err_out_regions:
-	pci_release_regions(pdev);
-err_out_disable_device:
-	pci_disable_device(pdev);
 err_out:
 	return rc;
 }
@@ -4901,8 +4899,6 @@ static void hisi_sas_v3_remove(struct pci_dev *pdev)
 	sas_remove_host(sha->core.shost);
 
 	hisi_sas_v3_destroy_irqs(pdev, hisi_hba);
-	pci_release_regions(pdev);
-	pci_disable_device(pdev);
 	hisi_sas_free(hisi_hba);
 	debugfs_exit_v3_hw(hisi_hba);
 	scsi_host_put(shost);
-- 
2.35.1



