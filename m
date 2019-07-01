Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1CBD23638
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388562AbfETM20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388572AbfETM2X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:28:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF8D121479;
        Mon, 20 May 2019 12:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355302;
        bh=bQv7F9YwS8Lh58Waq8ZarXfL6yR0PW/lwWaK3k7llTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7Sa32/ztAzuGRA9dl9bEj3R+4uUNukuTBBQulaIvCdRw2RId1hp27prK/B+5kDN8
         aR772byb0PPtGnSJMnw+Vd0YF/p3AhI6zbCRcMjfUdR4GPrGFwFZ0g0QdMNROCqWeN
         MLm3wbOkkWeq1QvKOGd5lnVJTtMhFkh95qTh0mDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Piotr Balcer <piotr.balcer@intel.com>,
        Yan Ma <yan.ma@intel.com>, Pankaj Gupta <pagupta@redhat.com>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Chandan Rajendra <chandan@linux.ibm.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.0 068/123] mm/huge_memory: fix vmf_insert_pfn_{pmd, pud}() crash, handle unaligned addresses
Date:   Mon, 20 May 2019 14:14:08 +0200
Message-Id: <20190520115249.355194880@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit fce86ff5802bac3a7b19db171aa1949ef9caac31 upstream.

Starting with c6f3c5ee40c1 ("mm/huge_memory.c: fix modifying of page
protection by insert_pfn_pmd()") vmf_insert_pfn_pmd() internally calls
pmdp_set_access_flags().  That helper enforces a pmd aligned @address
argument via VM_BUG_ON() assertion.

Update the implementation to take a 'struct vm_fault' argument directly
and apply the address alignment fixup internally to fix crash signatures
like:

    kernel BUG at arch/x86/mm/pgtable.c:515!
    invalid opcode: 0000 [#1] SMP NOPTI
    CPU: 51 PID: 43713 Comm: java Tainted: G           OE     4.19.35 #1
    [..]
    RIP: 0010:pmdp_set_access_flags+0x48/0x50
    [..]
    Call Trace:
     vmf_insert_pfn_pmd+0x198/0x350
     dax_iomap_fault+0xe82/0x1190
     ext4_dax_huge_fault+0x103/0x1f0
     ? __switch_to_asm+0x40/0x70
     __handle_mm_fault+0x3f6/0x1370
     ? __switch_to_asm+0x34/0x70
     ? __switch_to_asm+0x40/0x70
     handle_mm_fault+0xda/0x200
     __do_page_fault+0x249/0x4f0
     do_page_fault+0x32/0x110
     ? page_fault+0x8/0x30
     page_fault+0x1e/0x30

Link: http://lkml.kernel.org/r/155741946350.372037.11148198430068238140.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: c6f3c5ee40c1 ("mm/huge_memory.c: fix modifying of page protection by insert_pfn_pmd()")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Piotr Balcer <piotr.balcer@intel.com>
Tested-by: Yan Ma <yan.ma@intel.com>
Tested-by: Pankaj Gupta <pagupta@redhat.com>
Reviewed-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Chandan Rajendra <chandan@linux.ibm.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dax/device.c    |    6 ++----
 fs/dax.c                |    6 ++----
 include/linux/huge_mm.h |    6 ++----
 mm/huge_memory.c        |   16 ++++++++++------
 4 files changed, 16 insertions(+), 18 deletions(-)

--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -325,8 +325,7 @@ static vm_fault_t __dev_dax_pmd_fault(st
 
 	*pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
 
-	return vmf_insert_pfn_pmd(vmf->vma, vmf->address, vmf->pmd, *pfn,
-			vmf->flags & FAULT_FLAG_WRITE);
+	return vmf_insert_pfn_pmd(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
@@ -376,8 +375,7 @@ static vm_fault_t __dev_dax_pud_fault(st
 
 	*pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
 
-	return vmf_insert_pfn_pud(vmf->vma, vmf->address, vmf->pud, *pfn,
-			vmf->flags & FAULT_FLAG_WRITE);
+	return vmf_insert_pfn_pud(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
 #else
 static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1577,8 +1577,7 @@ static vm_fault_t dax_iomap_pmd_fault(st
 		}
 
 		trace_dax_pmd_insert_mapping(inode, vmf, PMD_SIZE, pfn, entry);
-		result = vmf_insert_pfn_pmd(vma, vmf->address, vmf->pmd, pfn,
-					    write);
+		result = vmf_insert_pfn_pmd(vmf, pfn, write);
 		break;
 	case IOMAP_UNWRITTEN:
 	case IOMAP_HOLE:
@@ -1688,8 +1687,7 @@ dax_insert_pfn_mkwrite(struct vm_fault *
 		ret = vmf_insert_mixed_mkwrite(vmf->vma, vmf->address, pfn);
 #ifdef CONFIG_FS_DAX_PMD
 	else if (order == PMD_ORDER)
-		ret = vmf_insert_pfn_pmd(vmf->vma, vmf->address, vmf->pmd,
-			pfn, true);
+		ret = vmf_insert_pfn_pmd(vmf, pfn, FAULT_FLAG_WRITE);
 #endif
 	else
 		ret = VM_FAULT_FALLBACK;
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -47,10 +47,8 @@ extern bool move_huge_pmd(struct vm_area
 extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			unsigned long addr, pgprot_t newprot,
 			int prot_numa);
-vm_fault_t vmf_insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
-			pmd_t *pmd, pfn_t pfn, bool write);
-vm_fault_t vmf_insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
-			pud_t *pud, pfn_t pfn, bool write);
+vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write);
+vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write);
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -791,11 +791,13 @@ out_unlock:
 		pte_free(mm, pgtable);
 }
 
-vm_fault_t vmf_insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
-			pmd_t *pmd, pfn_t pfn, bool write)
+vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write)
 {
+	unsigned long addr = vmf->address & PMD_MASK;
+	struct vm_area_struct *vma = vmf->vma;
 	pgprot_t pgprot = vma->vm_page_prot;
 	pgtable_t pgtable = NULL;
+
 	/*
 	 * If we had pmd_special, we could avoid all these restrictions,
 	 * but we need to be consistent with PTEs and architectures that
@@ -818,7 +820,7 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_
 
 	track_pfn_insert(vma, &pgprot, pfn);
 
-	insert_pfn_pmd(vma, addr, pmd, pfn, pgprot, write, pgtable);
+	insert_pfn_pmd(vma, addr, vmf->pmd, pfn, pgprot, write, pgtable);
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(vmf_insert_pfn_pmd);
@@ -867,10 +869,12 @@ out_unlock:
 	spin_unlock(ptl);
 }
 
-vm_fault_t vmf_insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
-			pud_t *pud, pfn_t pfn, bool write)
+vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write)
 {
+	unsigned long addr = vmf->address & PUD_MASK;
+	struct vm_area_struct *vma = vmf->vma;
 	pgprot_t pgprot = vma->vm_page_prot;
+
 	/*
 	 * If we had pud_special, we could avoid all these restrictions,
 	 * but we need to be consistent with PTEs and architectures that
@@ -887,7 +891,7 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_
 
 	track_pfn_insert(vma, &pgprot, pfn);
 
-	insert_pfn_pud(vma, addr, pud, pfn, pgprot, write);
+	insert_pfn_pud(vma, addr, vmf->pud, pfn, pgprot, write);
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(vmf_insert_pfn_pud);


