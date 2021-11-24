Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E49745C106
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245009AbhKXNOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:14:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:50778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347689AbhKXNML (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:12:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2414E61A7A;
        Wed, 24 Nov 2021 12:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757744;
        bh=KUSEjjeRRCEtiMNCz674Wa9/yzHql4lH76/cT+oYqcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0aYTnutB4nAx8nWqZF/o5HeRtCfck2N1a7SIEEnq11GaTtBXiZ+H2oOrmCeftbbHz
         n8Ms23MFOH8L86UulIf1PjHeR6mnyqZAX/UDcWNbe+kV7tiuZ2J6t9pZ6N7x7zh9Ru
         81ZJYKvs+JAo8bB1qawVBE620z3uJHnrGYrOvquU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 229/323] arm64: pgtable: make __pte_to_phys/__phys_to_pte_val inline functions
Date:   Wed, 24 Nov 2021 12:56:59 +0100
Message-Id: <20211124115726.648662804@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index f43519b710610..71a73ca1e2b05 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -64,9 +64,15 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
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



