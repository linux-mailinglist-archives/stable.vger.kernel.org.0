Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9A82B9F07
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 01:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgKTAHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 19:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgKTAHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 19:07:41 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB6AC0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 16:07:40 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id v21so5745706pgi.2
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 16:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7EQMD8scrFkeCrc6CCCnzJcZ3JqTzbC5BvZ5QsBWbm8=;
        b=apSumLAKiv/6gfN7WYM7ahLLTeCK+OsQBN4vEdW2zGZwSxcpEcB8OtCTEQpmx/oLMY
         EKEaoMI9VwxOg8IBMaUqi2oaXHAAz1j/mLWE5D5CWb4l6zcPaSxl6dqQkgSMV7xwlT3t
         gEVvEMwYmks0joNU1Zzj2Q1V8e2pdlSk8d2cQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7EQMD8scrFkeCrc6CCCnzJcZ3JqTzbC5BvZ5QsBWbm8=;
        b=fFnxKOjMgA5KyT62/DV3KoOQLt3E+IaF4oD/aCjJSMrKBPyjVuWVdq1huwW7U3tT1J
         Ctje7njxMjx0y1yXEAm99My10LABkBk2WFpQvq3KYM2FtXwCf9fNxAWf2eQKpGK3oIWG
         vemrZ0aNhPHIVpfP+/gXfPwAN4kpFcum6hfsMfQ0U5N/+HGaRTPK8KBd1FBRkzgCQy1N
         cc1ARAV4vunOpEQFR4cJxFfGF3XKfpUL9leNGOSPDRDvAWv+5KvApumIzYBubnTCG2zr
         M2OHK6kH1QwQ2YCySR5azU4B6HgckEQqm7mLKhKgE1ZHMLwuPQfQ97Bd46fWxaXMi7CN
         87Kw==
X-Gm-Message-State: AOAM530CCqbb/iSNQes0iA0Q2roE/vPNWnUwFiaTmSe8AHYMrktjR4qO
        VoXM0UoFNbX8ATabD5S9++owTa5AItk4IQ==
X-Google-Smtp-Source: ABdhPJxdQstCjqB/dMov1F+I7v9biPwJ7z4NeAnubL0Asa4PN9Pw7k1/WTsBTb41bqp6i3oxUzvFEA==
X-Received: by 2002:a62:2a81:0:b029:18c:310f:74fe with SMTP id q123-20020a622a810000b029018c310f74femr11324053pfq.50.1605830859361;
        Thu, 19 Nov 2020 16:07:39 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id m68sm908054pga.46.2020.11.19.16.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 16:07:38 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.4 8/8] powerpc/64s: flush L1D after user accesses
Date:   Fri, 20 Nov 2020 11:07:04 +1100
Message-Id: <20201120000704.374811-9-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120000704.374811-1-dja@axtens.net>
References: <20201120000704.374811-1-dja@axtens.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit 9a32a7e78bd0cd9a9b6332cbdc345ee5ffd0c5de upstream.

IBM Power9 processors can speculatively operate on data in the L1 cache before
it has been completely validated, via a way-prediction mechanism. It is not possible
for an attacker to determine the contents of impermissible memory using this method,
since these systems implement a combination of hardware and software security measures
to prevent scenarios where protected data could be leaked.

However these measures don't address the scenario where an attacker induces
the operating system to speculatively execute instructions using data that the
attacker controls. This can be used for example to speculatively bypass "kernel
user access prevention" techniques, as discovered by Anthony Steinhauser of
Google's Safeside Project. This is not an attack by itself, but there is a possibility
it could be used in conjunction with side-channels or other weaknesses in the
privileged code to construct an attack.

This issue can be mitigated by flushing the L1 cache between privilege boundaries
of concern. This patch flushes the L1 cache after user accesses.

This is part of the fix for CVE-2020-4788.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 Documentation/kernel-parameters.txt           |  4 +
 .../powerpc/include/asm/book3s/64/kup-radix.h | 23 +++++
 arch/powerpc/include/asm/feature-fixups.h     |  9 ++
 arch/powerpc/include/asm/kup.h                |  4 +
 arch/powerpc/include/asm/security_features.h  |  3 +
 arch/powerpc/include/asm/setup.h              |  1 +
 arch/powerpc/kernel/exceptions-64s.S          | 86 ++++++-------------
 arch/powerpc/kernel/ppc_ksyms.c               |  7 ++
 arch/powerpc/kernel/setup_64.c                | 80 +++++++++++++++++
 arch/powerpc/kernel/vmlinux.lds.S             |  7 ++
 arch/powerpc/lib/feature-fixups.c             | 50 +++++++++++
 arch/powerpc/platforms/powernv/setup.c        |  7 +-
 arch/powerpc/platforms/pseries/setup.c        |  4 +
 13 files changed, 224 insertions(+), 61 deletions(-)
 create mode 100644 arch/powerpc/include/asm/book3s/64/kup-radix.h

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 007f12c79365..2c579b53d582 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2197,6 +2197,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 					       mds=off [X86]
 					       tsx_async_abort=off [X86]
 					       no_entry_flush [PPC]
+					       no_uaccess_flush [PPC]
 
 			auto (default)
 				Mitigate all CPU vulnerabilities, but leave SMT
@@ -2521,6 +2522,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	nospec_store_bypass_disable
 			[HW] Disable all mitigations for the Speculative Store Bypass vulnerability
 
+	no_uaccess_flush
+			[PPC] Don't flush the L1-D cache after accessing user data.
+
 	noxsave		[BUGS=X86] Disables x86 extended register state save
 			and restore using xsave. The kernel will fallback to
 			enabling legacy floating-point and sse state.
diff --git a/arch/powerpc/include/asm/book3s/64/kup-radix.h b/arch/powerpc/include/asm/book3s/64/kup-radix.h
new file mode 100644
index 000000000000..cce8e7497d72
--- /dev/null
+++ b/arch/powerpc/include/asm/book3s/64/kup-radix.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_BOOK3S_64_KUP_RADIX_H
+#define _ASM_POWERPC_BOOK3S_64_KUP_RADIX_H
+#include <linux/jump_label.h>
+
+DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
+
+/* Prototype for function defined in exceptions-64s.S */
+void do_uaccess_flush(void);
+
+static __always_inline void allow_user_access(void __user *to, const void __user *from,
+					      unsigned long size)
+{
+}
+
+static inline void prevent_user_access(void __user *to, const void __user *from,
+				       unsigned long size)
+{
+	if (static_branch_unlikely(&uaccess_flush_key))
+		do_uaccess_flush();
+}
+
+#endif /* _ASM_POWERPC_BOOK3S_64_KUP_RADIX_H */
diff --git a/arch/powerpc/include/asm/feature-fixups.h b/arch/powerpc/include/asm/feature-fixups.h
index a963c26b2d34..83219710e904 100644
--- a/arch/powerpc/include/asm/feature-fixups.h
+++ b/arch/powerpc/include/asm/feature-fixups.h
@@ -200,6 +200,14 @@ label##3:					       	\
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
@@ -242,6 +250,7 @@ extern long stf_barrier_fallback;
 extern long entry_flush_fallback;
 extern long __start___stf_entry_barrier_fixup, __stop___stf_entry_barrier_fixup;
 extern long __start___stf_exit_barrier_fixup, __stop___stf_exit_barrier_fixup;
+extern long __start___uaccess_flush_fixup, __stop___uaccess_flush_fixup;
 extern long __start___entry_flush_fixup, __stop___entry_flush_fixup;
 extern long __start___rfi_flush_fixup, __stop___rfi_flush_fixup;
 extern long __start___barrier_nospec_fixup, __stop___barrier_nospec_fixup;
diff --git a/arch/powerpc/include/asm/kup.h b/arch/powerpc/include/asm/kup.h
index 7895d5eeaf21..f0f8e36ad71f 100644
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -6,10 +6,14 @@
 
 #include <asm/pgtable.h>
 
+#ifdef CONFIG_PPC_BOOK3S_64
+#include <asm/book3s/64/kup-radix.h>
+#else
 static inline void allow_user_access(void __user *to, const void __user *from,
 				     unsigned long size) { }
 static inline void prevent_user_access(void __user *to, const void __user *from,
 				       unsigned long size) { }
+#endif /* CONFIG_PPC_BOOK3S_64 */
 
 static inline void allow_read_from_user(const void __user *from, unsigned long size)
 {
diff --git a/arch/powerpc/include/asm/security_features.h b/arch/powerpc/include/asm/security_features.h
index 082b56bf678d..3b45a64e491e 100644
--- a/arch/powerpc/include/asm/security_features.h
+++ b/arch/powerpc/include/asm/security_features.h
@@ -87,6 +87,8 @@ static inline bool security_ftr_enabled(unsigned long feature)
 // The L1-D cache should be flushed when entering the kernel
 #define SEC_FTR_L1D_FLUSH_ENTRY		0x0000000000004000ull
 
+// The L1-D cache should be flushed after user accesses from the kernel
+#define SEC_FTR_L1D_FLUSH_UACCESS	0x0000000000008000ull
 
 // Features enabled by default
 #define SEC_FTR_DEFAULT \
@@ -94,6 +96,7 @@ static inline bool security_ftr_enabled(unsigned long feature)
 	 SEC_FTR_L1D_FLUSH_PR | \
 	 SEC_FTR_BNDS_CHK_SPEC_BAR | \
 	 SEC_FTR_L1D_FLUSH_ENTRY | \
+	 SEC_FTR_L1D_FLUSH_UACCESS | \
 	 SEC_FTR_FAVOUR_SECURITY)
 
 #endif /* _ASM_POWERPC_SECURITY_FEATURES_H */
diff --git a/arch/powerpc/include/asm/setup.h b/arch/powerpc/include/asm/setup.h
index 26b55f23cf64..1ccf474f08ab 100644
--- a/arch/powerpc/include/asm/setup.h
+++ b/arch/powerpc/include/asm/setup.h
@@ -46,6 +46,7 @@ void setup_barrier_nospec(void);
 #else
 static inline void setup_barrier_nospec(void) { };
 #endif
+void do_uaccess_flush_fixups(enum l1d_flush_type types);
 void do_entry_flush_fixups(enum l1d_flush_type types);
 void do_barrier_nospec_fixups(bool enable);
 extern bool barrier_nospec_enabled;
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 7715fd89bb94..7f8e1bdbe3e2 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1630,14 +1630,9 @@ stf_barrier_fallback:
 	.endr
 	blr
 
-	.globl rfi_flush_fallback
-rfi_flush_fallback:
-	SET_SCRATCH0(r13);
-	GET_PACA(r13);
-	std	r9,PACA_EXRFI+EX_R9(r13)
-	std	r10,PACA_EXRFI+EX_R10(r13)
-	std	r11,PACA_EXRFI+EX_R11(r13)
-	mfctr	r9
+
+/* Clobbers r10, r11, ctr */
+.macro L1D_DISPLACEMENT_FLUSH
 	ld	r10,PACA_RFI_FLUSH_FALLBACK_AREA(r13)
 	ld	r11,PACA_L1D_FLUSH_SIZE(r13)
 	srdi	r11,r11,(7 + 3) /* 128 byte lines, unrolled 8x */
@@ -1663,7 +1658,18 @@ rfi_flush_fallback:
 	ld	r11,(0x80 + 8)*7(r10)
 	addi	r10,r10,0x80*8
 	bdnz	1b
+.endm
+
 
+	.globl rfi_flush_fallback
+rfi_flush_fallback:
+	SET_SCRATCH0(r13);
+	GET_PACA(r13);
+	std	r9,PACA_EXRFI+EX_R9(r13)
+	std	r10,PACA_EXRFI+EX_R10(r13)
+	std	r11,PACA_EXRFI+EX_R11(r13)
+	mfctr	r9
+	L1D_DISPLACEMENT_FLUSH
 	mtctr	r9
 	ld	r9,PACA_EXRFI+EX_R9(r13)
 	ld	r10,PACA_EXRFI+EX_R10(r13)
@@ -1679,32 +1685,7 @@ hrfi_flush_fallback:
 	std	r10,PACA_EXRFI+EX_R10(r13)
 	std	r11,PACA_EXRFI+EX_R11(r13)
 	mfctr	r9
-	ld	r10,PACA_RFI_FLUSH_FALLBACK_AREA(r13)
-	ld	r11,PACA_L1D_FLUSH_SIZE(r13)
-	srdi	r11,r11,(7 + 3) /* 128 byte lines, unrolled 8x */
-	mtctr	r11
-	DCBT_STOP_ALL_STREAM_IDS(r11) /* Stop prefetch streams */
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
@@ -1718,38 +1699,14 @@ entry_flush_fallback:
 	std	r10,PACA_EXRFI+EX_R10(r13)
 	std	r11,PACA_EXRFI+EX_R11(r13)
 	mfctr	r9
-	ld	r10,PACA_RFI_FLUSH_FALLBACK_AREA(r13)
-	ld	r11,PACA_L1D_FLUSH_SIZE(r13)
-	srdi	r11,r11,(7 + 3) /* 128 byte lines, unrolled 8x */
-	mtctr	r11
-	DCBT_STOP_ALL_STREAM_IDS(r11) /* Stop prefetch streams */
-
-	/* order ld/st prior to dcbt stop all streams with flushing */
-	sync
-
-	/*
-	 * The load addresses are at staggered offsets within cachelines,
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
 	ld	r11,PACA_EXRFI+EX_R11(r13)
 	blr
 
+
 /*
  * Hash table stuff
  */
@@ -1909,3 +1866,12 @@ END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
 1:	addi	r3,r1,STACK_FRAME_OVERHEAD
 	bl	kernel_bad_stack
 	b	1b
+
+_KPROBE(do_uaccess_flush)
+	UACCESS_FLUSH_FIXUP_SECTION
+	nop
+	nop
+	nop
+	blr
+	L1D_DISPLACEMENT_FLUSH
+	blr
diff --git a/arch/powerpc/kernel/ppc_ksyms.c b/arch/powerpc/kernel/ppc_ksyms.c
index b92debacb821..80eb47113d5d 100644
--- a/arch/powerpc/kernel/ppc_ksyms.c
+++ b/arch/powerpc/kernel/ppc_ksyms.c
@@ -6,6 +6,9 @@
 #include <asm/cacheflush.h>
 #include <asm/epapr_hcalls.h>
 #include <asm/uaccess.h>
+#ifdef CONFIG_PPC64
+#include <asm/book3s/64/kup-radix.h>
+#endif
 
 EXPORT_SYMBOL(flush_dcache_range);
 EXPORT_SYMBOL(flush_icache_range);
@@ -46,3 +49,7 @@ EXPORT_SYMBOL(epapr_hypercall_start);
 EXPORT_SYMBOL(current_stack_pointer);
 
 EXPORT_SYMBOL(__arch_clear_user);
+
+#ifdef CONFIG_PPC64
+EXPORT_SYMBOL(do_uaccess_flush);
+#endif
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index cd405eaffa23..3c6717569360 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -845,8 +845,12 @@ static enum l1d_flush_type enabled_flush_types;
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
@@ -864,6 +868,14 @@ static int __init handle_no_entry_flush(char *p)
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
@@ -907,6 +919,23 @@ void entry_flush_enable(bool enable)
 	entry_flush = enable;
 }
 
+void uaccess_flush_enable(bool enable)
+{
+	if (enable) {
+		do_uaccess_flush_fixups(enabled_flush_types);
+		if (static_key_initialized)
+			static_branch_enable(&uaccess_flush_key);
+		else
+			printk(KERN_DEBUG "uaccess-flush: deferring static key until after static key initialization\n");
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
@@ -961,6 +990,15 @@ void setup_entry_flush(bool enable)
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
@@ -1014,12 +1052,54 @@ static int entry_flush_get(void *data, u64 *val)
 
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
+
 static __init int rfi_flush_debugfs_init(void)
 {
 	debugfs_create_file("rfi_flush", 0600, powerpc_debugfs_root, NULL, &fops_rfi_flush);
 	debugfs_create_file("entry_flush", 0600, powerpc_debugfs_root, NULL, &fops_entry_flush);
+	debugfs_create_file("uaccess_flush", 0600, powerpc_debugfs_root, NULL, &fops_uaccess_flush);
 	return 0;
 }
 device_initcall(rfi_flush_debugfs_init);
 #endif
+
+/*
+ * setup_uaccess_flush runs before jump_label_init, so we can't do the setup
+ * there. Do it now instead.
+ */
+static __init int uaccess_flush_static_key_init(void)
+{
+	if (uaccess_flush) {
+		printk(KERN_DEBUG "uaccess-flush: switching on static key\n");
+		static_branch_enable(&uaccess_flush_key);
+	}
+	return 0;
+}
+early_initcall(uaccess_flush_static_key_init);
 #endif /* CONFIG_PPC_BOOK3S_64 */
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 43a8cfa5e2fb..f820d03335eb 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -80,6 +80,13 @@ SECTIONS
 		__stop___stf_entry_barrier_fixup = .;
 	}
 
+	. = ALIGN(8);
+	__uaccess_flush_fixup : AT(ADDR(__uaccess_flush_fixup) - LOAD_OFFSET) {
+		__start___uaccess_flush_fixup = .;
+		*(__uaccess_flush_fixup)
+		__stop___uaccess_flush_fixup = .;
+	}
+
 	. = ALIGN(8);
 	__entry_flush_fixup : AT(ADDR(__entry_flush_fixup) - LOAD_OFFSET) {
 		__start___entry_flush_fixup = .;
diff --git a/arch/powerpc/lib/feature-fixups.c b/arch/powerpc/lib/feature-fixups.c
index 4f13bba13596..40b134bf5a68 100644
--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -229,6 +229,56 @@ void do_stf_barrier_fixups(enum stf_barrier_type types)
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
+		patch_instruction(dest, instrs[0]);
+
+		patch_instruction((dest + 1), instrs[1]);
+		patch_instruction((dest + 2), instrs[2]);
+		patch_instruction((dest + 3), instrs[3]);
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
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index fe3f1f438f78..6259228a0e18 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -126,9 +126,10 @@ static void pnv_setup_rfi_flush(void)
 
 	/*
 	 * 4.4 doesn't support Power9 bare metal, so we don't need to flush
-	 * here - the flush fixes a P9 specific vulnerability.
+	 * here - the flushes fix a P9 specific vulnerability.
 	 */
 	security_ftr_clear(SEC_FTR_L1D_FLUSH_ENTRY);
+	security_ftr_clear(SEC_FTR_L1D_FLUSH_UACCESS);
 
 	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) && \
 		 (security_ftr_enabled(SEC_FTR_L1D_FLUSH_PR)   || \
@@ -140,6 +141,10 @@ static void pnv_setup_rfi_flush(void)
 	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&
 		 security_ftr_enabled(SEC_FTR_L1D_FLUSH_ENTRY);
 	setup_entry_flush(enable);
+
+	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&
+		 security_ftr_enabled(SEC_FTR_L1D_FLUSH_UACCESS);
+	setup_uaccess_flush(enable);
 }
 
 static void __init pnv_setup_arch(void)
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 69f1808ecbd2..498c5092bd23 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -588,6 +588,10 @@ void pseries_setup_rfi_flush(void)
 	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&
 		 security_ftr_enabled(SEC_FTR_L1D_FLUSH_ENTRY);
 	setup_entry_flush(enable);
+
+	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&
+		 security_ftr_enabled(SEC_FTR_L1D_FLUSH_UACCESS);
+	setup_uaccess_flush(enable);
 }
 
 static void __init pSeries_setup_arch(void)
-- 
2.25.1

