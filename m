Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50EA58C3FE
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 09:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbiHHHco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 03:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbiHHHcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 03:32:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30E0A391
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 00:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659943961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=e0Pdt2xyQSgvDtuP1BKITOaP+0NDsDLRpOu8MDfQmU8=;
        b=UvAYMUP4MItJvlg0YuQSCg/IxboDkSLXBV/N110Pwzf+/mJ8xCAuHJB/LW0yqiley+Cmfu
        tSKZ7dcE6BQSfFXOX1lL5bMIw4Qre9Rj/ebg82PHFu++j7moBtB8gMo9bjPYYvHhsAN4lr
        Guv5t9+qTXpXZw6xFczfOE0r1bBmdgM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-plhta_mQPNSgiK0w6hRECQ-1; Mon, 08 Aug 2022 03:32:38 -0400
X-MC-Unique: plhta_mQPNSgiK0w6hRECQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7910B8037B5;
        Mon,  8 Aug 2022 07:32:37 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.193.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70D9118ECC;
        Mon,  8 Aug 2022 07:32:33 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove FOLL_COW
Date:   Mon,  8 Aug 2022 09:32:32 +0200
Message-Id: <20220808073232.8808-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ever since the Dirty COW (CVE-2016-5195) security issue happened, we know
that FOLL_FORCE can be possibly dangerous, especially if there are races
that can be exploited by user space.

Right now, it would be sufficient to have some code that sets a PTE of
a R/O-mapped shared page dirty, in order for it to erroneously become
writable by FOLL_FORCE. The implications of setting a write-protected PTE
dirty might not be immediately obvious to everyone.

And in fact ever since commit 9ae0f87d009c ("mm/shmem: unconditionally set
pte dirty in mfill_atomic_install_pte"), we can use UFFDIO_CONTINUE to map
a shmem page R/O while marking the pte dirty. This can be used by
unprivileged user space to modify tmpfs/shmem file content even if the user
does not have write permissions to the file -- Dirty COW restricted to
tmpfs/shmem (CVE-2022-2590).

To fix such security issues for good, the insight is that we really only
need that fancy retry logic (FOLL_COW) for COW mappings that are not
writable (!VM_WRITE). And in a COW mapping, we really only broke COW if
we have an exclusive anonymous page mapped. If we have something else
mapped, or the mapped anonymous page might be shared (!PageAnonExclusive),
we have to trigger a write fault to break COW. If we don't find an
exclusive anonymous page when we retry, we have to trigger COW breaking
once again because something intervened.

Let's move away from this mandatory-retry + dirty handling and rely on
our PageAnonExclusive() flag for making a similar decision, to use the
same COW logic as in other kernel parts here as well. In case we stumble
over a PTE in a COW mapping that does not map an exclusive anonymous page,
COW was not properly broken and we have to trigger a fake write-fault to
break COW.

Just like we do in can_change_pte_writable() added via
commit 64fe24a3e05e ("mm/mprotect: try avoiding write faults for exclusive
anonymous pages when changing protection") and commit 76aefad628aa
("mm/mprotect: fix soft-dirty check in can_change_pte_writable()"), take
care of softdirty and uffd-wp manually.

For example, a write() via /proc/self/mem to a uffd-wp-protected range has
to fail instead of silently granting write access and bypassing the
userspace fault handler. Note that FOLL_FORCE is not only used for debug
access, but also triggered by applications without debug intentions, for
example, when pinning pages via RDMA.

This fixes CVE-2022-2590. Note that only x86_64 and aarch64 are
affected, because only those support CONFIG_HAVE_ARCH_USERFAULTFD_MINOR.

Fortunately, FOLL_COW is no longer required to handle FOLL_FORCE. So
let's just get rid of it.

Note 1: We don't check for the PTE being dirty because it doesn't matter
	for making a "was COWed" decision anymore, and whoever modifies the
	page has to set the page dirty either way.

Note 2: Kernels before extended uffd-wp support and before
	PageAnonExclusive (< 5.19) can simply revert the problematic
	commit instead and be safe regarding UFFDIO_CONTINUE. A backport to
	v5.19 requires minor adjustments due to lack of
	vma_soft_dirty_enabled().

Fixes: 9ae0f87d009c ("mm/shmem: unconditionally set pte dirty in mfill_atomic_install_pte")
Cc: <stable@vger.kernel.org> # 5.16+
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---

Against upstream from yesterday instead of v5.19 because I wanted to
reference the mprotect commit IDs and can_change_pte_writable(), and I
wanted to directly use vma_soft_dirty_enabled().

I have a working reproducer that I'll post to oss-security in one week. Of
course, that reproducer no longer triggers with that commit and my ptrace
testing indicated that FOLL_FORCE seems to continue working as expected.

---
 include/linux/mm.h |  1 -
 mm/gup.c           | 62 +++++++++++++++++++++++++++++-----------------
 mm/huge_memory.c   | 45 +++++++++++++++++----------------
 3 files changed, 63 insertions(+), 45 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 18e01474cf6b..2222ed598112 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2885,7 +2885,6 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 #define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
 #define FOLL_TRIED	0x800	/* a retry, previous pass started an IO */
 #define FOLL_REMOTE	0x2000	/* we are working on non-current tsk/mm */
-#define FOLL_COW	0x4000	/* internal GUP flag */
 #define FOLL_ANON	0x8000	/* don't do file mappings */
 #define FOLL_LONGTERM	0x10000	/* mapping lifetime is indefinite: see below */
 #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
diff --git a/mm/gup.c b/mm/gup.c
index 732825157430..7a0b207f566f 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -478,14 +478,34 @@ static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
 	return -EEXIST;
 }
 
-/*
- * FOLL_FORCE can write to even unwritable pte's, but only
- * after we've gone through a COW cycle and they are dirty.
- */
-static inline bool can_follow_write_pte(pte_t pte, unsigned int flags)
-{
-	return pte_write(pte) ||
-		((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_dirty(pte));
+/* FOLL_FORCE can write to even unwritable PTEs in COW mappings. */
+static inline bool can_follow_write_pte(pte_t pte, struct page *page,
+					struct vm_area_struct *vma,
+					unsigned int flags)
+{
+	if (pte_write(pte))
+		return true;
+	if (!(flags & FOLL_FORCE))
+		return false;
+
+	/*
+	 * See check_vma_flags(): only COW mappings need that special
+	 * "force" handling when they lack VM_WRITE.
+	 */
+	if (vma->vm_flags & VM_WRITE)
+		return false;
+	VM_BUG_ON(!is_cow_mapping(vma->vm_flags));
+
+	/*
+	 * See can_change_pte_writable(): we broke COW and could map the page
+	 * writable if we have an exclusive anonymous page and a write-fault
+	 * isn't require for other reasons.
+	 */
+	if (!page || !PageAnon(page) || !PageAnonExclusive(page))
+		return false;
+	if (vma_soft_dirty_enabled(vma) && !pte_soft_dirty(pte))
+		return false;
+	return !userfaultfd_pte_wp(vma, pte);
 }
 
 static struct page *follow_page_pte(struct vm_area_struct *vma,
@@ -528,12 +548,19 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
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
@@ -986,17 +1013,6 @@ static int faultin_page(struct vm_area_struct *vma,
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
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8a7c1b344abe..352b5220e95e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1040,12 +1040,6 @@ struct page *follow_devmap_pmd(struct vm_area_struct *vma, unsigned long addr,
 
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
@@ -1395,14 +1389,23 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
 	return VM_FAULT_FALLBACK;
 }
 
-/*
- * FOLL_FORCE can write to even unwritable pmd's, but only
- * after we've gone through a COW cycle and they are dirty.
- */
-static inline bool can_follow_write_pmd(pmd_t pmd, unsigned int flags)
+/* See can_follow_write_pte() on FOLL_FORCE details. */
+static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
+					struct vm_area_struct *vma,
+					unsigned int flags)
 {
-	return pmd_write(pmd) ||
-	       ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));
+	if (pmd_write(pmd))
+		return true;
+	if (!(flags & FOLL_FORCE))
+		return false;
+	if (vma->vm_flags & VM_WRITE)
+		return false;
+	VM_BUG_ON(!is_cow_mapping(vma->vm_flags));
+	if (!page || !PageAnon(page) || !PageAnonExclusive(page))
+		return false;
+	if (vma_soft_dirty_enabled(vma) && !pmd_soft_dirty(pmd))
+		return false;
+	return !userfaultfd_huge_pmd_wp(vma, pmd);
 }
 
 struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
@@ -1411,12 +1414,16 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
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
@@ -1424,10 +1431,7 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 
 	/* Full NUMA hinting faults to serialise migration in fault paths */
 	if ((flags & FOLL_NUMA) && pmd_protnone(*pmd))
-		goto out;
-
-	page = pmd_page(*pmd);
-	VM_BUG_ON_PAGE(!PageHead(page) && !is_zone_device_page(page), page);
+		return NULL;
 
 	if (!pmd_write(*pmd) && gup_must_unshare(flags, page))
 		return ERR_PTR(-EMLINK);
@@ -1444,7 +1448,6 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	VM_BUG_ON_PAGE(!PageCompound(page) && !is_zone_device_page(page), page);
 
-out:
 	return page;
 }
 

base-commit: 1612c382ffbdf1f673caec76502b1c00e6d35363
-- 
2.35.3

