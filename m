Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB967D730
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbfHAIUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:14 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34880 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731060AbfHAIUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:13 -0400
Received: by mail-pf1-f195.google.com with SMTP id u14so33623215pfn.2
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CrIyupKIrKrrK5tgrFteGLmJmhdaioApkHetxHZMz8k=;
        b=K2QIFbnpoc/R2ENh2TKGCsFcdFyStNxdhOUBETp/w3HK5Cr3AJzziEkhY08G5SmFvp
         9DW3KJFxLda1K2NqOTmVrhHWcVX7Ze04pTddVzCrPvT/LjMJgI9Zj+QAL1NwCGr986Hw
         Jnv8rhNqSrjdgMzPo/Y11bwWtyDynsS7bMG0MWIX2uPkaNBEF9AWwmrXuLm8EgLEoV6F
         tvL62G3MoIRCZQ76xXF8OkGAu/X8usgZEp/Wo7RoYEeTeCu8736ZEp54gUg0mPRq41vF
         wmQkV3jXo+j3dt6FdHT0Ei9Jy9jKGJ5bnMtMTsmUa0jSPuqCDiLLkPeWOKIbDFMJt1Y1
         c1Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CrIyupKIrKrrK5tgrFteGLmJmhdaioApkHetxHZMz8k=;
        b=je8vRxfc4ziME/ZEub8LWXHZhrzg8jTPTEM4Dw//xzOgA0+gzq8ID1mRAKsoAZE+OS
         6Ps1iDZnyBWWwSuox8YMtH5nh5fg+v6mCtuOinXLqVZdxaw+HKFV+h1R2MCsNNcuqbWq
         2I2rqFdTYO+3xiXDiRXVXtykNd6+QGaQtjhsV4hXtwhAKZstRJRB3XZPbpBcArU/x28g
         jR/AtRZV4cmtymeV3VitchGY7g5etpoKVse2rINxnDiQxkA76/t4OlzcJ6BV/MTHQDvM
         OeMYodJHF7cv++lmIeUU33iJ3ZR029jLy4sz/8m9oNpkJg30tcrR80J/KjCSyxQGYrxl
         jfkA==
X-Gm-Message-State: APjAAAUU/kTsY5kwyVu0k8VlEfmYi0GpgWBM0NWfel2uqiZgbfV+pkhs
        Ulqnqzx/P0NXEalkkQKAXed+fx+TNx4=
X-Google-Smtp-Source: APXvYqw+CzsQ+SZ8hDVlYOUPmmc6b3UUlcGfgnHiWnG0Ovf1Q+L+bVHRTWI6+vzkaXwtkhiU7JIhKA==
X-Received: by 2002:a63:b555:: with SMTP id u21mr119771811pgo.222.1564647612337;
        Thu, 01 Aug 2019 01:20:12 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id i14sm109861236pfk.0.2019.08.01.01.20.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:11 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 14/47] ARM: spectre-v2: harden branch predictor on context switches
Date:   Thu,  1 Aug 2019 13:45:58 +0530
Message-Id: <88ddb8ae0ac1c0575d719e609c418b7a79f49853.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
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
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mm/Kconfig          |  19 ++++++
 arch/arm/mm/proc-v7-2level.S |   6 --
 arch/arm/mm/proc-v7.S        | 125 +++++++++++++++++++++++++++--------
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
@@ -490,10 +476,75 @@ ENDPROC(__v7_setup)
 
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
@@ -600,7 +651,7 @@ ENDPROC(__v7_setup)
 __v7_ca12mp_proc_info:
 	.long	0x410fc0d0
 	.long	0xff0ffff0
-	__v7_proc __v7_ca12mp_proc_info, __v7_ca12mp_setup
+	__v7_proc __v7_ca12mp_proc_info, __v7_ca12mp_setup, proc_fns = HARDENED_BPIALL_PROCESSOR_FUNCTIONS
 	.size	__v7_ca12mp_proc_info, . - __v7_ca12mp_proc_info
 
 	/*
@@ -610,7 +661,7 @@ ENDPROC(__v7_setup)
 __v7_ca15mp_proc_info:
 	.long	0x410fc0f0
 	.long	0xff0ffff0
-	__v7_proc __v7_ca15mp_proc_info, __v7_ca15mp_setup
+	__v7_proc __v7_ca15mp_proc_info, __v7_ca15mp_setup, proc_fns = ca15_processor_functions
 	.size	__v7_ca15mp_proc_info, . - __v7_ca15mp_proc_info
 
 	/*
@@ -620,7 +671,7 @@ ENDPROC(__v7_setup)
 __v7_b15mp_proc_info:
 	.long	0x420f00f0
 	.long	0xff0ffff0
-	__v7_proc __v7_b15mp_proc_info, __v7_b15mp_setup
+	__v7_proc __v7_b15mp_proc_info, __v7_b15mp_setup, proc_fns = ca15_processor_functions
 	.size	__v7_b15mp_proc_info, . - __v7_b15mp_proc_info
 
 	/*
@@ -630,9 +681,25 @@ ENDPROC(__v7_setup)
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
2.21.0.rc0.269.g1a574e7a288b

