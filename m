Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBD02BA881
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgKTLId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:08:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:55666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727789AbgKTLHo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 081BF206E3;
        Fri, 20 Nov 2020 11:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870461;
        bh=/QevccffWSu3c5aaGr+j16RtOd/1cHJxL1s/Q23dNTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gopPMV8tw/bb45q4CQVTriUbTF0UKELA/5EBSy1wGSL7v9H+gpu/qvpDl5ozA2RYL
         wLe82GHqSN4+Wy1zWpvtou4/IN0Z/1O/Q51VAETP1odDHIKjTrYoKIREPtOhSHiM1H
         5e3GuGWtN2v9F4V50X1ITbrlYHeJUPYaZlWxsPc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net,
        Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH 5.9 02/14] powerpc/64s: flush L1D on kernel entry
Date:   Fri, 20 Nov 2020 12:03:40 +0100
Message-Id: <20201120104541.287311892@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104541.168007611@linuxfoundation.org>
References: <20201120104541.168007611@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit f79643787e0a0762d2409b7b8334e83f22d85695 upstream.

IBM Power9 processors can speculatively operate on data in the L1 cache
before it has been completely validated, via a way-prediction mechanism. It
is not possible for an attacker to determine the contents of impermissible
memory using this method, since these systems implement a combination of
hardware and software security measures to prevent scenarios where
protected data could be leaked.

However these measures don't address the scenario where an attacker induces
the operating system to speculatively execute instructions using data that
the attacker controls. This can be used for example to speculatively bypass
"kernel user access prevention" techniques, as discovered by Anthony
Steinhauser of Google's Safeside Project. This is not an attack by itself,
but there is a possibility it could be used in conjunction with
side-channels or other weaknesses in the privileged code to construct an
attack.

This issue can be mitigated by flushing the L1 cache between privilege
boundaries of concern. This patch flushes the L1 cache on kernel entry.

This is part of the fix for CVE-2020-4788.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |    3 +
 arch/powerpc/include/asm/exception-64s.h        |    9 +++
 arch/powerpc/include/asm/feature-fixups.h       |   10 ++++
 arch/powerpc/include/asm/security_features.h    |    4 +
 arch/powerpc/include/asm/setup.h                |    3 +
 arch/powerpc/kernel/exceptions-64s.S            |   37 ++++++++++++++
 arch/powerpc/kernel/setup_64.c                  |   60 +++++++++++++++++++++++-
 arch/powerpc/kernel/vmlinux.lds.S               |    7 ++
 arch/powerpc/lib/feature-fixups.c               |   54 +++++++++++++++++++++
 arch/powerpc/platforms/powernv/setup.c          |   11 ++++
 arch/powerpc/platforms/pseries/setup.c          |    4 +
 11 files changed, 200 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2833,6 +2833,7 @@
 					       mds=off [X86]
 					       tsx_async_abort=off [X86]
 					       kvm.nx_huge_pages=off [X86]
+					       no_entry_flush [PPC]
 
 				Exceptions:
 					       This does not have any effect on
@@ -3157,6 +3158,8 @@
 
 	noefi		Disable EFI runtime services support.
 
+	no_entry_flush  [PPC] Don't flush the L1-D cache when entering the kernel.
+
 	noexec		[IA-64]
 
 	noexec		[X86]
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -57,11 +57,18 @@
 	nop;								\
 	nop
 
+#define ENTRY_FLUSH_SLOT						\
+	ENTRY_FLUSH_FIXUP_SECTION;					\
+	nop;								\
+	nop;								\
+	nop;
+
 /*
  * r10 must be free to use, r13 must be paca
  */
 #define INTERRUPT_TO_KERNEL						\
-	STF_ENTRY_BARRIER_SLOT
+	STF_ENTRY_BARRIER_SLOT;						\
+	ENTRY_FLUSH_SLOT
 
 /*
  * Macros for annotating the expected destination of (h)rfid
--- a/arch/powerpc/include/asm/feature-fixups.h
+++ b/arch/powerpc/include/asm/feature-fixups.h
@@ -205,6 +205,14 @@ label##3:					       	\
 	FTR_ENTRY_OFFSET 955b-956b;			\
 	.popsection;
 
+#define ENTRY_FLUSH_FIXUP_SECTION			\
+957:							\
+	.pushsection __entry_flush_fixup,"a";		\
+	.align 2;					\
+958:							\
+	FTR_ENTRY_OFFSET 957b-958b;			\
+	.popsection;
+
 #define RFI_FLUSH_FIXUP_SECTION				\
 951:							\
 	.pushsection __rfi_flush_fixup,"a";		\
@@ -237,8 +245,10 @@ label##3:					       	\
 #include <linux/types.h>
 
 extern long stf_barrier_fallback;
+extern long entry_flush_fallback;
 extern long __start___stf_entry_barrier_fixup, __stop___stf_entry_barrier_fixup;
 extern long __start___stf_exit_barrier_fixup, __stop___stf_exit_barrier_fixup;
+extern long __start___entry_flush_fixup, __stop___entry_flush_fixup;
 extern long __start___rfi_flush_fixup, __stop___rfi_flush_fixup;
 extern long __start___barrier_nospec_fixup, __stop___barrier_nospec_fixup;
 extern long __start__btb_flush_fixup, __stop__btb_flush_fixup;
--- a/arch/powerpc/include/asm/security_features.h
+++ b/arch/powerpc/include/asm/security_features.h
@@ -86,12 +86,16 @@ static inline bool security_ftr_enabled(
 // Software required to flush link stack on context switch
 #define SEC_FTR_FLUSH_LINK_STACK	0x0000000000001000ull
 
+// The L1-D cache should be flushed when entering the kernel
+#define SEC_FTR_L1D_FLUSH_ENTRY		0x0000000000004000ull
+
 
 // Features enabled by default
 #define SEC_FTR_DEFAULT \
 	(SEC_FTR_L1D_FLUSH_HV | \
 	 SEC_FTR_L1D_FLUSH_PR | \
 	 SEC_FTR_BNDS_CHK_SPEC_BAR | \
+	 SEC_FTR_L1D_FLUSH_ENTRY | \
 	 SEC_FTR_FAVOUR_SECURITY)
 
 #endif /* _ASM_POWERPC_SECURITY_FEATURES_H */
--- a/arch/powerpc/include/asm/setup.h
+++ b/arch/powerpc/include/asm/setup.h
@@ -52,12 +52,15 @@ enum l1d_flush_type {
 };
 
 void setup_rfi_flush(enum l1d_flush_type, bool enable);
+void setup_entry_flush(bool enable);
+void setup_uaccess_flush(bool enable);
 void do_rfi_flush_fixups(enum l1d_flush_type types);
 #ifdef CONFIG_PPC_BARRIER_NOSPEC
 void setup_barrier_nospec(void);
 #else
 static inline void setup_barrier_nospec(void) { };
 #endif
+void do_entry_flush_fixups(enum l1d_flush_type types);
 void do_barrier_nospec_fixups(bool enable);
 extern bool barrier_nospec_enabled;
 
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -2951,6 +2951,43 @@ TRAMP_REAL_BEGIN(stf_barrier_fallback)
 	.endr
 	blr
 
+TRAMP_REAL_BEGIN(entry_flush_fallback)
+	std	r9,PACA_EXRFI+EX_R9(r13)
+	std	r10,PACA_EXRFI+EX_R10(r13)
+	std	r11,PACA_EXRFI+EX_R11(r13)
+	mfctr	r9
+	ld	r10,PACA_RFI_FLUSH_FALLBACK_AREA(r13)
+	ld	r11,PACA_L1D_FLUSH_SIZE(r13)
+	srdi	r11,r11,(7 + 3) /* 128 byte lines, unrolled 8x */
+	mtctr	r11
+	DCBT_BOOK3S_STOP_ALL_STREAM_IDS(r11) /* Stop prefetch streams */
+
+	/* order ld/st prior to dcbt stop all streams with flushing */
+	sync
+
+	/*
+	 * The load addresses are at staggered offsets within cachelines,
+	 * which suits some pipelines better (on others it should not
+	 * hurt).
+	 */
+1:
+	ld	r11,(0x80 + 8)*0(r10)
+	ld	r11,(0x80 + 8)*1(r10)
+	ld	r11,(0x80 + 8)*2(r10)
+	ld	r11,(0x80 + 8)*3(r10)
+	ld	r11,(0x80 + 8)*4(r10)
+	ld	r11,(0x80 + 8)*5(r10)
+	ld	r11,(0x80 + 8)*6(r10)
+	ld	r11,(0x80 + 8)*7(r10)
+	addi	r10,r10,0x80*8
+	bdnz	1b
+
+	mtctr	r9
+	ld	r9,PACA_EXRFI+EX_R9(r13)
+	ld	r10,PACA_EXRFI+EX_R10(r13)
+	ld	r11,PACA_EXRFI+EX_R11(r13)
+	blr
+
 TRAMP_REAL_BEGIN(rfi_flush_fallback)
 	SET_SCRATCH0(r13);
 	GET_PACA(r13);
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -860,7 +860,9 @@ early_initcall(disable_hardlockup_detect
 static enum l1d_flush_type enabled_flush_types;
 static void *l1d_flush_fallback_area;
 static bool no_rfi_flush;
+static bool no_entry_flush;
 bool rfi_flush;
+bool entry_flush;
 
 static int __init handle_no_rfi_flush(char *p)
 {
@@ -870,6 +872,14 @@ static int __init handle_no_rfi_flush(ch
 }
 early_param("no_rfi_flush", handle_no_rfi_flush);
 
+static int __init handle_no_entry_flush(char *p)
+{
+	pr_info("entry-flush: disabled on command line.");
+	no_entry_flush = true;
+	return 0;
+}
+early_param("no_entry_flush", handle_no_entry_flush);
+
 /*
  * The RFI flush is not KPTI, but because users will see doco that says to use
  * nopti we hijack that option here to also disable the RFI flush.
@@ -901,6 +911,18 @@ void rfi_flush_enable(bool enable)
 	rfi_flush = enable;
 }
 
+void entry_flush_enable(bool enable)
+{
+	if (enable) {
+		do_entry_flush_fixups(enabled_flush_types);
+		on_each_cpu(do_nothing, NULL, 1);
+	} else {
+		do_entry_flush_fixups(L1D_FLUSH_NONE);
+	}
+
+	entry_flush = enable;
+}
+
 static void __ref init_fallback_flush(void)
 {
 	u64 l1d_size, limit;
@@ -959,10 +981,19 @@ void setup_rfi_flush(enum l1d_flush_type
 
 	enabled_flush_types = types;
 
-	if (!no_rfi_flush && !cpu_mitigations_off())
+	if (!cpu_mitigations_off() && !no_rfi_flush)
 		rfi_flush_enable(enable);
 }
 
+void setup_entry_flush(bool enable)
+{
+	if (cpu_mitigations_off())
+		return;
+
+	if (!no_entry_flush)
+		entry_flush_enable(enable);
+}
+
 #ifdef CONFIG_DEBUG_FS
 static int rfi_flush_set(void *data, u64 val)
 {
@@ -990,9 +1021,36 @@ static int rfi_flush_get(void *data, u64
 
 DEFINE_SIMPLE_ATTRIBUTE(fops_rfi_flush, rfi_flush_get, rfi_flush_set, "%llu\n");
 
+static int entry_flush_set(void *data, u64 val)
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
+	if (enable != entry_flush)
+		entry_flush_enable(enable);
+
+	return 0;
+}
+
+static int entry_flush_get(void *data, u64 *val)
+{
+	*val = entry_flush ? 1 : 0;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_entry_flush, entry_flush_get, entry_flush_set, "%llu\n");
+
 static __init int rfi_flush_debugfs_init(void)
 {
 	debugfs_create_file("rfi_flush", 0600, powerpc_debugfs_root, NULL, &fops_rfi_flush);
+	debugfs_create_file("entry_flush", 0600, powerpc_debugfs_root, NULL, &fops_entry_flush);
 	return 0;
 }
 device_initcall(rfi_flush_debugfs_init);
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -132,6 +132,13 @@ SECTIONS
 	}
 
 	. = ALIGN(8);
+	__entry_flush_fixup : AT(ADDR(__entry_flush_fixup) - LOAD_OFFSET) {
+		__start___entry_flush_fixup = .;
+		*(__entry_flush_fixup)
+		__stop___entry_flush_fixup = .;
+	}
+
+	. = ALIGN(8);
 	__stf_exit_barrier_fixup : AT(ADDR(__stf_exit_barrier_fixup) - LOAD_OFFSET) {
 		__start___stf_exit_barrier_fixup = .;
 		*(__stf_exit_barrier_fixup)
--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -234,6 +234,60 @@ void do_stf_barrier_fixups(enum stf_barr
 	do_stf_exit_barrier_fixups(types);
 }
 
+void do_entry_flush_fixups(enum l1d_flush_type types)
+{
+	unsigned int instrs[3], *dest;
+	long *start, *end;
+	int i;
+
+	start = PTRRELOC(&__start___entry_flush_fixup);
+	end = PTRRELOC(&__stop___entry_flush_fixup);
+
+	instrs[0] = 0x60000000; /* nop */
+	instrs[1] = 0x60000000; /* nop */
+	instrs[2] = 0x60000000; /* nop */
+
+	i = 0;
+	if (types == L1D_FLUSH_FALLBACK) {
+		instrs[i++] = 0x7d4802a6; /* mflr r10		*/
+		instrs[i++] = 0x60000000; /* branch patched below */
+		instrs[i++] = 0x7d4803a6; /* mtlr r10		*/
+	}
+
+	if (types & L1D_FLUSH_ORI) {
+		instrs[i++] = 0x63ff0000; /* ori 31,31,0 speculation barrier */
+		instrs[i++] = 0x63de0000; /* ori 30,30,0 L1d flush*/
+	}
+
+	if (types & L1D_FLUSH_MTTRIG)
+		instrs[i++] = 0x7c12dba6; /* mtspr TRIG2,r0 (SPR #882) */
+
+	for (i = 0; start < end; start++, i++) {
+		dest = (void *)start + *start;
+
+		pr_devel("patching dest %lx\n", (unsigned long)dest);
+
+		patch_instruction((struct ppc_inst *)dest, ppc_inst(instrs[0]));
+
+		if (types == L1D_FLUSH_FALLBACK)
+			patch_branch((struct ppc_inst *)(dest + 1), (unsigned long)&entry_flush_fallback,
+				     BRANCH_SET_LINK);
+		else
+			patch_instruction((struct ppc_inst *)(dest + 1), ppc_inst(instrs[1]));
+
+		patch_instruction((struct ppc_inst *)(dest + 2), ppc_inst(instrs[2]));
+	}
+
+	printk(KERN_DEBUG "entry-flush: patched %d locations (%s flush)\n", i,
+		(types == L1D_FLUSH_NONE)       ? "no" :
+		(types == L1D_FLUSH_FALLBACK)   ? "fallback displacement" :
+		(types &  L1D_FLUSH_ORI)        ? (types & L1D_FLUSH_MTTRIG)
+							? "ori+mttrig type"
+							: "ori type" :
+		(types &  L1D_FLUSH_MTTRIG)     ? "mttrig type"
+						: "unknown");
+}
+
 void do_rfi_flush_fixups(enum l1d_flush_type types)
 {
 	unsigned int instrs[3], *dest;
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -122,12 +122,23 @@ static void pnv_setup_rfi_flush(void)
 			type = L1D_FLUSH_ORI;
 	}
 
+	/*
+	 * If we are non-Power9 bare metal, we don't need to flush on kernel
+	 * entry: it fixes a P9 specific vulnerability.
+	 */
+	if (!pvr_version_is(PVR_POWER9))
+		security_ftr_clear(SEC_FTR_L1D_FLUSH_ENTRY);
+
 	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) && \
 		 (security_ftr_enabled(SEC_FTR_L1D_FLUSH_PR)   || \
 		  security_ftr_enabled(SEC_FTR_L1D_FLUSH_HV));
 
 	setup_rfi_flush(type, enable);
 	setup_count_cache_flush();
+
+	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&
+		 security_ftr_enabled(SEC_FTR_L1D_FLUSH_ENTRY);
+	setup_entry_flush(enable);
 }
 
 static void __init pnv_setup_arch(void)
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -573,6 +573,10 @@ void pseries_setup_rfi_flush(void)
 
 	setup_rfi_flush(types, enable);
 	setup_count_cache_flush();
+
+	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&
+		 security_ftr_enabled(SEC_FTR_L1D_FLUSH_ENTRY);
+	setup_entry_flush(enable);
 }
 
 #ifdef CONFIG_PCI_IOV


