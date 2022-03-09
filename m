Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1457C4D3344
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiCIQLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234712AbiCIQH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:07:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0171D145E2A;
        Wed,  9 Mar 2022 08:04:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75F41B82226;
        Wed,  9 Mar 2022 16:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD61C340E8;
        Wed,  9 Mar 2022 16:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841849;
        bh=LWaeW6uvIjJts0UD2xBhE8aZBsTlZSvzrhZpWRSiM4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCE84kw1AQATd3knUbz83AucbMxswxdQt77gSyHtShZpqc/kHDbHgxzpNhsdbsdeH
         lhhxmPbvLxBRNRa/rF5uk6ElldnDw1IIUR9h8FgVm8VJrfPepvgd9RIhhrmSAM3pV1
         izQYpNWC467oSsU8nZEeZ1GLpaoUQN8CAw3rbhIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.4 16/18] ARM: Spectre-BHB workaround
Date:   Wed,  9 Mar 2022 17:00:05 +0100
Message-Id: <20220309155857.030080654@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155856.552503355@linuxfoundation.org>
References: <20220309155856.552503355@linuxfoundation.org>
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

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

comomit b9baf5c8c5c356757f4f9d8180b5e9d234065bc3 upstream.

Workaround the Spectre BHB issues for Cortex-A15, Cortex-A57,
Cortex-A72, Cortex-A73 and Cortex-A75. We also include Brahma B15 as
well to be safe, which is affected by Spectre V2 in the same ways as
Cortex-A15.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
[changes due to lack of SYSTEM_FREEING_INITMEM - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/assembler.h |   10 ++++
 arch/arm/include/asm/spectre.h   |    4 +
 arch/arm/kernel/entry-armv.S     |   79 ++++++++++++++++++++++++++++++++++++---
 arch/arm/kernel/entry-common.S   |   24 +++++++++++
 arch/arm/kernel/spectre.c        |    4 +
 arch/arm/kernel/traps.c          |   38 ++++++++++++++++++
 arch/arm/kernel/vmlinux.lds.h    |   18 +++++++-
 arch/arm/mm/Kconfig              |   10 ++++
 arch/arm/mm/proc-v7-bugs.c       |   76 +++++++++++++++++++++++++++++++++++++
 9 files changed, 254 insertions(+), 9 deletions(-)

--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -107,6 +107,16 @@
 	.endm
 #endif
 
+#if __LINUX_ARM_ARCH__ < 7
+	.macro	dsb, args
+	mcr	p15, 0, r0, c7, c10, 4
+	.endm
+
+	.macro	isb, args
+	mcr	p15, 0, r0, c7, r5, 4
+	.endm
+#endif
+
 	.macro asm_trace_hardirqs_off, save=1
 #if defined(CONFIG_TRACE_IRQFLAGS)
 	.if \save
--- a/arch/arm/include/asm/spectre.h
+++ b/arch/arm/include/asm/spectre.h
@@ -14,6 +14,7 @@ enum {
 	__SPECTRE_V2_METHOD_ICIALLU,
 	__SPECTRE_V2_METHOD_SMC,
 	__SPECTRE_V2_METHOD_HVC,
+	__SPECTRE_V2_METHOD_LOOP8,
 };
 
 enum {
@@ -21,8 +22,11 @@ enum {
 	SPECTRE_V2_METHOD_ICIALLU = BIT(__SPECTRE_V2_METHOD_ICIALLU),
 	SPECTRE_V2_METHOD_SMC = BIT(__SPECTRE_V2_METHOD_SMC),
 	SPECTRE_V2_METHOD_HVC = BIT(__SPECTRE_V2_METHOD_HVC),
+	SPECTRE_V2_METHOD_LOOP8 = BIT(__SPECTRE_V2_METHOD_LOOP8),
 };
 
 void spectre_v2_update_state(unsigned int state, unsigned int methods);
 
+int spectre_bhb_update_vectors(unsigned int method);
+
 #endif
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -1005,12 +1005,11 @@ vector_\name:
 	sub	lr, lr, #\correction
 	.endif
 
-	@
-	@ Save r0, lr_<exception> (parent PC) and spsr_<exception>
-	@ (parent CPSR)
-	@
+	@ Save r0, lr_<exception> (parent PC)
 	stmia	sp, {r0, lr}		@ save r0, lr
-	mrs	lr, spsr
+
+	@ Save spsr_<exception> (parent CPSR)
+2:	mrs	lr, spsr
 	str	lr, [sp, #8]		@ save spsr
 
 	@
@@ -1031,6 +1030,44 @@ vector_\name:
 	movs	pc, lr			@ branch to handler in SVC mode
 ENDPROC(vector_\name)
 
+#ifdef CONFIG_HARDEN_BRANCH_HISTORY
+	.subsection 1
+	.align 5
+vector_bhb_loop8_\name:
+	.if \correction
+	sub	lr, lr, #\correction
+	.endif
+
+	@ Save r0, lr_<exception> (parent PC)
+	stmia	sp, {r0, lr}
+
+	@ bhb workaround
+	mov	r0, #8
+1:	b	. + 4
+	subs	r0, r0, #1
+	bne	1b
+	dsb
+	isb
+	b	2b
+ENDPROC(vector_bhb_loop8_\name)
+
+vector_bhb_bpiall_\name:
+	.if \correction
+	sub	lr, lr, #\correction
+	.endif
+
+	@ Save r0, lr_<exception> (parent PC)
+	stmia	sp, {r0, lr}
+
+	@ bhb workaround
+	mcr	p15, 0, r0, c7, c5, 6	@ BPIALL
+	@ isb not needed due to "movs pc, lr" in the vector stub
+	@ which gives a "context synchronisation".
+	b	2b
+ENDPROC(vector_bhb_bpiall_\name)
+	.previous
+#endif
+
 	.align	2
 	@ handler addresses follow this label
 1:
@@ -1039,6 +1076,10 @@ ENDPROC(vector_\name)
 	.section .stubs, "ax", %progbits
 	@ This must be the first word
 	.word	vector_swi
+#ifdef CONFIG_HARDEN_BRANCH_HISTORY
+	.word	vector_bhb_loop8_swi
+	.word	vector_bhb_bpiall_swi
+#endif
 
 vector_rst:
  ARM(	swi	SYS_ERROR0	)
@@ -1153,8 +1194,10 @@ vector_addrexcptn:
  * FIQ "NMI" handler
  *-----------------------------------------------------------------------------
  * Handle a FIQ using the SVC stack allowing FIQ act like NMI on x86
- * systems.
+ * systems. This must be the last vector stub, so lets place it in its own
+ * subsection.
  */
+	.subsection 2
 	vector_stub	fiq, FIQ_MODE, 4
 
 	.long	__fiq_usr			@  0  (USR_26 / USR_32)
@@ -1187,6 +1230,30 @@ vector_addrexcptn:
 	W(b)	vector_irq
 	W(b)	vector_fiq
 
+#ifdef CONFIG_HARDEN_BRANCH_HISTORY
+	.section .vectors.bhb.loop8, "ax", %progbits
+.L__vectors_bhb_loop8_start:
+	W(b)	vector_rst
+	W(b)	vector_bhb_loop8_und
+	W(ldr)	pc, .L__vectors_bhb_loop8_start + 0x1004
+	W(b)	vector_bhb_loop8_pabt
+	W(b)	vector_bhb_loop8_dabt
+	W(b)	vector_addrexcptn
+	W(b)	vector_bhb_loop8_irq
+	W(b)	vector_bhb_loop8_fiq
+
+	.section .vectors.bhb.bpiall, "ax", %progbits
+.L__vectors_bhb_bpiall_start:
+	W(b)	vector_rst
+	W(b)	vector_bhb_bpiall_und
+	W(ldr)	pc, .L__vectors_bhb_bpiall_start + 0x1008
+	W(b)	vector_bhb_bpiall_pabt
+	W(b)	vector_bhb_bpiall_dabt
+	W(b)	vector_addrexcptn
+	W(b)	vector_bhb_bpiall_irq
+	W(b)	vector_bhb_bpiall_fiq
+#endif
+
 	.data
 	.align	2
 
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -163,12 +163,36 @@ ENDPROC(ret_from_fork)
  */
 
 	.align	5
+#ifdef CONFIG_HARDEN_BRANCH_HISTORY
+ENTRY(vector_bhb_loop8_swi)
+	sub	sp, sp, #PT_REGS_SIZE
+	stmia	sp, {r0 - r12}
+	mov	r8, #8
+1:	b	2f
+2:	subs	r8, r8, #1
+	bne	1b
+	dsb
+	isb
+	b	3f
+ENDPROC(vector_bhb_loop8_swi)
+
+	.align	5
+ENTRY(vector_bhb_bpiall_swi)
+	sub	sp, sp, #PT_REGS_SIZE
+	stmia	sp, {r0 - r12}
+	mcr	p15, 0, r8, c7, c5, 6	@ BPIALL
+	isb
+	b	3f
+ENDPROC(vector_bhb_bpiall_swi)
+#endif
+	.align	5
 ENTRY(vector_swi)
 #ifdef CONFIG_CPU_V7M
 	v7m_exception_entry
 #else
 	sub	sp, sp, #PT_REGS_SIZE
 	stmia	sp, {r0 - r12}			@ Calling r0 - r12
+3:
  ARM(	add	r8, sp, #S_PC		)
  ARM(	stmdb	r8, {sp, lr}^		)	@ Calling sp, lr
  THUMB(	mov	r8, sp			)
--- a/arch/arm/kernel/spectre.c
+++ b/arch/arm/kernel/spectre.c
@@ -45,6 +45,10 @@ ssize_t cpu_show_spectre_v2(struct devic
 		method = "Firmware call";
 		break;
 
+	case SPECTRE_V2_METHOD_LOOP8:
+		method = "History overwrite";
+		break;
+
 	default:
 		method = "Multiple mitigations";
 		break;
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -30,6 +30,7 @@
 #include <linux/atomic.h>
 #include <asm/cacheflush.h>
 #include <asm/exception.h>
+#include <asm/spectre.h>
 #include <asm/unistd.h>
 #include <asm/traps.h>
 #include <asm/ptrace.h>
@@ -813,6 +814,43 @@ static void flush_vectors(void *vma, siz
 	flush_icache_range(start, end);
 }
 
+#ifdef CONFIG_HARDEN_BRANCH_HISTORY
+int spectre_bhb_update_vectors(unsigned int method)
+{
+	extern char __vectors_bhb_bpiall_start[], __vectors_bhb_bpiall_end[];
+	extern char __vectors_bhb_loop8_start[], __vectors_bhb_loop8_end[];
+	void *vec_start, *vec_end;
+
+	if (system_state > SYSTEM_SCHEDULING) {
+		pr_err("CPU%u: Spectre BHB workaround too late - system vulnerable\n",
+		       smp_processor_id());
+		return SPECTRE_VULNERABLE;
+	}
+
+	switch (method) {
+	case SPECTRE_V2_METHOD_LOOP8:
+		vec_start = __vectors_bhb_loop8_start;
+		vec_end = __vectors_bhb_loop8_end;
+		break;
+
+	case SPECTRE_V2_METHOD_BPIALL:
+		vec_start = __vectors_bhb_bpiall_start;
+		vec_end = __vectors_bhb_bpiall_end;
+		break;
+
+	default:
+		pr_err("CPU%u: unknown Spectre BHB state %d\n",
+		       smp_processor_id(), method);
+		return SPECTRE_VULNERABLE;
+	}
+
+	copy_from_lma(vectors_page, vec_start, vec_end);
+	flush_vectors(vectors_page, 0, vec_end - vec_start);
+
+	return SPECTRE_MITIGATED;
+}
+#endif
+
 void __init early_trap_init(void *vectors_base)
 {
 	extern char __stubs_start[], __stubs_end[];
--- a/arch/arm/kernel/vmlinux.lds.h
+++ b/arch/arm/kernel/vmlinux.lds.h
@@ -106,11 +106,23 @@
  */
 #define ARM_VECTORS							\
 	__vectors_lma = .;						\
-	.vectors 0xffff0000 : AT(__vectors_start) {			\
-		*(.vectors)						\
+	OVERLAY 0xffff0000 : NOCROSSREFS AT(__vectors_lma) {		\
+		.vectors {						\
+			*(.vectors)					\
+		}							\
+		.vectors.bhb.loop8 {					\
+			*(.vectors.bhb.loop8)				\
+		}							\
+		.vectors.bhb.bpiall {					\
+			*(.vectors.bhb.bpiall)				\
+		}							\
 	}								\
 	ARM_LMA(__vectors, .vectors);					\
-	. = __vectors_lma + SIZEOF(.vectors);				\
+	ARM_LMA(__vectors_bhb_loop8, .vectors.bhb.loop8);		\
+	ARM_LMA(__vectors_bhb_bpiall, .vectors.bhb.bpiall);		\
+	. = __vectors_lma + SIZEOF(.vectors) +				\
+		SIZEOF(.vectors.bhb.loop8) +				\
+		SIZEOF(.vectors.bhb.bpiall);				\
 									\
 	__stubs_lma = .;						\
 	.stubs ADDR(.vectors) + 0x1000 : AT(__stubs_lma) {		\
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -854,6 +854,16 @@ config HARDEN_BRANCH_PREDICTOR
 
 	   If unsure, say Y.
 
+config HARDEN_BRANCH_HISTORY
+	bool "Harden Spectre style attacks against branch history" if EXPERT
+	depends on CPU_SPECTRE
+	default y
+	help
+	  Speculation attacks against some high-performance processors can
+	  make use of branch history to influence future speculation. When
+	  taking an exception, a sequence of branches overwrites the branch
+	  history, or branch history is invalidated.
+
 config TLS_REG_EMUL
 	bool
 	select NEED_KUSER_HELPERS
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -190,6 +190,81 @@ static void cpu_v7_spectre_v2_init(void)
 	spectre_v2_update_state(state, method);
 }
 
+#ifdef CONFIG_HARDEN_BRANCH_HISTORY
+static int spectre_bhb_method;
+
+static const char *spectre_bhb_method_name(int method)
+{
+	switch (method) {
+	case SPECTRE_V2_METHOD_LOOP8:
+		return "loop";
+
+	case SPECTRE_V2_METHOD_BPIALL:
+		return "BPIALL";
+
+	default:
+		return "unknown";
+	}
+}
+
+static int spectre_bhb_install_workaround(int method)
+{
+	if (spectre_bhb_method != method) {
+		if (spectre_bhb_method) {
+			pr_err("CPU%u: Spectre BHB: method disagreement, system vulnerable\n",
+			       smp_processor_id());
+
+			return SPECTRE_VULNERABLE;
+		}
+
+		if (spectre_bhb_update_vectors(method) == SPECTRE_VULNERABLE)
+			return SPECTRE_VULNERABLE;
+
+		spectre_bhb_method = method;
+	}
+
+	pr_info("CPU%u: Spectre BHB: using %s workaround\n",
+		smp_processor_id(), spectre_bhb_method_name(method));
+
+	return SPECTRE_MITIGATED;
+}
+#else
+static int spectre_bhb_install_workaround(int method)
+{
+	return SPECTRE_VULNERABLE;
+}
+#endif
+
+static void cpu_v7_spectre_bhb_init(void)
+{
+	unsigned int state, method = 0;
+
+	switch (read_cpuid_part()) {
+	case ARM_CPU_PART_CORTEX_A15:
+	case ARM_CPU_PART_BRAHMA_B15:
+	case ARM_CPU_PART_CORTEX_A57:
+	case ARM_CPU_PART_CORTEX_A72:
+		state = SPECTRE_MITIGATED;
+		method = SPECTRE_V2_METHOD_LOOP8;
+		break;
+
+	case ARM_CPU_PART_CORTEX_A73:
+	case ARM_CPU_PART_CORTEX_A75:
+		state = SPECTRE_MITIGATED;
+		method = SPECTRE_V2_METHOD_BPIALL;
+		break;
+
+	default:
+		state = SPECTRE_UNAFFECTED;
+		break;
+	}
+
+	if (state == SPECTRE_MITIGATED)
+		state = spectre_bhb_install_workaround(method);
+
+	spectre_v2_update_state(state, method);
+}
+
 static __maybe_unused bool cpu_v7_check_auxcr_set(bool *warned,
 						  u32 mask, const char *msg)
 {
@@ -230,4 +305,5 @@ void cpu_v7_ca15_ibe(void)
 void cpu_v7_bugs_init(void)
 {
 	cpu_v7_spectre_v2_init();
+	cpu_v7_spectre_bhb_init();
 }


