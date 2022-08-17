Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9458597871
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 23:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242180AbiHQU5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 16:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242183AbiHQU5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 16:57:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AE6AB429;
        Wed, 17 Aug 2022 13:57:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA357B81F6A;
        Wed, 17 Aug 2022 20:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1B3C433B5;
        Wed, 17 Aug 2022 20:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660769826;
        bh=if8Q/cvth3T4U9MldYzY53NMMQ+A0a4MdbNP7bJtZls=;
        h=Date:To:From:Subject:From;
        b=XqhzQBEgx2+rmpCi2MMm8zhSKsyuvez29leFOwpn+86LZUUJshI8CGPwqrLr6PSRc
         qw68nQanQEeeXImruPUfy2tYn7CTZsA3el2BK7rwpqIZCmkVaj+WxPBJepXxvc1qr/
         F2Kp6LVTr0MPKl4z1aB5FNUXwCDPKcJ/EKIf2wxA=
Date:   Wed, 17 Aug 2022 13:57:05 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        stable@vger.kernel.org, peterx@redhat.com, nadav.amit@gmail.com,
        jhubbard@nvidia.com, jgg@nvidia.com, hughd@google.com,
        gregkh@linuxfoundation.org, David.Laight@ACULAB.COM,
        axelrasmussen@google.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-gup-fix-foll_force-cow-security-issue-and-remove-foll_cow.patch removed from -mm tree
Message-Id: <20220817205706.9F1B3C433B5@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: fix FOLL_FORCE COW security issue and remove FOLL_COW
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-foll_force-cow-security-issue-and-remove-foll_cow.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: fix FOLL_FORCE COW security issue and remove FOLL_COW
Date: Tue, 9 Aug 2022 22:56:40 +0200

Ever since the Dirty COW (CVE-2016-5195) security issue happened, we know
that FOLL_FORCE can be possibly dangerous, especially if there are races
that can be exploited by user space.

Right now, it would be sufficient to have some code that sets a PTE of a
R/O-mapped shared page dirty, in order for it to erroneously become
writable by FOLL_FORCE.  The implications of setting a write-protected PTE
dirty might not be immediately obvious to everyone.

And in fact ever since commit 9ae0f87d009c ("mm/shmem: unconditionally set
pte dirty in mfill_atomic_install_pte"), we can use UFFDIO_CONTINUE to map
a shmem page R/O while marking the pte dirty.  This can be used by
unprivileged user space to modify tmpfs/shmem file content even if the
user does not have write permissions to the file, and to bypass memfd
write sealing -- Dirty COW restricted to tmpfs/shmem (CVE-2022-2590).

To fix such security issues for good, the insight is that we really only
need that fancy retry logic (FOLL_COW) for COW mappings that are not
writable (!VM_WRITE).  And in a COW mapping, we really only broke COW if
we have an exclusive anonymous page mapped.  If we have something else
mapped, or the mapped anonymous page might be shared (!PageAnonExclusive),
we have to trigger a write fault to break COW.  If we don't find an
exclusive anonymous page when we retry, we have to trigger COW breaking
once again because something intervened.

Let's move away from this mandatory-retry + dirty handling and rely on our
PageAnonExclusive() flag for making a similar decision, to use the same
COW logic as in other kernel parts here as well.  In case we stumble over
a PTE in a COW mapping that does not map an exclusive anonymous page, COW
was not properly broken and we have to trigger a fake write-fault to break
COW.

Just like we do in can_change_pte_writable() added via commit 64fe24a3e05e
("mm/mprotect: try avoiding write faults for exclusive anonymous pages
when changing protection") and commit 76aefad628aa ("mm/mprotect: fix
soft-dirty check in can_change_pte_writable()"), take care of softdirty
and uffd-wp manually.

For example, a write() via /proc/self/mem to a uffd-wp-protected range has
to fail instead of silently granting write access and bypassing the
userspace fault handler.  Note that FOLL_FORCE is not only used for debug
access, but also triggered by applications without debug intentions, for
example, when pinning pages via RDMA.

This fixes CVE-2022-2590. Note that only x86_64 and aarch64 are
affected, because only those support CONFIG_HAVE_ARCH_USERFAULTFD_MINOR.

Fortunately, FOLL_COW is no longer required to handle FOLL_FORCE. So
let's just get rid of it.

Thanks to Nadav Amit for pointing out that the pte_dirty() check in
FOLL_FORCE code is problematic and might be exploitable.

Note 1: We don't check for the PTE being dirty because it doesn't matter
	for making a "was COWed" decision anymore, and whoever modifies the
	page has to set the page dirty either way.

Note 2: Kernels before extended uffd-wp support and before
	PageAnonExclusive (< 5.19) can simply revert the problematic
	commit instead and be safe regarding UFFDIO_CONTINUE. A backport to
	v5.19 requires minor adjustments due to lack of
	vma_soft_dirty_enabled().

Link: https://lkml.kernel.org/r/20220809205640.70916-1-david@redhat.com
Fixes: 9ae0f87d009c ("mm/shmem: unconditionally set pte dirty in mfill_atomic_install_pte")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: <stable@vger.kernel.org>	[5.16]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 
 mm/gup.c           |   68 +++++++++++++++++++++++++++++--------------
 mm/huge_memory.c   |   64 +++++++++++++++++++++++++++-------------
 3 files changed, 89 insertions(+), 44 deletions(-)

--- a/include/linux/mm.h~mm-gup-fix-foll_force-cow-security-issue-and-remove-foll_cow
+++ a/include/linux/mm.h
@@ -2884,7 +2884,6 @@ struct page *follow_page(struct vm_area_
 #define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
 #define FOLL_TRIED	0x800	/* a retry, previous pass started an IO */
 #define FOLL_REMOTE	0x2000	/* we are working on non-current tsk/mm */
-#define FOLL_COW	0x4000	/* internal GUP flag */
 #define FOLL_ANON	0x8000	/* don't do file mappings */
 #define FOLL_LONGTERM	0x10000	/* mapping lifetime is indefinite: see below */
 #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
--- a/mm/gup.c~mm-gup-fix-foll_force-cow-security-issue-and-remove-foll_cow
+++ a/mm/gup.c
@@ -478,14 +478,42 @@ static int follow_pfn_pte(struct vm_area
 	return -EEXIST;
 }
 
-/*
- * FOLL_FORCE can write to even unwritable pte's, but only
- * after we've gone through a COW cycle and they are dirty.
- */
-static inline bool can_follow_write_pte(pte_t pte, unsigned int flags)
+/* FOLL_FORCE can write to even unwritable PTEs in COW mappings. */
+static inline bool can_follow_write_pte(pte_t pte, struct page *page,
+					struct vm_area_struct *vma,
+					unsigned int flags)
 {
-	return pte_write(pte) ||
-		((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_dirty(pte));
+	/* If the pte is writable, we can write to the page. */
+	if (pte_write(pte))
+		return true;
+
+	/* Maybe FOLL_FORCE is set to override it? */
+	if (!(flags & FOLL_FORCE))
+		return false;
+
+	/* But FOLL_FORCE has no effect on shared mappings */
+	if (vma->vm_flags & (VM_MAYSHARE | VM_SHARED))
+		return false;
+
+	/* ... or read-only private ones */
+	if (!(vma->vm_flags & VM_MAYWRITE))
+		return false;
+
+	/* ... or already writable ones that just need to take a write fault */
+	if (vma->vm_flags & VM_WRITE)
+		return false;
+
+	/*
+	 * See can_change_pte_writable(): we broke COW and could map the page
+	 * writable if we have an exclusive anonymous page ...
+	 */
+	if (!page || !PageAnon(page) || !PageAnonExclusive(page))
+		return false;
+
+	/* ... and a write-fault isn't required for other reasons. */
+	if (vma_soft_dirty_enabled(vma) && !pte_soft_dirty(pte))
+		return false;
+	return !userfaultfd_pte_wp(vma, pte);
 }
 
 static struct page *follow_page_pte(struct vm_area_struct *vma,
@@ -528,12 +556,19 @@ retry:
 	}
 	if ((flags & FOLL_NUMA) && pte_protnone(pte))
 		goto no_page;
-	if ((flags & FOLL_WRITE) && !can_follow_write_pte(pte, flags)) {
-		pte_unmap_unlock(ptep, ptl);
-		return NULL;
-	}
 
 	page = vm_normal_page(vma, address, pte);
+
+	/*
+	 * We only care about anon pages in can_follow_write_pte() and don't
+	 * have to worry about pte_devmap() because they are never anon.
+	 */
+	if ((flags & FOLL_WRITE) &&
+	    !can_follow_write_pte(pte, page, vma, flags)) {
+		page = NULL;
+		goto out;
+	}
+
 	if (!page && pte_devmap(pte) && (flags & (FOLL_GET | FOLL_PIN))) {
 		/*
 		 * Only return device mapping pages in the FOLL_GET or FOLL_PIN
@@ -986,17 +1021,6 @@ static int faultin_page(struct vm_area_s
 		return -EBUSY;
 	}
 
-	/*
-	 * The VM_FAULT_WRITE bit tells us that do_wp_page has broken COW when
-	 * necessary, even if maybe_mkwrite decided not to set pte_write. We
-	 * can thus safely do subsequent page lookups as if they were reads.
-	 * But only do so when looping for pte_write is futile: in some cases
-	 * userspace may also be wanting to write to the gotten user page,
-	 * which a read fault here might prevent (a readonly page might get
-	 * reCOWed by userspace write).
-	 */
-	if ((ret & VM_FAULT_WRITE) && !(vma->vm_flags & VM_WRITE))
-		*flags |= FOLL_COW;
 	return 0;
 }
 
--- a/mm/huge_memory.c~mm-gup-fix-foll_force-cow-security-issue-and-remove-foll_cow
+++ a/mm/huge_memory.c
@@ -1040,12 +1040,6 @@ struct page *follow_devmap_pmd(struct vm
 
 	assert_spin_locked(pmd_lockptr(mm, pmd));
 
-	/*
-	 * When we COW a devmap PMD entry, we split it into PTEs, so we should
-	 * not be in this function with `flags & FOLL_COW` set.
-	 */
-	WARN_ONCE(flags & FOLL_COW, "mm: In follow_devmap_pmd with FOLL_COW set");
-
 	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
 	if (WARN_ON_ONCE((flags & (FOLL_PIN | FOLL_GET)) ==
 			 (FOLL_PIN | FOLL_GET)))
@@ -1395,14 +1389,42 @@ fallback:
 	return VM_FAULT_FALLBACK;
 }
 
-/*
- * FOLL_FORCE can write to even unwritable pmd's, but only
- * after we've gone through a COW cycle and they are dirty.
- */
-static inline bool can_follow_write_pmd(pmd_t pmd, unsigned int flags)
+/* FOLL_FORCE can write to even unwritable PMDs in COW mappings. */
+static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
+					struct vm_area_struct *vma,
+					unsigned int flags)
 {
-	return pmd_write(pmd) ||
-	       ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));
+	/* If the pmd is writable, we can write to the page. */
+	if (pmd_write(pmd))
+		return true;
+
+	/* Maybe FOLL_FORCE is set to override it? */
+	if (!(flags & FOLL_FORCE))
+		return false;
+
+	/* But FOLL_FORCE has no effect on shared mappings */
+	if (vma->vm_flags & (VM_MAYSHARE | VM_SHARED))
+		return false;
+
+	/* ... or read-only private ones */
+	if (!(vma->vm_flags & VM_MAYWRITE))
+		return false;
+
+	/* ... or already writable ones that just need to take a write fault */
+	if (vma->vm_flags & VM_WRITE)
+		return false;
+
+	/*
+	 * See can_change_pte_writable(): we broke COW and could map the page
+	 * writable if we have an exclusive anonymous page ...
+	 */
+	if (!page || !PageAnon(page) || !PageAnonExclusive(page))
+		return false;
+
+	/* ... and a write-fault isn't required for other reasons. */
+	if (vma_soft_dirty_enabled(vma) && !pmd_soft_dirty(pmd))
+		return false;
+	return !userfaultfd_huge_pmd_wp(vma, pmd);
 }
 
 struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
@@ -1411,12 +1433,16 @@ struct page *follow_trans_huge_pmd(struc
 				   unsigned int flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	struct page *page = NULL;
+	struct page *page;
 
 	assert_spin_locked(pmd_lockptr(mm, pmd));
 
-	if (flags & FOLL_WRITE && !can_follow_write_pmd(*pmd, flags))
-		goto out;
+	page = pmd_page(*pmd);
+	VM_BUG_ON_PAGE(!PageHead(page) && !is_zone_device_page(page), page);
+
+	if ((flags & FOLL_WRITE) &&
+	    !can_follow_write_pmd(*pmd, page, vma, flags))
+		return NULL;
 
 	/* Avoid dumping huge zero page */
 	if ((flags & FOLL_DUMP) && is_huge_zero_pmd(*pmd))
@@ -1424,10 +1450,7 @@ struct page *follow_trans_huge_pmd(struc
 
 	/* Full NUMA hinting faults to serialise migration in fault paths */
 	if ((flags & FOLL_NUMA) && pmd_protnone(*pmd))
-		goto out;
-
-	page = pmd_page(*pmd);
-	VM_BUG_ON_PAGE(!PageHead(page) && !is_zone_device_page(page), page);
+		return NULL;
 
 	if (!pmd_write(*pmd) && gup_must_unshare(flags, page))
 		return ERR_PTR(-EMLINK);
@@ -1444,7 +1467,6 @@ struct page *follow_trans_huge_pmd(struc
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	VM_BUG_ON_PAGE(!PageCompound(page) && !is_zone_device_page(page), page);
 
-out:
 	return page;
 }
 
_

Patches currently in -mm which might be from david@redhat.com are


