Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E50142DC47
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhJNO5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 10:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232148AbhJNO5h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:57:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CBD261183;
        Thu, 14 Oct 2021 14:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223332;
        bh=YAAPXk5jeIombjigF/GEo2Viy02LuUKA2HQqr3WMBfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nc+f9YiX+0O1YQGT8CCj/C0rpdJfKTVNa/yk9HYExyS7VqBfjfSPrYTaS2pi11U4d
         VSzpr0NG/rtydsn0SMBirsyQsPOXEbpJtL9uxcHNN9IhueUi9t52QSsI6B7GABDAv2
         lyuKVsYXJoQAT1qY/r+J9cEX0n1bNIKL6GEq9aKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Kirill Shutemov <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 4.4 11/18] gup: document and work around "COW can break either way" issue
Date:   Thu, 14 Oct 2021 16:53:43 +0200
Message-Id: <20211014145206.690315439@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145206.330102860@linuxfoundation.org>
References: <20211014145206.330102860@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 17839856fd588f4ab6b789f482ed3ffd7c403e1f upstream.

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
        Since gup_pgd_range does not exist, made appropriate changes on
        the the gup_huge_pgd, gup_huge_pd and gup_pud_range calls instead.
	Replaced (gup_flags | FOLL_WRITE) with write=1 in gup_huge_pgd,
        gup_huge_pd and gup_pud_range.
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
[surenb: backport to 4.4 kernel]
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c         |   48 ++++++++++++++++++++++++++++++++++++++++--------
 mm/huge_memory.c |    7 +++----
 2 files changed, 43 insertions(+), 12 deletions(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -59,13 +59,22 @@ static int follow_pfn_pte(struct vm_area
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
@@ -509,12 +518,18 @@ long __get_user_pages(struct task_struct
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
@@ -1346,6 +1361,10 @@ static int gup_pud_range(pgd_t pgd, unsi
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
@@ -1375,6 +1394,12 @@ int __get_user_pages_fast(unsigned long
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
@@ -1385,15 +1410,22 @@ int __get_user_pages_fast(unsigned long
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
 			break;
+		/*
+		 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+		 * because get_user_pages() may need to cause an early COW in
+		 * order to avoid confusing the normal COW routines. So only
+		 * targets that are already writable are safe to do by just
+		 * looking at the page tables.
+		 */
 		if (unlikely(pgd_huge(pgd))) {
-			if (!gup_huge_pgd(pgd, pgdp, addr, next, write,
+			if (!gup_huge_pgd(pgd, pgdp, addr, next, 1,
 					  pages, &nr))
 				break;
 		} else if (unlikely(is_hugepd(__hugepd(pgd_val(pgd))))) {
 			if (!gup_huge_pd(__hugepd(pgd_val(pgd)), addr,
-					 PGDIR_SHIFT, next, write, pages, &nr))
+					 PGDIR_SHIFT, next, 1, pages, &nr))
 				break;
-		} else if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
+		} else if (!gup_pud_range(pgd, addr, next, 1, pages, &nr))
 			break;
 	} while (pgdp++, addr = next, addr != end);
 	local_irq_restore(flags);
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1268,13 +1268,12 @@ out_unlock:
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


