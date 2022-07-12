Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1936057234D
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbiGLSot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbiGLSoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:44:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F529D31E5;
        Tue, 12 Jul 2022 11:42:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A6BD5CE1D88;
        Tue, 12 Jul 2022 18:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866C9C3411C;
        Tue, 12 Jul 2022 18:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651324;
        bh=Giw7ed+DIPgp8ePeOm7IAwsUx0fnFlZ6gBV2EK6t2Zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hnNZESm1axEM3I/tmUqpiFygNuY4Fp26vbkZ+geIIBEuXdJ5cmfjlK8X5HWUBwbE9
         lCzdwPjElnXK4w+Kb6KP2AcasjV0yAQM8kIadsjhRWWMvJiMvi3f6X7K7PJi3D1cLe
         5KrGsdCeGPoRKX0NawKAdksJXGZBmscNMXKUogpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 011/130] x86/alternative: Merge include files
Date:   Tue, 12 Jul 2022 20:37:37 +0200
Message-Id: <20220712183246.915249383@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

commit 5e21a3ecad1500e35b46701e7f3f232e15d78e69 upstream.

Merge arch/x86/include/asm/alternative-asm.h into
arch/x86/include/asm/alternative.h in order to make it easier to use
common definitions later.

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210311142319.4723-2-jgross@suse.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_32.S                |    2 
 arch/x86/entry/vdso/vdso32/system_call.S |    2 
 arch/x86/include/asm/alternative-asm.h   |  114 -------------------------------
 arch/x86/include/asm/alternative.h       |  112 +++++++++++++++++++++++++++++-
 arch/x86/include/asm/nospec-branch.h     |    1 
 arch/x86/include/asm/smap.h              |    5 -
 arch/x86/lib/atomic64_386_32.S           |    2 
 arch/x86/lib/atomic64_cx8_32.S           |    2 
 arch/x86/lib/copy_page_64.S              |    2 
 arch/x86/lib/copy_user_64.S              |    2 
 arch/x86/lib/memcpy_64.S                 |    2 
 arch/x86/lib/memmove_64.S                |    2 
 arch/x86/lib/memset_64.S                 |    2 
 arch/x86/lib/retpoline.S                 |    2 
 14 files changed, 120 insertions(+), 132 deletions(-)
 delete mode 100644 arch/x86/include/asm/alternative-asm.h

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -40,7 +40,7 @@
 #include <asm/processor-flags.h>
 #include <asm/irq_vectors.h>
 #include <asm/cpufeatures.h>
-#include <asm/alternative-asm.h>
+#include <asm/alternative.h>
 #include <asm/asm.h>
 #include <asm/smap.h>
 #include <asm/frame.h>
--- a/arch/x86/entry/vdso/vdso32/system_call.S
+++ b/arch/x86/entry/vdso/vdso32/system_call.S
@@ -6,7 +6,7 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
 #include <asm/cpufeatures.h>
-#include <asm/alternative-asm.h>
+#include <asm/alternative.h>
 
 	.text
 	.globl __kernel_vsyscall
--- a/arch/x86/include/asm/alternative-asm.h
+++ /dev/null
@@ -1,114 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_X86_ALTERNATIVE_ASM_H
-#define _ASM_X86_ALTERNATIVE_ASM_H
-
-#ifdef __ASSEMBLY__
-
-#include <asm/asm.h>
-
-#ifdef CONFIG_SMP
-	.macro LOCK_PREFIX
-672:	lock
-	.pushsection .smp_locks,"a"
-	.balign 4
-	.long 672b - .
-	.popsection
-	.endm
-#else
-	.macro LOCK_PREFIX
-	.endm
-#endif
-
-/*
- * objtool annotation to ignore the alternatives and only consider the original
- * instruction(s).
- */
-.macro ANNOTATE_IGNORE_ALTERNATIVE
-	.Lannotate_\@:
-	.pushsection .discard.ignore_alts
-	.long .Lannotate_\@ - .
-	.popsection
-.endm
-
-/*
- * Issue one struct alt_instr descriptor entry (need to put it into
- * the section .altinstructions, see below). This entry contains
- * enough information for the alternatives patching code to patch an
- * instruction. See apply_alternatives().
- */
-.macro altinstruction_entry orig alt feature orig_len alt_len pad_len
-	.long \orig - .
-	.long \alt - .
-	.word \feature
-	.byte \orig_len
-	.byte \alt_len
-	.byte \pad_len
-.endm
-
-/*
- * Define an alternative between two instructions. If @feature is
- * present, early code in apply_alternatives() replaces @oldinstr with
- * @newinstr. ".skip" directive takes care of proper instruction padding
- * in case @newinstr is longer than @oldinstr.
- */
-.macro ALTERNATIVE oldinstr, newinstr, feature
-140:
-	\oldinstr
-141:
-	.skip -(((144f-143f)-(141b-140b)) > 0) * ((144f-143f)-(141b-140b)),0x90
-142:
-
-	.pushsection .altinstructions,"a"
-	altinstruction_entry 140b,143f,\feature,142b-140b,144f-143f,142b-141b
-	.popsection
-
-	.pushsection .altinstr_replacement,"ax"
-143:
-	\newinstr
-144:
-	.popsection
-.endm
-
-#define old_len			141b-140b
-#define new_len1		144f-143f
-#define new_len2		145f-144f
-
-/*
- * gas compatible max based on the idea from:
- * http://graphics.stanford.edu/~seander/bithacks.html#IntegerMinOrMax
- *
- * The additional "-" is needed because gas uses a "true" value of -1.
- */
-#define alt_max_short(a, b)	((a) ^ (((a) ^ (b)) & -(-((a) < (b)))))
-
-
-/*
- * Same as ALTERNATIVE macro above but for two alternatives. If CPU
- * has @feature1, it replaces @oldinstr with @newinstr1. If CPU has
- * @feature2, it replaces @oldinstr with @feature2.
- */
-.macro ALTERNATIVE_2 oldinstr, newinstr1, feature1, newinstr2, feature2
-140:
-	\oldinstr
-141:
-	.skip -((alt_max_short(new_len1, new_len2) - (old_len)) > 0) * \
-		(alt_max_short(new_len1, new_len2) - (old_len)),0x90
-142:
-
-	.pushsection .altinstructions,"a"
-	altinstruction_entry 140b,143f,\feature1,142b-140b,144f-143f,142b-141b
-	altinstruction_entry 140b,144f,\feature2,142b-140b,145f-144f,142b-141b
-	.popsection
-
-	.pushsection .altinstr_replacement,"ax"
-143:
-	\newinstr1
-144:
-	\newinstr2
-145:
-	.popsection
-.endm
-
-#endif  /*  __ASSEMBLY__  */
-
-#endif /* _ASM_X86_ALTERNATIVE_ASM_H */
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -2,13 +2,14 @@
 #ifndef _ASM_X86_ALTERNATIVE_H
 #define _ASM_X86_ALTERNATIVE_H
 
-#ifndef __ASSEMBLY__
-
 #include <linux/types.h>
-#include <linux/stddef.h>
 #include <linux/stringify.h>
 #include <asm/asm.h>
 
+#ifndef __ASSEMBLY__
+
+#include <linux/stddef.h>
+
 /*
  * Alternative inline assembly for SMP.
  *
@@ -271,6 +272,111 @@ static inline int alternatives_text_rese
  */
 #define ASM_NO_INPUT_CLOBBER(clbr...) "i" (0) : clbr
 
+#else /* __ASSEMBLY__ */
+
+#ifdef CONFIG_SMP
+	.macro LOCK_PREFIX
+672:	lock
+	.pushsection .smp_locks,"a"
+	.balign 4
+	.long 672b - .
+	.popsection
+	.endm
+#else
+	.macro LOCK_PREFIX
+	.endm
+#endif
+
+/*
+ * objtool annotation to ignore the alternatives and only consider the original
+ * instruction(s).
+ */
+.macro ANNOTATE_IGNORE_ALTERNATIVE
+	.Lannotate_\@:
+	.pushsection .discard.ignore_alts
+	.long .Lannotate_\@ - .
+	.popsection
+.endm
+
+/*
+ * Issue one struct alt_instr descriptor entry (need to put it into
+ * the section .altinstructions, see below). This entry contains
+ * enough information for the alternatives patching code to patch an
+ * instruction. See apply_alternatives().
+ */
+.macro altinstruction_entry orig alt feature orig_len alt_len pad_len
+	.long \orig - .
+	.long \alt - .
+	.word \feature
+	.byte \orig_len
+	.byte \alt_len
+	.byte \pad_len
+.endm
+
+/*
+ * Define an alternative between two instructions. If @feature is
+ * present, early code in apply_alternatives() replaces @oldinstr with
+ * @newinstr. ".skip" directive takes care of proper instruction padding
+ * in case @newinstr is longer than @oldinstr.
+ */
+.macro ALTERNATIVE oldinstr, newinstr, feature
+140:
+	\oldinstr
+141:
+	.skip -(((144f-143f)-(141b-140b)) > 0) * ((144f-143f)-(141b-140b)),0x90
+142:
+
+	.pushsection .altinstructions,"a"
+	altinstruction_entry 140b,143f,\feature,142b-140b,144f-143f,142b-141b
+	.popsection
+
+	.pushsection .altinstr_replacement,"ax"
+143:
+	\newinstr
+144:
+	.popsection
+.endm
+
+#define old_len			141b-140b
+#define new_len1		144f-143f
+#define new_len2		145f-144f
+
+/*
+ * gas compatible max based on the idea from:
+ * http://graphics.stanford.edu/~seander/bithacks.html#IntegerMinOrMax
+ *
+ * The additional "-" is needed because gas uses a "true" value of -1.
+ */
+#define alt_max_short(a, b)	((a) ^ (((a) ^ (b)) & -(-((a) < (b)))))
+
+
+/*
+ * Same as ALTERNATIVE macro above but for two alternatives. If CPU
+ * has @feature1, it replaces @oldinstr with @newinstr1. If CPU has
+ * @feature2, it replaces @oldinstr with @feature2.
+ */
+.macro ALTERNATIVE_2 oldinstr, newinstr1, feature1, newinstr2, feature2
+140:
+	\oldinstr
+141:
+	.skip -((alt_max_short(new_len1, new_len2) - (old_len)) > 0) * \
+		(alt_max_short(new_len1, new_len2) - (old_len)),0x90
+142:
+
+	.pushsection .altinstructions,"a"
+	altinstruction_entry 140b,143f,\feature1,142b-140b,144f-143f,142b-141b
+	altinstruction_entry 140b,144f,\feature2,142b-140b,145f-144f,142b-141b
+	.popsection
+
+	.pushsection .altinstr_replacement,"ax"
+143:
+	\newinstr1
+144:
+	\newinstr2
+145:
+	.popsection
+.endm
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_ALTERNATIVE_H */
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -7,7 +7,6 @@
 #include <linux/objtool.h>
 
 #include <asm/alternative.h>
-#include <asm/alternative-asm.h>
 #include <asm/cpufeatures.h>
 #include <asm/msr-index.h>
 #include <asm/unwind_hints.h>
--- a/arch/x86/include/asm/smap.h
+++ b/arch/x86/include/asm/smap.h
@@ -11,6 +11,7 @@
 
 #include <asm/nops.h>
 #include <asm/cpufeatures.h>
+#include <asm/alternative.h>
 
 /* "Raw" instruction opcodes */
 #define __ASM_CLAC	".byte 0x0f,0x01,0xca"
@@ -18,8 +19,6 @@
 
 #ifdef __ASSEMBLY__
 
-#include <asm/alternative-asm.h>
-
 #ifdef CONFIG_X86_SMAP
 
 #define ASM_CLAC \
@@ -37,8 +36,6 @@
 
 #else /* __ASSEMBLY__ */
 
-#include <asm/alternative.h>
-
 #ifdef CONFIG_X86_SMAP
 
 static __always_inline void clac(void)
--- a/arch/x86/lib/atomic64_386_32.S
+++ b/arch/x86/lib/atomic64_386_32.S
@@ -6,7 +6,7 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/alternative-asm.h>
+#include <asm/alternative.h>
 
 /* if you want SMP support, implement these with real spinlocks */
 .macro LOCK reg
--- a/arch/x86/lib/atomic64_cx8_32.S
+++ b/arch/x86/lib/atomic64_cx8_32.S
@@ -6,7 +6,7 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/alternative-asm.h>
+#include <asm/alternative.h>
 
 .macro read64 reg
 	movl %ebx, %eax
--- a/arch/x86/lib/copy_page_64.S
+++ b/arch/x86/lib/copy_page_64.S
@@ -3,7 +3,7 @@
 
 #include <linux/linkage.h>
 #include <asm/cpufeatures.h>
-#include <asm/alternative-asm.h>
+#include <asm/alternative.h>
 #include <asm/export.h>
 
 /*
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -11,7 +11,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
 #include <asm/cpufeatures.h>
-#include <asm/alternative-asm.h>
+#include <asm/alternative.h>
 #include <asm/asm.h>
 #include <asm/smap.h>
 #include <asm/export.h>
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -4,7 +4,7 @@
 #include <linux/linkage.h>
 #include <asm/errno.h>
 #include <asm/cpufeatures.h>
-#include <asm/alternative-asm.h>
+#include <asm/alternative.h>
 #include <asm/export.h>
 
 .pushsection .noinstr.text, "ax"
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -8,7 +8,7 @@
  */
 #include <linux/linkage.h>
 #include <asm/cpufeatures.h>
-#include <asm/alternative-asm.h>
+#include <asm/alternative.h>
 #include <asm/export.h>
 
 #undef memmove
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -3,7 +3,7 @@
 
 #include <linux/linkage.h>
 #include <asm/cpufeatures.h>
-#include <asm/alternative-asm.h>
+#include <asm/alternative.h>
 #include <asm/export.h>
 
 /*
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -4,7 +4,7 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
 #include <asm/cpufeatures.h>
-#include <asm/alternative-asm.h>
+#include <asm/alternative.h>
 #include <asm/export.h>
 #include <asm/nospec-branch.h>
 #include <asm/unwind_hints.h>


