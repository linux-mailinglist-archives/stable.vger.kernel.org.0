Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57110F3CF6
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 01:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfKHAiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 19:38:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:57466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfKHAiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 19:38:50 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6D642084C;
        Fri,  8 Nov 2019 00:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573173524;
        bh=uEWQ6PdVtRrEM2OyvCuI0tFDyh5KlV6A08g/dWGIVgc=;
        h=Date:From:To:Subject:From;
        b=ocaqBL3y9mpJ3NnjEe+ysTI5Bue2tPMHelDjmfVVgJvOuKxYVx0ruF391Ju043eUP
         5HcqaVjAiVqLNG3gvbc2c+Hj86xqt/lHfEYHG0dKh5Fui931R8eZWxTEpGTbjBnJIy
         UqVsVPtdDFshSYuSY44Hk9NsggPLGGXpzD134McQ=
Date:   Thu, 07 Nov 2019 16:38:43 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, gavin.dg@linux.alibaba.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [merged]
 mm-thp-handle-page-cache-thp-correctly-in-pagetranscompoundmap.patch
 removed from -mm tree
Message-ID: <20191108003843.fTT4wpOB-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: thp: handle page cache THP correctly in PageTransCompoundMap
has been removed from the -mm tree.  Its filename was
     mm-thp-handle-page-cache-thp-correctly-in-pagetranscompoundmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: thp: handle page cache THP correctly in PageTransCompoundMap

We have a usecase to use tmpfs as QEMU memory backend and we would like to
take the advantage of THP as well.  But, our test shows the EPT is not PMD
mapped even though the underlying THP are PMD mapped on host.  The number
showed by /sys/kernel/debug/kvm/largepage is much less than the number of
PMD mapped shmem pages as the below:

7f2778200000-7f2878200000 rw-s 00000000 00:14 262232 /dev/shm/qemu_back_mem.mem.Hz2hSf (deleted)
Size:            4194304 kB
[snip]
AnonHugePages:         0 kB
ShmemPmdMapped:   579584 kB
[snip]
Locked:                0 kB

cat /sys/kernel/debug/kvm/largepages
12

And some benchmarks do worse than with anonymous THPs.

By digging into the code we figured out that commit 127393fbe597 ("mm:
thp: kvm: fix memory corruption in KVM with THP enabled") checks if there
is a single PTE mapping on the page for anonymous THP when setting up EPT
map.  But, the _mapcount < 0 check doesn't fit to page cache THP since
every subpage of page cache THP would get _mapcount inc'ed once it is PMD
mapped, so PageTransCompoundMap() always returns false for page cache THP.
This would prevent KVM from setting up PMD mapped EPT entry.

So we need handle page cache THP correctly.  However, when page cache
THP's PMD gets split, kernel just remove the map instead of setting up PTE
map like what anonymous THP does.  Before KVM calls get_user_pages() the
subpages may get PTE mapped even though it is still a THP since the page
cache THP may be mapped by other processes at the mean time.

Checking its _mapcount and whether the THP has PTE mapped or not. 
Although this may report some false negative cases (PTE mapped by other
processes), it looks not trivial to make this accurate.

With this fix /sys/kernel/debug/kvm/largepage would show reasonable pages
are PMD mapped by EPT as the below:

7fbeaee00000-7fbfaee00000 rw-s 00000000 00:14 275464 /dev/shm/qemu_back_mem.mem.SKUvat (deleted)
Size:            4194304 kB
[snip]
AnonHugePages:         0 kB
ShmemPmdMapped:   557056 kB
[snip]
Locked:                0 kB

cat /sys/kernel/debug/kvm/largepages
271

And the benchmarks are as same as anonymous THPs.

[yang.shi@linux.alibaba.com: v4]
  Link: http://lkml.kernel.org/r/1571865575-42913-1-git-send-email-yang.shi@linux.alibaba.com
Link: http://lkml.kernel.org/r/1571769577-89735-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: dd78fedde4b9 ("rmap: support file thp")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reported-by: Gang Deng <gavin.dg@linux.alibaba.com>
Tested-by: Gang Deng <gavin.dg@linux.alibaba.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>	[4.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h         |    5 -----
 include/linux/mm_types.h   |    5 +++++
 include/linux/page-flags.h |   20 ++++++++++++++++++--
 3 files changed, 23 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-thp-handle-page-cache-thp-correctly-in-pagetranscompoundmap
+++ a/include/linux/mm.h
@@ -695,11 +695,6 @@ static inline void *kvcalloc(size_t n, s
 
 extern void kvfree(const void *addr);
 
-static inline atomic_t *compound_mapcount_ptr(struct page *page)
-{
-	return &page[1].compound_mapcount;
-}
-
 static inline int compound_mapcount(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
--- a/include/linux/mm_types.h~mm-thp-handle-page-cache-thp-correctly-in-pagetranscompoundmap
+++ a/include/linux/mm_types.h
@@ -221,6 +221,11 @@ struct page {
 #endif
 } _struct_page_alignment;
 
+static inline atomic_t *compound_mapcount_ptr(struct page *page)
+{
+	return &page[1].compound_mapcount;
+}
+
 /*
  * Used for sizing the vmemmap region on some architectures
  */
--- a/include/linux/page-flags.h~mm-thp-handle-page-cache-thp-correctly-in-pagetranscompoundmap
+++ a/include/linux/page-flags.h
@@ -622,12 +622,28 @@ static inline int PageTransCompound(stru
  *
  * Unlike PageTransCompound, this is safe to be called only while
  * split_huge_pmd() cannot run from under us, like if protected by the
- * MMU notifier, otherwise it may result in page->_mapcount < 0 false
+ * MMU notifier, otherwise it may result in page->_mapcount check false
  * positives.
+ *
+ * We have to treat page cache THP differently since every subpage of it
+ * would get _mapcount inc'ed once it is PMD mapped.  But, it may be PTE
+ * mapped in the current process so comparing subpage's _mapcount to
+ * compound_mapcount to filter out PTE mapped case.
  */
 static inline int PageTransCompoundMap(struct page *page)
 {
-	return PageTransCompound(page) && atomic_read(&page->_mapcount) < 0;
+	struct page *head;
+
+	if (!PageTransCompound(page))
+		return 0;
+
+	if (PageAnon(page))
+		return atomic_read(&page->_mapcount) < 0;
+
+	head = compound_head(page);
+	/* File THP is PMD mapped and not PTE mapped */
+	return atomic_read(&page->_mapcount) ==
+	       atomic_read(compound_mapcount_ptr(head));
 }
 
 /*
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-mempolicy-fix-the-wrong-return-value-and-potential-pages-leak-of-mbind.patch
mm-rmap-use-vm_bug_on-in-__page_check_anon_rmap.patch
mm-vmscan-remove-unused-scan_control-parameter-from-pageout.patch

