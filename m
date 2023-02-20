Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF7669CD30
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbjBTNrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbjBTNrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:47:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AC91E1E0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:47:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BF58B80D4D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5ECFC433D2;
        Mon, 20 Feb 2023 13:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900787;
        bh=UGTU0MOHbMPkUy+v7OzXitunZQ/Qc/5LFri7p7iHH3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=omnjRUS+mFXbS21c6KMQNuUf94QX5MzgauEKdeDjDMLvfMKMRQA0ahY9c6xhFFcU7
         /RNgkjFvu3AQNa2Ga9ruaQ8FnM/mMQANHWxh5SpJ1f14w3NQX8fGV85vT79VKm2nLQ
         tO+pgslZYF1A1hgUmKK5jDZlFaTO/ysUsOI1FhLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tom Murphy <murphyt7@tcd.ie>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/156] iommu: Add gfp parameter to iommu_ops::map
Date:   Mon, 20 Feb 2023 14:35:11 +0100
Message-Id: <20230220133605.152833538@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Murphy <murphyt7@tcd.ie>

[ Upstream commit 781ca2de89bae1b1d2c96df9ef33e9a324415995 ]

Add a gfp_t parameter to the iommu_ops::map function.
Remove the needless locking in the AMD iommu driver.

The iommu_ops::map function (or the iommu_map function which calls it)
was always supposed to be sleepable (according to Joerg's comment in
this thread: https://lore.kernel.org/patchwork/patch/977520/ ) and so
should probably have had a "might_sleep()" since it was written. However
currently the dma-iommu api can call iommu_map in an atomic context,
which it shouldn't do. This doesn't cause any problems because any iommu
driver which uses the dma-iommu api uses gfp_atomic in it's
iommu_ops::map function. But doing this wastes the memory allocators
atomic pools.

Signed-off-by: Tom Murphy <murphyt7@tcd.ie>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: b7e08a5a63a1 ("RDMA/usnic: use iommu_map_atomic() under spin_lock()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu.c      |  3 ++-
 drivers/iommu/arm-smmu-v3.c    |  2 +-
 drivers/iommu/arm-smmu.c       |  2 +-
 drivers/iommu/dma-iommu.c      |  6 ++---
 drivers/iommu/exynos-iommu.c   |  2 +-
 drivers/iommu/intel-iommu.c    |  2 +-
 drivers/iommu/iommu.c          | 43 +++++++++++++++++++++++++++++-----
 drivers/iommu/ipmmu-vmsa.c     |  2 +-
 drivers/iommu/msm_iommu.c      |  2 +-
 drivers/iommu/mtk_iommu.c      |  2 +-
 drivers/iommu/mtk_iommu_v1.c   |  2 +-
 drivers/iommu/omap-iommu.c     |  2 +-
 drivers/iommu/qcom_iommu.c     |  2 +-
 drivers/iommu/rockchip-iommu.c |  2 +-
 drivers/iommu/s390-iommu.c     |  2 +-
 drivers/iommu/tegra-gart.c     |  2 +-
 drivers/iommu/tegra-smmu.c     |  2 +-
 drivers/iommu/virtio-iommu.c   |  2 +-
 include/linux/iommu.h          | 21 ++++++++++++++++-
 19 files changed, 77 insertions(+), 26 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index c392930253a30..5e269f3dca3dd 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3098,7 +3098,8 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 }
 
 static int amd_iommu_map(struct iommu_domain *dom, unsigned long iova,
-			 phys_addr_t paddr, size_t page_size, int iommu_prot)
+			 phys_addr_t paddr, size_t page_size, int iommu_prot,
+			 gfp_t gfp)
 {
 	struct protection_domain *domain = to_pdomain(dom);
 	int prot = 0;
diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 02c2fb551f381..4f64c3a9ee88d 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -2451,7 +2451,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 }
 
 static int arm_smmu_map(struct iommu_domain *domain, unsigned long iova,
-			phys_addr_t paddr, size_t size, int prot)
+			phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	struct io_pgtable_ops *ops = to_smmu_domain(domain)->pgtbl_ops;
 
diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 2185ea5191c15..775acae84d7d2 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1160,7 +1160,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 }
 
 static int arm_smmu_map(struct iommu_domain *domain, unsigned long iova,
-			phys_addr_t paddr, size_t size, int prot)
+			phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	struct io_pgtable_ops *ops = to_smmu_domain(domain)->pgtbl_ops;
 	struct arm_smmu_device *smmu = to_smmu_domain(domain)->smmu;
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 9c3e630c6c4c8..4fc8fb92d45ef 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -477,7 +477,7 @@ static dma_addr_t __iommu_dma_map(struct device *dev, phys_addr_t phys,
 	if (!iova)
 		return DMA_MAPPING_ERROR;
 
-	if (iommu_map(domain, iova, phys - iova_off, size, prot)) {
+	if (iommu_map_atomic(domain, iova, phys - iova_off, size, prot)) {
 		iommu_dma_free_iova(cookie, iova, size);
 		return DMA_MAPPING_ERROR;
 	}
@@ -612,7 +612,7 @@ static void *iommu_dma_alloc_remap(struct device *dev, size_t size,
 			arch_dma_prep_coherent(sg_page(sg), sg->length);
 	}
 
-	if (iommu_map_sg(domain, iova, sgt.sgl, sgt.orig_nents, ioprot)
+	if (iommu_map_sg_atomic(domain, iova, sgt.sgl, sgt.orig_nents, ioprot)
 			< size)
 		goto out_free_sg;
 
@@ -872,7 +872,7 @@ static int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg,
 	 * We'll leave any physical concatenation to the IOMMU driver's
 	 * implementation - it knows better than we do.
 	 */
-	if (iommu_map_sg(domain, iova, sg, nents, prot) < iova_len)
+	if (iommu_map_sg_atomic(domain, iova, sg, nents, prot) < iova_len)
 		goto out_free_iova;
 
 	return __finalise_sg(dev, sg, nents, iova);
diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 31a9b9885653f..acf21e4237949 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1077,7 +1077,7 @@ static int lv2set_page(sysmmu_pte_t *pent, phys_addr_t paddr, size_t size,
  */
 static int exynos_iommu_map(struct iommu_domain *iommu_domain,
 			    unsigned long l_iova, phys_addr_t paddr, size_t size,
-			    int prot)
+			    int prot, gfp_t gfp)
 {
 	struct exynos_iommu_domain *domain = to_exynos_domain(iommu_domain);
 	sysmmu_pte_t *entry;
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index ff120d7ed3424..2a53fa7d2b47d 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -5458,7 +5458,7 @@ static void intel_iommu_aux_detach_device(struct iommu_domain *domain,
 
 static int intel_iommu_map(struct iommu_domain *domain,
 			   unsigned long iova, phys_addr_t hpa,
-			   size_t size, int iommu_prot)
+			   size_t size, int iommu_prot, gfp_t gfp)
 {
 	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	u64 max_addr;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index c5758fb696cc8..ef8f0d1ac5ab1 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1858,8 +1858,8 @@ static size_t iommu_pgsize(struct iommu_domain *domain,
 	return pgsize;
 }
 
-int iommu_map(struct iommu_domain *domain, unsigned long iova,
-	      phys_addr_t paddr, size_t size, int prot)
+int __iommu_map(struct iommu_domain *domain, unsigned long iova,
+	      phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	const struct iommu_ops *ops = domain->ops;
 	unsigned long orig_iova = iova;
@@ -1896,8 +1896,8 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 
 		pr_debug("mapping: iova 0x%lx pa %pa pgsize 0x%zx\n",
 			 iova, &paddr, pgsize);
+		ret = ops->map(domain, iova, paddr, pgsize, prot, gfp);
 
-		ret = ops->map(domain, iova, paddr, pgsize, prot);
 		if (ret)
 			break;
 
@@ -1917,8 +1917,22 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 
 	return ret;
 }
+
+int iommu_map(struct iommu_domain *domain, unsigned long iova,
+	      phys_addr_t paddr, size_t size, int prot)
+{
+	might_sleep();
+	return __iommu_map(domain, iova, paddr, size, prot, GFP_KERNEL);
+}
 EXPORT_SYMBOL_GPL(iommu_map);
 
+int iommu_map_atomic(struct iommu_domain *domain, unsigned long iova,
+	      phys_addr_t paddr, size_t size, int prot)
+{
+	return __iommu_map(domain, iova, paddr, size, prot, GFP_ATOMIC);
+}
+EXPORT_SYMBOL_GPL(iommu_map_atomic);
+
 static size_t __iommu_unmap(struct iommu_domain *domain,
 			    unsigned long iova, size_t size,
 			    struct iommu_iotlb_gather *iotlb_gather)
@@ -1995,8 +2009,9 @@ size_t iommu_unmap_fast(struct iommu_domain *domain,
 }
 EXPORT_SYMBOL_GPL(iommu_unmap_fast);
 
-size_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
-		    struct scatterlist *sg, unsigned int nents, int prot)
+size_t __iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
+		    struct scatterlist *sg, unsigned int nents, int prot,
+		    gfp_t gfp)
 {
 	size_t len = 0, mapped = 0;
 	phys_addr_t start;
@@ -2007,7 +2022,9 @@ size_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 		phys_addr_t s_phys = sg_phys(sg);
 
 		if (len && s_phys != start + len) {
-			ret = iommu_map(domain, iova + mapped, start, len, prot);
+			ret = __iommu_map(domain, iova + mapped, start,
+					len, prot, gfp);
+
 			if (ret)
 				goto out_err;
 
@@ -2035,8 +2052,22 @@ size_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 	return 0;
 
 }
+
+size_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
+		    struct scatterlist *sg, unsigned int nents, int prot)
+{
+	might_sleep();
+	return __iommu_map_sg(domain, iova, sg, nents, prot, GFP_KERNEL);
+}
 EXPORT_SYMBOL_GPL(iommu_map_sg);
 
+size_t iommu_map_sg_atomic(struct iommu_domain *domain, unsigned long iova,
+		    struct scatterlist *sg, unsigned int nents, int prot)
+{
+	return __iommu_map_sg(domain, iova, sg, nents, prot, GFP_ATOMIC);
+}
+EXPORT_SYMBOL_GPL(iommu_map_sg_atomic);
+
 int iommu_domain_window_enable(struct iommu_domain *domain, u32 wnd_nr,
 			       phys_addr_t paddr, u64 size, int prot)
 {
diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
index 584eefab1dbcd..33874c7aea42c 100644
--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -724,7 +724,7 @@ static void ipmmu_detach_device(struct iommu_domain *io_domain,
 }
 
 static int ipmmu_map(struct iommu_domain *io_domain, unsigned long iova,
-		     phys_addr_t paddr, size_t size, int prot)
+		     phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	struct ipmmu_vmsa_domain *domain = to_vmsa_domain(io_domain);
 
diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index cba0097eba39c..696a6c53a69fd 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -504,7 +504,7 @@ static void msm_iommu_detach_dev(struct iommu_domain *domain,
 }
 
 static int msm_iommu_map(struct iommu_domain *domain, unsigned long iova,
-			 phys_addr_t pa, size_t len, int prot)
+			 phys_addr_t pa, size_t len, int prot, gfp_t gfp)
 {
 	struct msm_priv *priv = to_msm_priv(domain);
 	unsigned long flags;
diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 18d7c818a174c..dad44e10b3314 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -427,7 +427,7 @@ static void mtk_iommu_detach_device(struct iommu_domain *domain,
 }
 
 static int mtk_iommu_map(struct iommu_domain *domain, unsigned long iova,
-			 phys_addr_t paddr, size_t size, int prot)
+			 phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	struct mtk_iommu_domain *dom = to_mtk_domain(domain);
 	struct mtk_iommu_data *data = mtk_iommu_get_m4u_data();
diff --git a/drivers/iommu/mtk_iommu_v1.c b/drivers/iommu/mtk_iommu_v1.c
index e31bd281e59d6..fa602bfe69512 100644
--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -295,7 +295,7 @@ static void mtk_iommu_detach_device(struct iommu_domain *domain,
 }
 
 static int mtk_iommu_map(struct iommu_domain *domain, unsigned long iova,
-			 phys_addr_t paddr, size_t size, int prot)
+			 phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	struct mtk_iommu_domain *dom = to_mtk_domain(domain);
 	unsigned int page_num = size >> MT2701_IOMMU_PAGE_SHIFT;
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 09c6e1c680db9..be551cc34be45 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1339,7 +1339,7 @@ static u32 iotlb_init_entry(struct iotlb_entry *e, u32 da, u32 pa, int pgsz)
 }
 
 static int omap_iommu_map(struct iommu_domain *domain, unsigned long da,
-			  phys_addr_t pa, size_t bytes, int prot)
+			  phys_addr_t pa, size_t bytes, int prot, gfp_t gfp)
 {
 	struct omap_iommu_domain *omap_domain = to_omap_domain(domain);
 	struct device *dev = omap_domain->dev;
diff --git a/drivers/iommu/qcom_iommu.c b/drivers/iommu/qcom_iommu.c
index b6e546b62a7cb..e377f7771e30b 100644
--- a/drivers/iommu/qcom_iommu.c
+++ b/drivers/iommu/qcom_iommu.c
@@ -419,7 +419,7 @@ static void qcom_iommu_detach_dev(struct iommu_domain *domain, struct device *de
 }
 
 static int qcom_iommu_map(struct iommu_domain *domain, unsigned long iova,
-			  phys_addr_t paddr, size_t size, int prot)
+			  phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	int ret;
 	unsigned long flags;
diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index 0df091934361b..96f37d9d4d93c 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -758,7 +758,7 @@ static int rk_iommu_map_iova(struct rk_iommu_domain *rk_domain, u32 *pte_addr,
 }
 
 static int rk_iommu_map(struct iommu_domain *domain, unsigned long _iova,
-			phys_addr_t paddr, size_t size, int prot)
+			phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	struct rk_iommu_domain *rk_domain = to_rk_domain(domain);
 	unsigned long flags;
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index 3b0b18e23187c..1137f3ddcb851 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -265,7 +265,7 @@ static int s390_iommu_update_trans(struct s390_domain *s390_domain,
 }
 
 static int s390_iommu_map(struct iommu_domain *domain, unsigned long iova,
-			  phys_addr_t paddr, size_t size, int prot)
+			  phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	struct s390_domain *s390_domain = to_s390_domain(domain);
 	int flags = ZPCI_PTE_VALID, rc = 0;
diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
index 3924f7c055440..3fb7ba72507de 100644
--- a/drivers/iommu/tegra-gart.c
+++ b/drivers/iommu/tegra-gart.c
@@ -178,7 +178,7 @@ static inline int __gart_iommu_map(struct gart_device *gart, unsigned long iova,
 }
 
 static int gart_iommu_map(struct iommu_domain *domain, unsigned long iova,
-			  phys_addr_t pa, size_t bytes, int prot)
+			  phys_addr_t pa, size_t bytes, int prot, gfp_t gfp)
 {
 	struct gart_device *gart = gart_handle;
 	int ret;
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index dd486233e2828..576be3f245daa 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -651,7 +651,7 @@ static void tegra_smmu_set_pte(struct tegra_smmu_as *as, unsigned long iova,
 }
 
 static int tegra_smmu_map(struct iommu_domain *domain, unsigned long iova,
-			  phys_addr_t paddr, size_t size, int prot)
+			  phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	struct tegra_smmu_as *as = to_smmu_as(domain);
 	dma_addr_t pte_dma;
diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 60e659a24f90b..37e2267acf295 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -715,7 +715,7 @@ static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 }
 
 static int viommu_map(struct iommu_domain *domain, unsigned long iova,
-		      phys_addr_t paddr, size_t size, int prot)
+		      phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
 {
 	int ret;
 	u32 flags;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 29bac5345563a..6ca3fb2873d7d 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -256,7 +256,7 @@ struct iommu_ops {
 	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
 	void (*detach_dev)(struct iommu_domain *domain, struct device *dev);
 	int (*map)(struct iommu_domain *domain, unsigned long iova,
-		   phys_addr_t paddr, size_t size, int prot);
+		   phys_addr_t paddr, size_t size, int prot, gfp_t gfp);
 	size_t (*unmap)(struct iommu_domain *domain, unsigned long iova,
 		     size_t size, struct iommu_iotlb_gather *iotlb_gather);
 	void (*flush_iotlb_all)(struct iommu_domain *domain);
@@ -421,6 +421,8 @@ extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
 extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
 		     phys_addr_t paddr, size_t size, int prot);
+extern int iommu_map_atomic(struct iommu_domain *domain, unsigned long iova,
+			    phys_addr_t paddr, size_t size, int prot);
 extern size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 			  size_t size);
 extern size_t iommu_unmap_fast(struct iommu_domain *domain,
@@ -428,6 +430,9 @@ extern size_t iommu_unmap_fast(struct iommu_domain *domain,
 			       struct iommu_iotlb_gather *iotlb_gather);
 extern size_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 			   struct scatterlist *sg,unsigned int nents, int prot);
+extern size_t iommu_map_sg_atomic(struct iommu_domain *domain,
+				  unsigned long iova, struct scatterlist *sg,
+				  unsigned int nents, int prot);
 extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain, dma_addr_t iova);
 extern void iommu_set_fault_handler(struct iommu_domain *domain,
 			iommu_fault_handler_t handler, void *token);
@@ -662,6 +667,13 @@ static inline int iommu_map(struct iommu_domain *domain, unsigned long iova,
 	return -ENODEV;
 }
 
+static inline int iommu_map_atomic(struct iommu_domain *domain,
+				   unsigned long iova, phys_addr_t paddr,
+				   size_t size, int prot)
+{
+	return -ENODEV;
+}
+
 static inline size_t iommu_unmap(struct iommu_domain *domain,
 				 unsigned long iova, size_t size)
 {
@@ -682,6 +694,13 @@ static inline size_t iommu_map_sg(struct iommu_domain *domain,
 	return 0;
 }
 
+static inline size_t iommu_map_sg_atomic(struct iommu_domain *domain,
+				  unsigned long iova, struct scatterlist *sg,
+				  unsigned int nents, int prot)
+{
+	return 0;
+}
+
 static inline void iommu_flush_tlb_all(struct iommu_domain *domain)
 {
 }
-- 
2.39.0



