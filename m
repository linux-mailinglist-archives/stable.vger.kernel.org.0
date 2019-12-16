Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE123120610
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 13:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfLPMpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 07:45:36 -0500
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:17080 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727553AbfLPMpg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 07:45:36 -0500
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 16 Dec 2019 04:45:34 -0800
Received: from akaher-lnx-dev.eng.vmware.com (unknown [10.110.19.203])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id D7242401F4;
        Mon, 16 Dec 2019 04:45:29 -0800 (PST)
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
        Jann Horn <jannh@google.com>, <stable@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v3 2/8] mm: add 'try_get_page()' helper function
Date:   Tue, 17 Dec 2019 02:15:42 +0530
Message-ID: <1576529149-14269-3-git-send-email-akaher@vmware.com>
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

commit 88b1a17dfc3ed7728316478fae0f5ad508f50397 upsteam.

This is the same as the traditional 'get_page()' function, but instead
of unconditionally incrementing the reference count of the page, it only
does so if the count was "safe".  It returns whether the reference count
was incremented (and is marked __must_check, since the caller obviously
has to be aware of it).

Also like 'get_page()', you can't use this function unless you already
had a reference to the page.  The intent is that you can use this
exactly like get_page(), but in situations where you want to limit the
maximum reference count.

The code currently does an unconditional WARN_ON_ONCE() if we ever hit
the reference count issues (either zero or negative), as a notification
that the conditional non-increment actually happened.

NOTE! The count access for the "safety" check is inherently racy, but
that doesn't matter since the buffer we use is basically half the range
of the reference count (ie we look at the sign of the count).

Acked-by: Matthew Wilcox <willy@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ 4.4.y backport notes:
  Srivatsa:
  - Adapted try_get_page() to match the get_page()
    implementation in 4.4.y, except for the refcount check.
  - Added try_get_page_foll() which will be needed
    in a subsequent patch. ]
Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/mm.h | 12 ++++++++++++
 mm/internal.h      | 23 +++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 701088e..52edaf1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -505,6 +505,18 @@ static inline void get_page(struct page *page)
 	atomic_inc(&page->_count);
 }
 
+static inline __must_check bool try_get_page(struct page *page)
+{
+	if (unlikely(PageTail(page)))
+		if (likely(__get_page_tail(page)))
+			return true;
+
+	if (WARN_ON_ONCE(atomic_read(&page->_count) <= 0))
+		return false;
+	atomic_inc(&page->_count);
+	return true;
+}
+
 static inline struct page *virt_to_head_page(const void *x)
 {
 	struct page *page = virt_to_page(x);
diff --git a/mm/internal.h b/mm/internal.h
index 67015e5..d83afc9 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -112,6 +112,29 @@ static inline void get_page_foll(struct page *page)
 	}
 }
 
+static inline __must_check bool try_get_page_foll(struct page *page)
+{
+	if (unlikely(PageTail(page))) {
+		if (WARN_ON_ONCE(atomic_read(&compound_head(page)->_count) <= 0))
+			return false;
+		/*
+		 * This is safe only because
+		 * __split_huge_page_refcount() can't run under
+		 * get_page_foll() because we hold the proper PT lock.
+		 */
+		__get_page_tail_foll(page, true);
+	} else {
+		/*
+		 * Getting a normal page or the head of a compound page
+		 * requires to already have an elevated page->_count.
+		 */
+		if (WARN_ON_ONCE(atomic_read(&page->_count) <= 0))
+			return false;
+		atomic_inc(&page->_count);
+	}
+	return true;
+}
+
 extern unsigned long highest_memmap_pfn;
 
 /*
-- 
2.7.4

