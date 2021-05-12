Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EACA37CA00
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbhELQX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:23:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240127AbhELQRO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:17:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A33061C76;
        Wed, 12 May 2021 15:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834200;
        bh=knmJHBvyqqFKitxksHyy8h6XvibOlRZcIruRMKrqPb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsauEHjStEs3Td0orOZqTTNbQK19e8EL/UMNwOBWyCrUmoEWYRympS1o0JdfsxVEs
         QuOf8ZCSSlYJatOjcK0R55aIHdbUa5ifmexVY8qXFKcQ9g5wX6gybuqcvNtpJjuWJU
         vmao6nYWESWnbvUvBEnXSoJsRHqs1oSlxyp0heKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 403/601] iommu/dma: Resurrect the "forcedac" option
Date:   Wed, 12 May 2021 16:48:00 +0200
Message-Id: <20210512144841.085221279@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 3542dcb15cef66c0b9e6c3b33168eb657e0d9520 ]

In converting intel-iommu over to the common IOMMU DMA ops, it quietly
lost the functionality of its "forcedac" option. Since this is a handy
thing both for testing and for performance optimisation on certain
platforms, reimplement it under the common IOMMU parameter namespace.

For the sake of fixing the inadvertent breakage of the Intel-specific
parameter, remove the dmar_forcedac remnants and hook it up as an alias
while documenting the transition to the new common parameter.

Fixes: c588072bba6b ("iommu/vt-d: Convert intel iommu driver to the iommu ops")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Link: https://lore.kernel.org/r/7eece8e0ea7bfbe2cd0e30789e0d46df573af9b0.1614961776.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 15 ++++++++-------
 drivers/iommu/dma-iommu.c                       | 13 ++++++++++++-
 drivers/iommu/intel/iommu.c                     |  5 ++---
 include/linux/dma-iommu.h                       |  2 ++
 4 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a10b545c2070..b537a9608895 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1854,13 +1854,6 @@
 			bypassed by not enabling DMAR with this option. In
 			this case, gfx device will use physical address for
 			DMA.
-		forcedac [X86-64]
-			With this option iommu will not optimize to look
-			for io virtual address below 32-bit forcing dual
-			address cycle on pci bus for cards supporting greater
-			than 32-bit addressing. The default is to look
-			for translation below 32-bit and if not available
-			then look in the higher range.
 		strict [Default Off]
 			With this option on every unmap_single operation will
 			result in a hardware IOTLB flush operation as opposed
@@ -1949,6 +1942,14 @@
 		nobypass	[PPC/POWERNV]
 			Disable IOMMU bypass, using IOMMU for PCI devices.
 
+	iommu.forcedac=	[ARM64, X86] Control IOVA allocation for PCI devices.
+			Format: { "0" | "1" }
+			0 - Try to allocate a 32-bit DMA address first, before
+			  falling back to the full range if needed.
+			1 - Allocate directly from the full usable range,
+			  forcing Dual Address Cycle for PCI cards supporting
+			  greater than 32-bit addressing.
+
 	iommu.strict=	[ARM64] Configure TLB invalidation behaviour
 			Format: { "0" | "1" }
 			0 - Lazy mode.
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 07e7b2f3ba27..9d4a29796fe4 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -52,6 +52,17 @@ struct iommu_dma_cookie {
 };
 
 static DEFINE_STATIC_KEY_FALSE(iommu_deferred_attach_enabled);
+bool iommu_dma_forcedac __read_mostly;
+
+static int __init iommu_dma_forcedac_setup(char *str)
+{
+	int ret = kstrtobool(str, &iommu_dma_forcedac);
+
+	if (!ret && iommu_dma_forcedac)
+		pr_info("Forcing DAC for PCI devices\n");
+	return ret;
+}
+early_param("iommu.forcedac", iommu_dma_forcedac_setup);
 
 void iommu_dma_free_cpu_cached_iovas(unsigned int cpu,
 		struct iommu_domain *domain)
@@ -456,7 +467,7 @@ static dma_addr_t iommu_dma_alloc_iova(struct iommu_domain *domain,
 		dma_limit = min(dma_limit, (u64)domain->geometry.aperture_end);
 
 	/* Try to get PCI devices a SAC address */
-	if (dma_limit > DMA_BIT_MASK(32) && dev_is_pci(dev))
+	if (dma_limit > DMA_BIT_MASK(32) && !iommu_dma_forcedac && dev_is_pci(dev))
 		iova = alloc_iova_fast(iovad, iova_len,
 				       DMA_BIT_MASK(32) >> shift, false);
 
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index e49a79322c53..005daf50107d 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -350,7 +350,6 @@ int intel_iommu_enabled = 0;
 EXPORT_SYMBOL_GPL(intel_iommu_enabled);
 
 static int dmar_map_gfx = 1;
-static int dmar_forcedac;
 static int intel_iommu_strict;
 static int intel_iommu_superpage = 1;
 static int iommu_identity_mapping;
@@ -441,8 +440,8 @@ static int __init intel_iommu_setup(char *str)
 			dmar_map_gfx = 0;
 			pr_info("Disable GFX device mapping\n");
 		} else if (!strncmp(str, "forcedac", 8)) {
-			pr_info("Forcing DAC for PCI devices\n");
-			dmar_forcedac = 1;
+			pr_warn("intel_iommu=forcedac deprecated; use iommu.forcedac instead\n");
+			iommu_dma_forcedac = true;
 		} else if (!strncmp(str, "strict", 6)) {
 			pr_info("Disable batched IOTLB flush\n");
 			intel_iommu_strict = 1;
diff --git a/include/linux/dma-iommu.h b/include/linux/dma-iommu.h
index 706b68d1359b..13d1f4c14d7b 100644
--- a/include/linux/dma-iommu.h
+++ b/include/linux/dma-iommu.h
@@ -40,6 +40,8 @@ void iommu_dma_get_resv_regions(struct device *dev, struct list_head *list);
 void iommu_dma_free_cpu_cached_iovas(unsigned int cpu,
 		struct iommu_domain *domain);
 
+extern bool iommu_dma_forcedac;
+
 #else /* CONFIG_IOMMU_DMA */
 
 struct iommu_domain;
-- 
2.30.2



