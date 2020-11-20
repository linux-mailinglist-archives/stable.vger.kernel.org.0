Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A3E2BA86C
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgKTLHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:07:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728565AbgKTLHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00CCA2222F;
        Fri, 20 Nov 2020 11:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870464;
        bh=/cWOjmBdCV0ADakFJBfHgkHK0R/9u2bH9UfzqtTJ/Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gpk/XqiF674KeAq/PM6vhpsngAKW6H6YOsqtmaCbxdzt6+zXvtOKT+yTeuQfK1md5
         gVLe1rWs17UwL13fTs/CefSID5/tTgPFGv+IJhn8p41hVvfn6M9G2VWEb6kHJ2Ub0Z
         9GMTf3W37YaTdO5zrgpOgDthyxvlNgfqRpJMGCWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net,
        Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH 5.9 03/14] powerpc/64s: flush L1D after user accesses
Date:   Fri, 20 Nov 2020 12:03:41 +0100
Message-Id: <20201120104541.338714354@linuxfoundation.org>
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

commit 9a32a7e78bd0cd9a9b6332cbdc345ee5ffd0c5de upstream.

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
boundaries of concern. This patch flushes the L1 cache after user accesses.

This is part of the fix for CVE-2020-4788.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |    4 +
 arch/powerpc/include/asm/book3s/64/kup-radix.h  |   66 +++++++++++-------
 arch/powerpc/include/asm/exception-64s.h        |    3 
 arch/powerpc/include/asm/feature-fixups.h       |    9 ++
 arch/powerpc/include/asm/kup.h                  |   19 +++--
 arch/powerpc/include/asm/security_features.h    |    3 
 arch/powerpc/include/asm/setup.h                |    1 
 arch/powerpc/kernel/exceptions-64s.S            |   85 +++++++-----------------
 arch/powerpc/kernel/setup_64.c                  |   62 +++++++++++++++++
 arch/powerpc/kernel/vmlinux.lds.S               |    7 +
 arch/powerpc/lib/feature-fixups.c               |   50 ++++++++++++++
 arch/powerpc/platforms/powernv/setup.c          |   10 ++
 arch/powerpc/platforms/pseries/setup.c          |    4 +
 13 files changed, 233 insertions(+), 90 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2834,6 +2834,7 @@
 					       tsx_async_abort=off [X86]
 					       kvm.nx_huge_pages=off [X86]
 					       no_entry_flush [PPC]
+					       no_uaccess_flush [PPC]
 
 				Exceptions:
 					       This does not have any effect on
@@ -3209,6 +3210,9 @@
 	nospec_store_bypass_disable
 			[HW] Disable all mitigations for the Speculative Store Bypass vulnerability
 
+	no_uaccess_flush
+	                [PPC] Don't flush the L1-D cache after accessing user data.
+
 	noxsave		[BUGS=X86] Disables x86 extended register state save
 			and restore using xsave. The kernel will fallback to
 			enabling legacy floating-point and sse state.
--- a/arch/powerpc/include/asm/book3s/64/kup-radix.h
+++ b/arch/powerpc/include/asm/book3s/64/kup-radix.h
@@ -61,6 +61,8 @@
 
 #else /* !__ASSEMBLY__ */
 
+DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
+
 #ifdef CONFIG_PPC_KUAP
 
 #include <asm/mmu.h>
@@ -103,8 +105,16 @@ static inline void kuap_check_amr(void)
 
 static inline unsigned long get_kuap(void)
 {
+	/*
+	 * We return AMR_KUAP_BLOCKED when we don't support KUAP because
+	 * prevent_user_access_return needs to return AMR_KUAP_BLOCKED to
+	 * cause restore_user_access to do a flush.
+	 *
+	 * This has no effect in terms of actually blocking things on hash,
+	 * so it doesn't break anything.
+	 */
 	if (!early_mmu_has_feature(MMU_FTR_RADIX_KUAP))
-		return 0;
+		return AMR_KUAP_BLOCKED;
 
 	return mfspr(SPRN_AMR);
 }
@@ -123,6 +133,31 @@ static inline void set_kuap(unsigned lon
 	isync();
 }
 
+static inline bool
+bad_kuap_fault(struct pt_regs *regs, unsigned long address, bool is_write)
+{
+	return WARN(mmu_has_feature(MMU_FTR_RADIX_KUAP) &&
+		    (regs->kuap & (is_write ? AMR_KUAP_BLOCK_WRITE : AMR_KUAP_BLOCK_READ)),
+		    "Bug: %s fault blocked by AMR!", is_write ? "Write" : "Read");
+}
+#else /* CONFIG_PPC_KUAP */
+static inline void kuap_restore_amr(struct pt_regs *regs, unsigned long amr) { }
+
+static inline unsigned long kuap_get_and_check_amr(void)
+{
+	return 0UL;
+}
+
+static inline void kuap_check_amr(void) { }
+
+static inline unsigned long get_kuap(void)
+{
+	return AMR_KUAP_BLOCKED;
+}
+
+static inline void set_kuap(unsigned long value) { }
+#endif /* !CONFIG_PPC_KUAP */
+
 static __always_inline void allow_user_access(void __user *to, const void __user *from,
 					      unsigned long size, unsigned long dir)
 {
@@ -142,6 +177,8 @@ static inline void prevent_user_access(v
 				       unsigned long size, unsigned long dir)
 {
 	set_kuap(AMR_KUAP_BLOCKED);
+	if (static_branch_unlikely(&uaccess_flush_key))
+		do_uaccess_flush();
 }
 
 static inline unsigned long prevent_user_access_return(void)
@@ -149,6 +186,8 @@ static inline unsigned long prevent_user
 	unsigned long flags = get_kuap();
 
 	set_kuap(AMR_KUAP_BLOCKED);
+	if (static_branch_unlikely(&uaccess_flush_key))
+		do_uaccess_flush();
 
 	return flags;
 }
@@ -156,30 +195,9 @@ static inline unsigned long prevent_user
 static inline void restore_user_access(unsigned long flags)
 {
 	set_kuap(flags);
+	if (static_branch_unlikely(&uaccess_flush_key) && flags == AMR_KUAP_BLOCKED)
+		do_uaccess_flush();
 }
-
-static inline bool
-bad_kuap_fault(struct pt_regs *regs, unsigned long address, bool is_write)
-{
-	return WARN(mmu_has_feature(MMU_FTR_RADIX_KUAP) &&
-		    (regs->kuap & (is_write ? AMR_KUAP_BLOCK_WRITE : AMR_KUAP_BLOCK_READ)),
-		    "Bug: %s fault blocked by AMR!", is_write ? "Write" : "Read");
-}
-#else /* CONFIG_PPC_KUAP */
-static inline void kuap_restore_amr(struct pt_regs *regs, unsigned long amr)
-{
-}
-
-static inline void kuap_check_amr(void)
-{
-}
-
-static inline unsigned long kuap_get_and_check_amr(void)
-{
-	return 0;
-}
-#endif /* CONFIG_PPC_KUAP */
-
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_BOOK3S_64_KUP_RADIX_H */
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -144,6 +144,9 @@
 	RFSCV;								\
 	b	rfscv_flush_fallback
 
+#else /* __ASSEMBLY__ */
+/* Prototype for function defined in exceptions-64s.S */
+void do_uaccess_flush(void);
 #endif /* __ASSEMBLY__ */
 
 #endif	/* _ASM_POWERPC_EXCEPTION_H */
--- a/arch/powerpc/include/asm/feature-fixups.h
+++ b/arch/powerpc/include/asm/feature-fixups.h
@@ -205,6 +205,14 @@ label##3:					       	\
 	FTR_ENTRY_OFFSET 955b-956b;			\
 	.popsection;
 
+#define UACCESS_FLUSH_FIXUP_SECTION			\
+959:							\
+	.pushsection __uaccess_flush_fixup,"a";		\
+	.align 2;					\
+960:							\
+	FTR_ENTRY_OFFSET 959b-960b;			\
+	.popsection;
+
 #define ENTRY_FLUSH_FIXUP_SECTION			\
 957:							\
 	.pushsection __entry_flush_fixup,"a";		\
@@ -248,6 +256,7 @@ extern long stf_barrier_fallback;
 extern long entry_flush_fallback;
 extern long __start___stf_entry_barrier_fixup, __stop___stf_entry_barrier_fixup;
 extern long __start___stf_exit_barrier_fixup, __stop___stf_exit_barrier_fixup;
+extern long __start___uaccess_flush_fixup, __stop___uaccess_flush_fixup;
 extern long __start___entry_flush_fixup, __stop___entry_flush_fixup;
 extern long __start___rfi_flush_fixup, __stop___rfi_flush_fixup;
 extern long __start___barrier_nospec_fixup, __stop___barrier_nospec_fixup;
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -53,17 +53,26 @@ static inline void setup_kuep(bool disab
 void setup_kuap(bool disabled);
 #else
 static inline void setup_kuap(bool disabled) { }
+
+static inline bool
+bad_kuap_fault(struct pt_regs *regs, unsigned long address, bool is_write)
+{
+	return false;
+}
+
+/*
+ * book3s/64/kup-radix.h defines these functions for the !KUAP case to flush
+ * the L1D cache after user accesses. Only include the empty stubs for other
+ * platforms.
+ */
+#ifndef CONFIG_PPC64
 static inline void allow_user_access(void __user *to, const void __user *from,
 				     unsigned long size, unsigned long dir) { }
 static inline void prevent_user_access(void __user *to, const void __user *from,
 				       unsigned long size, unsigned long dir) { }
 static inline unsigned long prevent_user_access_return(void) { return 0UL; }
 static inline void restore_user_access(unsigned long flags) { }
-static inline bool
-bad_kuap_fault(struct pt_regs *regs, unsigned long address, bool is_write)
-{
-	return false;
-}
+#endif /* CONFIG_PPC64 */
 #endif /* CONFIG_PPC_KUAP */
 
 static inline void allow_read_from_user(const void __user *from, unsigned long size)
--- a/arch/powerpc/include/asm/security_features.h
+++ b/arch/powerpc/include/asm/security_features.h
@@ -89,6 +89,8 @@ static inline bool security_ftr_enabled(
 // The L1-D cache should be flushed when entering the kernel
 #define SEC_FTR_L1D_FLUSH_ENTRY		0x0000000000004000ull
 
+// The L1-D cache should be flushed after user accesses from the kernel
+#define SEC_FTR_L1D_FLUSH_UACCESS	0x0000000000008000ull
 
 // Features enabled by default
 #define SEC_FTR_DEFAULT \
@@ -96,6 +98,7 @@ static inline bool security_ftr_enabled(
 	 SEC_FTR_L1D_FLUSH_PR | \
 	 SEC_FTR_BNDS_CHK_SPEC_BAR | \
 	 SEC_FTR_L1D_FLUSH_ENTRY | \
+	 SEC_FTR_L1D_FLUSH_UACCESS | \
 	 SEC_FTR_FAVOUR_SECURITY)
 
 #endif /* _ASM_POWERPC_SECURITY_FEATURES_H */
--- a/arch/powerpc/include/asm/setup.h
+++ b/arch/powerpc/include/asm/setup.h
@@ -60,6 +60,7 @@ void setup_barrier_nospec(void);
 #else
 static inline void setup_barrier_nospec(void) { };
 #endif
+void do_uaccess_flush_fixups(enum l1d_flush_type types);
 void do_entry_flush_fixups(enum l1d_flush_type types);
 void do_barrier_nospec_fixups(bool enable);
 extern bool barrier_nospec_enabled;
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -2951,11 +2951,8 @@ TRAMP_REAL_BEGIN(stf_barrier_fallback)
 	.endr
 	blr
 
-TRAMP_REAL_BEGIN(entry_flush_fallback)
-	std	r9,PACA_EXRFI+EX_R9(r13)
-	std	r10,PACA_EXRFI+EX_R10(r13)
-	std	r11,PACA_EXRFI+EX_R11(r13)
-	mfctr	r9
+/* Clobbers r10, r11, ctr */
+.macro L1D_DISPLACEMENT_FLUSH
 	ld	r10,PACA_RFI_FLUSH_FALLBACK_AREA(r13)
 	ld	r11,PACA_L1D_FLUSH_SIZE(r13)
 	srdi	r11,r11,(7 + 3) /* 128 byte lines, unrolled 8x */
@@ -2981,7 +2978,14 @@ TRAMP_REAL_BEGIN(entry_flush_fallback)
 	ld	r11,(0x80 + 8)*7(r10)
 	addi	r10,r10,0x80*8
 	bdnz	1b
+.endm
 
+TRAMP_REAL_BEGIN(entry_flush_fallback)
+	std	r9,PACA_EXRFI+EX_R9(r13)
+	std	r10,PACA_EXRFI+EX_R10(r13)
+	std	r11,PACA_EXRFI+EX_R11(r13)
+	mfctr	r9
+	L1D_DISPLACEMENT_FLUSH
 	mtctr	r9
 	ld	r9,PACA_EXRFI+EX_R9(r13)
 	ld	r10,PACA_EXRFI+EX_R10(r13)
@@ -2997,32 +3001,7 @@ TRAMP_REAL_BEGIN(rfi_flush_fallback)
 	std	r10,PACA_EXRFI+EX_R10(r13)
 	std	r11,PACA_EXRFI+EX_R11(r13)
 	mfctr	r9
-	ld	r10,PACA_RFI_FLUSH_FALLBACK_AREA(r13)
-	ld	r11,PACA_L1D_FLUSH_SIZE(r13)
-	srdi	r11,r11,(7 + 3) /* 128 byte lines, unrolled 8x */
-	mtctr	r11
-	DCBT_BOOK3S_STOP_ALL_STREAM_IDS(r11) /* Stop prefetch streams */
-
-	/* order ld/st prior to dcbt stop all streams with flushing */
-	sync
-
-	/*
-	 * The load adresses are at staggered offsets within cachelines,
-	 * which suits some pipelines better (on others it should not
-	 * hurt).
-	 */
-1:
-	ld	r11,(0x80 + 8)*0(r10)
-	ld	r11,(0x80 + 8)*1(r10)
-	ld	r11,(0x80 + 8)*2(r10)
-	ld	r11,(0x80 + 8)*3(r10)
-	ld	r11,(0x80 + 8)*4(r10)
-	ld	r11,(0x80 + 8)*5(r10)
-	ld	r11,(0x80 + 8)*6(r10)
-	ld	r11,(0x80 + 8)*7(r10)
-	addi	r10,r10,0x80*8
-	bdnz	1b
-
+	L1D_DISPLACEMENT_FLUSH
 	mtctr	r9
 	ld	r9,PACA_EXRFI+EX_R9(r13)
 	ld	r10,PACA_EXRFI+EX_R10(r13)
@@ -3040,32 +3019,7 @@ TRAMP_REAL_BEGIN(hrfi_flush_fallback)
 	std	r10,PACA_EXRFI+EX_R10(r13)
 	std	r11,PACA_EXRFI+EX_R11(r13)
 	mfctr	r9
-	ld	r10,PACA_RFI_FLUSH_FALLBACK_AREA(r13)
-	ld	r11,PACA_L1D_FLUSH_SIZE(r13)
-	srdi	r11,r11,(7 + 3) /* 128 byte lines, unrolled 8x */
-	mtctr	r11
-	DCBT_BOOK3S_STOP_ALL_STREAM_IDS(r11) /* Stop prefetch streams */
-
-	/* order ld/st prior to dcbt stop all streams with flushing */
-	sync
-
-	/*
-	 * The load adresses are at staggered offsets within cachelines,
-	 * which suits some pipelines better (on others it should not
-	 * hurt).
-	 */
-1:
-	ld	r11,(0x80 + 8)*0(r10)
-	ld	r11,(0x80 + 8)*1(r10)
-	ld	r11,(0x80 + 8)*2(r10)
-	ld	r11,(0x80 + 8)*3(r10)
-	ld	r11,(0x80 + 8)*4(r10)
-	ld	r11,(0x80 + 8)*5(r10)
-	ld	r11,(0x80 + 8)*6(r10)
-	ld	r11,(0x80 + 8)*7(r10)
-	addi	r10,r10,0x80*8
-	bdnz	1b
-
+	L1D_DISPLACEMENT_FLUSH
 	mtctr	r9
 	ld	r9,PACA_EXRFI+EX_R9(r13)
 	ld	r10,PACA_EXRFI+EX_R10(r13)
@@ -3116,8 +3070,21 @@ TRAMP_REAL_BEGIN(rfscv_flush_fallback)
 	RFSCV
 
 USE_TEXT_SECTION()
-	MASKED_INTERRUPT
-	MASKED_INTERRUPT hsrr=1
+
+_GLOBAL(do_uaccess_flush)
+	UACCESS_FLUSH_FIXUP_SECTION
+	nop
+	nop
+	nop
+	blr
+	L1D_DISPLACEMENT_FLUSH
+	blr
+_ASM_NOKPROBE_SYMBOL(do_uaccess_flush)
+EXPORT_SYMBOL(do_uaccess_flush)
+
+
+MASKED_INTERRUPT
+MASKED_INTERRUPT hsrr=1
 
 #ifdef CONFIG_KVM_BOOK3S_64_HANDLER
 kvmppc_skip_interrupt:
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -861,8 +861,12 @@ static enum l1d_flush_type enabled_flush
 static void *l1d_flush_fallback_area;
 static bool no_rfi_flush;
 static bool no_entry_flush;
+static bool no_uaccess_flush;
 bool rfi_flush;
 bool entry_flush;
+bool uaccess_flush;
+DEFINE_STATIC_KEY_FALSE(uaccess_flush_key);
+EXPORT_SYMBOL(uaccess_flush_key);
 
 static int __init handle_no_rfi_flush(char *p)
 {
@@ -880,6 +884,14 @@ static int __init handle_no_entry_flush(
 }
 early_param("no_entry_flush", handle_no_entry_flush);
 
+static int __init handle_no_uaccess_flush(char *p)
+{
+	pr_info("uaccess-flush: disabled on command line.");
+	no_uaccess_flush = true;
+	return 0;
+}
+early_param("no_uaccess_flush", handle_no_uaccess_flush);
+
 /*
  * The RFI flush is not KPTI, but because users will see doco that says to use
  * nopti we hijack that option here to also disable the RFI flush.
@@ -923,6 +935,20 @@ void entry_flush_enable(bool enable)
 	entry_flush = enable;
 }
 
+void uaccess_flush_enable(bool enable)
+{
+	if (enable) {
+		do_uaccess_flush_fixups(enabled_flush_types);
+		static_branch_enable(&uaccess_flush_key);
+		on_each_cpu(do_nothing, NULL, 1);
+	} else {
+		static_branch_disable(&uaccess_flush_key);
+		do_uaccess_flush_fixups(L1D_FLUSH_NONE);
+	}
+
+	uaccess_flush = enable;
+}
+
 static void __ref init_fallback_flush(void)
 {
 	u64 l1d_size, limit;
@@ -994,6 +1020,15 @@ void setup_entry_flush(bool enable)
 		entry_flush_enable(enable);
 }
 
+void setup_uaccess_flush(bool enable)
+{
+	if (cpu_mitigations_off())
+		return;
+
+	if (!no_uaccess_flush)
+		uaccess_flush_enable(enable);
+}
+
 #ifdef CONFIG_DEBUG_FS
 static int rfi_flush_set(void *data, u64 val)
 {
@@ -1047,10 +1082,37 @@ static int entry_flush_get(void *data, u
 
 DEFINE_SIMPLE_ATTRIBUTE(fops_entry_flush, entry_flush_get, entry_flush_set, "%llu\n");
 
+static int uaccess_flush_set(void *data, u64 val)
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
+	if (enable != uaccess_flush)
+		uaccess_flush_enable(enable);
+
+	return 0;
+}
+
+static int uaccess_flush_get(void *data, u64 *val)
+{
+	*val = uaccess_flush ? 1 : 0;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_uaccess_flush, uaccess_flush_get, uaccess_flush_set, "%llu\n");
+
 static __init int rfi_flush_debugfs_init(void)
 {
 	debugfs_create_file("rfi_flush", 0600, powerpc_debugfs_root, NULL, &fops_rfi_flush);
 	debugfs_create_file("entry_flush", 0600, powerpc_debugfs_root, NULL, &fops_entry_flush);
+	debugfs_create_file("uaccess_flush", 0600, powerpc_debugfs_root, NULL, &fops_uaccess_flush);
 	return 0;
 }
 device_initcall(rfi_flush_debugfs_init);
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -132,6 +132,13 @@ SECTIONS
 	}
 
 	. = ALIGN(8);
+	__uaccess_flush_fixup : AT(ADDR(__uaccess_flush_fixup) - LOAD_OFFSET) {
+		__start___uaccess_flush_fixup = .;
+		*(__uaccess_flush_fixup)
+		__stop___uaccess_flush_fixup = .;
+	}
+
+	. = ALIGN(8);
 	__entry_flush_fixup : AT(ADDR(__entry_flush_fixup) - LOAD_OFFSET) {
 		__start___entry_flush_fixup = .;
 		*(__entry_flush_fixup)
--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -234,6 +234,56 @@ void do_stf_barrier_fixups(enum stf_barr
 	do_stf_exit_barrier_fixups(types);
 }
 
+void do_uaccess_flush_fixups(enum l1d_flush_type types)
+{
+	unsigned int instrs[4], *dest;
+	long *start, *end;
+	int i;
+
+	start = PTRRELOC(&__start___uaccess_flush_fixup);
+	end = PTRRELOC(&__stop___uaccess_flush_fixup);
+
+	instrs[0] = 0x60000000; /* nop */
+	instrs[1] = 0x60000000; /* nop */
+	instrs[2] = 0x60000000; /* nop */
+	instrs[3] = 0x4e800020; /* blr */
+
+	i = 0;
+	if (types == L1D_FLUSH_FALLBACK) {
+		instrs[3] = 0x60000000; /* nop */
+		/* fallthrough to fallback flush */
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
+		patch_instruction((struct ppc_inst *)(dest + 1), ppc_inst(instrs[1]));
+		patch_instruction((struct ppc_inst *)(dest + 2), ppc_inst(instrs[2]));
+		patch_instruction((struct ppc_inst *)(dest + 3), ppc_inst(instrs[3]));
+	}
+
+	printk(KERN_DEBUG "uaccess-flush: patched %d locations (%s flush)\n", i,
+		(types == L1D_FLUSH_NONE)       ? "no" :
+		(types == L1D_FLUSH_FALLBACK)   ? "fallback displacement" :
+		(types &  L1D_FLUSH_ORI)        ? (types & L1D_FLUSH_MTTRIG)
+							? "ori+mttrig type"
+							: "ori type" :
+		(types &  L1D_FLUSH_MTTRIG)     ? "mttrig type"
+						: "unknown");
+}
+
 void do_entry_flush_fixups(enum l1d_flush_type types)
 {
 	unsigned int instrs[3], *dest;
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -124,10 +124,12 @@ static void pnv_setup_rfi_flush(void)
 
 	/*
 	 * If we are non-Power9 bare metal, we don't need to flush on kernel
-	 * entry: it fixes a P9 specific vulnerability.
+	 * entry or after user access: they fix a P9 specific vulnerability.
 	 */
-	if (!pvr_version_is(PVR_POWER9))
+	if (!pvr_version_is(PVR_POWER9)) {
 		security_ftr_clear(SEC_FTR_L1D_FLUSH_ENTRY);
+		security_ftr_clear(SEC_FTR_L1D_FLUSH_UACCESS);
+	}
 
 	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) && \
 		 (security_ftr_enabled(SEC_FTR_L1D_FLUSH_PR)   || \
@@ -139,6 +141,10 @@ static void pnv_setup_rfi_flush(void)
 	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&
 		 security_ftr_enabled(SEC_FTR_L1D_FLUSH_ENTRY);
 	setup_entry_flush(enable);
+
+	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&
+		 security_ftr_enabled(SEC_FTR_L1D_FLUSH_UACCESS);
+	setup_uaccess_flush(enable);
 }
 
 static void __init pnv_setup_arch(void)
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -577,6 +577,10 @@ void pseries_setup_rfi_flush(void)
 	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&
 		 security_ftr_enabled(SEC_FTR_L1D_FLUSH_ENTRY);
 	setup_entry_flush(enable);
+
+	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&
+		 security_ftr_enabled(SEC_FTR_L1D_FLUSH_UACCESS);
+	setup_uaccess_flush(enable);
 }
 
 #ifdef CONFIG_PCI_IOV


