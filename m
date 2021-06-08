Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A117F3A00FF
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbhFHSuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:50:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235615AbhFHSrI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:47:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4177761406;
        Tue,  8 Jun 2021 18:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177479;
        bh=BtUMkyt4Ii44XjnnzVn2lkfQX5Yt3RcOKD83rvHMfwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJ5V0M499dVw/fEoAIYOEqUD9x2ZJblacjDMKxS0f5CXm9Sh2XjpLmuwZCHf+fDpv
         9uMwtUS3fJT8slXLBim87uDPX8fJNSydMqUnlTt5Hr5Gw3skCAHakK+/oS2mCvUnQS
         sZw8v8xrcw6M6tf6EYrD3RDMaO8LFOXbxa1nFCNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        William Kucharski <william.kucharski@oracle.com>,
        Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 65/78] mm: add thp_order
Date:   Tue,  8 Jun 2021 20:27:34 +0200
Message-Id: <20210608175937.462236794@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/huge_mm.h |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -231,6 +231,19 @@ static inline spinlock_t *pud_trans_huge
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
@@ -290,6 +303,12 @@ static inline struct list_head *page_def
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


