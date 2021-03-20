Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBC0342A62
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 05:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCTERD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 00:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhCTEQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 00:16:39 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B961C061761
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 21:16:39 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id g15so7244071pfq.3
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 21:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qx2lJVIGj34u/LPV1tiCGu8rXqy7Kzn5lo/CUtewkUw=;
        b=GD9zIgA06a/vBNkAi5/ndewe16Ck3704OqX03fjE3ebbyTI6dneA0aJCjaT0FqBOm/
         V3TERDprfEgWoAwZLnImH15+2vtBGibl+WLehA4P88+EEXTE4izodvBKLLwW8ZKOg96+
         BLvr3URNhK18no3n/Skh/ZvPW4XtqG1HbP9l0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qx2lJVIGj34u/LPV1tiCGu8rXqy7Kzn5lo/CUtewkUw=;
        b=NqTW8GTBY7737K/R+Eyth0ksqDJXIZowxrmQVTmuPwrbEoI63wOaxMNoW3hSbaREcz
         G8ArzNx9EuyMG65SzpVmpraec7VphXEJ2vBYjmKK48XFdvRtC9Sv/SM3YQZor/DmwWiN
         AtjFMr+qJhLKDl1ZzkIZ6QlnT3VMVwKHuU4heLke3oygu+c2PS0VKO9/meQAx90HxaOh
         IRzxyke8yVnxh+pUTKBjP5Cbp36IJjR02+BkUparIdEA1k2A03XixcJrW47mZPo+NpAx
         8ygD1ieqXlE02BeYXPyYgi6jmR21eQVZhee9y/u3hUIFlpgFfL5/9QyxgOpVGcUUE6rM
         yPWA==
X-Gm-Message-State: AOAM533m90rLi/pVd8HZdNXX5qrA+Xm9FgWCPnUyQHtQzllDGLsGch74
        Qdb79X0D2+3iRsUuJc35jpIdEbS3KTAWhw==
X-Google-Smtp-Source: ABdhPJz65K2FqJvKHOdHbGRLhkFUpwR7vB1ByJNbvaKtkJj9l6j0n4RyWzYsoWDlZ8rJlGZgnGZzKw==
X-Received: by 2002:aa7:86c1:0:b029:203:900:2813 with SMTP id h1-20020aa786c10000b029020309002813mr11787097pfo.35.1616213798429;
        Fri, 19 Mar 2021 21:16:38 -0700 (PDT)
Received: from drinkcat2.tpe.corp.google.com ([2401:fa00:1:b:f0c7:e1f7:948e:d8d5])
        by smtp.gmail.com with ESMTPSA id s62sm6998869pfb.148.2021.03.19.21.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 21:16:38 -0700 (PDT)
From:   Nicolas Boichat <drinkcat@chromium.org>
To:     stable@vger.kernel.org
Cc:     groeck@chromium.org, Thomas Gleixner <tglx@linutronix.de>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Axtens <dja@axtens.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Marek <michal.lkml@markovi.net>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [for-stable-4.19 PATCH v2 1/2] vmlinux.lds.h: Create section for protection against instrumentation
Date:   Sat, 20 Mar 2021 12:16:25 +0800
Message-Id: <20210320121614.for-stable-4.19.v2.1.I222f801866f71be9f7d85e5b10665cd4506d78ec@changeid>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
In-Reply-To: <20210320041626.885806-1-drinkcat@chromium.org>
References: <20210320041626.885806-1-drinkcat@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

---
Technically guarding with !__ASSEMBLY__ should be enough, but
there seems to be no reason to expose this new macro when
!__KERNEL__, so let's just match what upstream does.

Changes in v2:
 - Guard noinstr macro by __KERNEL__ && !__ASSEMBLY__ to prevent
   expansion in linker script and match upstream.

 arch/powerpc/kernel/vmlinux.lds.S |  1 +
 include/asm-generic/sections.h    |  3 ++
 include/asm-generic/vmlinux.lds.h | 10 ++++++
 include/linux/compiler.h          | 54 +++++++++++++++++++++++++++++++
 include/linux/compiler_types.h    |  6 ++++
 scripts/mod/modpost.c             |  2 +-
 6 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 695432965f20..9b346f3d2814 100644
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
diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index 849cd8eb5ca0..ea5987bb0b84 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -53,6 +53,9 @@ extern char __ctors_start[], __ctors_end[];
 /* Start and end of .opd section - used for function descriptors. */
 extern char __start_opd[], __end_opd[];
 
+/* Start and end of instrumentation protected text section */
+extern char __noinstr_text_start[], __noinstr_text_end[];
+
 extern __visible const void __nosave_begin, __nosave_end;
 
 /* Function descriptor handling (if any).  Override in asm/sections.h */
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 2d632a74cc5e..88484ee023ca 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -482,6 +482,15 @@
 		__security_initcall_end = .;				\
 	}
 
+/*
+ * Non-instrumentable text section
+ */
+#define NOINSTR_TEXT							\
+		ALIGN_FUNCTION();					\
+		__noinstr_text_start = .;				\
+		*(.noinstr.text)					\
+		__noinstr_text_end = .;
+
 /*
  * .text section. Map to function alignment to avoid address changes
  * during second ld run in second ld pass when generating System.map
@@ -496,6 +505,7 @@
 		*(TEXT_MAIN .text.fixup)				\
 		*(.text.unlikely .text.unlikely.*)			\
 		*(.text.unknown .text.unknown.*)			\
+		NOINSTR_TEXT						\
 		*(.text..refcount)					\
 		*(.ref.text)						\
 	MEM_KEEP(init.text*)						\
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 6b6505e3b2c7..6a53300cbd1e 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -129,11 +129,65 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
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
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 2b8ed70c4c77..c01100318b25 100644
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
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 91a80036c05d..7c693bd775c1 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -895,7 +895,7 @@ static void check_section(const char *modname, struct elf_info *elf,
 
 #define DATA_SECTIONS ".data", ".data.rel"
 #define TEXT_SECTIONS ".text", ".text.unlikely", ".sched.text", \
-		".kprobes.text", ".cpuidle.text"
+		".kprobes.text", ".cpuidle.text", ".noinstr.text"
 #define OTHER_TEXT_SECTIONS ".ref.text", ".head.text", ".spinlock.text", \
 		".fixup", ".entry.text", ".exception.text", ".text.*", \
 		".coldtext"
-- 
2.31.0.rc2.261.g7f71774620-goog

