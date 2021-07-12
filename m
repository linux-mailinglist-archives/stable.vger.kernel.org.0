Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D403C4B0E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239624AbhGLGz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241411AbhGLGzB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:55:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89F7660233;
        Mon, 12 Jul 2021 06:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072733;
        bh=+y2FYAQDGWMOnGr6OWX7nbIYxbvWgNq8PmZJg5fExgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VL/jV3i5DyH7ZK8GOmSfEzomd96FV5nsqnd0eMLEUW1iBAGX03dy63KqAqYcjtiF/
         D2rtYOmN9C+Z/JSuoz6NGvud4lsW2ZTnG1nbknOU8H/B1xQkZ/DmPrI9MAmyl1QN7P
         eLWaEvs/2jPBclTIqmvvDcjVIHxUzazISymDI48g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ralph Campbell <rcampbell@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 570/593] include/linux/huge_mm.h: remove extern keyword
Date:   Mon, 12 Jul 2021 08:12:10 +0200
Message-Id: <20210712060957.628614519@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>

[ Upstream commit ebfe1b8f6ea5d83d8c1aa18ddd8ede432a7414e7 ]

The external function definitions don't need the "extern" keyword.  Remove
them so future changes don't copy the function definition style.

Link: https://lkml.kernel.org/r/20201106235135.32109-1-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/huge_mm.h | 93 ++++++++++++++++++-----------------------
 1 file changed, 41 insertions(+), 52 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 42dc994c8897..e72787731a5b 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -7,43 +7,37 @@
 
 #include <linux/fs.h> /* only for vma_is_dax() */
 
-extern vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
-extern int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-			 pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
-			 struct vm_area_struct *vma);
-extern void huge_pmd_set_accessed(struct vm_fault *vmf, pmd_t orig_pmd);
-extern int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-			 pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
-			 struct vm_area_struct *vma);
+vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
+int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
+		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
+		  struct vm_area_struct *vma);
+void huge_pmd_set_accessed(struct vm_fault *vmf, pmd_t orig_pmd);
+int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
+		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
+		  struct vm_area_struct *vma);
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-extern void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud);
+void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud);
 #else
 static inline void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud)
 {
 }
 #endif
 
-extern vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd);
-extern struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
-					  unsigned long addr,
-					  pmd_t *pmd,
-					  unsigned int flags);
-extern bool madvise_free_huge_pmd(struct mmu_gather *tlb,
-			struct vm_area_struct *vma,
-			pmd_t *pmd, unsigned long addr, unsigned long next);
-extern int zap_huge_pmd(struct mmu_gather *tlb,
-			struct vm_area_struct *vma,
-			pmd_t *pmd, unsigned long addr);
-extern int zap_huge_pud(struct mmu_gather *tlb,
-			struct vm_area_struct *vma,
-			pud_t *pud, unsigned long addr);
-extern bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
-			 unsigned long new_addr,
-			 pmd_t *old_pmd, pmd_t *new_pmd);
-extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-			unsigned long addr, pgprot_t newprot,
-			unsigned long cp_flags);
+vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd);
+struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
+				   unsigned long addr, pmd_t *pmd,
+				   unsigned int flags);
+bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
+			   pmd_t *pmd, unsigned long addr, unsigned long next);
+int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma, pmd_t *pmd,
+		 unsigned long addr);
+int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma, pud_t *pud,
+		 unsigned long addr);
+bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
+		   unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd);
+int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
+		    pgprot_t newprot, unsigned long cp_flags);
 vm_fault_t vmf_insert_pfn_pmd_prot(struct vm_fault *vmf, pfn_t pfn,
 				   pgprot_t pgprot, bool write);
 
@@ -101,13 +95,13 @@ enum transparent_hugepage_flag {
 struct kobject;
 struct kobj_attribute;
 
-extern ssize_t single_hugepage_flag_store(struct kobject *kobj,
-				 struct kobj_attribute *attr,
-				 const char *buf, size_t count,
-				 enum transparent_hugepage_flag flag);
-extern ssize_t single_hugepage_flag_show(struct kobject *kobj,
-				struct kobj_attribute *attr, char *buf,
-				enum transparent_hugepage_flag flag);
+ssize_t single_hugepage_flag_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t count,
+				   enum transparent_hugepage_flag flag);
+ssize_t single_hugepage_flag_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf,
+				  enum transparent_hugepage_flag flag);
 extern struct kobj_attribute shmem_enabled_attr;
 
 #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
@@ -187,12 +181,11 @@ bool transparent_hugepage_active(struct vm_area_struct *vma);
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
 
-extern unsigned long thp_get_unmapped_area(struct file *filp,
-		unsigned long addr, unsigned long len, unsigned long pgoff,
-		unsigned long flags);
+unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags);
 
-extern void prep_transhuge_page(struct page *page);
-extern void free_transhuge_page(struct page *page);
+void prep_transhuge_page(struct page *page);
+void free_transhuge_page(struct page *page);
 bool is_transparent_hugepage(struct page *page);
 
 bool can_split_huge_page(struct page *page, int *pextra_pins);
@@ -230,16 +223,12 @@ void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
 			__split_huge_pud(__vma, __pud, __address);	\
 	}  while (0)
 
-extern int hugepage_madvise(struct vm_area_struct *vma,
-			    unsigned long *vm_flags, int advice);
-extern void vma_adjust_trans_huge(struct vm_area_struct *vma,
-				    unsigned long start,
-				    unsigned long end,
-				    long adjust_next);
-extern spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd,
-		struct vm_area_struct *vma);
-extern spinlock_t *__pud_trans_huge_lock(pud_t *pud,
-		struct vm_area_struct *vma);
+int hugepage_madvise(struct vm_area_struct *vma, unsigned long *vm_flags,
+		     int advice);
+void vma_adjust_trans_huge(struct vm_area_struct *vma, unsigned long start,
+			   unsigned long end, long adjust_next);
+spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma);
+spinlock_t *__pud_trans_huge_lock(pud_t *pud, struct vm_area_struct *vma);
 
 static inline int is_swap_pmd(pmd_t pmd)
 {
@@ -302,7 +291,7 @@ struct page *follow_devmap_pmd(struct vm_area_struct *vma, unsigned long addr,
 struct page *follow_devmap_pud(struct vm_area_struct *vma, unsigned long addr,
 		pud_t *pud, int flags, struct dev_pagemap **pgmap);
 
-extern vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t orig_pmd);
+vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t orig_pmd);
 
 extern struct page *huge_zero_page;
 extern unsigned long huge_zero_pfn;
-- 
2.30.2



