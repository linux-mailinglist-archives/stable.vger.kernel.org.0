Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3187F49D79E
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 02:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbiA0Bwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 20:52:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57406 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiA0Bwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 20:52:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A730B820F1;
        Thu, 27 Jan 2022 01:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A417C340E7;
        Thu, 27 Jan 2022 01:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643248347;
        bh=N3uHMf93qUV2UqmDk/3ynkjX/YZ8hIZ9blePZHcu+5M=;
        h=Date:From:To:Subject:From;
        b=lM2/FfbKOkwH0hnuWQoXza2IvHs449Ifbu5iTLvjJPput1hwex+rY7Y8SBZLeXUob
         rzDBWFuIniRQrmzTyQRAhCdIB0Yp9HVwvNpVCPFRvghKnYO4bHk8WVM3VxKIfn/kWK
         pVWD06GsEXwEJIIB4A8hHx2cGrBEJgbht0hRq2Ss=
Date:   Wed, 26 Jan 2022 17:52:26 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        dave.hansen@linux.intel.com, gthelen@google.com, hpa@zytor.com,
        hughd@google.com, jirislaby@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        pjt@google.com, rientjes@google.com, rppt@kernel.org,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        weixugc@google.com, will@kernel.org, ziy@nvidia.com
Subject:  +
 mm-debug_vm_pgtable-remove-pte-entry-from-the-page-table.patch added to -mm
 tree
Message-ID: <20220127015226.QSDavwGEn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
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

Patch series "page table check fixes and cleanups", v4.

Two fixes:

  mm/debug_vm_pgtable: remove pte entry from the page table
	- remove a pte entry from the page table at the end of
	  debug_vm_pgtable pte test

  mm/khugepaged: unify collapse pmd clear, flush and free
  mm/page_table_check: check entries at pmd levels
	- check pmd level in page_table_check for PTE regular entries
	  prior to freeing.
	  repro.c: https://gist.github.com/soleen/fdcd501d5df103976245fe84e9535087
	  config: https://gist.github.com/soleen/8a56f923c2fea9ce9c75b4e2517d4162
	  qemu_script: https://gist.github.com/soleen/f4be4795826b7ab1a51ae659582e179c
	  base image:
	  https://storage.googleapis.com/syzkaller/wheezy.img
	  https://storage.googleapis.com/syzkaller/wheezy.img.key

Small cleanup:
  mm/page_table_check: use unsigned long for page counters and cleanup


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

Link: https://lkml.kernel.org/r/20220126183637.1840960-2-pasha.tatashin@soleen.com
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

