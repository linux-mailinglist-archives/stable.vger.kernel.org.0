Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D5D36756B
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 00:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbhDUW62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 18:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235481AbhDUW62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 18:58:28 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE43C06138A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 15:57:54 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d8-20020a25eb080000b02904e6f038cad5so17502574ybs.4
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 15:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1nWjP/RxIMYmF/BrJAp3jQxj0PjCdfOojaRjn9Er+GI=;
        b=tTN3wCSvhGounV/buF485d6u1NjMMBKdWCWlXolvCY5Jil8D0aC3aOuC8Zo9p4oozx
         t9uhQ5egM1z1DKjsJwtrnfN2OPr0jUkX/D9+v698wDWXlFJPHlV3mKLim/8fZEt9tzwP
         CbnkvyIfwER7fk9mMG/BBpJ8L87vkn4q+bbSjtMeIBo0iiGwGdv1RicB0jvFaxt5ENwB
         O8P7Zw7ntz/jPXsmTXbHdFxNhzGEVeIiCD3gQyWJkp9jT7/fXCsZV8EimRhv77HMf9Ot
         pcTiJpE/VGSzWdjSoQWw5po9Q9zKE9NX7IyFvk5JW8pP1S2rt4pTTWgZApDguEeylMI4
         CkKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1nWjP/RxIMYmF/BrJAp3jQxj0PjCdfOojaRjn9Er+GI=;
        b=oag24mYRQcgxIkq4CeRxeoSHRgQTf6MPwoWmMvv0CqsCZDlv3m0ggCIhcPNHPNRvBv
         EjDdTVfymQpUQiLyZutab8tR0CGbozH0DCEC6sgI9PLe4UB/uIEm/UlSJyt0nwmnoxOk
         eSzrVBBkXrspEeT7yP4gPzlW7k/HXYvdtwPr4RLOqsSt8nDo69JT3wR4SszIv38D2f7I
         9q753RU9p7t9M2g08llfhKQL9SpdeWfJX+Jm1r/P0kCORySzu0Zv9jXp35zMYtEhb1Bm
         9x6qUvL2sf09FZCp2v3MAkik8gd4azQZ/GUjdjXRD/VPasAAjqtlZDNVzuBMiPmExenH
         ryzw==
X-Gm-Message-State: AOAM533gENVCgctPlO+U882er1sWu50BU5LdRQJNARQ9Zk56F7e4u1vz
        IxDRN1PIrhdhKsSPko4fc432m6yK6o+bbKhiW972UwQpnLrlTxiqiu8CN2mQygTRaiMI412gmWS
        fVskNklQ9lAJD0/FW+OjVC8g3Xz66O8D+oAeZ8vGwujIym8Ihhmxd/vdoukpVJg==
X-Google-Smtp-Source: ABdhPJzTIG2BgxHdHGNxygHKfQfnkDGOKEUVfAzM1lyLBGVwXNXc28h3V1AxUsmxkAPs175qwS9iydKHzD0=
X-Received: from surenb1.mtv.corp.google.com ([2620:15c:211:200:dae6:51e5:c9a2:646d])
 (user=surenb job=sendgmr) by 2002:a25:4fc4:: with SMTP id d187mr451085ybb.245.1619045873816;
 Wed, 21 Apr 2021 15:57:53 -0700 (PDT)
Date:   Wed, 21 Apr 2021 15:57:50 -0700
Message-Id: <20210421225750.60668-1-surenb@google.com>
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
[surenb: backport to 4.14 kernel]
Cc: stable@vger.kernel.org # 4.14.x
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/gup.c         | 44 ++++++++++++++++++++++++++++++++++++++------
 mm/huge_memory.c |  7 +++----
 2 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 12b9626b1a9e..cfe0a56f8e27 100644
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
@@ -694,12 +703,18 @@ static long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
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
@@ -1796,6 +1811,10 @@ bool gup_fast_permitted(unsigned long start, int nr_pages, int write)
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
@@ -1823,6 +1842,12 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
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
@@ -1868,9 +1893,16 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
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
index 9dbfa7286c61..513f0cf173ad 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1367,13 +1367,12 @@ int do_huge_pmd_wp_page(struct vm_fault *vmf, pmd_t orig_pmd)
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
2.31.1.498.g6c1eba8ee3d-goog

