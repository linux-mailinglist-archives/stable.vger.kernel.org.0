Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 824E312060F
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 13:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfLPMp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 07:45:29 -0500
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:17063 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727553AbfLPMp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 07:45:28 -0500
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 16 Dec 2019 04:45:26 -0800
Received: from akaher-lnx-dev.eng.vmware.com (unknown [10.110.19.203])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 44C1F4018C;
        Mon, 16 Dec 2019 04:45:22 -0800 (PST)
From:   Ajay Kaher <akaher@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <torvalds@linux-foundation.org>, <punit.agrawal@arm.com>,
        <akpm@linux-foundation.org>, <kirill.shutemov@linux.intel.com>,
        <willy@infradead.org>, <will.deacon@arm.com>,
        <mszeredi@redhat.com>, <stable@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <srivatsab@vmware.com>, <srivatsa@csail.mit.edu>,
        <amakhalov@vmware.com>, <srinidhir@vmware.com>,
        <bvikas@vmware.com>, <anishs@vmware.com>, <vsirnapalli@vmware.com>,
        <srostedt@vmware.com>, <akaher@vmware.com>,
        Jann Horn <jannh@google.com>, <stable@kernel.org>
Subject: [PATCH v3 1/8] mm: make page ref count overflow check tighter and more explicit
Date:   Tue, 17 Dec 2019 02:15:41 +0530
Message-ID: <1576529149-14269-2-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576529149-14269-1-git-send-email-akaher@vmware.com>
References: <1576529149-14269-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit f958d7b528b1b40c44cfda5eabe2d82760d868c3 upsteam.

We have a VM_BUG_ON() to check that the page reference count doesn't
underflow (or get close to overflow) by checking the sign of the count.

That's all fine, but we actually want to allow people to use a "get page
ref unless it's already very high" helper function, and we want that one
to use the sign of the page ref (without triggering this VM_BUG_ON).

Change the VM_BUG_ON to only check for small underflows (or _very_ close
to overflowing), and ignore overflows which have strayed into negative
territory.

Acked-by: Matthew Wilcox <willy@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ 4.4.y backport notes:
  Ajay: Open-coded atomic refcount access due to missing
  page_ref_count() helper in 4.4.y
  Srivatsa: Added overflow check to get_page_foll() and related code. ]
Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
 include/linux/mm.h | 6 +++++-
 mm/internal.h      | 5 +++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ed653ba..701088e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -488,6 +488,10 @@ static inline void get_huge_page_tail(struct page *page)
 
 extern bool __get_page_tail(struct page *page);
 
+/* 127: arbitrary random number, small enough to assemble well */
+#define page_ref_zero_or_close_to_overflow(page) \
+	((unsigned int) atomic_read(&page->_count) + 127u <= 127u)
+
 static inline void get_page(struct page *page)
 {
 	if (unlikely(PageTail(page)))
@@ -497,7 +501,7 @@ static inline void get_page(struct page *page)
 	 * Getting a normal page or the head of a compound page
 	 * requires to already have an elevated page->_count.
 	 */
-	VM_BUG_ON_PAGE(atomic_read(&page->_count) <= 0, page);
+	VM_BUG_ON_PAGE(page_ref_zero_or_close_to_overflow(page), page);
 	atomic_inc(&page->_count);
 }
 
diff --git a/mm/internal.h b/mm/internal.h
index f63f439..67015e5 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -81,7 +81,8 @@ static inline void __get_page_tail_foll(struct page *page,
 	 * speculative page access (like in
 	 * page_cache_get_speculative()) on tail pages.
 	 */
-	VM_BUG_ON_PAGE(atomic_read(&compound_head(page)->_count) <= 0, page);
+	VM_BUG_ON_PAGE(page_ref_zero_or_close_to_overflow(compound_head(page)),
+		       page);
 	if (get_page_head)
 		atomic_inc(&compound_head(page)->_count);
 	get_huge_page_tail(page);
@@ -106,7 +107,7 @@ static inline void get_page_foll(struct page *page)
 		 * Getting a normal page or the head of a compound page
 		 * requires to already have an elevated page->_count.
 		 */
-		VM_BUG_ON_PAGE(atomic_read(&page->_count) <= 0, page);
+		VM_BUG_ON_PAGE(page_ref_zero_or_close_to_overflow(page), page);
 		atomic_inc(&page->_count);
 	}
 }
-- 
2.7.4

