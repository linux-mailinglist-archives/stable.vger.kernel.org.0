Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F20367564
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 00:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbhDUW5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 18:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233995AbhDUW5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 18:57:12 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8B7C06138A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 15:56:38 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id e4-20020a37b5040000b02902df9a0070efso10717451qkf.18
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 15:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WI8F6sHKbEkY7kEQwiSfYT+DGU4CIMg8Y47B2zej05Q=;
        b=tIiakE5DxbCw7W4udzRAd0+gyva6ly/Y8tsq8LoT9Usk8NvuwNATO+ErkqUFiI5+Wi
         Rt2jweHDuF32vBcBBI8oWRhLInaZVDAKcnFBoG73XiMgUgyV3yS506rOiQRnGT46u6UT
         8nWMQQycSudM7zQ0daYRYEtd2Lk63ob+x56ZN0EPj61XWo7lYrAaqS1VhrYF49eKghOX
         41vxuyhjjDE0Jfxg8kH/UT4ZjjHhhyB3on8ZcdsB24tJXwAh6oWFdPSjYJ9D57v2YcFB
         fJ/7ecMFjyhjxu0hUveuka7X2Z6CEcnnbLS9bRWAfm1BInsT07PixjCTOya1Y8oE+bZh
         ehQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WI8F6sHKbEkY7kEQwiSfYT+DGU4CIMg8Y47B2zej05Q=;
        b=FznHgtre9K5d1pK+uOQmxsUadaGa5crhTiDcYQFU3XSdgWAjbG3VVyP3EKDz2AemzO
         iWHUk7Oiwms6EcQcgiX6ChDKI1zT9Kaj937oG6Mvxw/G6HKqZH4qkX8J7OcU1to2AijY
         8eQIYZUJEzBBGx6aN/IwPdQYr6DNufm4QhiokIQw9XW5LOdLR+cIiNaM7TCHdWPK4K8L
         hGL27Zrx7UrpOT5mLyBvx8Ml2TB6kY2A8owt2MuS2MkksJqF4XrH3u1OQxCh5EqRQy7G
         +7pi571Uf1+FK+8Q0o+iD9kqTqm99jQinje1E8oFJ9LCFMJiQUl8cOEbVAOv/jbP7l5/
         cDOA==
X-Gm-Message-State: AOAM532lzD39boXKA7sJkZ7/ouDa4c3MdZsYf93bWAiqcYILxz+3EKfQ
        ZuuBl6/W6UKSgwH3feIJnBr7KFtSKYRFyJ0ax7pK939B7I0lh1gYdB0BgpIfmAvp17APPRiO9bf
        D+KgEwqMAixF/ZWMqdvCPTzVbS7paW41iQoZNRVdOPI2gZv1sNdM3bodEaLfmIA==
X-Google-Smtp-Source: ABdhPJz3lyYov/2/yszTfBeTeqEGm3VXVyzJ7YGwC5QdZTj/8K1K6md/e2+GGomzI6jlJFOdZupiVZkc1UQ=
X-Received: from surenb1.mtv.corp.google.com ([2620:15c:211:200:dae6:51e5:c9a2:646d])
 (user=surenb job=sendgmr) by 2002:a0c:99d9:: with SMTP id y25mr568253qve.28.1619045797205;
 Wed, 21 Apr 2021 15:56:37 -0700 (PDT)
Date:   Wed, 21 Apr 2021 15:56:13 -0700
Message-Id: <20210421225613.60124-1-surenb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 1/1] gup: document and work around "COW can break either way" issue
From:   Suren Baghdasaryan <surenb@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, jannh@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, peterx@redhat.com,
        aarcange@redhat.com, david@redhat.com, jgg@ziepe.ca,
        ktkhai@virtuozzo.com, shli@fb.com, namit@vmware.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, surenb@google.com,
        Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Kirill Shutemov <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
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

[surenb: backport notes]
Replaced (gup_flags | FOLL_WRITE) with write=1 in gup_pgd_range.
Removed FOLL_PIN usage in should_force_cow_break since it's missing in
the earlier kernels.

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
---
 mm/gup.c         | 44 ++++++++++++++++++++++++++++++++++++++------
 mm/huge_memory.c |  7 +++----
 2 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index f3088d25bd92..44569927f0ea 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -61,13 +61,22 @@ static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
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
@@ -710,12 +719,18 @@ static long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 			if (!vma || check_vma_flags(vma, gup_flags))
 				return i ? : -EFAULT;
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
@@ -1804,6 +1819,10 @@ bool gup_fast_permitted(unsigned long start, int nr_pages, int write)
  * the regular GUP.
  * Note a difference with get_user_pages_fast: this always returns the
  * number of pages pinned, 0 if no pages were pinned.
+ *
+ * Careful, careful! COW breaking can go either way, so a non-write
+ * access can get ambiguous page results. If you call this function without
+ * 'write' set, you'd better be sure that you're ok with that ambiguity.
  */
 int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			  struct page **pages)
@@ -1831,6 +1850,12 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
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
 
 	if (gup_fast_permitted(start, nr_pages, write)) {
@@ -1876,9 +1901,16 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 					(void __user *)start, len)))
 		return -EFAULT;
 
+	/*
+	 * The FAST_GUP case requires FOLL_WRITE even for pure reads,
+	 * because get_user_pages() may need to cause an early COW in
+	 * order to avoid confusing the normal COW routines. So only
+	 * targets that are already writable are safe to do by just
+	 * looking at the page tables.
+	 */
 	if (gup_fast_permitted(start, nr_pages, write)) {
 		local_irq_disable();
-		gup_pgd_range(addr, end, write, pages, &nr);
+		gup_pgd_range(addr, end, 1, pages, &nr);
 		local_irq_enable();
 		ret = nr;
 	}
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index cf9e2bbffdc1..7c374c0fcf0c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1432,13 +1432,12 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
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
-- 
2.31.1.368.gbe11c130af-goog

