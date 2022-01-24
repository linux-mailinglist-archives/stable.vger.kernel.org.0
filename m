Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BB6498B81
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344293AbiAXTOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347758AbiAXTLI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:11:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F70CC08E86F;
        Mon, 24 Jan 2022 11:02:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28B1FB81235;
        Mon, 24 Jan 2022 19:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28823C340E5;
        Mon, 24 Jan 2022 19:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050954;
        bh=DWyQ42JRtDs5K2IVsSqF2J4Srzipab1SqKuJVt+Cix8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tcrV0nKOD0cLWuDkPivsBRQDtk0OASr5I5MEP/WCLnC1xlUcLK8wFi2tCcyF5F4od
         wsVMM7rF1kyLKnnkseOXyTRjZRRoR81UTBXqHmfqC2Cf0quHRKSArnJr/QPpiaCuAg
         RtbHtMKLdyqfwyGcZU/8xACfAO+yqfQcws34ZSI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jann Horn <jannh@google.com>, Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Kirill Shutemov <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 147/157] gup: document and work around "COW can break either way" issue
Date:   Mon, 24 Jan 2022 19:43:57 +0100
Message-Id: <20220124183937.429525904@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>

commit 9bbd42e79720122334226afad9ddcac1c3e6d373 upstream.

Doing a "get_user_pages()" on a copy-on-write page for reading can be
ambiguous: the page can be COW'ed at any time afterwards, and the
direction of a COW event isn't defined.

Yes, whoever writes to it will generally do the COW, but if the thread
that did the get_user_pages() unmapped the page before the write (and
that could happen due to memory pressure in addition to any outright
action), the writer could also just take over the old page instead.

End result: the get_user_pages() call might result in a page pointer
that is no longer associated with the original VM, and is associated
with - and controlled by - another VM having taken it over instead.

So when doing a get_user_pages() on a COW mapping, the only really safe
thing to do would be to break the COW when getting the page, even when
only getting it for reading.

At the same time, some users simply don't even care.

For example, the perf code wants to look up the page not because it
cares about the page, but because the code simply wants to look up the
physical address of the access for informational purposes, and doesn't
really care about races when a page might be unmapped and remapped
elsewhere.

This adds logic to force a COW event by setting FOLL_WRITE on any
copy-on-write mapping when FOLL_GET (or FOLL_PIN) is used to get a page
pointer as a result.

The current semantics end up being:

 - __get_user_pages_fast(): no change. If you don't ask for a write,
   you won't break COW. You'd better know what you're doing.

 - get_user_pages_fast(): the fast-case "look it up in the page tables
   without anything getting mmap_sem" now refuses to follow a read-only
   page, since it might need COW breaking.  Which happens in the slow
   path - the fast path doesn't know if the memory might be COW or not.

 - get_user_pages() (including the slow-path fallback for gup_fast()):
   for a COW mapping, turn on FOLL_WRITE for FOLL_GET/FOLL_PIN, with
   very similar semantics to FOLL_FORCE.

If it turns out that we want finer granularity (ie "only break COW when
it might actually matter" - things like the zero page are special and
don't need to be broken) we might need to push these semantics deeper
into the lookup fault path.  So if people care enough, it's possible
that we might end up adding a new internal FOLL_BREAK_COW flag to go
with the internal FOLL_COW flag we already have for tracking "I had a
COW".

Alternatively, if it turns out that different callers might want to
explicitly control the forced COW break behavior, we might even want to
make such a flag visible to the users of get_user_pages() instead of
using the above default semantics.

But for now, this is mostly commentary on the issue (this commit message
being a lot bigger than the patch, and that patch in turn is almost all
comments), with that minimal "enable COW breaking early" logic using the
existing FOLL_WRITE behavior.

[ It might be worth noting that we've always had this ambiguity, and it
  could arguably be seen as a user-space issue.

  You only get private COW mappings that could break either way in
  situations where user space is doing cooperative things (ie fork()
  before an execve() etc), but it _is_ surprising and very subtle, and
  fork() is supposed to give you independent address spaces.

  So let's treat this as a kernel issue and make the semantics of
  get_user_pages() easier to understand. Note that obviously a true
  shared mapping will still get a page that can change under us, so this
  does _not_ mean that get_user_pages() somehow returns any "stable"
  page ]

[surenb: backport notes
	Replaced (gup_flags | FOLL_WRITE) with write=1 in gup_pgd_range.
	Removed FOLL_PIN usage in should_force_cow_break since it's missing in
	the earlier kernels.]

Reported-by: Jann Horn <jannh@google.com>
Tested-by: Christoph Hellwig <hch@lst.de>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kirill Shutemov <kirill@shutemov.name>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[surenb: backport to 4.19 kernel]
Cc: stable@vger.kernel.org # 4.19.x
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 4.9:
 - Generic get_user_pages_fast() calls __get_user_pages_fast() here,
   so make it pass write=1
 - Various architectures have their own implementations of
   get_user_pages_fast(), so apply the corresponding change there
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/mm/gup.c  |    9 ++++++++-
 arch/s390/mm/gup.c  |    9 ++++++++-
 arch/sh/mm/gup.c    |    9 ++++++++-
 arch/sparc/mm/gup.c |    9 ++++++++-
 arch/x86/mm/gup.c   |    9 ++++++++-
 mm/gup.c            |   44 ++++++++++++++++++++++++++++++++++++++------
 mm/huge_memory.c    |    7 +++----
 7 files changed, 81 insertions(+), 15 deletions(-)

--- a/arch/mips/mm/gup.c
+++ b/arch/mips/mm/gup.c
@@ -271,7 +271,14 @@ int get_user_pages_fast(unsigned long st
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			goto slow;
-		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+		/*
+		 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+		 * because get_user_pages() may need to cause an early COW in
+		 * order to avoid confusing the normal COW routines. So only
+		 * targets that are already writable are safe to do by just
+		 * looking at the page tables.
+		 */
+		if (!gup_pud_range(pgd, addr, next, 1, pages, &nr))
 			goto slow;
 	} while (pgdp++, addr = next, addr != end);
 	local_irq_enable();
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -261,7 +261,14 @@ int get_user_pages_fast(unsigned long st
 
 	might_sleep();
 	start &= PAGE_MASK;
-	nr = __get_user_pages_fast(start, nr_pages, write, pages);
+	/*
+	 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+	 * because get_user_pages() may need to cause an early COW in
+	 * order to avoid confusing the normal COW routines. So only
+	 * targets that are already writable are safe to do by just
+	 * looking at the page tables.
+	 */
+	nr = __get_user_pages_fast(start, nr_pages, 1, pages);
 	if (nr == nr_pages)
 		return nr;
 
--- a/arch/sh/mm/gup.c
+++ b/arch/sh/mm/gup.c
@@ -239,7 +239,14 @@ int get_user_pages_fast(unsigned long st
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			goto slow;
-		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+		/*
+		 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+		 * because get_user_pages() may need to cause an early COW in
+		 * order to avoid confusing the normal COW routines. So only
+		 * targets that are already writable are safe to do by just
+		 * looking at the page tables.
+		 */
+		if (!gup_pud_range(pgd, addr, next, 1, pages, &nr))
 			goto slow;
 	} while (pgdp++, addr = next, addr != end);
 	local_irq_enable();
--- a/arch/sparc/mm/gup.c
+++ b/arch/sparc/mm/gup.c
@@ -218,7 +218,14 @@ int get_user_pages_fast(unsigned long st
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			goto slow;
-		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+		/*
+		 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+		 * because get_user_pages() may need to cause an early COW in
+		 * order to avoid confusing the normal COW routines. So only
+		 * targets that are already writable are safe to do by just
+		 * looking at the page tables.
+		 */
+		if (!gup_pud_range(pgd, addr, next, 1, pages, &nr))
 			goto slow;
 	} while (pgdp++, addr = next, addr != end);
 
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -454,7 +454,14 @@ int get_user_pages_fast(unsigned long st
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			goto slow;
-		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+		/*
+		 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+		 * because get_user_pages() may need to cause an early COW in
+		 * order to avoid confusing the normal COW routines. So only
+		 * targets that are already writable are safe to do by just
+		 * looking at the page tables.
+		 */
+		if (!gup_pud_range(pgd, addr, next, 1, pages, &nr))
 			goto slow;
 	} while (pgdp++, addr = next, addr != end);
 	local_irq_enable();
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -61,13 +61,22 @@ static int follow_pfn_pte(struct vm_area
 }
 
 /*
- * FOLL_FORCE can write to even unwritable pte's, but only
- * after we've gone through a COW cycle and they are dirty.
+ * FOLL_FORCE or a forced COW break can write even to unwritable pte's,
+ * but only after we've gone through a COW cycle and they are dirty.
  */
 static inline bool can_follow_write_pte(pte_t pte, unsigned int flags)
 {
-	return pte_write(pte) ||
-		((flags & FOLL_FORCE) && (flags & FOLL_COW) && pte_dirty(pte));
+	return pte_write(pte) || ((flags & FOLL_COW) && pte_dirty(pte));
+}
+
+/*
+ * A (separate) COW fault might break the page the other way and
+ * get_user_pages() would return the page from what is now the wrong
+ * VM. So we need to force a COW break at GUP time even for reads.
+ */
+static inline bool should_force_cow_break(struct vm_area_struct *vma, unsigned int flags)
+{
+	return is_cow_mapping(vma->vm_flags) && (flags & FOLL_GET);
 }
 
 static struct page *follow_page_pte(struct vm_area_struct *vma,
@@ -577,12 +586,18 @@ static long __get_user_pages(struct task
 			if (!vma || check_vma_flags(vma, gup_flags))
 				return i ? : -EFAULT;
 			if (is_vm_hugetlb_page(vma)) {
+				if (should_force_cow_break(vma, foll_flags))
+					foll_flags |= FOLL_WRITE;
 				i = follow_hugetlb_page(mm, vma, pages, vmas,
 						&start, &nr_pages, i,
-						gup_flags);
+						foll_flags);
 				continue;
 			}
 		}
+
+		if (should_force_cow_break(vma, foll_flags))
+			foll_flags |= FOLL_WRITE;
+
 retry:
 		/*
 		 * If we have a pending SIGKILL, don't keep faulting pages and
@@ -1503,6 +1518,10 @@ static int gup_pud_range(pgd_t pgd, unsi
 /*
  * Like get_user_pages_fast() except it's IRQ-safe in that it won't fall back to
  * the regular GUP. It will only return non-negative values.
+ *
+ * Careful, careful! COW breaking can go either way, so a non-write
+ * access can get ambiguous page results. If you call this function without
+ * 'write' set, you'd better be sure that you're ok with that ambiguity.
  */
 int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			  struct page **pages)
@@ -1532,6 +1551,12 @@ int __get_user_pages_fast(unsigned long
 	 *
 	 * We do not adopt an rcu_read_lock(.) here as we also want to
 	 * block IPIs that come from THPs splitting.
+	 *
+	 * NOTE! We allow read-only gup_fast() here, but you'd better be
+	 * careful about possible COW pages. You'll get _a_ COW page, but
+	 * not necessarily the one you intended to get depending on what
+	 * COW event happens after this. COW may break the page copy in a
+	 * random direction.
 	 */
 
 	local_irq_save(flags);
@@ -1580,7 +1605,14 @@ int get_user_pages_fast(unsigned long st
 	int nr, ret;
 
 	start &= PAGE_MASK;
-	nr = __get_user_pages_fast(start, nr_pages, write, pages);
+	/*
+	 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+	 * because get_user_pages() may need to cause an early COW in
+	 * order to avoid confusing the normal COW routines. So only
+	 * targets that are already writable are safe to do by just
+	 * looking at the page tables.
+	 */
+	nr = __get_user_pages_fast(start, nr_pages, 1, pages);
 	ret = nr;
 
 	if (nr < nr_pages) {
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1135,13 +1135,12 @@ out_unlock:
 }
 
 /*
- * FOLL_FORCE can write to even unwritable pmd's, but only
- * after we've gone through a COW cycle and they are dirty.
+ * FOLL_FORCE or a forced COW break can write even to unwritable pmd's,
+ * but only after we've gone through a COW cycle and they are dirty.
  */
 static inline bool can_follow_write_pmd(pmd_t pmd, unsigned int flags)
 {
-	return pmd_write(pmd) ||
-	       ((flags & FOLL_FORCE) && (flags & FOLL_COW) && pmd_dirty(pmd));
+	return pmd_write(pmd) || ((flags & FOLL_COW) && pmd_dirty(pmd));
 }
 
 struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,


