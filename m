Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297A94D6111
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 12:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbiCKL5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 06:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348386AbiCKL5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 06:57:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC74B1C2D91;
        Fri, 11 Mar 2022 03:56:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AF7B61D26;
        Fri, 11 Mar 2022 11:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5903CC340EC;
        Fri, 11 Mar 2022 11:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646999762;
        bh=LOgGhHTv4L7MzDN1fjfHElVmuOtydftMEsu8hSb/Oc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuds3I0OIBGFNm2BcFumCcvJFI8Clg08f+58bZ0uVzwKtLyzCdMtpxAln6S00MWb0
         a0tiTo/c8eWFseleNboV66J2j1KNHTPzsNBwsrpNGFCdLPGZ+nZQMd8FgGGMm8qG+y
         dMRdzKlJtKRO2YbyIwDdT+lWTkXl9s6fzhcxiYe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.16.14
Date:   Fri, 11 Mar 2022 12:55:50 +0100
Message-Id: <164699974912497@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <164699974918063@kroah.com>
References: <164699974918063@kroah.com>
MIME-Version: 1.0
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

diff --git a/Documentation/admin-guide/hw-vuln/spectre.rst b/Documentation/admin-guide/hw-vuln/spectre.rst
index a2b22d5640ec..9e9556826450 100644
--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -60,8 +60,8 @@ privileged data touched during the speculative execution.
 Spectre variant 1 attacks take advantage of speculative execution of
 conditional branches, while Spectre variant 2 attacks use speculative
 execution of indirect branches to leak privileged memory.
-See :ref:`[1] <spec_ref1>` :ref:`[5] <spec_ref5>` :ref:`[7] <spec_ref7>`
-:ref:`[10] <spec_ref10>` :ref:`[11] <spec_ref11>`.
+See :ref:`[1] <spec_ref1>` :ref:`[5] <spec_ref5>` :ref:`[6] <spec_ref6>`
+:ref:`[7] <spec_ref7>` :ref:`[10] <spec_ref10>` :ref:`[11] <spec_ref11>`.
 
 Spectre variant 1 (Bounds Check Bypass)
 ---------------------------------------
@@ -131,6 +131,19 @@ steer its indirect branch speculations to gadget code, and measure the
 speculative execution's side effects left in level 1 cache to infer the
 victim's data.
 
+Yet another variant 2 attack vector is for the attacker to poison the
+Branch History Buffer (BHB) to speculatively steer an indirect branch
+to a specific Branch Target Buffer (BTB) entry, even if the entry isn't
+associated with the source address of the indirect branch. Specifically,
+the BHB might be shared across privilege levels even in the presence of
+Enhanced IBRS.
+
+Currently the only known real-world BHB attack vector is via
+unprivileged eBPF. Therefore, it's highly recommended to not enable
+unprivileged eBPF, especially when eIBRS is used (without retpolines).
+For a full mitigation against BHB attacks, it's recommended to use
+retpolines (or eIBRS combined with retpolines).
+
 Attack scenarios
 ----------------
 
@@ -364,13 +377,15 @@ The possible values in this file are:
 
   - Kernel status:
 
-  ====================================  =================================
-  'Not affected'                        The processor is not vulnerable
-  'Vulnerable'                          Vulnerable, no mitigation
-  'Mitigation: Full generic retpoline'  Software-focused mitigation
-  'Mitigation: Full AMD retpoline'      AMD-specific software mitigation
-  'Mitigation: Enhanced IBRS'           Hardware-focused mitigation
-  ====================================  =================================
+  ========================================  =================================
+  'Not affected'                            The processor is not vulnerable
+  'Mitigation: None'                        Vulnerable, no mitigation
+  'Mitigation: Retpolines'                  Use Retpoline thunks
+  'Mitigation: LFENCE'                      Use LFENCE instructions
+  'Mitigation: Enhanced IBRS'               Hardware-focused mitigation
+  'Mitigation: Enhanced IBRS + Retpolines'  Hardware-focused + Retpolines
+  'Mitigation: Enhanced IBRS + LFENCE'      Hardware-focused + LFENCE
+  ========================================  =================================
 
   - Firmware status: Show if Indirect Branch Restricted Speculation (IBRS) is
     used to protect against Spectre variant 2 attacks when calling firmware (x86 only).
@@ -583,12 +598,13 @@ kernel command line.
 
 		Specific mitigations can also be selected manually:
 
-		retpoline
-					replace indirect branches
-		retpoline,generic
-					google's original retpoline
-		retpoline,amd
-					AMD-specific minimal thunk
+                retpoline               auto pick between generic,lfence
+                retpoline,generic       Retpolines
+                retpoline,lfence        LFENCE; indirect branch
+                retpoline,amd           alias for retpoline,lfence
+                eibrs                   enhanced IBRS
+                eibrs,retpoline         enhanced IBRS + Retpolines
+                eibrs,lfence            enhanced IBRS + LFENCE
 
 		Not specifying this option is equivalent to
 		spectre_v2=auto.
@@ -599,7 +615,7 @@ kernel command line.
 		spectre_v2=off. Spectre variant 1 mitigations
 		cannot be disabled.
 
-For spectre_v2_user see :doc:`/admin-guide/kernel-parameters`.
+For spectre_v2_user see Documentation/admin-guide/kernel-parameters.txt
 
 Mitigation selection guide
 --------------------------
@@ -681,7 +697,7 @@ AMD white papers:
 
 .. _spec_ref6:
 
-[6] `Software techniques for managing speculation on AMD processors <https://developer.amd.com/wp-content/resources/90343-B_SoftwareTechniquesforManagingSpeculation_WP_7-18Update_FNL.pdf>`_.
+[6] `Software techniques for managing speculation on AMD processors <https://developer.amd.com/wp-content/resources/Managing-Speculation-on-AMD-Processors.pdf>`_.
 
 ARM white papers:
 
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 2fba82431efb..391b3f9055fe 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5303,8 +5303,12 @@
 			Specific mitigations can also be selected manually:
 
 			retpoline	  - replace indirect branches
-			retpoline,generic - google's original retpoline
-			retpoline,amd     - AMD-specific minimal thunk
+			retpoline,generic - Retpolines
+			retpoline,lfence  - LFENCE; indirect branch
+			retpoline,amd     - alias for retpoline,lfence
+			eibrs		  - enhanced IBRS
+			eibrs,retpoline   - enhanced IBRS + Retpolines
+			eibrs,lfence      - enhanced IBRS + LFENCE
 
 			Not specifying this option is equivalent to
 			spectre_v2=auto.
diff --git a/Documentation/arm64/cpu-feature-registers.rst b/Documentation/arm64/cpu-feature-registers.rst
index 9f9b8fd06089..749ae970c319 100644
--- a/Documentation/arm64/cpu-feature-registers.rst
+++ b/Documentation/arm64/cpu-feature-registers.rst
@@ -275,6 +275,23 @@ infrastructure:
      | SVEVer                       | [3-0]   |    y    |
      +------------------------------+---------+---------+
 
+  8) ID_AA64MMFR1_EL1 - Memory model feature register 1
+
+     +------------------------------+---------+---------+
+     | Name                         |  bits   | visible |
+     +------------------------------+---------+---------+
+     | AFP                          | [47-44] |    y    |
+     +------------------------------+---------+---------+
+
+  9) ID_AA64ISAR2_EL1 - Instruction set attribute register 2
+
+     +------------------------------+---------+---------+
+     | Name                         |  bits   | visible |
+     +------------------------------+---------+---------+
+     | RPRES                        | [7-4]   |    y    |
+     +------------------------------+---------+---------+
+
+
 Appendix I: Example
 -------------------
 
diff --git a/Documentation/arm64/elf_hwcaps.rst b/Documentation/arm64/elf_hwcaps.rst
index af106af8e1c0..b72ff17d600a 100644
--- a/Documentation/arm64/elf_hwcaps.rst
+++ b/Documentation/arm64/elf_hwcaps.rst
@@ -251,6 +251,14 @@ HWCAP2_ECV
 
     Functionality implied by ID_AA64MMFR0_EL1.ECV == 0b0001.
 
+HWCAP2_AFP
+
+    Functionality implied by ID_AA64MFR1_EL1.AFP == 0b0001.
+
+HWCAP2_RPRES
+
+    Functionality implied by ID_AA64ISAR2_EL1.RPRES == 0b0001.
+
 4. Unused AT_HWCAP bits
 -----------------------
 
diff --git a/Makefile b/Makefile
index 6702e44821eb..86835419075f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 16
-SUBLEVEL = 13
+SUBLEVEL = 14
 EXTRAVERSION =
 NAME = Gobble Gobble
 
diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 6fe67963ba5a..aee73ef5b3dc 100644
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
+	mcr	p15, 0, r0, c7, c5, 4
+	.endm
+#endif
+
 	.macro asm_trace_hardirqs_off, save=1
 #if defined(CONFIG_TRACE_IRQFLAGS)
 	.if \save
diff --git a/arch/arm/include/asm/spectre.h b/arch/arm/include/asm/spectre.h
new file mode 100644
index 000000000000..d1fa5607d3aa
--- /dev/null
+++ b/arch/arm/include/asm/spectre.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __ASM_SPECTRE_H
+#define __ASM_SPECTRE_H
+
+enum {
+	SPECTRE_UNAFFECTED,
+	SPECTRE_MITIGATED,
+	SPECTRE_VULNERABLE,
+};
+
+enum {
+	__SPECTRE_V2_METHOD_BPIALL,
+	__SPECTRE_V2_METHOD_ICIALLU,
+	__SPECTRE_V2_METHOD_SMC,
+	__SPECTRE_V2_METHOD_HVC,
+	__SPECTRE_V2_METHOD_LOOP8,
+};
+
+enum {
+	SPECTRE_V2_METHOD_BPIALL = BIT(__SPECTRE_V2_METHOD_BPIALL),
+	SPECTRE_V2_METHOD_ICIALLU = BIT(__SPECTRE_V2_METHOD_ICIALLU),
+	SPECTRE_V2_METHOD_SMC = BIT(__SPECTRE_V2_METHOD_SMC),
+	SPECTRE_V2_METHOD_HVC = BIT(__SPECTRE_V2_METHOD_HVC),
+	SPECTRE_V2_METHOD_LOOP8 = BIT(__SPECTRE_V2_METHOD_LOOP8),
+};
+
+void spectre_v2_update_state(unsigned int state, unsigned int methods);
+
+int spectre_bhb_update_vectors(unsigned int method);
+
+#endif
diff --git a/arch/arm/include/asm/vmlinux.lds.h b/arch/arm/include/asm/vmlinux.lds.h
index 4a91428c324d..fad45c884e98 100644
--- a/arch/arm/include/asm/vmlinux.lds.h
+++ b/arch/arm/include/asm/vmlinux.lds.h
@@ -26,6 +26,19 @@
 #define ARM_MMU_DISCARD(x)	x
 #endif
 
+/*
+ * ld.lld does not support NOCROSSREFS:
+ * https://github.com/ClangBuiltLinux/linux/issues/1609
+ */
+#ifdef CONFIG_LD_IS_LLD
+#define NOCROSSREFS
+#endif
+
+/* Set start/end symbol names to the LMA for the section */
+#define ARM_LMA(sym, section)						\
+	sym##_start = LOADADDR(section);				\
+	sym##_end = LOADADDR(section) + SIZEOF(section)
+
 #define PROC_INFO							\
 		. = ALIGN(4);						\
 		__proc_info_begin = .;					\
@@ -110,19 +123,31 @@
  * only thing that matters is their relative offsets
  */
 #define ARM_VECTORS							\
-	__vectors_start = .;						\
-	.vectors 0xffff0000 : AT(__vectors_start) {			\
-		*(.vectors)						\
+	__vectors_lma = .;						\
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
-	. = __vectors_start + SIZEOF(.vectors);				\
-	__vectors_end = .;						\
+	ARM_LMA(__vectors, .vectors);					\
+	ARM_LMA(__vectors_bhb_loop8, .vectors.bhb.loop8);		\
+	ARM_LMA(__vectors_bhb_bpiall, .vectors.bhb.bpiall);		\
+	. = __vectors_lma + SIZEOF(.vectors) +				\
+		SIZEOF(.vectors.bhb.loop8) +				\
+		SIZEOF(.vectors.bhb.bpiall);				\
 									\
-	__stubs_start = .;						\
-	.stubs ADDR(.vectors) + 0x1000 : AT(__stubs_start) {		\
+	__stubs_lma = .;						\
+	.stubs ADDR(.vectors) + 0x1000 : AT(__stubs_lma) {		\
 		*(.stubs)						\
 	}								\
-	. = __stubs_start + SIZEOF(.stubs);				\
-	__stubs_end = .;						\
+	ARM_LMA(__stubs, .stubs);					\
+	. = __stubs_lma + SIZEOF(.stubs);				\
 									\
 	PROVIDE(vector_fiq_offset = vector_fiq - ADDR(.vectors));
 
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index ae295a3bcfef..6ef3b535b7bf 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -106,4 +106,6 @@ endif
 
 obj-$(CONFIG_HAVE_ARM_SMCCC)	+= smccc-call.o
 
+obj-$(CONFIG_GENERIC_CPU_VULNERABILITIES) += spectre.o
+
 extra-y := $(head-y) vmlinux.lds
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 5cd057859fe9..676703cbfe4b 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -1002,12 +1002,11 @@ vector_\name:
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
@@ -1028,6 +1027,44 @@ vector_\name:
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
@@ -1036,6 +1073,10 @@ ENDPROC(vector_\name)
 	.section .stubs, "ax", %progbits
 	@ This must be the first word
 	.word	vector_swi
+#ifdef CONFIG_HARDEN_BRANCH_HISTORY
+	.word	vector_bhb_loop8_swi
+	.word	vector_bhb_bpiall_swi
+#endif
 
 vector_rst:
  ARM(	swi	SYS_ERROR0	)
@@ -1150,8 +1191,10 @@ vector_addrexcptn:
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
@@ -1184,6 +1227,30 @@ vector_addrexcptn:
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
 
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index ac86c34682bb..dbc1913ee30b 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -153,6 +153,29 @@ ENDPROC(ret_from_fork)
  *-----------------------------------------------------------------------------
  */
 
+	.align	5
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
 	.align	5
 ENTRY(vector_swi)
 #ifdef CONFIG_CPU_V7M
@@ -160,6 +183,7 @@ ENTRY(vector_swi)
 #else
 	sub	sp, sp, #PT_REGS_SIZE
 	stmia	sp, {r0 - r12}			@ Calling r0 - r12
+3:
  ARM(	add	r8, sp, #S_PC		)
  ARM(	stmdb	r8, {sp, lr}^		)	@ Calling sp, lr
  THUMB(	mov	r8, sp			)
diff --git a/arch/arm/kernel/spectre.c b/arch/arm/kernel/spectre.c
new file mode 100644
index 000000000000..0dcefc36fb7a
--- /dev/null
+++ b/arch/arm/kernel/spectre.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/bpf.h>
+#include <linux/cpu.h>
+#include <linux/device.h>
+
+#include <asm/spectre.h>
+
+static bool _unprivileged_ebpf_enabled(void)
+{
+#ifdef CONFIG_BPF_SYSCALL
+	return !sysctl_unprivileged_bpf_disabled;
+#else
+	return false;
+#endif
+}
+
+ssize_t cpu_show_spectre_v1(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	return sprintf(buf, "Mitigation: __user pointer sanitization\n");
+}
+
+static unsigned int spectre_v2_state;
+static unsigned int spectre_v2_methods;
+
+void spectre_v2_update_state(unsigned int state, unsigned int method)
+{
+	if (state > spectre_v2_state)
+		spectre_v2_state = state;
+	spectre_v2_methods |= method;
+}
+
+ssize_t cpu_show_spectre_v2(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	const char *method;
+
+	if (spectre_v2_state == SPECTRE_UNAFFECTED)
+		return sprintf(buf, "%s\n", "Not affected");
+
+	if (spectre_v2_state != SPECTRE_MITIGATED)
+		return sprintf(buf, "%s\n", "Vulnerable");
+
+	if (_unprivileged_ebpf_enabled())
+		return sprintf(buf, "Vulnerable: Unprivileged eBPF enabled\n");
+
+	switch (spectre_v2_methods) {
+	case SPECTRE_V2_METHOD_BPIALL:
+		method = "Branch predictor hardening";
+		break;
+
+	case SPECTRE_V2_METHOD_ICIALLU:
+		method = "I-cache invalidation";
+		break;
+
+	case SPECTRE_V2_METHOD_SMC:
+	case SPECTRE_V2_METHOD_HVC:
+		method = "Firmware call";
+		break;
+
+	case SPECTRE_V2_METHOD_LOOP8:
+		method = "History overwrite";
+		break;
+
+	default:
+		method = "Multiple mitigations";
+		break;
+	}
+
+	return sprintf(buf, "Mitigation: %s\n", method);
+}
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 195dff58bafc..90c887aa67a4 100644
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
@@ -787,10 +788,59 @@ static inline void __init kuser_init(void *vectors)
 }
 #endif
 
+#ifndef CONFIG_CPU_V7M
+static void copy_from_lma(void *vma, void *lma_start, void *lma_end)
+{
+	memcpy(vma, lma_start, lma_end - lma_start);
+}
+
+static void flush_vectors(void *vma, size_t offset, size_t size)
+{
+	unsigned long start = (unsigned long)vma + offset;
+	unsigned long end = start + size;
+
+	flush_icache_range(start, end);
+}
+
+#ifdef CONFIG_HARDEN_BRANCH_HISTORY
+int spectre_bhb_update_vectors(unsigned int method)
+{
+	extern char __vectors_bhb_bpiall_start[], __vectors_bhb_bpiall_end[];
+	extern char __vectors_bhb_loop8_start[], __vectors_bhb_loop8_end[];
+	void *vec_start, *vec_end;
+
+	if (system_state >= SYSTEM_FREEING_INITMEM) {
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
-#ifndef CONFIG_CPU_V7M
-	unsigned long vectors = (unsigned long)vectors_base;
 	extern char __stubs_start[], __stubs_end[];
 	extern char __vectors_start[], __vectors_end[];
 	unsigned i;
@@ -811,17 +861,20 @@ void __init early_trap_init(void *vectors_base)
 	 * into the vector page, mapped at 0xffff0000, and ensure these
 	 * are visible to the instruction stream.
 	 */
-	memcpy((void *)vectors, __vectors_start, __vectors_end - __vectors_start);
-	memcpy((void *)vectors + 0x1000, __stubs_start, __stubs_end - __stubs_start);
+	copy_from_lma(vectors_base, __vectors_start, __vectors_end);
+	copy_from_lma(vectors_base + 0x1000, __stubs_start, __stubs_end);
 
 	kuser_init(vectors_base);
 
-	flush_icache_range(vectors, vectors + PAGE_SIZE * 2);
+	flush_vectors(vectors_base, 0, PAGE_SIZE * 2);
+}
 #else /* ifndef CONFIG_CPU_V7M */
+void __init early_trap_init(void *vectors_base)
+{
 	/*
 	 * on V7-M there is no need to copy the vector table to a dedicated
 	 * memory area. The address is configurable and so a table in the kernel
 	 * image can be used.
 	 */
-#endif
 }
+#endif
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 58afba346729..9724c16e9076 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -830,6 +830,7 @@ config CPU_BPREDICT_DISABLE
 
 config CPU_SPECTRE
 	bool
+	select GENERIC_CPU_VULNERABILITIES
 
 config HARDEN_BRANCH_PREDICTOR
 	bool "Harden the branch predictor against aliasing attacks" if EXPERT
@@ -850,6 +851,16 @@ config HARDEN_BRANCH_PREDICTOR
 
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
diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index 114c05ab4dd9..06dbfb968182 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -6,8 +6,35 @@
 #include <asm/cp15.h>
 #include <asm/cputype.h>
 #include <asm/proc-fns.h>
+#include <asm/spectre.h>
 #include <asm/system_misc.h>
 
+#ifdef CONFIG_ARM_PSCI
+static int __maybe_unused spectre_v2_get_cpu_fw_mitigation_state(void)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+			     ARM_SMCCC_ARCH_WORKAROUND_1, &res);
+
+	switch ((int)res.a0) {
+	case SMCCC_RET_SUCCESS:
+		return SPECTRE_MITIGATED;
+
+	case SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED:
+		return SPECTRE_UNAFFECTED;
+
+	default:
+		return SPECTRE_VULNERABLE;
+	}
+}
+#else
+static int __maybe_unused spectre_v2_get_cpu_fw_mitigation_state(void)
+{
+	return SPECTRE_VULNERABLE;
+}
+#endif
+
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 DEFINE_PER_CPU(harden_branch_predictor_fn_t, harden_branch_predictor_fn);
 
@@ -36,13 +63,61 @@ static void __maybe_unused call_hvc_arch_workaround_1(void)
 	arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
 }
 
-static void cpu_v7_spectre_init(void)
+static unsigned int spectre_v2_install_workaround(unsigned int method)
 {
 	const char *spectre_v2_method = NULL;
 	int cpu = smp_processor_id();
 
 	if (per_cpu(harden_branch_predictor_fn, cpu))
-		return;
+		return SPECTRE_MITIGATED;
+
+	switch (method) {
+	case SPECTRE_V2_METHOD_BPIALL:
+		per_cpu(harden_branch_predictor_fn, cpu) =
+			harden_branch_predictor_bpiall;
+		spectre_v2_method = "BPIALL";
+		break;
+
+	case SPECTRE_V2_METHOD_ICIALLU:
+		per_cpu(harden_branch_predictor_fn, cpu) =
+			harden_branch_predictor_iciallu;
+		spectre_v2_method = "ICIALLU";
+		break;
+
+	case SPECTRE_V2_METHOD_HVC:
+		per_cpu(harden_branch_predictor_fn, cpu) =
+			call_hvc_arch_workaround_1;
+		cpu_do_switch_mm = cpu_v7_hvc_switch_mm;
+		spectre_v2_method = "hypervisor";
+		break;
+
+	case SPECTRE_V2_METHOD_SMC:
+		per_cpu(harden_branch_predictor_fn, cpu) =
+			call_smc_arch_workaround_1;
+		cpu_do_switch_mm = cpu_v7_smc_switch_mm;
+		spectre_v2_method = "firmware";
+		break;
+	}
+
+	if (spectre_v2_method)
+		pr_info("CPU%u: Spectre v2: using %s workaround\n",
+			smp_processor_id(), spectre_v2_method);
+
+	return SPECTRE_MITIGATED;
+}
+#else
+static unsigned int spectre_v2_install_workaround(unsigned int method)
+{
+	pr_info("CPU%u: Spectre V2: workarounds disabled by configuration\n",
+		smp_processor_id());
+
+	return SPECTRE_VULNERABLE;
+}
+#endif
+
+static void cpu_v7_spectre_v2_init(void)
+{
+	unsigned int state, method = 0;
 
 	switch (read_cpuid_part()) {
 	case ARM_CPU_PART_CORTEX_A8:
@@ -51,69 +126,133 @@ static void cpu_v7_spectre_init(void)
 	case ARM_CPU_PART_CORTEX_A17:
 	case ARM_CPU_PART_CORTEX_A73:
 	case ARM_CPU_PART_CORTEX_A75:
-		per_cpu(harden_branch_predictor_fn, cpu) =
-			harden_branch_predictor_bpiall;
-		spectre_v2_method = "BPIALL";
+		state = SPECTRE_MITIGATED;
+		method = SPECTRE_V2_METHOD_BPIALL;
 		break;
 
 	case ARM_CPU_PART_CORTEX_A15:
 	case ARM_CPU_PART_BRAHMA_B15:
-		per_cpu(harden_branch_predictor_fn, cpu) =
-			harden_branch_predictor_iciallu;
-		spectre_v2_method = "ICIALLU";
+		state = SPECTRE_MITIGATED;
+		method = SPECTRE_V2_METHOD_ICIALLU;
 		break;
 
-#ifdef CONFIG_ARM_PSCI
 	case ARM_CPU_PART_BRAHMA_B53:
 		/* Requires no workaround */
+		state = SPECTRE_UNAFFECTED;
 		break;
+
 	default:
 		/* Other ARM CPUs require no workaround */
-		if (read_cpuid_implementor() == ARM_CPU_IMP_ARM)
+		if (read_cpuid_implementor() == ARM_CPU_IMP_ARM) {
+			state = SPECTRE_UNAFFECTED;
 			break;
+		}
+
 		fallthrough;
-		/* Cortex A57/A72 require firmware workaround */
-	case ARM_CPU_PART_CORTEX_A57:
-	case ARM_CPU_PART_CORTEX_A72: {
-		struct arm_smccc_res res;
 
-		arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
-				     ARM_SMCCC_ARCH_WORKAROUND_1, &res);
-		if ((int)res.a0 != 0)
-			return;
+	/* Cortex A57/A72 require firmware workaround */
+	case ARM_CPU_PART_CORTEX_A57:
+	case ARM_CPU_PART_CORTEX_A72:
+		state = spectre_v2_get_cpu_fw_mitigation_state();
+		if (state != SPECTRE_MITIGATED)
+			break;
 
 		switch (arm_smccc_1_1_get_conduit()) {
 		case SMCCC_CONDUIT_HVC:
-			per_cpu(harden_branch_predictor_fn, cpu) =
-				call_hvc_arch_workaround_1;
-			cpu_do_switch_mm = cpu_v7_hvc_switch_mm;
-			spectre_v2_method = "hypervisor";
+			method = SPECTRE_V2_METHOD_HVC;
 			break;
 
 		case SMCCC_CONDUIT_SMC:
-			per_cpu(harden_branch_predictor_fn, cpu) =
-				call_smc_arch_workaround_1;
-			cpu_do_switch_mm = cpu_v7_smc_switch_mm;
-			spectre_v2_method = "firmware";
+			method = SPECTRE_V2_METHOD_SMC;
 			break;
 
 		default:
+			state = SPECTRE_VULNERABLE;
 			break;
 		}
 	}
-#endif
+
+	if (state == SPECTRE_MITIGATED)
+		state = spectre_v2_install_workaround(method);
+
+	spectre_v2_update_state(state, method);
+}
+
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
 	}
+}
 
-	if (spectre_v2_method)
-		pr_info("CPU%u: Spectre v2: using %s workaround\n",
-			smp_processor_id(), spectre_v2_method);
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
 }
 #else
-static void cpu_v7_spectre_init(void)
+static int spectre_bhb_install_workaround(int method)
 {
+	return SPECTRE_VULNERABLE;
 }
 #endif
 
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
@@ -142,16 +281,17 @@ static bool check_spectre_auxcr(bool *warned, u32 bit)
 void cpu_v7_ca8_ibe(void)
 {
 	if (check_spectre_auxcr(this_cpu_ptr(&spectre_warned), BIT(6)))
-		cpu_v7_spectre_init();
+		cpu_v7_spectre_v2_init();
 }
 
 void cpu_v7_ca15_ibe(void)
 {
 	if (check_spectre_auxcr(this_cpu_ptr(&spectre_warned), BIT(0)))
-		cpu_v7_spectre_init();
+		cpu_v7_spectre_v2_init();
 }
 
 void cpu_v7_bugs_init(void)
 {
-	cpu_v7_spectre_init();
+	cpu_v7_spectre_v2_init();
+	cpu_v7_spectre_bhb_init();
 }
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 651bf217465e..0e2c31f7a9aa 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1395,6 +1395,15 @@ config UNMAP_KERNEL_AT_EL0
 
 	  If unsure, say Y.
 
+config MITIGATE_SPECTRE_BRANCH_HISTORY
+	bool "Mitigate Spectre style attacks against branch history" if EXPERT
+	default y
+	help
+	  Speculation attacks against some high-performance processors can
+	  make use of branch history to influence future speculation.
+	  When taking an exception from user-space, a sequence of branches
+	  or a firmware call overwrites the branch history.
+
 config RODATA_FULL_DEFAULT_ENABLED
 	bool "Apply r/o permissions of VM areas also to their linear aliases"
 	default y
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 136d13f3d6e9..5373a0772439 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -108,6 +108,13 @@
 	hint	#20
 	.endm
 
+/*
+ * Clear Branch History instruction
+ */
+	.macro clearbhb
+	hint	#22
+	.endm
+
 /*
  * Speculation barrier
  */
@@ -840,4 +847,50 @@ alternative_endif
 
 #endif /* GNU_PROPERTY_AARCH64_FEATURE_1_DEFAULT */
 
+	.macro __mitigate_spectre_bhb_loop      tmp
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+alternative_cb  spectre_bhb_patch_loop_iter
+	mov	\tmp, #32		// Patched to correct the immediate
+alternative_cb_end
+.Lspectre_bhb_loop\@:
+	b	. + 4
+	subs	\tmp, \tmp, #1
+	b.ne	.Lspectre_bhb_loop\@
+	sb
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+	.endm
+
+	.macro mitigate_spectre_bhb_loop	tmp
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+alternative_cb	spectre_bhb_patch_loop_mitigation_enable
+	b	.L_spectre_bhb_loop_done\@	// Patched to NOP
+alternative_cb_end
+	__mitigate_spectre_bhb_loop	\tmp
+.L_spectre_bhb_loop_done\@:
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+	.endm
+
+	/* Save/restores x0-x3 to the stack */
+	.macro __mitigate_spectre_bhb_fw
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	stp	x0, x1, [sp, #-16]!
+	stp	x2, x3, [sp, #-16]!
+	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_3
+alternative_cb	smccc_patch_fw_mitigation_conduit
+	nop					// Patched to SMC/HVC #0
+alternative_cb_end
+	ldp	x2, x3, [sp], #16
+	ldp	x0, x1, [sp], #16
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+	.endm
+
+	.macro mitigate_spectre_bhb_clear_insn
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+alternative_cb	spectre_bhb_patch_clearbhb
+	/* Patched to NOP when not supported */
+	clearbhb
+	isb
+alternative_cb_end
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+	.endm
 #endif	/* __ASM_ASSEMBLER_H */
diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
index 0f6d16faa540..a58e366f0b07 100644
--- a/arch/arm64/include/asm/cpu.h
+++ b/arch/arm64/include/asm/cpu.h
@@ -51,6 +51,7 @@ struct cpuinfo_arm64 {
 	u64		reg_id_aa64dfr1;
 	u64		reg_id_aa64isar0;
 	u64		reg_id_aa64isar1;
+	u64		reg_id_aa64isar2;
 	u64		reg_id_aa64mmfr0;
 	u64		reg_id_aa64mmfr1;
 	u64		reg_id_aa64mmfr2;
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index ef6be92b1921..a77b5f49b3a6 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -637,6 +637,35 @@ static inline bool cpu_supports_mixed_endian_el0(void)
 	return id_aa64mmfr0_mixed_endian_el0(read_cpuid(ID_AA64MMFR0_EL1));
 }
 
+
+static inline bool supports_csv2p3(int scope)
+{
+	u64 pfr0;
+	u8 csv2_val;
+
+	if (scope == SCOPE_LOCAL_CPU)
+		pfr0 = read_sysreg_s(SYS_ID_AA64PFR0_EL1);
+	else
+		pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+
+	csv2_val = cpuid_feature_extract_unsigned_field(pfr0,
+							ID_AA64PFR0_CSV2_SHIFT);
+	return csv2_val == 3;
+}
+
+static inline bool supports_clearbhb(int scope)
+{
+	u64 isar2;
+
+	if (scope == SCOPE_LOCAL_CPU)
+		isar2 = read_sysreg_s(SYS_ID_AA64ISAR2_EL1);
+	else
+		isar2 = read_sanitised_ftr_reg(SYS_ID_AA64ISAR2_EL1);
+
+	return cpuid_feature_extract_unsigned_field(isar2,
+						    ID_AA64ISAR2_CLEARBHB_SHIFT);
+}
+
 const struct cpumask *system_32bit_el0_cpumask(void);
 DECLARE_STATIC_KEY_FALSE(arm64_mismatched_32bit_el0);
 
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 999b9149f856..bfbf0c4c7c5e 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -73,10 +73,14 @@
 #define ARM_CPU_PART_CORTEX_A76		0xD0B
 #define ARM_CPU_PART_NEOVERSE_N1	0xD0C
 #define ARM_CPU_PART_CORTEX_A77		0xD0D
+#define ARM_CPU_PART_NEOVERSE_V1	0xD40
+#define ARM_CPU_PART_CORTEX_A78		0xD41
+#define ARM_CPU_PART_CORTEX_X1		0xD44
 #define ARM_CPU_PART_CORTEX_A510	0xD46
 #define ARM_CPU_PART_CORTEX_A710	0xD47
 #define ARM_CPU_PART_CORTEX_X2		0xD48
 #define ARM_CPU_PART_NEOVERSE_N2	0xD49
+#define ARM_CPU_PART_CORTEX_A78C	0xD4B
 
 #define APM_CPU_PART_POTENZA		0x000
 
@@ -117,10 +121,14 @@
 #define MIDR_CORTEX_A76	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A76)
 #define MIDR_NEOVERSE_N1 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N1)
 #define MIDR_CORTEX_A77	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A77)
+#define MIDR_NEOVERSE_V1	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V1)
+#define MIDR_CORTEX_A78	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78)
+#define MIDR_CORTEX_X1	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X1)
 #define MIDR_CORTEX_A510 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A510)
 #define MIDR_CORTEX_A710 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A710)
 #define MIDR_CORTEX_X2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X2)
 #define MIDR_NEOVERSE_N2 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N2)
+#define MIDR_CORTEX_A78C	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78C)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 4335800201c9..daff882883f9 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -62,9 +62,11 @@ enum fixed_addresses {
 #endif /* CONFIG_ACPI_APEI_GHES */
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+	FIX_ENTRY_TRAMP_TEXT3,
+	FIX_ENTRY_TRAMP_TEXT2,
+	FIX_ENTRY_TRAMP_TEXT1,
 	FIX_ENTRY_TRAMP_DATA,
-	FIX_ENTRY_TRAMP_TEXT,
-#define TRAMP_VALIAS		(__fix_to_virt(FIX_ENTRY_TRAMP_TEXT))
+#define TRAMP_VALIAS		(__fix_to_virt(FIX_ENTRY_TRAMP_TEXT1))
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
 	__end_of_permanent_fixed_addresses,
 
diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index b100e0055eab..f68fbb207473 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -106,6 +106,8 @@
 #define KERNEL_HWCAP_BTI		__khwcap2_feature(BTI)
 #define KERNEL_HWCAP_MTE		__khwcap2_feature(MTE)
 #define KERNEL_HWCAP_ECV		__khwcap2_feature(ECV)
+#define KERNEL_HWCAP_AFP		__khwcap2_feature(AFP)
+#define KERNEL_HWCAP_RPRES		__khwcap2_feature(RPRES)
 
 /*
  * This yields a mask that user programs can use to figure out what
diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 6b776c8667b2..b02f0c328c8e 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -65,6 +65,7 @@ enum aarch64_insn_hint_cr_op {
 	AARCH64_INSN_HINT_PSB  = 0x11 << 5,
 	AARCH64_INSN_HINT_TSB  = 0x12 << 5,
 	AARCH64_INSN_HINT_CSDB = 0x14 << 5,
+	AARCH64_INSN_HINT_CLEARBHB = 0x16 << 5,
 
 	AARCH64_INSN_HINT_BTI   = 0x20 << 5,
 	AARCH64_INSN_HINT_BTIC  = 0x22 << 5,
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2a5f7f38006f..d016f27af6da 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -712,6 +712,11 @@ static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
 	ctxt_sys_reg(cpu_ctxt, MPIDR_EL1) = read_cpuid_mpidr();
 }
 
+static inline bool kvm_system_needs_idmapped_vectors(void)
+{
+	return cpus_have_const_cap(ARM64_SPECTRE_V3A);
+}
+
 void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
 
 static inline void kvm_arch_hardware_unsetup(void) {}
diff --git a/arch/arm64/include/asm/rwonce.h b/arch/arm64/include/asm/rwonce.h
index 1bce62fa908a..56f7b1d4d54b 100644
--- a/arch/arm64/include/asm/rwonce.h
+++ b/arch/arm64/include/asm/rwonce.h
@@ -5,7 +5,7 @@
 #ifndef __ASM_RWONCE_H
 #define __ASM_RWONCE_H
 
-#ifdef CONFIG_LTO
+#if defined(CONFIG_LTO) && !defined(__ASSEMBLY__)
 
 #include <linux/compiler_types.h>
 #include <asm/alternative-macros.h>
@@ -66,7 +66,7 @@
 })
 
 #endif	/* !BUILD_VDSO */
-#endif	/* CONFIG_LTO */
+#endif	/* CONFIG_LTO && !__ASSEMBLY__ */
 
 #include <asm-generic/rwonce.h>
 
diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 152cb35bf9df..40971ac1303f 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -23,4 +23,9 @@ extern char __mmuoff_data_start[], __mmuoff_data_end[];
 extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
 extern char __relocate_new_kernel_start[], __relocate_new_kernel_end[];
 
+static inline size_t entry_tramp_text_size(void)
+{
+	return __entry_tramp_text_end - __entry_tramp_text_start;
+}
+
 #endif /* __ASM_SECTIONS_H */
diff --git a/arch/arm64/include/asm/spectre.h b/arch/arm64/include/asm/spectre.h
index f62ca39da6c5..86e0cc9b9c68 100644
--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -93,5 +93,9 @@ void spectre_v4_enable_task_mitigation(struct task_struct *tsk);
 
 enum mitigation_state arm64_get_meltdown_state(void);
 
+enum mitigation_state arm64_get_spectre_bhb_state(void);
+bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry, int scope);
+u8 spectre_bhb_loop_affected(int scope);
+void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 #endif	/* __ASSEMBLY__ */
 #endif	/* __ASM_SPECTRE_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 16b3f1a1d468..2d9e7f5214f5 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -182,6 +182,7 @@
 
 #define SYS_ID_AA64ISAR0_EL1		sys_reg(3, 0, 0, 6, 0)
 #define SYS_ID_AA64ISAR1_EL1		sys_reg(3, 0, 0, 6, 1)
+#define SYS_ID_AA64ISAR2_EL1		sys_reg(3, 0, 0, 6, 2)
 
 #define SYS_ID_AA64MMFR0_EL1		sys_reg(3, 0, 0, 7, 0)
 #define SYS_ID_AA64MMFR1_EL1		sys_reg(3, 0, 0, 7, 1)
@@ -771,6 +772,21 @@
 #define ID_AA64ISAR1_GPI_NI			0x0
 #define ID_AA64ISAR1_GPI_IMP_DEF		0x1
 
+/* id_aa64isar2 */
+#define ID_AA64ISAR2_CLEARBHB_SHIFT	28
+#define ID_AA64ISAR2_RPRES_SHIFT	4
+#define ID_AA64ISAR2_WFXT_SHIFT		0
+
+#define ID_AA64ISAR2_RPRES_8BIT		0x0
+#define ID_AA64ISAR2_RPRES_12BIT	0x1
+/*
+ * Value 0x1 has been removed from the architecture, and is
+ * reserved, but has not yet been removed from the ARM ARM
+ * as of ARM DDI 0487G.b.
+ */
+#define ID_AA64ISAR2_WFXT_NI		0x0
+#define ID_AA64ISAR2_WFXT_SUPPORTED	0x2
+
 /* id_aa64pfr0 */
 #define ID_AA64PFR0_CSV3_SHIFT		60
 #define ID_AA64PFR0_CSV2_SHIFT		56
@@ -889,6 +905,8 @@
 #endif
 
 /* id_aa64mmfr1 */
+#define ID_AA64MMFR1_ECBHB_SHIFT	60
+#define ID_AA64MMFR1_AFP_SHIFT		44
 #define ID_AA64MMFR1_ETS_SHIFT		36
 #define ID_AA64MMFR1_TWED_SHIFT		32
 #define ID_AA64MMFR1_XNX_SHIFT		28
diff --git a/arch/arm64/include/asm/vectors.h b/arch/arm64/include/asm/vectors.h
new file mode 100644
index 000000000000..f64613a96d53
--- /dev/null
+++ b/arch/arm64/include/asm/vectors.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2022 ARM Ltd.
+ */
+#ifndef __ASM_VECTORS_H
+#define __ASM_VECTORS_H
+
+#include <linux/bug.h>
+#include <linux/percpu.h>
+
+#include <asm/fixmap.h>
+
+extern char vectors[];
+extern char tramp_vectors[];
+extern char __bp_harden_el1_vectors[];
+
+/*
+ * Note: the order of this enum corresponds to two arrays in entry.S:
+ * tramp_vecs and __bp_harden_el1_vectors. By default the canonical
+ * 'full fat' vectors are used directly.
+ */
+enum arm64_bp_harden_el1_vectors {
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	/*
+	 * Perform the BHB loop mitigation, before branching to the canonical
+	 * vectors.
+	 */
+	EL1_VECTOR_BHB_LOOP,
+
+	/*
+	 * Make the SMC call for firmware mitigation, before branching to the
+	 * canonical vectors.
+	 */
+	EL1_VECTOR_BHB_FW,
+
+	/*
+	 * Use the ClearBHB instruction, before branching to the canonical
+	 * vectors.
+	 */
+	EL1_VECTOR_BHB_CLEAR_INSN,
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+
+	/*
+	 * Remap the kernel before branching to the canonical vectors.
+	 */
+	EL1_VECTOR_KPTI,
+};
+
+#ifndef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+#define EL1_VECTOR_BHB_LOOP		-1
+#define EL1_VECTOR_BHB_FW		-1
+#define EL1_VECTOR_BHB_CLEAR_INSN	-1
+#endif /* !CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
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
+
+#endif /* __ASM_VECTORS_H */
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index 7b23b16f21ce..f03731847d9d 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -76,5 +76,7 @@
 #define HWCAP2_BTI		(1 << 17)
 #define HWCAP2_MTE		(1 << 18)
 #define HWCAP2_ECV		(1 << 19)
+#define HWCAP2_AFP		(1 << 20)
+#define HWCAP2_RPRES		(1 << 21)
 
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index b3edde68bc3e..323e251ed37b 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -281,6 +281,11 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED	3
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED     	(1U << 4)
 
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3	KVM_REG_ARM_FW_REG(3)
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL		0
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_AVAIL		1
+#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_REQUIRED	2
+
 /* SVE registers */
 #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index b217941713a8..a401180e8d66 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -502,6 +502,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.matches = has_spectre_v4,
 		.cpu_enable = spectre_v4_enable_mitigation,
 	},
+	{
+		.desc = "Spectre-BHB",
+		.capability = ARM64_SPECTRE_BHB,
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		.matches = is_spectre_bhb_affected,
+		.cpu_enable = spectre_bhb_enable_mitigation,
+	},
 #ifdef CONFIG_ARM64_ERRATUM_1418040
 	{
 		.desc = "ARM erratum 1418040",
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index d18b953c078d..d33687673f6b 100644
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
@@ -110,6 +113,8 @@ DECLARE_BITMAP(boot_capabilities, ARM64_NPATCHABLE);
 bool arm64_use_ng_mappings = false;
 EXPORT_SYMBOL(arm64_use_ng_mappings);
 
+DEFINE_PER_CPU_READ_MOSTLY(const char *, this_cpu_vector) = vectors;
+
 /*
  * Permit PER_LINUX32 and execve() of 32-bit binaries even if not all CPUs
  * support it?
@@ -225,6 +230,12 @@ static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_HIGHER_SAFE, ID_AA64ISAR2_CLEARBHB_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_RPRES_SHIFT, 4, 0),
+	ARM64_FTR_END,
+};
+
 static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_CSV3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_CSV2_SHIFT, 4, 0),
@@ -325,6 +336,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr1[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_AFP_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_ETS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_TWED_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_XNX_SHIFT, 4, 0),
@@ -637,6 +649,7 @@ static const struct __ftr_reg_entry {
 	ARM64_FTR_REG(SYS_ID_AA64ISAR0_EL1, ftr_id_aa64isar0),
 	ARM64_FTR_REG_OVERRIDE(SYS_ID_AA64ISAR1_EL1, ftr_id_aa64isar1,
 			       &id_aa64isar1_override),
+	ARM64_FTR_REG(SYS_ID_AA64ISAR2_EL1, ftr_id_aa64isar2),
 
 	/* Op1 = 0, CRn = 0, CRm = 7 */
 	ARM64_FTR_REG(SYS_ID_AA64MMFR0_EL1, ftr_id_aa64mmfr0),
@@ -933,6 +946,7 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 	init_cpu_ftr_reg(SYS_ID_AA64DFR1_EL1, info->reg_id_aa64dfr1);
 	init_cpu_ftr_reg(SYS_ID_AA64ISAR0_EL1, info->reg_id_aa64isar0);
 	init_cpu_ftr_reg(SYS_ID_AA64ISAR1_EL1, info->reg_id_aa64isar1);
+	init_cpu_ftr_reg(SYS_ID_AA64ISAR2_EL1, info->reg_id_aa64isar2);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR0_EL1, info->reg_id_aa64mmfr0);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR1_EL1, info->reg_id_aa64mmfr1);
 	init_cpu_ftr_reg(SYS_ID_AA64MMFR2_EL1, info->reg_id_aa64mmfr2);
@@ -1151,6 +1165,8 @@ void update_cpu_features(int cpu,
 				      info->reg_id_aa64isar0, boot->reg_id_aa64isar0);
 	taint |= check_update_ftr_reg(SYS_ID_AA64ISAR1_EL1, cpu,
 				      info->reg_id_aa64isar1, boot->reg_id_aa64isar1);
+	taint |= check_update_ftr_reg(SYS_ID_AA64ISAR2_EL1, cpu,
+				      info->reg_id_aa64isar2, boot->reg_id_aa64isar2);
 
 	/*
 	 * Differing PARange support is fine as long as all peripherals and
@@ -1272,6 +1288,7 @@ u64 __read_sysreg_by_encoding(u32 sys_id)
 	read_sysreg_case(SYS_ID_AA64MMFR2_EL1);
 	read_sysreg_case(SYS_ID_AA64ISAR0_EL1);
 	read_sysreg_case(SYS_ID_AA64ISAR1_EL1);
+	read_sysreg_case(SYS_ID_AA64ISAR2_EL1);
 
 	read_sysreg_case(SYS_CNTFRQ_EL0);
 	read_sysreg_case(SYS_CTR_EL0);
@@ -1579,6 +1596,12 @@ kpti_install_ng_mappings(const struct arm64_cpu_capabilities *__unused)
 
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
@@ -2479,6 +2502,8 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 	HWCAP_CAP(SYS_ID_AA64PFR1_EL1, ID_AA64PFR1_MTE_SHIFT, FTR_UNSIGNED, ID_AA64PFR1_MTE, CAP_HWCAP, KERNEL_HWCAP_MTE),
 #endif /* CONFIG_ARM64_MTE */
 	HWCAP_CAP(SYS_ID_AA64MMFR0_EL1, ID_AA64MMFR0_ECV_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_ECV),
+	HWCAP_CAP(SYS_ID_AA64MMFR1_EL1, ID_AA64MMFR1_AFP_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_AFP),
+	HWCAP_CAP(SYS_ID_AA64ISAR2_EL1, ID_AA64ISAR2_RPRES_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_RPRES),
 	{},
 };
 
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 6e27b759056a..591c18a889a5 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -95,6 +95,8 @@ static const char *const hwcap_str[] = {
 	[KERNEL_HWCAP_BTI]		= "bti",
 	[KERNEL_HWCAP_MTE]		= "mte",
 	[KERNEL_HWCAP_ECV]		= "ecv",
+	[KERNEL_HWCAP_AFP]		= "afp",
+	[KERNEL_HWCAP_RPRES]		= "rpres",
 };
 
 #ifdef CONFIG_COMPAT
@@ -391,6 +393,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 	info->reg_id_aa64dfr1 = read_cpuid(ID_AA64DFR1_EL1);
 	info->reg_id_aa64isar0 = read_cpuid(ID_AA64ISAR0_EL1);
 	info->reg_id_aa64isar1 = read_cpuid(ID_AA64ISAR1_EL1);
+	info->reg_id_aa64isar2 = read_cpuid(ID_AA64ISAR2_EL1);
 	info->reg_id_aa64mmfr0 = read_cpuid(ID_AA64MMFR0_EL1);
 	info->reg_id_aa64mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
 	info->reg_id_aa64mmfr2 = read_cpuid(ID_AA64MMFR2_EL1);
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 2f69ae43941d..41f9c0f07269 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -37,18 +37,21 @@
 
 	.macro kernel_ventry, el:req, ht:req, regsize:req, label:req
 	.align 7
-#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+.Lventry_start\@:
 	.if	\el == 0
-alternative_if ARM64_UNMAP_KERNEL_AT_EL0
+	/*
+	 * This must be the first instruction of the EL0 vector entries. It is
+	 * skipped by the trampoline vectors, to trigger the cleanup.
+	 */
+	b	.Lskip_tramp_vectors_cleanup\@
 	.if	\regsize == 64
 	mrs	x30, tpidrro_el0
 	msr	tpidrro_el0, xzr
 	.else
 	mov	x30, xzr
 	.endif
-alternative_else_nop_endif
+.Lskip_tramp_vectors_cleanup\@:
 	.endif
-#endif
 
 	sub	sp, sp, #PT_REGS_SIZE
 #ifdef CONFIG_VMAP_STACK
@@ -95,11 +98,15 @@ alternative_else_nop_endif
 	mrs	x0, tpidrro_el0
 #endif
 	b	el\el\ht\()_\regsize\()_\label
+.org .Lventry_start\@ + 128	// Did we overflow the ventry slot?
 	.endm
 
-	.macro tramp_alias, dst, sym
+	.macro tramp_alias, dst, sym, tmp
 	mov_q	\dst, TRAMP_VALIAS
-	add	\dst, \dst, #(\sym - .entry.tramp.text)
+	adr_l	\tmp, \sym
+	add	\dst, \dst, \tmp
+	adr_l	\tmp, .entry.tramp.text
+	sub	\dst, \dst, \tmp
 	.endm
 
 	/*
@@ -116,7 +123,7 @@ alternative_cb_end
 	tbnz	\tmp2, #TIF_SSBD, .L__asm_ssbd_skip\@
 	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_2
 	mov	w1, #\state
-alternative_cb	spectre_v4_patch_fw_mitigation_conduit
+alternative_cb	smccc_patch_fw_mitigation_conduit
 	nop					// Patched to SMC/HVC #0
 alternative_cb_end
 .L__asm_ssbd_skip\@:
@@ -413,21 +420,26 @@ alternative_else_nop_endif
 	ldp	x24, x25, [sp, #16 * 12]
 	ldp	x26, x27, [sp, #16 * 13]
 	ldp	x28, x29, [sp, #16 * 14]
-	ldr	lr, [sp, #S_LR]
-	add	sp, sp, #PT_REGS_SIZE		// restore sp
 
 	.if	\el == 0
-alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
+alternative_if_not ARM64_UNMAP_KERNEL_AT_EL0
+	ldr	lr, [sp, #S_LR]
+	add	sp, sp, #PT_REGS_SIZE		// restore sp
+	eret
+alternative_else_nop_endif
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	bne	4f
-	msr	far_el1, x30
-	tramp_alias	x30, tramp_exit_native
+	msr	far_el1, x29
+	tramp_alias	x30, tramp_exit_native, x29
 	br	x30
 4:
-	tramp_alias	x30, tramp_exit_compat
+	tramp_alias	x30, tramp_exit_compat, x29
 	br	x30
 #endif
 	.else
+	ldr	lr, [sp, #S_LR]
+	add	sp, sp, #PT_REGS_SIZE		// restore sp
+
 	/* Ensure any device/NC reads complete */
 	alternative_insn nop, "dmb sy", ARM64_WORKAROUND_1508412
 
@@ -594,12 +606,6 @@ SYM_CODE_END(ret_to_user)
 
 	.popsection				// .entry.text
 
-#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-/*
- * Exception vectors trampoline.
- */
-	.pushsection ".entry.tramp.text", "ax"
-
 	// Move from tramp_pg_dir to swapper_pg_dir
 	.macro tramp_map_kernel, tmp
 	mrs	\tmp, ttbr1_el1
@@ -633,12 +639,47 @@ alternative_else_nop_endif
 	 */
 	.endm
 
-	.macro tramp_ventry, regsize = 64
+	.macro tramp_data_page	dst
+	adr_l	\dst, .entry.tramp.text
+	sub	\dst, \dst, PAGE_SIZE
+	.endm
+
+	.macro tramp_data_read_var	dst, var
+#ifdef CONFIG_RANDOMIZE_BASE
+	tramp_data_page		\dst
+	add	\dst, \dst, #:lo12:__entry_tramp_data_\var
+	ldr	\dst, [\dst]
+#else
+	ldr	\dst, =\var
+#endif
+	.endm
+
+#define BHB_MITIGATION_NONE	0
+#define BHB_MITIGATION_LOOP	1
+#define BHB_MITIGATION_FW	2
+#define BHB_MITIGATION_INSN	3
+
+	.macro tramp_ventry, vector_start, regsize, kpti, bhb
 	.align	7
 1:
 	.if	\regsize == 64
 	msr	tpidrro_el0, x30	// Restored in kernel_ventry
 	.endif
+
+	.if	\bhb == BHB_MITIGATION_LOOP
+	/*
+	 * This sequence must appear before the first indirect branch. i.e. the
+	 * ret out of tramp_ventry. It appears here because x30 is free.
+	 */
+	__mitigate_spectre_bhb_loop	x30
+	.endif // \bhb == BHB_MITIGATION_LOOP
+
+	.if	\bhb == BHB_MITIGATION_INSN
+	clearbhb
+	isb
+	.endif // \bhb == BHB_MITIGATION_INSN
+
+	.if	\kpti == 1
 	/*
 	 * Defend against branch aliasing attacks by pushing a dummy
 	 * entry onto the return stack and using a RET instruction to
@@ -648,46 +689,75 @@ alternative_else_nop_endif
 	b	.
 2:
 	tramp_map_kernel	x30
-#ifdef CONFIG_RANDOMIZE_BASE
-	adr	x30, tramp_vectors + PAGE_SIZE
 alternative_insn isb, nop, ARM64_WORKAROUND_QCOM_FALKOR_E1003
-	ldr	x30, [x30]
-#else
-	ldr	x30, =vectors
-#endif
+	tramp_data_read_var	x30, vectors
 alternative_if_not ARM64_WORKAROUND_CAVIUM_TX2_219_PRFM
-	prfm	plil1strm, [x30, #(1b - tramp_vectors)]
+	prfm	plil1strm, [x30, #(1b - \vector_start)]
 alternative_else_nop_endif
+
 	msr	vbar_el1, x30
-	add	x30, x30, #(1b - tramp_vectors)
 	isb
+	.else
+	ldr	x30, =vectors
+	.endif // \kpti == 1
+
+	.if	\bhb == BHB_MITIGATION_FW
+	/*
+	 * The firmware sequence must appear before the first indirect branch.
+	 * i.e. the ret out of tramp_ventry. But it also needs the stack to be
+	 * mapped to save/restore the registers the SMC clobbers.
+	 */
+	__mitigate_spectre_bhb_fw
+	.endif // \bhb == BHB_MITIGATION_FW
+
+	add	x30, x30, #(1b - \vector_start + 4)
 	ret
+.org 1b + 128	// Did we overflow the ventry slot?
 	.endm
 
 	.macro tramp_exit, regsize = 64
-	adr	x30, tramp_vectors
+	tramp_data_read_var	x30, this_cpu_vector
+	get_this_cpu_offset x29
+	ldr	x30, [x30, x29]
+
 	msr	vbar_el1, x30
-	tramp_unmap_kernel	x30
+	ldr	lr, [sp, #S_LR]
+	tramp_unmap_kernel	x29
 	.if	\regsize == 64
-	mrs	x30, far_el1
+	mrs	x29, far_el1
 	.endif
+	add	sp, sp, #PT_REGS_SIZE		// restore sp
 	eret
 	sb
 	.endm
 
-	.align	11
-SYM_CODE_START_NOALIGN(tramp_vectors)
+	.macro	generate_tramp_vector,	kpti, bhb
+.Lvector_start\@:
 	.space	0x400
 
-	tramp_ventry
-	tramp_ventry
-	tramp_ventry
-	tramp_ventry
+	.rept	4
+	tramp_ventry	.Lvector_start\@, 64, \kpti, \bhb
+	.endr
+	.rept	4
+	tramp_ventry	.Lvector_start\@, 32, \kpti, \bhb
+	.endr
+	.endm
 
-	tramp_ventry	32
-	tramp_ventry	32
-	tramp_ventry	32
-	tramp_ventry	32
+#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+/*
+ * Exception vectors trampoline.
+ * The order must match __bp_harden_el1_vectors and the
+ * arm64_bp_harden_el1_vectors enum.
+ */
+	.pushsection ".entry.tramp.text", "ax"
+	.align	11
+SYM_CODE_START_NOALIGN(tramp_vectors)
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_LOOP
+	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_FW
+	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_INSN
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+	generate_tramp_vector	kpti=1, bhb=BHB_MITIGATION_NONE
 SYM_CODE_END(tramp_vectors)
 
 SYM_CODE_START(tramp_exit_native)
@@ -704,12 +774,56 @@ SYM_CODE_END(tramp_exit_compat)
 	.pushsection ".rodata", "a"
 	.align PAGE_SHIFT
 SYM_DATA_START(__entry_tramp_data_start)
+__entry_tramp_data_vectors:
 	.quad	vectors
+#ifdef CONFIG_ARM_SDE_INTERFACE
+__entry_tramp_data___sdei_asm_handler:
+	.quad	__sdei_asm_handler
+#endif /* CONFIG_ARM_SDE_INTERFACE */
+__entry_tramp_data_this_cpu_vector:
+	.quad	this_cpu_vector
 SYM_DATA_END(__entry_tramp_data_start)
 	.popsection				// .rodata
 #endif /* CONFIG_RANDOMIZE_BASE */
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
 
+/*
+ * Exception vectors for spectre mitigations on entry from EL1 when
+ * kpti is not in use.
+ */
+	.macro generate_el1_vector, bhb
+.Lvector_start\@:
+	kernel_ventry	1, t, 64, sync		// Synchronous EL1t
+	kernel_ventry	1, t, 64, irq		// IRQ EL1t
+	kernel_ventry	1, t, 64, fiq		// FIQ EL1h
+	kernel_ventry	1, t, 64, error		// Error EL1t
+
+	kernel_ventry	1, h, 64, sync		// Synchronous EL1h
+	kernel_ventry	1, h, 64, irq		// IRQ EL1h
+	kernel_ventry	1, h, 64, fiq		// FIQ EL1h
+	kernel_ventry	1, h, 64, error		// Error EL1h
+
+	.rept	4
+	tramp_ventry	.Lvector_start\@, 64, 0, \bhb
+	.endr
+	.rept 4
+	tramp_ventry	.Lvector_start\@, 32, 0, \bhb
+	.endr
+	.endm
+
+/* The order must match tramp_vecs and the arm64_bp_harden_el1_vectors enum. */
+	.pushsection ".entry.text", "ax"
+	.align	11
+SYM_CODE_START(__bp_harden_el1_vectors)
+#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
+	generate_el1_vector	bhb=BHB_MITIGATION_LOOP
+	generate_el1_vector	bhb=BHB_MITIGATION_FW
+	generate_el1_vector	bhb=BHB_MITIGATION_INSN
+#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
+SYM_CODE_END(__bp_harden_el1_vectors)
+	.popsection
+
+
 /*
  * Register switch for AArch64. The callee-saved registers need to be saved
  * and restored. On entry:
@@ -835,14 +949,7 @@ SYM_CODE_START(__sdei_asm_entry_trampoline)
 	 * Remember whether to unmap the kernel on exit.
 	 */
 1:	str	x4, [x1, #(SDEI_EVENT_INTREGS + S_SDEI_TTBR1)]
-
-#ifdef CONFIG_RANDOMIZE_BASE
-	adr	x4, tramp_vectors + PAGE_SIZE
-	add	x4, x4, #:lo12:__sdei_asm_trampoline_next_handler
-	ldr	x4, [x4]
-#else
-	ldr	x4, =__sdei_asm_handler
-#endif
+	tramp_data_read_var     x4, __sdei_asm_handler
 	br	x4
 SYM_CODE_END(__sdei_asm_entry_trampoline)
 NOKPROBE(__sdei_asm_entry_trampoline)
@@ -865,13 +972,6 @@ SYM_CODE_END(__sdei_asm_exit_trampoline)
 NOKPROBE(__sdei_asm_exit_trampoline)
 	.ltorg
 .popsection		// .entry.tramp.text
-#ifdef CONFIG_RANDOMIZE_BASE
-.pushsection ".rodata", "a"
-SYM_DATA_START(__sdei_asm_trampoline_next_handler)
-	.quad	__sdei_asm_handler
-SYM_DATA_END(__sdei_asm_trampoline_next_handler)
-.popsection		// .rodata
-#endif /* CONFIG_RANDOMIZE_BASE */
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
 
 /*
@@ -979,7 +1079,7 @@ alternative_if_not ARM64_UNMAP_KERNEL_AT_EL0
 alternative_else_nop_endif
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-	tramp_alias	dst=x5, sym=__sdei_asm_exit_trampoline
+	tramp_alias	dst=x5, sym=__sdei_asm_exit_trampoline, tmp=x3
 	br	x5
 #endif
 SYM_CODE_END(__sdei_asm_handler)
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index c96a9a0043bf..e03e60f9482b 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -66,6 +66,10 @@ KVM_NVHE_ALIAS(kvm_patch_vector_branch);
 KVM_NVHE_ALIAS(kvm_update_va_mask);
 KVM_NVHE_ALIAS(kvm_get_kimage_voffset);
 KVM_NVHE_ALIAS(kvm_compute_final_ctr_el0);
+KVM_NVHE_ALIAS(spectre_bhb_patch_loop_iter);
+KVM_NVHE_ALIAS(spectre_bhb_patch_loop_mitigation_enable);
+KVM_NVHE_ALIAS(spectre_bhb_patch_wa3);
+KVM_NVHE_ALIAS(spectre_bhb_patch_clearbhb);
 
 /* Global kernel state accessed by nVHE hyp code. */
 KVM_NVHE_ALIAS(kvm_vgic_global_state);
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index 902e4084c477..6d45c63c6454 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -18,15 +18,18 @@
  */
 
 #include <linux/arm-smccc.h>
+#include <linux/bpf.h>
 #include <linux/cpu.h>
 #include <linux/device.h>
 #include <linux/nospec.h>
 #include <linux/prctl.h>
 #include <linux/sched/task_stack.h>
 
+#include <asm/debug-monitors.h>
 #include <asm/insn.h>
 #include <asm/spectre.h>
 #include <asm/traps.h>
+#include <asm/vectors.h>
 #include <asm/virt.h>
 
 /*
@@ -96,14 +99,51 @@ static bool spectre_v2_mitigations_off(void)
 	return ret;
 }
 
+static const char *get_bhb_affected_string(enum mitigation_state bhb_state)
+{
+	switch (bhb_state) {
+	case SPECTRE_UNAFFECTED:
+		return "";
+	default:
+	case SPECTRE_VULNERABLE:
+		return ", but not BHB";
+	case SPECTRE_MITIGATED:
+		return ", BHB";
+	}
+}
+
+static bool _unprivileged_ebpf_enabled(void)
+{
+#ifdef CONFIG_BPF_SYSCALL
+	return !sysctl_unprivileged_bpf_disabled;
+#else
+	return false;
+#endif
+}
+
 ssize_t cpu_show_spectre_v2(struct device *dev, struct device_attribute *attr,
 			    char *buf)
 {
+	enum mitigation_state bhb_state = arm64_get_spectre_bhb_state();
+	const char *bhb_str = get_bhb_affected_string(bhb_state);
+	const char *v2_str = "Branch predictor hardening";
+
 	switch (spectre_v2_state) {
 	case SPECTRE_UNAFFECTED:
-		return sprintf(buf, "Not affected\n");
+		if (bhb_state == SPECTRE_UNAFFECTED)
+			return sprintf(buf, "Not affected\n");
+
+		/*
+		 * Platforms affected by Spectre-BHB can't report
+		 * "Not affected" for Spectre-v2.
+		 */
+		v2_str = "CSV2";
+		fallthrough;
 	case SPECTRE_MITIGATED:
-		return sprintf(buf, "Mitigation: Branch predictor hardening\n");
+		if (bhb_state == SPECTRE_MITIGATED && _unprivileged_ebpf_enabled())
+			return sprintf(buf, "Vulnerable: Unprivileged eBPF enabled\n");
+
+		return sprintf(buf, "Mitigation: %s%s\n", v2_str, bhb_str);
 	case SPECTRE_VULNERABLE:
 		fallthrough;
 	default:
@@ -554,9 +594,9 @@ void __init spectre_v4_patch_fw_mitigation_enable(struct alt_instr *alt,
  * Patch a NOP in the Spectre-v4 mitigation code with an SMC/HVC instruction
  * to call into firmware to adjust the mitigation state.
  */
-void __init spectre_v4_patch_fw_mitigation_conduit(struct alt_instr *alt,
-						   __le32 *origptr,
-						   __le32 *updptr, int nr_inst)
+void __init smccc_patch_fw_mitigation_conduit(struct alt_instr *alt,
+					       __le32 *origptr,
+					       __le32 *updptr, int nr_inst)
 {
 	u32 insn;
 
@@ -770,3 +810,344 @@ int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which)
 		return -ENODEV;
 	}
 }
+
+/*
+ * Spectre BHB.
+ *
+ * A CPU is either:
+ * - Mitigated by a branchy loop a CPU specific number of times, and listed
+ *   in our "loop mitigated list".
+ * - Mitigated in software by the firmware Spectre v2 call.
+ * - Has the ClearBHB instruction to perform the mitigation.
+ * - Has the 'Exception Clears Branch History Buffer' (ECBHB) feature, so no
+ *   software mitigation in the vectors is needed.
+ * - Has CSV2.3, so is unaffected.
+ */
+static enum mitigation_state spectre_bhb_state;
+
+enum mitigation_state arm64_get_spectre_bhb_state(void)
+{
+	return spectre_bhb_state;
+}
+
+enum bhb_mitigation_bits {
+	BHB_LOOP,
+	BHB_FW,
+	BHB_HW,
+	BHB_INSN,
+};
+static unsigned long system_bhb_mitigations;
+
+/*
+ * This must be called with SCOPE_LOCAL_CPU for each type of CPU, before any
+ * SCOPE_SYSTEM call will give the right answer.
+ */
+u8 spectre_bhb_loop_affected(int scope)
+{
+	u8 k = 0;
+	static u8 max_bhb_k;
+
+	if (scope == SCOPE_LOCAL_CPU) {
+		static const struct midr_range spectre_bhb_k32_list[] = {
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A78),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A78C),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_X1),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A710),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_X2),
+			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
+			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V1),
+			{},
+		};
+		static const struct midr_range spectre_bhb_k24_list[] = {
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A76),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A77),
+			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
+			{},
+		};
+		static const struct midr_range spectre_bhb_k8_list[] = {
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
+			{},
+		};
+
+		if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k32_list))
+			k = 32;
+		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k24_list))
+			k = 24;
+		else if (is_midr_in_range_list(read_cpuid_id(), spectre_bhb_k8_list))
+			k =  8;
+
+		max_bhb_k = max(max_bhb_k, k);
+	} else {
+		k = max_bhb_k;
+	}
+
+	return k;
+}
+
+static enum mitigation_state spectre_bhb_get_cpu_fw_mitigation_state(void)
+{
+	int ret;
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+			     ARM_SMCCC_ARCH_WORKAROUND_3, &res);
+
+	ret = res.a0;
+	switch (ret) {
+	case SMCCC_RET_SUCCESS:
+		return SPECTRE_MITIGATED;
+	case SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED:
+		return SPECTRE_UNAFFECTED;
+	default:
+		fallthrough;
+	case SMCCC_RET_NOT_SUPPORTED:
+		return SPECTRE_VULNERABLE;
+	}
+}
+
+static bool is_spectre_bhb_fw_affected(int scope)
+{
+	static bool system_affected;
+	enum mitigation_state fw_state;
+	bool has_smccc = arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_NONE;
+	static const struct midr_range spectre_bhb_firmware_mitigated_list[] = {
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_A75),
+		{},
+	};
+	bool cpu_in_list = is_midr_in_range_list(read_cpuid_id(),
+					 spectre_bhb_firmware_mitigated_list);
+
+	if (scope != SCOPE_LOCAL_CPU)
+		return system_affected;
+
+	fw_state = spectre_bhb_get_cpu_fw_mitigation_state();
+	if (cpu_in_list || (has_smccc && fw_state == SPECTRE_MITIGATED)) {
+		system_affected = true;
+		return true;
+	}
+
+	return false;
+}
+
+static bool supports_ecbhb(int scope)
+{
+	u64 mmfr1;
+
+	if (scope == SCOPE_LOCAL_CPU)
+		mmfr1 = read_sysreg_s(SYS_ID_AA64MMFR1_EL1);
+	else
+		mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+
+	return cpuid_feature_extract_unsigned_field(mmfr1,
+						    ID_AA64MMFR1_ECBHB_SHIFT);
+}
+
+bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry,
+			     int scope)
+{
+	WARN_ON(scope != SCOPE_LOCAL_CPU || preemptible());
+
+	if (supports_csv2p3(scope))
+		return false;
+
+	if (supports_clearbhb(scope))
+		return true;
+
+	if (spectre_bhb_loop_affected(scope))
+		return true;
+
+	if (is_spectre_bhb_fw_affected(scope))
+		return true;
+
+	return false;
+}
+
+static void this_cpu_set_vectors(enum arm64_bp_harden_el1_vectors slot)
+{
+	const char *v = arm64_get_bp_hardening_vector(slot);
+
+	if (slot < 0)
+		return;
+
+	__this_cpu_write(this_cpu_vector, v);
+
+	/*
+	 * When KPTI is in use, the vectors are switched when exiting to
+	 * user-space.
+	 */
+	if (arm64_kernel_unmapped_at_el0())
+		return;
+
+	write_sysreg(v, vbar_el1);
+	isb();
+}
+
+void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *entry)
+{
+	bp_hardening_cb_t cpu_cb;
+	enum mitigation_state fw_state, state = SPECTRE_VULNERABLE;
+	struct bp_hardening_data *data = this_cpu_ptr(&bp_hardening_data);
+
+	if (!is_spectre_bhb_affected(entry, SCOPE_LOCAL_CPU))
+		return;
+
+	if (arm64_get_spectre_v2_state() == SPECTRE_VULNERABLE) {
+		/* No point mitigating Spectre-BHB alone. */
+	} else if (!IS_ENABLED(CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY)) {
+		pr_info_once("spectre-bhb mitigation disabled by compile time option\n");
+	} else if (cpu_mitigations_off()) {
+		pr_info_once("spectre-bhb mitigation disabled by command line option\n");
+	} else if (supports_ecbhb(SCOPE_LOCAL_CPU)) {
+		state = SPECTRE_MITIGATED;
+		set_bit(BHB_HW, &system_bhb_mitigations);
+	} else if (supports_clearbhb(SCOPE_LOCAL_CPU)) {
+		/*
+		 * Ensure KVM uses the indirect vector which will have ClearBHB
+		 * added.
+		 */
+		if (!data->slot)
+			data->slot = HYP_VECTOR_INDIRECT;
+
+		this_cpu_set_vectors(EL1_VECTOR_BHB_CLEAR_INSN);
+		state = SPECTRE_MITIGATED;
+		set_bit(BHB_INSN, &system_bhb_mitigations);
+	} else if (spectre_bhb_loop_affected(SCOPE_LOCAL_CPU)) {
+		/*
+		 * Ensure KVM uses the indirect vector which will have the
+		 * branchy-loop added. A57/A72-r0 will already have selected
+		 * the spectre-indirect vector, which is sufficient for BHB
+		 * too.
+		 */
+		if (!data->slot)
+			data->slot = HYP_VECTOR_INDIRECT;
+
+		this_cpu_set_vectors(EL1_VECTOR_BHB_LOOP);
+		state = SPECTRE_MITIGATED;
+		set_bit(BHB_LOOP, &system_bhb_mitigations);
+	} else if (is_spectre_bhb_fw_affected(SCOPE_LOCAL_CPU)) {
+		fw_state = spectre_bhb_get_cpu_fw_mitigation_state();
+		if (fw_state == SPECTRE_MITIGATED) {
+			/*
+			 * Ensure KVM uses one of the spectre bp_hardening
+			 * vectors. The indirect vector doesn't include the EL3
+			 * call, so needs upgrading to
+			 * HYP_VECTOR_SPECTRE_INDIRECT.
+			 */
+			if (!data->slot || data->slot == HYP_VECTOR_INDIRECT)
+				data->slot += 1;
+
+			this_cpu_set_vectors(EL1_VECTOR_BHB_FW);
+
+			/*
+			 * The WA3 call in the vectors supersedes the WA1 call
+			 * made during context-switch. Uninstall any firmware
+			 * bp_hardening callback.
+			 */
+			cpu_cb = spectre_v2_get_sw_mitigation_cb();
+			if (__this_cpu_read(bp_hardening_data.fn) != cpu_cb)
+				__this_cpu_write(bp_hardening_data.fn, NULL);
+
+			state = SPECTRE_MITIGATED;
+			set_bit(BHB_FW, &system_bhb_mitigations);
+		}
+	}
+
+	update_mitigation_state(&spectre_bhb_state, state);
+}
+
+/* Patched to NOP when enabled */
+void noinstr spectre_bhb_patch_loop_mitigation_enable(struct alt_instr *alt,
+						     __le32 *origptr,
+						      __le32 *updptr, int nr_inst)
+{
+	BUG_ON(nr_inst != 1);
+
+	if (test_bit(BHB_LOOP, &system_bhb_mitigations))
+		*updptr++ = cpu_to_le32(aarch64_insn_gen_nop());
+}
+
+/* Patched to NOP when enabled */
+void noinstr spectre_bhb_patch_fw_mitigation_enabled(struct alt_instr *alt,
+						   __le32 *origptr,
+						   __le32 *updptr, int nr_inst)
+{
+	BUG_ON(nr_inst != 1);
+
+	if (test_bit(BHB_FW, &system_bhb_mitigations))
+		*updptr++ = cpu_to_le32(aarch64_insn_gen_nop());
+}
+
+/* Patched to correct the immediate */
+void noinstr spectre_bhb_patch_loop_iter(struct alt_instr *alt,
+				   __le32 *origptr, __le32 *updptr, int nr_inst)
+{
+	u8 rd;
+	u32 insn;
+	u16 loop_count = spectre_bhb_loop_affected(SCOPE_SYSTEM);
+
+	BUG_ON(nr_inst != 1); /* MOV -> MOV */
+
+	if (!IS_ENABLED(CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY))
+		return;
+
+	insn = le32_to_cpu(*origptr);
+	rd = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD, insn);
+	insn = aarch64_insn_gen_movewide(rd, loop_count, 0,
+					 AARCH64_INSN_VARIANT_64BIT,
+					 AARCH64_INSN_MOVEWIDE_ZERO);
+	*updptr++ = cpu_to_le32(insn);
+}
+
+/* Patched to mov WA3 when supported */
+void noinstr spectre_bhb_patch_wa3(struct alt_instr *alt,
+				   __le32 *origptr, __le32 *updptr, int nr_inst)
+{
+	u8 rd;
+	u32 insn;
+
+	BUG_ON(nr_inst != 1); /* MOV -> MOV */
+
+	if (!IS_ENABLED(CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY) ||
+	    !test_bit(BHB_FW, &system_bhb_mitigations))
+		return;
+
+	insn = le32_to_cpu(*origptr);
+	rd = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD, insn);
+
+	insn = aarch64_insn_gen_logical_immediate(AARCH64_INSN_LOGIC_ORR,
+						  AARCH64_INSN_VARIANT_32BIT,
+						  AARCH64_INSN_REG_ZR, rd,
+						  ARM_SMCCC_ARCH_WORKAROUND_3);
+	if (WARN_ON_ONCE(insn == AARCH64_BREAK_FAULT))
+		return;
+
+	*updptr++ = cpu_to_le32(insn);
+}
+
+/* Patched to NOP when not supported */
+void __init spectre_bhb_patch_clearbhb(struct alt_instr *alt,
+				   __le32 *origptr, __le32 *updptr, int nr_inst)
+{
+	BUG_ON(nr_inst != 2);
+
+	if (test_bit(BHB_INSN, &system_bhb_mitigations))
+		return;
+
+	*updptr++ = cpu_to_le32(aarch64_insn_gen_nop());
+	*updptr++ = cpu_to_le32(aarch64_insn_gen_nop());
+}
+
+#ifdef CONFIG_BPF_SYSCALL
+#define EBPF_WARN "Unprivileged eBPF is enabled, data leaks possible via Spectre v2 BHB attacks!\n"
+void unpriv_ebpf_notify(int new_state)
+{
+	if (spectre_v2_state == SPECTRE_VULNERABLE ||
+	    spectre_bhb_state != SPECTRE_MITIGATED)
+		return;
+
+	if (!new_state)
+		pr_err("WARNING: %s", EBPF_WARN);
+}
+#endif
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 50bab186c49b..edaf0faf766f 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -341,7 +341,7 @@ ASSERT(__hibernate_exit_text_end - (__hibernate_exit_text_start & ~(SZ_4K - 1))
 	<= SZ_4K, "Hibernate exit text too big or misaligned")
 #endif
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-ASSERT((__entry_tramp_text_end - __entry_tramp_text_start) == PAGE_SIZE,
+ASSERT((__entry_tramp_text_end - __entry_tramp_text_start) <= 3*PAGE_SIZE,
 	"Entry trampoline text too big")
 #endif
 #ifdef CONFIG_KVM
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b2222d8eb0b5..1eadf9088880 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1464,10 +1464,7 @@ static int kvm_init_vector_slots(void)
 	base = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs));
 	kvm_init_vector_slot(base, HYP_VECTOR_SPECTRE_DIRECT);
 
-	if (!cpus_have_const_cap(ARM64_SPECTRE_V3A))
-		return 0;
-
-	if (!has_vhe()) {
+	if (kvm_system_needs_idmapped_vectors() && !has_vhe()) {
 		err = create_hyp_exec_mappings(__pa_symbol(__bp_harden_hyp_vecs),
 					       __BP_HARDEN_HYP_VECS_SZ, &base);
 		if (err)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index b6b6801d96d5..7839d075729b 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -62,6 +62,10 @@ el1_sync:				// Guest trapped into EL2
 	/* ARM_SMCCC_ARCH_WORKAROUND_2 handling */
 	eor	w1, w1, #(ARM_SMCCC_ARCH_WORKAROUND_1 ^ \
 			  ARM_SMCCC_ARCH_WORKAROUND_2)
+	cbz	w1, wa_epilogue
+
+	eor	w1, w1, #(ARM_SMCCC_ARCH_WORKAROUND_2 ^ \
+			  ARM_SMCCC_ARCH_WORKAROUND_3)
 	cbnz	w1, el1_trap
 
 wa_epilogue:
@@ -192,7 +196,10 @@ SYM_CODE_END(__kvm_hyp_vector)
 	sub	sp, sp, #(8 * 4)
 	stp	x2, x3, [sp, #(8 * 0)]
 	stp	x0, x1, [sp, #(8 * 2)]
+	alternative_cb spectre_bhb_patch_wa3
+	/* Patched to mov WA3 when supported */
 	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_1
+	alternative_cb_end
 	smc	#0
 	ldp	x2, x3, [sp, #(8 * 0)]
 	add	sp, sp, #(8 * 2)
@@ -205,6 +212,8 @@ SYM_CODE_END(__kvm_hyp_vector)
 	spectrev2_smccc_wa1_smc
 	.else
 	stp	x0, x1, [sp, #-16]!
+	mitigate_spectre_bhb_loop	x0
+	mitigate_spectre_bhb_clear_insn
 	.endif
 	.if \indirect != 0
 	alternative_cb  kvm_patch_vector_branch
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 2fabeceb889a..5146fb170505 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -146,8 +146,10 @@ int hyp_map_vectors(void)
 	phys_addr_t phys;
 	void *bp_base;
 
-	if (!cpus_have_const_cap(ARM64_SPECTRE_V3A))
+	if (!kvm_system_needs_idmapped_vectors()) {
+		__hyp_bp_vect_base = __bp_harden_hyp_vecs;
 		return 0;
+	}
 
 	phys = __hyp_pa(__bp_harden_hyp_vecs);
 	bp_base = (void *)__pkvm_create_private_mapping(phys,
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index fbb26b93c347..54af47005e45 100644
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
 
@@ -82,7 +84,10 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 
 	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
-	write_sysreg(vectors, vbar_el1);
+
+	if (!arm64_kernel_unmapped_at_el0())
+		host_vectors = __this_cpu_read(this_cpu_vector);
+	write_sysreg(host_vectors, vbar_el1);
 }
 NOKPROBE_SYMBOL(__deactivate_traps);
 
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 30da78f72b3b..202b8c455724 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -107,6 +107,18 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 				break;
 			}
 			break;
+		case ARM_SMCCC_ARCH_WORKAROUND_3:
+			switch (arm64_get_spectre_bhb_state()) {
+			case SPECTRE_VULNERABLE:
+				break;
+			case SPECTRE_MITIGATED:
+				val[0] = SMCCC_RET_SUCCESS;
+				break;
+			case SPECTRE_UNAFFECTED:
+				val[0] = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
+				break;
+			}
+			break;
 		case ARM_SMCCC_HV_PV_TIME_FEATURES:
 			val[0] = SMCCC_RET_SUCCESS;
 			break;
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 74c47d420253..44efe12dfc06 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -406,7 +406,7 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
 {
-	return 3;		/* PSCI version and two workaround registers */
+	return 4;		/* PSCI version and three workaround registers */
 }
 
 int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
@@ -420,6 +420,9 @@ int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2, uindices++))
 		return -EFAULT;
 
+	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3, uindices++))
+		return -EFAULT;
+
 	return 0;
 }
 
@@ -459,6 +462,17 @@ static int get_kernel_wa_level(u64 regid)
 		case SPECTRE_VULNERABLE:
 			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
 		}
+		break;
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
+		switch (arm64_get_spectre_bhb_state()) {
+		case SPECTRE_VULNERABLE:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL;
+		case SPECTRE_MITIGATED:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_AVAIL;
+		case SPECTRE_UNAFFECTED:
+			return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_REQUIRED;
+		}
+		return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL;
 	}
 
 	return -EINVAL;
@@ -475,6 +489,7 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		break;
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
 		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
 		break;
 	default:
@@ -520,6 +535,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	}
 
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
+	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
 		if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
 			return -EINVAL;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e3ec1a44f94d..4dc2fba316ff 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1525,7 +1525,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* CRm=6 */
 	ID_SANITISED(ID_AA64ISAR0_EL1),
 	ID_SANITISED(ID_AA64ISAR1_EL1),
-	ID_UNALLOCATED(6,2),
+	ID_SANITISED(ID_AA64ISAR2_EL1),
 	ID_UNALLOCATED(6,3),
 	ID_UNALLOCATED(6,4),
 	ID_UNALLOCATED(6,5),
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index acfae9b41cc8..49abbf43bf35 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -617,6 +617,8 @@ early_param("rodata", parse_rodata);
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 static int __init map_entry_trampoline(void)
 {
+	int i;
+
 	pgprot_t prot = rodata_enabled ? PAGE_KERNEL_ROX : PAGE_KERNEL_EXEC;
 	phys_addr_t pa_start = __pa_symbol(__entry_tramp_text_start);
 
@@ -625,11 +627,15 @@ static int __init map_entry_trampoline(void)
 
 	/* Map only the text into the trampoline page table */
 	memset(tramp_pg_dir, 0, PGD_SIZE);
-	__create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS, PAGE_SIZE,
-			     prot, __pgd_pgtable_alloc, 0);
+	__create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS,
+			     entry_tramp_text_size(), prot,
+			     __pgd_pgtable_alloc, NO_BLOCK_MAPPINGS);
 
 	/* Map both the text and data into the kernel page table */
-	__set_fixmap(FIX_ENTRY_TRAMP_TEXT, pa_start, prot);
+	for (i = 0; i < DIV_ROUND_UP(entry_tramp_text_size(), PAGE_SIZE); i++)
+		__set_fixmap(FIX_ENTRY_TRAMP_TEXT1 - i,
+			     pa_start + i * PAGE_SIZE, prot);
+
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
 		extern char __entry_tramp_data_start[];
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 9c65b1e25a96..cea7533cb304 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -44,6 +44,7 @@ MTE_ASYMM
 SPECTRE_V2
 SPECTRE_V3A
 SPECTRE_V4
+SPECTRE_BHB
 SSBS
 SVE
 UNMAP_KERNEL_AT_EL0
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index d5b5f2ab87a0..cc8570f73898 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -204,7 +204,7 @@
 /* FREE!                                ( 7*32+10) */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
 #define X86_FEATURE_RETPOLINE		( 7*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
-#define X86_FEATURE_RETPOLINE_AMD	( 7*32+13) /* "" AMD Retpoline mitigation for Spectre variant 2 */
+#define X86_FEATURE_RETPOLINE_LFENCE	( 7*32+13) /* "" Use LFENCE for Spectre variant 2 */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_CDP_L2		( 7*32+15) /* Code and Data Prioritization L2 */
 #define X86_FEATURE_MSR_SPEC_CTRL	( 7*32+16) /* "" MSR SPEC_CTRL is implemented */
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index cc74dc584836..acbaeaf83b61 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -84,7 +84,7 @@
 #ifdef CONFIG_RETPOLINE
 	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), \
 		      __stringify(jmp __x86_indirect_thunk_\reg), X86_FEATURE_RETPOLINE, \
-		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), X86_FEATURE_RETPOLINE_AMD
+		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), X86_FEATURE_RETPOLINE_LFENCE
 #else
 	jmp	*%\reg
 #endif
@@ -94,7 +94,7 @@
 #ifdef CONFIG_RETPOLINE
 	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; call *%\reg), \
 		      __stringify(call __x86_indirect_thunk_\reg), X86_FEATURE_RETPOLINE, \
-		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; call *%\reg), X86_FEATURE_RETPOLINE_AMD
+		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; call *%\reg), X86_FEATURE_RETPOLINE_LFENCE
 #else
 	call	*%\reg
 #endif
@@ -146,7 +146,7 @@ extern retpoline_thunk_t __x86_indirect_thunk_array[];
 	"lfence;\n"						\
 	ANNOTATE_RETPOLINE_SAFE					\
 	"call *%[thunk_target]\n",				\
-	X86_FEATURE_RETPOLINE_AMD)
+	X86_FEATURE_RETPOLINE_LFENCE)
 
 # define THUNK_TARGET(addr) [thunk_target] "r" (addr)
 
@@ -176,7 +176,7 @@ extern retpoline_thunk_t __x86_indirect_thunk_array[];
 	"lfence;\n"						\
 	ANNOTATE_RETPOLINE_SAFE					\
 	"call *%[thunk_target]\n",				\
-	X86_FEATURE_RETPOLINE_AMD)
+	X86_FEATURE_RETPOLINE_LFENCE)
 
 # define THUNK_TARGET(addr) [thunk_target] "rm" (addr)
 #endif
@@ -188,9 +188,11 @@ extern retpoline_thunk_t __x86_indirect_thunk_array[];
 /* The Spectre V2 mitigation variants */
 enum spectre_v2_mitigation {
 	SPECTRE_V2_NONE,
-	SPECTRE_V2_RETPOLINE_GENERIC,
-	SPECTRE_V2_RETPOLINE_AMD,
-	SPECTRE_V2_IBRS_ENHANCED,
+	SPECTRE_V2_RETPOLINE,
+	SPECTRE_V2_LFENCE,
+	SPECTRE_V2_EIBRS,
+	SPECTRE_V2_EIBRS_RETPOLINE,
+	SPECTRE_V2_EIBRS_LFENCE,
 };
 
 /* The indirect branch speculation control variants */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 23fb4d51a5da..563a3de72477 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -389,7 +389,7 @@ static int emit_indirect(int op, int reg, u8 *bytes)
  *
  *   CALL *%\reg
  *
- * It also tries to inline spectre_v2=retpoline,amd when size permits.
+ * It also tries to inline spectre_v2=retpoline,lfence when size permits.
  */
 static int patch_retpoline(void *addr, struct insn *insn, u8 *bytes)
 {
@@ -407,7 +407,7 @@ static int patch_retpoline(void *addr, struct insn *insn, u8 *bytes)
 	BUG_ON(reg == 4);
 
 	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE) &&
-	    !cpu_feature_enabled(X86_FEATURE_RETPOLINE_AMD))
+	    !cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE))
 		return -1;
 
 	op = insn->opcode.bytes[0];
@@ -438,9 +438,9 @@ static int patch_retpoline(void *addr, struct insn *insn, u8 *bytes)
 	}
 
 	/*
-	 * For RETPOLINE_AMD: prepend the indirect CALL/JMP with an LFENCE.
+	 * For RETPOLINE_LFENCE: prepend the indirect CALL/JMP with an LFENCE.
 	 */
-	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_AMD)) {
+	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE)) {
 		bytes[i++] = 0x0f;
 		bytes[i++] = 0xae;
 		bytes[i++] = 0xe8; /* LFENCE */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 1c1f218a701d..6296e1ebed1d 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -16,6 +16,7 @@
 #include <linux/prctl.h>
 #include <linux/sched/smt.h>
 #include <linux/pgtable.h>
+#include <linux/bpf.h>
 
 #include <asm/spec-ctrl.h>
 #include <asm/cmdline.h>
@@ -650,6 +651,32 @@ static inline const char *spectre_v2_module_string(void)
 static inline const char *spectre_v2_module_string(void) { return ""; }
 #endif
 
+#define SPECTRE_V2_LFENCE_MSG "WARNING: LFENCE mitigation is not recommended for this CPU, data leaks possible!\n"
+#define SPECTRE_V2_EIBRS_EBPF_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!\n"
+#define SPECTRE_V2_EIBRS_LFENCE_EBPF_SMT_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS+LFENCE mitigation and SMT, data leaks possible via Spectre v2 BHB attacks!\n"
+
+#ifdef CONFIG_BPF_SYSCALL
+void unpriv_ebpf_notify(int new_state)
+{
+	if (new_state)
+		return;
+
+	/* Unprivileged eBPF is enabled */
+
+	switch (spectre_v2_enabled) {
+	case SPECTRE_V2_EIBRS:
+		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
+		break;
+	case SPECTRE_V2_EIBRS_LFENCE:
+		if (sched_smt_active())
+			pr_err(SPECTRE_V2_EIBRS_LFENCE_EBPF_SMT_MSG);
+		break;
+	default:
+		break;
+	}
+}
+#endif
+
 static inline bool match_option(const char *arg, int arglen, const char *opt)
 {
 	int len = strlen(opt);
@@ -664,7 +691,10 @@ enum spectre_v2_mitigation_cmd {
 	SPECTRE_V2_CMD_FORCE,
 	SPECTRE_V2_CMD_RETPOLINE,
 	SPECTRE_V2_CMD_RETPOLINE_GENERIC,
-	SPECTRE_V2_CMD_RETPOLINE_AMD,
+	SPECTRE_V2_CMD_RETPOLINE_LFENCE,
+	SPECTRE_V2_CMD_EIBRS,
+	SPECTRE_V2_CMD_EIBRS_RETPOLINE,
+	SPECTRE_V2_CMD_EIBRS_LFENCE,
 };
 
 enum spectre_v2_user_cmd {
@@ -737,6 +767,13 @@ spectre_v2_parse_user_cmdline(enum spectre_v2_mitigation_cmd v2_cmd)
 	return SPECTRE_V2_USER_CMD_AUTO;
 }
 
+static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
+{
+	return (mode == SPECTRE_V2_EIBRS ||
+		mode == SPECTRE_V2_EIBRS_RETPOLINE ||
+		mode == SPECTRE_V2_EIBRS_LFENCE);
+}
+
 static void __init
 spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 {
@@ -804,7 +841,7 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 	 */
 	if (!boot_cpu_has(X86_FEATURE_STIBP) ||
 	    !smt_possible ||
-	    spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
+	    spectre_v2_in_eibrs_mode(spectre_v2_enabled))
 		return;
 
 	/*
@@ -824,9 +861,11 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 
 static const char * const spectre_v2_strings[] = {
 	[SPECTRE_V2_NONE]			= "Vulnerable",
-	[SPECTRE_V2_RETPOLINE_GENERIC]		= "Mitigation: Full generic retpoline",
-	[SPECTRE_V2_RETPOLINE_AMD]		= "Mitigation: Full AMD retpoline",
-	[SPECTRE_V2_IBRS_ENHANCED]		= "Mitigation: Enhanced IBRS",
+	[SPECTRE_V2_RETPOLINE]			= "Mitigation: Retpolines",
+	[SPECTRE_V2_LFENCE]			= "Mitigation: LFENCE",
+	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced IBRS",
+	[SPECTRE_V2_EIBRS_LFENCE]		= "Mitigation: Enhanced IBRS + LFENCE",
+	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced IBRS + Retpolines",
 };
 
 static const struct {
@@ -837,8 +876,12 @@ static const struct {
 	{ "off",		SPECTRE_V2_CMD_NONE,		  false },
 	{ "on",			SPECTRE_V2_CMD_FORCE,		  true  },
 	{ "retpoline",		SPECTRE_V2_CMD_RETPOLINE,	  false },
-	{ "retpoline,amd",	SPECTRE_V2_CMD_RETPOLINE_AMD,	  false },
+	{ "retpoline,amd",	SPECTRE_V2_CMD_RETPOLINE_LFENCE,  false },
+	{ "retpoline,lfence",	SPECTRE_V2_CMD_RETPOLINE_LFENCE,  false },
 	{ "retpoline,generic",	SPECTRE_V2_CMD_RETPOLINE_GENERIC, false },
+	{ "eibrs",		SPECTRE_V2_CMD_EIBRS,		  false },
+	{ "eibrs,lfence",	SPECTRE_V2_CMD_EIBRS_LFENCE,	  false },
+	{ "eibrs,retpoline",	SPECTRE_V2_CMD_EIBRS_RETPOLINE,	  false },
 	{ "auto",		SPECTRE_V2_CMD_AUTO,		  false },
 };
 
@@ -875,10 +918,30 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
 	}
 
 	if ((cmd == SPECTRE_V2_CMD_RETPOLINE ||
-	     cmd == SPECTRE_V2_CMD_RETPOLINE_AMD ||
-	     cmd == SPECTRE_V2_CMD_RETPOLINE_GENERIC) &&
+	     cmd == SPECTRE_V2_CMD_RETPOLINE_LFENCE ||
+	     cmd == SPECTRE_V2_CMD_RETPOLINE_GENERIC ||
+	     cmd == SPECTRE_V2_CMD_EIBRS_LFENCE ||
+	     cmd == SPECTRE_V2_CMD_EIBRS_RETPOLINE) &&
 	    !IS_ENABLED(CONFIG_RETPOLINE)) {
-		pr_err("%s selected but not compiled in. Switching to AUTO select\n", mitigation_options[i].option);
+		pr_err("%s selected but not compiled in. Switching to AUTO select\n",
+		       mitigation_options[i].option);
+		return SPECTRE_V2_CMD_AUTO;
+	}
+
+	if ((cmd == SPECTRE_V2_CMD_EIBRS ||
+	     cmd == SPECTRE_V2_CMD_EIBRS_LFENCE ||
+	     cmd == SPECTRE_V2_CMD_EIBRS_RETPOLINE) &&
+	    !boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
+		pr_err("%s selected but CPU doesn't have eIBRS. Switching to AUTO select\n",
+		       mitigation_options[i].option);
+		return SPECTRE_V2_CMD_AUTO;
+	}
+
+	if ((cmd == SPECTRE_V2_CMD_RETPOLINE_LFENCE ||
+	     cmd == SPECTRE_V2_CMD_EIBRS_LFENCE) &&
+	    !boot_cpu_has(X86_FEATURE_LFENCE_RDTSC)) {
+		pr_err("%s selected, but CPU doesn't have a serializing LFENCE. Switching to AUTO select\n",
+		       mitigation_options[i].option);
 		return SPECTRE_V2_CMD_AUTO;
 	}
 
@@ -887,6 +950,16 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
 	return cmd;
 }
 
+static enum spectre_v2_mitigation __init spectre_v2_select_retpoline(void)
+{
+	if (!IS_ENABLED(CONFIG_RETPOLINE)) {
+		pr_err("Kernel not compiled with retpoline; no mitigation available!");
+		return SPECTRE_V2_NONE;
+	}
+
+	return SPECTRE_V2_RETPOLINE;
+}
+
 static void __init spectre_v2_select_mitigation(void)
 {
 	enum spectre_v2_mitigation_cmd cmd = spectre_v2_parse_cmdline();
@@ -907,49 +980,64 @@ static void __init spectre_v2_select_mitigation(void)
 	case SPECTRE_V2_CMD_FORCE:
 	case SPECTRE_V2_CMD_AUTO:
 		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
-			mode = SPECTRE_V2_IBRS_ENHANCED;
-			/* Force it so VMEXIT will restore correctly */
-			x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
-			goto specv2_set_mode;
+			mode = SPECTRE_V2_EIBRS;
+			break;
 		}
-		if (IS_ENABLED(CONFIG_RETPOLINE))
-			goto retpoline_auto;
+
+		mode = spectre_v2_select_retpoline();
 		break;
-	case SPECTRE_V2_CMD_RETPOLINE_AMD:
-		if (IS_ENABLED(CONFIG_RETPOLINE))
-			goto retpoline_amd;
+
+	case SPECTRE_V2_CMD_RETPOLINE_LFENCE:
+		pr_err(SPECTRE_V2_LFENCE_MSG);
+		mode = SPECTRE_V2_LFENCE;
 		break;
+
 	case SPECTRE_V2_CMD_RETPOLINE_GENERIC:
-		if (IS_ENABLED(CONFIG_RETPOLINE))
-			goto retpoline_generic;
+		mode = SPECTRE_V2_RETPOLINE;
 		break;
+
 	case SPECTRE_V2_CMD_RETPOLINE:
-		if (IS_ENABLED(CONFIG_RETPOLINE))
-			goto retpoline_auto;
+		mode = spectre_v2_select_retpoline();
+		break;
+
+	case SPECTRE_V2_CMD_EIBRS:
+		mode = SPECTRE_V2_EIBRS;
+		break;
+
+	case SPECTRE_V2_CMD_EIBRS_LFENCE:
+		mode = SPECTRE_V2_EIBRS_LFENCE;
+		break;
+
+	case SPECTRE_V2_CMD_EIBRS_RETPOLINE:
+		mode = SPECTRE_V2_EIBRS_RETPOLINE;
 		break;
 	}
-	pr_err("Spectre mitigation: kernel not compiled with retpoline; no mitigation available!");
-	return;
 
-retpoline_auto:
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
-	    boot_cpu_data.x86_vendor == X86_VENDOR_HYGON) {
-	retpoline_amd:
-		if (!boot_cpu_has(X86_FEATURE_LFENCE_RDTSC)) {
-			pr_err("Spectre mitigation: LFENCE not serializing, switching to generic retpoline\n");
-			goto retpoline_generic;
-		}
-		mode = SPECTRE_V2_RETPOLINE_AMD;
-		setup_force_cpu_cap(X86_FEATURE_RETPOLINE_AMD);
-		setup_force_cpu_cap(X86_FEATURE_RETPOLINE);
-	} else {
-	retpoline_generic:
-		mode = SPECTRE_V2_RETPOLINE_GENERIC;
+	if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
+		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
+
+	if (spectre_v2_in_eibrs_mode(mode)) {
+		/* Force it so VMEXIT will restore correctly */
+		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
+		wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+	}
+
+	switch (mode) {
+	case SPECTRE_V2_NONE:
+	case SPECTRE_V2_EIBRS:
+		break;
+
+	case SPECTRE_V2_LFENCE:
+	case SPECTRE_V2_EIBRS_LFENCE:
+		setup_force_cpu_cap(X86_FEATURE_RETPOLINE_LFENCE);
+		fallthrough;
+
+	case SPECTRE_V2_RETPOLINE:
+	case SPECTRE_V2_EIBRS_RETPOLINE:
 		setup_force_cpu_cap(X86_FEATURE_RETPOLINE);
+		break;
 	}
 
-specv2_set_mode:
 	spectre_v2_enabled = mode;
 	pr_info("%s\n", spectre_v2_strings[mode]);
 
@@ -975,7 +1063,7 @@ static void __init spectre_v2_select_mitigation(void)
 	 * the CPU supports Enhanced IBRS, kernel might un-intentionally not
 	 * enable IBRS around firmware calls.
 	 */
-	if (boot_cpu_has(X86_FEATURE_IBRS) && mode != SPECTRE_V2_IBRS_ENHANCED) {
+	if (boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_eibrs_mode(mode)) {
 		setup_force_cpu_cap(X86_FEATURE_USE_IBRS_FW);
 		pr_info("Enabling Restricted Speculation for firmware calls\n");
 	}
@@ -1045,6 +1133,10 @@ void cpu_bugs_smt_update(void)
 {
 	mutex_lock(&spec_ctrl_mutex);
 
+	if (sched_smt_active() && unprivileged_ebpf_enabled() &&
+	    spectre_v2_enabled == SPECTRE_V2_EIBRS_LFENCE)
+		pr_warn_once(SPECTRE_V2_EIBRS_LFENCE_EBPF_SMT_MSG);
+
 	switch (spectre_v2_user_stibp) {
 	case SPECTRE_V2_USER_NONE:
 		break;
@@ -1684,7 +1776,7 @@ static ssize_t tsx_async_abort_show_state(char *buf)
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
+	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))
 		return "";
 
 	switch (spectre_v2_user_stibp) {
@@ -1714,6 +1806,27 @@ static char *ibpb_state(void)
 	return "";
 }
 
+static ssize_t spectre_v2_show_state(char *buf)
+{
+	if (spectre_v2_enabled == SPECTRE_V2_LFENCE)
+		return sprintf(buf, "Vulnerable: LFENCE\n");
+
+	if (spectre_v2_enabled == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
+		return sprintf(buf, "Vulnerable: eIBRS with unprivileged eBPF\n");
+
+	if (sched_smt_active() && unprivileged_ebpf_enabled() &&
+	    spectre_v2_enabled == SPECTRE_V2_EIBRS_LFENCE)
+		return sprintf(buf, "Vulnerable: eIBRS+LFENCE with unprivileged eBPF and SMT\n");
+
+	return sprintf(buf, "%s%s%s%s%s%s\n",
+		       spectre_v2_strings[spectre_v2_enabled],
+		       ibpb_state(),
+		       boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? ", IBRS_FW" : "",
+		       stibp_state(),
+		       boot_cpu_has(X86_FEATURE_RSB_CTXSW) ? ", RSB filling" : "",
+		       spectre_v2_module_string());
+}
+
 static ssize_t srbds_show_state(char *buf)
 {
 	return sprintf(buf, "%s\n", srbds_strings[srbds_mitigation]);
@@ -1739,12 +1852,7 @@ static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr
 		return sprintf(buf, "%s\n", spectre_v1_strings[spectre_v1_mitigation]);
 
 	case X86_BUG_SPECTRE_V2:
-		return sprintf(buf, "%s%s%s%s%s%s\n", spectre_v2_strings[spectre_v2_enabled],
-			       ibpb_state(),
-			       boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? ", IBRS_FW" : "",
-			       stibp_state(),
-			       boot_cpu_has(X86_FEATURE_RSB_CTXSW) ? ", RSB filling" : "",
-			       spectre_v2_module_string());
+		return spectre_v2_show_state(buf);
 
 	case X86_BUG_SPEC_STORE_BYPASS:
 		return sprintf(buf, "%s\n", ssb_strings[ssb_mode]);
diff --git a/arch/x86/lib/retpoline.S b/arch/x86/lib/retpoline.S
index cf0b39f97adc..6565c6f86160 100644
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -34,7 +34,7 @@ SYM_INNER_LABEL(__x86_indirect_thunk_\reg, SYM_L_GLOBAL)
 
 	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), \
 		      __stringify(RETPOLINE \reg), X86_FEATURE_RETPOLINE, \
-		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), X86_FEATURE_RETPOLINE_AMD
+		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), X86_FEATURE_RETPOLINE_LFENCE
 
 .endm
 
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index b87d98efd224..cd3959c0be50 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -394,7 +394,7 @@ static void emit_indirect_jump(u8 **pprog, int reg, u8 *ip)
 	u8 *prog = *pprog;
 
 #ifdef CONFIG_RETPOLINE
-	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_AMD)) {
+	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE)) {
 		EMIT_LFENCE();
 		EMIT2(0xFF, 0xE0 + reg);
 	} else if (cpu_feature_enabled(X86_FEATURE_RETPOLINE)) {
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 1712990bf2ad..b9c44e6c5e40 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2051,16 +2051,6 @@ bool acpi_ec_dispatch_gpe(void)
 	if (acpi_any_gpe_status_set(first_ec->gpe))
 		return true;
 
-	/*
-	 * Cancel the SCI wakeup and process all pending events in case there
-	 * are any wakeup ones in there.
-	 *
-	 * Note that if any non-EC GPEs are active at this point, the SCI will
-	 * retrigger after the rearming in acpi_s2idle_wake(), so no events
-	 * should be missed by canceling the wakeup here.
-	 */
-	pm_system_cancel_wakeup();
-
 	/*
 	 * Dispatch the EC GPE in-band, but do not report wakeup in any case
 	 * to allow the caller to process events properly after that.
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 8513410ca2fc..9f237dc9d45f 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -739,15 +739,21 @@ bool acpi_s2idle_wake(void)
 			return true;
 		}
 
-		/*
-		 * Check non-EC GPE wakeups and if there are none, cancel the
-		 * SCI-related wakeup and dispatch the EC GPE.
-		 */
+		/* Check non-EC GPE wakeups and dispatch the EC GPE. */
 		if (acpi_ec_dispatch_gpe()) {
 			pm_pr_dbg("ACPI non-EC GPE wakeup\n");
 			return true;
 		}
 
+		/*
+		 * Cancel the SCI wakeup and process all pending events in case
+		 * there are any wakeup ones in there.
+		 *
+		 * Note that if any non-EC GPEs are active at this point, the
+		 * SCI will retrigger after the rearming below, so no events
+		 * should be missed by canceling the wakeup here.
+		 */
+		pm_system_cancel_wakeup();
 		acpi_os_wait_events_complete();
 
 		/*
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2a5b14230986..7d798f8216be 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1291,7 +1291,8 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
 			rinfo->ring_ref[i] = GRANT_INVALID_REF;
 		}
 	}
-	free_pages((unsigned long)rinfo->ring.sring, get_order(info->nr_ring_pages * XEN_PAGE_SIZE));
+	free_pages_exact(rinfo->ring.sring,
+			 info->nr_ring_pages * XEN_PAGE_SIZE);
 	rinfo->ring.sring = NULL;
 
 	if (rinfo->irq)
@@ -1375,9 +1376,15 @@ static int blkif_get_final_status(enum blk_req_status s1,
 	return BLKIF_RSP_OKAY;
 }
 
-static bool blkif_completion(unsigned long *id,
-			     struct blkfront_ring_info *rinfo,
-			     struct blkif_response *bret)
+/*
+ * Return values:
+ *  1 response processed.
+ *  0 missing further responses.
+ * -1 error while processing.
+ */
+static int blkif_completion(unsigned long *id,
+			    struct blkfront_ring_info *rinfo,
+			    struct blkif_response *bret)
 {
 	int i = 0;
 	struct scatterlist *sg;
@@ -1400,7 +1407,7 @@ static bool blkif_completion(unsigned long *id,
 
 		/* Wait the second response if not yet here. */
 		if (s2->status < REQ_DONE)
-			return false;
+			return 0;
 
 		bret->status = blkif_get_final_status(s->status,
 						      s2->status);
@@ -1451,42 +1458,43 @@ static bool blkif_completion(unsigned long *id,
 	}
 	/* Add the persistent grant into the list of free grants */
 	for (i = 0; i < num_grant; i++) {
-		if (gnttab_query_foreign_access(s->grants_used[i]->gref)) {
+		if (!gnttab_try_end_foreign_access(s->grants_used[i]->gref)) {
 			/*
 			 * If the grant is still mapped by the backend (the
 			 * backend has chosen to make this grant persistent)
 			 * we add it at the head of the list, so it will be
 			 * reused first.
 			 */
-			if (!info->feature_persistent)
-				pr_alert_ratelimited("backed has not unmapped grant: %u\n",
-						     s->grants_used[i]->gref);
+			if (!info->feature_persistent) {
+				pr_alert("backed has not unmapped grant: %u\n",
+					 s->grants_used[i]->gref);
+				return -1;
+			}
 			list_add(&s->grants_used[i]->node, &rinfo->grants);
 			rinfo->persistent_gnts_c++;
 		} else {
 			/*
-			 * If the grant is not mapped by the backend we end the
-			 * foreign access and add it to the tail of the list,
-			 * so it will not be picked again unless we run out of
-			 * persistent grants.
+			 * If the grant is not mapped by the backend we add it
+			 * to the tail of the list, so it will not be picked
+			 * again unless we run out of persistent grants.
 			 */
-			gnttab_end_foreign_access(s->grants_used[i]->gref, 0, 0UL);
 			s->grants_used[i]->gref = GRANT_INVALID_REF;
 			list_add_tail(&s->grants_used[i]->node, &rinfo->grants);
 		}
 	}
 	if (s->req.operation == BLKIF_OP_INDIRECT) {
 		for (i = 0; i < INDIRECT_GREFS(num_grant); i++) {
-			if (gnttab_query_foreign_access(s->indirect_grants[i]->gref)) {
-				if (!info->feature_persistent)
-					pr_alert_ratelimited("backed has not unmapped grant: %u\n",
-							     s->indirect_grants[i]->gref);
+			if (!gnttab_try_end_foreign_access(s->indirect_grants[i]->gref)) {
+				if (!info->feature_persistent) {
+					pr_alert("backed has not unmapped grant: %u\n",
+						 s->indirect_grants[i]->gref);
+					return -1;
+				}
 				list_add(&s->indirect_grants[i]->node, &rinfo->grants);
 				rinfo->persistent_gnts_c++;
 			} else {
 				struct page *indirect_page;
 
-				gnttab_end_foreign_access(s->indirect_grants[i]->gref, 0, 0UL);
 				/*
 				 * Add the used indirect page back to the list of
 				 * available pages for indirect grefs.
@@ -1501,7 +1509,7 @@ static bool blkif_completion(unsigned long *id,
 		}
 	}
 
-	return true;
+	return 1;
 }
 
 static irqreturn_t blkif_interrupt(int irq, void *dev_id)
@@ -1567,12 +1575,17 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 		}
 
 		if (bret.operation != BLKIF_OP_DISCARD) {
+			int ret;
+
 			/*
 			 * We may need to wait for an extra response if the
 			 * I/O request is split in 2
 			 */
-			if (!blkif_completion(&id, rinfo, &bret))
+			ret = blkif_completion(&id, rinfo, &bret);
+			if (!ret)
 				continue;
+			if (unlikely(ret < 0))
+				goto err;
 		}
 
 		if (add_id_to_freelist(rinfo, id)) {
@@ -1679,8 +1692,7 @@ static int setup_blkring(struct xenbus_device *dev,
 	for (i = 0; i < info->nr_ring_pages; i++)
 		rinfo->ring_ref[i] = GRANT_INVALID_REF;
 
-	sring = (struct blkif_sring *)__get_free_pages(GFP_NOIO | __GFP_HIGH,
-						       get_order(ring_size));
+	sring = alloc_pages_exact(ring_size, GFP_NOIO);
 	if (!sring) {
 		xenbus_dev_fatal(dev, -ENOMEM, "allocating shared ring");
 		return -ENOMEM;
@@ -1690,7 +1702,7 @@ static int setup_blkring(struct xenbus_device *dev,
 
 	err = xenbus_grant_ring(dev, rinfo->ring.sring, info->nr_ring_pages, gref);
 	if (err < 0) {
-		free_pages((unsigned long)sring, get_order(ring_size));
+		free_pages_exact(sring, ring_size);
 		rinfo->ring.sring = NULL;
 		goto fail;
 	}
@@ -2536,11 +2548,10 @@ static void purge_persistent_grants(struct blkfront_info *info)
 		list_for_each_entry_safe(gnt_list_entry, tmp, &rinfo->grants,
 					 node) {
 			if (gnt_list_entry->gref == GRANT_INVALID_REF ||
-			    gnttab_query_foreign_access(gnt_list_entry->gref))
+			    !gnttab_try_end_foreign_access(gnt_list_entry->gref))
 				continue;
 
 			list_del(&gnt_list_entry->node);
-			gnttab_end_foreign_access(gnt_list_entry->gref, 0, 0UL);
 			rinfo->persistent_gnts_c--;
 			gnt_list_entry->gref = GRANT_INVALID_REF;
 			list_add_tail(&gnt_list_entry->node, &rinfo->grants);
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 039ca902c5bf..d2d753960c4d 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -424,14 +424,12 @@ static bool xennet_tx_buf_gc(struct netfront_queue *queue)
 			queue->tx_link[id] = TX_LINK_NONE;
 			skb = queue->tx_skbs[id];
 			queue->tx_skbs[id] = NULL;
-			if (unlikely(gnttab_query_foreign_access(
-				queue->grant_tx_ref[id]) != 0)) {
+			if (unlikely(!gnttab_end_foreign_access_ref(
+				queue->grant_tx_ref[id], GNTMAP_readonly))) {
 				dev_alert(dev,
 					  "Grant still in use by backend domain\n");
 				goto err;
 			}
-			gnttab_end_foreign_access_ref(
-				queue->grant_tx_ref[id], GNTMAP_readonly);
 			gnttab_release_grant_reference(
 				&queue->gref_tx_head, queue->grant_tx_ref[id]);
 			queue->grant_tx_ref[id] = GRANT_INVALID_REF;
@@ -990,7 +988,6 @@ static int xennet_get_responses(struct netfront_queue *queue,
 	struct device *dev = &queue->info->netdev->dev;
 	struct bpf_prog *xdp_prog;
 	struct xdp_buff xdp;
-	unsigned long ret;
 	int slots = 1;
 	int err = 0;
 	u32 verdict;
@@ -1032,8 +1029,13 @@ static int xennet_get_responses(struct netfront_queue *queue,
 			goto next;
 		}
 
-		ret = gnttab_end_foreign_access_ref(ref, 0);
-		BUG_ON(!ret);
+		if (!gnttab_end_foreign_access_ref(ref, 0)) {
+			dev_alert(dev,
+				  "Grant still in use by backend domain\n");
+			queue->info->broken = true;
+			dev_alert(dev, "Disabled for further use\n");
+			return -EINVAL;
+		}
 
 		gnttab_release_grant_reference(&queue->gref_rx_head, ref);
 
@@ -1254,6 +1256,10 @@ static int xennet_poll(struct napi_struct *napi, int budget)
 					   &need_xdp_flush);
 
 		if (unlikely(err)) {
+			if (queue->info->broken) {
+				spin_unlock(&queue->rx_lock);
+				return 0;
+			}
 err:
 			while ((skb = __skb_dequeue(&tmpq)))
 				__skb_queue_tail(&errq, skb);
@@ -1918,7 +1924,7 @@ static int setup_netfront(struct xenbus_device *dev,
 			struct netfront_queue *queue, unsigned int feature_split_evtchn)
 {
 	struct xen_netif_tx_sring *txs;
-	struct xen_netif_rx_sring *rxs;
+	struct xen_netif_rx_sring *rxs = NULL;
 	grant_ref_t gref;
 	int err;
 
@@ -1938,21 +1944,21 @@ static int setup_netfront(struct xenbus_device *dev,
 
 	err = xenbus_grant_ring(dev, txs, 1, &gref);
 	if (err < 0)
-		goto grant_tx_ring_fail;
+		goto fail;
 	queue->tx_ring_ref = gref;
 
 	rxs = (struct xen_netif_rx_sring *)get_zeroed_page(GFP_NOIO | __GFP_HIGH);
 	if (!rxs) {
 		err = -ENOMEM;
 		xenbus_dev_fatal(dev, err, "allocating rx ring page");
-		goto alloc_rx_ring_fail;
+		goto fail;
 	}
 	SHARED_RING_INIT(rxs);
 	FRONT_RING_INIT(&queue->rx, rxs, XEN_PAGE_SIZE);
 
 	err = xenbus_grant_ring(dev, rxs, 1, &gref);
 	if (err < 0)
-		goto grant_rx_ring_fail;
+		goto fail;
 	queue->rx_ring_ref = gref;
 
 	if (feature_split_evtchn)
@@ -1965,22 +1971,28 @@ static int setup_netfront(struct xenbus_device *dev,
 		err = setup_netfront_single(queue);
 
 	if (err)
-		goto alloc_evtchn_fail;
+		goto fail;
 
 	return 0;
 
 	/* If we fail to setup netfront, it is safe to just revoke access to
 	 * granted pages because backend is not accessing it at this point.
 	 */
-alloc_evtchn_fail:
-	gnttab_end_foreign_access_ref(queue->rx_ring_ref, 0);
-grant_rx_ring_fail:
-	free_page((unsigned long)rxs);
-alloc_rx_ring_fail:
-	gnttab_end_foreign_access_ref(queue->tx_ring_ref, 0);
-grant_tx_ring_fail:
-	free_page((unsigned long)txs);
-fail:
+ fail:
+	if (queue->rx_ring_ref != GRANT_INVALID_REF) {
+		gnttab_end_foreign_access(queue->rx_ring_ref, 0,
+					  (unsigned long)rxs);
+		queue->rx_ring_ref = GRANT_INVALID_REF;
+	} else {
+		free_page((unsigned long)rxs);
+	}
+	if (queue->tx_ring_ref != GRANT_INVALID_REF) {
+		gnttab_end_foreign_access(queue->tx_ring_ref, 0,
+					  (unsigned long)txs);
+		queue->tx_ring_ref = GRANT_INVALID_REF;
+	} else {
+		free_page((unsigned long)txs);
+	}
 	return err;
 }
 
diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 12c10a5e3d93..7f421600cb66 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -233,12 +233,11 @@ static void scsifront_gnttab_done(struct vscsifrnt_info *info,
 		return;
 
 	for (i = 0; i < shadow->nr_grants; i++) {
-		if (unlikely(gnttab_query_foreign_access(shadow->gref[i]))) {
+		if (unlikely(!gnttab_try_end_foreign_access(shadow->gref[i]))) {
 			shost_printk(KERN_ALERT, info->host, KBUILD_MODNAME
 				     "grant still in use by backend\n");
 			BUG();
 		}
-		gnttab_end_foreign_access(shadow->gref[i], 0, 0UL);
 	}
 
 	kfree(shadow->sg);
diff --git a/drivers/xen/gntalloc.c b/drivers/xen/gntalloc.c
index 3fa40c723e8e..edb0acd0b832 100644
--- a/drivers/xen/gntalloc.c
+++ b/drivers/xen/gntalloc.c
@@ -169,20 +169,14 @@ static int add_grefs(struct ioctl_gntalloc_alloc_gref *op,
 		__del_gref(gref);
 	}
 
-	/* It's possible for the target domain to map the just-allocated grant
-	 * references by blindly guessing their IDs; if this is done, then
-	 * __del_gref will leave them in the queue_gref list. They need to be
-	 * added to the global list so that we can free them when they are no
-	 * longer referenced.
-	 */
-	if (unlikely(!list_empty(&queue_gref)))
-		list_splice_tail(&queue_gref, &gref_list);
 	mutex_unlock(&gref_mutex);
 	return rc;
 }
 
 static void __del_gref(struct gntalloc_gref *gref)
 {
+	unsigned long addr;
+
 	if (gref->notify.flags & UNMAP_NOTIFY_CLEAR_BYTE) {
 		uint8_t *tmp = kmap(gref->page);
 		tmp[gref->notify.pgoff] = 0;
@@ -196,21 +190,16 @@ static void __del_gref(struct gntalloc_gref *gref)
 	gref->notify.flags = 0;
 
 	if (gref->gref_id) {
-		if (gnttab_query_foreign_access(gref->gref_id))
-			return;
-
-		if (!gnttab_end_foreign_access_ref(gref->gref_id, 0))
-			return;
-
-		gnttab_free_grant_reference(gref->gref_id);
+		if (gref->page) {
+			addr = (unsigned long)page_to_virt(gref->page);
+			gnttab_end_foreign_access(gref->gref_id, 0, addr);
+		} else
+			gnttab_free_grant_reference(gref->gref_id);
 	}
 
 	gref_size--;
 	list_del(&gref->next_gref);
 
-	if (gref->page)
-		__free_page(gref->page);
-
 	kfree(gref);
 }
 
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 3729bea0c989..5c83d41766c8 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -134,12 +134,9 @@ struct gnttab_ops {
 	 */
 	unsigned long (*end_foreign_transfer_ref)(grant_ref_t ref);
 	/*
-	 * Query the status of a grant entry. Ref parameter is reference of
-	 * queried grant entry, return value is the status of queried entry.
-	 * Detailed status(writing/reading) can be gotten from the return value
-	 * by bit operations.
+	 * Read the frame number related to a given grant reference.
 	 */
-	int (*query_foreign_access)(grant_ref_t ref);
+	unsigned long (*read_frame)(grant_ref_t ref);
 };
 
 struct unmap_refs_callback_data {
@@ -284,22 +281,6 @@ int gnttab_grant_foreign_access(domid_t domid, unsigned long frame,
 }
 EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access);
 
-static int gnttab_query_foreign_access_v1(grant_ref_t ref)
-{
-	return gnttab_shared.v1[ref].flags & (GTF_reading|GTF_writing);
-}
-
-static int gnttab_query_foreign_access_v2(grant_ref_t ref)
-{
-	return grstatus[ref] & (GTF_reading|GTF_writing);
-}
-
-int gnttab_query_foreign_access(grant_ref_t ref)
-{
-	return gnttab_interface->query_foreign_access(ref);
-}
-EXPORT_SYMBOL_GPL(gnttab_query_foreign_access);
-
 static int gnttab_end_foreign_access_ref_v1(grant_ref_t ref, int readonly)
 {
 	u16 flags, nflags;
@@ -353,6 +334,16 @@ int gnttab_end_foreign_access_ref(grant_ref_t ref, int readonly)
 }
 EXPORT_SYMBOL_GPL(gnttab_end_foreign_access_ref);
 
+static unsigned long gnttab_read_frame_v1(grant_ref_t ref)
+{
+	return gnttab_shared.v1[ref].frame;
+}
+
+static unsigned long gnttab_read_frame_v2(grant_ref_t ref)
+{
+	return gnttab_shared.v2[ref].full_page.frame;
+}
+
 struct deferred_entry {
 	struct list_head list;
 	grant_ref_t ref;
@@ -382,12 +373,9 @@ static void gnttab_handle_deferred(struct timer_list *unused)
 		spin_unlock_irqrestore(&gnttab_list_lock, flags);
 		if (_gnttab_end_foreign_access_ref(entry->ref, entry->ro)) {
 			put_free_entry(entry->ref);
-			if (entry->page) {
-				pr_debug("freeing g.e. %#x (pfn %#lx)\n",
-					 entry->ref, page_to_pfn(entry->page));
-				put_page(entry->page);
-			} else
-				pr_info("freeing g.e. %#x\n", entry->ref);
+			pr_debug("freeing g.e. %#x (pfn %#lx)\n",
+				 entry->ref, page_to_pfn(entry->page));
+			put_page(entry->page);
 			kfree(entry);
 			entry = NULL;
 		} else {
@@ -412,9 +400,18 @@ static void gnttab_handle_deferred(struct timer_list *unused)
 static void gnttab_add_deferred(grant_ref_t ref, bool readonly,
 				struct page *page)
 {
-	struct deferred_entry *entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
+	struct deferred_entry *entry;
+	gfp_t gfp = (in_atomic() || irqs_disabled()) ? GFP_ATOMIC : GFP_KERNEL;
 	const char *what = KERN_WARNING "leaking";
 
+	entry = kmalloc(sizeof(*entry), gfp);
+	if (!page) {
+		unsigned long gfn = gnttab_interface->read_frame(ref);
+
+		page = pfn_to_page(gfn_to_pfn(gfn));
+		get_page(page);
+	}
+
 	if (entry) {
 		unsigned long flags;
 
@@ -435,11 +432,21 @@ static void gnttab_add_deferred(grant_ref_t ref, bool readonly,
 	       what, ref, page ? page_to_pfn(page) : -1);
 }
 
+int gnttab_try_end_foreign_access(grant_ref_t ref)
+{
+	int ret = _gnttab_end_foreign_access_ref(ref, 0);
+
+	if (ret)
+		put_free_entry(ref);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(gnttab_try_end_foreign_access);
+
 void gnttab_end_foreign_access(grant_ref_t ref, int readonly,
 			       unsigned long page)
 {
-	if (gnttab_end_foreign_access_ref(ref, readonly)) {
-		put_free_entry(ref);
+	if (gnttab_try_end_foreign_access(ref)) {
 		if (page != 0)
 			put_page(virt_to_page(page));
 	} else
@@ -1417,7 +1424,7 @@ static const struct gnttab_ops gnttab_v1_ops = {
 	.update_entry			= gnttab_update_entry_v1,
 	.end_foreign_access_ref		= gnttab_end_foreign_access_ref_v1,
 	.end_foreign_transfer_ref	= gnttab_end_foreign_transfer_ref_v1,
-	.query_foreign_access		= gnttab_query_foreign_access_v1,
+	.read_frame			= gnttab_read_frame_v1,
 };
 
 static const struct gnttab_ops gnttab_v2_ops = {
@@ -1429,7 +1436,7 @@ static const struct gnttab_ops gnttab_v2_ops = {
 	.update_entry			= gnttab_update_entry_v2,
 	.end_foreign_access_ref		= gnttab_end_foreign_access_ref_v2,
 	.end_foreign_transfer_ref	= gnttab_end_foreign_transfer_ref_v2,
-	.query_foreign_access		= gnttab_query_foreign_access_v2,
+	.read_frame			= gnttab_read_frame_v2,
 };
 
 static bool gnttab_need_v2(void)
diff --git a/drivers/xen/pvcalls-front.c b/drivers/xen/pvcalls-front.c
index 3c9ae156b597..0ca351f30a6d 100644
--- a/drivers/xen/pvcalls-front.c
+++ b/drivers/xen/pvcalls-front.c
@@ -337,8 +337,8 @@ static void free_active_ring(struct sock_mapping *map)
 	if (!map->active.ring)
 		return;
 
-	free_pages((unsigned long)map->active.data.in,
-			map->active.ring->ring_order);
+	free_pages_exact(map->active.data.in,
+			 PAGE_SIZE << map->active.ring->ring_order);
 	free_page((unsigned long)map->active.ring);
 }
 
@@ -352,8 +352,8 @@ static int alloc_active_ring(struct sock_mapping *map)
 		goto out;
 
 	map->active.ring->ring_order = PVCALLS_RING_ORDER;
-	bytes = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
-					PVCALLS_RING_ORDER);
+	bytes = alloc_pages_exact(PAGE_SIZE << PVCALLS_RING_ORDER,
+				  GFP_KERNEL | __GFP_ZERO);
 	if (!bytes)
 		goto out;
 
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index e8bed1cb76ba..df6890681231 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -379,7 +379,14 @@ int xenbus_grant_ring(struct xenbus_device *dev, void *vaddr,
 		      unsigned int nr_pages, grant_ref_t *grefs)
 {
 	int err;
-	int i, j;
+	unsigned int i;
+	grant_ref_t gref_head;
+
+	err = gnttab_alloc_grant_references(nr_pages, &gref_head);
+	if (err) {
+		xenbus_dev_fatal(dev, err, "granting access to ring page");
+		return err;
+	}
 
 	for (i = 0; i < nr_pages; i++) {
 		unsigned long gfn;
@@ -389,23 +396,14 @@ int xenbus_grant_ring(struct xenbus_device *dev, void *vaddr,
 		else
 			gfn = virt_to_gfn(vaddr);
 
-		err = gnttab_grant_foreign_access(dev->otherend_id, gfn, 0);
-		if (err < 0) {
-			xenbus_dev_fatal(dev, err,
-					 "granting access to ring page");
-			goto fail;
-		}
-		grefs[i] = err;
+		grefs[i] = gnttab_claim_grant_reference(&gref_head);
+		gnttab_grant_foreign_access_ref(grefs[i], dev->otherend_id,
+						gfn, 0);
 
 		vaddr = vaddr + XEN_PAGE_SIZE;
 	}
 
 	return 0;
-
-fail:
-	for (j = 0; j < i; j++)
-		gnttab_end_foreign_access_ref(grefs[j], 0);
-	return err;
 }
 EXPORT_SYMBOL_GPL(xenbus_grant_ring);
 
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 63ccb5252190..220c8c60e021 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -92,6 +92,11 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 0x7fff)
 
+#define ARM_SMCCC_ARCH_WORKAROUND_3					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x3fff)
+
 #define ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID				\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
 			   ARM_SMCCC_SMC_32,				\
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7078938ba235..28e5f31c287d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1774,6 +1774,12 @@ bool bpf_prog_has_kfunc_call(const struct bpf_prog *prog);
 const struct btf_func_model *
 bpf_jit_find_kfunc_model(const struct bpf_prog *prog,
 			 const struct bpf_insn *insn);
+
+static inline bool unprivileged_ebpf_enabled(void)
+{
+	return !sysctl_unprivileged_bpf_disabled;
+}
+
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
 {
@@ -1993,6 +1999,12 @@ bpf_jit_find_kfunc_model(const struct bpf_prog *prog,
 {
 	return NULL;
 }
+
+static inline bool unprivileged_ebpf_enabled(void)
+{
+	return false;
+}
+
 #endif /* CONFIG_BPF_SYSCALL */
 
 void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index cb854df031ce..c9fea9389ebe 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -104,17 +104,32 @@ int gnttab_end_foreign_access_ref(grant_ref_t ref, int readonly);
  * access has been ended, free the given page too.  Access will be ended
  * immediately iff the grant entry is not in use, otherwise it will happen
  * some time later.  page may be 0, in which case no freeing will occur.
+ * Note that the granted page might still be accessed (read or write) by the
+ * other side after gnttab_end_foreign_access() returns, so even if page was
+ * specified as 0 it is not allowed to just reuse the page for other
+ * purposes immediately. gnttab_end_foreign_access() will take an additional
+ * reference to the granted page in this case, which is dropped only after
+ * the grant is no longer in use.
+ * This requires that multi page allocations for areas subject to
+ * gnttab_end_foreign_access() are done via alloc_pages_exact() (and freeing
+ * via free_pages_exact()) in order to avoid high order pages.
  */
 void gnttab_end_foreign_access(grant_ref_t ref, int readonly,
 			       unsigned long page);
 
+/*
+ * End access through the given grant reference, iff the grant entry is
+ * no longer in use.  In case of success ending foreign access, the
+ * grant reference is deallocated.
+ * Return 1 if the grant entry was freed, 0 if it is still in use.
+ */
+int gnttab_try_end_foreign_access(grant_ref_t ref);
+
 int gnttab_grant_foreign_transfer(domid_t domid, unsigned long pfn);
 
 unsigned long gnttab_end_foreign_transfer_ref(grant_ref_t ref);
 unsigned long gnttab_end_foreign_transfer(grant_ref_t ref);
 
-int gnttab_query_foreign_access(grant_ref_t ref);
-
 /*
  * operations on reserved batches of grant references
  */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 083be6af29d7..0586047f7323 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -228,6 +228,10 @@ static int bpf_stats_handler(struct ctl_table *table, int write,
 	return ret;
 }
 
+void __weak unpriv_ebpf_notify(int new_state)
+{
+}
+
 static int bpf_unpriv_handler(struct ctl_table *table, int write,
 			      void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -245,6 +249,9 @@ static int bpf_unpriv_handler(struct ctl_table *table, int write,
 			return -EPERM;
 		*(int *)table->data = unpriv_enable;
 	}
+
+	unpriv_ebpf_notify(unpriv_enable);
+
 	return ret;
 }
 #endif /* CONFIG_BPF_SYSCALL && CONFIG_SYSCTL */
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 2418fa0b58f3..cf2685ae5ffe 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -281,9 +281,9 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 				ref = priv->rings[i].intf->ref[j];
 				gnttab_end_foreign_access(ref, 0, 0);
 			}
-			free_pages((unsigned long)priv->rings[i].data.in,
-				   priv->rings[i].intf->ring_order -
-				   (PAGE_SHIFT - XEN_PAGE_SHIFT));
+			free_pages_exact(priv->rings[i].data.in,
+				   1UL << (priv->rings[i].intf->ring_order +
+					   XEN_PAGE_SHIFT));
 		}
 		gnttab_end_foreign_access(priv->rings[i].ref, 0, 0);
 		free_page((unsigned long)priv->rings[i].intf);
@@ -322,8 +322,8 @@ static int xen_9pfs_front_alloc_dataring(struct xenbus_device *dev,
 	if (ret < 0)
 		goto out;
 	ring->ref = ret;
-	bytes = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
-			order - (PAGE_SHIFT - XEN_PAGE_SHIFT));
+	bytes = alloc_pages_exact(1UL << (order + XEN_PAGE_SHIFT),
+				  GFP_KERNEL | __GFP_ZERO);
 	if (!bytes) {
 		ret = -ENOMEM;
 		goto out;
@@ -354,9 +354,7 @@ static int xen_9pfs_front_alloc_dataring(struct xenbus_device *dev,
 	if (bytes) {
 		for (i--; i >= 0; i--)
 			gnttab_end_foreign_access(ring->intf->ref[i], 0, 0);
-		free_pages((unsigned long)bytes,
-			   ring->intf->ring_order -
-			   (PAGE_SHIFT - XEN_PAGE_SHIFT));
+		free_pages_exact(bytes, 1UL << (order + XEN_PAGE_SHIFT));
 	}
 	gnttab_end_foreign_access(ring->ref, 0, 0);
 	free_page((unsigned long)ring->intf);
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index d5b5f2ab87a0..9f2b79a8e3ee 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -204,7 +204,7 @@
 /* FREE!                                ( 7*32+10) */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
 #define X86_FEATURE_RETPOLINE		( 7*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
-#define X86_FEATURE_RETPOLINE_AMD	( 7*32+13) /* "" AMD Retpoline mitigation for Spectre variant 2 */
+#define X86_FEATURE_RETPOLINE_LFENCE	( 7*32+13) /* "" Use LFENCEs for Spectre variant 2 */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_CDP_L2		( 7*32+15) /* Code and Data Prioritization L2 */
 #define X86_FEATURE_MSR_SPEC_CTRL	( 7*32+16) /* "" MSR SPEC_CTRL is implemented */
