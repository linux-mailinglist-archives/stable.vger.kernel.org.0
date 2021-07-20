Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15773CFEA6
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 18:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbhGTPZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 11:25:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238629AbhGTPRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 11:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626796626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rxi10QV5fHJLit1Ga0uHG5DDHU2257Q+ziTd2cRYISQ=;
        b=f5bRpC+ChJWSBGyOLsxHrCwpIqm1reovKRtruQWZ1P/rmGdvZjloISZ3BUZAjuVobJ9oa0
        KifH/tethJSx7hlZgKWX0amZX3HU2Bschz5d2VRCbWTxJ6QCMZWXAyv9RSyQMI/mdFL77T
        HrGGlMX7gHwDrTakL9Qqk30p4eEFlAg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-00IkfETbP96ijlg9jrprkw-1; Tue, 20 Jul 2021 11:57:05 -0400
X-MC-Unique: 00IkfETbP96ijlg9jrprkw-1
Received: by mail-qk1-f199.google.com with SMTP id c3-20020a37b3030000b02903ad0001a2e8so18851898qkf.3
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 08:57:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rxi10QV5fHJLit1Ga0uHG5DDHU2257Q+ziTd2cRYISQ=;
        b=f9jWNUguYb3v0lLrK2to89kdX7RlB1FQ5vbh9vy46RrJOXY4mzCnvnhlfOwwKIfkhQ
         +Xv1P7/dT2x9PtUo+aow+myEDpL0jQUrDNTtZqkRqNUw0YAyof7CM1QFWpSieCmWOGhv
         7UDFIbYQYYx7OCpA6yaT27Zvwr3B8kc2O3G8k3Lon/trgnCChETpZOxSfBx9q0bvVqeU
         I55atL6TKZH/uTHFQ3qXj1xnB6lgKRhiEnBosPyvnpXFs8Npy47zxFHliVyFCkFMu+9/
         zgXWWR9J6EYevfAxQvSKrgbzXS9NzeNZRAv9ccS4EgOQjLML1LGs9yLkQLj7AqhITtRU
         OPnw==
X-Gm-Message-State: AOAM531FgYOse5L5stYxuHLHhk1/3O7Ngefsm1pRKgsj3GhPIMfkvfQv
        QOhLzqvbC39h/YGK5GJuQbtdwqyBsinzl0gyUi6uLrSQ8+d/0ULtXaVRpslPnABBEsTo4gB43+k
        oB1ut7pDgere1x5TvYSK9i1k8aFP0tIwMDVqfr2YEJymN1CouvhmEVK7Xr4fXhKWjaQ==
X-Received: by 2002:a05:620a:a19:: with SMTP id i25mr29759149qka.426.1626796624693;
        Tue, 20 Jul 2021 08:57:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPq3/Ach6YWW41XG3arulEdzTswCT5M9JA7h1mhCRjH75TRo5S5BRY/MaIPjwWavYyMJX6wQ==
X-Received: by 2002:a05:620a:a19:: with SMTP id i25mr29759115qka.426.1626796624391;
        Tue, 20 Jul 2021 08:57:04 -0700 (PDT)
Received: from localhost.localdomain (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id 74sm5298585qkh.42.2021.07.20.08.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 08:57:03 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc:     Igor Raits <igor@gooddata.com>, peterx@redhat.com,
        Hillf Danton <hdanton@sina.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH stable 5.10.y 2/2] mm/userfaultfd: fix uffd-wp special cases for fork()
Date:   Tue, 20 Jul 2021 11:56:57 -0400
Message-Id: <20210720155657.499127-3-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210720155657.499127-1-peterx@redhat.com>
References: <796cbb7-5a1c-1ba0-dde5-479aba8224f2@google.com>
 <20210720155657.499127-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Conflict: copy_huge_pmd() hasn't introduced helper page_needs_cow_for_dma()]

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
index e72787731a5b..176457145bcf 100644
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
index 8763c4e346cb..594368f6134f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1012,7 +1012,7 @@ struct page *follow_devmap_pmd(struct vm_area_struct *vma, unsigned long addr,
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		  pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
-		  struct vm_area_struct *vma)
+		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
 	spinlock_t *dst_ptl, *src_ptl;
 	struct page *src_page;
@@ -1021,7 +1021,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	int ret = -ENOMEM;
 
 	/* Skip if can be re-fill on fault */
-	if (!vma_is_anonymous(vma))
+	if (!vma_is_anonymous(dst_vma))
 		return 0;
 
 	pgtable = pte_alloc_one(dst_mm);
@@ -1035,14 +1035,6 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
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
@@ -1053,11 +1045,15 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
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
@@ -1093,13 +1089,13 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	 * best effort that the pinned pages won't be replaced by another
 	 * random page during the coming copy-on-write.
 	 */
-	if (unlikely(is_cow_mapping(vma->vm_flags) &&
+	if (unlikely(is_cow_mapping(src_vma->vm_flags) &&
 		     atomic_read(&src_mm->has_pinned) &&
 		     page_maybe_dma_pinned(src_page))) {
 		pte_free(dst_mm, pgtable);
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
-		__split_huge_pmd(vma, src_pmd, addr, false, NULL);
+		__split_huge_pmd(src_vma, src_pmd, addr, false, NULL);
 		return -EAGAIN;
 	}
 
@@ -1109,8 +1105,9 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 out_zero_page:
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
-
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
+	if (!userfaultfd_wp(dst_vma))
+		pmd = pmd_clear_uffd_wp(pmd);
 	pmd = pmd_mkold(pmd_wrprotect(pmd));
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 
@@ -1829,6 +1826,8 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			newpmd = swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*pmd))
 				newpmd = pmd_swp_mksoft_dirty(newpmd);
+			if (pmd_swp_uffd_wp(*pmd))
+				newpmd = pmd_swp_mkuffd_wp(newpmd);
 			set_pmd_at(mm, addr, pmd, newpmd);
 		}
 		goto unlock;
@@ -2995,6 +2994,8 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 		pmde = pmd_mksoft_dirty(pmde);
 	if (is_write_migration_entry(entry))
 		pmde = maybe_pmd_mkwrite(pmde, vma);
+	if (pmd_swp_uffd_wp(*pvmw->pmd))
+		pmde = pmd_wrprotect(pmd_mkuffd_wp(pmde));
 
 	flush_cache_range(vma, mmun_start, mmun_start + HPAGE_PMD_SIZE);
 	if (PageAnon(new))
diff --git a/mm/memory.c b/mm/memory.c
index 0a905e0a7e67..f979511a3bb4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -696,10 +696,10 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 
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
@@ -768,6 +768,8 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			set_pte_at(src_mm, addr, src_pte, pte);
 		}
 	}
+	if (!userfaultfd_wp(dst_vma))
+		pte = pte_swp_clear_uffd_wp(pte);
 	set_pte_at(dst_mm, addr, dst_pte, pte);
 	return 0;
 }
@@ -839,6 +841,9 @@ copy_present_page(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 	/* All done, just insert the new page copy in the child */
 	pte = mk_pte(new_page, dst_vma->vm_page_prot);
 	pte = maybe_mkwrite(pte_mkdirty(pte), dst_vma);
+	if (userfaultfd_pte_wp(dst_vma, *src_pte))
+		/* Uffd-wp needs to be delivered to dest pte as well */
+		pte = pte_wrprotect(pte_mkuffd_wp(pte));
 	set_pte_at(dst_vma->vm_mm, addr, dst_pte, pte);
 	return 0;
 }
@@ -888,12 +893,7 @@ copy_present_pte(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
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
@@ -968,7 +968,8 @@ copy_pte_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 		if (unlikely(!pte_present(*src_pte))) {
 			entry.val = copy_nonpresent_pte(dst_mm, src_mm,
 							dst_pte, src_pte,
-							src_vma, addr, rss);
+							dst_vma, src_vma,
+							addr, rss);
 			if (entry.val)
 				break;
 			progress += 8;
@@ -1045,8 +1046,8 @@ copy_pmd_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
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

