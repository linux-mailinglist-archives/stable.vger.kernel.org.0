Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACDD22A4C1
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 03:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387477AbgGWBje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 21:39:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:34860 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387462AbgGWBjd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 21:39:33 -0400
IronPort-SDR: n60riF+YSzJ23OZCk1B6Z4jXrRN/9fNYpj7RuS7dZTU3zm8MATIdFy1N4k4feBVoqdAhq1mkPM
 y76P8KamGdog==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="211993696"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="211993696"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 18:39:32 -0700
IronPort-SDR: 7zrhWpDc8Dq+RDs5PTNPbO6CO5f02gsBGbOw/XTvQCn86sOgMbs0NIXZyWIWy/LCGgPeuV/ZMb
 LgyuEdJB/rXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="284414083"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by orsmga003.jf.intel.com with ESMTP; 22 Jul 2020 18:39:29 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Koba Ko <koba.ko@canonical.com>, Jun Miao <jun.miao@windriver.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Ashok Raj <ashok.raj@intel.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/1] iommu/vt-d: Skip TE disabling on quirky gfx dedicated iommu
Date:   Thu, 23 Jul 2020 09:34:37 +0800
Message-Id: <20200723013437.2268-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The VT-d spec requires (10.4.4 Global Command Register, TE field) that:

Hardware implementations supporting DMA draining must drain any in-flight
DMA read/write requests queued within the Root-Complex before completing
the translation enable command and reflecting the status of the command
through the TES field in the Global Status register.

Unfortunately, some integrated graphic devices fail to do so after some
kind of power state transition. As the result, the system might stuck in
iommu_disable_translation(), waiting for the completion of TE transition.

This provides a quirk list for those devices and skips TE disabling if
the qurik hits.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=208363
Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=206571
Tested-by: Koba Ko <koba.ko@canonical.com>
Tested-by: Jun Miao <jun.miao@windriver.com>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 Change since v1:
 - Add below tags:
   Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=206571
   Tested-by: Jun Miao <jun.miao@windriver.com>

 drivers/iommu/intel/dmar.c  |  1 +
 drivers/iommu/intel/iommu.c | 27 +++++++++++++++++++++++++++
 include/linux/dmar.h        |  1 +
 include/linux/intel-iommu.h |  2 ++
 4 files changed, 31 insertions(+)

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 683b812c5c47..16f47041f1bf 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1102,6 +1102,7 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 	}
 
 	drhd->iommu = iommu;
+	iommu->drhd = drhd;
 
 	return 0;
 
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index d759e7234e98..a459eac96754 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -356,6 +356,7 @@ static int intel_iommu_strict;
 static int intel_iommu_superpage = 1;
 static int iommu_identity_mapping;
 static int intel_no_bounce;
+static int iommu_skip_te_disable;
 
 #define IDENTMAP_GFX		2
 #define IDENTMAP_AZALIA		4
@@ -1629,6 +1630,10 @@ static void iommu_disable_translation(struct intel_iommu *iommu)
 	u32 sts;
 	unsigned long flag;
 
+	if (iommu_skip_te_disable && iommu->drhd->gfx_dedicated &&
+	    (cap_read_drain(iommu->cap) || cap_write_drain(iommu->cap)))
+		return;
+
 	raw_spin_lock_irqsave(&iommu->register_lock, flag);
 	iommu->gcmd &= ~DMA_GCMD_TE;
 	writel(iommu->gcmd, iommu->reg + DMAR_GCMD_REG);
@@ -4039,6 +4044,7 @@ static void __init init_no_remapping_devices(void)
 
 		/* This IOMMU has *only* gfx devices. Either bypass it or
 		   set the gfx_mapped flag, as appropriate */
+		drhd->gfx_dedicated = 1;
 		if (!dmar_map_gfx) {
 			drhd->ignored = 1;
 			for_each_active_dev_scope(drhd->devices,
@@ -6182,6 +6188,27 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x0044, quirk_calpella_no_shadow_g
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x0062, quirk_calpella_no_shadow_gtt);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x006a, quirk_calpella_no_shadow_gtt);
 
+static void quirk_igfx_skip_te_disable(struct pci_dev *dev)
+{
+	unsigned short ver;
+
+	if (!IS_GFX_DEVICE(dev))
+		return;
+
+	ver = (dev->device >> 8) & 0xff;
+	if (ver != 0x45 && ver != 0x46 && ver != 0x4c &&
+	    ver != 0x4e && ver != 0x8a && ver != 0x98 &&
+	    ver != 0x9a)
+		return;
+
+	if (risky_device(dev))
+		return;
+
+	pci_info(dev, "Skip IOMMU disabling for graphics\n");
+	iommu_skip_te_disable = 1;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, quirk_igfx_skip_te_disable);
+
 /* On Tylersburg chipsets, some BIOSes have been known to enable the
    ISOCH DMAR unit for the Azalia sound device, but not give it any
    TLB entries, which causes it to deadlock. Check for that.  We do
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index d7bf029df737..65565820328a 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -48,6 +48,7 @@ struct dmar_drhd_unit {
 	u16	segment;		/* PCI domain		*/
 	u8	ignored:1; 		/* ignore drhd		*/
 	u8	include_all:1;
+	u8	gfx_dedicated:1;	/* graphic dedicated	*/
 	struct intel_iommu *iommu;
 };
 
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 3e8fa1c7a1e6..04bd9279c3fb 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -600,6 +600,8 @@ struct intel_iommu {
 	struct iommu_device iommu;  /* IOMMU core code handle */
 	int		node;
 	u32		flags;      /* Software defined flags */
+
+	struct dmar_drhd_unit *drhd;
 };
 
 /* PCI domain-device relationship */
-- 
2.17.1

