Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3578657EDE2
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238089AbiGWKEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238082AbiGWKDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:03:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5158C8EB;
        Sat, 23 Jul 2022 02:59:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49D94B82C1A;
        Sat, 23 Jul 2022 09:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6CEC341C7;
        Sat, 23 Jul 2022 09:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570373;
        bh=ccttcUejxIAp0iXxK7DSBQA0Uf0qGZNTazYuhCCZ8cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRilNCXb74SxxyNu47iQDYf1B1/nJuQC+FNUoQUvEmrR5nXL3S/dAhHbDNEQaD04w
         MFot4ftY7e5Vsd8EWf9VugLbGDy3cqL58iv4m3YUEdoWj9K/s77nTWLQqp10ILl4MM
         GZlfUJaIW+y9MIoDmYKt8k5OgudR2ygw4xsOEaDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 063/148] x86: Prepare inline-asm for straight-line-speculation
Date:   Sat, 23 Jul 2022 11:54:35 +0200
Message-Id: <20220723095241.926858016@linuxfoundation.org>
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

commit b17c2baa305cccbd16bafa289fd743cc2db77966 upstream.

Replace all ret/retq instructions with ASM_RET in preparation of
making it more than a single instruction.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20211204134907.964635458@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 5.10: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
@@ -630,7 +630,7 @@ bool __raw_callee_save___native_vcpu_is_
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
@@ -869,7 +869,7 @@ asm (
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
@@ -768,7 +768,7 @@ asm(
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
@@ -40,7 +40,7 @@ extern void _paravirt_nop(void);
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
@@ -316,7 +316,7 @@ static int fastop(struct x86_emulate_ctx
 	__FOP_FUNC(#name)
 
 #define __FOP_RET(name) \
-	"ret \n\t" \
+	ASM_RET \
 	".size " name ", .-" name "\n\t"
 
 #define FOP_RET(name) \
@@ -437,7 +437,7 @@ static int fastop(struct x86_emulate_ctx
 
 asm(".pushsection .fixup, \"ax\"\n"
     ".global kvm_fastop_exception \n"
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


