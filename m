Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 401941969BE
	for <lists+stable@lfdr.de>; Sat, 28 Mar 2020 23:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgC1WKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Mar 2020 18:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727461AbgC1WKK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Mar 2020 18:10:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F056520716;
        Sat, 28 Mar 2020 22:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585433409;
        bh=vevYlXcZkpJHh31WS28GBKwYWP3pIrDL6PTJ1dN+AMY=;
        h=Date:From:To:Subject:From;
        b=afrNd/rX8NNS/mQXQJPudFFm+QBD4rt69hGXtrViI5iS+5tgYVuqEUt6IOvvf86oH
         gXerTRZl+k0IkhIxFm2qsCzgr7VJg+Cjjk/TtIXNuLAY3mn7+1v2sEHG6ItrIsG+rw
         oyQ40hKXmt5VgtnFEZxwCI2PwmZcW3bwNGKEDarY=
Date:   Sat, 28 Mar 2020 15:10:08 -0700
From:   akpm@linux-foundation.org
To:     jgg@ziepe.ca, longpeng2@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, sean.j.christopherson@intel.com,
        stable@vger.kernel.org, willy@infradead.org
Subject:  +
 mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch added
 to -mm tree
Message-ID: <20200328221008.c6KdUoTLQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix a addressing exception caused by huge_pte_offset
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Longpeng <longpeng2@huawei.com>
Subject: mm/hugetlb: fix a addressing exception caused by huge_pte_offset

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

Link: http://lkml.kernel.org/r/20200327235748.2048-1-longpeng2@huawei.com
Signed-off-by: Longpeng <longpeng2@huawei.com>
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset
+++ a/mm/hugetlb.c
@@ -4909,29 +4909,33 @@ pte_t *huge_pte_offset(struct mm_struct
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
+
 	p4d = p4d_offset(pgd, addr);
-	if (!p4d_present(*p4d))
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
_

Patches currently in -mm which might be from longpeng2@huawei.com are

mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch

