Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053901FB813
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731078AbgFPPwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:52:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732814AbgFPPwt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:52:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9B3D207C4;
        Tue, 16 Jun 2020 15:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322766;
        bh=NDChWoyLhMG8NdssUQxNACWxHeOvhTrRJueaqvTcQDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnybGM0W0fZ3wlUJgYbDCqYcU9QTcXBOqN05hhc3ay9v6FjBGSwsJZAUUybNN1bY7
         LKLQ3XnFeZHcqCIkiV6LMlPFY3ZzOxi4TXr3V91WmaYBDhz+VwYdgTjYiqoQ7NXnuD
         3DkdRaqanQe078i9sFczI/LbS2WZp6y1sPEXXtlM=
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
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.6 094/161] gup: document and work around "COW can break either way" issue
Date:   Tue, 16 Jun 2020 17:34:44 +0200
Message-Id: <20200616153110.855025071@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

Reported-by: Jann Horn <jannh@google.com>
Tested-by: Christoph Hellwig <hch@lst.de>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kirill Shutemov <kirill@shutemov.name>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c |    8 +++++
 mm/gup.c                                    |   44 ++++++++++++++++++++++++----
 mm/huge_memory.c                            |    7 +---
 3 files changed, 49 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -600,6 +600,14 @@ static int i915_gem_userptr_get_pages(st
 				      GFP_KERNEL |
 				      __GFP_NORETRY |
 				      __GFP_NOWARN);
+		/*
+		 * Using __get_user_pages_fast() with a read-only
+		 * access is questionable. A read-only page may be
+		 * COW-broken, and then this might end up giving
+		 * the wrong side of the COW..
+		 *
+		 * We may or may not care.
+		 */
 		if (pvec) /* defer to worker if malloc fails */
 			pinned = __get_user_pages_fast(obj->userptr.ptr,
 						       num_pages,
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -176,13 +176,22 @@ static int follow_pfn_pte(struct vm_area
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
+	return is_cow_mapping(vma->vm_flags) && (flags & (FOLL_GET | FOLL_PIN));
 }
 
 static struct page *follow_page_pte(struct vm_area_struct *vma,
@@ -848,12 +857,18 @@ static long __get_user_pages(struct task
 				goto out;
 			}
 			if (is_vm_hugetlb_page(vma)) {
+				if (should_force_cow_break(vma, foll_flags))
+					foll_flags |= FOLL_WRITE;
 				i = follow_hugetlb_page(mm, vma, pages, vmas,
 						&start, &nr_pages, i,
-						gup_flags, nonblocking);
+						foll_flags, nonblocking);
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
@@ -2364,6 +2379,10 @@ static bool gup_fast_permitted(unsigned
  *
  * If the architecture does not support this function, simply return with no
  * pages pinned.
+ *
+ * Careful, careful! COW breaking can go either way, so a non-write
+ * access can get ambiguous page results. If you call this function without
+ * 'write' set, you'd better be sure that you're ok with that ambiguity.
  */
 int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			  struct page **pages)
@@ -2391,6 +2410,12 @@ int __get_user_pages_fast(unsigned long
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
 
 	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP) &&
@@ -2448,10 +2473,17 @@ static int internal_get_user_pages_fast(
 	if (unlikely(!access_ok((void __user *)start, len)))
 		return -EFAULT;
 
+	/*
+	 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+	 * because get_user_pages() may need to cause an early COW in
+	 * order to avoid confusing the normal COW routines. So only
+	 * targets that are already writable are safe to do by just
+	 * looking at the page tables.
+	 */
 	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP) &&
 	    gup_fast_permitted(start, end)) {
 		local_irq_disable();
-		gup_pgd_range(addr, end, gup_flags, pages, &nr);
+		gup_pgd_range(addr, end, gup_flags | FOLL_WRITE, pages, &nr);
 		local_irq_enable();
 		ret = nr;
 	}
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1465,13 +1465,12 @@ out_unlock:
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


