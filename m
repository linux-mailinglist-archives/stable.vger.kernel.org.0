Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8780324FA12
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbgHXJwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728535AbgHXIij (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:38:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C19A2177B;
        Mon, 24 Aug 2020 08:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258318;
        bh=Uhj6dEJu6AGEjcDWmhyIdamP5e5R5Xf5Z/7H+u4JIm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DIuWo2TRmW1cvdEXyHxiGYw3qOYCnOuMtveD4qIjVOfXfd/LzfJp31k3FcCPYlFdK
         msJrbOBZ9orv7ETqGBZDj2t6tN21RZVRjdZJb8Rvw1jhg5NXIYv3xuEZS0HBZpJRdr
         VCJfVAQSKkQc8GGSY9zl00CduSwi1nXnotAyO4wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 115/148] scsi: ufs-pci: Add quirk for broken auto-hibernate for Intel EHL
Date:   Mon, 24 Aug 2020 10:30:13 +0200
Message-Id: <20200824082419.519204503@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 8da76f71fef7d8a1a72af09d48899573feb60065 ]

Intel EHL UFS host controller advertises auto-hibernate capability but it
does not work correctly. Add a quirk for that.

[mkp: checkpatch fix]

Link: https://lore.kernel.org/r/20200810141024.28859-1-adrian.hunter@intel.com
Fixes: 8c09d7527697 ("scsi: ufshdc-pci: Add Intel PCI IDs for EHL")
Acked-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd-pci.c | 16 ++++++++++++++--
 drivers/scsi/ufs/ufshcd.h     |  9 ++++++++-
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 8f78a81514991..b220666774ce8 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -67,11 +67,23 @@ static int ufs_intel_link_startup_notify(struct ufs_hba *hba,
 	return err;
 }
 
+static int ufs_intel_ehl_init(struct ufs_hba *hba)
+{
+	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
+	return 0;
+}
+
 static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
 	.name                   = "intel-pci",
 	.link_startup_notify	= ufs_intel_link_startup_notify,
 };
 
+static struct ufs_hba_variant_ops ufs_intel_ehl_hba_vops = {
+	.name                   = "intel-pci",
+	.init			= ufs_intel_ehl_init,
+	.link_startup_notify	= ufs_intel_link_startup_notify,
+};
+
 #ifdef CONFIG_PM_SLEEP
 /**
  * ufshcd_pci_suspend - suspend power management function
@@ -200,8 +212,8 @@ static const struct dev_pm_ops ufshcd_pci_pm_ops = {
 static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ PCI_VDEVICE(INTEL, 0x9DFA), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
-	{ PCI_VDEVICE(INTEL, 0x4B41), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
-	{ PCI_VDEVICE(INTEL, 0x4B43), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x4B41), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x4B43), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
 	{ }	/* terminate list */
 };
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e38e9e0af6b59..4bf98c2295372 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -549,6 +549,12 @@ enum ufshcd_quirks {
 	 * OCS FATAL ERROR with device error through sense data
 	 */
 	UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR		= 1 << 10,
+
+	/*
+	 * This quirk needs to be enabled if the host controller has
+	 * auto-hibernate capability but it doesn't work.
+	 */
+	UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8		= 1 << 11,
 };
 
 enum ufshcd_caps {
@@ -815,7 +821,8 @@ return true;
 
 static inline bool ufshcd_is_auto_hibern8_supported(struct ufs_hba *hba)
 {
-	return (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT);
+	return (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT) &&
+		!(hba->quirks & UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8);
 }
 
 static inline bool ufshcd_is_auto_hibern8_enabled(struct ufs_hba *hba)
-- 
2.25.1



