Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E18057ED78
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 11:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237534AbiGWJ5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 05:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237532AbiGWJ5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:57:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6ACC474D8;
        Sat, 23 Jul 2022 02:57:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35D606117F;
        Sat, 23 Jul 2022 09:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16104C341C0;
        Sat, 23 Jul 2022 09:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570223;
        bh=Sn8JMrIl2IDnUyeKrj7T8ivawqQC2JCHM7kxIMlJeUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yy6i3M85xxbhlI2OaUqU2+dieXnJD27nVVrn7gs+erkkskPKaWJIro1hxC6QHTLqL
         A49imZfH1o4abpWOHfKUIXM5csnAFuSlH0XWfuI5T/E5G90vOZ9bCIcpt24/riw1fy
         qf1gRkLGuDnRQWWZMi41fGHRr0iWdqgj6EVgw08I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 022/148] x86/retpoline: Simplify retpolines
Date:   Sat, 23 Jul 2022 11:53:54 +0200
Message-Id: <20220723095230.677297796@linuxfoundation.org>
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

commit 119251855f9adf9421cb5eb409933092141ab2c7 upstream.

Due to:

  c9c324dc22aa ("objtool: Support stack layout changes in alternatives")

it is now possible to simplify the retpolines.

Currently our retpolines consist of 2 symbols:

 - __x86_indirect_thunk_\reg: the compiler target
 - __x86_retpoline_\reg:  the actual retpoline.

Both are consecutive in code and aligned such that for any one register
they both live in the same cacheline:

  0000000000000000 <__x86_indirect_thunk_rax>:
   0:   ff e0                   jmpq   *%rax
   2:   90                      nop
   3:   90                      nop
   4:   90                      nop

  0000000000000005 <__x86_retpoline_rax>:
   5:   e8 07 00 00 00          callq  11 <__x86_retpoline_rax+0xc>
   a:   f3 90                   pause
   c:   0f ae e8                lfence
   f:   eb f9                   jmp    a <__x86_retpoline_rax+0x5>
  11:   48 89 04 24             mov    %rax,(%rsp)
  15:   c3                      retq
  16:   66 2e 0f 1f 84 00 00 00 00 00   nopw   %cs:0x0(%rax,%rax,1)

The thunk is an alternative_2, where one option is a JMP to the
retpoline. This was done so that objtool didn't need to deal with
alternatives with stack ops. But that problem has been solved, so now
it is possible to fold the entire retpoline into the alternative to
simplify and consolidate unused bytes:

  0000000000000000 <__x86_indirect_thunk_rax>:
   0:   ff e0                   jmpq   *%rax
   2:   90                      nop
   3:   90                      nop
   4:   90                      nop
   5:   90                      nop
   6:   90                      nop
   7:   90                      nop
   8:   90                      nop
   9:   90                      nop
   a:   90                      nop
   b:   90                      nop
   c:   90                      nop
   d:   90                      nop
   e:   90                      nop
   f:   90                      nop
  10:   90                      nop
  11:   66 66 2e 0f 1f 84 00 00 00 00 00        data16 nopw %cs:0x0(%rax,%rax,1)
  1c:   0f 1f 40 00             nopl   0x0(%rax)

Notice that since the longest alternative sequence is now:

   0:   e8 07 00 00 00          callq  c <.altinstr_replacement+0xc>
   5:   f3 90                   pause
   7:   0f ae e8                lfence
   a:   eb f9                   jmp    5 <.altinstr_replacement+0x5>
   c:   48 89 04 24             mov    %rax,(%rsp)
  10:   c3                      retq

17 bytes, we have 15 bytes NOP at the end of our 32 byte slot. (IOW, if
we can shrink the retpoline by 1 byte we can pack it more densely).

 [ bp: Massage commit message. ]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/20210326151259.506071949@infradead.org
[bwh: Backported to 5.10:
 - Use X86_FEATRURE_RETPOLINE_LFENCE flag instead of
   X86_FEATURE_RETPOLINE_AMD, since the later renaming of this flag
   has already been applied
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/asm-prototypes.h |    7 -------
 arch/x86/include/asm/nospec-branch.h  |    6 +++---
 arch/x86/lib/retpoline.S              |   34 +++++++++++++++++-----------------
 tools/objtool/check.c                 |    3 +--
 4 files changed, 21 insertions(+), 29 deletions(-)

--- a/arch/x86/include/asm/asm-prototypes.h
+++ b/arch/x86/include/asm/asm-prototypes.h
@@ -22,15 +22,8 @@ extern void cmpxchg8b_emu(void);
 #define DECL_INDIRECT_THUNK(reg) \
 	extern asmlinkage void __x86_indirect_thunk_ ## reg (void);
 
-#define DECL_RETPOLINE(reg) \
-	extern asmlinkage void __x86_retpoline_ ## reg (void);
-
 #undef GEN
 #define GEN(reg) DECL_INDIRECT_THUNK(reg)
 #include <asm/GEN-for-each-reg.h>
 
-#undef GEN
-#define GEN(reg) DECL_RETPOLINE(reg)
-#include <asm/GEN-for-each-reg.h>
-
 #endif /* CONFIG_RETPOLINE */
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -80,7 +80,7 @@
 .macro JMP_NOSPEC reg:req
 #ifdef CONFIG_RETPOLINE
 	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), \
-		      __stringify(jmp __x86_retpoline_\reg), X86_FEATURE_RETPOLINE, \
+		      __stringify(jmp __x86_indirect_thunk_\reg), X86_FEATURE_RETPOLINE, \
 		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), X86_FEATURE_RETPOLINE_LFENCE
 #else
 	jmp	*%\reg
@@ -90,7 +90,7 @@
 .macro CALL_NOSPEC reg:req
 #ifdef CONFIG_RETPOLINE
 	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; call *%\reg), \
-		      __stringify(call __x86_retpoline_\reg), X86_FEATURE_RETPOLINE, \
+		      __stringify(call __x86_indirect_thunk_\reg), X86_FEATURE_RETPOLINE, \
 		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; call *%\reg), X86_FEATURE_RETPOLINE_LFENCE
 #else
 	call	*%\reg
@@ -128,7 +128,7 @@
 	ALTERNATIVE_2(						\
 	ANNOTATE_RETPOLINE_SAFE					\
 	"call *%[thunk_target]\n",				\
-	"call __x86_retpoline_%V[thunk_target]\n",		\
+	"call __x86_indirect_thunk_%V[thunk_target]\n",		\
 	X86_FEATURE_RETPOLINE,					\
 	"lfence;\n"						\
 	ANNOTATE_RETPOLINE_SAFE					\
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -10,27 +10,31 @@
 #include <asm/unwind_hints.h>
 #include <asm/frame.h>
 
-.macro THUNK reg
-	.section .text.__x86.indirect_thunk
-
-	.align 32
-SYM_FUNC_START(__x86_indirect_thunk_\reg)
-	JMP_NOSPEC \reg
-SYM_FUNC_END(__x86_indirect_thunk_\reg)
-
-SYM_FUNC_START_NOALIGN(__x86_retpoline_\reg)
+.macro RETPOLINE reg
 	ANNOTATE_INTRA_FUNCTION_CALL
-	call	.Ldo_rop_\@
+	call    .Ldo_rop_\@
 .Lspec_trap_\@:
 	UNWIND_HINT_EMPTY
 	pause
 	lfence
-	jmp	.Lspec_trap_\@
+	jmp .Lspec_trap_\@
 .Ldo_rop_\@:
-	mov	%\reg, (%_ASM_SP)
+	mov     %\reg, (%_ASM_SP)
 	UNWIND_HINT_FUNC
 	ret
-SYM_FUNC_END(__x86_retpoline_\reg)
+.endm
+
+.macro THUNK reg
+	.section .text.__x86.indirect_thunk
+
+	.align 32
+SYM_FUNC_START(__x86_indirect_thunk_\reg)
+
+	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), \
+		      __stringify(RETPOLINE \reg), X86_FEATURE_RETPOLINE, \
+		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), X86_FEATURE_RETPOLINE_LFENCE
+
+SYM_FUNC_END(__x86_indirect_thunk_\reg)
 
 .endm
 
@@ -48,7 +52,6 @@ SYM_FUNC_END(__x86_retpoline_\reg)
 
 #define __EXPORT_THUNK(sym)	_ASM_NOKPROBE(sym); EXPORT_SYMBOL(sym)
 #define EXPORT_THUNK(reg)	__EXPORT_THUNK(__x86_indirect_thunk_ ## reg)
-#define EXPORT_RETPOLINE(reg)  __EXPORT_THUNK(__x86_retpoline_ ## reg)
 
 #undef GEN
 #define GEN(reg) THUNK reg
@@ -58,6 +61,3 @@ SYM_FUNC_END(__x86_retpoline_\reg)
 #define GEN(reg) EXPORT_THUNK(reg)
 #include <asm/GEN-for-each-reg.h>
 
-#undef GEN
-#define GEN(reg) EXPORT_RETPOLINE(reg)
-#include <asm/GEN-for-each-reg.h>
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -800,8 +800,7 @@ static int add_jump_destinations(struct
 		} else if (reloc->sym->type == STT_SECTION) {
 			dest_sec = reloc->sym->sec;
 			dest_off = arch_dest_reloc_offset(reloc->addend);
-		} else if (!strncmp(reloc->sym->name, "__x86_indirect_thunk_", 21) ||
-			   !strncmp(reloc->sym->name, "__x86_retpoline_", 16)) {
+		} else if (!strncmp(reloc->sym->name, "__x86_indirect_thunk_", 21)) {
 			/*
 			 * Retpoline jumps are really dynamic jumps in
 			 * disguise, so convert them accordingly.


