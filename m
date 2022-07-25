Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77F457FC7D
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 11:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiGYJfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 05:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiGYJfF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 05:35:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9F616586
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 02:35:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08CE9B80E1A
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 09:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D80C341C6;
        Mon, 25 Jul 2022 09:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658741700;
        bh=YR/+DyPO9eimhtPZY18Grm5wzbuzs5X6Lazv+dwX0Ng=;
        h=Subject:To:Cc:From:Date:From;
        b=RCIVs+C2oEzdVSwlWNW0wlJ79osv45Qhuug8FlJR3b2aMe7B5NA0q9dBU/6qYw84n
         aI4auMG89bKXpT4dHdlkE0pPlzfNNBCUtzb/JOFXJveG+DyNxqwbect+vAiKIkV7h7
         O5GITgsc30q1XCRx+kikC9UCRDjcGAJWPBuyUfJQ=
Subject: FAILED: patch "[PATCH] x86/retbleed: Add fine grained Kconfig knobs" failed to apply to 5.15-stable tree
To:     peterz@infradead.org, bp@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jul 2022 11:34:48 +0200
Message-ID: <16587416884914@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f43b9876e857c739d407bc56df288b0ebe1a9164 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon, 27 Jun 2022 22:21:17 +0000
Subject: [PATCH] x86/retbleed: Add fine grained Kconfig knobs

Do fine-grained Kconfig for all the various retbleed parts.

NOTE: if your compiler doesn't support return thunks this will
silently 'upgrade' your mitigation to IBPB, you might not like this.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e35eecfb74f2..e58798f636d4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -462,32 +462,6 @@ config GOLDFISH
 	def_bool y
 	depends on X86_GOLDFISH
 
-config RETPOLINE
-	bool "Avoid speculative indirect branches in kernel"
-	select OBJTOOL if HAVE_OBJTOOL
-	default y
-	help
-	  Compile kernel with the retpoline compiler options to guard against
-	  kernel-to-user data leaks by avoiding speculative indirect
-	  branches. Requires a compiler with -mindirect-branch=thunk-extern
-	  support for full protection. The kernel may run slower.
-
-config CC_HAS_SLS
-	def_bool $(cc-option,-mharden-sls=all)
-
-config CC_HAS_RETURN_THUNK
-	def_bool $(cc-option,-mfunction-return=thunk-extern)
-
-config SLS
-	bool "Mitigate Straight-Line-Speculation"
-	depends on CC_HAS_SLS && X86_64
-	select OBJTOOL if HAVE_OBJTOOL
-	default n
-	help
-	  Compile the kernel with straight-line-speculation options to guard
-	  against straight line speculation. The kernel image might be slightly
-	  larger.
-
 config X86_CPU_RESCTRL
 	bool "x86 CPU resource control support"
 	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
@@ -2456,6 +2430,91 @@ source "kernel/livepatch/Kconfig"
 
 endmenu
 
+config CC_HAS_SLS
+	def_bool $(cc-option,-mharden-sls=all)
+
+config CC_HAS_RETURN_THUNK
+	def_bool $(cc-option,-mfunction-return=thunk-extern)
+
+menuconfig SPECULATION_MITIGATIONS
+	bool "Mitigations for speculative execution vulnerabilities"
+	default y
+	help
+	  Say Y here to enable options which enable mitigations for
+	  speculative execution hardware vulnerabilities.
+
+	  If you say N, all mitigations will be disabled. You really
+	  should know what you are doing to say so.
+
+if SPECULATION_MITIGATIONS
+
+config PAGE_TABLE_ISOLATION
+	bool "Remove the kernel mapping in user mode"
+	default y
+	depends on (X86_64 || X86_PAE)
+	help
+	  This feature reduces the number of hardware side channels by
+	  ensuring that the majority of kernel addresses are not mapped
+	  into userspace.
+
+	  See Documentation/x86/pti.rst for more details.
+
+config RETPOLINE
+	bool "Avoid speculative indirect branches in kernel"
+	select OBJTOOL if HAVE_OBJTOOL
+	default y
+	help
+	  Compile kernel with the retpoline compiler options to guard against
+	  kernel-to-user data leaks by avoiding speculative indirect
+	  branches. Requires a compiler with -mindirect-branch=thunk-extern
+	  support for full protection. The kernel may run slower.
+
+config RETHUNK
+	bool "Enable return-thunks"
+	depends on RETPOLINE && CC_HAS_RETURN_THUNK
+	select OBJTOOL if HAVE_OBJTOOL
+	default y
+	help
+	  Compile the kernel with the return-thunks compiler option to guard
+	  against kernel-to-user data leaks by avoiding return speculation.
+	  Requires a compiler with -mfunction-return=thunk-extern
+	  support for full protection. The kernel may run slower.
+
+config CPU_UNRET_ENTRY
+	bool "Enable UNRET on kernel entry"
+	depends on CPU_SUP_AMD && RETHUNK
+	default y
+	help
+	  Compile the kernel with support for the retbleed=unret mitigation.
+
+config CPU_IBPB_ENTRY
+	bool "Enable IBPB on kernel entry"
+	depends on CPU_SUP_AMD
+	default y
+	help
+	  Compile the kernel with support for the retbleed=ibpb mitigation.
+
+config CPU_IBRS_ENTRY
+	bool "Enable IBRS on kernel entry"
+	depends on CPU_SUP_INTEL
+	default y
+	help
+	  Compile the kernel with support for the spectre_v2=ibrs mitigation.
+	  This mitigates both spectre_v2 and retbleed at great cost to
+	  performance.
+
+config SLS
+	bool "Mitigate Straight-Line-Speculation"
+	depends on CC_HAS_SLS && X86_64
+	select OBJTOOL if HAVE_OBJTOOL
+	default n
+	help
+	  Compile the kernel with straight-line-speculation options to guard
+	  against straight line speculation. The kernel image might be slightly
+	  larger.
+
+endif
+
 config ARCH_HAS_ADD_PAGES
 	def_bool y
 	depends on ARCH_ENABLE_MEMORY_HOTPLUG
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 6e16057737e5..1f40dad30d50 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -15,14 +15,18 @@ endif
 ifdef CONFIG_CC_IS_GCC
 RETPOLINE_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-extern -mindirect-branch-register)
 RETPOLINE_CFLAGS	+= $(call cc-option,-mindirect-branch-cs-prefix)
-RETPOLINE_CFLAGS	+= $(call cc-option,-mfunction-return=thunk-extern)
 RETPOLINE_VDSO_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-inline -mindirect-branch-register)
 endif
 ifdef CONFIG_CC_IS_CLANG
 RETPOLINE_CFLAGS	:= -mretpoline-external-thunk
 RETPOLINE_VDSO_CFLAGS	:= -mretpoline
-RETPOLINE_CFLAGS	+= $(call cc-option,-mfunction-return=thunk-extern)
 endif
+
+ifdef CONFIG_RETHUNK
+RETHUNK_CFLAGS		:= -mfunction-return=thunk-extern
+RETPOLINE_CFLAGS	+= $(RETHUNK_CFLAGS)
+endif
+
 export RETPOLINE_CFLAGS
 export RETPOLINE_VDSO_CFLAGS
 
diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 074d04e434de..f6907627172b 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -297,6 +297,7 @@ For 32-bit we have the following conventions - kernel is built with
  * Assumes x86_spec_ctrl_{base,current} to have SPEC_CTRL_IBRS set.
  */
 .macro IBRS_ENTER save_reg
+#ifdef CONFIG_CPU_IBRS_ENTRY
 	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_KERNEL_IBRS
 	movl	$MSR_IA32_SPEC_CTRL, %ecx
 
@@ -317,6 +318,7 @@ For 32-bit we have the following conventions - kernel is built with
 	shr	$32, %rdx
 	wrmsr
 .Lend_\@:
+#endif
 .endm
 
 /*
@@ -324,6 +326,7 @@ For 32-bit we have the following conventions - kernel is built with
  * regs. Must be called after the last RET.
  */
 .macro IBRS_EXIT save_reg
+#ifdef CONFIG_CPU_IBRS_ENTRY
 	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_KERNEL_IBRS
 	movl	$MSR_IA32_SPEC_CTRL, %ecx
 
@@ -338,6 +341,7 @@ For 32-bit we have the following conventions - kernel is built with
 	shr	$32, %rdx
 	wrmsr
 .Lend_\@:
+#endif
 .endm
 
 /*
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index db75da511a36..33d2cd04d254 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -54,9 +54,19 @@
 # define DISABLE_RETPOLINE	0
 #else
 # define DISABLE_RETPOLINE	((1 << (X86_FEATURE_RETPOLINE & 31)) | \
-				 (1 << (X86_FEATURE_RETPOLINE_LFENCE & 31)) | \
-				 (1 << (X86_FEATURE_RETHUNK & 31)) | \
-				 (1 << (X86_FEATURE_UNRET & 31)))
+				 (1 << (X86_FEATURE_RETPOLINE_LFENCE & 31)))
+#endif
+
+#ifdef CONFIG_RETHUNK
+# define DISABLE_RETHUNK	0
+#else
+# define DISABLE_RETHUNK	(1 << (X86_FEATURE_RETHUNK & 31))
+#endif
+
+#ifdef CONFIG_CPU_UNRET_ENTRY
+# define DISABLE_UNRET		0
+#else
+# define DISABLE_UNRET		(1 << (X86_FEATURE_UNRET & 31))
 #endif
 
 #ifdef CONFIG_INTEL_IOMMU_SVM
@@ -91,7 +101,7 @@
 #define DISABLED_MASK8	(DISABLE_TDX_GUEST)
 #define DISABLED_MASK9	(DISABLE_SGX)
 #define DISABLED_MASK10	0
-#define DISABLED_MASK11	(DISABLE_RETPOLINE)
+#define DISABLED_MASK11	(DISABLE_RETPOLINE|DISABLE_RETHUNK|DISABLE_UNRET)
 #define DISABLED_MASK12	0
 #define DISABLED_MASK13	0
 #define DISABLED_MASK14	0
diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index e3ae331cabb1..73ca20049835 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -19,7 +19,7 @@
 #define __ALIGN_STR	__stringify(__ALIGN)
 #endif
 
-#if defined(CONFIG_RETPOLINE) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
+#if defined(CONFIG_RETHUNK) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
 #define RET	jmp __x86_return_thunk
 #else /* CONFIG_RETPOLINE */
 #ifdef CONFIG_SLS
@@ -31,7 +31,7 @@
 
 #else /* __ASSEMBLY__ */
 
-#if defined(CONFIG_RETPOLINE) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
+#if defined(CONFIG_RETHUNK) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
 #define ASM_RET	"jmp __x86_return_thunk\n\t"
 #else /* CONFIG_RETPOLINE */
 #ifdef CONFIG_SLS
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index ccde87e6eabb..bb05ed4f46bd 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -127,6 +127,12 @@
 .Lskip_rsb_\@:
 .endm
 
+#ifdef CONFIG_CPU_UNRET_ENTRY
+#define CALL_ZEN_UNTRAIN_RET	"call zen_untrain_ret"
+#else
+#define CALL_ZEN_UNTRAIN_RET	""
+#endif
+
 /*
  * Mitigate RETBleed for AMD/Hygon Zen uarch. Requires KERNEL CR3 because the
  * return thunk isn't mapped into the userspace tables (then again, AMD
@@ -139,10 +145,10 @@
  * where we have a stack but before any RET instruction.
  */
 .macro UNTRAIN_RET
-#ifdef CONFIG_RETPOLINE
+#if defined(CONFIG_CPU_UNRET_ENTRY) || defined(CONFIG_CPU_IBPB_ENTRY)
 	ANNOTATE_UNRET_END
 	ALTERNATIVE_2 "",						\
-	              "call zen_untrain_ret", X86_FEATURE_UNRET,	\
+	              CALL_ZEN_UNTRAIN_RET, X86_FEATURE_UNRET,		\
 		      "call entry_ibpb", X86_FEATURE_ENTRY_IBPB
 #endif
 .endm
diff --git a/arch/x86/include/asm/static_call.h b/arch/x86/include/asm/static_call.h
index 70cc9ccb8029..343b722ccaf2 100644
--- a/arch/x86/include/asm/static_call.h
+++ b/arch/x86/include/asm/static_call.h
@@ -46,7 +46,7 @@
 #define ARCH_DEFINE_STATIC_CALL_TRAMP(name, func)			\
 	__ARCH_DEFINE_STATIC_CALL_TRAMP(name, ".byte 0xe9; .long " #func " - (. + 4)")
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_RETHUNK
 #define ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)			\
 	__ARCH_DEFINE_STATIC_CALL_TRAMP(name, "jmp __x86_return_thunk")
 #else
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index cf447ee18b3c..d6858533e6e5 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -508,6 +508,7 @@ void __init_or_module noinline apply_retpolines(s32 *start, s32 *end)
 	}
 }
 
+#ifdef CONFIG_RETHUNK
 /*
  * Rewrite the compiler generated return thunk tail-calls.
  *
@@ -569,6 +570,10 @@ void __init_or_module noinline apply_returns(s32 *start, s32 *end)
 		}
 	}
 }
+#else
+void __init_or_module noinline apply_returns(s32 *start, s32 *end) { }
+#endif /* CONFIG_RETHUNK */
+
 #else /* !CONFIG_RETPOLINE || !CONFIG_OBJTOOL */
 
 void __init_or_module noinline apply_retpolines(s32 *start, s32 *end) { }
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 9cfd11f7ba11..35d5288394cb 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -864,6 +864,7 @@ static void init_amd_bd(struct cpuinfo_x86 *c)
 
 void init_spectral_chicken(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_CPU_UNRET_ENTRY
 	u64 value;
 
 	/*
@@ -880,6 +881,7 @@ void init_spectral_chicken(struct cpuinfo_x86 *c)
 			wrmsrl_safe(MSR_ZEN2_SPECTRAL_CHICKEN, value);
 		}
 	}
+#endif
 }
 
 static void init_amd_zn(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 182f8b2e8a3c..cf08a1b8f3c7 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -842,7 +842,6 @@ static int __init retbleed_parse_cmdline(char *str)
 early_param("retbleed", retbleed_parse_cmdline);
 
 #define RETBLEED_UNTRAIN_MSG "WARNING: BTB untrained return thunk mitigation is only effective on AMD/Hygon!\n"
-#define RETBLEED_COMPILER_MSG "WARNING: kernel not compiled with RETPOLINE or -mfunction-return capable compiler; falling back to IBPB!\n"
 #define RETBLEED_INTEL_MSG "WARNING: Spectre v2 mitigation leaves CPU vulnerable to RETBleed attacks, data leaks possible!\n"
 
 static void __init retbleed_select_mitigation(void)
@@ -857,18 +856,33 @@ static void __init retbleed_select_mitigation(void)
 		return;
 
 	case RETBLEED_CMD_UNRET:
-		retbleed_mitigation = RETBLEED_MITIGATION_UNRET;
+		if (IS_ENABLED(CONFIG_CPU_UNRET_ENTRY)) {
+			retbleed_mitigation = RETBLEED_MITIGATION_UNRET;
+		} else {
+			pr_err("WARNING: kernel not compiled with CPU_UNRET_ENTRY.\n");
+			goto do_cmd_auto;
+		}
 		break;
 
 	case RETBLEED_CMD_IBPB:
-		retbleed_mitigation = RETBLEED_MITIGATION_IBPB;
+		if (IS_ENABLED(CONFIG_CPU_IBPB_ENTRY)) {
+			retbleed_mitigation = RETBLEED_MITIGATION_IBPB;
+		} else {
+			pr_err("WARNING: kernel not compiled with CPU_IBPB_ENTRY.\n");
+			goto do_cmd_auto;
+		}
 		break;
 
+do_cmd_auto:
 	case RETBLEED_CMD_AUTO:
 	default:
 		if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
-		    boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)
-			retbleed_mitigation = RETBLEED_MITIGATION_UNRET;
+		    boot_cpu_data.x86_vendor == X86_VENDOR_HYGON) {
+			if (IS_ENABLED(CONFIG_CPU_UNRET_ENTRY))
+				retbleed_mitigation = RETBLEED_MITIGATION_UNRET;
+			else if (IS_ENABLED(CONFIG_CPU_IBPB_ENTRY))
+				retbleed_mitigation = RETBLEED_MITIGATION_IBPB;
+		}
 
 		/*
 		 * The Intel mitigation (IBRS or eIBRS) was already selected in
@@ -881,14 +895,6 @@ static void __init retbleed_select_mitigation(void)
 
 	switch (retbleed_mitigation) {
 	case RETBLEED_MITIGATION_UNRET:
-
-		if (!IS_ENABLED(CONFIG_RETPOLINE) ||
-		    !IS_ENABLED(CONFIG_CC_HAS_RETURN_THUNK)) {
-			pr_err(RETBLEED_COMPILER_MSG);
-			retbleed_mitigation = RETBLEED_MITIGATION_IBPB;
-			goto retbleed_force_ibpb;
-		}
-
 		setup_force_cpu_cap(X86_FEATURE_RETHUNK);
 		setup_force_cpu_cap(X86_FEATURE_UNRET);
 
@@ -900,7 +906,6 @@ static void __init retbleed_select_mitigation(void)
 		break;
 
 	case RETBLEED_MITIGATION_IBPB:
-retbleed_force_ibpb:
 		setup_force_cpu_cap(X86_FEATURE_ENTRY_IBPB);
 		mitigate_smt = true;
 		break;
@@ -1271,6 +1276,12 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
 		return SPECTRE_V2_CMD_AUTO;
 	}
 
+	if (cmd == SPECTRE_V2_CMD_IBRS && !IS_ENABLED(CONFIG_CPU_IBRS_ENTRY)) {
+		pr_err("%s selected but not compiled in. Switching to AUTO select\n",
+		       mitigation_options[i].option);
+		return SPECTRE_V2_CMD_AUTO;
+	}
+
 	if (cmd == SPECTRE_V2_CMD_IBRS && boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
 		pr_err("%s selected but not Intel CPU. Switching to AUTO select\n",
 		       mitigation_options[i].option);
@@ -1328,7 +1339,8 @@ static void __init spectre_v2_select_mitigation(void)
 			break;
 		}
 
-		if (boot_cpu_has_bug(X86_BUG_RETBLEED) &&
+		if (IS_ENABLED(CONFIG_CPU_IBRS_ENTRY) &&
+		    boot_cpu_has_bug(X86_BUG_RETBLEED) &&
 		    retbleed_cmd != RETBLEED_CMD_OFF &&
 		    boot_cpu_has(X86_FEATURE_IBRS) &&
 		    boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) {
diff --git a/arch/x86/kernel/static_call.c b/arch/x86/kernel/static_call.c
index fe21fe778185..be7038a0da4d 100644
--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -126,7 +126,7 @@ void arch_static_call_transform(void *site, void *tramp, void *func, bool tail)
 }
 EXPORT_SYMBOL_GPL(arch_static_call_transform);
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_RETHUNK
 /*
  * This is called by apply_returns() to fix up static call trampolines,
  * specifically ARCH_DEFINE_STATIC_CALL_NULL_TRAMP which is recorded as
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index b01437015f99..db96bf7d1122 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -439,10 +439,10 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
  *
  * ENDBR			[4 bytes; CONFIG_X86_KERNEL_IBT]
  * SETcc %al			[3 bytes]
- * RET | JMP __x86_return_thunk	[1,5 bytes; CONFIG_RETPOLINE]
+ * RET | JMP __x86_return_thunk	[1,5 bytes; CONFIG_RETHUNK]
  * INT3				[1 byte; CONFIG_SLS]
  */
-#define RET_LENGTH	(1 + (4 * IS_ENABLED(CONFIG_RETPOLINE)) + \
+#define RET_LENGTH	(1 + (4 * IS_ENABLED(CONFIG_RETHUNK)) + \
 			 IS_ENABLED(CONFIG_SLS))
 #define SETCC_LENGTH	(ENDBR_INSN_SIZE + 3 + RET_LENGTH)
 #define SETCC_ALIGN	(4 << ((SETCC_LENGTH > 4) & 1) << ((SETCC_LENGTH > 8) & 1))
diff --git a/arch/x86/lib/retpoline.S b/arch/x86/lib/retpoline.S
index fdd16163b996..073289a55f84 100644
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -72,6 +72,8 @@ SYM_CODE_END(__x86_indirect_thunk_array)
  * This function name is magical and is used by -mfunction-return=thunk-extern
  * for the compiler to generate JMPs to it.
  */
+#ifdef CONFIG_RETHUNK
+
 	.section .text.__x86.return_thunk
 
 /*
@@ -136,3 +138,5 @@ SYM_FUNC_END(zen_untrain_ret)
 __EXPORT_THUNK(zen_untrain_ret)
 
 EXPORT_SYMBOL(__x86_return_thunk)
+
+#endif /* CONFIG_RETHUNK */
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index d1425778664b..3fb6a99e78c4 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -236,6 +236,7 @@ objtool_args =								\
 	$(if $(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL), --mcount)		\
 	$(if $(CONFIG_UNWINDER_ORC), --orc)				\
 	$(if $(CONFIG_RETPOLINE), --retpoline)				\
+	$(if $(CONFIG_RETHUNK), --rethunk)				\
 	$(if $(CONFIG_SLS), --sls)					\
 	$(if $(CONFIG_STACK_VALIDATION), --stackval)			\
 	$(if $(CONFIG_HAVE_STATIC_CALL_INLINE), --static-call)		\
diff --git a/scripts/Makefile.vmlinux_o b/scripts/Makefile.vmlinux_o
index bc67748044a6..84019814f33f 100644
--- a/scripts/Makefile.vmlinux_o
+++ b/scripts/Makefile.vmlinux_o
@@ -44,7 +44,7 @@ objtool-enabled := $(or $(delay-objtool),$(CONFIG_NOINSTR_VALIDATION))
 
 objtool_args := \
 	$(if $(delay-objtool),$(objtool_args)) \
-	$(if $(CONFIG_NOINSTR_VALIDATION), --noinstr $(if $(CONFIG_RETPOLINE), --unret)) \
+	$(if $(CONFIG_NOINSTR_VALIDATION), --noinstr $(if $(CONFIG_CPU_UNRET_ENTRY), --unret)) \
 	$(if $(CONFIG_GCOV_KERNEL), --no-unreachable) \
 	--link
 
diff --git a/security/Kconfig b/security/Kconfig
index f29e4c656983..e6db09a779b7 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -54,17 +54,6 @@ config SECURITY_NETWORK
 	  implement socket and networking access controls.
 	  If you are unsure how to answer this question, answer N.
 
-config PAGE_TABLE_ISOLATION
-	bool "Remove the kernel mapping in user mode"
-	default y
-	depends on (X86_64 || X86_PAE) && !UML
-	help
-	  This feature reduces the number of hardware side channels by
-	  ensuring that the majority of kernel addresses are not mapped
-	  into userspace.
-
-	  See Documentation/x86/pti.rst for more details.
-
 config SECURITY_INFINIBAND
 	bool "Infiniband Security Hooks"
 	depends on SECURITY && INFINIBAND
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index c063e1ff96b2..24fbe803a0d3 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -68,6 +68,7 @@ const struct option check_options[] = {
 	OPT_BOOLEAN('n', "noinstr", &opts.noinstr, "validate noinstr rules"),
 	OPT_BOOLEAN('o', "orc", &opts.orc, "generate ORC metadata"),
 	OPT_BOOLEAN('r', "retpoline", &opts.retpoline, "validate and annotate retpoline usage"),
+	OPT_BOOLEAN(0,   "rethunk", &opts.rethunk, "validate and annotate rethunk usage"),
 	OPT_BOOLEAN(0,   "unret", &opts.unret, "validate entry unret placement"),
 	OPT_BOOLEAN('l', "sls", &opts.sls, "validate straight-line-speculation mitigations"),
 	OPT_BOOLEAN('s', "stackval", &opts.stackval, "validate frame pointer rules"),
@@ -124,6 +125,7 @@ static bool opts_valid(void)
 	    opts.noinstr		||
 	    opts.orc			||
 	    opts.retpoline		||
+	    opts.rethunk		||
 	    opts.sls			||
 	    opts.stackval		||
 	    opts.static_call		||
@@ -136,6 +138,11 @@ static bool opts_valid(void)
 		return true;
 	}
 
+	if (opts.unret && !opts.rethunk) {
+		ERROR("--unret requires --rethunk");
+		return false;
+	}
+
 	if (opts.dump_orc)
 		return true;
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index ddfdd138cc2a..7bebdb8867cd 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3732,8 +3732,11 @@ static int validate_retpoline(struct objtool_file *file)
 			continue;
 
 		if (insn->type == INSN_RETURN) {
-			WARN_FUNC("'naked' return found in RETPOLINE build",
-				  insn->sec, insn->offset);
+			if (opts.rethunk) {
+				WARN_FUNC("'naked' return found in RETHUNK build",
+					  insn->sec, insn->offset);
+			} else
+				continue;
 		} else {
 			WARN_FUNC("indirect %s found in RETPOLINE build",
 				  insn->sec, insn->offset,
@@ -4264,7 +4267,9 @@ int check(struct objtool_file *file)
 		if (ret < 0)
 			goto out;
 		warnings += ret;
+	}
 
+	if (opts.rethunk) {
 		ret = create_return_sites_sections(file);
 		if (ret < 0)
 			goto out;
diff --git a/tools/objtool/include/objtool/builtin.h b/tools/objtool/include/objtool/builtin.h
index 0c476b0b40a3..42a52f1a0add 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -19,6 +19,7 @@ struct opts {
 	bool noinstr;
 	bool orc;
 	bool retpoline;
+	bool rethunk;
 	bool unret;
 	bool sls;
 	bool stackval;

