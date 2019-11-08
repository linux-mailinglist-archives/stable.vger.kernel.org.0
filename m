Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8533F4BD0
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfKHMgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:36:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:44364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfKHMgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:36:49 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5F7922491;
        Fri,  8 Nov 2019 12:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216607;
        bh=UC6fX6ggFPnTO9pcyhbs7o9gLzIEaI6zxjFwsNpdbyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YvKnVU5Qv8jWUY+bIXvIObeM0HXVCZG+owQ4DjCtV8NpvqMWkWs5Wc9kBO0JfooWD
         RoHVrlfbWVdBZjt3v45E7XntKTQTu0GY/Ft5YoIVHawict5DcFYeTZqTik5TL3EPm7
         8AtxZJTj+b0H0jNspA/+SAFMtMjgFH76bnckwP3E=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 22/50] ARM: spectre-v2: harden branch predictor on context switches
Date:   Fri,  8 Nov 2019 13:35:26 +0100
Message-Id: <20191108123554.29004-23-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit 06c23f5ffe7ad45b908d0fff604dae08a7e334b9 upstream.

Required manual merge of arch/arm/mm/proc-v7.S.

Harden the branch predictor against Spectre v2 attacks on context
switches for ARMv7 and later CPUs.  We do this by:

Cortex A9, A12, A17, A73, A75: invalidating the BTB.
Cortex A15, Brahma B15: invalidating the instruction cache.

Cortex A57 and Cortex A72 are not addressed in this patch.

Cortex R7 and Cortex R8 are also not addressed as we do not enforce
memory protection on these cores.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/mm/Kconfig          |  19 +++
 arch/arm/mm/proc-v7-2level.S |   6 -
 arch/arm/mm/proc-v7.S        | 125 +++++++++++++++-----
 3 files changed, 115 insertions(+), 35 deletions(-)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 7ef92e6692ab..71115afb71a0 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -797,6 +797,25 @@ config CPU_BPREDICT_DISABLE
 config CPU_SPECTRE
 	bool
 
+config HARDEN_BRANCH_PREDICTOR
+	bool "Harden the branch predictor against aliasing attacks" if EXPERT
+	depends on CPU_SPECTRE
+	default y
+	help
+	   Speculation attacks against some high-performance processors rely
+	   on being able to manipulate the branch predictor for a victim
+	   context by executing aliasing branches in the attacker context.
+	   Such attacks can be partially mitigated against by clearing
+	   internal branch predictor state and limiting the prediction
+	   logic in some situations.
+
+	   This config option will take CPU-specific actions to harden
+	   the branch predictor against aliasing attacks and may rely on
+	   specific instruction sequences or control bits being set by
+	   the system firmware.
+
+	   If unsure, say Y.
+
 config TLS_REG_EMUL
 	bool
 	select NEED_KUSER_HELPERS
diff --git a/arch/arm/mm/proc-v7-2level.S b/arch/arm/mm/proc-v7-2level.S
index c6141a5435c3..f8d45ad2a515 100644
--- a/arch/arm/mm/proc-v7-2level.S
+++ b/arch/arm/mm/proc-v7-2level.S
@@ -41,11 +41,6 @@
  *	even on Cortex-A8 revisions not affected by 430973.
  *	If IBE is not set, the flush BTAC/BTB won't do anything.
  */
-ENTRY(cpu_ca8_switch_mm)
-#ifdef CONFIG_MMU
-	mov	r2, #0
-	mcr	p15, 0, r2, c7, c5, 6		@ flush BTAC/BTB
-#endif
 ENTRY(cpu_v7_switch_mm)
 #ifdef CONFIG_MMU
 	mmid	r1, r1				@ get mm->context.id
@@ -66,7 +61,6 @@ ENTRY(cpu_v7_switch_mm)
 #endif
 	bx	lr
 ENDPROC(cpu_v7_switch_mm)
-ENDPROC(cpu_ca8_switch_mm)
 
 /*
  *	cpu_v7_set_pte_ext(ptep, pte)
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 8e1ea433c3f1..c2950317c7c2 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -87,6 +87,17 @@ ENTRY(cpu_v7_dcache_clean_area)
 	ret	lr
 ENDPROC(cpu_v7_dcache_clean_area)
 
+ENTRY(cpu_v7_iciallu_switch_mm)
+	mov	r3, #0
+	mcr	p15, 0, r3, c7, c5, 0		@ ICIALLU
+	b	cpu_v7_switch_mm
+ENDPROC(cpu_v7_iciallu_switch_mm)
+ENTRY(cpu_v7_bpiall_switch_mm)
+	mov	r3, #0
+	mcr	p15, 0, r3, c7, c5, 6		@ flush BTAC/BTB
+	b	cpu_v7_switch_mm
+ENDPROC(cpu_v7_bpiall_switch_mm)
+
 	string	cpu_v7_name, "ARMv7 Processor"
 	.align
 
@@ -152,31 +163,6 @@ ENTRY(cpu_v7_do_resume)
 ENDPROC(cpu_v7_do_resume)
 #endif
 
-/*
- * Cortex-A8
- */
-	globl_equ	cpu_ca8_proc_init,	cpu_v7_proc_init
-	globl_equ	cpu_ca8_proc_fin,	cpu_v7_proc_fin
-	globl_equ	cpu_ca8_reset,		cpu_v7_reset
-	globl_equ	cpu_ca8_do_idle,	cpu_v7_do_idle
-	globl_equ	cpu_ca8_dcache_clean_area, cpu_v7_dcache_clean_area
-	globl_equ	cpu_ca8_set_pte_ext,	cpu_v7_set_pte_ext
-	globl_equ	cpu_ca8_suspend_size,	cpu_v7_suspend_size
-#ifdef CONFIG_ARM_CPU_SUSPEND
-	globl_equ	cpu_ca8_do_suspend,	cpu_v7_do_suspend
-	globl_equ	cpu_ca8_do_resume,	cpu_v7_do_resume
-#endif
-
-/*
- * Cortex-A9 processor functions
- */
-	globl_equ	cpu_ca9mp_proc_init,	cpu_v7_proc_init
-	globl_equ	cpu_ca9mp_proc_fin,	cpu_v7_proc_fin
-	globl_equ	cpu_ca9mp_reset,	cpu_v7_reset
-	globl_equ	cpu_ca9mp_do_idle,	cpu_v7_do_idle
-	globl_equ	cpu_ca9mp_dcache_clean_area, cpu_v7_dcache_clean_area
-	globl_equ	cpu_ca9mp_switch_mm,	cpu_v7_switch_mm
-	globl_equ	cpu_ca9mp_set_pte_ext,	cpu_v7_set_pte_ext
 .globl	cpu_ca9mp_suspend_size
 .equ	cpu_ca9mp_suspend_size, cpu_v7_suspend_size + 4 * 2
 #ifdef CONFIG_ARM_CPU_SUSPEND
@@ -490,10 +476,75 @@ __v7_setup_stack:
 
 	@ define struct processor (see <asm/proc-fns.h> and proc-macros.S)
 	define_processor_functions v7, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+	@ generic v7 bpiall on context switch
+	globl_equ	cpu_v7_bpiall_proc_init,	cpu_v7_proc_init
+	globl_equ	cpu_v7_bpiall_proc_fin,		cpu_v7_proc_fin
+	globl_equ	cpu_v7_bpiall_reset,		cpu_v7_reset
+	globl_equ	cpu_v7_bpiall_do_idle,		cpu_v7_do_idle
+	globl_equ	cpu_v7_bpiall_dcache_clean_area, cpu_v7_dcache_clean_area
+	globl_equ	cpu_v7_bpiall_set_pte_ext,	cpu_v7_set_pte_ext
+	globl_equ	cpu_v7_bpiall_suspend_size,	cpu_v7_suspend_size
+#ifdef CONFIG_ARM_CPU_SUSPEND
+	globl_equ	cpu_v7_bpiall_do_suspend,	cpu_v7_do_suspend
+	globl_equ	cpu_v7_bpiall_do_resume,	cpu_v7_do_resume
+#endif
+	define_processor_functions v7_bpiall, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+
+#define HARDENED_BPIALL_PROCESSOR_FUNCTIONS v7_bpiall_processor_functions
+#else
+#define HARDENED_BPIALL_PROCESSOR_FUNCTIONS v7_processor_functions
+#endif
+
 #ifndef CONFIG_ARM_LPAE
+	@ Cortex-A8 - always needs bpiall switch_mm implementation
+	globl_equ	cpu_ca8_proc_init,	cpu_v7_proc_init
+	globl_equ	cpu_ca8_proc_fin,	cpu_v7_proc_fin
+	globl_equ	cpu_ca8_reset,		cpu_v7_reset
+	globl_equ	cpu_ca8_do_idle,	cpu_v7_do_idle
+	globl_equ	cpu_ca8_dcache_clean_area, cpu_v7_dcache_clean_area
+	globl_equ	cpu_ca8_set_pte_ext,	cpu_v7_set_pte_ext
+	globl_equ	cpu_ca8_switch_mm,	cpu_v7_bpiall_switch_mm
+	globl_equ	cpu_ca8_suspend_size,	cpu_v7_suspend_size
+#ifdef CONFIG_ARM_CPU_SUSPEND
+	globl_equ	cpu_ca8_do_suspend,	cpu_v7_do_suspend
+	globl_equ	cpu_ca8_do_resume,	cpu_v7_do_resume
+#endif
 	define_processor_functions ca8, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+
+	@ Cortex-A9 - needs more registers preserved across suspend/resume
+	@ and bpiall switch_mm for hardening
+	globl_equ	cpu_ca9mp_proc_init,	cpu_v7_proc_init
+	globl_equ	cpu_ca9mp_proc_fin,	cpu_v7_proc_fin
+	globl_equ	cpu_ca9mp_reset,	cpu_v7_reset
+	globl_equ	cpu_ca9mp_do_idle,	cpu_v7_do_idle
+	globl_equ	cpu_ca9mp_dcache_clean_area, cpu_v7_dcache_clean_area
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+	globl_equ	cpu_ca9mp_switch_mm,	cpu_v7_bpiall_switch_mm
+#else
+	globl_equ	cpu_ca9mp_switch_mm,	cpu_v7_switch_mm
+#endif
+	globl_equ	cpu_ca9mp_set_pte_ext,	cpu_v7_set_pte_ext
 	define_processor_functions ca9mp, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
 #endif
+
+	@ Cortex-A15 - needs iciallu switch_mm for hardening
+	globl_equ	cpu_ca15_proc_init,	cpu_v7_proc_init
+	globl_equ	cpu_ca15_proc_fin,	cpu_v7_proc_fin
+	globl_equ	cpu_ca15_reset,		cpu_v7_reset
+	globl_equ	cpu_ca15_do_idle,	cpu_v7_do_idle
+	globl_equ	cpu_ca15_dcache_clean_area, cpu_v7_dcache_clean_area
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+	globl_equ	cpu_ca15_switch_mm,	cpu_v7_iciallu_switch_mm
+#else
+	globl_equ	cpu_ca15_switch_mm,	cpu_v7_switch_mm
+#endif
+	globl_equ	cpu_ca15_set_pte_ext,	cpu_v7_set_pte_ext
+	globl_equ	cpu_ca15_suspend_size,	cpu_v7_suspend_size
+	globl_equ	cpu_ca15_do_suspend,	cpu_v7_do_suspend
+	globl_equ	cpu_ca15_do_resume,	cpu_v7_do_resume
+	define_processor_functions ca15, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
 #ifdef CONFIG_CPU_PJ4B
 	define_processor_functions pj4b, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
 #endif
@@ -600,7 +651,7 @@ __v7_ca7mp_proc_info:
 __v7_ca12mp_proc_info:
 	.long	0x410fc0d0
 	.long	0xff0ffff0
-	__v7_proc __v7_ca12mp_proc_info, __v7_ca12mp_setup
+	__v7_proc __v7_ca12mp_proc_info, __v7_ca12mp_setup, proc_fns = HARDENED_BPIALL_PROCESSOR_FUNCTIONS
 	.size	__v7_ca12mp_proc_info, . - __v7_ca12mp_proc_info
 
 	/*
@@ -610,7 +661,7 @@ __v7_ca12mp_proc_info:
 __v7_ca15mp_proc_info:
 	.long	0x410fc0f0
 	.long	0xff0ffff0
-	__v7_proc __v7_ca15mp_proc_info, __v7_ca15mp_setup
+	__v7_proc __v7_ca15mp_proc_info, __v7_ca15mp_setup, proc_fns = ca15_processor_functions
 	.size	__v7_ca15mp_proc_info, . - __v7_ca15mp_proc_info
 
 	/*
@@ -620,7 +671,7 @@ __v7_ca15mp_proc_info:
 __v7_b15mp_proc_info:
 	.long	0x420f00f0
 	.long	0xff0ffff0
-	__v7_proc __v7_b15mp_proc_info, __v7_b15mp_setup
+	__v7_proc __v7_b15mp_proc_info, __v7_b15mp_setup, proc_fns = ca15_processor_functions
 	.size	__v7_b15mp_proc_info, . - __v7_b15mp_proc_info
 
 	/*
@@ -630,9 +681,25 @@ __v7_b15mp_proc_info:
 __v7_ca17mp_proc_info:
 	.long	0x410fc0e0
 	.long	0xff0ffff0
-	__v7_proc __v7_ca17mp_proc_info, __v7_ca17mp_setup
+	__v7_proc __v7_ca17mp_proc_info, __v7_ca17mp_setup, proc_fns = HARDENED_BPIALL_PROCESSOR_FUNCTIONS
 	.size	__v7_ca17mp_proc_info, . - __v7_ca17mp_proc_info
 
+	/* ARM Ltd. Cortex A73 processor */
+	.type	__v7_ca73_proc_info, #object
+__v7_ca73_proc_info:
+	.long	0x410fd090
+	.long	0xff0ffff0
+	__v7_proc __v7_ca73_proc_info, __v7_setup, proc_fns = HARDENED_BPIALL_PROCESSOR_FUNCTIONS
+	.size	__v7_ca73_proc_info, . - __v7_ca73_proc_info
+
+	/* ARM Ltd. Cortex A75 processor */
+	.type	__v7_ca75_proc_info, #object
+__v7_ca75_proc_info:
+	.long	0x410fd0a0
+	.long	0xff0ffff0
+	__v7_proc __v7_ca75_proc_info, __v7_setup, proc_fns = HARDENED_BPIALL_PROCESSOR_FUNCTIONS
+	.size	__v7_ca75_proc_info, . - __v7_ca75_proc_info
+
 	/*
 	 * Qualcomm Inc. Krait processors.
 	 */
-- 
2.20.1

