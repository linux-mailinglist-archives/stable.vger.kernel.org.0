Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26A839C554
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 05:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhFEDDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 23:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230169AbhFEDDF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 23:03:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8359D61402;
        Sat,  5 Jun 2021 03:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622862078;
        bh=4bHvHbl6CY5ATZIsrA1xqhEJ4I0Fv2cydSPOtNL8hrk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IH66IRT6jYWxlBiclATZOqnq8lsijIlTTnZvYlrAu5xgHNch8DEzQdSUHWM5zg0FQ
         b/4L0kyh8He+zLZp5hUQwGmwknBW8mnDCsU4YmaEMIkMSKAjrmwNsT3Eylwah4OyYT
         v83F6RAQJcNlFa+ojfNaMm7JsCXmU2EWj4ygKM2o=
Date:   Fri, 04 Jun 2021 20:01:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        gerald.schaefer@linux.ibm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, palmer@dabbelt.com,
        paul.walmsley@sifive.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vgupta@synopsys.com
Subject:  [patch 04/13] mm/debug_vm_pgtable: fix alignment for
 pmd/pud_advanced_tests()
Message-ID: <20210605030118.fd0d-oaQo%akpm@linux-foundation.org>
In-Reply-To: <20210604200040.d8d0406caf195525620c0f3d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
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
