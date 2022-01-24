Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0302498B36
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345848AbiAXTMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:12:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37860 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344560AbiAXTH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:07:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A60EC611ED;
        Mon, 24 Jan 2022 19:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E80C340E7;
        Mon, 24 Jan 2022 19:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051277;
        bh=NmMex1hUSvPxt8t3CgZsrJCcWmi1yWg90e+EwbPuPPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nvIP9mTfwSRlCO/fZl6V5Rqg1K0Kd4UDW1JVadQf1BGpkAZ3Cm8qoF5hkBQTP5Gc
         JH6uDYUkkQd+8KtzAyCbhQuZcFfAzzyxAIyNEgtpLJBD7VlRlLrsC/s8xMIc07kQLE
         lMXJJcXScZ6C+uO6bUE6Bj775QtieYVM8eb9RX4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 077/186] scsi: ufs: Fix race conditions related to driver data
Date:   Mon, 24 Jan 2022 19:42:32 +0100
Message-Id: <20220124183939.599917695@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
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
 drivers/scsi/ufs/ufshcd-pltfrm.c   | 2 --
 drivers/scsi/ufs/ufshcd.c          | 7 +++++++
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/tc-dwc-g210-pci.c b/drivers/scsi/ufs/tc-dwc-g210-pci.c
index 325d5e14fc0d8..a8b50fc1960d1 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pci.c
+++ b/drivers/scsi/ufs/tc-dwc-g210-pci.c
@@ -138,7 +138,6 @@ tc_dwc_g210_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
-	pci_set_drvdata(pdev, hba);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_allow(&pdev->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 8992354d4e2c7..6f076ff35dd38 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -348,8 +348,6 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 		goto dealloc_host;
 	}
 
-	platform_set_drvdata(pdev, hba);
-
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f46fa8a2f6585..694c0fc31fbf7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7904,6 +7904,13 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	struct Scsi_Host *host = hba->host;
 	struct device *dev = hba->dev;
 
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



