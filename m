Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D851A70F8C
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 05:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387882AbfGWDIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 23:08:42 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:12328 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387875AbfGWDIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 23:08:41 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 22 Jul 2019 20:08:22 -0700
Received: from akaher-lnx-dev.eng.vmware.com (unknown [10.110.19.203])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 10E83B24DB;
        Mon, 22 Jul 2019 23:08:34 -0400 (EDT)
From:   Ajay Kaher <akaher@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <torvalds@linux-foundation.org>, <aarcange@redhat.com>,
        <hughd@google.com>, <dave.hansen@intel.com>, <mgorman@suse.de>,
        <riel@redhat.com>, <mhocko@suse.cz>, <jannh@google.com>,
        <linux-kernel@vger.kernel.org>, <stable@kernel.org>,
        <stable@vger.kernel.org>, <srivatsab@vmware.com>,
        <srivatsa@csail.mit.edu>, <amakhalov@vmware.com>,
        <srinidhir@vmware.com>, <bvikas@vmware.com>, <srostedt@vmware.com>,
        <akaher@vmware.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Steve Capper <steve.capper@linaro.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/8] mm: handle PTE-mapped tail pages in gerneric fast gup implementaiton
Date:   Tue, 23 Jul 2019 16:38:26 +0530
Message-ID: <1563880111-19058-4-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563880111-19058-1-git-send-email-akaher@vmware.com>
References: <1563880111-19058-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

commit 7aef4172c7957d7e65fc172be4c99becaef855d4 upstream.

With new refcounting we are going to see THP tail pages mapped with PTE.
Generic fast GUP rely on page_cache_get_speculative() to obtain
reference on page.  page_cache_get_speculative() always fails on tail
pages, because ->_count on tail pages is always zero.

Let's handle tail pages in gup_pte_range().

New split_huge_page() will rely on migration entries to freeze page's
counts.  Recheck PTE value after page_cache_get_speculative() on head
page should be enough to serialize against split.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
 mm/gup.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 2cd3b31..45c544b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1070,7 +1070,7 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 		 * for an example see gup_get_pte in arch/x86/mm/gup.c
 		 */
 		pte_t pte = READ_ONCE(*ptep);
-		struct page *page;
+		struct page *head, *page;
 
 		/*
 		 * Similar to the PMD case below, NUMA hinting must take slow
@@ -1082,15 +1082,17 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
+		head = compound_head(page);
 
-		if (!page_cache_get_speculative(page))
+		if (!page_cache_get_speculative(head))
 			goto pte_unmap;
 
 		if (unlikely(pte_val(pte) != pte_val(*ptep))) {
-			put_page(page);
+			put_page(head);
 			goto pte_unmap;
 		}
 
+		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		(*nr)++;
 
-- 
2.7.4

