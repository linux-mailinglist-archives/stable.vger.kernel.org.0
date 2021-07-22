Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC433D29EF
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbhGVQHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234228AbhGVQG0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:06:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 180A361D0B;
        Thu, 22 Jul 2021 16:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972420;
        bh=iNsa5GPkjseL65jVrvtwbz+ADwfdaB+HZflh5PY1AFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lc4t6rJ7wdfAycvNUD317R30y6O5+4GQW80O2QOvzEf1NffQducgrW75TjxBgmoO4
         sb+R0kS68daozCCjovLpLr6qDgXl3t2A96K2gu1U1eRBYk/2nJqhQDyWBWKTYEYvmn
         U4Ax9WelTi2miwqMNHx+r+UkeG0dWZHEH1p+egV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Brian Geffon <bgeffon@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Hugh Dickins <hughd@google.com>, Joe Perches <joe@perches.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Lokesh Gidra <lokeshgidra@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mina Almasry <almasrymina@google.com>,
        Oliver Upton <oupton@google.com>, Shaohua Li <shli@fb.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Wang Qing <wangqing@vivo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.13 106/156] mm/userfaultfd: fix uffd-wp special cases for fork()
Date:   Thu, 22 Jul 2021 18:31:21 +0200
Message-Id: <20210722155631.798626003@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit 8f34f1eac3820fc2722e5159acceb22545b30b0d upstream.

We tried to do something similar in b569a1760782 ("userfaultfd: wp: drop
_PAGE_UFFD_WP properly when fork") previously, but it's not doing it all
right..  A few fixes around the code path:

1. We were referencing VM_UFFD_WP vm_flags on the _old_ vma rather
   than the new vma.  That's overlooked in b569a1760782, so it won't work
   as expected.  Thanks to the recent rework on fork code
   (7a4830c380f3a8b3), we can easily get the new vma now, so switch the
   checks to that.

2. Dropping the uffd-wp bit in copy_huge_pmd() could be wrong if the
   huge pmd is a migration huge pmd.  When it happens, instead of using
   pmd_uffd_wp(), we should use pmd_swp_uffd_wp().  The fix is simply to
   handle them separately.

3. Forget to carry over uffd-wp bit for a write migration huge pmd
   entry.  This also happens in copy_huge_pmd(), where we converted a
   write huge migration entry into a read one.

4. In copy_nonpresent_pte(), drop uffd-wp if necessary for swap ptes.

5. In copy_present_page() when COW is enforced when fork(), we also
   need to pass over the uffd-wp bit if VM_UFFD_WP is armed on the new
   vma, and when the pte to be copied has uffd-wp bit set.

Remove the comment in copy_present_pte() about this.  It won't help a huge
lot to only comment there, but comment everywhere would be an overkill.
Let's assume the commit messages would help.

[peterx@redhat.com: fix a few thp pmd missing uffd-wp bit]
  Link: https://lkml.kernel.org/r/20210428225030.9708-4-peterx@redhat.com

Link: https://lkml.kernel.org/r/20210428225030.9708-3-peterx@redhat.com
Fixes: b569a1760782f ("userfaultfd: wp: drop _PAGE_UFFD_WP properly when fork")
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/huge_mm.h |    2 +-
 include/linux/swapops.h |    2 ++
 mm/huge_memory.c        |   27 ++++++++++++++-------------
 mm/memory.c             |   25 +++++++++++++------------
 4 files changed, 30 insertions(+), 26 deletions(-)

--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -10,7 +10,7 @@
 vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
-		  struct vm_area_struct *vma);
+		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
 void huge_pmd_set_accessed(struct vm_fault *vmf, pmd_t orig_pmd);
 int copy_huge_pud(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pud_t *dst_pud, pud_t *src_pud, unsigned long addr,
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -265,6 +265,8 @@ static inline swp_entry_t pmd_to_swp_ent
 
 	if (pmd_swp_soft_dirty(pmd))
 		pmd = pmd_swp_clear_soft_dirty(pmd);
+	if (pmd_swp_uffd_wp(pmd))
+		pmd = pmd_swp_clear_uffd_wp(pmd);
 	arch_entry = __pmd_to_swp_entry(pmd);
 	return swp_entry(__swp_type(arch_entry), __swp_offset(arch_entry));
 }
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1026,7 +1026,7 @@ struct page *follow_devmap_pmd(struct vm
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
-		  struct vm_area_struct *vma)
+		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
 	spinlock_t *dst_ptl, *src_ptl;
 	struct page *src_page;
@@ -1035,7 +1035,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 	int ret = -ENOMEM;
 
 	/* Skip if can be re-fill on fault */
-	if (!vma_is_anonymous(vma))
+	if (!vma_is_anonymous(dst_vma))
 		return 0;
 
 	pgtable = pte_alloc_one(dst_mm);
@@ -1049,14 +1049,6 @@ int copy_huge_pmd(struct mm_struct *dst_
 	ret = -EAGAIN;
 	pmd = *src_pmd;
 
-	/*
-	 * Make sure the _PAGE_UFFD_WP bit is cleared if the new VMA
-	 * does not have the VM_UFFD_WP, which means that the uffd
-	 * fork event is not enabled.
-	 */
-	if (!(vma->vm_flags & VM_UFFD_WP))
-		pmd = pmd_clear_uffd_wp(pmd);
-
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 	if (unlikely(is_swap_pmd(pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(pmd);
@@ -1067,11 +1059,15 @@ int copy_huge_pmd(struct mm_struct *dst_
 			pmd = swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*src_pmd))
 				pmd = pmd_swp_mksoft_dirty(pmd);
+			if (pmd_swp_uffd_wp(*src_pmd))
+				pmd = pmd_swp_mkuffd_wp(pmd);
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
 		}
 		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm_inc_nr_ptes(dst_mm);
 		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+		if (!userfaultfd_wp(dst_vma))
+			pmd = pmd_swp_clear_uffd_wp(pmd);
 		set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 		ret = 0;
 		goto out_unlock;
@@ -1107,11 +1103,11 @@ int copy_huge_pmd(struct mm_struct *dst_
 	 * best effort that the pinned pages won't be replaced by another
 	 * random page during the coming copy-on-write.
 	 */
-	if (unlikely(page_needs_cow_for_dma(vma, src_page))) {
+	if (unlikely(page_needs_cow_for_dma(src_vma, src_page))) {
 		pte_free(dst_mm, pgtable);
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
-		__split_huge_pmd(vma, src_pmd, addr, false, NULL);
+		__split_huge_pmd(src_vma, src_pmd, addr, false, NULL);
 		return -EAGAIN;
 	}
 
@@ -1121,8 +1117,9 @@ int copy_huge_pmd(struct mm_struct *dst_
 out_zero_page:
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
-
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
+	if (!userfaultfd_wp(dst_vma))
+		pmd = pmd_clear_uffd_wp(pmd);
 	pmd = pmd_mkold(pmd_wrprotect(pmd));
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 
@@ -1838,6 +1835,8 @@ int change_huge_pmd(struct vm_area_struc
 			newpmd = swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*pmd))
 				newpmd = pmd_swp_mksoft_dirty(newpmd);
+			if (pmd_swp_uffd_wp(*pmd))
+				newpmd = pmd_swp_mkuffd_wp(newpmd);
 			set_pmd_at(mm, addr, pmd, newpmd);
 		}
 		goto unlock;
@@ -3248,6 +3247,8 @@ void remove_migration_pmd(struct page_vm
 		pmde = pmd_mksoft_dirty(pmde);
 	if (is_write_migration_entry(entry))
 		pmde = maybe_pmd_mkwrite(pmde, vma);
+	if (pmd_swp_uffd_wp(*pvmw->pmd))
+		pmde = pmd_wrprotect(pmd_mkuffd_wp(pmde));
 
 	flush_cache_range(vma, mmun_start, mmun_start + HPAGE_PMD_SIZE);
 	if (PageAnon(new))
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -708,10 +708,10 @@ out:
 
 static unsigned long
 copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
-		pte_t *dst_pte, pte_t *src_pte, struct vm_area_struct *vma,
-		unsigned long addr, int *rss)
+		pte_t *dst_pte, pte_t *src_pte, struct vm_area_struct *dst_vma,
+		struct vm_area_struct *src_vma, unsigned long addr, int *rss)
 {
-	unsigned long vm_flags = vma->vm_flags;
+	unsigned long vm_flags = dst_vma->vm_flags;
 	pte_t pte = *src_pte;
 	struct page *page;
 	swp_entry_t entry = pte_to_swp_entry(pte);
@@ -780,6 +780,8 @@ copy_nonpresent_pte(struct mm_struct *ds
 			set_pte_at(src_mm, addr, src_pte, pte);
 		}
 	}
+	if (!userfaultfd_wp(dst_vma))
+		pte = pte_swp_clear_uffd_wp(pte);
 	set_pte_at(dst_mm, addr, dst_pte, pte);
 	return 0;
 }
@@ -845,6 +847,9 @@ copy_present_page(struct vm_area_struct
 	/* All done, just insert the new page copy in the child */
 	pte = mk_pte(new_page, dst_vma->vm_page_prot);
 	pte = maybe_mkwrite(pte_mkdirty(pte), dst_vma);
+	if (userfaultfd_pte_wp(dst_vma, *src_pte))
+		/* Uffd-wp needs to be delivered to dest pte as well */
+		pte = pte_wrprotect(pte_mkuffd_wp(pte));
 	set_pte_at(dst_vma->vm_mm, addr, dst_pte, pte);
 	return 0;
 }
@@ -894,12 +899,7 @@ copy_present_pte(struct vm_area_struct *
 		pte = pte_mkclean(pte);
 	pte = pte_mkold(pte);
 
-	/*
-	 * Make sure the _PAGE_UFFD_WP bit is cleared if the new VMA
-	 * does not have the VM_UFFD_WP, which means that the uffd
-	 * fork event is not enabled.
-	 */
-	if (!(vm_flags & VM_UFFD_WP))
+	if (!userfaultfd_wp(dst_vma))
 		pte = pte_clear_uffd_wp(pte);
 
 	set_pte_at(dst_vma->vm_mm, addr, dst_pte, pte);
@@ -974,7 +974,8 @@ again:
 		if (unlikely(!pte_present(*src_pte))) {
 			entry.val = copy_nonpresent_pte(dst_mm, src_mm,
 							dst_pte, src_pte,
-							src_vma, addr, rss);
+							dst_vma, src_vma,
+							addr, rss);
 			if (entry.val)
 				break;
 			progress += 8;
@@ -1051,8 +1052,8 @@ copy_pmd_range(struct vm_area_struct *ds
 			|| pmd_devmap(*src_pmd)) {
 			int err;
 			VM_BUG_ON_VMA(next-addr != HPAGE_PMD_SIZE, src_vma);
-			err = copy_huge_pmd(dst_mm, src_mm,
-					    dst_pmd, src_pmd, addr, src_vma);
+			err = copy_huge_pmd(dst_mm, src_mm, dst_pmd, src_pmd,
+					    addr, dst_vma, src_vma);
 			if (err == -ENOMEM)
 				return -ENOMEM;
 			if (!err)


