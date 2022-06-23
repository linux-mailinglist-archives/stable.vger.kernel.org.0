Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B73525586EA
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbiFWSSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236885AbiFWSQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:16:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EEC62C1C;
        Thu, 23 Jun 2022 10:23:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2EFFB824B9;
        Thu, 23 Jun 2022 17:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E977BC3411B;
        Thu, 23 Jun 2022 17:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656005013;
        bh=Pplf4yDHXUbuRV90A27MZmzIBQ4huT/4sBw/QKEODoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHbaHaGWra/dfs9catmtQwBQj8oUUVnGOSjdp0lqgTBJFAxPn86H+ITqfVQr80sih
         g7h2DH/JzCMNFmejUHvqNc/qw6n6/SSBrILePxm+vLL5kG9Dpn3fdf98VTf8kQTj9w
         PZy9egRavgu/8Qz48wPoeeslgLieoyXZmh9+n2a8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.19 224/234] powerpc/mm: Switch obsolete dssall to .long
Date:   Thu, 23 Jun 2022 18:44:51 +0200
Message-Id: <20220623164349.388634935@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/ppc-opcode.h   |    2 ++
 arch/powerpc/kernel/idle_6xx.S          |    2 +-
 arch/powerpc/kernel/l2cr_6xx.S          |    6 +++---
 arch/powerpc/kernel/swsusp_32.S         |    2 +-
 arch/powerpc/kernel/swsusp_asm64.S      |    2 +-
 arch/powerpc/mm/mmu_context.c           |    2 +-
 arch/powerpc/platforms/powermac/cache.S |    4 ++--
 7 files changed, 11 insertions(+), 9 deletions(-)

--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -207,6 +207,7 @@
 #define PPC_INST_ICBT			0x7c00002c
 #define PPC_INST_ICSWX			0x7c00032d
 #define PPC_INST_ICSWEPX		0x7c00076d
+#define PPC_INST_DSSALL			0x7e00066c
 #define PPC_INST_ISEL			0x7c00001e
 #define PPC_INST_ISEL_MASK		0xfc00003e
 #define PPC_INST_LDARX			0x7c0000a8
@@ -424,6 +425,7 @@
 					__PPC_RA(a) | __PPC_RB(b))
 #define	PPC_DCBZL(a, b)		stringify_in_c(.long PPC_INST_DCBZL | \
 					__PPC_RA(a) | __PPC_RB(b))
+#define PPC_DSSALL		stringify_in_c(.long PPC_INST_DSSALL)
 #define PPC_LQARX(t, a, b, eh)	stringify_in_c(.long PPC_INST_LQARX | \
 					___PPC_RT(t) | ___PPC_RA(a) | \
 					___PPC_RB(b) | __PPC_EH(eh))
--- a/arch/powerpc/kernel/idle_6xx.S
+++ b/arch/powerpc/kernel/idle_6xx.S
@@ -133,7 +133,7 @@ BEGIN_FTR_SECTION
 END_FTR_SECTION_IFCLR(CPU_FTR_NO_DPM)
 	mtspr	SPRN_HID0,r4
 BEGIN_FTR_SECTION
-	DSSALL
+	PPC_DSSALL
 	sync
 END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 	CURRENT_THREAD_INFO(r9, r1)
--- a/arch/powerpc/kernel/l2cr_6xx.S
+++ b/arch/powerpc/kernel/l2cr_6xx.S
@@ -108,7 +108,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_L2CR)
 
 	/* Stop DST streams */
 BEGIN_FTR_SECTION
-	DSSALL
+	PPC_DSSALL
 	sync
 END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 
@@ -305,7 +305,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_L3CR)
 	isync
 
 	/* Stop DST streams */
-	DSSALL
+	PPC_DSSALL
 	sync
 
 	/* Get the current enable bit of the L3CR into r4 */
@@ -414,7 +414,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_L3CR)
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
@@ -143,7 +143,7 @@ END_FW_FTR_SECTION_IFCLR(FW_FEATURE_LPAR
 _GLOBAL(swsusp_arch_resume)
 	/* Stop pending alitvec streams and memory accesses */
 BEGIN_FTR_SECTION
-	DSSALL
+	PPC_DSSALL
 END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 	sync
 
--- a/arch/powerpc/mm/mmu_context.c
+++ b/arch/powerpc/mm/mmu_context.c
@@ -83,7 +83,7 @@ void switch_mm_irqs_off(struct mm_struct
 	 * context
 	 */
 	if (cpu_has_feature(CPU_FTR_ALTIVEC))
-		asm volatile ("dssall");
+		asm volatile (PPC_DSSALL);
 
 	if (new_on_cpu)
 		radix_kvm_prefetch_workaround(next);
--- a/arch/powerpc/platforms/powermac/cache.S
+++ b/arch/powerpc/platforms/powermac/cache.S
@@ -53,7 +53,7 @@ flush_disable_75x:
 
 	/* Stop DST streams */
 BEGIN_FTR_SECTION
-	DSSALL
+	PPC_DSSALL
 	sync
 END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 
@@ -201,7 +201,7 @@ flush_disable_745x:
 	isync
 
 	/* Stop prefetch streams */
-	DSSALL
+	PPC_DSSALL
 	sync
 
 	/* Disable L2 prefetching */


