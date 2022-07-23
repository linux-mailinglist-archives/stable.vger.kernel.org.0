Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E802857EDEB
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238161AbiGWKEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238451AbiGWKEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:04:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968609B1AB;
        Sat, 23 Jul 2022 03:00:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7885B82C1D;
        Sat, 23 Jul 2022 09:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA2CC341C0;
        Sat, 23 Jul 2022 09:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570381;
        bh=k9IrByeFv4ANj8rXmHXEEaxduV+WzzfaR+gGXS2EnL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJbV2T3sP2ZXoNnMN9IkL3jRlm4by6ZC/m9ohsXeQ9wtv5o8pHulHgRUj+svieW9S
         bxE/t4YQwAqLX2W1yN53Au2q9UDIgdG+BUeH/n4lqJZbX05spoLneEdCBUr8Lx/A2Y
         bkiG/Drk4Y/8SRHgHl4g5FvOjSrK22u4Iqwm4V+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 066/148] x86: Add straight-line-speculation mitigation
Date:   Sat, 23 Jul 2022 11:54:38 +0200
Message-Id: <20220723095242.750401927@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
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

commit e463a09af2f0677b9485a7e8e4e70b396b2ffb6f upstream.

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
[bwh: Backported to 5.10:
 - In scripts/Makefile.build, add the objtool option with an ifdef
   block, same as for other options
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig                   |   12 ++++++++++++
 arch/x86/Makefile                  |    6 +++++-
 arch/x86/include/asm/linkage.h     |   10 ++++++++++
 arch/x86/include/asm/static_call.h |    2 +-
 arch/x86/kernel/ftrace.c           |    2 +-
 arch/x86/kernel/static_call.c      |    5 +++--
 arch/x86/lib/memmove_64.S          |    2 +-
 arch/x86/lib/retpoline.S           |    2 +-
 scripts/Makefile.build             |    3 +++
 scripts/link-vmlinux.sh            |    3 +++
 10 files changed, 40 insertions(+), 7 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -462,6 +462,18 @@ config RETPOLINE
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
@@ -196,7 +196,11 @@ ifdef CONFIG_RETPOLINE
   endif
 endif
 
-KBUILD_LDFLAGS := -m elf_$(UTS_MACHINE)
+ifdef CONFIG_SLS
+  KBUILD_CFLAGS += -mharden-sls=all
+endif
+
+KBUILD_LDFLAGS += -m elf_$(UTS_MACHINE)
 
 ifdef CONFIG_X86_NEED_RELOCS
 LDFLAGS_vmlinux := --emit-relocs --discard-none
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
@@ -11,6 +11,8 @@ enum insn_type {
 	RET = 3,  /* tramp / site cond-tail-call */
 };
 
+static const u8 retinsn[] = { RET_INSN_OPCODE, 0xcc, 0xcc, 0xcc, 0xcc };
+
 static void __ref __static_call_transform(void *insn, enum insn_type type, void *func)
 {
 	int size = CALL_INSN_SIZE;
@@ -30,8 +32,7 @@ static void __ref __static_call_transfor
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
@@ -34,7 +34,7 @@ SYM_INNER_LABEL(__x86_indirect_thunk_\re
 
 	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), \
 		      __stringify(RETPOLINE \reg), X86_FEATURE_RETPOLINE, \
-		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), X86_FEATURE_RETPOLINE_LFENCE
+		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg; int3), X86_FEATURE_RETPOLINE_LFENCE
 
 .endm
 
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -230,6 +230,9 @@ endif
 ifdef CONFIG_X86_SMAP
   objtool_args += --uaccess
 endif
+ifdef CONFIG_SLS
+  objtool_args += --sls
+endif
 
 # 'OBJECT_FILES_NON_STANDARD := y': skip objtool checking for a directory
 # 'OBJECT_FILES_NON_STANDARD_foo.o := 'y': skip objtool checking for a file
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -77,6 +77,9 @@ objtool_link()
 		if [ -n "${CONFIG_X86_SMAP}" ]; then
 			objtoolopt="${objtoolopt} --uaccess"
 		fi
+		if [ -n "${CONFIG_SLS}" ]; then
+			objtoolopt="${objtoolopt} --sls"
+		fi
 		info OBJTOOL ${1}
 		tools/objtool/objtool ${objtoolopt} ${1}
 	fi


