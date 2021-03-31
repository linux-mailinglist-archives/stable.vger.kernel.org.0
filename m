Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2DF344364
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhCVMuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232830AbhCVMsR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:48:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07AEF619CB;
        Mon, 22 Mar 2021 12:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417065;
        bh=IsCkwS9fJewdMlKabP+p3F0xmqYu9U/ws65klNQMD98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTm48+V0fF0xtE6umoItUBKkWJUnGBkM7MyMONz8yhuGchN0p2r568ORzteWu4F0V
         xG6RMgyOLte5EE1ffnD+yBl3Qlwk6+bSiYRKx8U4TCO2iuoaXM5kjJTHiToHz3DANW
         Yj95sg5tmtWZLdv+u5ZmgfvMZeJqBmlPtlgssYmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Nicolas Boichat <drinkcat@chromium.org>
Subject: [PATCH 4.19 05/43] vmlinux.lds.h: Create section for protection against instrumentation
Date:   Mon, 22 Mar 2021 13:28:19 +0100
Message-Id: <20210322121920.112066796@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121919.936671417@linuxfoundation.org>
References: <20210322121919.936671417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Boichat <drinkcat@chromium.org>

From: Thomas Gleixner <tglx@linutronix.de>

commit 6553896666433e7efec589838b400a2a652b3ffa upstream.

Some code pathes, especially the low level entry code, must be protected
against instrumentation for various reasons:

 - Low level entry code can be a fragile beast, especially on x86.

 - With NO_HZ_FULL RCU state needs to be established before using it.

Having a dedicated section for such code allows to validate with tooling
that no unsafe functions are invoked.

Add the .noinstr.text section and the noinstr attribute to mark
functions. noinstr implies notrace. Kprobes will gain a section check
later.

Provide also a set of markers: instrumentation_begin()/end()

These are used to mark code inside a noinstr function which calls
into regular instrumentable text section as safe.

The instrumentation markers are only active when CONFIG_DEBUG_ENTRY is
enabled as the end marker emits a NOP to prevent the compiler from merging
the annotation points. This means the objtool verification requires a
kernel compiled with this option.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200505134100.075416272@linutronix.de

[Nicolas:
Guard noinstr macro in include/linux/compiler_types.h in __KERNEL__
&& !__ASSEMBLY__, otherwise noinstr is expanded in the linker
script construct.

Upstream does not have this problem as many macros were moved by
commit 71391bdd2e9a ("include/linux/compiler_types.h: don't pollute
userspace with macro definitions"). We take the minimal approach here
and just guard the new macro.

Minor context conflicts in:
	arch/powerpc/kernel/vmlinux.lds.S
	include/asm-generic/vmlinux.lds.h
	include/linux/compiler.h]
Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Technically guarding with !__ASSEMBLY__ should be enough, but
there seems to be no reason to expose this new macro when
!__KERNEL__, so let's just match what upstream does.

Changes in v2:
 - Guard noinstr macro by __KERNEL__ && !__ASSEMBLY__ to prevent
   expansion in linker script and match upstream.

 arch/powerpc/kernel/vmlinux.lds.S |    1 
 include/asm-generic/sections.h    |    3 ++
 include/asm-generic/vmlinux.lds.h |   10 +++++++
 include/linux/compiler.h          |   54 ++++++++++++++++++++++++++++++++++++++
 include/linux/compiler_types.h    |    6 ++++
 scripts/mod/modpost.c             |    2 -
 6 files changed, 75 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -99,6 +99,7 @@ SECTIONS
 #endif
 		/* careful! __ftr_alt_* sections need to be close to .text */
 		*(.text.hot TEXT_MAIN .text.fixup .text.unlikely .fixup __ftr_alt_* .ref.text);
+		NOINSTR_TEXT
 		SCHED_TEXT
 		CPUIDLE_TEXT
 		LOCK_TEXT
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -53,6 +53,9 @@ extern char __ctors_start[], __ctors_end
 /* Start and end of .opd section - used for function descriptors. */
 extern char __start_opd[], __end_opd[];
 
+/* Start and end of instrumentation protected text section */
+extern char __noinstr_text_start[], __noinstr_text_end[];
+
 extern __visible const void __nosave_begin, __nosave_end;
 
 /* Function descriptor handling (if any).  Override in asm/sections.h */
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -483,6 +483,15 @@
 	}
 
 /*
+ * Non-instrumentable text section
+ */
+#define NOINSTR_TEXT							\
+		ALIGN_FUNCTION();					\
+		__noinstr_text_start = .;				\
+		*(.noinstr.text)					\
+		__noinstr_text_end = .;
+
+/*
  * .text section. Map to function alignment to avoid address changes
  * during second ld run in second ld pass when generating System.map
  *
@@ -496,6 +505,7 @@
 		*(TEXT_MAIN .text.fixup)				\
 		*(.text.unlikely .text.unlikely.*)			\
 		*(.text.unknown .text.unknown.*)			\
+		NOINSTR_TEXT						\
 		*(.text..refcount)					\
 		*(.ref.text)						\
 	MEM_KEEP(init.text*)						\
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -129,11 +129,65 @@ void ftrace_likely_update(struct ftrace_
 	".pushsection .discard.unreachable\n\t"				\
 	".long 999b - .\n\t"						\
 	".popsection\n\t"
+
+#ifdef CONFIG_DEBUG_ENTRY
+/* Begin/end of an instrumentation safe region */
+#define instrumentation_begin() ({					\
+	asm volatile("%c0:\n\t"						\
+		     ".pushsection .discard.instr_begin\n\t"		\
+		     ".long %c0b - .\n\t"				\
+		     ".popsection\n\t" : : "i" (__COUNTER__));		\
+})
+
+/*
+ * Because instrumentation_{begin,end}() can nest, objtool validation considers
+ * _begin() a +1 and _end() a -1 and computes a sum over the instructions.
+ * When the value is greater than 0, we consider instrumentation allowed.
+ *
+ * There is a problem with code like:
+ *
+ * noinstr void foo()
+ * {
+ *	instrumentation_begin();
+ *	...
+ *	if (cond) {
+ *		instrumentation_begin();
+ *		...
+ *		instrumentation_end();
+ *	}
+ *	bar();
+ *	instrumentation_end();
+ * }
+ *
+ * If instrumentation_end() would be an empty label, like all the other
+ * annotations, the inner _end(), which is at the end of a conditional block,
+ * would land on the instruction after the block.
+ *
+ * If we then consider the sum of the !cond path, we'll see that the call to
+ * bar() is with a 0-value, even though, we meant it to happen with a positive
+ * value.
+ *
+ * To avoid this, have _end() be a NOP instruction, this ensures it will be
+ * part of the condition block and does not escape.
+ */
+#define instrumentation_end() ({					\
+	asm volatile("%c0: nop\n\t"					\
+		     ".pushsection .discard.instr_end\n\t"		\
+		     ".long %c0b - .\n\t"				\
+		     ".popsection\n\t" : : "i" (__COUNTER__));		\
+})
+#endif /* CONFIG_DEBUG_ENTRY */
+
 #else
 #define annotate_reachable()
 #define annotate_unreachable()
 #endif
 
+#ifndef instrumentation_begin
+#define instrumentation_begin()		do { } while(0)
+#define instrumentation_end()		do { } while(0)
+#endif
+
 #ifndef ASM_UNREACHABLE
 # define ASM_UNREACHABLE
 #endif
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -234,6 +234,12 @@ struct ftrace_likely_data {
 #define notrace			__attribute__((no_instrument_function))
 #endif
 
+#if defined(__KERNEL__) && !defined(__ASSEMBLY__)
+/* Section for code which can't be instrumented at all */
+#define noinstr								\
+	noinline notrace __attribute((__section__(".noinstr.text")))
+#endif
+
 /*
  * it doesn't make sense on ARM (currently the only user of __naked)
  * to trace naked functions because then mcount is called without
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -895,7 +895,7 @@ static void check_section(const char *mo
 
 #define DATA_SECTIONS ".data", ".data.rel"
 #define TEXT_SECTIONS ".text", ".text.unlikely", ".sched.text", \
-		".kprobes.text", ".cpuidle.text"
+		".kprobes.text", ".cpuidle.text", ".noinstr.text"
 #define OTHER_TEXT_SECTIONS ".ref.text", ".head.text", ".spinlock.text", \
 		".fixup", ".entry.text", ".exception.text", ".text.*", \
 		".coldtext"


