Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2509449A976
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322601AbiAYDWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:22:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56326 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356458AbiAXUbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:31:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4806B6153C;
        Mon, 24 Jan 2022 20:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C294C340E7;
        Mon, 24 Jan 2022 20:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056297;
        bh=mGRwhgutD5F/03hC0eC/ggllLNMardUvS9KmQ8CBr2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Juv54I0vYHKa6xOTRTVuAYxcBGL+mnM+2P8zkZwNPni+nVm79j1RJdWq1/laHVc5b
         5TJ1eE0+LBg/JkNwjn3V37ojk4URet41ZlmTqrPz3h+hHDYcXsskhfo3yFNyW7rpmI
         RYM12L88JJ7Ty2sZfPN8oXdyUHHsa5keuPbrJGZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 405/846] scsi: ufs: Fix race conditions related to driver data
Date:   Mon, 24 Jan 2022 19:38:42 +0100
Message-Id: <20220124184114.936665356@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 21ad0e49085deb22c094f91f9da57319a97188e4 ]

The driver data pointer must be set before any callbacks are registered
that use that pointer. Hence move the initialization of that pointer from
after the ufshcd_init() call to inside ufshcd_init().

Link: https://lore.kernel.org/r/20211203231950.193369-7-bvanassche@acm.org
Fixes: 3b1d05807a9a ("[SCSI] ufs: Segregate PCI Specific Code")
Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/tc-dwc-g210-pci.c | 1 -
 drivers/scsi/ufs/ufshcd-pci.c      | 2 --
 drivers/scsi/ufs/ufshcd-pltfrm.c   | 2 --
 drivers/scsi/ufs/ufshcd.c          | 7 +++++++
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/tc-dwc-g210-pci.c b/drivers/scsi/ufs/tc-dwc-g210-pci.c
index 679289e1a78e6..7b08e2e07cc5f 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pci.c
+++ b/drivers/scsi/ufs/tc-dwc-g210-pci.c
@@ -110,7 +110,6 @@ tc_dwc_g210_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
-	pci_set_drvdata(pdev, hba);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_allow(&pdev->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index f725248ba57f4..f76692053ca17 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -538,8 +538,6 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
-	pci_set_drvdata(pdev, hba);
-
 	hba->vops = (struct ufs_hba_variant_ops *)id->driver_data;
 
 	err = ufshcd_init(hba, mmio_base, pdev->irq);
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index eaeae83b999fd..8b16bbbcb806c 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -361,8 +361,6 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 		goto dealloc_host;
 	}
 
-	platform_set_drvdata(pdev, hba);
-
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 31adf25e57b0d..300bf00765d5b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9366,6 +9366,13 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	struct device *dev = hba->dev;
 	char eh_wq_name[sizeof("ufs_eh_wq_00")];
 
+	/*
+	 * dev_set_drvdata() must be called before any callbacks are registered
+	 * that use dev_get_drvdata() (frequency scaling, clock scaling, hwmon,
+	 * sysfs).
+	 */
+	dev_set_drvdata(dev, hba);
+
 	if (!mmio_base) {
 		dev_err(hba->dev,
 		"Invalid memory reference for mmio_base is NULL\n");
-- 
2.34.1



