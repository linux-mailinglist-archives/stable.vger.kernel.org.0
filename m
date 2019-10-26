Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47CEAE5D73
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfJZNQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:16:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbfJZNQG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:16:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05EE921897;
        Sat, 26 Oct 2019 13:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095765;
        bh=lOdJL/LUFTJZ8eR9zv4gZAu7pjGdv3hDBHXTMPM/GWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wi+LNeXq2AjYGfD8TxuTxcPh/3e7BZ36z3Z44wTWOmMOILcWIq1erzYtplZWqiqWB
         Zj2keJqmrm2TVOnnbggrpRjx+6givvw93MzVS1M7NhRUdaAdW2s4ferRrUom/38A2Z
         X7yaHumLZVXqyp9ZLMZOufhlZ9ZMXasug3Su6taU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Steven Price <steven.price@arm.com>,
        Rob Herring <robh@kernel.org>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.3 03/99] iommu/io-pgtable-arm: Correct Mali attributes
Date:   Sat, 26 Oct 2019 09:14:24 -0400
Message-Id: <20191026131600.2507-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 52f325f4eb321ea2e8a0779f49a3866be58bc694 ]

Whilst Midgard's MEMATTR follows a similar principle to the VMSA MAIR,
the actual attribute values differ, so although it currently appears to
work to some degree, we probably shouldn't be using our standard stage 1
MAIR for that. Instead, generate a reasonable MEMATTR with attribute
values borrowed from the kbase driver; at this point we'll be overriding
or ignoring pretty much all of the LPAE config, so just implement these
Mali details in a dedicated allocator instead of pretending to subclass
the standard VMSA format.

Fixes: d08d42de6432 ("iommu: io-pgtable: Add ARM Mali midgard MMU page table format")
Tested-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/io-pgtable-arm.c | 53 +++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 161a7d56264d0..9e35cd991f065 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -167,6 +167,9 @@
 #define ARM_MALI_LPAE_TTBR_READ_INNER	BIT(2)
 #define ARM_MALI_LPAE_TTBR_SHARE_OUTER	BIT(4)
 
+#define ARM_MALI_LPAE_MEMATTR_IMP_DEF	0x88ULL
+#define ARM_MALI_LPAE_MEMATTR_WRITE_ALLOC 0x8DULL
+
 /* IOPTE accessors */
 #define iopte_deref(pte,d) __va(iopte_to_paddr(pte, d))
 
@@ -1013,27 +1016,51 @@ arm_32_lpae_alloc_pgtable_s2(struct io_pgtable_cfg *cfg, void *cookie)
 static struct io_pgtable *
 arm_mali_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 {
-	struct io_pgtable *iop;
+	struct arm_lpae_io_pgtable *data;
+
+	/* No quirks for Mali (hopefully) */
+	if (cfg->quirks)
+		return NULL;
 
 	if (cfg->ias != 48 || cfg->oas > 40)
 		return NULL;
 
 	cfg->pgsize_bitmap &= (SZ_4K | SZ_2M | SZ_1G);
-	iop = arm_64_lpae_alloc_pgtable_s1(cfg, cookie);
-	if (iop) {
-		u64 mair, ttbr;
 
-		/* Copy values as union fields overlap */
-		mair = cfg->arm_lpae_s1_cfg.mair[0];
-		ttbr = cfg->arm_lpae_s1_cfg.ttbr[0];
+	data = arm_lpae_alloc_pgtable(cfg);
+	if (!data)
+		return NULL;
 
-		cfg->arm_mali_lpae_cfg.memattr = mair;
-		cfg->arm_mali_lpae_cfg.transtab = ttbr |
-			ARM_MALI_LPAE_TTBR_READ_INNER |
-			ARM_MALI_LPAE_TTBR_ADRMODE_TABLE;
-	}
+	/*
+	 * MEMATTR: Mali has no actual notion of a non-cacheable type, so the
+	 * best we can do is mimic the out-of-tree driver and hope that the
+	 * "implementation-defined caching policy" is good enough. Similarly,
+	 * we'll use it for the sake of a valid attribute for our 'device'
+	 * index, although callers should never request that in practice.
+	 */
+	cfg->arm_mali_lpae_cfg.memattr =
+		(ARM_MALI_LPAE_MEMATTR_IMP_DEF
+		 << ARM_LPAE_MAIR_ATTR_SHIFT(ARM_LPAE_MAIR_ATTR_IDX_NC)) |
+		(ARM_MALI_LPAE_MEMATTR_WRITE_ALLOC
+		 << ARM_LPAE_MAIR_ATTR_SHIFT(ARM_LPAE_MAIR_ATTR_IDX_CACHE)) |
+		(ARM_MALI_LPAE_MEMATTR_IMP_DEF
+		 << ARM_LPAE_MAIR_ATTR_SHIFT(ARM_LPAE_MAIR_ATTR_IDX_DEV));
 
-	return iop;
+	data->pgd = __arm_lpae_alloc_pages(data->pgd_size, GFP_KERNEL, cfg);
+	if (!data->pgd)
+		goto out_free_data;
+
+	/* Ensure the empty pgd is visible before TRANSTAB can be written */
+	wmb();
+
+	cfg->arm_mali_lpae_cfg.transtab = virt_to_phys(data->pgd) |
+					  ARM_MALI_LPAE_TTBR_READ_INNER |
+					  ARM_MALI_LPAE_TTBR_ADRMODE_TABLE;
+	return &data->iop;
+
+out_free_data:
+	kfree(data);
+	return NULL;
 }
 
 struct io_pgtable_init_fns io_pgtable_arm_64_lpae_s1_init_fns = {
-- 
2.20.1

