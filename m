Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B53812C9D8
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbfL2R0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:26:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728165AbfL2R0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:26:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8390721744;
        Sun, 29 Dec 2019 17:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640378;
        bh=siKNwuh2zRW0dKAyJxEQER2/TqmLDXbV0rH2BnzudpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYaXYrykyxp72E+Kqdwfr9O9VwClc5Iuc92swMvEKp1Nl3aXTfYATuswx6uIoEsuX
         moFvRS0pKOtmffn6b4HpPrUAR1am1NAbPFOKGODV2TwZtx9J8Hp3F2PrSD/x/QUPas
         QVtoqJmDCulzupDmikCmEGMGOwGguXyia1nbjIrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 134/161] mips: fix build when "48 bits virtual memory" is enabled
Date:   Sun, 29 Dec 2019 18:19:42 +0100
Message-Id: <20191229162439.416974712@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

[ Upstream commit 3ed6751bb8fa89c3014399bb0414348499ee202a ]

With CONFIG_MIPS_VA_BITS_48=y the build fails miserably:

  CC      arch/mips/kernel/asm-offsets.s
In file included from arch/mips/include/asm/pgtable.h:644,
                 from include/linux/mm.h:99,
                 from arch/mips/kernel/asm-offsets.c:15:
include/asm-generic/pgtable.h:16:2: error: #error CONFIG_PGTABLE_LEVELS is not consistent with __PAGETABLE_{P4D,PUD,PMD}_FOLDED
 #error CONFIG_PGTABLE_LEVELS is not consistent with __PAGETABLE_{P4D,PUD,PMD}_FOLDED
  ^~~~~
include/asm-generic/pgtable.h:390:28: error: unknown type name 'p4d_t'; did you mean 'pmd_t'?
 static inline int p4d_same(p4d_t p4d_a, p4d_t p4d_b)
                            ^~~~~
                            pmd_t

[ ... more such errors ... ]

scripts/Makefile.build:99: recipe for target 'arch/mips/kernel/asm-offsets.s' failed
make[2]: *** [arch/mips/kernel/asm-offsets.s] Error 1

This happens because when CONFIG_MIPS_VA_BITS_48 enables 4th level of the
page tables, but neither pgtable-nop4d.h nor 5level-fixup.h are included to
cope with the 5th level.

Replace #ifdef conditions around includes of the pgtable-nop{m,u}d.h with
explicit CONFIG_PGTABLE_LEVELS and add include of 5level-fixup.h for the
case when CONFIG_PGTABLE_LEVELS==4

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/pgtable-64.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/pgtable-64.h b/arch/mips/include/asm/pgtable-64.h
index a2252c2a9ded..d0b9912fb63f 100644
--- a/arch/mips/include/asm/pgtable-64.h
+++ b/arch/mips/include/asm/pgtable-64.h
@@ -18,10 +18,12 @@
 #include <asm/fixmap.h>
 
 #define __ARCH_USE_5LEVEL_HACK
-#if defined(CONFIG_PAGE_SIZE_64KB) && !defined(CONFIG_MIPS_VA_BITS_48)
+#if CONFIG_PGTABLE_LEVELS == 2
 #include <asm-generic/pgtable-nopmd.h>
-#elif !(defined(CONFIG_PAGE_SIZE_4KB) && defined(CONFIG_MIPS_VA_BITS_48))
+#elif CONFIG_PGTABLE_LEVELS == 3
 #include <asm-generic/pgtable-nopud.h>
+#else
+#include <asm-generic/5level-fixup.h>
 #endif
 
 /*
@@ -222,6 +224,9 @@ static inline unsigned long pgd_page_vaddr(pgd_t pgd)
 	return pgd_val(pgd);
 }
 
+#define pgd_phys(pgd)		virt_to_phys((void *)pgd_val(pgd))
+#define pgd_page(pgd)		(pfn_to_page(pgd_phys(pgd) >> PAGE_SHIFT))
+
 static inline pud_t *pud_offset(pgd_t *pgd, unsigned long address)
 {
 	return (pud_t *)pgd_page_vaddr(*pgd) + pud_index(address);
-- 
2.20.1



