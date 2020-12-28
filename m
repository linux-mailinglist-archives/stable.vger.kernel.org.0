Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C613C2E40BA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502601AbgL1O4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441203AbgL1OQd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:16:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07903207B2;
        Mon, 28 Dec 2020 14:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164977;
        bh=188XjPRh+cZ1IaC6Uq1dHcFkfB6s+a4moffO7X/Kn9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NHJYtDhO/Hnygx7SI+eRoWdtwkTKU0hg6XjhpFFPdLlNsiKu49L6qpSDjXVnvdKZy
         OGqQLp95BK5/ri2zkrui5Tqd89T95onT6qvKdX8IYyY3a0gGNhWR38WbrUYJZV1+/T
         amc5eZ2nBysqAUlU+7Y71EKuCNIeyuf4WlydzfuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Giuseppe Sacco <giuseppe@sguazz.it>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 366/717] powerpc/powermac: Fix low_sleep_handler with CONFIG_VMAP_STACK
Date:   Mon, 28 Dec 2020 13:46:04 +0100
Message-Id: <20201228125038.541431228@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit db972a3787d12b1ce9ba7a31ec376d8a79e04c47 ]

low_sleep_handler() can't restore the context from standard
stack because the stack can hardly be accessed with MMU OFF.

Store everything in a global storage area instead of storing
a pointer to the stack in that global storage area.

To avoid a complete churn of the function, still use r1 as
the pointer to the storage area during restore.

Fixes: cd08f109e262 ("powerpc/32s: Enable CONFIG_VMAP_STACK")
Reported-by: Giuseppe Sacco <giuseppe@sguazz.it>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Giuseppe Sacco <giuseppe@sguazz.it>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/e3e0d8042a3ba75cb4a9546c19c408b5b5b28994.1607404931.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/Kconfig.cputype  |   2 +-
 arch/powerpc/platforms/powermac/sleep.S | 132 +++++++++++-------------
 2 files changed, 60 insertions(+), 74 deletions(-)

diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index c194c4ae8bc7d..32a9c4c09b989 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -36,7 +36,7 @@ config PPC_BOOK3S_6xx
 	select PPC_HAVE_PMU_SUPPORT
 	select PPC_HAVE_KUEP
 	select PPC_HAVE_KUAP
-	select HAVE_ARCH_VMAP_STACK if !ADB_PMU
+	select HAVE_ARCH_VMAP_STACK
 
 config PPC_85xx
 	bool "Freescale 85xx"
diff --git a/arch/powerpc/platforms/powermac/sleep.S b/arch/powerpc/platforms/powermac/sleep.S
index 7e0f8ba6e54a5..d497a60003d2d 100644
--- a/arch/powerpc/platforms/powermac/sleep.S
+++ b/arch/powerpc/platforms/powermac/sleep.S
@@ -44,7 +44,8 @@
 #define SL_TB		0xa0
 #define SL_R2		0xa8
 #define SL_CR		0xac
-#define SL_R12		0xb0	/* r12 to r31 */
+#define SL_LR		0xb0
+#define SL_R12		0xb4	/* r12 to r31 */
 #define SL_SIZE		(SL_R12 + 80)
 
 	.section .text
@@ -63,105 +64,107 @@ _GLOBAL(low_sleep_handler)
 	blr
 #else
 	mflr	r0
-	stw	r0,4(r1)
-	stwu	r1,-SL_SIZE(r1)
+	lis	r11,sleep_storage@ha
+	addi	r11,r11,sleep_storage@l
+	stw	r0,SL_LR(r11)
 	mfcr	r0
-	stw	r0,SL_CR(r1)
-	stw	r2,SL_R2(r1)
-	stmw	r12,SL_R12(r1)
+	stw	r0,SL_CR(r11)
+	stw	r1,SL_SP(r11)
+	stw	r2,SL_R2(r11)
+	stmw	r12,SL_R12(r11)
 
 	/* Save MSR & SDR1 */
 	mfmsr	r4
-	stw	r4,SL_MSR(r1)
+	stw	r4,SL_MSR(r11)
 	mfsdr1	r4
-	stw	r4,SL_SDR1(r1)
+	stw	r4,SL_SDR1(r11)
 
 	/* Get a stable timebase and save it */
 1:	mftbu	r4
-	stw	r4,SL_TB(r1)
+	stw	r4,SL_TB(r11)
 	mftb	r5
-	stw	r5,SL_TB+4(r1)
+	stw	r5,SL_TB+4(r11)
 	mftbu	r3
 	cmpw	r3,r4
 	bne	1b
 
 	/* Save SPRGs */
 	mfsprg	r4,0
-	stw	r4,SL_SPRG0(r1)
+	stw	r4,SL_SPRG0(r11)
 	mfsprg	r4,1
-	stw	r4,SL_SPRG0+4(r1)
+	stw	r4,SL_SPRG0+4(r11)
 	mfsprg	r4,2
-	stw	r4,SL_SPRG0+8(r1)
+	stw	r4,SL_SPRG0+8(r11)
 	mfsprg	r4,3
-	stw	r4,SL_SPRG0+12(r1)
+	stw	r4,SL_SPRG0+12(r11)
 
 	/* Save BATs */
 	mfdbatu	r4,0
-	stw	r4,SL_DBAT0(r1)
+	stw	r4,SL_DBAT0(r11)
 	mfdbatl	r4,0
-	stw	r4,SL_DBAT0+4(r1)
+	stw	r4,SL_DBAT0+4(r11)
 	mfdbatu	r4,1
-	stw	r4,SL_DBAT1(r1)
+	stw	r4,SL_DBAT1(r11)
 	mfdbatl	r4,1
-	stw	r4,SL_DBAT1+4(r1)
+	stw	r4,SL_DBAT1+4(r11)
 	mfdbatu	r4,2
-	stw	r4,SL_DBAT2(r1)
+	stw	r4,SL_DBAT2(r11)
 	mfdbatl	r4,2
-	stw	r4,SL_DBAT2+4(r1)
+	stw	r4,SL_DBAT2+4(r11)
 	mfdbatu	r4,3
-	stw	r4,SL_DBAT3(r1)
+	stw	r4,SL_DBAT3(r11)
 	mfdbatl	r4,3
-	stw	r4,SL_DBAT3+4(r1)
+	stw	r4,SL_DBAT3+4(r11)
 	mfibatu	r4,0
-	stw	r4,SL_IBAT0(r1)
+	stw	r4,SL_IBAT0(r11)
 	mfibatl	r4,0
-	stw	r4,SL_IBAT0+4(r1)
+	stw	r4,SL_IBAT0+4(r11)
 	mfibatu	r4,1
-	stw	r4,SL_IBAT1(r1)
+	stw	r4,SL_IBAT1(r11)
 	mfibatl	r4,1
-	stw	r4,SL_IBAT1+4(r1)
+	stw	r4,SL_IBAT1+4(r11)
 	mfibatu	r4,2
-	stw	r4,SL_IBAT2(r1)
+	stw	r4,SL_IBAT2(r11)
 	mfibatl	r4,2
-	stw	r4,SL_IBAT2+4(r1)
+	stw	r4,SL_IBAT2+4(r11)
 	mfibatu	r4,3
-	stw	r4,SL_IBAT3(r1)
+	stw	r4,SL_IBAT3(r11)
 	mfibatl	r4,3
-	stw	r4,SL_IBAT3+4(r1)
+	stw	r4,SL_IBAT3+4(r11)
 
 BEGIN_MMU_FTR_SECTION
 	mfspr	r4,SPRN_DBAT4U
-	stw	r4,SL_DBAT4(r1)
+	stw	r4,SL_DBAT4(r11)
 	mfspr	r4,SPRN_DBAT4L
-	stw	r4,SL_DBAT4+4(r1)
+	stw	r4,SL_DBAT4+4(r11)
 	mfspr	r4,SPRN_DBAT5U
-	stw	r4,SL_DBAT5(r1)
+	stw	r4,SL_DBAT5(r11)
 	mfspr	r4,SPRN_DBAT5L
-	stw	r4,SL_DBAT5+4(r1)
+	stw	r4,SL_DBAT5+4(r11)
 	mfspr	r4,SPRN_DBAT6U
-	stw	r4,SL_DBAT6(r1)
+	stw	r4,SL_DBAT6(r11)
 	mfspr	r4,SPRN_DBAT6L
-	stw	r4,SL_DBAT6+4(r1)
+	stw	r4,SL_DBAT6+4(r11)
 	mfspr	r4,SPRN_DBAT7U
-	stw	r4,SL_DBAT7(r1)
+	stw	r4,SL_DBAT7(r11)
 	mfspr	r4,SPRN_DBAT7L
-	stw	r4,SL_DBAT7+4(r1)
+	stw	r4,SL_DBAT7+4(r11)
 	mfspr	r4,SPRN_IBAT4U
-	stw	r4,SL_IBAT4(r1)
+	stw	r4,SL_IBAT4(r11)
 	mfspr	r4,SPRN_IBAT4L
-	stw	r4,SL_IBAT4+4(r1)
+	stw	r4,SL_IBAT4+4(r11)
 	mfspr	r4,SPRN_IBAT5U
-	stw	r4,SL_IBAT5(r1)
+	stw	r4,SL_IBAT5(r11)
 	mfspr	r4,SPRN_IBAT5L
-	stw	r4,SL_IBAT5+4(r1)
+	stw	r4,SL_IBAT5+4(r11)
 	mfspr	r4,SPRN_IBAT6U
-	stw	r4,SL_IBAT6(r1)
+	stw	r4,SL_IBAT6(r11)
 	mfspr	r4,SPRN_IBAT6L
-	stw	r4,SL_IBAT6+4(r1)
+	stw	r4,SL_IBAT6+4(r11)
 	mfspr	r4,SPRN_IBAT7U
-	stw	r4,SL_IBAT7(r1)
+	stw	r4,SL_IBAT7(r11)
 	mfspr	r4,SPRN_IBAT7L
-	stw	r4,SL_IBAT7+4(r1)
+	stw	r4,SL_IBAT7+4(r11)
 END_MMU_FTR_SECTION_IFSET(MMU_FTR_USE_HIGH_BATS)
 
 	/* Backup various CPU config stuffs */
@@ -180,9 +183,9 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_USE_HIGH_BATS)
 	lis	r5,grackle_wake_up@ha
 	addi	r5,r5,grackle_wake_up@l
 	tophys(r5,r5)
-	stw	r5,SL_PC(r1)
+	stw	r5,SL_PC(r11)
 	lis	r4,KERNELBASE@h
-	tophys(r5,r1)
+	tophys(r5,r11)
 	addi	r5,r5,SL_PC
 	lis	r6,MAGIC@ha
 	addi	r6,r6,MAGIC@l
@@ -194,12 +197,6 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_USE_HIGH_BATS)
 	tophys(r3,r3)
 	stw	r3,0x80(r4)
 	stw	r5,0x84(r4)
-	/* Store a pointer to our backup storage into
-	 * a kernel global
-	 */
-	lis r3,sleep_storage@ha
-	addi r3,r3,sleep_storage@l
-	stw r5,0(r3)
 
 	.globl	low_cpu_offline_self
 low_cpu_offline_self:
@@ -279,7 +276,7 @@ _GLOBAL(core99_wake_up)
 	lis	r3,sleep_storage@ha
 	addi	r3,r3,sleep_storage@l
 	tophys(r3,r3)
-	lwz	r1,0(r3)
+	addi	r1,r3,SL_PC
 
 	/* Pass thru to older resume code ... */
 _ASM_NOKPROBE_SYMBOL(core99_wake_up)
@@ -399,13 +396,6 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_USE_HIGH_BATS)
 	blt	1b
 	sync
 
-	/* restore the MSR and turn on the MMU */
-	lwz	r3,SL_MSR(r1)
-	bl	turn_on_mmu
-
-	/* get back the stack pointer */
-	tovirt(r1,r1)
-
 	/* Restore TB */
 	li	r3,0
 	mttbl	r3
@@ -419,28 +409,24 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_USE_HIGH_BATS)
 	mtcr	r0
 	lwz	r2,SL_R2(r1)
 	lmw	r12,SL_R12(r1)
-	addi	r1,r1,SL_SIZE
-	lwz	r0,4(r1)
-	mtlr	r0
-	blr
-_ASM_NOKPROBE_SYMBOL(grackle_wake_up)
 
-turn_on_mmu:
-	mflr	r4
-	tovirt(r4,r4)
+	/* restore the MSR and SP and turn on the MMU and return */
+	lwz	r3,SL_MSR(r1)
+	lwz	r4,SL_LR(r1)
+	lwz	r1,SL_SP(r1)
 	mtsrr0	r4
 	mtsrr1	r3
 	sync
 	isync
 	rfi
-_ASM_NOKPROBE_SYMBOL(turn_on_mmu)
+_ASM_NOKPROBE_SYMBOL(grackle_wake_up)
 
 #endif /* defined(CONFIG_PM) || defined(CONFIG_CPU_FREQ) */
 
-	.section .data
+	.section .bss
 	.balign	L1_CACHE_BYTES
 sleep_storage:
-	.long 0
+	.space SL_SIZE
 	.balign	L1_CACHE_BYTES, 0
 
 #endif /* CONFIG_PPC_BOOK3S_32 */
-- 
2.27.0



