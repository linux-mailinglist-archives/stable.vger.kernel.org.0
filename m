Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01171C16FB
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgEANzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730392AbgEANdM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:33:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94490208C3;
        Fri,  1 May 2020 13:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339992;
        bh=zUGitAkhB8RDiv7/HMq0FogI1jM8ADbhJB8eP1+L2C0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1zpk45CKhaj89k9QwcTtR9shz2PbJJklrAoYbvR5ZQLR5Fo18D1NTAwCpVdyDmbX3
         SRWLaDUkB60D7/xBZkVyISUHreIvevr3o5rGyriLNPdEPzgq3AzacLIAtcdGS7HAzp
         9t4bijjt/vkt6ijx9m4tfiOpHPp3J9KeJShJvNxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Longpeng <longpeng2@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 050/117] mm/hugetlb: fix a addressing exception caused by huge_pte_offset
Date:   Fri,  1 May 2020 15:21:26 +0200
Message-Id: <20200501131550.709834572@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

commit 3c1d7e6ccb644d517a12f73a7ff200870926f865 upstream.

Our machine encountered a panic(addressing exception) after run for a
long time and the calltrace is:

    RIP: hugetlb_fault+0x307/0xbe0
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
      follow_hugetlb_page+0x175/0x540
      __get_user_pages+0x2a0/0x7e0
      __get_user_pages_unlocked+0x15d/0x210
      __gfn_to_pfn_memslot+0x3c5/0x460 [kvm]
      try_async_pf+0x6e/0x2a0 [kvm]
      tdp_page_fault+0x151/0x2d0 [kvm]
     ...
      kvm_arch_vcpu_ioctl_run+0x330/0x490 [kvm]
      kvm_vcpu_ioctl+0x309/0x6d0 [kvm]
      do_vfs_ioctl+0x3f0/0x540
      SyS_ioctl+0xa1/0xc0
      system_call_fastpath+0x22/0x27

For 1G hugepages, huge_pte_offset() wants to return NULL or pudp, but it
may return a wrong 'pmdp' if there is a race.  Please look at the
following code snippet:

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

 - CPU0: sz = PUD_SIZE and *pud = 0 , continue
 - CPU0: "pud_huge(*pud)" is false
 - CPU1: calling hugetlb_no_page and set *pud to xxxx8e7(PRESENT)
 - CPU0: "!pud_present(*pud)" is false, continue
 - CPU0: pmd = pmd_offset(pud, addr) and maybe return a wrong pmdp

However, we want CPU0 to return NULL or pudp in this case.

We must make sure there is exactly one dereference of pud and pmd.

Signed-off-by: Longpeng <longpeng2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200413010342.771-1-longpeng2@huawei.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4745,8 +4745,8 @@ pte_t *huge_pte_offset(struct mm_struct
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
+	pud_t *pud, pud_entry;
+	pmd_t *pmd, pmd_entry;
 
 	pgd = pgd_offset(mm, addr);
 	if (!pgd_present(*pgd))
@@ -4756,17 +4756,19 @@ pte_t *huge_pte_offset(struct mm_struct
 		return NULL;
 
 	pud = pud_offset(p4d, addr);
-	if (sz != PUD_SIZE && pud_none(*pud))
+	pud_entry = READ_ONCE(*pud);
+	if (sz != PUD_SIZE && pud_none(pud_entry))
 		return NULL;
 	/* hugepage or swap? */
-	if (pud_huge(*pud) || !pud_present(*pud))
+	if (pud_huge(pud_entry) || !pud_present(pud_entry))
 		return (pte_t *)pud;
 
 	pmd = pmd_offset(pud, addr);
-	if (sz != PMD_SIZE && pmd_none(*pmd))
+	pmd_entry = READ_ONCE(*pmd);
+	if (sz != PMD_SIZE && pmd_none(pmd_entry))
 		return NULL;
 	/* hugepage or swap? */
-	if (pmd_huge(*pmd) || !pmd_present(*pmd))
+	if (pmd_huge(pmd_entry) || !pmd_present(pmd_entry))
 		return (pte_t *)pmd;
 
 	return NULL;


