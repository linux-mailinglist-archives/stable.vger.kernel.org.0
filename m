Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 429DFE234E
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 21:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404741AbfJWT2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 15:28:45 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:45503 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403801AbfJWT2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 15:28:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Tg.XfEi_1571858915;
Received: from e19h19392.et15sqa.tbsite.net(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0Tg.XfEi_1571858915)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Oct 2019 03:28:42 +0800
From:   Yang Shi <yang.shi@linux.alibaba.com>
To:     hughd@google.com, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com, willy@infradead.org,
        gavin.dg@linux.alibaba.com, akpm@linux-foundation.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [v3 PATCH] mm: thp: handle page cache THP correctly in PageTransCompoundMap
Date:   Thu, 24 Oct 2019 03:28:35 +0800
Message-Id: <1571858915-72362-1-git-send-email-yang.shi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We have usecase to use tmpfs as QEMU memory backend and we would like to
take the advantage of THP as well.  But, our test shows the EPT is not
PMD mapped even though the underlying THP are PMD mapped on host.
The number showed by /sys/kernel/debug/kvm/largepage is much less than
the number of PMD mapped shmem pages as the below:

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
thp: kvm: fix memory corruption in KVM with THP enabled") checks if
there is a single PTE mapping on the page for anonymous THP when
setting up EPT map.  But, the _mapcount < 0 check doesn't fit to page
cache THP since every subpage of page cache THP would get _mapcount
inc'ed once it is PMD mapped, so PageTransCompoundMap() always returns
false for page cache THP.  This would prevent KVM from setting up PMD
mapped EPT entry.

So we need handle page cache THP correctly.  However, when page cache
THP's PMD gets split, kernel just remove the map instead of setting up
PTE map like what anonymous THP does.  Before KVM calls get_user_pages()
the subpages may get PTE mapped even though it is still a THP since the
page cache THP may be mapped by other processes at the mean time.

Checking its _mapcount and whether the THP has PTE mapped or not.
Although this may report some false negative cases (PTE mapped by other
processes), it looks not trivial to make this accurate.

With this fix /sys/kernel/debug/kvm/largepage would show reasonable
pages are PMD mapped by EPT as the below:

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

Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reported-by: Gang Deng <gavin.dg@linux.alibaba.com>
Tested-by: Gang Deng <gavin.dg@linux.alibaba.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org> 4.8+
---
v3: Took the suggestion from Willy to move the definition of
    compound_mapcount_ptr to mm_types.h in order to use it instead of
    open coding it.
v2: Adopted the suggestion from Hugh to use _mapcount and compound_mapcount.
    But I just open coding compound_mapcount to avoid duplicating the
    definition of compound_mapcount_ptr in two different files.  Since
    "compound_mapcount" looks self-explained so I'm supposed the open
    coding would not affect the readability.

 include/linux/mm.h         |  5 -----
 include/linux/mm_types.h   |  5 +++++
 include/linux/page-flags.h | 22 ++++++++++++++++++++--
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cc29227..a2adf95 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -695,11 +695,6 @@ static inline void *kvcalloc(size_t n, size_t size, gfp_t flags)
 
 extern void kvfree(const void *addr);
 
-static inline atomic_t *compound_mapcount_ptr(struct page *page)
-{
-	return &page[1].compound_mapcount;
-}
-
 static inline int compound_mapcount(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 2222fa7..270aa8f 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
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
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f91cb88..e0f2d53 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -622,12 +622,30 @@ static inline int PageTransCompound(struct page *page)
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
+ * compound_mapcount ot filter out PTE mapped case.
  */
 static inline int PageTransCompoundMap(struct page *page)
 {
-	return PageTransCompound(page) && atomic_read(&page->_mapcount) < 0;
+	struct page *head;
+	int map_count;
+
+	if (!PageTransCompound(page))
+		return 0;
+
+	if (PageAnon(page))
+		return atomic_read(&page->_mapcount) < 0;
+
+	head = compound_head(page);
+	map_count = atomic_read(&page->_mapcount);
+	/* File THP is PMD mapped and not double mapped */
+	return map_count >= 0 &&
+	       map_count == atomic_read(compound_mapcount_ptr(head));
 }
 
 /*
-- 
1.8.3.1

