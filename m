Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0424F69A1
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 21:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiDFTPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 15:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiDFTOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 15:14:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648332852A3;
        Wed,  6 Apr 2022 11:28:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 001BB61B89;
        Wed,  6 Apr 2022 18:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1D2C385A3;
        Wed,  6 Apr 2022 18:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269698;
        bh=kHSUulTABwjjKP9PIdnv1/jS51JgP6m5G62mGvO6sKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTWWdtKTWuIBxLbiiQQUL4vNY9qj/hKiz8X09Yh8ZllMyi0dHn5Nn0YOtjHWRZt6q
         ryfKtn5zC0X+9fmWwnO/0emf+qU9jIAznh7sOLPU4WBpSHqm9vkfh7+TcX87GX/sQr
         41aSzxjsBWSmZFkQOzL59y9w74kEajmk17jJ363Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 38/43] arm64: Add percpu vectors for EL1
Date:   Wed,  6 Apr 2022 20:26:47 +0200
Message-Id: <20220406182437.786062691@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: James Morse <james.morse@arm.com>

commit bd09128d16fac3c34b80bd6a29088ac632e8ce09 upstream.

The Spectre-BHB workaround adds a firmware call to the vectors. This
is needed on some CPUs, but not others. To avoid the unaffected CPU in
a big/little pair from making the firmware call, create per cpu vectors.

The per-cpu vectors only apply when returning from EL0.

Systems using KPTI can use the canonical 'full-fat' vectors directly at
EL1, the trampoline exit code will switch to this_cpu_vector on exit to
EL0. Systems not using KPTI should always use this_cpu_vector.

this_cpu_vector will point at a vector in tramp_vecs or
__bp_harden_el1_vectors, depending on whether KPTI is in use.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/mmu.h     |    2 +-
 arch/arm64/include/asm/vectors.h |   27 +++++++++++++++++++++++++++
 arch/arm64/kernel/cpufeature.c   |   11 +++++++++++
 arch/arm64/kernel/entry.S        |   16 ++++++++++------
 arch/arm64/kvm/hyp/switch.c      |    9 ++++++---
 5 files changed, 55 insertions(+), 10 deletions(-)

--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -34,7 +34,7 @@ typedef struct {
  */
 #define ASID(mm)	((mm)->context.id.counter & 0xffff)
 
-static inline bool arm64_kernel_unmapped_at_el0(void)
+static __always_inline bool arm64_kernel_unmapped_at_el0(void)
 {
 	return IS_ENABLED(CONFIG_UNMAP_KERNEL_AT_EL0) &&
 	       cpus_have_const_cap(ARM64_UNMAP_KERNEL_AT_EL0);
--- a/arch/arm64/include/asm/vectors.h
+++ b/arch/arm64/include/asm/vectors.h
@@ -5,6 +5,15 @@
 #ifndef __ASM_VECTORS_H
 #define __ASM_VECTORS_H
 
+#include <linux/bug.h>
+#include <linux/percpu.h>
+
+#include <asm/fixmap.h>
+
+extern char vectors[];
+extern char tramp_vectors[];
+extern char __bp_harden_el1_vectors[];
+
 /*
  * Note: the order of this enum corresponds to two arrays in entry.S:
  * tramp_vecs and __bp_harden_el1_vectors. By default the canonical
@@ -31,4 +40,22 @@ enum arm64_bp_harden_el1_vectors {
 	EL1_VECTOR_KPTI,
 };
 
+/* The vectors to use on return from EL0. e.g. to remap the kernel */
+DECLARE_PER_CPU_READ_MOSTLY(const char *, this_cpu_vector);
+
+#ifndef CONFIG_UNMAP_KERNEL_AT_EL0
+#define TRAMP_VALIAS	0
+#endif
+
+static inline const char *
+arm64_get_bp_hardening_vector(enum arm64_bp_harden_el1_vectors slot)
+{
+	if (arm64_kernel_unmapped_at_el0())
+		return (char *)TRAMP_VALIAS + SZ_2K * slot;
+
+	WARN_ON_ONCE(slot == EL1_VECTOR_KPTI);
+
+	return __bp_harden_el1_vectors + SZ_2K * slot;
+}
+
 #endif /* __ASM_VECTORS_H */
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -20,15 +20,18 @@
 
 #include <linux/bsearch.h>
 #include <linux/cpumask.h>
+#include <linux/percpu.h>
 #include <linux/sort.h>
 #include <linux/stop_machine.h>
 #include <linux/types.h>
+
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
 #include <asm/mmu_context.h>
 #include <asm/processor.h>
 #include <asm/sysreg.h>
+#include <asm/vectors.h>
 #include <asm/virt.h>
 
 unsigned long elf_hwcap __read_mostly;
@@ -49,6 +52,8 @@ unsigned int compat_elf_hwcap2 __read_mo
 DECLARE_BITMAP(cpu_hwcaps, ARM64_NCAPS);
 EXPORT_SYMBOL(cpu_hwcaps);
 
+DEFINE_PER_CPU_READ_MOSTLY(const char *, this_cpu_vector) = vectors;
+
 DEFINE_STATIC_KEY_ARRAY_FALSE(cpu_hwcap_keys, ARM64_NCAPS);
 EXPORT_SYMBOL(cpu_hwcap_keys);
 
@@ -821,6 +826,12 @@ kpti_install_ng_mappings(const struct ar
 	static bool kpti_applied = false;
 	int cpu = smp_processor_id();
 
+	if (__this_cpu_read(this_cpu_vector) == vectors) {
+		const char *v = arm64_get_bp_hardening_vector(EL1_VECTOR_KPTI);
+
+		__this_cpu_write(this_cpu_vector, v);
+	}
+
 	if (kpti_applied)
 		return;
 
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -75,7 +75,6 @@
 	.macro kernel_ventry, el, label, regsize = 64
 	.align 7
 .Lventry_start\@:
-#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	.if	\el == 0
 	/*
 	 * This must be the first instruction of the EL0 vector entries. It is
@@ -90,7 +89,6 @@
 	.endif
 .Lskip_tramp_vectors_cleanup\@:
 	.endif
-#endif
 
 	sub	sp, sp, #S_FRAME_SIZE
 	b	el\()\el\()_\label
@@ -983,10 +981,14 @@ __ni_sys_trace:
 	.endm
 
 	.macro tramp_exit, regsize = 64
-	adr	x30, tramp_vectors
-#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
-	add	x30, x30, SZ_4K
-#endif
+	tramp_data_read_var	x30, this_cpu_vector
+alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
+	mrs	x29, tpidr_el1
+alternative_else
+	mrs	x29, tpidr_el2
+alternative_endif
+	ldr	x30, [x30, x29]
+
 	msr	vbar_el1, x30
 	ldr	lr, [sp, #S_LR]
 	tramp_unmap_kernel	x29
@@ -1046,6 +1048,8 @@ __entry_tramp_data_vectors:
 __entry_tramp_data___sdei_asm_trampoline_next_handler:
 	.quad	__sdei_asm_handler
 #endif /* CONFIG_ARM_SDE_INTERFACE */
+__entry_tramp_data_this_cpu_vector:
+	.quad	this_cpu_vector
 	.popsection				// .rodata
 #endif /* CONFIG_RANDOMIZE_BASE */
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -26,7 +26,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/uaccess.h>
-
+#include <asm/vectors.h>
 extern struct exception_table_entry __start___kvm_ex_table;
 extern struct exception_table_entry __stop___kvm_ex_table;
 
@@ -107,11 +107,14 @@ static void __hyp_text __activate_traps(
 
 static void __hyp_text __deactivate_traps_vhe(void)
 {
-	extern char vectors[];	/* kernel exception vectors */
+	const char *host_vectors = vectors;
 
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
 	write_sysreg(CPACR_EL1_FPEN, cpacr_el1);
-	write_sysreg(vectors, vbar_el1);
+
+	if (!arm64_kernel_unmapped_at_el0())
+		host_vectors = __this_cpu_read(this_cpu_vector);
+	write_sysreg(host_vectors, vbar_el1);
 }
 
 static void __hyp_text __deactivate_traps_nvhe(void)


