Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2148CFF24
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 18:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfJHQoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 12:44:16 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:28986 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726239AbfJHQoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 12:44:16 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 8 Oct 2019 09:44:13 -0700
Received: from akaher-lnx-dev.eng.vmware.com (unknown [10.110.19.203])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 1580B40C00;
        Tue,  8 Oct 2019 09:44:08 -0700 (PDT)
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
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Hillf Danton <hillf.zj@alibaba-inc.com>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>
Subject: [PATCH v2 4/8] mm, gup: remove broken VM_BUG_ON_PAGE compound check for hugepages
Date:   Wed, 9 Oct 2019 06:14:19 +0530
Message-ID: <1570581863-12090-5-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570581863-12090-1-git-send-email-akaher@vmware.com>
References: <1570581863-12090-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit a3e328556d41bb61c55f9dfcc62d6a826ea97b85 upstream.

When operating on hugepages with DEBUG_VM enabled, the GUP code checks
the compound head for each tail page prior to calling
page_cache_add_speculative.  This is broken, because on the fast-GUP
path (where we don't hold any page table locks) we can be racing with a
concurrent invocation of split_huge_page_to_list.

split_huge_page_to_list deals with this race by using page_ref_freeze to
freeze the page and force concurrent GUPs to fail whilst the component
pages are modified.  This modification includes clearing the
compound_head field for the tail pages, so checking this prior to a
successful call to page_cache_add_speculative can lead to false
positives: In fact, page_cache_add_speculative *already* has this check
once the page refcount has been successfully updated, so we can simply
remove the broken calls to VM_BUG_ON_PAGE.

Link: http://lkml.kernel.org/r/20170522133604.11392-2-punit.agrawal@arm.com
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Acked-by: Steve Capper <steve.capper@arm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
 mm/gup.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 45c544b..6e7cfaa 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1136,7 +1136,6 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	tail = page;
 	do {
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		(*nr)++;
 		page++;
@@ -1183,7 +1182,6 @@ static int gup_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
 	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 	tail = page;
 	do {
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		(*nr)++;
 		page++;
@@ -1226,7 +1224,6 @@ static int gup_huge_pgd(pgd_t orig, pgd_t *pgdp, unsigned long addr,
 	page = head + ((addr & ~PGDIR_MASK) >> PAGE_SHIFT);
 	tail = page;
 	do {
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		(*nr)++;
 		page++;
-- 
2.7.4

