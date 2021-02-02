Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0C530BFF5
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhBBNqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:46:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231894AbhBBNpK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:45:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 416CD64F76;
        Tue,  2 Feb 2021 13:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273239;
        bh=PhylmEDigE/Fyoxcnd+m+iZ6ndgWX3G9KEaOs+tmo5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBiDYePG5Y+u6DqZ021i0SRInRnV2g72ONRtJEjT4rpBPopRP3exkBGuKaMTnq8H8
         UbgTbz9zMC6wfUqQAwQl3E6QpUQf0mcONDDo+Cm9rPsYchniB+drD7GU292SUHjWTD
         N1WTAJKQWWljPsXOvKe3bLe4SO6Gd16i/2QTEut0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Mark Brown <broonie@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Chris Clayton <chris2553@googlemail.com>
Subject: [PATCH 5.10 032/142] x86/entry: Emit a symbol for register restoring thunk
Date:   Tue,  2 Feb 2021 14:36:35 +0100
Message-Id: <20210202132959.033676544@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit 5e6dca82bcaa49348f9e5fcb48df4881f6d6c4ae upstream.

Arnd found a randconfig that produces the warning:

  arch/x86/entry/thunk_64.o: warning: objtool: missing symbol for insn at
  offset 0x3e

when building with LLVM_IAS=1 (Clang's integrated assembler). Josh
notes:

  With the LLVM assembler not generating section symbols, objtool has no
  way to reference this code when it generates ORC unwinder entries,
  because this code is outside of any ELF function.

  The limitation now being imposed by objtool is that all code must be
  contained in an ELF symbol.  And .L symbols don't create such symbols.

  So basically, you can use an .L symbol *inside* a function or a code
  segment, you just can't use the .L symbol to contain the code using a
  SYM_*_START/END annotation pair.

Fangrui notes that this optimization is helpful for reducing image size
when compiling with -ffunction-sections and -fdata-sections. I have
observed on the order of tens of thousands of symbols for the kernel
images built with those flags.

A patch has been authored against GNU binutils to match this behavior
of not generating unused section symbols ([1]), so this will
also become a problem for users of GNU binutils once they upgrade to 2.36.

Omit the .L prefix on a label so that the assembler will emit an entry
into the symbol table for the label, with STB_LOCAL binding. This
enables objtool to generate proper unwind info here with LLVM_IAS=1 or
GNU binutils 2.36+.

 [ bp: Massage commit message. ]

Reported-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Suggested-by: Borislav Petkov <bp@alien8.de>
Suggested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lkml.kernel.org/r/20210112194625.4181814-1-ndesaulniers@google.com
Link: https://github.com/ClangBuiltLinux/linux/issues/1209
Link: https://reviews.llvm.org/D93783
Link: https://sourceware.org/binutils/docs/as/Symbol-Names.html
Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=d1bcae833b32f1408485ce69f844dcd7ded093a8 [1]
Cc: Chris Clayton <chris2553@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/asm-annotations.rst |    5 +++++
 arch/x86/entry/thunk_64.S         |    8 ++++----
 include/linux/linkage.h           |    5 +++++
 3 files changed, 14 insertions(+), 4 deletions(-)

--- a/Documentation/asm-annotations.rst
+++ b/Documentation/asm-annotations.rst
@@ -100,6 +100,11 @@ Instruction Macros
 ~~~~~~~~~~~~~~~~~~
 This section covers ``SYM_FUNC_*`` and ``SYM_CODE_*`` enumerated above.
 
+``objtool`` requires that all code must be contained in an ELF symbol. Symbol
+names that have a ``.L`` prefix do not emit symbol table entries. ``.L``
+prefixed symbols can be used within a code region, but should be avoided for
+denoting a range of code via ``SYM_*_START/END`` annotations.
+
 * ``SYM_FUNC_START`` and ``SYM_FUNC_START_LOCAL`` are supposed to be **the
   most frequent markings**. They are used for functions with standard calling
   conventions -- global and local. Like in C, they both align the functions to
--- a/arch/x86/entry/thunk_64.S
+++ b/arch/x86/entry/thunk_64.S
@@ -31,7 +31,7 @@ SYM_FUNC_START_NOALIGN(\name)
 	.endif
 
 	call \func
-	jmp  .L_restore
+	jmp  __thunk_restore
 SYM_FUNC_END(\name)
 	_ASM_NOKPROBE(\name)
 	.endm
@@ -44,7 +44,7 @@ SYM_FUNC_END(\name)
 #endif
 
 #ifdef CONFIG_PREEMPTION
-SYM_CODE_START_LOCAL_NOALIGN(.L_restore)
+SYM_CODE_START_LOCAL_NOALIGN(__thunk_restore)
 	popq %r11
 	popq %r10
 	popq %r9
@@ -56,6 +56,6 @@ SYM_CODE_START_LOCAL_NOALIGN(.L_restore)
 	popq %rdi
 	popq %rbp
 	ret
-	_ASM_NOKPROBE(.L_restore)
-SYM_CODE_END(.L_restore)
+	_ASM_NOKPROBE(__thunk_restore)
+SYM_CODE_END(__thunk_restore)
 #endif
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -178,6 +178,11 @@
  * Objtool generates debug info for both FUNC & CODE, but needs special
  * annotations for each CODE's start (to describe the actual stack frame).
  *
+ * Objtool requires that all code must be contained in an ELF symbol. Symbol
+ * names that have a  .L prefix do not emit symbol table entries. .L
+ * prefixed symbols can be used within a code region, but should be avoided for
+ * denoting a range of code via ``SYM_*_START/END`` annotations.
+ *
  * ALIAS -- does not generate debug info -- the aliased function will
  */
 


