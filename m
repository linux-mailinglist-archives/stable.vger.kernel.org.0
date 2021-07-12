Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A74D3C496E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbhGLGo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:44:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237574AbhGLGnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:43:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC5566102A;
        Mon, 12 Jul 2021 06:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071969;
        bh=OKBqR9L+8UIbO+SoNIBuuIsSGGcY6EdTuVaIYVSDvGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDOmrd8A+NjT1gikSxY8cYIZT1UtAIrZSB75IFIbOFgxmYMjg0Soyk85boaX8G20N
         JfeiDmtigjVYstbq8gXv7FyV/ycTK+Qo9RYv8dDiXWL5DBqGFQdHTT2LN4OwVKFtPf
         pLXO0F8NHJC1n0rvA8bcaofQTS55vALX2I//sL3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Steven Price <steven.price@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: [PATCH 5.10 291/593] mm/debug_vm_pgtable/basic: add validation for dirtiness after write protect
Date:   Mon, 12 Jul 2021 08:07:31 +0200
Message-Id: <20210712060916.409115930@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit bb5c47ced46797409f4791d0380db3116d93134c ]

Patch series "mm/debug_vm_pgtable: Some minor updates", v3.

This series contains some cleanups and new test suggestions from Catalin
from an earlier discussion.

https://lore.kernel.org/linux-mm/20201123142237.GF17833@gaia/

This patch (of 2):

This adds validation tests for dirtiness after write protect conversion
for each page table level.  There are two new separate test types involved
here.

The first test ensures that a given page table entry does not become dirty
after pxx_wrprotect().  This is important for platforms like arm64 which
transfers and drops the hardware dirty bit (!PTE_RDONLY) to the software
dirty bit while making it an write protected one.  This test ensures that
no fresh page table entry could be created with hardware dirty bit set.
The second test ensures that a given page table entry always preserve the
dirty information across pxx_wrprotect().

This adds two previously missing PUD level basic tests and while here
fixes pxx_wrprotect() related typos in the documentation file.

Link: https://lkml.kernel.org/r/1611137241-26220-1-git-send-email-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/1611137241-26220-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Gerald Schaefer <gerald.schaefer@de.ibm.com> [s390]
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/vm/arch_pgtable_helpers.rst |  8 ++---
 mm/debug_vm_pgtable.c                     | 39 +++++++++++++++++++++++
 2 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/Documentation/vm/arch_pgtable_helpers.rst b/Documentation/vm/arch_pgtable_helpers.rst
index f3591ee3aaa8..552567d863b8 100644
--- a/Documentation/vm/arch_pgtable_helpers.rst
+++ b/Documentation/vm/arch_pgtable_helpers.rst
@@ -50,7 +50,7 @@ PTE Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pte_mkwrite               | Creates a writable PTE                           |
 +---------------------------+--------------------------------------------------+
-| pte_mkwrprotect           | Creates a write protected PTE                    |
+| pte_wrprotect             | Creates a write protected PTE                    |
 +---------------------------+--------------------------------------------------+
 | pte_mkspecial             | Creates a special PTE                            |
 +---------------------------+--------------------------------------------------+
@@ -120,7 +120,7 @@ PMD Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pmd_mkwrite               | Creates a writable PMD                           |
 +---------------------------+--------------------------------------------------+
-| pmd_mkwrprotect           | Creates a write protected PMD                    |
+| pmd_wrprotect             | Creates a write protected PMD                    |
 +---------------------------+--------------------------------------------------+
 | pmd_mkspecial             | Creates a special PMD                            |
 +---------------------------+--------------------------------------------------+
@@ -186,7 +186,7 @@ PUD Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | pud_mkwrite               | Creates a writable PUD                           |
 +---------------------------+--------------------------------------------------+
-| pud_mkwrprotect           | Creates a write protected PUD                    |
+| pud_wrprotect             | Creates a write protected PUD                    |
 +---------------------------+--------------------------------------------------+
 | pud_mkdevmap              | Creates a ZONE_DEVICE mapped PUD                 |
 +---------------------------+--------------------------------------------------+
@@ -224,7 +224,7 @@ HugeTLB Page Table Helpers
 +---------------------------+--------------------------------------------------+
 | huge_pte_mkwrite          | Creates a writable HugeTLB                       |
 +---------------------------+--------------------------------------------------+
-| huge_pte_mkwrprotect      | Creates a write protected HugeTLB                |
+| huge_pte_wrprotect        | Creates a write protected HugeTLB                |
 +---------------------------+--------------------------------------------------+
 | huge_ptep_get_and_clear   | Clears a HugeTLB                                 |
 +---------------------------+--------------------------------------------------+
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 750bfef26be3..79480fd18443 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -63,6 +63,16 @@ static void __init pte_basic_tests(unsigned long pfn, pgprot_t prot)
 	pte_t pte = pfn_pte(pfn, prot);
 
 	pr_debug("Validating PTE basic\n");
+
+	/*
+	 * This test needs to be executed after the given page table entry
+	 * is created with pfn_pte() to make sure that protection_map[idx]
+	 * does not have the dirty bit enabled from the beginning. This is
+	 * important for platforms like arm64 where (!PTE_RDONLY) indicate
+	 * dirty bit being set.
+	 */
+	WARN_ON(pte_dirty(pte_wrprotect(pte)));
+
 	WARN_ON(!pte_same(pte, pte));
 	WARN_ON(!pte_young(pte_mkyoung(pte_mkold(pte))));
 	WARN_ON(!pte_dirty(pte_mkdirty(pte_mkclean(pte))));
@@ -70,6 +80,8 @@ static void __init pte_basic_tests(unsigned long pfn, pgprot_t prot)
 	WARN_ON(pte_young(pte_mkold(pte_mkyoung(pte))));
 	WARN_ON(pte_dirty(pte_mkclean(pte_mkdirty(pte))));
 	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte))));
+	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
+	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
 }
 
 static void __init pte_advanced_tests(struct mm_struct *mm,
@@ -137,6 +149,17 @@ static void __init pmd_basic_tests(unsigned long pfn, pgprot_t prot)
 		return;
 
 	pr_debug("Validating PMD basic\n");
+
+	/*
+	 * This test needs to be executed after the given page table entry
+	 * is created with pfn_pmd() to make sure that protection_map[idx]
+	 * does not have the dirty bit enabled from the beginning. This is
+	 * important for platforms like arm64 where (!PTE_RDONLY) indicate
+	 * dirty bit being set.
+	 */
+	WARN_ON(pmd_dirty(pmd_wrprotect(pmd)));
+
+
 	WARN_ON(!pmd_same(pmd, pmd));
 	WARN_ON(!pmd_young(pmd_mkyoung(pmd_mkold(pmd))));
 	WARN_ON(!pmd_dirty(pmd_mkdirty(pmd_mkclean(pmd))));
@@ -144,6 +167,8 @@ static void __init pmd_basic_tests(unsigned long pfn, pgprot_t prot)
 	WARN_ON(pmd_young(pmd_mkold(pmd_mkyoung(pmd))));
 	WARN_ON(pmd_dirty(pmd_mkclean(pmd_mkdirty(pmd))));
 	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite(pmd))));
+	WARN_ON(pmd_dirty(pmd_wrprotect(pmd_mkclean(pmd))));
+	WARN_ON(!pmd_dirty(pmd_wrprotect(pmd_mkdirty(pmd))));
 	/*
 	 * A huge page does not point to next level page table
 	 * entry. Hence this must qualify as pmd_bad().
@@ -257,11 +282,25 @@ static void __init pud_basic_tests(unsigned long pfn, pgprot_t prot)
 		return;
 
 	pr_debug("Validating PUD basic\n");
+
+	/*
+	 * This test needs to be executed after the given page table entry
+	 * is created with pfn_pud() to make sure that protection_map[idx]
+	 * does not have the dirty bit enabled from the beginning. This is
+	 * important for platforms like arm64 where (!PTE_RDONLY) indicate
+	 * dirty bit being set.
+	 */
+	WARN_ON(pud_dirty(pud_wrprotect(pud)));
+
 	WARN_ON(!pud_same(pud, pud));
 	WARN_ON(!pud_young(pud_mkyoung(pud_mkold(pud))));
+	WARN_ON(!pud_dirty(pud_mkdirty(pud_mkclean(pud))));
+	WARN_ON(pud_dirty(pud_mkclean(pud_mkdirty(pud))));
 	WARN_ON(!pud_write(pud_mkwrite(pud_wrprotect(pud))));
 	WARN_ON(pud_write(pud_wrprotect(pud_mkwrite(pud))));
 	WARN_ON(pud_young(pud_mkold(pud_mkyoung(pud))));
+	WARN_ON(pud_dirty(pud_wrprotect(pud_mkclean(pud))));
+	WARN_ON(!pud_dirty(pud_wrprotect(pud_mkdirty(pud))));
 
 	if (mm_pmd_folded(mm))
 		return;
-- 
2.30.2



