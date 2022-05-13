Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC0B526471
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380880AbiEMObh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381235AbiEMObL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:31:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A7619CECC;
        Fri, 13 May 2022 07:28:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5ED4B82C9D;
        Fri, 13 May 2022 14:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8D6C34115;
        Fri, 13 May 2022 14:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452124;
        bh=Ie+eHcCaTSHoGvHxsjKpqq2s83j3y+ckD62izrJ50SI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3vXDnsnVs7utCQ0EA6Tj+QEZTL3SiYiITuDat7l9tYaf0JHaE+7gMZYp3zj8B7DM
         qzoAa+aynqesSgVSJrBckHBHR/uuwZZEWjuBbA/A1XhINSIug4c7cKX4KOU/R1gJv0
         8NrNJtJHCStfNdm2szsr/hHQ/HRqSSPBHyQOnZBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/21] x86: Add straight-line-speculation mitigation
Date:   Fri, 13 May 2022 16:23:49 +0200
Message-Id: <20220513142230.090384168@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142229.874949670@linuxfoundation.org>
References: <20220513142229.874949670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit e463a09af2f0677b9485a7e8e4e70b396b2ffb6f ]

Make use of an upcoming GCC feature to mitigate
straight-line-speculation for x86:

  https://gcc.gnu.org/g:53a643f8568067d7700a9f2facc8ba39974973d3
  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=102952
  https://bugs.llvm.org/show_bug.cgi?id=52323

It's built tested on x86_64-allyesconfig using GCC-12 and GCC-11.

Maintenance overhead of this should be fairly low due to objtool
validation.

Size overhead of all these additional int3 instructions comes to:

     text	   data	    bss	    dec	    hex	filename
  22267751	6933356	2011368	31212475	1dc43bb	defconfig-build/vmlinux
  22804126	6933356	1470696	31208178	1dc32f2	defconfig-build/vmlinux.sls

Or roughly 2.4% additional text.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211204134908.140103474@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig                   |   12 ++++++++++++
 arch/x86/Makefile                  |    4 ++++
 arch/x86/include/asm/linkage.h     |   10 ++++++++++
 arch/x86/include/asm/static_call.h |    2 +-
 arch/x86/kernel/ftrace.c           |    2 +-
 arch/x86/kernel/static_call.c      |    5 +++--
 arch/x86/lib/memmove_64.S          |    2 +-
 arch/x86/lib/retpoline.S           |    2 +-
 scripts/Makefile.build             |    3 ++-
 scripts/link-vmlinux.sh            |    3 +++
 10 files changed, 38 insertions(+), 7 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -468,6 +468,18 @@ config RETPOLINE
 	  branches. Requires a compiler with -mindirect-branch=thunk-extern
 	  support for full protection. The kernel may run slower.
 
+config CC_HAS_SLS
+	def_bool $(cc-option,-mharden-sls=all)
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
 config X86_CPU_RESCTRL
 	bool "x86 CPU resource control support"
 	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -179,6 +179,10 @@ ifdef CONFIG_RETPOLINE
   endif
 endif
 
+ifdef CONFIG_SLS
+  KBUILD_CFLAGS += -mharden-sls=all
+endif
+
 KBUILD_LDFLAGS += -m elf_$(UTS_MACHINE)
 
 ifdef CONFIG_LTO_CLANG
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -18,9 +18,19 @@
 #define __ALIGN_STR	__stringify(__ALIGN)
 #endif
 
+#ifdef CONFIG_SLS
+#define RET	ret; int3
+#else
+#define RET	ret
+#endif
+
 #else /* __ASSEMBLY__ */
 
+#ifdef CONFIG_SLS
+#define ASM_RET	"ret; int3\n\t"
+#else
 #define ASM_RET	"ret\n\t"
+#endif
 
 #endif /* __ASSEMBLY__ */
 
--- a/arch/x86/include/asm/static_call.h
+++ b/arch/x86/include/asm/static_call.h
@@ -35,7 +35,7 @@
 	__ARCH_DEFINE_STATIC_CALL_TRAMP(name, ".byte 0xe9; .long " #func " - (. + 4)")
 
 #define ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)			\
-	__ARCH_DEFINE_STATIC_CALL_TRAMP(name, "ret; nop; nop; nop; nop")
+	__ARCH_DEFINE_STATIC_CALL_TRAMP(name, "ret; int3; nop; nop; nop")
 
 
 #define ARCH_ADD_TRAMP_KEY(name)					\
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -308,7 +308,7 @@ union ftrace_op_code_union {
 	} __attribute__((packed));
 };
 
-#define RET_SIZE		1
+#define RET_SIZE		1 + IS_ENABLED(CONFIG_SLS)
 
 static unsigned long
 create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -16,6 +16,8 @@ enum insn_type {
  */
 static const u8 xor5rax[] = { 0x2e, 0x2e, 0x2e, 0x31, 0xc0 };
 
+static const u8 retinsn[] = { RET_INSN_OPCODE, 0xcc, 0xcc, 0xcc, 0xcc };
+
 static void __ref __static_call_transform(void *insn, enum insn_type type, void *func)
 {
 	const void *emulate = NULL;
@@ -41,8 +43,7 @@ static void __ref __static_call_transfor
 		break;
 
 	case RET:
-		code = text_gen_insn(RET_INSN_OPCODE, insn, func);
-		size = RET_INSN_SIZE;
+		code = &retinsn;
 		break;
 	}
 
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -40,7 +40,7 @@ SYM_FUNC_START(__memmove)
 	/* FSRM implies ERMS => no length checks, do the copy directly */
 .Lmemmove_begin_forward:
 	ALTERNATIVE "cmp $0x20, %rdx; jb 1f", "", X86_FEATURE_FSRM
-	ALTERNATIVE "", "movq %rdx, %rcx; rep movsb; RET", X86_FEATURE_ERMS
+	ALTERNATIVE "", __stringify(movq %rdx, %rcx; rep movsb; RET), X86_FEATURE_ERMS
 
 	/*
 	 * movsq instruction have many startup latency
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -34,7 +34,7 @@ SYM_FUNC_START(__x86_indirect_thunk_\reg
 
 	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), \
 		      __stringify(RETPOLINE \reg), X86_FEATURE_RETPOLINE, \
-		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), X86_FEATURE_RETPOLINE_LFENCE
+		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg; int3), X86_FEATURE_RETPOLINE_LFENCE
 
 SYM_FUNC_END(__x86_indirect_thunk_\reg)
 
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -232,7 +232,8 @@ objtool_args =								\
 	$(if $(CONFIG_GCOV_KERNEL)$(CONFIG_LTO_CLANG), --no-unreachable)\
 	$(if $(CONFIG_RETPOLINE), --retpoline)				\
 	$(if $(CONFIG_X86_SMAP), --uaccess)				\
-	$(if $(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL), --mcount)
+	$(if $(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL), --mcount)		\
+	$(if $(CONFIG_SLS), --sls)
 
 ifndef CONFIG_LTO_CLANG
 
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -139,6 +139,9 @@ objtool_link()
 		if [ -n "${CONFIG_X86_SMAP}" ]; then
 			objtoolopt="${objtoolopt} --uaccess"
 		fi
+		if [ -n "${CONFIG_SLS}" ]; then
+			objtoolopt="${objtoolopt} --sls"
+		fi
 		info OBJTOOL ${1}
 		tools/objtool/objtool ${objtoolcmd} ${objtoolopt} ${1}
 	fi


