Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72AF30CBF4
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhBBThM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:42038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233008AbhBBNza (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:55:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1F1B64EC5;
        Tue,  2 Feb 2021 13:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273496;
        bh=jJNj5n1w4HU184AANRp5RZmEiTtFQQwfi98CutakT0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UnggyM7gok09Bm9udVvqyFAPE1wn9yvfKu1WmRwoRz/oWp3xhGuQpTUL4uEmk+zb8
         Tyr7Ra2jRURW26tXpbB8LytPZnMRzDuhDpPfhmW7ObS8b6QnwFMa5Bi1fmcmrDXbMB
         Ic0/VkiYxH+GyMgFHDy5vKxj1EhHEU+F2SidjOxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Robert Richter <rrichter@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/142] iommu/amd: Use IVHD EFR for early initialization of IOMMU features
Date:   Tue,  2 Feb 2021 14:38:11 +0100
Message-Id: <20210202133002.979869198@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

[ Upstream commit a44092e326d403c7878018ba532369f84d31dbfa ]

IOMMU Extended Feature Register (EFR) is used to communicate
the supported features for each IOMMU to the IOMMU driver.
This is normally read from the PCI MMIO register offset 0x30,
and used by the iommu_feature() helper function.

However, there are certain scenarios where the information is needed
prior to PCI initialization, and the iommu_feature() function is used
prematurely w/o warning. This has caused incorrect initialization of IOMMU.
This is the case for the commit 6d39bdee238f ("iommu/amd: Enforce 4k
mapping for certain IOMMU data structures")

Since, the EFR is also available in the IVHD header, and is available to
the driver prior to PCI initialization. Therefore, default to using
the IVHD EFR instead.

Fixes: 6d39bdee238f ("iommu/amd: Enforce 4k mapping for certain IOMMU data structures")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Brijesh Singh <brijesh.singh@amd.com>
Reviewed-by: Robert Richter <rrichter@amd.com>
Link: https://lore.kernel.org/r/20210120135002.2682-1-suravee.suthikulpanit@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu.h       |  7 ++--
 drivers/iommu/amd/amd_iommu_types.h |  4 +++
 drivers/iommu/amd/init.c            | 56 +++++++++++++++++++++++++++--
 3 files changed, 60 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 6b8cbdf717140..b4adab6985632 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -84,12 +84,9 @@ static inline bool is_rd890_iommu(struct pci_dev *pdev)
 	       (pdev->device == PCI_DEVICE_ID_RD890_IOMMU);
 }
 
-static inline bool iommu_feature(struct amd_iommu *iommu, u64 f)
+static inline bool iommu_feature(struct amd_iommu *iommu, u64 mask)
 {
-	if (!(iommu->cap & (1 << IOMMU_CAP_EFR)))
-		return false;
-
-	return !!(iommu->features & f);
+	return !!(iommu->features & mask);
 }
 
 static inline u64 iommu_virt_to_phys(void *vaddr)
diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 494b42a31b7ae..33446c9d3bac8 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -379,6 +379,10 @@
 #define IOMMU_CAP_NPCACHE 26
 #define IOMMU_CAP_EFR     27
 
+/* IOMMU IVINFO */
+#define IOMMU_IVINFO_OFFSET     36
+#define IOMMU_IVINFO_EFRSUP     BIT(0)
+
 /* IOMMU Feature Reporting Field (for IVHD type 10h */
 #define IOMMU_FEAT_GASUP_SHIFT	6
 
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 23a790f8f5506..c842545368fdd 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -257,6 +257,8 @@ static void init_device_table_dma(void);
 
 static bool amd_iommu_pre_enabled = true;
 
+static u32 amd_iommu_ivinfo __initdata;
+
 bool translation_pre_enabled(struct amd_iommu *iommu)
 {
 	return (iommu->flags & AMD_IOMMU_FLAG_TRANS_PRE_ENABLED);
@@ -296,6 +298,18 @@ int amd_iommu_get_num_iommus(void)
 	return amd_iommus_present;
 }
 
+/*
+ * For IVHD type 0x11/0x40, EFR is also available via IVHD.
+ * Default to IVHD EFR since it is available sooner
+ * (i.e. before PCI init).
+ */
+static void __init early_iommu_features_init(struct amd_iommu *iommu,
+					     struct ivhd_header *h)
+{
+	if (amd_iommu_ivinfo & IOMMU_IVINFO_EFRSUP)
+		iommu->features = h->efr_reg;
+}
+
 /* Access to l1 and l2 indexed register spaces */
 
 static u32 iommu_read_l1(struct amd_iommu *iommu, u16 l1, u8 address)
@@ -1584,6 +1598,9 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 		if ((h->efr_reg & BIT(IOMMU_EFR_XTSUP_SHIFT)) &&
 		    (h->efr_reg & BIT(IOMMU_EFR_MSICAPMMIOSUP_SHIFT)))
 			amd_iommu_xt_mode = IRQ_REMAP_X2APIC_MODE;
+
+		early_iommu_features_init(iommu, h);
+
 		break;
 	default:
 		return -EINVAL;
@@ -1775,6 +1792,35 @@ static const struct attribute_group *amd_iommu_groups[] = {
 	NULL,
 };
 
+/*
+ * Note: IVHD 0x11 and 0x40 also contains exact copy
+ * of the IOMMU Extended Feature Register [MMIO Offset 0030h].
+ * Default to EFR in IVHD since it is available sooner (i.e. before PCI init).
+ */
+static void __init late_iommu_features_init(struct amd_iommu *iommu)
+{
+	u64 features;
+
+	if (!(iommu->cap & (1 << IOMMU_CAP_EFR)))
+		return;
+
+	/* read extended feature bits */
+	features = readq(iommu->mmio_base + MMIO_EXT_FEATURES);
+
+	if (!iommu->features) {
+		iommu->features = features;
+		return;
+	}
+
+	/*
+	 * Sanity check and warn if EFR values from
+	 * IVHD and MMIO conflict.
+	 */
+	if (features != iommu->features)
+		pr_warn(FW_WARN "EFR mismatch. Use IVHD EFR (%#llx : %#llx\n).",
+			features, iommu->features);
+}
+
 static int __init iommu_init_pci(struct amd_iommu *iommu)
 {
 	int cap_ptr = iommu->cap_ptr;
@@ -1794,8 +1840,7 @@ static int __init iommu_init_pci(struct amd_iommu *iommu)
 	if (!(iommu->cap & (1 << IOMMU_CAP_IOTLB)))
 		amd_iommu_iotlb_sup = false;
 
-	/* read extended feature bits */
-	iommu->features = readq(iommu->mmio_base + MMIO_EXT_FEATURES);
+	late_iommu_features_init(iommu);
 
 	if (iommu_feature(iommu, FEATURE_GT)) {
 		int glxval;
@@ -2525,6 +2570,11 @@ static void __init free_dma_resources(void)
 	free_unity_maps();
 }
 
+static void __init ivinfo_init(void *ivrs)
+{
+	amd_iommu_ivinfo = *((u32 *)(ivrs + IOMMU_IVINFO_OFFSET));
+}
+
 /*
  * This is the hardware init function for AMD IOMMU in the system.
  * This function is called either from amd_iommu_init or from the interrupt
@@ -2579,6 +2629,8 @@ static int __init early_amd_iommu_init(void)
 	if (ret)
 		goto out;
 
+	ivinfo_init(ivrs_base);
+
 	amd_iommu_target_ivhd_type = get_highest_supported_ivhd_type(ivrs_base);
 	DUMP_printk("Using IVHD type %#x\n", amd_iommu_target_ivhd_type);
 
-- 
2.27.0



