Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3728A39E812
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 22:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhFGULd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 16:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbhFGULc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 16:11:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC44C061574
        for <stable@vger.kernel.org>; Mon,  7 Jun 2021 13:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=UiKiWW1LfthVy/A1ybsLhvVtDVF7wlQtgYewKiQ7+Ok=; b=YDapLjKUdAqRB29Wq96R6ZF4oc
        P5dAAhC/cZtCbi7Six211o4pta5uQ05QYUwOKOdJq9WxAZw3jke7y/ESOtoQ/BeLUPYOkBmRmUWyF
        /MCBm9Akig/OkVK52uKjFX/jp4YBBnyveiyO1kaWk//APjgbCWL/BfrEYtnpTAQ8YdvXNy5ILEHQp
        vKCw/nseSvjKWh8cVQjMt7f+sGB+av/s7txBUQS3Z5wp/nJg55xLR+wckDguBUYzWxwK6mu995dx5
        ADOZ/yHRphK3rgs2tIscH8Bu7gejoEFw+vMe7KkHSWKdxlrBsYO77ijyppTEFeVlg3c4tC3jiwZLX
        Zx+ODxnQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lqLYb-00GCKu-Db; Mon, 07 Jun 2021 20:09:12 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        William Kucharski <william.kucharski@oracle.com>,
        Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/4] mm: add thp_order
Date:   Mon,  7 Jun 2021 21:08:42 +0100
Message-Id: <20210607200845.3860579-2-willy@infradead.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607200845.3860579-1-willy@infradead.org>
References: <20210607200845.3860579-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6ffbb45826f5d9ae09aa60cd88594b7816c96190 upstream

This function returns the order of a transparent huge page.  It compiles
to 0 if CONFIG_TRANSPARENT_HUGEPAGE is disabled.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Link: http://lkml.kernel.org/r/20200629151959.15779-4-willy@infradead.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/huge_mm.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 93d5cf0bc716..d8b86fd39113 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -231,6 +231,19 @@ static inline spinlock_t *pud_trans_huge_lock(pud_t *pud,
 	else
 		return NULL;
 }
+
+/**
+ * thp_order - Order of a transparent huge page.
+ * @page: Head page of a transparent huge page.
+ */
+static inline unsigned int thp_order(struct page *page)
+{
+	VM_BUG_ON_PGFLAGS(PageTail(page), page);
+	if (PageHead(page))
+		return HPAGE_PMD_ORDER;
+	return 0;
+}
+
 static inline int hpage_nr_pages(struct page *page)
 {
 	if (unlikely(PageTransHuge(page)))
@@ -290,6 +303,12 @@ static inline struct list_head *page_deferred_list(struct page *page)
 #define HPAGE_PUD_MASK ({ BUILD_BUG(); 0; })
 #define HPAGE_PUD_SIZE ({ BUILD_BUG(); 0; })
 
+static inline unsigned int thp_order(struct page *page)
+{
+	VM_BUG_ON_PGFLAGS(PageTail(page), page);
+	return 0;
+}
+
 #define hpage_nr_pages(x) 1
 
 static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
-- 
2.30.2

