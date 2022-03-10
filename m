Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924054D490A
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242911AbiCJOOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243044AbiCJONj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:13:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD3A158783;
        Thu, 10 Mar 2022 06:11:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4C50B82670;
        Thu, 10 Mar 2022 14:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DF8C340E8;
        Thu, 10 Mar 2022 14:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921490;
        bh=AxC1teQyuVkVP30iRuUx5rWcdT5vrE/3hwpQ9jN7DcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMJeJUVQcn7AV7WYLVHASUivg3EkUmIXKF1wXnPI/+YN3YKYr1HiExpRnk2WNv+lQ
         93BTGkGyY5GfgfbpQi+nPPquR8xp5KQITCkGlFPsREFhHUnB7TVj4fnVnt08wEPxTL
         tQFvdk5m9DIaYp+JgRCF5PdxcArpTshEdw+gwFHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.16 31/53] arm64: Add percpu vectors for EL1
Date:   Thu, 10 Mar 2022 15:09:36 +0100
Message-Id: <20220310140812.729875371@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
References: <20220310140811.832630727@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/arm64/include/asm/vectors.h |   29 ++++++++++++++++++++++++++++-
 arch/arm64/kernel/cpufeature.c   |   11 +++++++++++
 arch/arm64/kernel/entry.S        |   12 ++++++------
 arch/arm64/kvm/hyp/vhe/switch.c  |    9 +++++++--
 4 files changed, 52 insertions(+), 9 deletions(-)

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
@@ -29,6 +38,24 @@ enum arm64_bp_harden_el1_vectors {
 	 * Remap the kernel before branching to the canonical vectors.
 	 */
 	EL1_VECTOR_KPTI,
-+};
+};
+
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
 
 #endif /* __ASM_VECTORS_H */
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -73,6 +73,8 @@
 #include <linux/mm.h>
 #include <linux/cpu.h>
 #include <linux/kasan.h>
+#include <linux/percpu.h>
+
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
@@ -85,6 +87,7 @@
 #include <asm/smp.h>
 #include <asm/sysreg.h>
 #include <asm/traps.h>
+#include <asm/vectors.h>
 #include <asm/virt.h>
 
 /* Kernel representation of AT_HWCAP and AT_HWCAP2 */
@@ -110,6 +113,8 @@ DECLARE_BITMAP(boot_capabilities, ARM64_
 bool arm64_use_ng_mappings = false;
 EXPORT_SYMBOL(arm64_use_ng_mappings);
 
+DEFINE_PER_CPU_READ_MOSTLY(const char *, this_cpu_vector) = vectors;
+
 /*
  * Permit PER_LINUX32 and execve() of 32-bit binaries even if not all CPUs
  * support it?
@@ -1590,6 +1595,12 @@ kpti_install_ng_mappings(const struct ar
 
 	int cpu = smp_processor_id();
 
+	if (__this_cpu_read(this_cpu_vector) == vectors) {
+		const char *v = arm64_get_bp_hardening_vector(EL1_VECTOR_KPTI);
+
+		__this_cpu_write(this_cpu_vector, v);
+	}
+
 	/*
 	 * We don't need to rewrite the page-tables if either we've done
 	 * it already or we have KASLR enabled and therefore have not
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -38,7 +38,6 @@
 	.macro kernel_ventry, el:req, ht:req, regsize:req, label:req
 	.align 7
 .Lventry_start\@:
-#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	.if	\el == 0
 	/*
 	 * This must be the first instruction of the EL0 vector entries. It is
@@ -53,7 +52,6 @@
 	.endif
 .Lskip_tramp_vectors_cleanup\@:
 	.endif
-#endif
 
 	sub	sp, sp, #PT_REGS_SIZE
 #ifdef CONFIG_VMAP_STACK
@@ -712,10 +710,10 @@ alternative_else_nop_endif
 	.endm
 
 	.macro tramp_exit, regsize = 64
-	adr	x30, tramp_vectors
-#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
-	add	x30, x30, SZ_4K
-#endif
+	tramp_data_read_var	x30, this_cpu_vector
+	get_this_cpu_offset x29
+	ldr	x30, [x30, x29]
+
 	msr	vbar_el1, x30
 	ldr	lr, [sp, #S_LR]
 	tramp_unmap_kernel	x29
@@ -775,6 +773,8 @@ __entry_tramp_data_vectors:
 __entry_tramp_data___sdei_asm_handler:
 	.quad	__sdei_asm_handler
 #endif /* CONFIG_ARM_SDE_INTERFACE */
+__entry_tramp_data_this_cpu_vector:
+	.quad	this_cpu_vector
 SYM_DATA_END(__entry_tramp_data_start)
 	.popsection				// .rodata
 #endif /* CONFIG_RANDOMIZE_BASE */
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -10,6 +10,7 @@
 #include <linux/kvm_host.h>
 #include <linux/types.h>
 #include <linux/jump_label.h>
+#include <linux/percpu.h>
 #include <uapi/linux/psci.h>
 
 #include <kvm/arm_psci.h>
@@ -25,6 +26,7 @@
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
 #include <asm/thread_info.h>
+#include <asm/vectors.h>
 
 /* VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
@@ -68,7 +70,7 @@ NOKPROBE_SYMBOL(__activate_traps);
 
 static void __deactivate_traps(struct kvm_vcpu *vcpu)
 {
-	extern char vectors[];	/* kernel exception vectors */
+	const char *host_vectors = vectors;
 
 	___deactivate_traps(vcpu);
 
@@ -82,7 +84,10 @@ static void __deactivate_traps(struct kv
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 
 	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
-	write_sysreg(vectors, vbar_el1);
+
+	if (!arm64_kernel_unmapped_at_el0())
+		host_vectors = __this_cpu_read(this_cpu_vector);
+	write_sysreg(host_vectors, vbar_el1);
 }
 NOKPROBE_SYMBOL(__deactivate_traps);
 


