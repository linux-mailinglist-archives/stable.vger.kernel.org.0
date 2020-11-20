Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A122B9E66
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgKSXfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbgKSXfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:35:30 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0E9C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:35:29 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id w14so6044764pfd.7
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xZikf4qpM4KRZId2YHa5tBMNnFIY46U7SoBQgxww6VU=;
        b=BaAppwug41R6YpW0mIA44iPJkVS/Np7YCRJthcTbJYi2WrheFnUD6tQWuw2KJxon2T
         O166hYRIon8/t6aZHPyCMGuCG9Q+KIQfMpQG+cgQtuQ2JZkWNBkhf+dG/ANVfkrLcmRe
         uR373RmgKvAi3fspCLZRq0JqOyYFgnNxDlsss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xZikf4qpM4KRZId2YHa5tBMNnFIY46U7SoBQgxww6VU=;
        b=PToOvWNin255jk9GjVk5UPX6X8ksD3LoxDhmg/p9W/QjFJpcI3b1skzolWm8ItixeA
         /TgjfzPafhbZNmPEd4TjpU7JuC9gD9Wd5/JJS1wF3BeCXaj2o+x5qqL5ehoE64RJsj5Z
         Y/6S3NKyuek+Jr3G3fBMnWnYJ3JDGhDoslKVDFUpaFeU0oL1oXwBrYnfzf5WZDnWCS+r
         3QMjQjnrZeojnR15vBD567uKHZA1B4M5fWH+Qw9yuki8efbOdNw2W34qRdsSsVHsF3b2
         18JPQPFWu9bNp1UFbHu8e6dOP1XYq9XwqIosMrGoSDVu2Z8h90MOtFWmSIn7+v2grwH7
         XEeQ==
X-Gm-Message-State: AOAM532Lg1eflocvi+TVw9Hmi9mnT9f+AQCO/Yv2rS6rFqDun2WnCHgU
        oyBvUq5IpXEYOI2GNmXKxClmzBpzlCeqwA==
X-Google-Smtp-Source: ABdhPJyNhhzeOBXRrenSmhP7WLGN4IRisCh/YmHQH9WyDJpsJmB/c5hhJxGlMXWxA3vyLRGNU5NWJw==
X-Received: by 2002:a63:5853:: with SMTP id i19mr15220483pgm.333.1605828928255;
        Thu, 19 Nov 2020 15:35:28 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id l190sm1030710pfl.205.2020.11.19.15.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:35:27 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 5.4 2/5] powerpc/64s: flush L1D on kernel entry
Date:   Fri, 20 Nov 2020 10:35:13 +1100
Message-Id: <20201119233516.368194-3-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119233516.368194-1-dja@axtens.net>
References: <20201119233516.368194-1-dja@axtens.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit f79643787e0a0762d2409b7b8334e83f22d85695 upstream.

[backporting note: we need to mark some exception handlers as out-of-line
 because the flushing makes them take too much space -- dja]

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
---
 .../admin-guide/kernel-parameters.txt         |  3 +
 arch/powerpc/include/asm/exception-64s.h      |  9 ++-
 arch/powerpc/include/asm/feature-fixups.h     | 10 ++++
 arch/powerpc/include/asm/security_features.h  |  4 ++
 arch/powerpc/include/asm/setup.h              |  3 +
 arch/powerpc/kernel/exceptions-64s.S          | 49 +++++++++++++--
 arch/powerpc/kernel/setup_64.c                | 60 ++++++++++++++++++-
 arch/powerpc/kernel/vmlinux.lds.S             |  7 +++
 arch/powerpc/lib/feature-fixups.c             | 54 +++++++++++++++++
 arch/powerpc/platforms/powernv/setup.c        | 11 ++++
 arch/powerpc/platforms/pseries/setup.c        |  4 ++
 11 files changed, 206 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 5b4753e602de..e1036ff037e6 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2667,6 +2667,7 @@
 					       mds=off [X86]
 					       tsx_async_abort=off [X86]
 					       kvm.nx_huge_pages=off [X86]
+					       no_entry_flush [PPC]
 
 				Exceptions:
 					       This does not have any effect on
@@ -2989,6 +2990,8 @@
 
 	noefi		Disable EFI runtime services support.
 
+	no_entry_flush  [PPC] Don't flush the L1-D cache when entering the kernel.
+
 	noexec		[IA-64]
 
 	noexec		[X86]
diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/include/asm/exception-64s.h
index 33f4f72eb035..82fc12ae3278 100644
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -61,11 +61,18 @@
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
diff --git a/arch/powerpc/include/asm/feature-fixups.h b/arch/powerpc/include/asm/feature-fixups.h
index b0af97add751..06a48219bbf2 100644
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
diff --git a/arch/powerpc/include/asm/security_features.h b/arch/powerpc/include/asm/security_features.h
index 7c05e95a5c44..8c99b651a83e 100644
--- a/arch/powerpc/include/asm/security_features.h
+++ b/arch/powerpc/include/asm/security_features.h
@@ -84,12 +84,16 @@ static inline bool security_ftr_enabled(u64 feature)
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
diff --git a/arch/powerpc/include/asm/setup.h b/arch/powerpc/include/asm/setup.h
index 65676e2325b8..556635217e5c 100644
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
 
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 70ac8a6ba0c1..a31a8b39f234 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1150,7 +1150,7 @@ EXC_REAL_BEGIN(data_access, 0x300, 0x80)
 	INT_HANDLER data_access, 0x300, ool=1, dar=1, dsisr=1, kvm=1
 EXC_REAL_END(data_access, 0x300, 0x80)
 EXC_VIRT_BEGIN(data_access, 0x4300, 0x80)
-	INT_HANDLER data_access, 0x300, virt=1, dar=1, dsisr=1
+	INT_HANDLER data_access, 0x300, ool=1, virt=1, dar=1, dsisr=1
 EXC_VIRT_END(data_access, 0x4300, 0x80)
 INT_KVM_HANDLER data_access, 0x300, EXC_STD, PACA_EXGEN, 1
 EXC_COMMON_BEGIN(data_access_common)
@@ -1205,7 +1205,7 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TYPE_RADIX)
 
 
 EXC_REAL_BEGIN(instruction_access, 0x400, 0x80)
-	INT_HANDLER instruction_access, 0x400, kvm=1
+	INT_HANDLER instruction_access, 0x400, ool=1, kvm=1
 EXC_REAL_END(instruction_access, 0x400, 0x80)
 EXC_VIRT_BEGIN(instruction_access, 0x4400, 0x80)
 	INT_HANDLER instruction_access, 0x400, virt=1
@@ -1225,7 +1225,7 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TYPE_RADIX)
 
 
 EXC_REAL_BEGIN(instruction_access_slb, 0x480, 0x80)
-	INT_HANDLER instruction_access_slb, 0x480, area=PACA_EXSLB, kvm=1
+	INT_HANDLER instruction_access_slb, 0x480, ool=1, area=PACA_EXSLB, kvm=1
 EXC_REAL_END(instruction_access_slb, 0x480, 0x80)
 EXC_VIRT_BEGIN(instruction_access_slb, 0x4480, 0x80)
 	INT_HANDLER instruction_access_slb, 0x480, virt=1, area=PACA_EXSLB
@@ -1365,17 +1365,17 @@ EXC_REAL_BEGIN(decrementer, 0x900, 0x80)
 	INT_HANDLER decrementer, 0x900, ool=1, bitmask=IRQS_DISABLED, kvm=1
 EXC_REAL_END(decrementer, 0x900, 0x80)
 EXC_VIRT_BEGIN(decrementer, 0x4900, 0x80)
-	INT_HANDLER decrementer, 0x900, virt=1, bitmask=IRQS_DISABLED
+	INT_HANDLER decrementer, 0x900, ool=1, virt=1, bitmask=IRQS_DISABLED
 EXC_VIRT_END(decrementer, 0x4900, 0x80)
 INT_KVM_HANDLER decrementer, 0x900, EXC_STD, PACA_EXGEN, 0
 EXC_COMMON_ASYNC(decrementer_common, 0x900, timer_interrupt)
 
 
 EXC_REAL_BEGIN(hdecrementer, 0x980, 0x80)
-	INT_HANDLER hdecrementer, 0x980, hsrr=EXC_HV, kvm=1
+	INT_HANDLER hdecrementer, 0x980, ool=1, hsrr=EXC_HV, kvm=1
 EXC_REAL_END(hdecrementer, 0x980, 0x80)
 EXC_VIRT_BEGIN(hdecrementer, 0x4980, 0x80)
-	INT_HANDLER hdecrementer, 0x980, virt=1, hsrr=EXC_HV, kvm=1
+	INT_HANDLER hdecrementer, 0x980, ool=1, virt=1, hsrr=EXC_HV, kvm=1
 EXC_VIRT_END(hdecrementer, 0x4980, 0x80)
 INT_KVM_HANDLER hdecrementer, 0x980, EXC_HV, PACA_EXGEN, 0
 EXC_COMMON(hdecrementer_common, 0x980, hdec_interrupt)
@@ -2046,6 +2046,43 @@ TRAMP_REAL_BEGIN(stf_barrier_fallback)
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
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index e50fbed36651..fc0ec8cf3a7e 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -859,7 +859,9 @@ early_initcall(disable_hardlockup_detector);
 static enum l1d_flush_type enabled_flush_types;
 static void *l1d_flush_fallback_area;
 static bool no_rfi_flush;
+static bool no_entry_flush;
 bool rfi_flush;
+bool entry_flush;
 
 static int __init handle_no_rfi_flush(char *p)
 {
@@ -869,6 +871,14 @@ static int __init handle_no_rfi_flush(char *p)
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
@@ -900,6 +910,18 @@ void rfi_flush_enable(bool enable)
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
@@ -958,10 +980,19 @@ void setup_rfi_flush(enum l1d_flush_type types, bool enable)
 
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
@@ -989,9 +1020,36 @@ static int rfi_flush_get(void *data, u64 *val)
 
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
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 060a1acd7c6d..752bf5910283 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -143,6 +143,13 @@ SECTIONS
 		__stop___stf_entry_barrier_fixup = .;
 	}
 
+	. = ALIGN(8);
+	__entry_flush_fixup : AT(ADDR(__entry_flush_fixup) - LOAD_OFFSET) {
+		__start___entry_flush_fixup = .;
+		*(__entry_flush_fixup)
+		__stop___entry_flush_fixup = .;
+	}
+
 	. = ALIGN(8);
 	__stf_exit_barrier_fixup : AT(ADDR(__stf_exit_barrier_fixup) - LOAD_OFFSET) {
 		__start___stf_exit_barrier_fixup = .;
diff --git a/arch/powerpc/lib/feature-fixups.c b/arch/powerpc/lib/feature-fixups.c
index 4ba634b89ce5..8050f074b346 100644
--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -228,6 +228,60 @@ void do_stf_barrier_fixups(enum stf_barrier_type types)
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
+		patch_instruction(dest, instrs[0]);
+
+		if (types == L1D_FLUSH_FALLBACK)
+			patch_branch((dest + 1), (unsigned long)&entry_flush_fallback,
+				     BRANCH_SET_LINK);
+		else
+			patch_instruction((dest + 1), instrs[1]);
+
+		patch_instruction((dest + 2), instrs[2]);
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
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 83498604d322..36d60bc2c5e4 100644
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
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 0c8421dd01ab..0597bff44788 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -561,6 +561,10 @@ void pseries_setup_rfi_flush(void)
 
 	setup_rfi_flush(types, enable);
 	setup_count_cache_flush();
+
+	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&
+		 security_ftr_enabled(SEC_FTR_L1D_FLUSH_ENTRY);
+	setup_entry_flush(enable);
 }
 
 #ifdef CONFIG_PCI_IOV
-- 
2.25.1

