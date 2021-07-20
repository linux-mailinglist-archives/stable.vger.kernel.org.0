Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869083CFEA2
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 18:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbhGTPZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 11:25:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33132 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242681AbhGTPL3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 11:11:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626796326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O9a/fbeKGsRCaGbj0GjFx29XZTyn9/xl+mDovWeTZmg=;
        b=aMW4CRGllW+yeBtMyH4MWTex1HkLJGIbBMK1jUgnasSEVSCspE+LeOwMF9ZpWMHE8y7lRZ
        a0oi52ZN+S1KapDVU8skWTwXbytYcvTzb6uLjbTbuagJss5bbhrZ4f9mFlKk5VhePKZ1+q
        NUBq0DW3hKDgxJSCrKatEIunfgJwWeo=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-n1-VQRt6Ps-UrX8-iqIvoA-1; Tue, 20 Jul 2021 11:51:59 -0400
X-MC-Unique: n1-VQRt6Ps-UrX8-iqIvoA-1
Received: by mail-qt1-f200.google.com with SMTP id l15-20020ac84a8f0000b0290267bc0213a9so4648248qtq.0
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 08:51:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O9a/fbeKGsRCaGbj0GjFx29XZTyn9/xl+mDovWeTZmg=;
        b=h8jFRnp/XXnRAJ5q4vWsc0fe5qSIiWfhPNnsz5WbjVSlUhFJGjVni3BmJkCnwmelQd
         mKmqciCctaGNnyxgp2bJJmV84LsgrgSsoJBYIV1FAANF1cPbR8MI2hd7ODwAZK5UZbYo
         G03lARhL2kV6CL1EuMuoTza14jM1+GRoEjcgtPha5WkeAfL3qUbLQ5+AU7Fx026blXoF
         Vgru4q1X4A4sYY/aWDjCIXKahfZeZltn9escexTII6wdMJkzfqo6QfdMShVsosC7eRmL
         fM7m4Q7V1dvjV2NNUKKJqEdz5vCO4VbKrRfecSb7OCpfY09GBTzr2BeTI/QLh/oFsffP
         VOHQ==
X-Gm-Message-State: AOAM5306e7+AUTD3Z7e70uczlgG0d3DY7PcDJoXcu/tVQdrmruCUyH7g
        YnMJvInFXczwG8lCsrdAVEdf2Wi7D2DL8kl+2WPhY0aFh/Y1W97jEvlElvQPJKxd0y6fcEo/I8t
        7lUwZQkTq0IBoQu560BIj7nLSf4lAGJqeVHb7h6LnPYKUgf1RDdQUCYFr+Ax2WL03Og==
X-Received: by 2002:ae9:eb97:: with SMTP id b145mr29483702qkg.111.1626796318300;
        Tue, 20 Jul 2021 08:51:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzM7UZgHaImiiimyOrNJGtSVevcrLmOKEvzTT9ExNnVNqev9TqLlnVV2THRD6LFzI+PQnpSqw==
X-Received: by 2002:ae9:eb97:: with SMTP id b145mr29483662qkg.111.1626796317942;
        Tue, 20 Jul 2021 08:51:57 -0700 (PDT)
Received: from localhost.localdomain (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id c15sm5467012qtc.37.2021.07.20.08.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 08:51:57 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
        Hillf Danton <hdanton@sina.com>, Igor Raits <igor@gooddata.com>
Subject: [PATCH stable 5.13.y/5.12.y 2/2] mm/userfaultfd: fix uffd-wp special cases for fork()
Date:   Tue, 20 Jul 2021 11:51:50 -0400
Message-Id: <20210720155150.497148-3-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210720155150.497148-1-peterx@redhat.com>
References: <796cbb7-5a1c-1ba0-dde5-479aba8224f2@google.com>
 <20210720155150.497148-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
(cherry picked from commit 8f34f1eac3820fc2722e5159acceb22545b30b0d)
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/huge_mm.h |  2 +-
 include/linux/swapops.h |  2 ++
 mm/huge_memory.c        | 27 ++++++++++++++-------------
 mm/memory.c             | 25 +++++++++++++------------
 4 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index b4e1ebaae825..939f21b69ead 100644
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
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 6430a94c6981..0d429a102d41 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -265,6 +265,8 @@ static inline swp_entry_t pmd_to_swp_entry(pmd_t pmd)
 
 	if (pmd_swp_soft_dirty(pmd))
 		pmd = pmd_swp_clear_soft_dirty(pmd);
+	if (pmd_swp_uffd_wp(pmd))
+		pmd = pmd_swp_clear_uffd_wp(pmd);
 	arch_entry = __pmd_to_swp_entry(pmd);
 	return swp_entry(__swp_type(arch_entry), __swp_offset(arch_entry));
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4cea1e218b48..9aaf4a8ebeeb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1026,7 +1026,7 @@ struct page *follow_devmap_pmd(struct vm_area_struct *vma, unsigned long addr,
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
-		  struct vm_area_struct *vma)
+		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
 	spinlock_t *dst_ptl, *src_ptl;
 	struct page *src_page;
@@ -1035,7 +1035,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	int ret = -ENOMEM;
 
 	/* Skip if can be re-fill on fault */
-	if (!vma_is_anonymous(vma))
+	if (!vma_is_anonymous(dst_vma))
 		return 0;
 
 	pgtable = pte_alloc_one(dst_mm);
@@ -1049,14 +1049,6 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
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
@@ -1067,11 +1059,15 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
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
@@ -1107,11 +1103,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
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
 
@@ -1121,8 +1117,9 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 out_zero_page:
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
-
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
+	if (!userfaultfd_wp(dst_vma))
+		pmd = pmd_clear_uffd_wp(pmd);
 	pmd = pmd_mkold(pmd_wrprotect(pmd));
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 
@@ -1838,6 +1835,8 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			newpmd = swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*pmd))
 				newpmd = pmd_swp_mksoft_dirty(newpmd);
+			if (pmd_swp_uffd_wp(*pmd))
+				newpmd = pmd_swp_mkuffd_wp(newpmd);
 			set_pmd_at(mm, addr, pmd, newpmd);
 		}
 		goto unlock;
@@ -3248,6 +3247,8 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 		pmde = pmd_mksoft_dirty(pmde);
 	if (is_write_migration_entry(entry))
 		pmde = maybe_pmd_mkwrite(pmde, vma);
+	if (pmd_swp_uffd_wp(*pvmw->pmd))
+		pmde = pmd_wrprotect(pmd_mkuffd_wp(pmde));
 
 	flush_cache_range(vma, mmun_start, mmun_start + HPAGE_PMD_SIZE);
 	if (PageAnon(new))
diff --git a/mm/memory.c b/mm/memory.c
index b15367c285bd..f8e8c99bba73 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -708,10 +708,10 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 
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
@@ -780,6 +780,8 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			set_pte_at(src_mm, addr, src_pte, pte);
 		}
 	}
+	if (!userfaultfd_wp(dst_vma))
+		pte = pte_swp_clear_uffd_wp(pte);
 	set_pte_at(dst_mm, addr, dst_pte, pte);
 	return 0;
 }
@@ -845,6 +847,9 @@ copy_present_page(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 	/* All done, just insert the new page copy in the child */
 	pte = mk_pte(new_page, dst_vma->vm_page_prot);
 	pte = maybe_mkwrite(pte_mkdirty(pte), dst_vma);
+	if (userfaultfd_pte_wp(dst_vma, *src_pte))
+		/* Uffd-wp needs to be delivered to dest pte as well */
+		pte = pte_wrprotect(pte_mkuffd_wp(pte));
 	set_pte_at(dst_vma->vm_mm, addr, dst_pte, pte);
 	return 0;
 }
@@ -894,12 +899,7 @@ copy_present_pte(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
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
@@ -974,7 +974,8 @@ copy_pte_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 		if (unlikely(!pte_present(*src_pte))) {
 			entry.val = copy_nonpresent_pte(dst_mm, src_mm,
 							dst_pte, src_pte,
-							src_vma, addr, rss);
+							dst_vma, src_vma,
+							addr, rss);
 			if (entry.val)
 				break;
 			progress += 8;
@@ -1051,8 +1052,8 @@ copy_pmd_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
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
-- 
2.31.1

