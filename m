Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754B657DE04
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236127AbiGVJZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236056AbiGVJYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:24:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6E3AFB4F;
        Fri, 22 Jul 2022 02:16:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BEADB827C8;
        Fri, 22 Jul 2022 09:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370B4C341C6;
        Fri, 22 Jul 2022 09:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481360;
        bh=/hAk18avzkknfn109hYoOXcNDxv2t4pM/+4dlQSCuxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wUxe+OfbCvdPV5QP5jydbR0yL9UC90usvVKJwoWASsO2BvJjAaSqQPxSncn2U5VQi
         t3B/kW+H0+1JjEnW6tAZtTT7xwblSjS0tZ2TdBnngAvAexPkMJXQfGQ6rgBZqX+6+f
         L0+n3ahhy7U+hn5oSQQbJOv/3xNVm6P2lvOHlcAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 72/89] x86/retbleed: Add fine grained Kconfig knobs
Date:   Fri, 22 Jul 2022 11:11:46 +0200
Message-Id: <20220722091137.375655554@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
References: <20220722091133.320803732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit f43b9876e857c739d407bc56df288b0ebe1a9164 upstream.

Do fine-grained Kconfig for all the various retbleed parts.

NOTE: if your compiler doesn't support return thunks this will
silently 'upgrade' your mitigation to IBPB, you might not like this.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: there is no CONFIG_OBJTOOL]
[cascardo: objtool calling and option parsing has changed]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile                                 |    8 +-
 arch/x86/Kconfig                         |  106 +++++++++++++++++++++++--------
 arch/x86/entry/calling.h                 |    4 +
 arch/x86/include/asm/disabled-features.h |   18 ++++-
 arch/x86/include/asm/linkage.h           |    4 -
 arch/x86/include/asm/nospec-branch.h     |   10 ++
 arch/x86/include/asm/static_call.h       |    2 
 arch/x86/kernel/alternative.c            |    5 +
 arch/x86/kernel/cpu/amd.c                |    2 
 arch/x86/kernel/cpu/bugs.c               |   42 +++++++-----
 arch/x86/kernel/static_call.c            |    2 
 arch/x86/kvm/emulate.c                   |    4 -
 arch/x86/lib/retpoline.S                 |    4 +
 scripts/Makefile.build                   |    1 
 scripts/link-vmlinux.sh                  |    2 
 security/Kconfig                         |   11 ---
 tools/objtool/builtin-check.c            |    3 
 tools/objtool/check.c                    |    9 ++
 tools/objtool/include/objtool/builtin.h  |    2 
 19 files changed, 170 insertions(+), 69 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -687,14 +687,18 @@ endif
 
 ifdef CONFIG_CC_IS_GCC
 RETPOLINE_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-extern -mindirect-branch-register)
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
+RETHUNK_CFLAGS         := -mfunction-return=thunk-extern
+RETPOLINE_CFLAGS       += $(RETHUNK_CFLAGS)
+endif
+
 export RETPOLINE_CFLAGS
 export RETPOLINE_VDSO_CFLAGS
 
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -459,30 +459,6 @@ config GOLDFISH
 	def_bool y
 	depends on X86_GOLDFISH
 
-config RETPOLINE
-	bool "Avoid speculative indirect branches in kernel"
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
-	default n
-	help
-	  Compile the kernel with straight-line-speculation options to guard
-	  against straight line speculation. The kernel image might be slightly
-	  larger.
-
 config X86_CPU_RESCTRL
 	bool "x86 CPU resource control support"
 	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
@@ -2410,6 +2386,88 @@ source "kernel/livepatch/Kconfig"
 
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
 	depends on X86_64 && ARCH_ENABLE_MEMORY_HOTPLUG
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -296,6 +296,7 @@ For 32-bit we have the following convent
  * Assumes x86_spec_ctrl_{base,current} to have SPEC_CTRL_IBRS set.
  */
 .macro IBRS_ENTER save_reg
+#ifdef CONFIG_CPU_IBRS_ENTRY
 	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_KERNEL_IBRS
 	movl	$MSR_IA32_SPEC_CTRL, %ecx
 
@@ -316,6 +317,7 @@ For 32-bit we have the following convent
 	shr	$32, %rdx
 	wrmsr
 .Lend_\@:
+#endif
 .endm
 
 /*
@@ -323,6 +325,7 @@ For 32-bit we have the following convent
  * regs. Must be called after the last RET.
  */
 .macro IBRS_EXIT save_reg
+#ifdef CONFIG_CPU_IBRS_ENTRY
 	ALTERNATIVE "jmp .Lend_\@", "", X86_FEATURE_KERNEL_IBRS
 	movl	$MSR_IA32_SPEC_CTRL, %ecx
 
@@ -337,6 +340,7 @@ For 32-bit we have the following convent
 	shr	$32, %rdx
 	wrmsr
 .Lend_\@:
+#endif
 .endm
 
 /*
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -60,9 +60,19 @@
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
 
 /* Force disable because it's broken beyond repair */
@@ -88,7 +98,7 @@
 #define DISABLED_MASK8	0
 #define DISABLED_MASK9	(DISABLE_SMAP|DISABLE_SGX)
 #define DISABLED_MASK10	0
-#define DISABLED_MASK11	(DISABLE_RETPOLINE)
+#define DISABLED_MASK11	(DISABLE_RETPOLINE|DISABLE_RETHUNK|DISABLE_UNRET)
 #define DISABLED_MASK12	0
 #define DISABLED_MASK13	0
 #define DISABLED_MASK14	0
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -18,7 +18,7 @@
 #define __ALIGN_STR	__stringify(__ALIGN)
 #endif
 
-#if defined(CONFIG_RETPOLINE) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
+#if defined(CONFIG_RETHUNK) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
 #define RET	jmp __x86_return_thunk
 #else /* CONFIG_RETPOLINE */
 #ifdef CONFIG_SLS
@@ -30,7 +30,7 @@
 
 #else /* __ASSEMBLY__ */
 
-#if defined(CONFIG_RETPOLINE) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
+#if defined(CONFIG_RETHUNK) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
 #define ASM_RET	"jmp __x86_return_thunk\n\t"
 #else /* CONFIG_RETPOLINE */
 #ifdef CONFIG_SLS
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
--- a/arch/x86/include/asm/static_call.h
+++ b/arch/x86/include/asm/static_call.h
@@ -44,7 +44,7 @@
 #define ARCH_DEFINE_STATIC_CALL_TRAMP(name, func)			\
 	__ARCH_DEFINE_STATIC_CALL_TRAMP(name, ".byte 0xe9; .long " #func " - (. + 4)")
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_RETHUNK
 #define ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)			\
 	__ARCH_DEFINE_STATIC_CALL_TRAMP(name, "jmp __x86_return_thunk")
 #else
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -507,6 +507,7 @@ void __init_or_module noinline apply_ret
 	}
 }
 
+#ifdef CONFIG_RETHUNK
 /*
  * Rewrite the compiler generated return thunk tail-calls.
  *
@@ -568,6 +569,10 @@ void __init_or_module noinline apply_ret
 		}
 	}
 }
+#else
+void __init_or_module noinline apply_returns(s32 *start, s32 *end) { }
+#endif /* CONFIG_RETHUNK */
+
 #else /* !RETPOLINES || !CONFIG_STACK_VALIDATION */
 
 void __init_or_module noinline apply_retpolines(s32 *start, s32 *end) { }
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -888,6 +888,7 @@ static void init_amd_bd(struct cpuinfo_x
 
 void init_spectral_chicken(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_CPU_UNRET_ENTRY
 	u64 value;
 
 	/*
@@ -904,6 +905,7 @@ void init_spectral_chicken(struct cpuinf
 			wrmsrl_safe(MSR_ZEN2_SPECTRAL_CHICKEN, value);
 		}
 	}
+#endif
 }
 
 static void init_amd_zn(struct cpuinfo_x86 *c)
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -835,7 +835,6 @@ static int __init retbleed_parse_cmdline
 early_param("retbleed", retbleed_parse_cmdline);
 
 #define RETBLEED_UNTRAIN_MSG "WARNING: BTB untrained return thunk mitigation is only effective on AMD/Hygon!\n"
-#define RETBLEED_COMPILER_MSG "WARNING: kernel not compiled with RETPOLINE or -mfunction-return capable compiler; falling back to IBPB!\n"
 #define RETBLEED_INTEL_MSG "WARNING: Spectre v2 mitigation leaves CPU vulnerable to RETBleed attacks, data leaks possible!\n"
 
 static void __init retbleed_select_mitigation(void)
@@ -850,18 +849,33 @@ static void __init retbleed_select_mitig
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
@@ -874,14 +888,6 @@ static void __init retbleed_select_mitig
 
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
 
@@ -893,7 +899,6 @@ static void __init retbleed_select_mitig
 		break;
 
 	case RETBLEED_MITIGATION_IBPB:
-retbleed_force_ibpb:
 		setup_force_cpu_cap(X86_FEATURE_ENTRY_IBPB);
 		mitigate_smt = true;
 		break;
@@ -1264,6 +1269,12 @@ static enum spectre_v2_mitigation_cmd __
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
@@ -1321,7 +1332,8 @@ static void __init spectre_v2_select_mit
 			break;
 		}
 
-		if (boot_cpu_has_bug(X86_BUG_RETBLEED) &&
+		if (IS_ENABLED(CONFIG_CPU_IBRS_ENTRY) &&
+		    boot_cpu_has_bug(X86_BUG_RETBLEED) &&
 		    retbleed_cmd != RETBLEED_CMD_OFF &&
 		    boot_cpu_has(X86_FEATURE_IBRS) &&
 		    boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) {
--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -120,7 +120,7 @@ void arch_static_call_transform(void *si
 }
 EXPORT_SYMBOL_GPL(arch_static_call_transform);
 
-#ifdef CONFIG_RETPOLINE
+#ifdef CONFIG_RETHUNK
 /*
  * This is called by apply_returns() to fix up static call trampolines,
  * specifically ARCH_DEFINE_STATIC_CALL_NULL_TRAMP which is recorded as
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -434,10 +434,10 @@ static int fastop(struct x86_emulate_ctx
  * Depending on .config the SETcc functions look like:
  *
  * SETcc %al			[3 bytes]
- * RET | JMP __x86_return_thunk	[1,5 bytes; CONFIG_RETPOLINE]
+ * RET | JMP __x86_return_thunk	[1,5 bytes; CONFIG_RETHUNK]
  * INT3				[1 byte; CONFIG_SLS]
  */
-#define RET_LENGTH	(1 + (4 * IS_ENABLED(CONFIG_RETPOLINE)) + \
+#define RET_LENGTH	(1 + (4 * IS_ENABLED(CONFIG_RETHUNK)) + \
 			 IS_ENABLED(CONFIG_SLS))
 #define SETCC_LENGTH	(3 + RET_LENGTH)
 #define SETCC_ALIGN	(4 << ((SETCC_LENGTH > 4) & 1) << ((SETCC_LENGTH > 8) & 1))
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -71,6 +71,8 @@ SYM_CODE_END(__x86_indirect_thunk_array)
  * This function name is magical and is used by -mfunction-return=thunk-extern
  * for the compiler to generate JMPs to it.
  */
+#ifdef CONFIG_RETHUNK
+
 	.section .text.__x86.return_thunk
 
 /*
@@ -135,3 +137,5 @@ SYM_FUNC_END(zen_untrain_ret)
 __EXPORT_THUNK(zen_untrain_ret)
 
 EXPORT_SYMBOL(__x86_return_thunk)
+
+#endif /* CONFIG_RETHUNK */
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -231,6 +231,7 @@ objtool_args =								\
 	$(if $(CONFIG_FRAME_POINTER),, --no-fp)				\
 	$(if $(CONFIG_GCOV_KERNEL)$(CONFIG_LTO_CLANG), --no-unreachable)\
 	$(if $(CONFIG_RETPOLINE), --retpoline)				\
+	$(if $(CONFIG_RETHUNK), --rethunk)				\
 	$(if $(CONFIG_X86_SMAP), --uaccess)				\
 	$(if $(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL), --mcount)		\
 	$(if $(CONFIG_SLS), --sls)
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -120,7 +120,7 @@ objtool_link()
 
 	if [ -n "${CONFIG_VMLINUX_VALIDATION}" ]; then
 		objtoolopt="${objtoolopt} --noinstr"
-		if is_enabled CONFIG_RETPOLINE; then
+		if is_enabled CONFIG_CPU_UNRET_ENTRY; then
 			objtoolopt="${objtoolopt} --unret"
 		fi
 	fi
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
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -20,7 +20,7 @@
 #include <objtool/objtool.h>
 
 bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats,
-     validate_dup, vmlinux, mcount, noinstr, backup, sls, unret;
+     validate_dup, vmlinux, mcount, noinstr, backup, sls, unret, rethunk;
 
 static const char * const check_usage[] = {
 	"objtool check [<options>] file.o",
@@ -36,6 +36,7 @@ const struct option check_options[] = {
 	OPT_BOOLEAN('f', "no-fp", &no_fp, "Skip frame pointer validation"),
 	OPT_BOOLEAN('u', "no-unreachable", &no_unreachable, "Skip 'unreachable instruction' warnings"),
 	OPT_BOOLEAN('r', "retpoline", &retpoline, "Validate retpoline assumptions"),
+	OPT_BOOLEAN(0,   "rethunk", &rethunk, "validate and annotate rethunk usage"),
 	OPT_BOOLEAN(0,   "unret", &unret, "validate entry unret placement"),
 	OPT_BOOLEAN('m', "module", &module, "Indicates the object will be part of a kernel module"),
 	OPT_BOOLEAN('b', "backtrace", &backtrace, "unwind on error"),
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3440,8 +3440,11 @@ static int validate_retpoline(struct obj
 			continue;
 
 		if (insn->type == INSN_RETURN) {
-			WARN_FUNC("'naked' return found in RETPOLINE build",
-				  insn->sec, insn->offset);
+			if (rethunk) {
+				WARN_FUNC("'naked' return found in RETHUNK build",
+					  insn->sec, insn->offset);
+			} else
+				continue;
 		} else {
 			WARN_FUNC("indirect %s found in RETPOLINE build",
 				  insn->sec, insn->offset,
@@ -3711,7 +3714,9 @@ int check(struct objtool_file *file)
 		if (ret < 0)
 			goto out;
 		warnings += ret;
+	}
 
+	if (rethunk) {
 		ret = create_return_sites_sections(file);
 		if (ret < 0)
 			goto out;
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -9,7 +9,7 @@
 
 extern const struct option check_options[];
 extern bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats,
-            validate_dup, vmlinux, mcount, noinstr, backup, sls, unret;
+            validate_dup, vmlinux, mcount, noinstr, backup, sls, unret, rethunk;
 
 extern int cmd_parse_options(int argc, const char **argv, const char * const usage[]);
 


