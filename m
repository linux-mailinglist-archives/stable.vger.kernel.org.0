Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A73C365097
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 04:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhDTC4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 22:56:08 -0400
Received: from mga04.intel.com ([192.55.52.120]:44248 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhDTC4I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 22:56:08 -0400
IronPort-SDR: edVZBTkDAL8hrKhLzk5bV0ia7wFsQHyxCR9rr3MN+mvkaELGeqM+cRdUSq2PGEzg0+kMxh3/qe
 C8xR2nOHuX0g==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="193308685"
X-IronPort-AV: E=Sophos;i="5.82,235,1613462400"; 
   d="scan'208";a="193308685"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2021 19:55:37 -0700
IronPort-SDR: CAJVH2FbCBXOeh6Kk14yftkJhGYblD+fDKdZFAavVfQs8qrSKUvF5hKBHiy3H9PwQ/ci15O3Iu
 SZ1MWQiQOfqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,235,1613462400"; 
   d="scan'208";a="400848296"
Received: from ipu5-build.bj.intel.com ([10.238.232.202])
  by orsmga002.jf.intel.com with ESMTP; 19 Apr 2021 19:55:32 -0700
From:   Bingbu Cao <bingbu.cao@intel.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc:     dwmw2@infradead.org, baolu.lu@linux.intel.com, joro@8bytes.org,
        will@kernel.org, bhelgaas@google.com, rajatja@google.com,
        grundler@chromium.org, tfiga@chromium.org,
        senozhatsky@chromium.org, sakari.ailus@linux.intel.com,
        andriy.shevchenko@linux.intel.com, bingbu.cao@intel.com,
        bingbu.cao@linux.intel.com
Subject: [RESEND v2] iommu/vt-d: Use passthrough mode for the Intel IPUs
Date:   Tue, 20 Apr 2021 10:48:33 +0800
Message-Id: <1618886913-6594-1-git-send-email-bingbu.cao@intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Intel IPU(Image Processing Unit) has its own (IO)MMU hardware,
The IPU driver allocates its own page table that is not mapped
via the DMA, and thus the Intel IOMMU driver blocks access giving
this error:

DMAR: DRHD: handling fault status reg 3
DMAR: [DMA Read] Request device [00:05.0] PASID ffffffff
      fault addr 76406000 [fault reason 06] PTE Read access is not set

As IPU is not an external facing device which is not risky, so use
IOMMU passthrough mode for Intel IPUs.

Fixes: 26f5689592e2 ("media: staging/intel-ipu3: mmu: Implement driver")
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
---
 drivers/iommu/intel/iommu.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index ee0932307d64..7e2fbdae467e 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -55,6 +55,12 @@
 #define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
 #define IS_USB_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_SERIAL_USB)
 #define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
+#define IS_INTEL_IPU(pdev) ((pdev)->vendor == PCI_VENDOR_ID_INTEL &&	\
+			    ((pdev)->device == 0x9a19 ||		\
+			     (pdev)->device == 0x9a39 ||		\
+			     (pdev)->device == 0x4e19 ||		\
+			     (pdev)->device == 0x465d ||		\
+			     (pdev)->device == 0x1919))
 #define IS_AZALIA(pdev) ((pdev)->vendor == 0x8086 && (pdev)->device == 0x3a3e)
 
 #define IOAPIC_RANGE_START	(0xfee00000)
@@ -360,6 +366,7 @@ int intel_iommu_enabled = 0;
 EXPORT_SYMBOL_GPL(intel_iommu_enabled);
 
 static int dmar_map_gfx = 1;
+static int dmar_map_ipu = 1;
 static int dmar_forcedac;
 static int intel_iommu_strict;
 static int intel_iommu_superpage = 1;
@@ -368,6 +375,7 @@ static int iommu_skip_te_disable;
 
 #define IDENTMAP_GFX		2
 #define IDENTMAP_AZALIA		4
+#define IDENTMAP_IPU		8
 
 int intel_iommu_gfx_mapped;
 EXPORT_SYMBOL_GPL(intel_iommu_gfx_mapped);
@@ -2839,6 +2847,9 @@ static int device_def_domain_type(struct device *dev)
 
 		if ((iommu_identity_mapping & IDENTMAP_GFX) && IS_GFX_DEVICE(pdev))
 			return IOMMU_DOMAIN_IDENTITY;
+
+		if ((iommu_identity_mapping & IDENTMAP_IPU) && IS_INTEL_IPU(pdev))
+			return IOMMU_DOMAIN_IDENTITY;
 	}
 
 	return 0;
@@ -3278,6 +3289,9 @@ static int __init init_dmars(void)
 	if (!dmar_map_gfx)
 		iommu_identity_mapping |= IDENTMAP_GFX;
 
+	if (!dmar_map_ipu)
+		iommu_identity_mapping |= IDENTMAP_IPU;
+
 	check_tylersburg_isoch();
 
 	ret = si_domain_init(hw_pass_through);
@@ -5622,6 +5636,18 @@ static void quirk_iommu_igfx(struct pci_dev *dev)
 	dmar_map_gfx = 0;
 }
 
+static void quirk_iommu_ipu(struct pci_dev *dev)
+{
+	if (!IS_INTEL_IPU(dev))
+		return;
+
+	if (risky_device(dev))
+		return;
+
+	pci_info(dev, "Passthrough IOMMU for integrated Intel IPU\n");
+	dmar_map_ipu = 0;
+}
+
 /* G4x/GM45 integrated gfx dmar support is totally busted. */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2a40, quirk_iommu_igfx);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e00, quirk_iommu_igfx);
@@ -5657,6 +5683,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x1632, quirk_iommu_igfx);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x163A, quirk_iommu_igfx);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x163D, quirk_iommu_igfx);
 
+/* disable IPU dmar support */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, quirk_iommu_ipu);
+
 static void quirk_iommu_rwbf(struct pci_dev *dev)
 {
 	if (risky_device(dev))
-- 
2.7.4

