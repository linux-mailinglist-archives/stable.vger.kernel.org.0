Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6775615E9EC
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392357AbgBNRKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:10:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403925AbgBNQNp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:13:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC59D246DE;
        Fri, 14 Feb 2020 16:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696824;
        bh=eIfNHxaTaF6oemS/jKYLYEWreka0CQ5m1S3ahstw9uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKCye3p00wPGQdEK1Xhi630FoIEkqVTfO2xFwbNOUj1eLPANN6wflFFfCH8HxSSaD
         8LSTDxmW1gZV1ixW9UIW4PCyL56fq2w+jNG3M9swF990EcjdAYZiFVqDTh6skYJZmw
         5fR6Z4NnA3q8gGSDNiEMGq5bd0Y7Xo/d5FBpVAz4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Liu <wei.liu@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 091/252] PCI: iproc: Apply quirk_paxc_bridge() for module as well as built-in
Date:   Fri, 14 Feb 2020 11:09:06 -0500
Message-Id: <20200214161147.15842-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Liu <wei.liu@kernel.org>

[ Upstream commit 574f29036fce385e28617547955dd6911d375025 ]

Previously quirk_paxc_bridge() was applied when the iproc driver was
built-in, but not when it was compiled as a module.

This happened because it was under #ifdef CONFIG_PCIE_IPROC_PLATFORM:
PCIE_IPROC_PLATFORM=y causes CONFIG_PCIE_IPROC_PLATFORM to be defined, but
PCIE_IPROC_PLATFORM=m causes CONFIG_PCIE_IPROC_PLATFORM_MODULE to be
defined.

Move quirk_paxc_bridge() to pcie-iproc.c and drop the #ifdef so the quirk
is always applied, whether iproc is built-in or a module.

[bhelgaas: commit log, move to pcie-iproc.c, not pcie-iproc-platform.c]
Link: https://lore.kernel.org/r/20191211174511.89713-1-wei.liu@kernel.org
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-iproc.c | 24 ++++++++++++++++++++++++
 drivers/pci/quirks.c                | 26 --------------------------
 2 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/pci/controller/pcie-iproc.c b/drivers/pci/controller/pcie-iproc.c
index 9d5cbc75d5ae0..ec86414216f97 100644
--- a/drivers/pci/controller/pcie-iproc.c
+++ b/drivers/pci/controller/pcie-iproc.c
@@ -1526,6 +1526,30 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_BROADCOM, 0xd802,
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_BROADCOM, 0xd804,
 			quirk_paxc_disable_msi_parsing);
 
+static void quirk_paxc_bridge(struct pci_dev *pdev)
+{
+	/*
+	 * The PCI config space is shared with the PAXC root port and the first
+	 * Ethernet device.  So, we need to workaround this by telling the PCI
+	 * code that the bridge is not an Ethernet device.
+	 */
+	if (pdev->hdr_type == PCI_HEADER_TYPE_BRIDGE)
+		pdev->class = PCI_CLASS_BRIDGE_PCI << 8;
+
+	/*
+	 * MPSS is not being set properly (as it is currently 0).  This is
+	 * because that area of the PCI config space is hard coded to zero, and
+	 * is not modifiable by firmware.  Set this to 2 (e.g., 512 byte MPS)
+	 * so that the MPS can be set to the real max value.
+	 */
+	pdev->pcie_mpss = 2;
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_BROADCOM, 0x16cd, quirk_paxc_bridge);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_BROADCOM, 0x16f0, quirk_paxc_bridge);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_BROADCOM, 0xd750, quirk_paxc_bridge);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_BROADCOM, 0xd802, quirk_paxc_bridge);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_BROADCOM, 0xd804, quirk_paxc_bridge);
+
 MODULE_AUTHOR("Ray Jui <rjui@broadcom.com>");
 MODULE_DESCRIPTION("Broadcom iPROC PCIe common driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 5b4c36ab15962..84f10cda539ea 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2358,32 +2358,6 @@ DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_BROADCOM,
 			 PCI_DEVICE_ID_TIGON3_5719,
 			 quirk_brcm_5719_limit_mrrs);
 
-#ifdef CONFIG_PCIE_IPROC_PLATFORM
-static void quirk_paxc_bridge(struct pci_dev *pdev)
-{
-	/*
-	 * The PCI config space is shared with the PAXC root port and the first
-	 * Ethernet device.  So, we need to workaround this by telling the PCI
-	 * code that the bridge is not an Ethernet device.
-	 */
-	if (pdev->hdr_type == PCI_HEADER_TYPE_BRIDGE)
-		pdev->class = PCI_CLASS_BRIDGE_PCI << 8;
-
-	/*
-	 * MPSS is not being set properly (as it is currently 0).  This is
-	 * because that area of the PCI config space is hard coded to zero, and
-	 * is not modifiable by firmware.  Set this to 2 (e.g., 512 byte MPS)
-	 * so that the MPS can be set to the real max value.
-	 */
-	pdev->pcie_mpss = 2;
-}
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_BROADCOM, 0x16cd, quirk_paxc_bridge);
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_BROADCOM, 0x16f0, quirk_paxc_bridge);
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_BROADCOM, 0xd750, quirk_paxc_bridge);
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_BROADCOM, 0xd802, quirk_paxc_bridge);
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_BROADCOM, 0xd804, quirk_paxc_bridge);
-#endif
-
 /*
  * Originally in EDAC sources for i82875P: Intel tells BIOS developers to
  * hide device 6 which configures the overflow device access containing the
-- 
2.20.1

