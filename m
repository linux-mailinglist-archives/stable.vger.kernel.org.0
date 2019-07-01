Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2B31F376
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbfEOLDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:03:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbfEOLDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:03:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BED9120644;
        Wed, 15 May 2019 11:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918179;
        bh=WEhUO2KJMVp8EOnqdIMbhxKaH51CMgAWVDSrjBl+J6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZ75QFmOAElL2oUNOWLmBDZf4QuqA+nSpa0Q7aOw7/zHXnxcgcxHZxAnjrim++z54
         dYFLq44RCymP15V/f3PEEzxurj4Op9wEa0u8ox3+1/LBOuBDrE9m0jBlmb4Y1pFc5f
         0e/wUK6IIFtaNYESXH54YwxGR78Hvnl4ZdYeXcZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Michael Neuling <mikey@neuling.org>,
        =?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 036/266] powerpc/64s: Add support for a store forwarding barrier at kernel entry/exit
Date:   Wed, 15 May 2019 12:52:23 +0200
Message-Id: <20190515090723.736193624@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit a048a07d7f4535baa4cbad6bc024f175317ab938 upstream.

On some CPUs we can prevent a vulnerability related to store-to-load
forwarding by preventing store forwarding between privilege domains,
by inserting a barrier in kernel entry and exit paths.

This is known to be the case on at least Power7, Power8 and Power9
powerpc CPUs.

Barriers must be inserted generally before the first load after moving
to a higher privilege, and after the last store before moving to a
lower privilege, HV and PR privilege transitions must be protected.

Barriers are added as patch sections, with all kernel/hypervisor entry
points patched, and the exit points to lower privilge levels patched
similarly to the RFI flush patching.

Firmware advertisement is not implemented yet, so CPU flush types
are hard coded.

Thanks to Michal Suchánek for bug fixes and review.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Michal Suchánek <msuchanek@suse.de>
[mpe: 4.4 doesn't have EXC_REAL_OOL_MASKABLE, so do it manually]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/exception-64s.h     |   35 ++++++
 arch/powerpc/include/asm/feature-fixups.h    |   19 +++
 arch/powerpc/include/asm/security_features.h |   11 ++
 arch/powerpc/kernel/exceptions-64s.S         |   22 +++-
 arch/powerpc/kernel/security.c               |  148 +++++++++++++++++++++++++++
 arch/powerpc/kernel/vmlinux.lds.S            |   14 ++
 arch/powerpc/lib/feature-fixups.c            |  116 ++++++++++++++++++++-
 arch/powerpc/platforms/powernv/setup.c       |    1 
 arch/powerpc/platforms/pseries/setup.c       |    1 
 9 files changed, 365 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -50,6 +50,27 @@
 #define EX_PPR		88	/* SMT thread status register (priority) */
 #define EX_CTR		96
 
+#define STF_ENTRY_BARRIER_SLOT						\
+	STF_ENTRY_BARRIER_FIXUP_SECTION;				\
+	nop;								\
+	nop;								\
+	nop
+
+#define STF_EXIT_BARRIER_SLOT						\
+	STF_EXIT_BARRIER_FIXUP_SECTION;					\
+	nop;								\
+	nop;								\
+	nop;								\
+	nop;								\
+	nop;								\
+	nop
+
+/*
+ * r10 must be free to use, r13 must be paca
+ */
+#define INTERRUPT_TO_KERNEL						\
+	STF_ENTRY_BARRIER_SLOT
+
 /*
  * Macros for annotating the expected destination of (h)rfid
  *
@@ -66,16 +87,19 @@
 	rfid
 
 #define RFI_TO_USER							\
+	STF_EXIT_BARRIER_SLOT;						\
 	RFI_FLUSH_SLOT;							\
 	rfid;								\
 	b	rfi_flush_fallback
 
 #define RFI_TO_USER_OR_KERNEL						\
+	STF_EXIT_BARRIER_SLOT;						\
 	RFI_FLUSH_SLOT;							\
 	rfid;								\
 	b	rfi_flush_fallback
 
 #define RFI_TO_GUEST							\
+	STF_EXIT_BARRIER_SLOT;						\
 	RFI_FLUSH_SLOT;							\
 	rfid;								\
 	b	rfi_flush_fallback
@@ -84,21 +108,25 @@
 	hrfid
 
 #define HRFI_TO_USER							\
+	STF_EXIT_BARRIER_SLOT;						\
 	RFI_FLUSH_SLOT;							\
 	hrfid;								\
 	b	hrfi_flush_fallback
 
 #define HRFI_TO_USER_OR_KERNEL						\
+	STF_EXIT_BARRIER_SLOT;						\
 	RFI_FLUSH_SLOT;							\
 	hrfid;								\
 	b	hrfi_flush_fallback
 
 #define HRFI_TO_GUEST							\
+	STF_EXIT_BARRIER_SLOT;						\
 	RFI_FLUSH_SLOT;							\
 	hrfid;								\
 	b	hrfi_flush_fallback
 
 #define HRFI_TO_UNKNOWN							\
+	STF_EXIT_BARRIER_SLOT;						\
 	RFI_FLUSH_SLOT;							\
 	hrfid;								\
 	b	hrfi_flush_fallback
@@ -226,6 +254,7 @@ END_FTR_SECTION_NESTED(ftr,ftr,943)
 #define __EXCEPTION_PROLOG_1(area, extra, vec)				\
 	OPT_SAVE_REG_TO_PACA(area+EX_PPR, r9, CPU_FTR_HAS_PPR);		\
 	OPT_SAVE_REG_TO_PACA(area+EX_CFAR, r10, CPU_FTR_CFAR);		\
+	INTERRUPT_TO_KERNEL;						\
 	SAVE_CTR(r10, area);						\
 	mfcr	r9;							\
 	extra(vec);							\
@@ -512,6 +541,12 @@ label##_relon_hv:						\
 #define _MASKABLE_EXCEPTION_PSERIES(vec, label, h, extra)		\
 	__MASKABLE_EXCEPTION_PSERIES(vec, label, h, extra)
 
+#define MASKABLE_EXCEPTION_OOL(vec, label)				\
+	.globl label##_ool;						\
+label##_ool:								\
+	EXCEPTION_PROLOG_1(PACA_EXGEN, SOFTEN_TEST_PR, vec);		\
+	EXCEPTION_PROLOG_PSERIES_1(label##_common, EXC_STD);
+
 #define MASKABLE_EXCEPTION_PSERIES(loc, vec, label)			\
 	. = loc;							\
 	.globl label##_pSeries;						\
--- a/arch/powerpc/include/asm/feature-fixups.h
+++ b/arch/powerpc/include/asm/feature-fixups.h
@@ -184,6 +184,22 @@ label##3:					       	\
 	FTR_ENTRY_OFFSET label##1b-label##3b;		\
 	.popsection;
 
+#define STF_ENTRY_BARRIER_FIXUP_SECTION			\
+953:							\
+	.pushsection __stf_entry_barrier_fixup,"a";	\
+	.align 2;					\
+954:							\
+	FTR_ENTRY_OFFSET 953b-954b;			\
+	.popsection;
+
+#define STF_EXIT_BARRIER_FIXUP_SECTION			\
+955:							\
+	.pushsection __stf_exit_barrier_fixup,"a";	\
+	.align 2;					\
+956:							\
+	FTR_ENTRY_OFFSET 955b-956b;			\
+	.popsection;
+
 #define RFI_FLUSH_FIXUP_SECTION				\
 951:							\
 	.pushsection __rfi_flush_fixup,"a";		\
@@ -195,6 +211,9 @@ label##3:					       	\
 
 #ifndef __ASSEMBLY__
 
+extern long stf_barrier_fallback;
+extern long __start___stf_entry_barrier_fixup, __stop___stf_entry_barrier_fixup;
+extern long __start___stf_exit_barrier_fixup, __stop___stf_exit_barrier_fixup;
 extern long __start___rfi_flush_fixup, __stop___rfi_flush_fixup;
 
 #endif
--- a/arch/powerpc/include/asm/security_features.h
+++ b/arch/powerpc/include/asm/security_features.h
@@ -12,6 +12,17 @@
 extern unsigned long powerpc_security_features;
 extern bool rfi_flush;
 
+/* These are bit flags */
+enum stf_barrier_type {
+	STF_BARRIER_NONE	= 0x1,
+	STF_BARRIER_FALLBACK	= 0x2,
+	STF_BARRIER_EIEIO	= 0x4,
+	STF_BARRIER_SYNC_ORI	= 0x8,
+};
+
+void setup_stf_barrier(void);
+void do_stf_barrier_fixups(enum stf_barrier_type types);
+
 static inline void security_ftr_set(unsigned long feature)
 {
 	powerpc_security_features |= feature;
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -36,6 +36,7 @@ BEGIN_FTR_SECTION						\
 END_FTR_SECTION_IFSET(CPU_FTR_REAL_LE)				\
 	mr	r9,r13 ;					\
 	GET_PACA(r13) ;						\
+	INTERRUPT_TO_KERNEL ;					\
 	mfspr	r11,SPRN_SRR0 ;					\
 0:
 
@@ -292,7 +293,9 @@ hardware_interrupt_hv:
 	. = 0x900
 	.globl decrementer_pSeries
 decrementer_pSeries:
-	_MASKABLE_EXCEPTION_PSERIES(0x900, decrementer, EXC_STD, SOFTEN_TEST_PR)
+	SET_SCRATCH0(r13)
+	EXCEPTION_PROLOG_0(PACA_EXGEN)
+	b	decrementer_ool
 
 	STD_EXCEPTION_HV(0x980, 0x982, hdecrementer)
 
@@ -319,6 +322,7 @@ system_call_pSeries:
 	OPT_GET_SPR(r9, SPRN_PPR, CPU_FTR_HAS_PPR);
 	HMT_MEDIUM;
 	std	r10,PACA_EXGEN+EX_R10(r13)
+	INTERRUPT_TO_KERNEL
 	OPT_SAVE_REG_TO_PACA(PACA_EXGEN+EX_PPR, r9, CPU_FTR_HAS_PPR);
 	mfcr	r9
 	KVMTEST(0xc00)
@@ -607,6 +611,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
 
 	.align	7
 	/* moved from 0xe00 */
+	MASKABLE_EXCEPTION_OOL(0x900, decrementer)
 	STD_EXCEPTION_HV_OOL(0xe02, h_data_storage)
 	KVM_HANDLER_SKIP(PACA_EXGEN, EXC_HV, 0xe02)
 	STD_EXCEPTION_HV_OOL(0xe22, h_instr_storage)
@@ -1564,6 +1569,21 @@ power4_fixup_nap:
 	blr
 #endif
 
+	.balign 16
+	.globl stf_barrier_fallback
+stf_barrier_fallback:
+	std	r9,PACA_EXRFI+EX_R9(r13)
+	std	r10,PACA_EXRFI+EX_R10(r13)
+	sync
+	ld	r9,PACA_EXRFI+EX_R9(r13)
+	ld	r10,PACA_EXRFI+EX_R10(r13)
+	ori	31,31,0
+	.rept 14
+	b	1f
+1:
+	.endr
+	blr
+
 	.globl rfi_flush_fallback
 rfi_flush_fallback:
 	SET_SCRATCH0(r13);
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -5,9 +5,11 @@
 // Copyright 2018, Michael Ellerman, IBM Corporation.
 
 #include <linux/kernel.h>
+#include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/seq_buf.h>
 
+#include <asm/debug.h>
 #include <asm/security_features.h>
 
 
@@ -86,3 +88,149 @@ ssize_t cpu_show_spectre_v2(struct devic
 
 	return s.len;
 }
+
+/*
+ * Store-forwarding barrier support.
+ */
+
+static enum stf_barrier_type stf_enabled_flush_types;
+static bool no_stf_barrier;
+bool stf_barrier;
+
+static int __init handle_no_stf_barrier(char *p)
+{
+	pr_info("stf-barrier: disabled on command line.");
+	no_stf_barrier = true;
+	return 0;
+}
+
+early_param("no_stf_barrier", handle_no_stf_barrier);
+
+/* This is the generic flag used by other architectures */
+static int __init handle_ssbd(char *p)
+{
+	if (!p || strncmp(p, "auto", 5) == 0 || strncmp(p, "on", 2) == 0 ) {
+		/* Until firmware tells us, we have the barrier with auto */
+		return 0;
+	} else if (strncmp(p, "off", 3) == 0) {
+		handle_no_stf_barrier(NULL);
+		return 0;
+	} else
+		return 1;
+
+	return 0;
+}
+early_param("spec_store_bypass_disable", handle_ssbd);
+
+/* This is the generic flag used by other architectures */
+static int __init handle_no_ssbd(char *p)
+{
+	handle_no_stf_barrier(NULL);
+	return 0;
+}
+early_param("nospec_store_bypass_disable", handle_no_ssbd);
+
+static void stf_barrier_enable(bool enable)
+{
+	if (enable)
+		do_stf_barrier_fixups(stf_enabled_flush_types);
+	else
+		do_stf_barrier_fixups(STF_BARRIER_NONE);
+
+	stf_barrier = enable;
+}
+
+void setup_stf_barrier(void)
+{
+	enum stf_barrier_type type;
+	bool enable, hv;
+
+	hv = cpu_has_feature(CPU_FTR_HVMODE);
+
+	/* Default to fallback in case fw-features are not available */
+	if (cpu_has_feature(CPU_FTR_ARCH_207S))
+		type = STF_BARRIER_SYNC_ORI;
+	else if (cpu_has_feature(CPU_FTR_ARCH_206))
+		type = STF_BARRIER_FALLBACK;
+	else
+		type = STF_BARRIER_NONE;
+
+	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&
+		(security_ftr_enabled(SEC_FTR_L1D_FLUSH_PR) ||
+		 (security_ftr_enabled(SEC_FTR_L1D_FLUSH_HV) && hv));
+
+	if (type == STF_BARRIER_FALLBACK) {
+		pr_info("stf-barrier: fallback barrier available\n");
+	} else if (type == STF_BARRIER_SYNC_ORI) {
+		pr_info("stf-barrier: hwsync barrier available\n");
+	} else if (type == STF_BARRIER_EIEIO) {
+		pr_info("stf-barrier: eieio barrier available\n");
+	}
+
+	stf_enabled_flush_types = type;
+
+	if (!no_stf_barrier)
+		stf_barrier_enable(enable);
+}
+
+ssize_t cpu_show_spec_store_bypass(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	if (stf_barrier && stf_enabled_flush_types != STF_BARRIER_NONE) {
+		const char *type;
+		switch (stf_enabled_flush_types) {
+		case STF_BARRIER_EIEIO:
+			type = "eieio";
+			break;
+		case STF_BARRIER_SYNC_ORI:
+			type = "hwsync";
+			break;
+		case STF_BARRIER_FALLBACK:
+			type = "fallback";
+			break;
+		default:
+			type = "unknown";
+		}
+		return sprintf(buf, "Mitigation: Kernel entry/exit barrier (%s)\n", type);
+	}
+
+	if (!security_ftr_enabled(SEC_FTR_L1D_FLUSH_HV) &&
+	    !security_ftr_enabled(SEC_FTR_L1D_FLUSH_PR))
+		return sprintf(buf, "Not affected\n");
+
+	return sprintf(buf, "Vulnerable\n");
+}
+
+#ifdef CONFIG_DEBUG_FS
+static int stf_barrier_set(void *data, u64 val)
+{
+	bool enable;
+
+	if (val == 1)
+		enable = true;
+	else if (val == 0)
+		enable = false;
+	else
+		return -EINVAL;
+
+	/* Only do anything if we're changing state */
+	if (enable != stf_barrier)
+		stf_barrier_enable(enable);
+
+	return 0;
+}
+
+static int stf_barrier_get(void *data, u64 *val)
+{
+	*val = stf_barrier ? 1 : 0;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_stf_barrier, stf_barrier_get, stf_barrier_set, "%llu\n");
+
+static __init int stf_barrier_debugfs_init(void)
+{
+	debugfs_create_file("stf_barrier", 0600, powerpc_debugfs_root, NULL, &fops_stf_barrier);
+	return 0;
+}
+device_initcall(stf_barrier_debugfs_init);
+#endif /* CONFIG_DEBUG_FS */
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -74,6 +74,20 @@ SECTIONS
 
 #ifdef CONFIG_PPC64
 	. = ALIGN(8);
+	__stf_entry_barrier_fixup : AT(ADDR(__stf_entry_barrier_fixup) - LOAD_OFFSET) {
+		__start___stf_entry_barrier_fixup = .;
+		*(__stf_entry_barrier_fixup)
+		__stop___stf_entry_barrier_fixup = .;
+	}
+
+	. = ALIGN(8);
+	__stf_exit_barrier_fixup : AT(ADDR(__stf_exit_barrier_fixup) - LOAD_OFFSET) {
+		__start___stf_exit_barrier_fixup = .;
+		*(__stf_exit_barrier_fixup)
+		__stop___stf_exit_barrier_fixup = .;
+	}
+
+	. = ALIGN(8);
 	__rfi_flush_fixup : AT(ADDR(__rfi_flush_fixup) - LOAD_OFFSET) {
 		__start___rfi_flush_fixup = .;
 		*(__rfi_flush_fixup)
--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -21,7 +21,7 @@
 #include <asm/page.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
-
+#include <asm/security_features.h>
 
 struct fixup_entry {
 	unsigned long	mask;
@@ -115,6 +115,120 @@ void do_feature_fixups(unsigned long val
 }
 
 #ifdef CONFIG_PPC_BOOK3S_64
+void do_stf_entry_barrier_fixups(enum stf_barrier_type types)
+{
+	unsigned int instrs[3], *dest;
+	long *start, *end;
+	int i;
+
+	start = PTRRELOC(&__start___stf_entry_barrier_fixup),
+	end = PTRRELOC(&__stop___stf_entry_barrier_fixup);
+
+	instrs[0] = 0x60000000; /* nop */
+	instrs[1] = 0x60000000; /* nop */
+	instrs[2] = 0x60000000; /* nop */
+
+	i = 0;
+	if (types & STF_BARRIER_FALLBACK) {
+		instrs[i++] = 0x7d4802a6; /* mflr r10		*/
+		instrs[i++] = 0x60000000; /* branch patched below */
+		instrs[i++] = 0x7d4803a6; /* mtlr r10		*/
+	} else if (types & STF_BARRIER_EIEIO) {
+		instrs[i++] = 0x7e0006ac; /* eieio + bit 6 hint */
+	} else if (types & STF_BARRIER_SYNC_ORI) {
+		instrs[i++] = 0x7c0004ac; /* hwsync		*/
+		instrs[i++] = 0xe94d0000; /* ld r10,0(r13)	*/
+		instrs[i++] = 0x63ff0000; /* ori 31,31,0 speculation barrier */
+	}
+
+	for (i = 0; start < end; start++, i++) {
+		dest = (void *)start + *start;
+
+		pr_devel("patching dest %lx\n", (unsigned long)dest);
+
+		patch_instruction(dest, instrs[0]);
+
+		if (types & STF_BARRIER_FALLBACK)
+			patch_branch(dest + 1, (unsigned long)&stf_barrier_fallback,
+				     BRANCH_SET_LINK);
+		else
+			patch_instruction(dest + 1, instrs[1]);
+
+		patch_instruction(dest + 2, instrs[2]);
+	}
+
+	printk(KERN_DEBUG "stf-barrier: patched %d entry locations (%s barrier)\n", i,
+		(types == STF_BARRIER_NONE)                  ? "no" :
+		(types == STF_BARRIER_FALLBACK)              ? "fallback" :
+		(types == STF_BARRIER_EIEIO)                 ? "eieio" :
+		(types == (STF_BARRIER_SYNC_ORI))            ? "hwsync"
+		                                           : "unknown");
+}
+
+void do_stf_exit_barrier_fixups(enum stf_barrier_type types)
+{
+	unsigned int instrs[6], *dest;
+	long *start, *end;
+	int i;
+
+	start = PTRRELOC(&__start___stf_exit_barrier_fixup),
+	end = PTRRELOC(&__stop___stf_exit_barrier_fixup);
+
+	instrs[0] = 0x60000000; /* nop */
+	instrs[1] = 0x60000000; /* nop */
+	instrs[2] = 0x60000000; /* nop */
+	instrs[3] = 0x60000000; /* nop */
+	instrs[4] = 0x60000000; /* nop */
+	instrs[5] = 0x60000000; /* nop */
+
+	i = 0;
+	if (types & STF_BARRIER_FALLBACK || types & STF_BARRIER_SYNC_ORI) {
+		if (cpu_has_feature(CPU_FTR_HVMODE)) {
+			instrs[i++] = 0x7db14ba6; /* mtspr 0x131, r13 (HSPRG1) */
+			instrs[i++] = 0x7db04aa6; /* mfspr r13, 0x130 (HSPRG0) */
+		} else {
+			instrs[i++] = 0x7db243a6; /* mtsprg 2,r13	*/
+			instrs[i++] = 0x7db142a6; /* mfsprg r13,1    */
+	        }
+		instrs[i++] = 0x7c0004ac; /* hwsync		*/
+		instrs[i++] = 0xe9ad0000; /* ld r13,0(r13)	*/
+		instrs[i++] = 0x63ff0000; /* ori 31,31,0 speculation barrier */
+		if (cpu_has_feature(CPU_FTR_HVMODE)) {
+			instrs[i++] = 0x7db14aa6; /* mfspr r13, 0x131 (HSPRG1) */
+		} else {
+			instrs[i++] = 0x7db242a6; /* mfsprg r13,2 */
+		}
+	} else if (types & STF_BARRIER_EIEIO) {
+		instrs[i++] = 0x7e0006ac; /* eieio + bit 6 hint */
+	}
+
+	for (i = 0; start < end; start++, i++) {
+		dest = (void *)start + *start;
+
+		pr_devel("patching dest %lx\n", (unsigned long)dest);
+
+		patch_instruction(dest, instrs[0]);
+		patch_instruction(dest + 1, instrs[1]);
+		patch_instruction(dest + 2, instrs[2]);
+		patch_instruction(dest + 3, instrs[3]);
+		patch_instruction(dest + 4, instrs[4]);
+		patch_instruction(dest + 5, instrs[5]);
+	}
+	printk(KERN_DEBUG "stf-barrier: patched %d exit locations (%s barrier)\n", i,
+		(types == STF_BARRIER_NONE)                  ? "no" :
+		(types == STF_BARRIER_FALLBACK)              ? "fallback" :
+		(types == STF_BARRIER_EIEIO)                 ? "eieio" :
+		(types == (STF_BARRIER_SYNC_ORI))            ? "hwsync"
+		                                           : "unknown");
+}
+
+
+void do_stf_barrier_fixups(enum stf_barrier_type types)
+{
+	do_stf_entry_barrier_fixups(types);
+	do_stf_exit_barrier_fixups(types);
+}
+
 void do_rfi_flush_fixups(enum l1d_flush_type types)
 {
 	unsigned int instrs[3], *dest;
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -130,6 +130,7 @@ static void __init pnv_setup_arch(void)
 	set_arch_panic_timeout(10, ARCH_PANIC_TIMEOUT);
 
 	pnv_setup_rfi_flush();
+	setup_stf_barrier();
 
 	/* Initialize SMP */
 	pnv_smp_init();
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -593,6 +593,7 @@ static void __init pSeries_setup_arch(vo
 	fwnmi_init();
 
 	pseries_setup_rfi_flush();
+	setup_stf_barrier();
 
 	/* By default, only probe PCI (can be overridden by rtas_pci) */
 	pci_add_flags(PCI_PROBE_ONLY);


