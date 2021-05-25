Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF846390BD6
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 23:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbhEYV7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 17:59:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232896AbhEYV7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 17:59:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB0A2613C1;
        Tue, 25 May 2021 21:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621979902;
        bh=Kjz3bb80tjoovQukukBUd+0ZU/0kz8AnMAE5BeZYUag=;
        h=Date:From:To:Subject:From;
        b=H5pWDiQT0wdpcJZT0sYs62FNuHEYDNtBtyAuQarBhZafDG4ffDKDXt74rVkoB2Yuu
         sMNrOjutkze2/02+FLqcXcPhJVwWkjJCLSoGj9N2Nodqo+0mJrj4yA3oJQqy2N/T59
         DsHPqWUKYIXqnOVKFuDpPsv4lYiL9x14invq3VwA=
Date:   Tue, 25 May 2021 14:58:22 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, gerald.schaefer@linux.ibm.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  +
 mm-debug_vm_pgtable-fix-alignment-for-pmd-pud_advanced_tests.patch added to
 -mm tree
Message-ID: <20210525215822.b9d6uZLDU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: fix alignment for pmd/pud_advanced_tests()
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-fix-alignment-for-pmd-pud_advanced_tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-fix-alignment-for-pmd-pud_advanced_tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-fix-alignment-for-pmd-pud_advanced_tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: mm/debug_vm_pgtable: fix alignment for pmd/pud_advanced_tests()

In pmd/pud_advanced_tests(), the vaddr is aligned up to the next pmd/pud
entry, and so it does not match the given pmdp/pudp and (aligned down) pfn
any more.

For s390, this results in memory corruption, because the IDTE instruction
used e.g. in xxx_get_and_clear() will take the vaddr for some calculations,
in combination with the given pmdp. It will then end up with a wrong table
origin, ending on ...ff8, and some of those wrongly set low-order bits will
also select a wrong pagetable level for the index addition. IDTE could
therefore invalidate (or 0x20) something outside of the page tables,
depending on the wrongly picked index, which in turn depends on the random
vaddr.

As result, we sometimes see "BUG task_struct (Not tainted): Padding
overwritten" on s390, where one 0x5a padding value got overwritten with
0x7a.

Fix this by aligning down, similar to how the pmd/pud_aligned pfns are
calculated.

Link: https://lkml.kernel.org/r/20210525130043.186290-2-gerald.schaefer@linux.ibm.com
Fixes: a5c3b9ffb0f40 ("mm/debug_vm_pgtable: add tests validating advanced arch page table helpers")
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: <stable@vger.kernel.org>	[5.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-fix-alignment-for-pmd-pud_advanced_tests
+++ a/mm/debug_vm_pgtable.c
@@ -192,7 +192,7 @@ static void __init pmd_advanced_tests(st
 
 	pr_debug("Validating PMD advanced\n");
 	/* Align the address wrt HPAGE_PMD_SIZE */
-	vaddr = (vaddr & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE;
+	vaddr &= HPAGE_PMD_MASK;
 
 	pgtable_trans_huge_deposit(mm, pmdp, pgtable);
 
@@ -330,7 +330,7 @@ static void __init pud_advanced_tests(st
 
 	pr_debug("Validating PUD advanced\n");
 	/* Align the address wrt HPAGE_PUD_SIZE */
-	vaddr = (vaddr & HPAGE_PUD_MASK) + HPAGE_PUD_SIZE;
+	vaddr &= HPAGE_PUD_MASK;
 
 	set_pud_at(mm, vaddr, pudp, pud);
 	pudp_set_wrprotect(mm, vaddr, pudp);
_

Patches currently in -mm which might be from gerald.schaefer@linux.ibm.com are

mm-debug_vm_pgtable-fix-alignment-for-pmd-pud_advanced_tests.patch

