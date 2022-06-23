Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980A2557603
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 10:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiFWI4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 04:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiFWI4q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 04:56:46 -0400
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E6A38186;
        Thu, 23 Jun 2022 01:56:45 -0700 (PDT)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4LTDdR3RDNz9t7C;
        Thu, 23 Jun 2022 10:56:43 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rB5xfNfnoNUc; Thu, 23 Jun 2022 10:56:43 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4LTDdR2ZVlz9t6Q;
        Thu, 23 Jun 2022 10:56:43 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 4743A8B781;
        Thu, 23 Jun 2022 10:56:43 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id UwjsiME56Pee; Thu, 23 Jun 2022 10:56:43 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.232.34])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 0E5DD8B763;
        Thu, 23 Jun 2022 10:56:43 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 25N8uSoh1200275
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 10:56:28 +0200
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 25N8uQxD1200273;
        Thu, 23 Jun 2022 10:56:26 +0200
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org, Mike Rapoport <rppt@kernel.org>
Subject: [PATCH] powerpc/book3e: Fix PUD allocation size in map_kernel_page()
Date:   Thu, 23 Jun 2022 10:56:17 +0200
Message-Id: <95ddfd6176d53e6c85e13bd1c358359daa56775f.1655974558.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1655974576; l=1585; s=20211009; h=from:subject:message-id; bh=Jp+v78vMca/ZhgxNxJxjjN47ttG4snyxnWxwIcvn2FQ=; b=fJWL366FpnhIey5YC0D33IJ7uJFJfP4T2HGGw2n467rJNOmNOfAXj50BgSY2G8/9K+C2sVEqPX44 PQ5ia/7VBfwecEkzZYzGvniMO7D8QDIedqs7buR9CEcBRP+4L2G6
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 2fb4706057bc ("powerpc: add support for folded p4d page tables")
erroneously changed PUD setup to a mix of PMD and PUD. Fix it.

While at it, use PTE_TABLE_SIZE instead of PAGE_SIZE for PTE tables
in order to avoid any confusion.

Fixes: 2fb4706057bc ("powerpc: add support for folded p4d page tables")
Cc: stable@vger.kernel.org
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 arch/powerpc/mm/nohash/book3e_pgtable.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/mm/nohash/book3e_pgtable.c b/arch/powerpc/mm/nohash/book3e_pgtable.c
index 7d4368d055a6..b80fc4a91a53 100644
--- a/arch/powerpc/mm/nohash/book3e_pgtable.c
+++ b/arch/powerpc/mm/nohash/book3e_pgtable.c
@@ -96,8 +96,8 @@ int __ref map_kernel_page(unsigned long ea, unsigned long pa, pgprot_t prot)
 		pgdp = pgd_offset_k(ea);
 		p4dp = p4d_offset(pgdp, ea);
 		if (p4d_none(*p4dp)) {
-			pmdp = early_alloc_pgtable(PMD_TABLE_SIZE);
-			p4d_populate(&init_mm, p4dp, pmdp);
+			pudp = early_alloc_pgtable(PUD_TABLE_SIZE);
+			p4d_populate(&init_mm, p4dp, pudp);
 		}
 		pudp = pud_offset(p4dp, ea);
 		if (pud_none(*pudp)) {
@@ -106,7 +106,7 @@ int __ref map_kernel_page(unsigned long ea, unsigned long pa, pgprot_t prot)
 		}
 		pmdp = pmd_offset(pudp, ea);
 		if (!pmd_present(*pmdp)) {
-			ptep = early_alloc_pgtable(PAGE_SIZE);
+			ptep = early_alloc_pgtable(PTE_TABLE_SIZE);
 			pmd_populate_kernel(&init_mm, pmdp, ptep);
 		}
 		ptep = pte_offset_kernel(pmdp, ea);
-- 
2.36.1

