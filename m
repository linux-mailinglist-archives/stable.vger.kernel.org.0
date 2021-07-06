Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C523BD23F
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237331AbhGFLlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:41:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237541AbhGFLgN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B841A61F2D;
        Tue,  6 Jul 2021 11:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570908;
        bh=YLXnt5wG5jvESbfEUk+/masoINAD5jvQEUvbk327gPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8N1ynfrX6bM+0kW9bc8cwsUsLU9Y+YQPodxr4FCJap0gP7WBUUzv7Z4N4v817/tr
         qjR4lzOY0kLNAI01B+lgAGZY91z5VPL4FWXw6+JJQ9qJdwT2oYhl2gxxO7mxXrvzxG
         PIoYqoc9HkL44/De3xFgRgduvSQmS5JCFZo7Km9unyuPMwizqgAzucKiWcIXyXPPoi
         MKVID5rQUkB/lcfFEQG0ClN212IA3comQKma2bSNHC1Yg3oLh20RXAcCHskq2e4f9X
         pKLhtuw02fTd+7aZCWaX2X08A+44lXQbGzCpESlOGasju2dVJK/5f+DNB97+faEtOf
         8uMz9Yn2WkmQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 31/45] MIPS: add PMD table accounting into MIPS'pmd_alloc_one
Date:   Tue,  6 Jul 2021 07:27:35 -0400
Message-Id: <20210706112749.2065541-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112749.2065541-1-sashal@kernel.org>
References: <20210706112749.2065541-1-sashal@kernel.org>
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
index 39b9f311c4ef..f800872f867b 100644
--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -93,11 +93,15 @@ do {							\
 
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

