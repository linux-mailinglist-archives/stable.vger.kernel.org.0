Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F4FE0B8C
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 20:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbfJVSjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 14:39:48 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:34748 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727851AbfJVSjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Oct 2019 14:39:48 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07487;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Tfw2B3M_1571769577;
Received: from e19h19392.et15sqa.tbsite.net(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0Tfw2B3M_1571769577)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 23 Oct 2019 02:39:44 +0800
From:   Yang Shi <yang.shi@linux.alibaba.com>
To:     aarcange@redhat.com, kirill.shutemov@linux.intel.com,
        hughd@google.com, gavin.dg@linux.alibaba.com,
        akpm@linux-foundation.org
Cc:     yang.shi@linux.alibaba.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] mm: thp: handle page cache THP correctly in PageTransCompoundMap
Date:   Wed, 23 Oct 2019 02:39:37 +0800
Message-Id: <1571769577-89735-1-git-send-email-yang.shi@linux.alibaba.com>
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

Checking its _mapcount and whether the THP is double mapped or not since
we can't tell if the single PTE mapping comes from the current process
or not by _mapcount.  Although this may report some false negative cases
(PTE mapped by other processes), it looks not trivial to make this
accurate.

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
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org> 4.8+
---
 include/linux/page-flags.h | 54 ++++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f91cb88..3b8e5c5 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -610,27 +610,6 @@ static inline int PageTransCompound(struct page *page)
 }
 
 /*
- * PageTransCompoundMap is the same as PageTransCompound, but it also
- * guarantees the primary MMU has the entire compound page mapped
- * through pmd_trans_huge, which in turn guarantees the secondary MMUs
- * can also map the entire compound page. This allows the secondary
- * MMUs to call get_user_pages() only once for each compound page and
- * to immediately map the entire compound page with a single secondary
- * MMU fault. If there will be a pmd split later, the secondary MMUs
- * will get an update through the MMU notifier invalidation through
- * split_huge_pmd().
- *
- * Unlike PageTransCompound, this is safe to be called only while
- * split_huge_pmd() cannot run from under us, like if protected by the
- * MMU notifier, otherwise it may result in page->_mapcount < 0 false
- * positives.
- */
-static inline int PageTransCompoundMap(struct page *page)
-{
-	return PageTransCompound(page) && atomic_read(&page->_mapcount) < 0;
-}
-
-/*
  * PageTransTail returns true for both transparent huge pages
  * and hugetlbfs pages, so it should only be called when it's known
  * that hugetlbfs pages aren't involved.
@@ -681,6 +660,39 @@ static inline int TestClearPageDoubleMap(struct page *page)
 	return test_and_clear_bit(PG_double_map, &page[1].flags);
 }
 
+/*
+ * PageTransCompoundMap is the same as PageTransCompound, but it also
+ * guarantees the primary MMU has the entire compound page mapped
+ * through pmd_trans_huge, which in turn guarantees the secondary MMUs
+ * can also map the entire compound page. This allows the secondary
+ * MMUs to call get_user_pages() only once for each compound page and
+ * to immediately map the entire compound page with a single secondary
+ * MMU fault. If there will be a pmd split later, the secondary MMUs
+ * will get an update through the MMU notifier invalidation through
+ * split_huge_pmd().
+ *
+ * Unlike PageTransCompound, this is safe to be called only while
+ * split_huge_pmd() cannot run from under us, like if protected by the
+ * MMU notifier, otherwise it may result in page->_mapcount check false
+ * positives.
+ *
+ * We have to treat page cache THP differently since every subpage of it
+ * would get _mapcount inc'ed once it is PMD mapped.  But, it may be PTE
+ * mapped in the current process so checking PageDoubleMap flag to rule
+ * this out.
+ */
+static inline int PageTransCompoundMap(struct page *page)
+{
+	bool pmd_mapped;
+
+	if (PageAnon(page))
+		pmd_mapped = atomic_read(&page->_mapcount) < 0;
+	else
+		pmd_mapped = atomic_read(&page->_mapcount) >= 0 &&
+			     !PageDoubleMap(compound_head(page));
+
+	return PageTransCompound(page) && pmd_mapped;
+}
 #else
 TESTPAGEFLAG_FALSE(TransHuge)
 TESTPAGEFLAG_FALSE(TransCompound)
-- 
1.8.3.1

