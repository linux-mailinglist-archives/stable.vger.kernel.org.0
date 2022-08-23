Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFC159DCC2
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242781AbiHWKRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353404AbiHWKPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:15:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8D772FE2;
        Tue, 23 Aug 2022 02:00:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD1086155E;
        Tue, 23 Aug 2022 09:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C84C433D6;
        Tue, 23 Aug 2022 09:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245204;
        bh=6XxyMxUtDNh1xCRAMJ3F1TbsgLln1XdyvazR/OQeeGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrzczDhNy0sDzF3moSzqwgT8/eFjxxT+mRknJkmeZAHI+ccohL6ybSdzKKHkKTaHU
         ULMakhFNz1gLPxqBlawzxcJYFzS7gha2PBqgCA3sJKPOOEO5Rr6JDgjXv5oDmGUvpM
         sPLFBYJWv/Ta3IgYS/txhmiM/2bDrHZVcFZWajx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 220/244] powerpc/32: Set an IBAT covering up to _einittext during init
Date:   Tue, 23 Aug 2022 10:26:19 +0200
Message-Id: <20220823080106.884379948@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 2a0fb3c155c97c75176e557d61f8e66c1bd9b735 ]

Always set an IBAT covering up to _einittext during init because when
CONFIG_MODULES is not selected there is no reason to have an exception
handler for kernel instruction TLB misses.

It implies DBAT and IBAT are now totaly independent, IBATs are set
by setibat() and DBAT by setbat().

This allows to revert commit 9bb162fa26ed ("powerpc/603: Fix
boot failure with DEBUG_PAGEALLOC and KFENCE")

Reported-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/ce7f04a39593934d9b1ee68c69144ccd3d4da4a1.1655202804.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/head_book3s_32.S |  4 ++--
 arch/powerpc/mm/book3s32/mmu.c       | 10 ++++------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kernel/head_book3s_32.S b/arch/powerpc/kernel/head_book3s_32.S
index 2e2a8211b17b..68e5c0a7e99d 100644
--- a/arch/powerpc/kernel/head_book3s_32.S
+++ b/arch/powerpc/kernel/head_book3s_32.S
@@ -421,14 +421,14 @@ InstructionTLBMiss:
  */
 	/* Get PTE (linux-style) and check access */
 	mfspr	r3,SPRN_IMISS
-#if defined(CONFIG_MODULES) || defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KFENCE)
+#ifdef CONFIG_MODULES
 	lis	r1, TASK_SIZE@h		/* check if kernel address */
 	cmplw	0,r1,r3
 #endif
 	mfspr	r2, SPRN_SDR1
 	li	r1,_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC | _PAGE_USER
 	rlwinm	r2, r2, 28, 0xfffff000
-#if defined(CONFIG_MODULES) || defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KFENCE)
+#ifdef CONFIG_MODULES
 	bgt-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
 	li	r1,_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC
diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/mmu.c
index 203735caf691..bfca0afe9112 100644
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -160,7 +160,10 @@ unsigned long __init mmu_mapin_ram(unsigned long base, unsigned long top)
 {
 	unsigned long done;
 	unsigned long border = (unsigned long)__init_begin - PAGE_OFFSET;
+	unsigned long size;
 
+	size = roundup_pow_of_two((unsigned long)_einittext - PAGE_OFFSET);
+	setibat(0, PAGE_OFFSET, 0, size, PAGE_KERNEL_X);
 
 	if (debug_pagealloc_enabled_or_kfence() || __map_without_bats) {
 		pr_debug_once("Read-Write memory mapped without BATs\n");
@@ -246,10 +249,9 @@ void mmu_mark_rodata_ro(void)
 }
 
 /*
- * Set up one of the I/D BAT (block address translation) register pairs.
+ * Set up one of the D BAT (block address translation) register pairs.
  * The parameters are not checked; in particular size must be a power
  * of 2 between 128k and 256M.
- * On 603+, only set IBAT when _PAGE_EXEC is set
  */
 void __init setbat(int index, unsigned long virt, phys_addr_t phys,
 		   unsigned int size, pgprot_t prot)
@@ -285,10 +287,6 @@ void __init setbat(int index, unsigned long virt, phys_addr_t phys,
 		/* G bit must be zero in IBATs */
 		flags &= ~_PAGE_EXEC;
 	}
-	if (flags & _PAGE_EXEC)
-		bat[0] = bat[1];
-	else
-		bat[0].batu = bat[0].batl = 0;
 
 	bat_addrs[index].start = virt;
 	bat_addrs[index].limit = virt + ((bl + 1) << 17) - 1;
-- 
2.35.1



