Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668A852649F
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380918AbiEMObj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381398AbiEMObW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:31:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450701A7D02;
        Fri, 13 May 2022 07:29:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6912621A9;
        Fri, 13 May 2022 14:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5F1C34100;
        Fri, 13 May 2022 14:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452143;
        bh=eV4ZT1JHdZBrwzJ4fhmScpaWEESNg35gtavKqTCc4ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KxdA7JqrWZXBnYjmzDFjNemgl+9Q/AQ86s1RKIAK8HjivC2xMqQhN0UGOF5tEpKtj
         kxlsn8sJrRtHTeGeC+cxOHOm5uM8NQHL/et7XBeXyvahawHlCXEvEYT2PJkTNANi4b
         IB+puHV9RlkDrGmq+lP5Ygodgxjpm1aiFjppvEXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/21] x86: Prepare inline-asm for straight-line-speculation
Date:   Fri, 13 May 2022 16:23:45 +0200
Message-Id: <20220513142229.978979020@linuxfoundation.org>
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

[ Upstream commit b17c2baa305cccbd16bafa289fd743cc2db77966 ]

Replace all ret/retq instructions with ASM_RET in preparation of
making it more than a single instruction.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211204134907.964635458@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/linkage.h            |    4 ++++
 arch/x86/include/asm/paravirt.h           |    2 +-
 arch/x86/include/asm/qspinlock_paravirt.h |    4 ++--
 arch/x86/kernel/alternative.c             |    2 +-
 arch/x86/kernel/kprobes/core.c            |    2 +-
 arch/x86/kernel/paravirt.c                |    2 +-
 arch/x86/kvm/emulate.c                    |    4 ++--
 arch/x86/lib/error-inject.c               |    3 ++-
 samples/ftrace/ftrace-direct-modify.c     |    4 ++--
 samples/ftrace/ftrace-direct-too.c        |    2 +-
 samples/ftrace/ftrace-direct.c            |    2 +-
 11 files changed, 18 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -18,6 +18,10 @@
 #define __ALIGN_STR	__stringify(__ALIGN)
 #endif
 
+#else /* __ASSEMBLY__ */
+
+#define ASM_RET	"ret\n\t"
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_LINKAGE_H */
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -665,7 +665,7 @@ bool __raw_callee_save___native_vcpu_is_
 	    "call " #func ";"						\
 	    PV_RESTORE_ALL_CALLER_REGS					\
 	    FRAME_END							\
-	    "ret;"							\
+	    ASM_RET							\
 	    ".size " PV_THUNK_NAME(func) ", .-" PV_THUNK_NAME(func) ";"	\
 	    ".popsection")
 
--- a/arch/x86/include/asm/qspinlock_paravirt.h
+++ b/arch/x86/include/asm/qspinlock_paravirt.h
@@ -48,7 +48,7 @@ asm    (".pushsection .text;"
 	"jne   .slowpath;"
 	"pop   %rdx;"
 	FRAME_END
-	"ret;"
+	ASM_RET
 	".slowpath: "
 	"push   %rsi;"
 	"movzbl %al,%esi;"
@@ -56,7 +56,7 @@ asm    (".pushsection .text;"
 	"pop    %rsi;"
 	"pop    %rdx;"
 	FRAME_END
-	"ret;"
+	ASM_RET
 	".size " PV_UNLOCK ", .-" PV_UNLOCK ";"
 	".popsection");
 
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -537,7 +537,7 @@ asm (
 "	.type		int3_magic, @function\n"
 "int3_magic:\n"
 "	movl	$1, (%" _ASM_ARG1 ")\n"
-"	ret\n"
+	ASM_RET
 "	.size		int3_magic, .-int3_magic\n"
 "	.popsection\n"
 );
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -1044,7 +1044,7 @@ asm(
 	RESTORE_REGS_STRING
 	"	popfl\n"
 #endif
-	"	ret\n"
+	ASM_RET
 	".size kretprobe_trampoline, .-kretprobe_trampoline\n"
 );
 NOKPROBE_SYMBOL(kretprobe_trampoline);
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -41,7 +41,7 @@ extern void _paravirt_nop(void);
 asm (".pushsection .entry.text, \"ax\"\n"
      ".global _paravirt_nop\n"
      "_paravirt_nop:\n\t"
-     "ret\n\t"
+     ASM_RET
      ".size _paravirt_nop, . - _paravirt_nop\n\t"
      ".type _paravirt_nop, @function\n\t"
      ".popsection");
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -315,7 +315,7 @@ static int fastop(struct x86_emulate_ctx
 	__FOP_FUNC(#name)
 
 #define __FOP_RET(name) \
-	"ret \n\t" \
+	ASM_RET \
 	".size " name ", .-" name "\n\t"
 
 #define FOP_RET(name) \
@@ -435,7 +435,7 @@ static int fastop(struct x86_emulate_ctx
 	__FOP_RET(#op)
 
 asm(".pushsection .fixup, \"ax\"\n"
-    "kvm_fastop_exception: xor %esi, %esi; ret\n"
+    "kvm_fastop_exception: xor %esi, %esi; " ASM_RET
     ".popsection");
 
 FOP_START(setcc)
--- a/arch/x86/lib/error-inject.c
+++ b/arch/x86/lib/error-inject.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <linux/linkage.h>
 #include <linux/error-injection.h>
 #include <linux/kprobes.h>
 
@@ -10,7 +11,7 @@ asm(
 	".type just_return_func, @function\n"
 	".globl just_return_func\n"
 	"just_return_func:\n"
-	"	ret\n"
+		ASM_RET
 	".size just_return_func, .-just_return_func\n"
 );
 
--- a/samples/ftrace/ftrace-direct-modify.c
+++ b/samples/ftrace/ftrace-direct-modify.c
@@ -31,7 +31,7 @@ asm (
 "	call my_direct_func1\n"
 "	leave\n"
 "	.size		my_tramp1, .-my_tramp1\n"
-"	ret\n"
+	ASM_RET
 "	.type		my_tramp2, @function\n"
 "	.globl		my_tramp2\n"
 "   my_tramp2:"
@@ -39,7 +39,7 @@ asm (
 "	movq %rsp, %rbp\n"
 "	call my_direct_func2\n"
 "	leave\n"
-"	ret\n"
+	ASM_RET
 "	.size		my_tramp2, .-my_tramp2\n"
 "	.popsection\n"
 );
--- a/samples/ftrace/ftrace-direct-too.c
+++ b/samples/ftrace/ftrace-direct-too.c
@@ -31,7 +31,7 @@ asm (
 "	popq %rsi\n"
 "	popq %rdi\n"
 "	leave\n"
-"	ret\n"
+	ASM_RET
 "	.size		my_tramp, .-my_tramp\n"
 "	.popsection\n"
 );
--- a/samples/ftrace/ftrace-direct.c
+++ b/samples/ftrace/ftrace-direct.c
@@ -24,7 +24,7 @@ asm (
 "	call my_direct_func\n"
 "	popq %rdi\n"
 "	leave\n"
-"	ret\n"
+	ASM_RET
 "	.size		my_tramp, .-my_tramp\n"
 "	.popsection\n"
 );


