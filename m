Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F413C592380
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240930AbiHNQWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240817AbiHNQVi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:21:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E058B140C9;
        Sun, 14 Aug 2022 09:20:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BECA60B4E;
        Sun, 14 Aug 2022 16:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CF6C433D6;
        Sun, 14 Aug 2022 16:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660493999;
        bh=YI2a3bQsRpitOm3qvXNGbLX4UFt3jIL05K8HgbujqzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q7UL13Xr3n8vsNcHpB5q3DRXA4nVdL1AtEFl6qlMcJOUzN0daGytf/cNN6UIO//Iv
         5jjeW+WxKBv6Q0Sm9t+LD7BdYJUDTdyfcahoT90P+AsPnI885nKV8tvBEC9ZT+Moqy
         5jM3eoQ2Vy1kjsWUdqRybx8fRkxG54xWxJTtJkuuGev7klSrOrUQ1Tb2uNkwZdqBa5
         HKg3e4QDAFg2qKhGNUBW59Irpt2p4LzT4AJR6pCOQ3StgV0ZtDKbAlQrRax/AlI10+
         JrfFc3JBGQgVpO+uHWp2Z2vRIuPvfvaHeb1A63q8EfzDofs6tYFO9M6ZBVdu5QZUkT
         GnRCVU2jJnZXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunfei Wang <yf.wang@mediatek.com>, Ning Li <ning.li@mediatek.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>, joro@8bytes.org,
        matthias.bgg@gmail.com, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 07/48] iommu/io-pgtable-arm-v7s: Add a quirk to allow pgtable PA up to 35bit
Date:   Sun, 14 Aug 2022 12:19:00 -0400
Message-Id: <20220814161943.2394452-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814161943.2394452-1-sashal@kernel.org>
References: <20220814161943.2394452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfei Wang <yf.wang@mediatek.com>

[ Upstream commit bfdd231374181254742c5e2faef0bef2d30c0ee4 ]

Single memory zone feature will remove ZONE_DMA32 and ZONE_DMA and
cause pgtable PA size larger than 32bit.

Since Mediatek IOMMU hardware support at most 35bit PA in pgtable,
so add a quirk to allow the PA of pgtables support up to bit35.

Signed-off-by: Ning Li <ning.li@mediatek.com>
Signed-off-by: Yunfei Wang <yf.wang@mediatek.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20220630092927.24925-2-yf.wang@mediatek.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/io-pgtable-arm-v7s.c | 75 ++++++++++++++++++++++--------
 include/linux/io-pgtable.h         | 15 ++++--
 2 files changed, 66 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/io-pgtable-arm-v7s.c b/drivers/iommu/io-pgtable-arm-v7s.c
index be066c1503d3..ba3115fd0f86 100644
--- a/drivers/iommu/io-pgtable-arm-v7s.c
+++ b/drivers/iommu/io-pgtable-arm-v7s.c
@@ -182,14 +182,8 @@ static bool arm_v7s_is_mtk_enabled(struct io_pgtable_cfg *cfg)
 		(cfg->quirks & IO_PGTABLE_QUIRK_ARM_MTK_EXT);
 }
 
-static arm_v7s_iopte paddr_to_iopte(phys_addr_t paddr, int lvl,
-				    struct io_pgtable_cfg *cfg)
+static arm_v7s_iopte to_mtk_iopte(phys_addr_t paddr, arm_v7s_iopte pte)
 {
-	arm_v7s_iopte pte = paddr & ARM_V7S_LVL_MASK(lvl);
-
-	if (!arm_v7s_is_mtk_enabled(cfg))
-		return pte;
-
 	if (paddr & BIT_ULL(32))
 		pte |= ARM_V7S_ATTR_MTK_PA_BIT32;
 	if (paddr & BIT_ULL(33))
@@ -199,6 +193,17 @@ static arm_v7s_iopte paddr_to_iopte(phys_addr_t paddr, int lvl,
 	return pte;
 }
 
+static arm_v7s_iopte paddr_to_iopte(phys_addr_t paddr, int lvl,
+				    struct io_pgtable_cfg *cfg)
+{
+	arm_v7s_iopte pte = paddr & ARM_V7S_LVL_MASK(lvl);
+
+	if (arm_v7s_is_mtk_enabled(cfg))
+		return to_mtk_iopte(paddr, pte);
+
+	return pte;
+}
+
 static phys_addr_t iopte_to_paddr(arm_v7s_iopte pte, int lvl,
 				  struct io_pgtable_cfg *cfg)
 {
@@ -240,10 +245,17 @@ static void *__arm_v7s_alloc_table(int lvl, gfp_t gfp,
 	dma_addr_t dma;
 	size_t size = ARM_V7S_TABLE_SIZE(lvl, cfg);
 	void *table = NULL;
+	gfp_t gfp_l1;
+
+	/*
+	 * ARM_MTK_TTBR_EXT extend the translation table base support larger
+	 * memory address.
+	 */
+	gfp_l1 = cfg->quirks & IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT ?
+		 GFP_KERNEL : ARM_V7S_TABLE_GFP_DMA;
 
 	if (lvl == 1)
-		table = (void *)__get_free_pages(
-			__GFP_ZERO | ARM_V7S_TABLE_GFP_DMA, get_order(size));
+		table = (void *)__get_free_pages(gfp_l1 | __GFP_ZERO, get_order(size));
 	else if (lvl == 2)
 		table = kmem_cache_zalloc(data->l2_tables, gfp);
 
@@ -251,7 +263,8 @@ static void *__arm_v7s_alloc_table(int lvl, gfp_t gfp,
 		return NULL;
 
 	phys = virt_to_phys(table);
-	if (phys != (arm_v7s_iopte)phys) {
+	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT ?
+	    phys >= (1ULL << cfg->oas) : phys != (arm_v7s_iopte)phys) {
 		/* Doesn't fit in PTE */
 		dev_err(dev, "Page table does not fit in PTE: %pa", &phys);
 		goto out_free;
@@ -457,9 +470,14 @@ static arm_v7s_iopte arm_v7s_install_table(arm_v7s_iopte *table,
 					   arm_v7s_iopte curr,
 					   struct io_pgtable_cfg *cfg)
 {
+	phys_addr_t phys = virt_to_phys(table);
 	arm_v7s_iopte old, new;
 
-	new = virt_to_phys(table) | ARM_V7S_PTE_TYPE_TABLE;
+	new = phys | ARM_V7S_PTE_TYPE_TABLE;
+
+	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT)
+		new = to_mtk_iopte(phys, new);
+
 	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_NS)
 		new |= ARM_V7S_ATTR_NS_TABLE;
 
@@ -779,6 +797,8 @@ static struct io_pgtable *arm_v7s_alloc_pgtable(struct io_pgtable_cfg *cfg,
 						void *cookie)
 {
 	struct arm_v7s_io_pgtable *data;
+	slab_flags_t slab_flag;
+	phys_addr_t paddr;
 
 	if (cfg->ias > (arm_v7s_is_mtk_enabled(cfg) ? 34 : ARM_V7S_ADDR_BITS))
 		return NULL;
@@ -788,7 +808,8 @@ static struct io_pgtable *arm_v7s_alloc_pgtable(struct io_pgtable_cfg *cfg,
 
 	if (cfg->quirks & ~(IO_PGTABLE_QUIRK_ARM_NS |
 			    IO_PGTABLE_QUIRK_NO_PERMS |
-			    IO_PGTABLE_QUIRK_ARM_MTK_EXT))
+			    IO_PGTABLE_QUIRK_ARM_MTK_EXT |
+			    IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT))
 		return NULL;
 
 	/* If ARM_MTK_4GB is enabled, the NO_PERMS is also expected. */
@@ -796,15 +817,27 @@ static struct io_pgtable *arm_v7s_alloc_pgtable(struct io_pgtable_cfg *cfg,
 	    !(cfg->quirks & IO_PGTABLE_QUIRK_NO_PERMS))
 			return NULL;
 
+	if ((cfg->quirks & IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT) &&
+	    !arm_v7s_is_mtk_enabled(cfg))
+		return NULL;
+
 	data = kmalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return NULL;
 
 	spin_lock_init(&data->split_lock);
+
+	/*
+	 * ARM_MTK_TTBR_EXT extend the translation table base support larger
+	 * memory address.
+	 */
+	slab_flag = cfg->quirks & IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT ?
+		    0 : ARM_V7S_TABLE_SLAB_FLAGS;
+
 	data->l2_tables = kmem_cache_create("io-pgtable_armv7s_l2",
 					    ARM_V7S_TABLE_SIZE(2, cfg),
 					    ARM_V7S_TABLE_SIZE(2, cfg),
-					    ARM_V7S_TABLE_SLAB_FLAGS, NULL);
+					    slab_flag, NULL);
 	if (!data->l2_tables)
 		goto out_free_data;
 
@@ -850,12 +883,16 @@ static struct io_pgtable *arm_v7s_alloc_pgtable(struct io_pgtable_cfg *cfg,
 	wmb();
 
 	/* TTBR */
-	cfg->arm_v7s_cfg.ttbr = virt_to_phys(data->pgd) | ARM_V7S_TTBR_S |
-				(cfg->coherent_walk ? (ARM_V7S_TTBR_NOS |
-				 ARM_V7S_TTBR_IRGN_ATTR(ARM_V7S_RGN_WBWA) |
-				 ARM_V7S_TTBR_ORGN_ATTR(ARM_V7S_RGN_WBWA)) :
-				(ARM_V7S_TTBR_IRGN_ATTR(ARM_V7S_RGN_NC) |
-				 ARM_V7S_TTBR_ORGN_ATTR(ARM_V7S_RGN_NC)));
+	paddr = virt_to_phys(data->pgd);
+	if (arm_v7s_is_mtk_enabled(cfg))
+		cfg->arm_v7s_cfg.ttbr = paddr | upper_32_bits(paddr);
+	else
+		cfg->arm_v7s_cfg.ttbr = paddr | ARM_V7S_TTBR_S |
+					(cfg->coherent_walk ? (ARM_V7S_TTBR_NOS |
+					 ARM_V7S_TTBR_IRGN_ATTR(ARM_V7S_RGN_WBWA) |
+					 ARM_V7S_TTBR_ORGN_ATTR(ARM_V7S_RGN_WBWA)) :
+					(ARM_V7S_TTBR_IRGN_ATTR(ARM_V7S_RGN_NC) |
+					 ARM_V7S_TTBR_ORGN_ATTR(ARM_V7S_RGN_NC)));
 	return &data->iop;
 
 out_free_data:
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index 86af6f0a00a2..ca98aeadcc80 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -74,17 +74,22 @@ struct io_pgtable_cfg {
 	 *	to support up to 35 bits PA where the bit32, bit33 and bit34 are
 	 *	encoded in the bit9, bit4 and bit5 of the PTE respectively.
 	 *
+	 * IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT: (ARM v7s format) MediaTek IOMMUs
+	 *	extend the translation table base support up to 35 bits PA, the
+	 *	encoding format is same with IO_PGTABLE_QUIRK_ARM_MTK_EXT.
+	 *
 	 * IO_PGTABLE_QUIRK_ARM_TTBR1: (ARM LPAE format) Configure the table
 	 *	for use in the upper half of a split address space.
 	 *
 	 * IO_PGTABLE_QUIRK_ARM_OUTER_WBWA: Override the outer-cacheability
 	 *	attributes set in the TCR for a non-coherent page-table walker.
 	 */
-	#define IO_PGTABLE_QUIRK_ARM_NS		BIT(0)
-	#define IO_PGTABLE_QUIRK_NO_PERMS	BIT(1)
-	#define IO_PGTABLE_QUIRK_ARM_MTK_EXT	BIT(3)
-	#define IO_PGTABLE_QUIRK_ARM_TTBR1	BIT(5)
-	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA	BIT(6)
+	#define IO_PGTABLE_QUIRK_ARM_NS			BIT(0)
+	#define IO_PGTABLE_QUIRK_NO_PERMS		BIT(1)
+	#define IO_PGTABLE_QUIRK_ARM_MTK_EXT		BIT(3)
+	#define IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT	BIT(4)
+	#define IO_PGTABLE_QUIRK_ARM_TTBR1		BIT(5)
+	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA		BIT(6)
 	unsigned long			quirks;
 	unsigned long			pgsize_bitmap;
 	unsigned int			ias;
-- 
2.35.1

