Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9093A499D9F
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1585797AbiAXWZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1578869AbiAXWRR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:17:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E2FC06E010;
        Mon, 24 Jan 2022 11:32:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9B48B81247;
        Mon, 24 Jan 2022 19:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F21AC340E5;
        Mon, 24 Jan 2022 19:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052769;
        bh=ZJme4Yid2pZKebZ4YavbIa0wEaqlh17EKn5d80x8Sd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhXNGTwpL5VC4UGNPv8WgnUr4R4Qy8ER2+eIyPbcKDJ6w7F9LiJrWFdP+A4TJ3fqW
         cJ1s1JCvgbzDA0TacXuxhrxrdpZLFu7erXfJnm/rp1o1omq+xHY8gvs7y1tBSena3U
         qEyKmscTijV7+EgzSGIO7cEq+pkt5vG7IBeVuytU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 135/320] scsi: ufs: Fix race conditions related to driver data
Date:   Mon, 24 Jan 2022 19:41:59 +0100
Message-Id: <20220124183958.253484533@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index 67a6a61154b71..4e471484539d2 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pci.c
+++ b/drivers/scsi/ufs/tc-dwc-g210-pci.c
@@ -135,7 +135,6 @@ tc_dwc_g210_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
-	pci_set_drvdata(pdev, hba);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_allow(&pdev->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 8d40dc918f4e1..10eec501f6b39 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -436,8 +436,6 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 		goto dealloc_host;
 	}
 
-	platform_set_drvdata(pdev, hba);
-
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 29c7a76d2c658..ebf7ae1ef70d4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8328,6 +8328,13 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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



