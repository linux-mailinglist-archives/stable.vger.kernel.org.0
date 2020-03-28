Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7DD196232
	for <lists+stable@lfdr.de>; Sat, 28 Mar 2020 00:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgC0X6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 19:58:04 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43686 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726071AbgC0X6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 19:58:04 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8CA50B503EC0D91486CF;
        Sat, 28 Mar 2020 07:58:00 +0800 (CST)
Received: from DESKTOP-27KDQMV.china.huawei.com (10.173.228.124) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Sat, 28 Mar 2020 07:57:52 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC:     <kvm@vger.kernel.org>, <arei.gonglei@huawei.com>,
        <weidong.huang@huawei.com>, <weifuqiang@huawei.com>,
        <kirill.shutemov@linux.intel.com>, Longpeng <longpeng2@huawei.com>,
        "Mike Kravetz" <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matthew Wilcox <willy@infradead.org>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        <stable@vger.kernel.org>
Subject: [PATCH RESEND v4] mm/hugetlb: fix a addressing exception caused by huge_pte_offset
Date:   Sat, 28 Mar 2020 07:57:48 +0800
Message-ID: <20200327235748.2048-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.173.228.124]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

Our machine encountered a panic(addressing exception) after run
for a long time and the calltrace is:
RIP: 0010:[<ffffffff9dff0587>]  [<ffffffff9dff0587>] hugetlb_fault+0x307/0xbe0
RSP: 0018:ffff9567fc27f808  EFLAGS: 00010286
RAX: e800c03ff1258d48 RBX: ffffd3bb003b69c0 RCX: e800c03ff1258d48
RDX: 17ff3fc00eda72b7 RSI: 00003ffffffff000 RDI: e800c03ff1258d48
RBP: ffff9567fc27f8c8 R08: e800c03ff1258d48 R09: 0000000000000080
R10: ffffaba0704c22a8 R11: 0000000000000001 R12: ffff95c87b4b60d8
R13: 00005fff00000000 R14: 0000000000000000 R15: ffff9567face8074
FS:  00007fe2d9ffb700(0000) GS:ffff956900e40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffd3bb003b69c0 CR3: 000000be67374000 CR4: 00000000003627e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 [<ffffffff9df9b71b>] ? unlock_page+0x2b/0x30
 [<ffffffff9dff04a2>] ? hugetlb_fault+0x222/0xbe0
 [<ffffffff9dff1405>] follow_hugetlb_page+0x175/0x540
 [<ffffffff9e15b825>] ? cpumask_next_and+0x35/0x50
 [<ffffffff9dfc7230>] __get_user_pages+0x2a0/0x7e0
 [<ffffffff9dfc648d>] __get_user_pages_unlocked+0x15d/0x210
 [<ffffffffc068cfc5>] __gfn_to_pfn_memslot+0x3c5/0x460 [kvm]
 [<ffffffffc06b28be>] try_async_pf+0x6e/0x2a0 [kvm]
 [<ffffffffc06b4b41>] tdp_page_fault+0x151/0x2d0 [kvm]
 ...
 [<ffffffffc06a6f90>] kvm_arch_vcpu_ioctl_run+0x330/0x490 [kvm]
 [<ffffffffc068d919>] kvm_vcpu_ioctl+0x309/0x6d0 [kvm]
 [<ffffffff9deaa8c2>] ? dequeue_signal+0x32/0x180
 [<ffffffff9deae34d>] ? do_sigtimedwait+0xcd/0x230
 [<ffffffff9e03aed0>] do_vfs_ioctl+0x3f0/0x540
 [<ffffffff9e03b0c1>] SyS_ioctl+0xa1/0xc0
 [<ffffffff9e53879b>] system_call_fastpath+0x22/0x27

For 1G hugepages, huge_pte_offset() wants to return NULL or pudp, but it
may return a wrong 'pmdp' if there is a race. Please look at the following
code snippet:
    ...
    pud = pud_offset(p4d, addr);
    if (sz != PUD_SIZE && pud_none(*pud))
        return NULL;
    /* hugepage or swap? */
    if (pud_huge(*pud) || !pud_present(*pud))
        return (pte_t *)pud;

    pmd = pmd_offset(pud, addr);
    if (sz != PMD_SIZE && pmd_none(*pmd))
        return NULL;
    /* hugepage or swap? */
    if (pmd_huge(*pmd) || !pmd_present(*pmd))
        return (pte_t *)pmd;
    ...

The following sequence would trigger this bug:
1. CPU0: sz = PUD_SIZE and *pud = 0 , continue
1. CPU0: "pud_huge(*pud)" is false
2. CPU1: calling hugetlb_no_page and set *pud to xxxx8e7(PRESENT)
3. CPU0: "!pud_present(*pud)" is false, continue
4. CPU0: pmd = pmd_offset(pud, addr) and maybe return a wrong pmdp
However, we want CPU0 to return NULL or pudp in this case.

Also, according to the section 'COMPILER BARRIER' of memory-barriers.txt:
'''
 (*) The compiler is within its rights to reorder loads and stores
     to the same variable, and in some cases, the CPU is within its
     rights to reorder loads to the same variable.  This means that
     the following code:

        a[0] = x;
        a[1] = x;

     Might result in an older value of x stored in a[1] than in a[0].
'''
there're several other data races in huge_pte_offset, for example:
'''
  p4d = p4d_offset(pgd, addr)
  if (!p4d_present(*p4d))
      return NULL;
  pud = pud_offset(p4d, addr) <-- will be unwinded as:
    pud = (pud_t *)p4d_page_vaddr(*p4d) + pud_index(address);
'''
which is free for the compiler/CPU to execute as:
'''
  p4d = p4d_offset(pgd, addr)
  p4d_for_vaddr = *p4d;
  if (!p4d_present(*p4d))
      return NULL;
  pud = (pud_t *)p4d_page_vaddr(p4d_for_vaddr) + pud_index(address);
'''
so in the case where *p4d goes from '!present' to 'present':
p4d_present(*p4d) == true and p4d_for_vaddr == none, meaning the
p4d_page_vaddr() will crash.

For these reasons, we must make sure there is exactly one dereference of
p4d, pud and pmd.

Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: stable@vger.kernel.org
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Longpeng <longpeng2@huawei.com>
---
v3 -> v4:
  fix a typo s/p4g/p4d.  [Jason]
v2 -> v3:
  make sure p4d/pud/pmd be dereferenced once. [Jason]
---
 mm/hugetlb.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index dd8737a..d4fab68 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4909,29 +4909,33 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
 		       unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
+	p4d_t *p4d, p4d_entry;
+	pud_t *pud, pud_entry;
+	pmd_t *pmd, pmd_entry;
 
 	pgd = pgd_offset(mm, addr);
 	if (!pgd_present(*pgd))
 		return NULL;
-	p4d = p4d_offset(pgd, addr);
-	if (!p4d_present(*p4d))
+
+	p4d = p4d_offset(pgd, addr);
+	p4d_entry = READ_ONCE(*p4d);
+	if (!p4d_present(p4d_entry))
 		return NULL;
 
-	pud = pud_offset(p4d, addr);
-	if (sz != PUD_SIZE && pud_none(*pud))
+	pud = pud_offset(&p4d_entry, addr);
+	pud_entry = READ_ONCE(*pud);
+	if (sz != PUD_SIZE && pud_none(pud_entry))
 		return NULL;
 	/* hugepage or swap? */
-	if (pud_huge(*pud) || !pud_present(*pud))
+	if (pud_huge(pud_entry) || !pud_present(pud_entry))
 		return (pte_t *)pud;
 
-	pmd = pmd_offset(pud, addr);
-	if (sz != PMD_SIZE && pmd_none(*pmd))
+	pmd = pmd_offset(&pud_entry, addr);
+	pmd_entry = READ_ONCE(*pmd);
+	if (sz != PMD_SIZE && pmd_none(pmd_entry))
 		return NULL;
 	/* hugepage or swap? */
-	if (pmd_huge(*pmd) || !pmd_present(*pmd))
+	if (pmd_huge(pmd_entry) || !pmd_present(pmd_entry))
 		return (pte_t *)pmd;
 
 	return NULL;
-- 
1.8.3.1

