Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF82845128F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346864AbhKOThM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244897AbhKOTSL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6EB360EE0;
        Mon, 15 Nov 2021 18:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000707;
        bh=WLXO+JRbrxT8OzdRxLRdbDEoBDy83w1OjaaSVYZmB18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xj2WHfCXuVkYBdvc5jo6Ky2mwY1i8kCZhzmdrs/6yhfH1s/hypB9ZUOji9aKy1s5R
         L7fpPRPA8/3fjf1qBszNhVR9ON7jOnYToK5LsE7BzIUlT0OB7ZvqMzg3qcLQ1znnxW
         dnLo1BDSa6NxWeN67kvTRtfa3WtyqEiSxQ2MIzWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 762/849] arm64: pgtable: make __pte_to_phys/__phys_to_pte_val inline functions
Date:   Mon, 15 Nov 2021 18:04:05 +0100
Message-Id: <20211115165446.028623016@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index f09bf5c028919..16e53d2515089 100644
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



