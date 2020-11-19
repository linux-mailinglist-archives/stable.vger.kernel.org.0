Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892DF2B9E67
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgKSXfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgKSXfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:35:33 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30313C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:35:33 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id f18so5661678pgi.8
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VKjps+mnbdG6xBdC85TIxnI2Z8m19u5mNs4kZzqGPTM=;
        b=cytKb3BPKRW9J9wRxiWdnHL9feGO4FCGAmFSNNRZsa+qmEFePq8/16y50gfcxZVmLN
         8z0fyW+h8yCUVQIm6K2mQ5AK7TFiiERPBso76IKx+ukLajB0tShEqDkDhN/4tr1Q+NFL
         jhd3JWho2h+4pqRUt6yz/IbZDZ4iJcWYMOVCw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VKjps+mnbdG6xBdC85TIxnI2Z8m19u5mNs4kZzqGPTM=;
        b=mILadQgRwUv6DiOqNcyvcGPYf6GWYmYmPROEyej70mTYPW/YJHZMB4Xq2CK7XFj4HH
         z4xQpUSpSvLLUzzh+R21K9mfN5s4GJGtTO3q+d9Too7SBKl+L+KJ306rKfjnXzv4VOql
         STK5F0hGu9AskGqyBC3YBq9WonfQe69m+3ByTPy9W+oq8NrnoXbib0RVYGRr95ccazrm
         QJGDtTlXOGX7RxyAyHauGbWkRuQwLfn7QiAsvVIp98orwenJL30EY6fbIzy4k85lwpJ4
         TPJNyg9L70hY9UGDkavQ1MGnq29tZFLVFpL6935tizOJtP1J4oPYxe2yZ1lJrkiR8Qtt
         n8Nw==
X-Gm-Message-State: AOAM530CVosuh/qp3GG0OyeRkN/4m/UHnNiSOJToO/hfhRX66cWNMGq2
        Kihw6HIXcdTphSreqL5E/fTHM2ZJZ4jg3A==
X-Google-Smtp-Source: ABdhPJwDBsdC2szGP9h+yC0mGhFlvv3QKDgFf8xbKiKQIELk/yAFzq1gcDQT/5kbOGgT1G09Tsq+iQ==
X-Received: by 2002:a17:90a:f317:: with SMTP id ca23mr2394027pjb.141.1605828932072;
        Thu, 19 Nov 2020 15:35:32 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id 184sm1120810pfc.28.2020.11.19.15.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:35:31 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 5.4 3/5] powerpc/64s: flush L1D after user accesses
Date:   Fri, 20 Nov 2020 10:35:14 +1100
Message-Id: <20201119233516.368194-4-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119233516.368194-1-dja@axtens.net>
References: <20201119233516.368194-1-dja@axtens.net>
MIME-Version: 1.0
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
---
 .../admin-guide/kernel-parameters.txt         |  4 +
 .../powerpc/include/asm/book3s/64/kup-radix.h | 24 +++---
 arch/powerpc/include/asm/exception-64s.h      |  3 +
 arch/powerpc/include/asm/feature-fixups.h     |  9 +++
 arch/powerpc/include/asm/kup.h                | 17 +++-
 arch/powerpc/include/asm/security_features.h  |  3 +
 arch/powerpc/include/asm/setup.h              |  1 +
 arch/powerpc/kernel/exceptions-64s.S          | 81 ++++++-------------
 arch/powerpc/kernel/setup_64.c                | 62 ++++++++++++++
 arch/powerpc/kernel/vmlinux.lds.S             |  7 ++
 arch/powerpc/lib/feature-fixups.c             | 50 ++++++++++++
 arch/powerpc/platforms/powernv/setup.c        |  4 +
 arch/powerpc/platforms/pseries/setup.c        |  4 +
 13 files changed, 199 insertions(+), 70 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index e1036ff037e6..fea15cd49fbc 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2668,6 +2668,7 @@
 					       tsx_async_abort=off [X86]
 					       kvm.nx_huge_pages=off [X86]
 					       no_entry_flush [PPC]
+					       no_uaccess_flush [PPC]
 
 				Exceptions:
 					       This does not have any effect on
@@ -3041,6 +3042,9 @@
 	nospec_store_bypass_disable
 			[HW] Disable all mitigations for the Speculative Store Bypass vulnerability
 
+	no_uaccess_flush
+	                [PPC] Don't flush the L1-D cache after accessing user data.
+
 	noxsave		[BUGS=X86] Disables x86 extended register state save
 			and restore using xsave. The kernel will fallback to
 			enabling legacy floating-point and sse state.
diff --git a/arch/powerpc/include/asm/book3s/64/kup-radix.h b/arch/powerpc/include/asm/book3s/64/kup-radix.h
index c8d1076e0ebb..394931798550 100644
--- a/arch/powerpc/include/asm/book3s/64/kup-radix.h
+++ b/arch/powerpc/include/asm/book3s/64/kup-radix.h
@@ -54,6 +54,8 @@
 
 #else /* !__ASSEMBLY__ */
 
+DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
+
 #ifdef CONFIG_PPC_KUAP
 
 #include <asm/reg.h>
@@ -77,6 +79,17 @@ static inline void set_kuap(unsigned long value)
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
+static inline void set_kuap(unsigned long value) { }
+#endif /* !CONFIG_PPC_KUAP */
+
 static __always_inline void allow_user_access(void __user *to, const void __user *from,
 					      unsigned long size, unsigned long dir)
 {
@@ -94,17 +107,10 @@ static inline void prevent_user_access(void __user *to, const void __user *from,
 				       unsigned long size, unsigned long dir)
 {
 	set_kuap(AMR_KUAP_BLOCKED);
+	if (static_branch_unlikely(&uaccess_flush_key))
+		do_uaccess_flush();
 }
 
-static inline bool
-bad_kuap_fault(struct pt_regs *regs, unsigned long address, bool is_write)
-{
-	return WARN(mmu_has_feature(MMU_FTR_RADIX_KUAP) &&
-		    (regs->kuap & (is_write ? AMR_KUAP_BLOCK_WRITE : AMR_KUAP_BLOCK_READ)),
-		    "Bug: %s fault blocked by AMR!", is_write ? "Write" : "Read");
-}
-#endif /* CONFIG_PPC_KUAP */
-
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_BOOK3S_64_KUP_RADIX_H */
diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/include/asm/exception-64s.h
index 82fc12ae3278..6d0795d7b89c 100644
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -134,6 +134,9 @@
 	hrfid;								\
 	b	hrfi_flush_fallback
 
+#else /* __ASSEMBLY__ */
+/* Prototype for function defined in exceptions-64s.S */
+void do_uaccess_flush(void);
 #endif /* __ASSEMBLY__ */
 
 #endif	/* _ASM_POWERPC_EXCEPTION_H */
diff --git a/arch/powerpc/include/asm/feature-fixups.h b/arch/powerpc/include/asm/feature-fixups.h
index 06a48219bbf2..fbd406cd6916 100644
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
diff --git a/arch/powerpc/include/asm/kup.h b/arch/powerpc/include/asm/kup.h
index 94f24928916a..8f4d27980003 100644
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -45,15 +45,24 @@ static inline void setup_kuep(bool disabled) { }
 void setup_kuap(bool disabled);
 #else
 static inline void setup_kuap(bool disabled) { }
-static inline void allow_user_access(void __user *to, const void __user *from,
-				     unsigned long size, unsigned long dir) { }
-static inline void prevent_user_access(void __user *to, const void __user *from,
-				       unsigned long size, unsigned long dir) { }
+
 static inline bool
 bad_kuap_fault(struct pt_regs *regs, unsigned long address, bool is_write)
 {
 	return false;
 }
+
+/*
+ * book3s/64/kup-radix.h defines these functions for the !KUAP case to flush
+ * the L1D cache after user accesses. Only include the empty stubs for other
+ * platforms.
+ */
+#ifndef CONFIG_PPC64
+static inline void allow_user_access(void __user *to, const void __user *from,
+				     unsigned long size, unsigned long dir) { }
+static inline void prevent_user_access(void __user *to, const void __user *from,
+				       unsigned long size, unsigned long dir) { }
+#endif /* CONFIG_PPC64 */
 #endif /* CONFIG_PPC_KUAP */
 
 static inline void allow_read_from_user(const void __user *from, unsigned long size)
diff --git a/arch/powerpc/include/asm/security_features.h b/arch/powerpc/include/asm/security_features.h
index 8c99b651a83e..e9e3f85134e5 100644
--- a/arch/powerpc/include/asm/security_features.h
+++ b/arch/powerpc/include/asm/security_features.h
@@ -87,6 +87,8 @@ static inline bool security_ftr_enabled(u64 feature)
 // The L1-D cache should be flushed when entering the kernel
 #define SEC_FTR_L1D_FLUSH_ENTRY		0x0000000000004000ull
 
+// The L1-D cache should be flushed after user accesses from the kernel
+#define SEC_FTR_L1D_FLUSH_UACCESS	0x0000000000008000ull
 
 // Features enabled by default
 #define SEC_FTR_DEFAULT \
@@ -94,6 +96,7 @@ static inline bool security_ftr_enabled(u64 feature)
 	 SEC_FTR_L1D_FLUSH_PR | \
 	 SEC_FTR_BNDS_CHK_SPEC_BAR | \
 	 SEC_FTR_L1D_FLUSH_ENTRY | \
+	 SEC_FTR_L1D_FLUSH_UACCESS | \
 	 SEC_FTR_FAVOUR_SECURITY)
 
 #endif /* _ASM_POWERPC_SECURITY_FEATURES_H */
diff --git a/arch/powerpc/include/asm/setup.h b/arch/powerpc/include/asm/setup.h
index 556635217e5c..6f2f4497e13b 100644
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
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index a31a8b39f234..88bba0a931d6 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -2046,11 +2046,8 @@ TRAMP_REAL_BEGIN(stf_barrier_fallback)
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
@@ -2076,7 +2073,14 @@ TRAMP_REAL_BEGIN(entry_flush_fallback)
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
@@ -2092,32 +2096,7 @@ TRAMP_REAL_BEGIN(rfi_flush_fallback)
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
@@ -2135,32 +2114,7 @@ TRAMP_REAL_BEGIN(hrfi_flush_fallback)
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
@@ -2169,6 +2123,19 @@ TRAMP_REAL_BEGIN(hrfi_flush_fallback)
 	GET_SCRATCH0(r13);
 	hrfid
 
+USE_TEXT_SECTION()
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
 /*
  * Real mode exceptions actually use this too, but alternate
  * instruction code patches (which end up in the common .text area)
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index fc0ec8cf3a7e..a6b72dd431a4 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -860,8 +860,12 @@ static enum l1d_flush_type enabled_flush_types;
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
@@ -879,6 +883,14 @@ static int __init handle_no_entry_flush(char *p)
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
@@ -922,6 +934,20 @@ void entry_flush_enable(bool enable)
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
@@ -993,6 +1019,15 @@ void setup_entry_flush(bool enable)
 		entry_flush_enable(enable);
 }
 
+void setup_uaccess_flush(bool enable)
+{
+	if (cpu_mitigations_off())
+		return;
+
+	if (!no_uaccess_flush)
+		uaccess_flush_enable(true);
+}
+
 #ifdef CONFIG_DEBUG_FS
 static int rfi_flush_set(void *data, u64 val)
 {
@@ -1046,10 +1081,37 @@ static int entry_flush_get(void *data, u64 *val)
 
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
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 752bf5910283..5229eeac8946 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -143,6 +143,13 @@ SECTIONS
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
index 8050f074b346..e8b25f74454d 100644
--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -228,6 +228,56 @@ void do_stf_barrier_fixups(enum stf_barrier_type types)
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
index 36d60bc2c5e4..ef7b4c09e7d6 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -139,6 +139,10 @@ static void pnv_setup_rfi_flush(void)
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
index 0597bff44788..ce71235c8b81 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -565,6 +565,10 @@ void pseries_setup_rfi_flush(void)
 	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&
 		 security_ftr_enabled(SEC_FTR_L1D_FLUSH_ENTRY);
 	setup_entry_flush(enable);
+
+	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&
+		 security_ftr_enabled(SEC_FTR_L1D_FLUSH_UACCESS);
+	setup_uaccess_flush(enable);
 }
 
 #ifdef CONFIG_PCI_IOV
-- 
2.25.1

