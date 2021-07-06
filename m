Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D123BD53E
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbhGFMTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:19:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237210AbhGFLgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 587D461ED2;
        Tue,  6 Jul 2021 11:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570770;
        bh=SgchSdyMjIM8hkJyq6+OQX/R7CAhcXTq1tfjK5njyJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zv7rIn3Bu+RV7HobydqkS6H9q21HI7PUDJnYQxkc4yH7IHc3lgntJRhKCBbabOTrg
         3gWw63VzNQTZ8s906sIihJrI1iLlpXsMlQM/0FxAcfx9ONQvwBUKeG7vCkalpcd1aI
         zzITSIPUDH94YgiwgWYCVrmcJDKxz49m7Sh67IJvpgkdBixto91KSlViicc6o8yYZs
         v+l6kdcjFypyfPT7kRanZx2hGfRFMbi7X+O5KBqOghxVoqqKtgRmRKUVtSW24MOzzr
         vVS6gWcGIyiNYxq5i0bJ57rbB+RgCdh5FWPEpH3lMDzsVeMsT1PID1y8KY31LF/MG3
         ko78WStVf+6fA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 53/74] MIPS: add PMD table accounting into MIPS'pmd_alloc_one
Date:   Tue,  6 Jul 2021 07:24:41 -0400
Message-Id: <20210706112502.2064236-53-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
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
index 166842337eb2..dd10854321ca 100644
--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -62,11 +62,15 @@ do {							\
 
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

