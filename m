Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1DF4A517F
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 22:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241365AbiAaVe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 16:34:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47854 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379942AbiAaVe4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 16:34:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0D7EB82C8D;
        Mon, 31 Jan 2022 21:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A9FC340E8;
        Mon, 31 Jan 2022 21:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643664894;
        bh=OE8esjYg7OYehxbI4YHjYDGmj8EIEBZYtw1oYW3B/vc=;
        h=Date:To:From:Subject:From;
        b=GokFLadv22YVi8Uq4J8rdyi5OVqidAhqUov6QXJ37/o+1oLPMtOl1+ccIYSb9uSFI
         192mPu7zelFYk7X1CdxXA1Fngsi5OaJoNaFcnitO6iDMr1STuzU42VhfDcgY9/M+i4
         p4ncdzbOZ93SplKNUE+WNwHFKii0Cbag3Y3Nhu+o=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 13:34:52 -0800
Date:   Mon, 31 Jan 2022 13:34:52 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, will@kernel.org,
        weixugc@google.com, stable@vger.kernel.org,
        songmuchun@bytedance.com, rppt@kernel.org, rientjes@google.com,
        pjt@google.com, mingo@redhat.com, jirislaby@kernel.org,
        hughd@google.com, hpa@zytor.com, gthelen@google.com,
        dave.hansen@linux.intel.com, anshuman.khandual@arm.com,
        aneesh.kumar@linux.ibm.com, pasha.tatashin@soleen.com
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug_vm_pgtable-remove-pte-entry-from-the-page-table.patch added to -mm tree
Message-Id: <20220131213452.E8A9FC340E8@smtp.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/debug_vm_pgtable: remove pte entry from the page table
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-remove-pte-entry-from-the-page-table.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-remove-pte-entry-from-the-page-table.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-remove-pte-entry-from-the-page-table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm/debug_vm_pgtable: remove pte entry from the page table

Patch series "page table check fixes and cleanups", v5.


This patch (of 4):

The pte entry that is used in pte_advanced_tests() is never removed from
the page table at the end of the test.

The issue is detected by page_table_check, to repro compile kernel with
the following configs:

CONFIG_DEBUG_VM_PGTABLE=y
CONFIG_PAGE_TABLE_CHECK=y
CONFIG_PAGE_TABLE_CHECK_ENFORCED=y

During the boot the following BUG is printed:

[    2.262821] debug_vm_pgtable: [debug_vm_pgtable         ]: Validating
               architecture page table helpers
[    2.276826] ------------[ cut here ]------------
[    2.280426] kernel BUG at mm/page_table_check.c:162!
[    2.284118] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[    2.287787] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
               5.16.0-11413-g2c271fe77d52 #3
[    2.293226] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
               BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org
               04/01/2014
...

The entry should be properly removed from the page table before the page
is released to the free list.

Link: https://lkml.kernel.org/r/20220131203249.2832273-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20220131203249.2832273-2-pasha.tatashin@soleen.com
Fixes: a5c3b9ffb0f4 ("mm/debug_vm_pgtable: add tests validating advanced arch page table helpers")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Paul Turner <pjt@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: <stable@vger.kernel.org>	[5.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-remove-pte-entry-from-the-page-table
+++ a/mm/debug_vm_pgtable.c
@@ -171,6 +171,8 @@ static void __init pte_advanced_tests(st
 	ptep_test_and_clear_young(args->vma, args->vaddr, args->ptep);
 	pte = ptep_get(args->ptep);
 	WARN_ON(pte_young(pte));
+
+	ptep_get_and_clear_full(args->mm, args->vaddr, args->ptep, 1);
 }
 
 static void __init pte_savedwrite_tests(struct pgtable_debug_args *args)
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-debug_vm_pgtable-remove-pte-entry-from-the-page-table.patch
mm-page_table_check-use-unsigned-long-for-page-counters-and-cleanup.patch
mm-khugepaged-unify-collapse-pmd-clear-flush-and-free.patch
mm-page_table_check-check-entries-at-pmd-levels.patch

