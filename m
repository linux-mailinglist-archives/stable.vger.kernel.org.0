Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6B43CD99E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243768AbhGSObG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244520AbhGSO3t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:29:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0A17611CE;
        Mon, 19 Jul 2021 15:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707391;
        bh=MCQpnu3VrSwS07KU2tshh1HSlp1qQeuYL1AzCQd7Sjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUg/IFlxx0uNUYDXiUOwkA4PPWqesTxAQYoNAUvR9lHe+Nyo2AXflMhbnfkNJES6W
         HD7GWCFOlLc8FvrLMpIOvqXnXUMBP5sAQPZxtmw4VpD4Wep+J5y4mJ30Hkx29vhYTC
         97Pv2E9DweKtLcv5tHzXyFgkyveSShTX6aT9c1JM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 145/245] MIPS: add PMD table accounting into MIPSpmd_alloc_one
Date:   Mon, 19 Jul 2021 16:51:27 +0200
Message-Id: <20210719144945.093480381@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a03e86969f78..ff982d8b62f6 100644
--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -107,11 +107,15 @@ do {							\
 
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



