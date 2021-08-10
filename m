Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD9F3E7FCF
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhHJRnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233975AbhHJRlH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:41:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B15DC611C5;
        Tue, 10 Aug 2021 17:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617097;
        bh=4N9F4XwHqssl3coRKsDZj6kfcnqot9nOZGW3exOX8oM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gncX53wHrDKdb21vEsc9fAnAJ/pa4rTz80lbXnS/NLqgYxcuwRYLvMUsTkwr5QRAy
         O0v0pNRJ/c147xzfzQrb+Hj6Gv+QKw7pymUJOPhBZJy+9vHOY7F953YbjtibAgzrD1
         IgwDFJnxe1Ns+u/cO2Rc5HvfIcKd0fmLaovkaM7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joshua Kinard <kumba@gentoo.org>,
        Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/135] MIPS: check return value of pgtable_pmd_page_ctor
Date:   Tue, 10 Aug 2021 19:29:38 +0200
Message-Id: <20210810172957.188573777@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Pei <huangpei@loongson.cn>

[ Upstream commit 6aa32467299e9e12280a6aec9dbc21bf2db830b0 ]

+. According to Documentation/vm/split_page_table_lock, handle failure
of pgtable_pmd_page_ctor

+. Use GFP_KERNEL_ACCOUNT instead of GFP_KERNEL|__GFP_ACCOUNT

+. Adjust coding style

Fixes: ed914d48b6a1 ("MIPS: add PMD table accounting into MIPS')
Reported-by: Joshua Kinard <kumba@gentoo.org>
Signed-off-by: Huang Pei <huangpei@loongson.cn>
Reviewed-by: Joshua Kinard <kumba@gentoo.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/pgalloc.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/mips/include/asm/pgalloc.h b/arch/mips/include/asm/pgalloc.h
index d0cf997b4ba8..139b4050259f 100644
--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -59,15 +59,20 @@ do {							\
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	pmd_t *pmd = NULL;
+	pmd_t *pmd;
 	struct page *pg;
 
-	pg = alloc_pages(GFP_KERNEL | __GFP_ACCOUNT, PMD_ORDER);
-	if (pg) {
-		pgtable_pmd_page_ctor(pg);
-		pmd = (pmd_t *)page_address(pg);
-		pmd_init((unsigned long)pmd, (unsigned long)invalid_pte_table);
+	pg = alloc_pages(GFP_KERNEL_ACCOUNT, PMD_ORDER);
+	if (!pg)
+		return NULL;
+
+	if (!pgtable_pmd_page_ctor(pg)) {
+		__free_pages(pg, PMD_ORDER);
+		return NULL;
 	}
+
+	pmd = (pmd_t *)page_address(pg);
+	pmd_init((unsigned long)pmd, (unsigned long)invalid_pte_table);
 	return pmd;
 }
 
-- 
2.30.2



