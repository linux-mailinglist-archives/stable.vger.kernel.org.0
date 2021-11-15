Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EFF451E60
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355052AbhKPAft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344837AbhKOTZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03CDF636DB;
        Mon, 15 Nov 2021 19:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003123;
        bh=dDINOVOaUapdVnUqdXJc0L0stCRFEAfiFgnProVEn6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0WHycclxjJybk2/U/CDeD2qozDurOZJJoC9ijRlkz/5jS3ibHJa54Pm4Qq8KXVD2w
         9to2Yq0y1CcSN4zT79Fyma0Ts1zV75TQ5XEU/lCwJGXnuBn9Cnhx19BHzJUpL/U6j6
         TTWb1YS9L1G95WJ4BFnwvKfrcx/1vgY6cEt04Uao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 820/917] arm64: pgtable: make __pte_to_phys/__phys_to_pte_val inline functions
Date:   Mon, 15 Nov 2021 18:05:15 +0100
Message-Id: <20211115165456.849646751@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c7c386fbc20262c1d911c615c65db6a58667d92c ]

gcc warns about undefined behavior the vmalloc code when building
with CONFIG_ARM64_PA_BITS_52, when the 'idx++' in the argument to
__phys_to_pte_val() is evaluated twice:

mm/vmalloc.c: In function 'vmap_pfn_apply':
mm/vmalloc.c:2800:58: error: operation on 'data->idx' may be undefined [-Werror=sequence-point]
 2800 |         *pte = pte_mkspecial(pfn_pte(data->pfns[data->idx++], data->prot));
      |                                                 ~~~~~~~~~^~
arch/arm64/include/asm/pgtable-types.h:25:37: note: in definition of macro '__pte'
   25 | #define __pte(x)        ((pte_t) { (x) } )
      |                                     ^
arch/arm64/include/asm/pgtable.h:80:15: note: in expansion of macro '__phys_to_pte_val'
   80 |         __pte(__phys_to_pte_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
      |               ^~~~~~~~~~~~~~~~~
mm/vmalloc.c:2800:30: note: in expansion of macro 'pfn_pte'
 2800 |         *pte = pte_mkspecial(pfn_pte(data->pfns[data->idx++], data->prot));
      |                              ^~~~~~~

I have no idea why this never showed up earlier, but the safest
workaround appears to be changing those macros into inline functions
so the arguments get evaluated only once.

Cc: Matthew Wilcox <willy@infradead.org>
Fixes: 75387b92635e ("arm64: handle 52-bit physical addresses in page table entries")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20211105075414.2553155-1-arnd@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index dfa76afa0ccff..72f95c6a70519 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -67,9 +67,15 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
  * page table entry, taking care of 52-bit addresses.
  */
 #ifdef CONFIG_ARM64_PA_BITS_52
-#define __pte_to_phys(pte)	\
-	((pte_val(pte) & PTE_ADDR_LOW) | ((pte_val(pte) & PTE_ADDR_HIGH) << 36))
-#define __phys_to_pte_val(phys)	(((phys) | ((phys) >> 36)) & PTE_ADDR_MASK)
+static inline phys_addr_t __pte_to_phys(pte_t pte)
+{
+	return (pte_val(pte) & PTE_ADDR_LOW) |
+		((pte_val(pte) & PTE_ADDR_HIGH) << 36);
+}
+static inline pteval_t __phys_to_pte_val(phys_addr_t phys)
+{
+	return (phys | (phys >> 36)) & PTE_ADDR_MASK;
+}
 #else
 #define __pte_to_phys(pte)	(pte_val(pte) & PTE_ADDR_MASK)
 #define __phys_to_pte_val(phys)	(phys)
-- 
2.33.0



