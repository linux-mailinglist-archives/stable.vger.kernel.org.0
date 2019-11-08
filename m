Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2171F4382
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 10:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731194AbfKHJi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 04:38:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:39608 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730005AbfKHJi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 04:38:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 56883AC79;
        Fri,  8 Nov 2019 09:38:24 +0000 (UTC)
From:   Vlastimil Babka <vbabka@suse.cz>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ajay Kaher <akaher@vmware.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jann Horn <jannh@google.com>, stable@kernel.org,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH STABLE 4.4 3/8] mm: make page ref count overflow check tighter and more explicit
Date:   Fri,  8 Nov 2019 10:38:09 +0100
Message-Id: <20191108093814.16032-4-vbabka@suse.cz>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108093814.16032-1-vbabka@suse.cz>
References: <20191108093814.16032-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit f958d7b528b1b40c44cfda5eabe2d82760d868c3 upstream.

[ 4.4 backport: page_ref_count() doesn't exist, introduce it to reduce churn.
		Change also two similar checks in mm/internal.h		  ]

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
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/mm.h | 11 ++++++++++-
 mm/internal.h      |  5 +++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ed653ba47c46..997edfcb0a30 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -488,6 +488,15 @@ static inline void get_huge_page_tail(struct page *page)
 
 extern bool __get_page_tail(struct page *page);
 
+static inline int page_ref_count(struct page *page)
+{
+	return atomic_read(&page->_count);
+}
+
+/* 127: arbitrary random number, small enough to assemble well */
+#define page_ref_zero_or_close_to_overflow(page) \
+	((unsigned int) page_ref_count(page) + 127u <= 127u)
+
 static inline void get_page(struct page *page)
 {
 	if (unlikely(PageTail(page)))
@@ -497,7 +506,7 @@ static inline void get_page(struct page *page)
 	 * Getting a normal page or the head of a compound page
 	 * requires to already have an elevated page->_count.
 	 */
-	VM_BUG_ON_PAGE(atomic_read(&page->_count) <= 0, page);
+	VM_BUG_ON_PAGE(page_ref_zero_or_close_to_overflow(page), page);
 	atomic_inc(&page->_count);
 }
 
diff --git a/mm/internal.h b/mm/internal.h
index f63f4393d633..a6639c72780a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -81,7 +81,8 @@ static inline void __get_page_tail_foll(struct page *page,
 	 * speculative page access (like in
 	 * page_cache_get_speculative()) on tail pages.
 	 */
-	VM_BUG_ON_PAGE(atomic_read(&compound_head(page)->_count) <= 0, page);
+	VM_BUG_ON_PAGE(page_ref_zero_or_close_to_overflow(compound_head(page)),
+									page);
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
2.23.0

