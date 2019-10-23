Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBBC6E215E
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 19:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfJWRFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 13:05:17 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:38061 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726812AbfJWRFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 13:05:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04446;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Tg.1n3m_1571850304;
Received: from e19h19392.et15sqa.tbsite.net(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0Tg.1n3m_1571850304)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Oct 2019 01:05:15 +0800
From:   Yang Shi <yang.shi@linux.alibaba.com>
To:     hughd@google.com, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com, gavin.dg@linux.alibaba.com,
        akpm@linux-foundation.org
Cc:     yang.shi@linux.alibaba.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [v2 PATCH] mm: thp: handle page cache THP correctly in PageTransCompoundMap
Date:   Thu, 24 Oct 2019 01:05:04 +0800
Message-Id: <1571850304-82802-1-git-send-email-yang.shi@linux.alibaba.com>
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
Cc: <stable@vger.kernel.org> 4.8+
---
v2: Adopted the suggestion from Hugh to use _mapcount and compound_mapcount.
    But I just open coding compound_mapcount to avoid duplicating the
    definition of compound_mapcount_ptr in two different files.  Since
    "compound_mapcount" looks self-explained so I'm supposed the open
    coding would not affect the readability.

 include/linux/page-flags.h | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f91cb88..954a877 100644
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
+	       map_count == atomic_read(&head[1].compound_mapcount);
 }
 
 /*
-- 
1.8.3.1

