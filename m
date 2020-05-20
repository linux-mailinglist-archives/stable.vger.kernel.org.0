Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C001DC331
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 01:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgETXql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 19:46:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbgETXql (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 May 2020 19:46:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEC4F2072C;
        Wed, 20 May 2020 23:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590018399;
        bh=B7YrcQDkd1BKM+w20pbPLj/CV31guf6ed94E2pDUfU0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=l1Gpfi0yjW44OxcVrXtiGDNqE+fSxkd+Ys2slZf5LV9ev4ncPN/oIXkyuFG/pvP0S
         aLrasx24RHMlBTbkNnlmtaixZvd9c5DnDnOZ440AzBeSEm8x7+5y9Y+u1Yry/aS/ud
         eCTK3wMha6bVm6zYPdgJQ5LsodaEMy0E6kj+jGfE=
Date:   Wed, 20 May 2020 16:46:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     davem@davemloft.net, lkp@intel.com, matorola@gmail.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        stable@vger.kernel.org
Subject:  +
 sparc32-use-pud-rather-than-pgd-to-get-pmd-in-srmmu_nocache_init.patch
 added to -mm tree
Message-ID: <20200520234639.Bjq6Hhiq6%akpm@linux-foundation.org>
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: sparc32: use PUD rather than PGD to get PMD in srmmu_nocache_init()
has been added to the -mm tree.  Its filename is
     sparc32-use-pud-rather-than-pgd-to-get-pmd-in-srmmu_nocache_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc32-use-pud-rather-than-pgd-to-get-pmd-in-srmmu_nocache_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc32-use-pud-rather-than-pgd-to-get-pmd-in-srmmu_nocache_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: sparc32: use PUD rather than PGD to get PMD in srmmu_nocache_init()

The kbuild test robot reported the following warning:

arch/sparc/mm/srmmu.c: In function 'srmmu_nocache_init':
>> arch/sparc/mm/srmmu.c:300:9: error: variable 'pud' set but not used
>> [-Werror=unused-but-set-variable]
300 |  pud_t *pud;

This warning is caused by misprint in the page table traversal in
srmmu_nocache_init() function which accessed a PMD entry using PGD rather
than PUD.
Since sparc32 has only 3 page table levels, the PGD and PUD are essentially
the same and usage of __nocache_fix() removed the type checking.

Use PUD for the consistency and to silence the compiler warning.

Link: http://lkml.kernel.org/r/20200520132005.GM1059226@linux.ibm.com
Fixes: 7235db268a2777bc38 ("sparc32: use pgtable-nopud instead of 4level-fixup")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: kbuild test robot <lkp@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Anatoly Pugachev <matorola@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/srmmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/mm/srmmu.c~sparc32-use-pud-rather-than-pgd-to-get-pmd-in-srmmu_nocache_init
+++ a/arch/sparc/mm/srmmu.c
@@ -333,7 +333,7 @@ static void __init srmmu_nocache_init(vo
 		pgd = pgd_offset_k(vaddr);
 		p4d = p4d_offset(__nocache_fix(pgd), vaddr);
 		pud = pud_offset(__nocache_fix(p4d), vaddr);
-		pmd = pmd_offset(__nocache_fix(pgd), vaddr);
+		pmd = pmd_offset(__nocache_fix(pud), vaddr);
 		pte = pte_offset_kernel(__nocache_fix(pmd), vaddr);
 
 		pteval = ((paddr >> 4) | SRMMU_ET_PTE | SRMMU_PRIV);
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

sparc32-use-pud-rather-than-pgd-to-get-pmd-in-srmmu_nocache_init.patch
mm-memblock-replace-dereferences-of-memblock_regionnid-with-api-calls.patch
mm-make-early_pfn_to_nid-and-related-defintions-close-to-each-other.patch
mm-remove-config_have_memblock_node_map-option.patch
mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes.patch
mm-use-free_area_init-instead-of-free_area_init_nodes.patch
alpha-simplify-detection-of-memory-zone-boundaries.patch
arm-simplify-detection-of-memory-zone-boundaries.patch
arm64-simplify-detection-of-memory-zone-boundaries-for-uma-configs.patch
csky-simplify-detection-of-memory-zone-boundaries.patch
m68k-mm-simplify-detection-of-memory-zone-boundaries.patch
parisc-simplify-detection-of-memory-zone-boundaries.patch
sparc32-simplify-detection-of-memory-zone-boundaries.patch
unicore32-simplify-detection-of-memory-zone-boundaries.patch
xtensa-simplify-detection-of-memory-zone-boundaries.patch
mm-remove-early_pfn_in_nid-and-config_nodes_span_other_nodes.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2.patch
mm-rename-free_area_init_node-to-free_area_init_memoryless_node.patch
mm-clean-up-free_area_init_node-and-its-helpers.patch
mm-simplify-find_min_pfn_with_active_regions.patch
docs-vm-update-memory-models-documentation.patch
h8300-remove-usage-of-__arch_use_5level_hack.patch
arm-add-support-for-folded-p4d-page-tables.patch
arm-add-support-for-folded-p4d-page-tables-fix.patch
arm64-add-support-for-folded-p4d-page-tables.patch
hexagon-remove-__arch_use_5level_hack.patch
ia64-add-support-for-folded-p4d-page-tables.patch
nios2-add-support-for-folded-p4d-page-tables.patch
openrisc-add-support-for-folded-p4d-page-tables.patch
powerpc-add-support-for-folded-p4d-page-tables.patch
powerpc-add-support-for-folded-p4d-page-tables-fix.patch
powerpc-add-support-for-folded-p4d-page-tables-fix-2.patch
sh-drop-__pxd_offset-macros-that-duplicate-pxd_index-ones.patch
sh-add-support-for-folded-p4d-page-tables.patch
unicore32-remove-__arch_use_5level_hack.patch
asm-generic-remove-pgtable-nop4d-hackh.patch
mm-remove-__arch_has_5level_hack-and-include-asm-generic-5level-fixuph.patch
mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included.patch
mm-introduce-include-linux-pgtableh.patch
mm-reorder-includes-after-introduction-of-linux-pgtableh.patch
csky-replace-definitions-of-__pxd_offset-with-pxd_index.patch
m68k-mm-motorola-move-comment-about-page-table-allocation-funcitons.patch
m68k-mm-move-cachenocahe_page-definitions-close-to-their-user.patch
x86-mm-simplify-init_trampoline-and-surrounding-logic.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte-fix-2.patch
mm-consolidate-pte_index-and-pte_offset_-definitions.patch
mm-consolidate-pmd_index-and-pmd_offset-definitions.patch
mm-consolidate-pud_index-and-pud_offset-definitions.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions.patch

