Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3607B5EA2A2
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237555AbiIZLLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237455AbiIZLLH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:11:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF585FF67;
        Mon, 26 Sep 2022 03:35:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0352FB80952;
        Mon, 26 Sep 2022 10:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B18BC433C1;
        Mon, 26 Sep 2022 10:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188455;
        bh=CpH7sa+frMK4P/NHOW7zUyXx8HsPQqRjzHYIcfGFvRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BjAPVzMmCm1qNYsb/Xp+juzNtGQqbQq1V09lE685oLhQu/HAGalLlFZT6OHKTaiT3
         GeODHZndOTr57sdWpxkl/kKVURL0iRPeZ3GCmNPS267KEaEPwvTn7EzDP8MQaQO3t4
         18tLVBbsDcnFT0ic9Ka4NxA0WigIuO5+yNclVMXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/148] powerpc/rtas: Move rtas entry assembly into its own file
Date:   Mon, 26 Sep 2022 12:10:47 +0200
Message-Id: <20220926100756.539397084@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 838ee286ecc9a3c76e6bd8f5aaad0c8c5c66b9ca ]

This makes working on the code a bit easier.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220308135047.478297-2-npiggin@gmail.com
Stable-dep-of: 91926d8b7e71 ("powerpc/rtas: Fix RTAS MSR[HV] handling for Cell")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/Makefile     |   2 +-
 arch/powerpc/kernel/entry_32.S   |  49 --------
 arch/powerpc/kernel/entry_64.S   | 150 -----------------------
 arch/powerpc/kernel/rtas_entry.S | 198 +++++++++++++++++++++++++++++++
 4 files changed, 199 insertions(+), 200 deletions(-)
 create mode 100644 arch/powerpc/kernel/rtas_entry.S

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index ed91d5b9ffc6..df1692020693 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -69,7 +69,7 @@ obj-$(CONFIG_PPC_BOOK3S_IDLE)	+= idle_book3s.o
 procfs-y			:= proc_powerpc.o
 obj-$(CONFIG_PROC_FS)		+= $(procfs-y)
 rtaspci-$(CONFIG_PPC64)-$(CONFIG_PCI)	:= rtas_pci.o
-obj-$(CONFIG_PPC_RTAS)		+= rtas.o rtas-rtc.o $(rtaspci-y-y)
+obj-$(CONFIG_PPC_RTAS)		+= rtas_entry.o rtas.o rtas-rtc.o $(rtaspci-y-y)
 obj-$(CONFIG_PPC_RTAS_DAEMON)	+= rtasd.o
 obj-$(CONFIG_RTAS_FLASH)	+= rtas_flash.o
 obj-$(CONFIG_RTAS_PROC)		+= rtas-proc.o
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index c62dd9815965..77b6b0e4b752 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -526,52 +526,3 @@ ret_from_mcheck_exc:
 _ASM_NOKPROBE_SYMBOL(ret_from_mcheck_exc)
 #endif /* CONFIG_BOOKE */
 #endif /* !(CONFIG_4xx || CONFIG_BOOKE) */
-
-/*
- * PROM code for specific machines follows.  Put it
- * here so it's easy to add arch-specific sections later.
- * -- Cort
- */
-#ifdef CONFIG_PPC_RTAS
-/*
- * On CHRP, the Run-Time Abstraction Services (RTAS) have to be
- * called with the MMU off.
- */
-_GLOBAL(enter_rtas)
-	stwu	r1,-INT_FRAME_SIZE(r1)
-	mflr	r0
-	stw	r0,INT_FRAME_SIZE+4(r1)
-	LOAD_REG_ADDR(r4, rtas)
-	lis	r6,1f@ha	/* physical return address for rtas */
-	addi	r6,r6,1f@l
-	tophys(r6,r6)
-	lwz	r8,RTASENTRY(r4)
-	lwz	r4,RTASBASE(r4)
-	mfmsr	r9
-	stw	r9,8(r1)
-	LOAD_REG_IMMEDIATE(r0,MSR_KERNEL)
-	mtmsr	r0	/* disable interrupts so SRR0/1 don't get trashed */
-	li	r9,MSR_KERNEL & ~(MSR_IR|MSR_DR)
-	mtlr	r6
-	stw	r1, THREAD + RTAS_SP(r2)
-	mtspr	SPRN_SRR0,r8
-	mtspr	SPRN_SRR1,r9
-	rfi
-1:
-	lis	r8, 1f@h
-	ori	r8, r8, 1f@l
-	LOAD_REG_IMMEDIATE(r9,MSR_KERNEL)
-	mtspr	SPRN_SRR0,r8
-	mtspr	SPRN_SRR1,r9
-	rfi			/* Reactivate MMU translation */
-1:
-	lwz	r8,INT_FRAME_SIZE+4(r1)	/* get return address */
-	lwz	r9,8(r1)	/* original msr value */
-	addi	r1,r1,INT_FRAME_SIZE
-	li	r0,0
-	stw	r0, THREAD + RTAS_SP(r2)
-	mtlr	r8
-	mtmsr	r9
-	blr			/* return to caller */
-_ASM_NOKPROBE_SYMBOL(enter_rtas)
-#endif /* CONFIG_PPC_RTAS */
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 07a1448146e2..d1ec22fe59f6 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -264,156 +264,6 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_207S)
 	addi	r1,r1,SWITCH_FRAME_SIZE
 	blr
 
-#ifdef CONFIG_PPC_RTAS
-/*
- * On CHRP, the Run-Time Abstraction Services (RTAS) have to be
- * called with the MMU off.
- *
- * In addition, we need to be in 32b mode, at least for now.
- * 
- * Note: r3 is an input parameter to rtas, so don't trash it...
- */
-_GLOBAL(enter_rtas)
-	mflr	r0
-	std	r0,16(r1)
-        stdu	r1,-SWITCH_FRAME_SIZE(r1) /* Save SP and create stack space. */
-
-	/* Because RTAS is running in 32b mode, it clobbers the high order half
-	 * of all registers that it saves.  We therefore save those registers
-	 * RTAS might touch to the stack.  (r0, r3-r13 are caller saved)
-   	 */
-	SAVE_GPR(2, r1)			/* Save the TOC */
-	SAVE_GPR(13, r1)		/* Save paca */
-	SAVE_NVGPRS(r1)			/* Save the non-volatiles */
-
-	mfcr	r4
-	std	r4,_CCR(r1)
-	mfctr	r5
-	std	r5,_CTR(r1)
-	mfspr	r6,SPRN_XER
-	std	r6,_XER(r1)
-	mfdar	r7
-	std	r7,_DAR(r1)
-	mfdsisr	r8
-	std	r8,_DSISR(r1)
-
-	/* Temporary workaround to clear CR until RTAS can be modified to
-	 * ignore all bits.
-	 */
-	li	r0,0
-	mtcr	r0
-
-#ifdef CONFIG_BUG
-	/* There is no way it is acceptable to get here with interrupts enabled,
-	 * check it with the asm equivalent of WARN_ON
-	 */
-	lbz	r0,PACAIRQSOFTMASK(r13)
-1:	tdeqi	r0,IRQS_ENABLED
-	EMIT_WARN_ENTRY 1b,__FILE__,__LINE__,BUGFLAG_WARNING
-#endif
-
-	/* Hard-disable interrupts */
-	mfmsr	r6
-	rldicl	r7,r6,48,1
-	rotldi	r7,r7,16
-	mtmsrd	r7,1
-
-	/* Unfortunately, the stack pointer and the MSR are also clobbered,
-	 * so they are saved in the PACA which allows us to restore
-	 * our original state after RTAS returns.
-         */
-	std	r1,PACAR1(r13)
-        std	r6,PACASAVEDMSR(r13)
-
-	/* Setup our real return addr */	
-	LOAD_REG_ADDR(r4,rtas_return_loc)
-	clrldi	r4,r4,2			/* convert to realmode address */
-       	mtlr	r4
-
-__enter_rtas:
-	LOAD_REG_ADDR(r4, rtas)
-	ld	r5,RTASENTRY(r4)	/* get the rtas->entry value */
-	ld	r4,RTASBASE(r4)		/* get the rtas->base value */
-
-	/*
-	 * RTAS runs in 32-bit big endian real mode, but leave MSR[RI] on as we
-	 * may hit NMI (SRESET or MCE) while in RTAS. RTAS should disable RI in
-	 * its critical regions (as specified in PAPR+ section 7.2.1). MSR[S]
-	 * is not impacted by RFI_TO_KERNEL (only urfid can unset it). So if
-	 * MSR[S] is set, it will remain when entering RTAS.
-	 */
-	LOAD_REG_IMMEDIATE(r6, MSR_ME | MSR_RI)
-
-	li      r0,0
-	mtmsrd  r0,1                    /* disable RI before using SRR0/1 */
-	
-	mtspr	SPRN_SRR0,r5
-	mtspr	SPRN_SRR1,r6
-	RFI_TO_KERNEL
-	b	.	/* prevent speculative execution */
-
-rtas_return_loc:
-	FIXUP_ENDIAN
-
-	/*
-	 * Clear RI and set SF before anything.
-	 */
-	mfmsr   r6
-	li	r0,MSR_RI
-	andc	r6,r6,r0
-	sldi	r0,r0,(MSR_SF_LG - MSR_RI_LG)
-	or	r6,r6,r0
-	sync
-	mtmsrd  r6
-
-	/* relocation is off at this point */
-	GET_PACA(r4)
-	clrldi	r4,r4,2			/* convert to realmode address */
-
-	bcl	20,31,$+4
-0:	mflr	r3
-	ld	r3,(1f-0b)(r3)		/* get &rtas_restore_regs */
-
-        ld	r1,PACAR1(r4)           /* Restore our SP */
-        ld	r4,PACASAVEDMSR(r4)     /* Restore our MSR */
-
-	mtspr	SPRN_SRR0,r3
-	mtspr	SPRN_SRR1,r4
-	RFI_TO_KERNEL
-	b	.	/* prevent speculative execution */
-_ASM_NOKPROBE_SYMBOL(__enter_rtas)
-_ASM_NOKPROBE_SYMBOL(rtas_return_loc)
-
-	.align	3
-1:	.8byte	rtas_restore_regs
-
-rtas_restore_regs:
-	/* relocation is on at this point */
-	REST_GPR(2, r1)			/* Restore the TOC */
-	REST_GPR(13, r1)		/* Restore paca */
-	REST_NVGPRS(r1)			/* Restore the non-volatiles */
-
-	GET_PACA(r13)
-
-	ld	r4,_CCR(r1)
-	mtcr	r4
-	ld	r5,_CTR(r1)
-	mtctr	r5
-	ld	r6,_XER(r1)
-	mtspr	SPRN_XER,r6
-	ld	r7,_DAR(r1)
-	mtdar	r7
-	ld	r8,_DSISR(r1)
-	mtdsisr	r8
-
-        addi	r1,r1,SWITCH_FRAME_SIZE	/* Unstack our frame */
-	ld	r0,16(r1)		/* get return address */
-
-	mtlr    r0
-        blr				/* return to caller */
-
-#endif /* CONFIG_PPC_RTAS */
-
 _GLOBAL(enter_prom)
 	mflr	r0
 	std	r0,16(r1)
diff --git a/arch/powerpc/kernel/rtas_entry.S b/arch/powerpc/kernel/rtas_entry.S
new file mode 100644
index 000000000000..9ae1ca3c6fca
--- /dev/null
+++ b/arch/powerpc/kernel/rtas_entry.S
@@ -0,0 +1,198 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#include <asm/asm-offsets.h>
+#include <asm/bug.h>
+#include <asm/page.h>
+#include <asm/ppc_asm.h>
+
+/*
+ * RTAS is called with MSR IR, DR, EE disabled, and LR in the return address.
+ *
+ * Note: r3 is an input parameter to rtas, so don't trash it...
+ */
+
+#ifdef CONFIG_PPC32
+_GLOBAL(enter_rtas)
+	stwu	r1,-INT_FRAME_SIZE(r1)
+	mflr	r0
+	stw	r0,INT_FRAME_SIZE+4(r1)
+	LOAD_REG_ADDR(r4, rtas)
+	lis	r6,1f@ha	/* physical return address for rtas */
+	addi	r6,r6,1f@l
+	tophys(r6,r6)
+	lwz	r8,RTASENTRY(r4)
+	lwz	r4,RTASBASE(r4)
+	mfmsr	r9
+	stw	r9,8(r1)
+	LOAD_REG_IMMEDIATE(r0,MSR_KERNEL)
+	mtmsr	r0	/* disable interrupts so SRR0/1 don't get trashed */
+	li	r9,MSR_KERNEL & ~(MSR_IR|MSR_DR)
+	mtlr	r6
+	stw	r1, THREAD + RTAS_SP(r2)
+	mtspr	SPRN_SRR0,r8
+	mtspr	SPRN_SRR1,r9
+	rfi
+1:
+	lis	r8, 1f@h
+	ori	r8, r8, 1f@l
+	LOAD_REG_IMMEDIATE(r9,MSR_KERNEL)
+	mtspr	SPRN_SRR0,r8
+	mtspr	SPRN_SRR1,r9
+	rfi			/* Reactivate MMU translation */
+1:
+	lwz	r8,INT_FRAME_SIZE+4(r1)	/* get return address */
+	lwz	r9,8(r1)	/* original msr value */
+	addi	r1,r1,INT_FRAME_SIZE
+	li	r0,0
+	stw	r0, THREAD + RTAS_SP(r2)
+	mtlr	r8
+	mtmsr	r9
+	blr			/* return to caller */
+_ASM_NOKPROBE_SYMBOL(enter_rtas)
+
+#else /* CONFIG_PPC32 */
+#include <asm/exception-64s.h>
+
+/*
+ * 32-bit rtas on 64-bit machines has the additional problem that RTAS may
+ * not preserve the upper parts of registers it uses.
+ */
+_GLOBAL(enter_rtas)
+	mflr	r0
+	std	r0,16(r1)
+        stdu	r1,-SWITCH_FRAME_SIZE(r1) /* Save SP and create stack space. */
+
+	/* Because RTAS is running in 32b mode, it clobbers the high order half
+	 * of all registers that it saves.  We therefore save those registers
+	 * RTAS might touch to the stack.  (r0, r3-r13 are caller saved)
+   	 */
+	SAVE_GPR(2, r1)			/* Save the TOC */
+	SAVE_GPR(13, r1)		/* Save paca */
+	SAVE_NVGPRS(r1)			/* Save the non-volatiles */
+
+	mfcr	r4
+	std	r4,_CCR(r1)
+	mfctr	r5
+	std	r5,_CTR(r1)
+	mfspr	r6,SPRN_XER
+	std	r6,_XER(r1)
+	mfdar	r7
+	std	r7,_DAR(r1)
+	mfdsisr	r8
+	std	r8,_DSISR(r1)
+
+	/* Temporary workaround to clear CR until RTAS can be modified to
+	 * ignore all bits.
+	 */
+	li	r0,0
+	mtcr	r0
+
+#ifdef CONFIG_BUG
+	/* There is no way it is acceptable to get here with interrupts enabled,
+	 * check it with the asm equivalent of WARN_ON
+	 */
+	lbz	r0,PACAIRQSOFTMASK(r13)
+1:	tdeqi	r0,IRQS_ENABLED
+	EMIT_WARN_ENTRY 1b,__FILE__,__LINE__,BUGFLAG_WARNING
+#endif
+
+	/* Hard-disable interrupts */
+	mfmsr	r6
+	rldicl	r7,r6,48,1
+	rotldi	r7,r7,16
+	mtmsrd	r7,1
+
+	/* Unfortunately, the stack pointer and the MSR are also clobbered,
+	 * so they are saved in the PACA which allows us to restore
+	 * our original state after RTAS returns.
+         */
+	std	r1,PACAR1(r13)
+        std	r6,PACASAVEDMSR(r13)
+
+	/* Setup our real return addr */	
+	LOAD_REG_ADDR(r4,rtas_return_loc)
+	clrldi	r4,r4,2			/* convert to realmode address */
+       	mtlr	r4
+
+__enter_rtas:
+	LOAD_REG_ADDR(r4, rtas)
+	ld	r5,RTASENTRY(r4)	/* get the rtas->entry value */
+	ld	r4,RTASBASE(r4)		/* get the rtas->base value */
+
+	/*
+	 * RTAS runs in 32-bit big endian real mode, but leave MSR[RI] on as we
+	 * may hit NMI (SRESET or MCE) while in RTAS. RTAS should disable RI in
+	 * its critical regions (as specified in PAPR+ section 7.2.1). MSR[S]
+	 * is not impacted by RFI_TO_KERNEL (only urfid can unset it). So if
+	 * MSR[S] is set, it will remain when entering RTAS.
+	 */
+	LOAD_REG_IMMEDIATE(r6, MSR_ME | MSR_RI)
+
+	li      r0,0
+	mtmsrd  r0,1                    /* disable RI before using SRR0/1 */
+	
+	mtspr	SPRN_SRR0,r5
+	mtspr	SPRN_SRR1,r6
+	RFI_TO_KERNEL
+	b	.	/* prevent speculative execution */
+rtas_return_loc:
+	FIXUP_ENDIAN
+
+	/*
+	 * Clear RI and set SF before anything.
+	 */
+	mfmsr   r6
+	li	r0,MSR_RI
+	andc	r6,r6,r0
+	sldi	r0,r0,(MSR_SF_LG - MSR_RI_LG)
+	or	r6,r6,r0
+	sync
+	mtmsrd  r6
+
+	/* relocation is off at this point */
+	GET_PACA(r4)
+	clrldi	r4,r4,2			/* convert to realmode address */
+
+	bcl	20,31,$+4
+0:	mflr	r3
+	ld	r3,(1f-0b)(r3)		/* get &rtas_restore_regs */
+
+        ld	r1,PACAR1(r4)           /* Restore our SP */
+        ld	r4,PACASAVEDMSR(r4)     /* Restore our MSR */
+
+	mtspr	SPRN_SRR0,r3
+	mtspr	SPRN_SRR1,r4
+	RFI_TO_KERNEL
+	b	.	/* prevent speculative execution */
+_ASM_NOKPROBE_SYMBOL(__enter_rtas)
+_ASM_NOKPROBE_SYMBOL(rtas_return_loc)
+
+	.align	3
+1:	.8byte	rtas_restore_regs
+
+rtas_restore_regs:
+	/* relocation is on at this point */
+	REST_GPR(2, r1)			/* Restore the TOC */
+	REST_GPR(13, r1)		/* Restore paca */
+	REST_NVGPRS(r1)			/* Restore the non-volatiles */
+
+	GET_PACA(r13)
+
+	ld	r4,_CCR(r1)
+	mtcr	r4
+	ld	r5,_CTR(r1)
+	mtctr	r5
+	ld	r6,_XER(r1)
+	mtspr	SPRN_XER,r6
+	ld	r7,_DAR(r1)
+	mtdar	r7
+	ld	r8,_DSISR(r1)
+	mtdsisr	r8
+
+        addi	r1,r1,SWITCH_FRAME_SIZE	/* Unstack our frame */
+	ld	r0,16(r1)		/* get return address */
+
+	mtlr    r0
+        blr				/* return to caller */
+
+#endif /* CONFIG_PPC32 */
-- 
2.35.1



