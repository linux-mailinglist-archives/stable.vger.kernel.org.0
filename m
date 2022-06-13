Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAB5548991
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359712AbiFMNU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377118AbiFMNUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:20:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74A46A01F;
        Mon, 13 Jun 2022 04:23:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE51EB80EA8;
        Mon, 13 Jun 2022 11:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CA3C34114;
        Mon, 13 Jun 2022 11:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119371;
        bh=Dj/kSjaqhkxhxJKbMWzx5gYqGhBbJl2vIhWkkBUPOC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZbIE/DJ4U7k+MDpTn3hLFDZpmRU8yZj5SG6tA15BGwznEHksIoPsgP0llkfaL5FRq
         Gt4IuG2n0uLZig/LK5u4hhrUn5lKwBhnHUBqR55coNlSQEapt9MHd6X0y6hXUp13Xg
         CnAAWAGjkrdoQBlY/wLr8M/uL9A5xnY/fVCwedL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 239/247] powerpc/mm: Switch obsolete dssall to .long
Date:   Mon, 13 Jun 2022 12:12:21 +0200
Message-Id: <20220613094930.195445063@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

commit d51f86cfd8e378d4907958db77da3074f6dce3ba upstream.

The dssall ("Data Stream Stop All") instruction is obsolete altogether
with other Data Cache Instructions since ISA 2.03 (year 2006).

LLVM IAS does not support it but PPC970 seems to be using it.
This switches dssall to .long as there is no much point in fixing LLVM.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211221055904.555763-6-aik@ozlabs.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/ppc-opcode.h   |    2 ++
 arch/powerpc/kernel/idle.c              |    2 +-
 arch/powerpc/kernel/idle_6xx.S          |    2 +-
 arch/powerpc/kernel/l2cr_6xx.S          |    6 +++---
 arch/powerpc/kernel/swsusp_32.S         |    2 +-
 arch/powerpc/kernel/swsusp_asm64.S      |    2 +-
 arch/powerpc/mm/mmu_context.c           |    2 +-
 arch/powerpc/platforms/powermac/cache.S |    4 ++--
 8 files changed, 12 insertions(+), 10 deletions(-)

--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -249,6 +249,7 @@
 #define PPC_INST_COPY			0x7c20060c
 #define PPC_INST_DCBA			0x7c0005ec
 #define PPC_INST_DCBA_MASK		0xfc0007fe
+#define PPC_INST_DSSALL			0x7e00066c
 #define PPC_INST_ISEL			0x7c00001e
 #define PPC_INST_ISEL_MASK		0xfc00003e
 #define PPC_INST_LSWI			0x7c0004aa
@@ -576,6 +577,7 @@
 #define	PPC_DCBZL(a, b)		stringify_in_c(.long PPC_RAW_DCBZL(a, b))
 #define	PPC_DIVDE(t, a, b)	stringify_in_c(.long PPC_RAW_DIVDE(t, a, b))
 #define	PPC_DIVDEU(t, a, b)	stringify_in_c(.long PPC_RAW_DIVDEU(t, a, b))
+#define PPC_DSSALL		stringify_in_c(.long PPC_INST_DSSALL)
 #define PPC_LQARX(t, a, b, eh)	stringify_in_c(.long PPC_RAW_LQARX(t, a, b, eh))
 #define PPC_STQCX(t, a, b)	stringify_in_c(.long PPC_RAW_STQCX(t, a, b))
 #define PPC_MADDHD(t, a, b, c)	stringify_in_c(.long PPC_RAW_MADDHD(t, a, b, c))
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -82,7 +82,7 @@ void power4_idle(void)
 		return;
 
 	if (cpu_has_feature(CPU_FTR_ALTIVEC))
-		asm volatile("DSSALL ; sync" ::: "memory");
+		asm volatile(PPC_DSSALL " ; sync" ::: "memory");
 
 	power4_idle_nap();
 
--- a/arch/powerpc/kernel/idle_6xx.S
+++ b/arch/powerpc/kernel/idle_6xx.S
@@ -129,7 +129,7 @@ BEGIN_FTR_SECTION
 END_FTR_SECTION_IFCLR(CPU_FTR_NO_DPM)
 	mtspr	SPRN_HID0,r4
 BEGIN_FTR_SECTION
-	DSSALL
+	PPC_DSSALL
 	sync
 END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 	lwz	r8,TI_LOCAL_FLAGS(r2)	/* set napping bit */
--- a/arch/powerpc/kernel/l2cr_6xx.S
+++ b/arch/powerpc/kernel/l2cr_6xx.S
@@ -96,7 +96,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_L2CR)
 
 	/* Stop DST streams */
 BEGIN_FTR_SECTION
-	DSSALL
+	PPC_DSSALL
 	sync
 END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 
@@ -292,7 +292,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_L3CR)
 	isync
 
 	/* Stop DST streams */
-	DSSALL
+	PPC_DSSALL
 	sync
 
 	/* Get the current enable bit of the L3CR into r4 */
@@ -401,7 +401,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_L3CR)
 _GLOBAL(__flush_disable_L1)
 	/* Stop pending alitvec streams and memory accesses */
 BEGIN_FTR_SECTION
-	DSSALL
+	PPC_DSSALL
 END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
  	sync
 
--- a/arch/powerpc/kernel/swsusp_32.S
+++ b/arch/powerpc/kernel/swsusp_32.S
@@ -181,7 +181,7 @@ _GLOBAL(swsusp_arch_resume)
 #ifdef CONFIG_ALTIVEC
 	/* Stop pending alitvec streams and memory accesses */
 BEGIN_FTR_SECTION
-	DSSALL
+	PPC_DSSALL
 END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 #endif
  	sync
--- a/arch/powerpc/kernel/swsusp_asm64.S
+++ b/arch/powerpc/kernel/swsusp_asm64.S
@@ -142,7 +142,7 @@ END_FW_FTR_SECTION_IFCLR(FW_FEATURE_LPAR
 _GLOBAL(swsusp_arch_resume)
 	/* Stop pending alitvec streams and memory accesses */
 BEGIN_FTR_SECTION
-	DSSALL
+	PPC_DSSALL
 END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 	sync
 
--- a/arch/powerpc/mm/mmu_context.c
+++ b/arch/powerpc/mm/mmu_context.c
@@ -81,7 +81,7 @@ void switch_mm_irqs_off(struct mm_struct
 	 * context
 	 */
 	if (cpu_has_feature(CPU_FTR_ALTIVEC))
-		asm volatile ("dssall");
+		asm volatile (PPC_DSSALL);
 
 	if (!new_on_cpu)
 		membarrier_arch_switch_mm(prev, next, tsk);
--- a/arch/powerpc/platforms/powermac/cache.S
+++ b/arch/powerpc/platforms/powermac/cache.S
@@ -48,7 +48,7 @@ flush_disable_75x:
 
 	/* Stop DST streams */
 BEGIN_FTR_SECTION
-	DSSALL
+	PPC_DSSALL
 	sync
 END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 
@@ -197,7 +197,7 @@ flush_disable_745x:
 	isync
 
 	/* Stop prefetch streams */
-	DSSALL
+	PPC_DSSALL
 	sync
 
 	/* Disable L2 prefetching */


