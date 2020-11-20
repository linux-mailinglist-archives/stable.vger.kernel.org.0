Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E862B9F01
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 01:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgKTAHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 19:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgKTAHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 19:07:22 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47F4C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 16:07:20 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id q5so6113577pfk.6
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 16:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KxDrQOH+AskRWqdkTEsAmN3G7qYz2MfrDHx9cbR5q6E=;
        b=DTxHsyKVcGzn9Sig10kQ/JoKK24laelUZCKmYk9UiyzYRndoPgqwDc0kPTxygRCTpD
         kpetx9KKrLr3wHxfPigAVv4JJJB+Qo3rdsEe+x/lngErmRzQdfNbb/slbeac6WwMGL0r
         JulpubwhO01CIMNvqpDBkGf56AhMtsftA5eMM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KxDrQOH+AskRWqdkTEsAmN3G7qYz2MfrDHx9cbR5q6E=;
        b=hAfoD0r7u1yNDBSBciq925qh9jPrwizPtXYEH6rJ8+e4QX74J4X401kvfISHt2J0Jd
         sE0N132FIQmT7d0nSNH5yM8Zav8HMopM1ecj7rSN+kCFuu59hjzPYNF4u8QfGTrFnGU1
         oj74R8blH6jYVU5OrD+Rar0DaXobpcRsJ5yE7TvfrBanvXxnmXIamfpKtwembRUBdifV
         h7EdRDXh5g/hyuLG80rPv3UxJOJX1y7eAO7v1/4pFSRreIPFF0PKIDiQhPwRkeuaz54q
         yteCe1WBmnQ13o1wHloHlRXJv4Oy5ImQ1c9NQ+miDLmfPegRG7ohDwDXnIHPawYq6IG8
         /fDA==
X-Gm-Message-State: AOAM5313j0ZZcTRXv2A8v4DMXg09YObiZXwPP17WLqU0PZigDyDpn2Pc
        g9sZYM4Gc8SAmOnNjPYs//eBFnQlZ9wH+w==
X-Google-Smtp-Source: ABdhPJx6Oop+PLRsmLdaglKnVxJbxBfIRYAVvANUQ5i8kGuDz3e+hPp3VHgNOEsIbPaDRGr3UYv0Aw==
X-Received: by 2002:a17:90a:a090:: with SMTP id r16mr7108835pjp.179.1605830839904;
        Thu, 19 Nov 2020 16:07:19 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id s6sm1192356pfh.9.2020.11.19.16.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 16:07:19 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.4 3/8] powerpc/64s: flush L1D on kernel entry
Date:   Fri, 20 Nov 2020 11:06:59 +1100
Message-Id: <20201120000704.374811-4-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120000704.374811-1-dja@axtens.net>
References: <20201120000704.374811-1-dja@axtens.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit f79643787e0a0762d2409b7b8334e83f22d85695 upstream.

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
of concern. This patch flushes the L1 cache on kernel entry.

This is part of the fix for CVE-2020-4788.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 Documentation/kernel-parameters.txt          |  3 +
 arch/powerpc/include/asm/exception-64s.h     |  9 ++-
 arch/powerpc/include/asm/feature-fixups.h    | 10 ++++
 arch/powerpc/include/asm/security_features.h |  4 ++
 arch/powerpc/include/asm/setup.h             |  3 +
 arch/powerpc/kernel/exceptions-64s.S         | 38 +++++++++++++
 arch/powerpc/kernel/setup_64.c               | 58 ++++++++++++++++++++
 arch/powerpc/kernel/vmlinux.lds.S            |  7 +++
 arch/powerpc/lib/feature-fixups.c            | 54 ++++++++++++++++++
 arch/powerpc/platforms/powernv/setup.c       | 10 ++++
 arch/powerpc/platforms/pseries/setup.c       |  4 ++
 11 files changed, 199 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b19d872feb56..007f12c79365 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2196,6 +2196,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 					       spec_store_bypass_disable=off [X86]
 					       mds=off [X86]
 					       tsx_async_abort=off [X86]
+					       no_entry_flush [PPC]
 
 			auto (default)
 				Mitigate all CPU vulnerabilities, but leave SMT
@@ -2476,6 +2477,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	noefi		Disable EFI runtime services support.
 
+	no_entry_flush	[PPC] Don't flush the L1-D cache when entering the kernel.
+
 	noexec		[IA-64]
 
 	noexec		[X86]
diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/include/asm/exception-64s.h
index 26f00ab2d0c9..fbcfc722d109 100644
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -65,11 +65,18 @@
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
index 145a37ab2d3e..a963c26b2d34 100644
--- a/arch/powerpc/include/asm/feature-fixups.h
+++ b/arch/powerpc/include/asm/feature-fixups.h
@@ -200,6 +200,14 @@ label##3:					       	\
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
@@ -231,8 +239,10 @@ label##3:					       	\
 #ifndef __ASSEMBLY__
 
 extern long stf_barrier_fallback;
+extern long entry_flush_fallback;
 extern long __start___stf_entry_barrier_fixup, __stop___stf_entry_barrier_fixup;
 extern long __start___stf_exit_barrier_fixup, __stop___stf_exit_barrier_fixup;
+extern long __start___entry_flush_fixup, __stop___entry_flush_fixup;
 extern long __start___rfi_flush_fixup, __stop___rfi_flush_fixup;
 extern long __start___barrier_nospec_fixup, __stop___barrier_nospec_fixup;
 extern long __start__btb_flush_fixup, __stop__btb_flush_fixup;
diff --git a/arch/powerpc/include/asm/security_features.h b/arch/powerpc/include/asm/security_features.h
index ccf44c135389..082b56bf678d 100644
--- a/arch/powerpc/include/asm/security_features.h
+++ b/arch/powerpc/include/asm/security_features.h
@@ -84,12 +84,16 @@ static inline bool security_ftr_enabled(unsigned long feature)
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
index d299479c770b..26b55f23cf64 100644
--- a/arch/powerpc/include/asm/setup.h
+++ b/arch/powerpc/include/asm/setup.h
@@ -38,12 +38,15 @@ enum l1d_flush_type {
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
index 3d843e1a162c..7715fd89bb94 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1712,6 +1712,44 @@ hrfi_flush_fallback:
 	GET_SCRATCH0(r13);
 	hrfid
 
+	.globl entry_flush_fallback
+entry_flush_fallback:
+	std	r9,PACA_EXRFI+EX_R9(r13)
+	std	r10,PACA_EXRFI+EX_R10(r13)
+	std	r11,PACA_EXRFI+EX_R11(r13)
+	mfctr	r9
+	ld	r10,PACA_RFI_FLUSH_FALLBACK_AREA(r13)
+	ld	r11,PACA_L1D_FLUSH_SIZE(r13)
+	srdi	r11,r11,(7 + 3) /* 128 byte lines, unrolled 8x */
+	mtctr	r11
+	DCBT_STOP_ALL_STREAM_IDS(r11) /* Stop prefetch streams */
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
 /*
  * Hash table stuff
  */
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 11590f6cb2f9..cd405eaffa23 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -844,7 +844,9 @@ early_initcall(disable_hardlockup_detector);
 static enum l1d_flush_type enabled_flush_types;
 static void *l1d_flush_fallback_area;
 static bool no_rfi_flush;
+static bool no_entry_flush;
 bool rfi_flush;
+bool entry_flush;
 
 static int __init handle_no_rfi_flush(char *p)
 {
@@ -854,6 +856,14 @@ static int __init handle_no_rfi_flush(char *p)
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
@@ -885,6 +895,18 @@ void rfi_flush_enable(bool enable)
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
@@ -930,6 +952,15 @@ void setup_rfi_flush(enum l1d_flush_type types, bool enable)
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
@@ -957,9 +988,36 @@ static int rfi_flush_get(void *data, u64 *val)
 
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
index 9b1e297be673..43a8cfa5e2fb 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -80,6 +80,13 @@ SECTIONS
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
index 7bdfc19a491d..4f13bba13596 100644
--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -229,6 +229,60 @@ void do_stf_barrier_fixups(enum stf_barrier_type types)
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
index e14b52c7ebd8..fe3f1f438f78 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -124,12 +124,22 @@ static void pnv_setup_rfi_flush(void)
 			type = L1D_FLUSH_ORI;
 	}
 
+	/*
+	 * 4.4 doesn't support Power9 bare metal, so we don't need to flush
+	 * here - the flush fixes a P9 specific vulnerability.
+	 */
+	security_ftr_clear(SEC_FTR_L1D_FLUSH_ENTRY);
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
index 88fcf6a95fa6..69f1808ecbd2 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -584,6 +584,10 @@ void pseries_setup_rfi_flush(void)
 
 	setup_rfi_flush(types, enable);
 	setup_count_cache_flush();
+
+	enable = security_ftr_enabled(SEC_FTR_FAVOUR_SECURITY) &&
+		 security_ftr_enabled(SEC_FTR_L1D_FLUSH_ENTRY);
+	setup_entry_flush(enable);
 }
 
 static void __init pSeries_setup_arch(void)
-- 
2.25.1

