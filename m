Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700C53BCD56
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbhGFLVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233169AbhGFLUK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9FF761C65;
        Tue,  6 Jul 2021 11:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570237;
        bh=3vY8jkLEb5T5wUhD3hW2OPPBQIV5VgHI3/oaBlcpP+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BfkdhPlftM3lR+tITgLIBuviXXwIaKD8J8TeK+KwKjzRByin6HpEON3sxEYaTWHLA
         VG0TRdkhTtbMqgMqkQFZXBhEkh8/YkNcVTL5vfNFyVqQISuE9Pd1ECD7Rskjq0O3R7
         1bxNJitHBTlxhJtF1uP1KDey+eR4Sv69Xi5IXfpxe95U2kZJMuE/p/IFeLPyDKTPkE
         2d3AZf1yWMlWKhiOKi++hmp2Np3IgYj/CwNG5bouWDaIraqEe0hMftzdT+OZdFtQUP
         4Apel1oYXd56XWFm5aQzIc5XwG2Yk/QUI91QoFG2jnsKaDtk2UQDCddsKFzLJBCRjv
         VvcWMze6HyFog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 139/189] MIPS: add PMD table accounting into MIPS'pmd_alloc_one
Date:   Tue,  6 Jul 2021 07:13:19 -0400
Message-Id: <20210706111409.2058071-139-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Pei <huangpei@loongson.cn>

[ Upstream commit ed914d48b6a1040d1039d371b56273d422c0081e ]

This fixes Page Table accounting bug.

MIPS is the ONLY arch just defining __HAVE_ARCH_PMD_ALLOC_ONE alone.
Since commit b2b29d6d011944 (mm: account PMD tables like PTE tables),
"pmd_free" in asm-generic with PMD table accounting and "pmd_alloc_one"
in MIPS without PMD table accounting causes PageTable accounting number
negative, which read by global_zone_page_state(), always returns 0.

Signed-off-by: Huang Pei <huangpei@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/pgalloc.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/mips/include/asm/pgalloc.h b/arch/mips/include/asm/pgalloc.h
index 8b18424b3120..d0cf997b4ba8 100644
--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -59,11 +59,15 @@ do {							\
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	pmd_t *pmd;
+	pmd_t *pmd = NULL;
+	struct page *pg;
 
-	pmd = (pmd_t *) __get_free_pages(GFP_KERNEL, PMD_ORDER);
-	if (pmd)
+	pg = alloc_pages(GFP_KERNEL | __GFP_ACCOUNT, PMD_ORDER);
+	if (pg) {
+		pgtable_pmd_page_ctor(pg);
+		pmd = (pmd_t *)page_address(pg);
 		pmd_init((unsigned long)pmd, (unsigned long)invalid_pte_table);
+	}
 	return pmd;
 }
 
-- 
2.30.2

