Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D051F2AC2A6
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 18:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731621AbgKIRk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 12:40:56 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:44011 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731476AbgKIRk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 12:40:56 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4CVJDv0DNTz9tyTB;
        Mon,  9 Nov 2020 18:40:47 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id UIuvxbl0moFo; Mon,  9 Nov 2020 18:40:46 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4CVJDt66v3z9tyT9;
        Mon,  9 Nov 2020 18:40:46 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 978298B7C5;
        Mon,  9 Nov 2020 18:40:52 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 07F2NDf0y9LI; Mon,  9 Nov 2020 18:40:52 +0100 (CET)
Received: from po17688vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5FD688B7C4;
        Mon,  9 Nov 2020 18:40:52 +0100 (CET)
Received: by po17688vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 6C87C66086; Mon,  9 Nov 2020 17:40:52 +0000 (UTC)
Message-Id: <9351d8a775f749d7c881c909388e69af944087b9.1604943353.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH for 5.4] powerpc/603: Always fault when _PAGE_ACCESSED is not set
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date:   Mon,  9 Nov 2020 17:40:52 +0000 (UTC)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[That is backport of 11522448e641e8f1690c9db06e01985e8e19b401 to linux 5.4]

The kernel expects pte_young() to work regardless of CONFIG_SWAP.

Make sure a minor fault is taken to set _PAGE_ACCESSED when it
is not already set, regardless of the selection of CONFIG_SWAP.

Fixes: 84de6ab0e904 ("powerpc/603: don't handle PAGE_ACCESSED in TLB miss handlers.")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/a44367744de54e2315b2f1a8cbbd7f88488072e0.1602342806.git.christophe.leroy@csgroup.eu
---
 arch/powerpc/kernel/head_32.S | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/powerpc/kernel/head_32.S b/arch/powerpc/kernel/head_32.S
index 5e2f2fd78b94..126ba5438430 100644
--- a/arch/powerpc/kernel/head_32.S
+++ b/arch/powerpc/kernel/head_32.S
@@ -418,11 +418,7 @@ InstructionTLBMiss:
 	cmplw	0,r1,r3
 #endif
 	mfspr	r2, SPRN_SPRG_PGDIR
-#ifdef CONFIG_SWAP
 	li	r1,_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC
-#else
-	li	r1,_PAGE_PRESENT | _PAGE_EXEC
-#endif
 #if defined(CONFIG_MODULES) || defined(CONFIG_DEBUG_PAGEALLOC)
 	bge-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
@@ -484,11 +480,7 @@ DataLoadTLBMiss:
 	lis	r1,PAGE_OFFSET@h		/* check if kernel address */
 	cmplw	0,r1,r3
 	mfspr	r2, SPRN_SPRG_PGDIR
-#ifdef CONFIG_SWAP
 	li	r1, _PAGE_PRESENT | _PAGE_ACCESSED
-#else
-	li	r1, _PAGE_PRESENT
-#endif
 	bge-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
 	addi	r2, r2, (swapper_pg_dir - PAGE_OFFSET)@l	/* kernel page table */
@@ -564,11 +556,7 @@ DataStoreTLBMiss:
 	lis	r1,PAGE_OFFSET@h		/* check if kernel address */
 	cmplw	0,r1,r3
 	mfspr	r2, SPRN_SPRG_PGDIR
-#ifdef CONFIG_SWAP
 	li	r1, _PAGE_RW | _PAGE_DIRTY | _PAGE_PRESENT | _PAGE_ACCESSED
-#else
-	li	r1, _PAGE_RW | _PAGE_DIRTY | _PAGE_PRESENT
-#endif
 	bge-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
 	addi	r2, r2, (swapper_pg_dir - PAGE_OFFSET)@l	/* kernel page table */
-- 
2.25.0

