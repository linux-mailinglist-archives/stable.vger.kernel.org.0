Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31E9A147696
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 02:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730284AbgAXBUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 20:20:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:60226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730373AbgAXBRT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 20:17:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEC9B2087E;
        Fri, 24 Jan 2020 01:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579828638;
        bh=211t5XzXWX/CIo9MpU3YiGbam3sw1bdHL6udOFgw1+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3+oPbPvDDpkUxWJ5MN801KO0X+bEsnI9BACfh9GGoECGX5jUHp8aFgPb6zms8Dn3
         vczg1vvkZIiCspdqmWM8o+M05VRMpioYfPp0F+W9AHAOkoaoF8aDUij84ClJrNpr7w
         xpJKxQ9neSGlkRMyDwt2bbt/Ova53u0Sw+SyC2AE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Slawomir Pawlowski <slawomir.pawlowski@intel.com>,
        Przemek Kitszel <przemyslawx.kitszel@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/33] PCI: Add DMA alias quirk for Intel VCA NTB
Date:   Thu, 23 Jan 2020 20:16:43 -0500
Message-Id: <20200124011708.18232-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124011708.18232-1-sashal@kernel.org>
References: <20200124011708.18232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slawomir Pawlowski <slawomir.pawlowski@intel.com>

[ Upstream commit 56b4cd4b7da9ee95778eb5c8abea49f641ebfd91 ]

Intel Visual Compute Accelerator (VCA) is a family of PCIe add-in devices
exposing computational units via Non Transparent Bridges (NTB, PEX 87xx).

Similarly to MIC x200, we need to add DMA aliases to allow buffer access
when IOMMU is enabled.

Add aliases to allow computational unit access to host memory.  These
aliases mark the whole VCA device as one IOMMU group.

All possible slot numbers (0x20) are used, since we are unable to tell what
slot is used on other side.  This quirk is intended for both host and
computational unit sides.  The VCA devices have up to five functions: four
for DMA channels and one additional.

Link: https://lore.kernel.org/r/5683A335CC8BE1438C3C30C49DCC38DF637CED8E@IRSMSX102.ger.corp.intel.com
Signed-off-by: Slawomir Pawlowski <slawomir.pawlowski@intel.com>
Signed-off-by: Przemek Kitszel <przemyslawx.kitszel@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 308f744393ebe..2544e210b9840 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4080,6 +4080,40 @@ static void quirk_mic_x200_dma_alias(struct pci_dev *pdev)
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2260, quirk_mic_x200_dma_alias);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2264, quirk_mic_x200_dma_alias);
 
+/*
+ * Intel Visual Compute Accelerator (VCA) is a family of PCIe add-in devices
+ * exposing computational units via Non Transparent Bridges (NTB, PEX 87xx).
+ *
+ * Similarly to MIC x200, we need to add DMA aliases to allow buffer access
+ * when IOMMU is enabled.  These aliases allow computational unit access to
+ * host memory.  These aliases mark the whole VCA device as one IOMMU
+ * group.
+ *
+ * All possible slot numbers (0x20) are used, since we are unable to tell
+ * what slot is used on other side.  This quirk is intended for both host
+ * and computational unit sides.  The VCA devices have up to five functions
+ * (four for DMA channels and one additional).
+ */
+static void quirk_pex_vca_alias(struct pci_dev *pdev)
+{
+	const unsigned int num_pci_slots = 0x20;
+	unsigned int slot;
+
+	for (slot = 0; slot < num_pci_slots; slot++) {
+		pci_add_dma_alias(pdev, PCI_DEVFN(slot, 0x0));
+		pci_add_dma_alias(pdev, PCI_DEVFN(slot, 0x1));
+		pci_add_dma_alias(pdev, PCI_DEVFN(slot, 0x2));
+		pci_add_dma_alias(pdev, PCI_DEVFN(slot, 0x3));
+		pci_add_dma_alias(pdev, PCI_DEVFN(slot, 0x4));
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2954, quirk_pex_vca_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2955, quirk_pex_vca_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2956, quirk_pex_vca_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2958, quirk_pex_vca_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2959, quirk_pex_vca_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x295A, quirk_pex_vca_alias);
+
 /*
  * The IOMMU and interrupt controller on Broadcom Vulcan/Cavium ThunderX2 are
  * associated not at the root bus, but at a bridge below. This quirk avoids
-- 
2.20.1

