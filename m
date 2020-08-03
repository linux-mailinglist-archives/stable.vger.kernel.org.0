Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9506C23A41E
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgHCMXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727797AbgHCMXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:23:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 013B92076B;
        Mon,  3 Aug 2020 12:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457383;
        bh=mMaacA9vE0nsei1eQU9xoZKDWVY7ktUlsDNk0P5mmr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iK3VSBvfmbS2vG655fbbTUI5yq/mDCk5rsI1vj+Dg7ZMb9Bet3ebTTusuabAxoFsw
         vqGB7sp6eSekfhVzviXjnZlm3AyObz/phZYDJQMUXe0F7VOad64SoHpjdRURyL6MCT
         A57hL8ADoPdICyfkASqGpTbv6Mzb49/YNtpe4aAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rich Felker <dalias@libc.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 047/120] sh/tlb: Fix PGTABLE_LEVELS > 2
Date:   Mon,  3 Aug 2020 14:18:25 +0200
Message-Id: <20200803121905.098549302@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit c7bcbc8ab9cb20536b8f50c62a48cebda965fdba ]

Geert reported that his SH7722-based Migo-R board failed to boot after
commit:

  c5b27a889da9 ("sh/tlb: Convert SH to generic mmu_gather")

That commit fell victim to copying the wrong pattern --
__pmd_free_tlb() used to be implemented with pmd_free().

Fixes: c5b27a889da9 ("sh/tlb: Convert SH to generic mmu_gather")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Rich Felker <dalias@libc.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/include/asm/pgalloc.h | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/sh/include/asm/pgalloc.h b/arch/sh/include/asm/pgalloc.h
index 22d968bfe9bb6..d770da3f8b6fb 100644
--- a/arch/sh/include/asm/pgalloc.h
+++ b/arch/sh/include/asm/pgalloc.h
@@ -12,6 +12,7 @@ extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
 extern void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd);
 extern pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address);
 extern void pmd_free(struct mm_struct *mm, pmd_t *pmd);
+#define __pmd_free_tlb(tlb, pmdp, addr)		pmd_free((tlb)->mm, (pmdp))
 #endif
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
@@ -33,13 +34,4 @@ do {							\
 	tlb_remove_page((tlb), (pte));			\
 } while (0)
 
-#if CONFIG_PGTABLE_LEVELS > 2
-#define __pmd_free_tlb(tlb, pmdp, addr)			\
-do {							\
-	struct page *page = virt_to_page(pmdp);		\
-	pgtable_pmd_page_dtor(page);			\
-	tlb_remove_page((tlb), page);			\
-} while (0);
-#endif
-
 #endif /* __ASM_SH_PGALLOC_H */
-- 
2.25.1



