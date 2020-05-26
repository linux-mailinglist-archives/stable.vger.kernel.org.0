Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464AE1D82F2
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732305AbgERSAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731267AbgERSAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:00:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 347CB20715;
        Mon, 18 May 2020 18:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824841;
        bh=UOZjw9GCTUkY7R7Iv/y8lPuVl0phoLjrNXJzRZAJgM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIAx8PVe/SdwkleGT30x8qY1lNV66wVkMg9/GSFQbs7+vJILH61mpsNkR50HTQTq2
         NMXNvEyAHFyL90Vhi4zmb8KAwSqkzJgfI50t46ja7dZ0WnVpMvTBgQB0dlJDUzcZyr
         6yd5bbfSHmu908fErjdQD1+L6mAx6VkciEPzh6dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 025/194] iommu/amd: Fix race in increase_address_space()/fetch_pte()
Date:   Mon, 18 May 2020 19:35:15 +0200
Message-Id: <20200518173533.632925454@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit eb791aa70b90c559eeb371d807c8813d569393f0 ]

The 'pt_root' and 'mode' struct members of 'struct protection_domain'
need to be get/set atomically, otherwise the page-table of the domain
can get corrupted.

Merge the fields into one atomic64_t struct member which can be
get/set atomically.

Fixes: 92d420ec028d ("iommu/amd: Relax locking in dma_ops path")
Reported-by: Qian Cai <cai@lca.pw>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Qian Cai <cai@lca.pw>
Link: https://lore.kernel.org/r/20200504125413.16798-2-joro@8bytes.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu.c       | 140 ++++++++++++++++++++++++--------
 drivers/iommu/amd_iommu_types.h |   9 +-
 2 files changed, 112 insertions(+), 37 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 20cce366e9518..28229a38af4d2 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -151,6 +151,26 @@ static struct protection_domain *to_pdomain(struct iommu_domain *dom)
 	return container_of(dom, struct protection_domain, domain);
 }
 
+static void amd_iommu_domain_get_pgtable(struct protection_domain *domain,
+					 struct domain_pgtable *pgtable)
+{
+	u64 pt_root = atomic64_read(&domain->pt_root);
+
+	pgtable->root = (u64 *)(pt_root & PAGE_MASK);
+	pgtable->mode = pt_root & 7; /* lowest 3 bits encode pgtable mode */
+}
+
+static u64 amd_iommu_domain_encode_pgtable(u64 *root, int mode)
+{
+	u64 pt_root;
+
+	/* lowest 3 bits encode pgtable mode */
+	pt_root = mode & 7;
+	pt_root |= (u64)root;
+
+	return pt_root;
+}
+
 static struct iommu_dev_data *alloc_dev_data(u16 devid)
 {
 	struct iommu_dev_data *dev_data;
@@ -1397,13 +1417,18 @@ static struct page *free_sub_pt(unsigned long root, int mode,
 
 static void free_pagetable(struct protection_domain *domain)
 {
-	unsigned long root = (unsigned long)domain->pt_root;
+	struct domain_pgtable pgtable;
 	struct page *freelist = NULL;
+	unsigned long root;
+
+	amd_iommu_domain_get_pgtable(domain, &pgtable);
+	atomic64_set(&domain->pt_root, 0);
 
-	BUG_ON(domain->mode < PAGE_MODE_NONE ||
-	       domain->mode > PAGE_MODE_6_LEVEL);
+	BUG_ON(pgtable.mode < PAGE_MODE_NONE ||
+	       pgtable.mode > PAGE_MODE_6_LEVEL);
 
-	freelist = free_sub_pt(root, domain->mode, freelist);
+	root = (unsigned long)pgtable.root;
+	freelist = free_sub_pt(root, pgtable.mode, freelist);
 
 	free_page_list(freelist);
 }
@@ -1417,24 +1442,28 @@ static bool increase_address_space(struct protection_domain *domain,
 				   unsigned long address,
 				   gfp_t gfp)
 {
+	struct domain_pgtable pgtable;
 	unsigned long flags;
 	bool ret = false;
-	u64 *pte;
+	u64 *pte, root;
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	if (address <= PM_LEVEL_SIZE(domain->mode) ||
-	    WARN_ON_ONCE(domain->mode == PAGE_MODE_6_LEVEL))
+	amd_iommu_domain_get_pgtable(domain, &pgtable);
+
+	if (address <= PM_LEVEL_SIZE(pgtable.mode) ||
+	    WARN_ON_ONCE(pgtable.mode == PAGE_MODE_6_LEVEL))
 		goto out;
 
 	pte = (void *)get_zeroed_page(gfp);
 	if (!pte)
 		goto out;
 
-	*pte             = PM_LEVEL_PDE(domain->mode,
-					iommu_virt_to_phys(domain->pt_root));
-	domain->pt_root  = pte;
-	domain->mode    += 1;
+	*pte = PM_LEVEL_PDE(pgtable.mode, iommu_virt_to_phys(pgtable.root));
+
+	root = amd_iommu_domain_encode_pgtable(pte, pgtable.mode + 1);
+
+	atomic64_set(&domain->pt_root, root);
 
 	ret = true;
 
@@ -1451,16 +1480,22 @@ static u64 *alloc_pte(struct protection_domain *domain,
 		      gfp_t gfp,
 		      bool *updated)
 {
+	struct domain_pgtable pgtable;
 	int level, end_lvl;
 	u64 *pte, *page;
 
 	BUG_ON(!is_power_of_2(page_size));
 
-	while (address > PM_LEVEL_SIZE(domain->mode))
+	amd_iommu_domain_get_pgtable(domain, &pgtable);
+
+	while (address > PM_LEVEL_SIZE(pgtable.mode)) {
 		*updated = increase_address_space(domain, address, gfp) || *updated;
+		amd_iommu_domain_get_pgtable(domain, &pgtable);
+	}
+
 
-	level   = domain->mode - 1;
-	pte     = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
+	level   = pgtable.mode - 1;
+	pte     = &pgtable.root[PM_LEVEL_INDEX(level, address)];
 	address = PAGE_SIZE_ALIGN(address, page_size);
 	end_lvl = PAGE_SIZE_LEVEL(page_size);
 
@@ -1536,16 +1571,19 @@ static u64 *fetch_pte(struct protection_domain *domain,
 		      unsigned long address,
 		      unsigned long *page_size)
 {
+	struct domain_pgtable pgtable;
 	int level;
 	u64 *pte;
 
 	*page_size = 0;
 
-	if (address > PM_LEVEL_SIZE(domain->mode))
+	amd_iommu_domain_get_pgtable(domain, &pgtable);
+
+	if (address > PM_LEVEL_SIZE(pgtable.mode))
 		return NULL;
 
-	level	   =  domain->mode - 1;
-	pte	   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
+	level	   =  pgtable.mode - 1;
+	pte	   = &pgtable.root[PM_LEVEL_INDEX(level, address)];
 	*page_size =  PTE_LEVEL_PAGE_SIZE(level);
 
 	while (level > 0) {
@@ -1806,6 +1844,7 @@ static void dma_ops_domain_free(struct protection_domain *domain)
 static struct protection_domain *dma_ops_domain_alloc(void)
 {
 	struct protection_domain *domain;
+	u64 *pt_root, root;
 
 	domain = kzalloc(sizeof(struct protection_domain), GFP_KERNEL);
 	if (!domain)
@@ -1814,12 +1853,14 @@ static struct protection_domain *dma_ops_domain_alloc(void)
 	if (protection_domain_init(domain))
 		goto free_domain;
 
-	domain->mode = PAGE_MODE_3_LEVEL;
-	domain->pt_root = (void *)get_zeroed_page(GFP_KERNEL);
-	domain->flags = PD_DMA_OPS_MASK;
-	if (!domain->pt_root)
+	pt_root = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!pt_root)
 		goto free_domain;
 
+	root = amd_iommu_domain_encode_pgtable(pt_root, PAGE_MODE_3_LEVEL);
+	atomic64_set(&domain->pt_root, root);
+	domain->flags = PD_DMA_OPS_MASK;
+
 	if (iommu_get_dma_cookie(&domain->domain) == -ENOMEM)
 		goto free_domain;
 
@@ -1843,14 +1884,17 @@ static bool dma_ops_domain(struct protection_domain *domain)
 static void set_dte_entry(u16 devid, struct protection_domain *domain,
 			  bool ats, bool ppr)
 {
+	struct domain_pgtable pgtable;
 	u64 pte_root = 0;
 	u64 flags = 0;
 	u32 old_domid;
 
-	if (domain->mode != PAGE_MODE_NONE)
-		pte_root = iommu_virt_to_phys(domain->pt_root);
+	amd_iommu_domain_get_pgtable(domain, &pgtable);
+
+	if (pgtable.mode != PAGE_MODE_NONE)
+		pte_root = iommu_virt_to_phys(pgtable.root);
 
-	pte_root |= (domain->mode & DEV_ENTRY_MODE_MASK)
+	pte_root |= (pgtable.mode & DEV_ENTRY_MODE_MASK)
 		    << DEV_ENTRY_MODE_SHIFT;
 	pte_root |= DTE_FLAG_IR | DTE_FLAG_IW | DTE_FLAG_V | DTE_FLAG_TV;
 
@@ -2375,6 +2419,7 @@ static struct protection_domain *protection_domain_alloc(void)
 static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
 {
 	struct protection_domain *pdomain;
+	u64 *pt_root, root;
 
 	switch (type) {
 	case IOMMU_DOMAIN_UNMANAGED:
@@ -2382,13 +2427,15 @@ static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
 		if (!pdomain)
 			return NULL;
 
-		pdomain->mode    = PAGE_MODE_3_LEVEL;
-		pdomain->pt_root = (void *)get_zeroed_page(GFP_KERNEL);
-		if (!pdomain->pt_root) {
+		pt_root = (void *)get_zeroed_page(GFP_KERNEL);
+		if (!pt_root) {
 			protection_domain_free(pdomain);
 			return NULL;
 		}
 
+		root = amd_iommu_domain_encode_pgtable(pt_root, PAGE_MODE_3_LEVEL);
+		atomic64_set(&pdomain->pt_root, root);
+
 		pdomain->domain.geometry.aperture_start = 0;
 		pdomain->domain.geometry.aperture_end   = ~0ULL;
 		pdomain->domain.geometry.force_aperture = true;
@@ -2406,7 +2453,7 @@ static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
 		if (!pdomain)
 			return NULL;
 
-		pdomain->mode = PAGE_MODE_NONE;
+		atomic64_set(&pdomain->pt_root, PAGE_MODE_NONE);
 		break;
 	default:
 		return NULL;
@@ -2418,6 +2465,7 @@ static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
 static void amd_iommu_domain_free(struct iommu_domain *dom)
 {
 	struct protection_domain *domain;
+	struct domain_pgtable pgtable;
 
 	domain = to_pdomain(dom);
 
@@ -2435,7 +2483,9 @@ static void amd_iommu_domain_free(struct iommu_domain *dom)
 		dma_ops_domain_free(domain);
 		break;
 	default:
-		if (domain->mode != PAGE_MODE_NONE)
+		amd_iommu_domain_get_pgtable(domain, &pgtable);
+
+		if (pgtable.mode != PAGE_MODE_NONE)
 			free_pagetable(domain);
 
 		if (domain->flags & PD_IOMMUV2_MASK)
@@ -2518,10 +2568,12 @@ static int amd_iommu_map(struct iommu_domain *dom, unsigned long iova,
 			 gfp_t gfp)
 {
 	struct protection_domain *domain = to_pdomain(dom);
+	struct domain_pgtable pgtable;
 	int prot = 0;
 	int ret;
 
-	if (domain->mode == PAGE_MODE_NONE)
+	amd_iommu_domain_get_pgtable(domain, &pgtable);
+	if (pgtable.mode == PAGE_MODE_NONE)
 		return -EINVAL;
 
 	if (iommu_prot & IOMMU_READ)
@@ -2541,8 +2593,10 @@ static size_t amd_iommu_unmap(struct iommu_domain *dom, unsigned long iova,
 			      struct iommu_iotlb_gather *gather)
 {
 	struct protection_domain *domain = to_pdomain(dom);
+	struct domain_pgtable pgtable;
 
-	if (domain->mode == PAGE_MODE_NONE)
+	amd_iommu_domain_get_pgtable(domain, &pgtable);
+	if (pgtable.mode == PAGE_MODE_NONE)
 		return 0;
 
 	return iommu_unmap_page(domain, iova, page_size);
@@ -2553,9 +2607,11 @@ static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 {
 	struct protection_domain *domain = to_pdomain(dom);
 	unsigned long offset_mask, pte_pgsize;
+	struct domain_pgtable pgtable;
 	u64 *pte, __pte;
 
-	if (domain->mode == PAGE_MODE_NONE)
+	amd_iommu_domain_get_pgtable(domain, &pgtable);
+	if (pgtable.mode == PAGE_MODE_NONE)
 		return iova;
 
 	pte = fetch_pte(domain, iova, &pte_pgsize);
@@ -2708,16 +2764,26 @@ EXPORT_SYMBOL(amd_iommu_unregister_ppr_notifier);
 void amd_iommu_domain_direct_map(struct iommu_domain *dom)
 {
 	struct protection_domain *domain = to_pdomain(dom);
+	struct domain_pgtable pgtable;
 	unsigned long flags;
+	u64 pt_root;
 
 	spin_lock_irqsave(&domain->lock, flags);
 
+	/* First save pgtable configuration*/
+	amd_iommu_domain_get_pgtable(domain, &pgtable);
+
 	/* Update data structure */
-	domain->mode    = PAGE_MODE_NONE;
+	pt_root = amd_iommu_domain_encode_pgtable(NULL, PAGE_MODE_NONE);
+	atomic64_set(&domain->pt_root, pt_root);
 
 	/* Make changes visible to IOMMUs */
 	update_domain(domain);
 
+	/* Restore old pgtable in domain->ptroot to free page-table */
+	pt_root = amd_iommu_domain_encode_pgtable(pgtable.root, pgtable.mode);
+	atomic64_set(&domain->pt_root, pt_root);
+
 	/* Page-table is not visible to IOMMU anymore, so free it */
 	free_pagetable(domain);
 
@@ -2908,9 +2974,11 @@ static u64 *__get_gcr3_pte(u64 *root, int level, int pasid, bool alloc)
 static int __set_gcr3(struct protection_domain *domain, int pasid,
 		      unsigned long cr3)
 {
+	struct domain_pgtable pgtable;
 	u64 *pte;
 
-	if (domain->mode != PAGE_MODE_NONE)
+	amd_iommu_domain_get_pgtable(domain, &pgtable);
+	if (pgtable.mode != PAGE_MODE_NONE)
 		return -EINVAL;
 
 	pte = __get_gcr3_pte(domain->gcr3_tbl, domain->glx, pasid, true);
@@ -2924,9 +2992,11 @@ static int __set_gcr3(struct protection_domain *domain, int pasid,
 
 static int __clear_gcr3(struct protection_domain *domain, int pasid)
 {
+	struct domain_pgtable pgtable;
 	u64 *pte;
 
-	if (domain->mode != PAGE_MODE_NONE)
+	amd_iommu_domain_get_pgtable(domain, &pgtable);
+	if (pgtable.mode != PAGE_MODE_NONE)
 		return -EINVAL;
 
 	pte = __get_gcr3_pte(domain->gcr3_tbl, domain->glx, pasid, false);
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index ca8c4522045b3..7a8fdec138bd1 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -468,8 +468,7 @@ struct protection_domain {
 				       iommu core code */
 	spinlock_t lock;	/* mostly used to lock the page table*/
 	u16 id;			/* the domain id written to the device table */
-	int mode;		/* paging mode (0-6 levels) */
-	u64 *pt_root;		/* page table root pointer */
+	atomic64_t pt_root;	/* pgtable root and pgtable mode */
 	int glx;		/* Number of levels for GCR3 table */
 	u64 *gcr3_tbl;		/* Guest CR3 table */
 	unsigned long flags;	/* flags to find out type of domain */
@@ -477,6 +476,12 @@ struct protection_domain {
 	unsigned dev_iommu[MAX_IOMMUS]; /* per-IOMMU reference count */
 };
 
+/* For decocded pt_root */
+struct domain_pgtable {
+	int mode;
+	u64 *root;
+};
+
 /*
  * Structure where we save information about one hardware AMD IOMMU in the
  * system.
-- 
2.20.1



