Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FC129B4CF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793529AbgJ0PGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790937AbgJ0PEu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:04:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 436572071A;
        Tue, 27 Oct 2020 15:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811089;
        bh=D6CmrTf6q2KupTEsc6y18uYP+IEiFGZ/b2GEyFpSSHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WETBNtolt9vVXO72xOmRBehIJcK7KKL8POAp7fX7N0AlTcETwQnr5JhsfH25YxaoE
         tvp9XRDgrMguIGQdXCpAgChfMScxYXrs+7/Lm3qhmEM1ixSW5lPbZCpnBZUk5PLQjp
         +3lHL3ZYilEHulf2ncN+aaWbhX+VqCLnxX1p8Alo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 369/633] powerpc/kasan: Fix CONFIG_KASAN_VMALLOC for 8xx
Date:   Tue, 27 Oct 2020 14:51:52 +0100
Message-Id: <20201027135540.011627138@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 4c42dc5c69a8f24c467a6c997909d2f1d4efdc7f ]

Before the commit identified below, pages tables allocation was
performed after the allocation of final shadow area for linear memory.
But that commit switched the order, leading to page tables being
already allocated at the time 8xx kasan_init_shadow_8M() is called.
Due to this, kasan_init_shadow_8M() doesn't map the needed
shadow entries because there are already page tables.

kasan_init_shadow_8M() installs huge PMD entries instead of page
tables. We could at that time free the page tables, but there is no
point in creating page tables that get freed before being used.

Only book3s/32 hash needs early allocation of page tables. For other
variants, we can keep the initial order and create remaining page
tables after the allocation of final shadow memory for linear mem.

Move back the allocation of shadow page tables for
CONFIG_KASAN_VMALLOC into kasan_init() after the loop which creates
final shadow memory for linear mem.

Fixes: 41ea93cf7ba4 ("powerpc/kasan: Fix shadow pages allocation failure")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/8ae4554357da4882612644a74387ae05525b2aaa.1599800716.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/kasan/kasan_init_32.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/mm/kasan/kasan_init_32.c b/arch/powerpc/mm/kasan/kasan_init_32.c
index 019b0c0bbbf31..ca91d04d0a7ae 100644
--- a/arch/powerpc/mm/kasan/kasan_init_32.c
+++ b/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -121,8 +121,7 @@ void __init kasan_mmu_init(void)
 {
 	int ret;
 
-	if (early_mmu_has_feature(MMU_FTR_HPTE_TABLE) ||
-	    IS_ENABLED(CONFIG_KASAN_VMALLOC)) {
+	if (early_mmu_has_feature(MMU_FTR_HPTE_TABLE)) {
 		ret = kasan_init_shadow_page_tables(KASAN_SHADOW_START, KASAN_SHADOW_END);
 
 		if (ret)
@@ -133,11 +132,11 @@ void __init kasan_mmu_init(void)
 void __init kasan_init(void)
 {
 	struct memblock_region *reg;
+	int ret;
 
 	for_each_memblock(memory, reg) {
 		phys_addr_t base = reg->base;
 		phys_addr_t top = min(base + reg->size, total_lowmem);
-		int ret;
 
 		if (base >= top)
 			continue;
@@ -147,6 +146,13 @@ void __init kasan_init(void)
 			panic("kasan: kasan_init_region() failed");
 	}
 
+	if (IS_ENABLED(CONFIG_KASAN_VMALLOC)) {
+		ret = kasan_init_shadow_page_tables(KASAN_SHADOW_START, KASAN_SHADOW_END);
+
+		if (ret)
+			panic("kasan: kasan_init_shadow_page_tables() failed");
+	}
+
 	kasan_remap_early_shadow_ro();
 
 	clear_page(kasan_early_shadow_page);
-- 
2.25.1



