Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5975B324D4F
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 10:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbhBYJ4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 04:56:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235491AbhBYJyl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:54:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0DDF64EF1;
        Thu, 25 Feb 2021 09:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246840;
        bh=Ri6tlHL/gZt+eZ+uo+mtnGkZXF6hBMSb8DcDLYgpHXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iSPa5Zon41Vt0WWmbCxogsMyfESJuUCDy5+qiYaScykjpYEe/uld6gFkitsb55wL6
         tHA7HflPKlVSoyH+bINqyHWw4JY/XBzwLEA9Hb/yPAGIlOIlqQQfdWRI/Aa3QUbnCk
         1U8bGuqZ4AP85Xa7100Kk/32PTHle46xSWy9HlR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 11/12] mm: provide a saner PTE walking API for modules
Date:   Thu, 25 Feb 2021 10:53:45 +0100
Message-Id: <20210225092515.526437922@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092515.015261674@linuxfoundation.org>
References: <20210225092515.015261674@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 9fd6dad1261a541b3f5fa7dc5b152222306e6702 upstream.

Currently, the follow_pfn function is exported for modules but
follow_pte is not.  However, follow_pfn is very easy to misuse,
because it does not provide protections (so most of its callers
assume the page is writable!) and because it returns after having
already unlocked the page table lock.

Provide instead a simplified version of follow_pte that does
not have the pmdpp and range arguments.  The older version
survives as follow_invalidate_pte() for use by fs/dax.c.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_mmio.c |    4 ++--
 fs/dax.c                 |    5 +++--
 include/linux/mm.h       |    6 ++++--
 mm/memory.c              |   41 ++++++++++++++++++++++++++++++++++++-----
 virt/kvm/kvm_main.c      |    4 ++--
 5 files changed, 47 insertions(+), 13 deletions(-)

--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -170,7 +170,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, uns
 	if (!(vma->vm_flags & VM_WRITE))
 		goto out_unlock_mmap;
 
-	ret = follow_pte(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
+	ret = follow_pte(vma->vm_mm, mmio_addr, &ptep, &ptl);
 	if (ret)
 		goto out_unlock_mmap;
 
@@ -311,7 +311,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsi
 	if (!(vma->vm_flags & VM_WRITE))
 		goto out_unlock_mmap;
 
-	ret = follow_pte(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
+	ret = follow_pte(vma->vm_mm, mmio_addr, &ptep, &ptl);
 	if (ret)
 		goto out_unlock_mmap;
 
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -810,11 +810,12 @@ static void dax_entry_mkclean(struct add
 		address = pgoff_address(index, vma);
 
 		/*
-		 * Note because we provide range to follow_pte it will call
+		 * follow_invalidate_pte() will use the range to call
 		 * mmu_notifier_invalidate_range_start() on our behalf before
 		 * taking any lock.
 		 */
-		if (follow_pte(vma->vm_mm, address, &range, &ptep, &pmdp, &ptl))
+		if (follow_invalidate_pte(vma->vm_mm, address, &range, &ptep,
+					  &pmdp, &ptl))
 			continue;
 
 		/*
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1658,9 +1658,11 @@ void free_pgd_range(struct mmu_gather *t
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
+int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
+			  struct mmu_notifier_range *range, pte_t **ptepp,
+			  pmd_t **pmdpp, spinlock_t **ptlp);
 int follow_pte(struct mm_struct *mm, unsigned long address,
-		struct mmu_notifier_range *range, pte_t **ptepp, pmd_t **pmdpp,
-		spinlock_t **ptlp);
+	       pte_t **ptepp, spinlock_t **ptlp);
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
 	unsigned long *pfn);
 int follow_phys(struct vm_area_struct *vma, unsigned long address,
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4709,9 +4709,9 @@ int __pmd_alloc(struct mm_struct *mm, pu
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-int follow_pte(struct mm_struct *mm, unsigned long address,
-	       struct mmu_notifier_range *range, pte_t **ptepp, pmd_t **pmdpp,
-	       spinlock_t **ptlp)
+int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
+			  struct mmu_notifier_range *range, pte_t **ptepp,
+			  pmd_t **pmdpp, spinlock_t **ptlp)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -4777,6 +4777,34 @@ out:
 }
 
 /**
+ * follow_pte - look up PTE at a user virtual address
+ * @mm: the mm_struct of the target address space
+ * @address: user virtual address
+ * @ptepp: location to store found PTE
+ * @ptlp: location to store the lock for the PTE
+ *
+ * On a successful return, the pointer to the PTE is stored in @ptepp;
+ * the corresponding lock is taken and its location is stored in @ptlp.
+ * The contents of the PTE are only stable until @ptlp is released;
+ * any further use, if any, must be protected against invalidation
+ * with MMU notifiers.
+ *
+ * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphore
+ * should be taken for read.
+ *
+ * KVM uses this function.  While it is arguably less bad than ``follow_pfn``,
+ * it is not a good general-purpose API.
+ *
+ * Return: zero on success, -ve otherwise.
+ */
+int follow_pte(struct mm_struct *mm, unsigned long address,
+	       pte_t **ptepp, spinlock_t **ptlp)
+{
+	return follow_invalidate_pte(mm, address, NULL, ptepp, NULL, ptlp);
+}
+EXPORT_SYMBOL_GPL(follow_pte);
+
+/**
  * follow_pfn - look up PFN at a user virtual address
  * @vma: memory mapping
  * @address: user virtual address
@@ -4784,6 +4812,9 @@ out:
  *
  * Only IO mappings and raw PFN mappings are allowed.
  *
+ * This function does not allow the caller to read the permissions
+ * of the PTE.  Do not use it.
+ *
  * Return: zero and the pfn at @pfn on success, -ve otherwise.
  */
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
@@ -4796,7 +4827,7 @@ int follow_pfn(struct vm_area_struct *vm
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		return ret;
 
-	ret = follow_pte(vma->vm_mm, address, NULL, &ptep, NULL, &ptl);
+	ret = follow_pte(vma->vm_mm, address, &ptep, &ptl);
 	if (ret)
 		return ret;
 	*pfn = pte_pfn(*ptep);
@@ -4817,7 +4848,7 @@ int follow_phys(struct vm_area_struct *v
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		goto out;
 
-	if (follow_pte(vma->vm_mm, address, NULL, &ptep, NULL, &ptl))
+	if (follow_pte(vma->vm_mm, address, &ptep, &ptl))
 		goto out;
 	pte = *ptep;
 
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1908,7 +1908,7 @@ static int hva_to_pfn_remapped(struct vm
 	spinlock_t *ptl;
 	int r;
 
-	r = follow_pte(vma->vm_mm, addr, NULL, &ptep, NULL, &ptl);
+	r = follow_pte(vma->vm_mm, addr, &ptep, &ptl);
 	if (r) {
 		/*
 		 * get_user_pages fails for VM_IO and VM_PFNMAP vmas and does
@@ -1923,7 +1923,7 @@ static int hva_to_pfn_remapped(struct vm
 		if (r)
 			return r;
 
-		r = follow_pte(vma->vm_mm, addr, NULL, &ptep, NULL, &ptl);
+		r = follow_pte(vma->vm_mm, addr, &ptep, &ptl);
 		if (r)
 			return r;
 	}


