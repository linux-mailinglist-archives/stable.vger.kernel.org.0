Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CE63CA734
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbhGOSwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239588AbhGOSwL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:52:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3FC3613E0;
        Thu, 15 Jul 2021 18:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374957;
        bh=3vY8jkLEb5T5wUhD3hW2OPPBQIV5VgHI3/oaBlcpP+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZMVvwlTtexTbCAszcky9gv5Ub5yIVJ5ifnEj1GURy5LXHOocjmwMqaspMmhUSQ3T
         4n26cch7bdOVQGNSOmHMwqX3RLK6nAAHBGJamYgnxTJCDWZA3eVSh4/7yCcZxFbxqc
         uAumrpc/KwYMV4de9B5HWreSa48XrfAw5ZGZDNZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/215] MIPS: add PMD table accounting into MIPSpmd_alloc_one
Date:   Thu, 15 Jul 2021 20:37:48 +0200
Message-Id: <20210715182616.287897032@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
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



