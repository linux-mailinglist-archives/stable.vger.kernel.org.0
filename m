Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0392F138C
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731238AbhAKNKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:10:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:57080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731236AbhAKNKk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:10:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25847227C3;
        Mon, 11 Jan 2021 13:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370624;
        bh=BQSipWm4K8jrZ6XWz6uhxK9p+QWwX1+/3UZ0O6jNdkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRSobjXqWIzYURRcWNiy5kfO0Un2p1rGmlQnl80mrfTrWSou0DKrFQdqvbam6qGVZ
         JvgWnC7sj71k/Ovu2TZhOMAg8uDNE3FrnXJYn55lhVCXwJWPpESuBzi/q506Z7431f
         9Z113A8pnOXFDNc6S8P+pI4+6ehK4m77/wlDfhbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/92] scsi: ufs-pci: Ensure UFS device is in PowerDown mode for suspend-to-disk ->poweroff()
Date:   Mon, 11 Jan 2021 14:01:07 +0100
Message-Id: <20210111130039.323817472@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit af423534d2de86cd0db729a5ac41f056ca8717de ]

The expectation for suspend-to-disk is that devices will be powered-off, so
the UFS device should be put in PowerDown mode. If spm_lvl is not 5, then
that will not happen. Change the pm callbacks to force spm_lvl 5 for
suspend-to-disk poweroff.

Link: https://lore.kernel.org/r/20201207083120.26732-3-adrian.hunter@intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd-pci.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 3b19de3ae9a30..e4ba2445ff56f 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -96,6 +96,30 @@ static int ufshcd_pci_resume(struct device *dev)
 {
 	return ufshcd_system_resume(dev_get_drvdata(dev));
 }
+
+/**
+ * ufshcd_pci_poweroff - suspend-to-disk poweroff function
+ * @dev: pointer to PCI device handle
+ *
+ * Returns 0 if successful
+ * Returns non-zero otherwise
+ */
+static int ufshcd_pci_poweroff(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int spm_lvl = hba->spm_lvl;
+	int ret;
+
+	/*
+	 * For poweroff we need to set the UFS device to PowerDown mode.
+	 * Force spm_lvl to ensure that.
+	 */
+	hba->spm_lvl = 5;
+	ret = ufshcd_system_suspend(hba);
+	hba->spm_lvl = spm_lvl;
+	return ret;
+}
+
 #endif /* !CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_PM
@@ -190,8 +214,14 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 }
 
 static const struct dev_pm_ops ufshcd_pci_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_pci_suspend,
-				ufshcd_pci_resume)
+#ifdef CONFIG_PM_SLEEP
+	.suspend	= ufshcd_pci_suspend,
+	.resume		= ufshcd_pci_resume,
+	.freeze		= ufshcd_pci_suspend,
+	.thaw		= ufshcd_pci_resume,
+	.poweroff	= ufshcd_pci_poweroff,
+	.restore	= ufshcd_pci_resume,
+#endif
 	SET_RUNTIME_PM_OPS(ufshcd_pci_runtime_suspend,
 			   ufshcd_pci_runtime_resume,
 			   ufshcd_pci_runtime_idle)
-- 
2.27.0



