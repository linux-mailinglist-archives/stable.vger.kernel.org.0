Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD1E730905
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 08:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfEaG5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 02:57:17 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41379 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfEaG5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 02:57:16 -0400
Received: by mail-ed1-f66.google.com with SMTP id x25so797473eds.8
        for <stable@vger.kernel.org>; Thu, 30 May 2019 23:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ook/Jc2VHPTuiSZyVVkLNwx6fB/5RpGhyYFgJXGL9ic=;
        b=PwQd2rZbwq7d07I4HrHlQPwCkT51YT77RCfabrrAGJHnqWV9+wJ+R+3C6vUkGud1TJ
         QsF75z/reMNogZLvCcxP+l39+k5i3iG1qYxKkGQT2i2uY56IxYNLUQaVT3YzKXTJ/ps3
         alWHpX9zEYXhf314zRhp1rneby84lAgA8DosPmDChESfBb/uLHbxVsM5V1MbPq4uDQoC
         PNCV9Y5vM6FmseYz6q8iwMmG7hr7N97xtjVL36zX2AP2eqOR3iJx+0CDYyPJ1ynlC3Gf
         MdV742aKMS16JexIN4mG1k/rsO7cwkb9uLiQWC+Jb3k6p7zsX/W5FxcqpUvFsO9LGHd6
         B1oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ook/Jc2VHPTuiSZyVVkLNwx6fB/5RpGhyYFgJXGL9ic=;
        b=RxBGCegOx5Rlc4OLVaAljsGGRFq4HvWAzksjsRL/JGNvs2QRKZ3xoeOIDqIImH88dn
         yxz94Q1M0OUGpqdoIcxl3ZsZ1r1ju0PXxbxU+ReE/4XQlHwE0N7A7VIHklcdMW1Q4xwa
         MiaCcUkSZPDOEaw/61V6ueudFduYmKOcqFfK7/xsw74vdSaD5ybwfBLkIEyB9tpZQctj
         EBCqF1f0zQ3NieudKioycP/IVZEyL5iKnsc07q8QPsafF73OCH1qhc76SeXJkUxLJO5H
         f88q+Aft5OQfAcLGDQ0iNUaQtTeY6HEM5z/KL9dQ2kpJ1b3gyHcIaHYHLOkkljuPss8A
         x1rA==
X-Gm-Message-State: APjAAAXsmi33t0Dofq1vo95Sap1eP2d7gRwv+E+8TzCja1e3++ya4yCA
        71it6RbUH64BW4U1D95juzU=
X-Google-Smtp-Source: APXvYqx+Bpvacq3QoqRB6TUIUNYRaYxzhglJEyPH0T8h8RsWGUnc/KsgWqhmdsJFskVm5xWSzR+WGw==
X-Received: by 2002:a17:906:6a97:: with SMTP id p23mr7512862ejr.203.1559285832738;
        Thu, 30 May 2019 23:57:12 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id w16sm796900ejq.56.2019.05.30.23.57.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 23:57:12 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, clang-built-linux@googlegroups.com,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 4.19] jump_label: move 'asm goto' support test to Kconfig
Date:   Thu, 30 May 2019 23:52:00 -0700
Message-Id: <20190531065159.6490-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.22.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit e9666d10a5677a494260d60d1fa0b73cc7646eb3 upstream.

Currently, CONFIG_JUMP_LABEL just means "I _want_ to use jump label".

The jump label is controlled by HAVE_JUMP_LABEL, which is defined
like this:

  #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
  # define HAVE_JUMP_LABEL
  #endif

We can improve this by testing 'asm goto' support in Kconfig, then
make JUMP_LABEL depend on CC_HAS_ASM_GOTO.

Ugly #ifdef HAVE_JUMP_LABEL will go away, and CONFIG_JUMP_LABEL will
match to the real kernel capability.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
[nc: Fix trivial conflicts in 4.19
     arch/xtensa/kernel/jump_label.c doesn't exist yet
     Ensured CC_HAVE_ASM_GOTO and HAVE_JUMP_LABEL were sufficiently
     eliminated]
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

Hi Greg and Sasha,

Please pick up this patch for 4.19. It fixes some warnings in the boot
code for x86 when using clang because that Makefile steamrolls
KBUILD_CFLAGS so CC_HAVE_ASM_GOTO is not defined, which triggers the
warnings in arch/x86/include/asm/cpufeature.h on line 143.

I've tested this with GCC 9.1.0 and a clang 9.0.0 build with asm goto
support on arm, arm64, and x86_64 and CONFIG_CC_HAS_ASM_GOTO and
CONFIG_JUMP_LABEL get enabled properly.

 Makefile                                      |  7 ------
 arch/Kconfig                                  |  1 +
 arch/arm/kernel/jump_label.c                  |  4 ----
 arch/arm64/kernel/jump_label.c                |  4 ----
 arch/mips/kernel/jump_label.c                 |  4 ----
 arch/powerpc/include/asm/asm-prototypes.h     |  2 +-
 arch/powerpc/kernel/jump_label.c              |  2 --
 .../platforms/powernv/opal-tracepoints.c      |  2 +-
 .../powerpc/platforms/powernv/opal-wrappers.S |  2 +-
 arch/powerpc/platforms/pseries/hvCall.S       |  4 ++--
 arch/powerpc/platforms/pseries/lpar.c         |  2 +-
 arch/s390/kernel/Makefile                     |  3 ++-
 arch/s390/kernel/jump_label.c                 |  4 ----
 arch/sparc/kernel/Makefile                    |  2 +-
 arch/sparc/kernel/jump_label.c                |  4 ----
 arch/x86/Makefile                             |  2 +-
 arch/x86/entry/calling.h                      |  2 +-
 arch/x86/include/asm/cpufeature.h             |  2 +-
 arch/x86/include/asm/jump_label.h             | 13 -----------
 arch/x86/include/asm/rmwcc.h                  |  6 ++---
 arch/x86/kernel/Makefile                      |  3 ++-
 arch/x86/kernel/jump_label.c                  |  4 ----
 arch/x86/kvm/emulate.c                        |  2 +-
 include/linux/dynamic_debug.h                 |  6 ++---
 include/linux/jump_label.h                    | 22 ++++++++-----------
 include/linux/jump_label_ratelimit.h          |  8 +++----
 include/linux/module.h                        |  2 +-
 include/linux/netfilter.h                     |  4 ++--
 include/linux/netfilter_ingress.h             |  2 +-
 init/Kconfig                                  |  3 +++
 kernel/jump_label.c                           | 10 +++------
 kernel/module.c                               |  2 +-
 kernel/sched/core.c                           |  2 +-
 kernel/sched/debug.c                          |  4 ++--
 kernel/sched/fair.c                           |  6 ++---
 kernel/sched/sched.h                          |  6 ++---
 lib/dynamic_debug.c                           |  2 +-
 net/core/dev.c                                |  6 ++---
 net/netfilter/core.c                          |  6 ++---
 scripts/gcc-goto.sh                           |  2 +-
 tools/arch/x86/include/asm/rmwcc.h            |  6 ++---
 41 files changed, 65 insertions(+), 115 deletions(-)

diff --git a/Makefile b/Makefile
index 5383dd317d59..ec326417527a 100644
--- a/Makefile
+++ b/Makefile
@@ -508,13 +508,6 @@ export RETPOLINE_VDSO_CFLAGS
 KBUILD_CFLAGS	+= $(call cc-option,-fno-PIE)
 KBUILD_AFLAGS	+= $(call cc-option,-fno-PIE)
 
-# check for 'asm goto'
-ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC) $(KBUILD_CFLAGS)), y)
-  CC_HAVE_ASM_GOTO := 1
-  KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
-  KBUILD_AFLAGS += -DCC_HAVE_ASM_GOTO
-endif
-
 # The expansion should be delayed until arch/$(SRCARCH)/Makefile is included.
 # Some architectures define CROSS_COMPILE in arch/$(SRCARCH)/Makefile.
 # CC_VERSION_TEXT is referenced from Kconfig (so it needs export),
diff --git a/arch/Kconfig b/arch/Kconfig
index 6801123932a5..a336548487e6 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -71,6 +71,7 @@ config KPROBES
 config JUMP_LABEL
        bool "Optimize very unlikely/likely branches"
        depends on HAVE_ARCH_JUMP_LABEL
+       depends on CC_HAS_ASM_GOTO
        help
          This option enables a transparent branch optimization that
 	 makes certain almost-always-true or almost-always-false branch
diff --git a/arch/arm/kernel/jump_label.c b/arch/arm/kernel/jump_label.c
index 90bce3d9928e..303b3ab87f7e 100644
--- a/arch/arm/kernel/jump_label.c
+++ b/arch/arm/kernel/jump_label.c
@@ -4,8 +4,6 @@
 #include <asm/patch.h>
 #include <asm/insn.h>
 
-#ifdef HAVE_JUMP_LABEL
-
 static void __arch_jump_label_transform(struct jump_entry *entry,
 					enum jump_label_type type,
 					bool is_static)
@@ -35,5 +33,3 @@ void arch_jump_label_transform_static(struct jump_entry *entry,
 {
 	__arch_jump_label_transform(entry, type, true);
 }
-
-#endif
diff --git a/arch/arm64/kernel/jump_label.c b/arch/arm64/kernel/jump_label.c
index e0756416e567..b90754aebd12 100644
--- a/arch/arm64/kernel/jump_label.c
+++ b/arch/arm64/kernel/jump_label.c
@@ -20,8 +20,6 @@
 #include <linux/jump_label.h>
 #include <asm/insn.h>
 
-#ifdef HAVE_JUMP_LABEL
-
 void arch_jump_label_transform(struct jump_entry *entry,
 			       enum jump_label_type type)
 {
@@ -49,5 +47,3 @@ void arch_jump_label_transform_static(struct jump_entry *entry,
 	 * NOP needs to be replaced by a branch.
 	 */
 }
-
-#endif	/* HAVE_JUMP_LABEL */
diff --git a/arch/mips/kernel/jump_label.c b/arch/mips/kernel/jump_label.c
index 32e3168316cd..ab943927f97a 100644
--- a/arch/mips/kernel/jump_label.c
+++ b/arch/mips/kernel/jump_label.c
@@ -16,8 +16,6 @@
 #include <asm/cacheflush.h>
 #include <asm/inst.h>
 
-#ifdef HAVE_JUMP_LABEL
-
 /*
  * Define parameters for the standard MIPS and the microMIPS jump
  * instruction encoding respectively:
@@ -70,5 +68,3 @@ void arch_jump_label_transform(struct jump_entry *e,
 
 	mutex_unlock(&text_mutex);
 }
-
-#endif /* HAVE_JUMP_LABEL */
diff --git a/arch/powerpc/include/asm/asm-prototypes.h b/arch/powerpc/include/asm/asm-prototypes.h
index 1f4691ce4126..e398173ae67d 100644
--- a/arch/powerpc/include/asm/asm-prototypes.h
+++ b/arch/powerpc/include/asm/asm-prototypes.h
@@ -38,7 +38,7 @@ extern struct static_key hcall_tracepoint_key;
 void __trace_hcall_entry(unsigned long opcode, unsigned long *args);
 void __trace_hcall_exit(long opcode, long retval, unsigned long *retbuf);
 /* OPAL tracing */
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 extern struct static_key opal_tracepoint_key;
 #endif
 
diff --git a/arch/powerpc/kernel/jump_label.c b/arch/powerpc/kernel/jump_label.c
index 6472472093d0..0080c5fbd225 100644
--- a/arch/powerpc/kernel/jump_label.c
+++ b/arch/powerpc/kernel/jump_label.c
@@ -11,7 +11,6 @@
 #include <linux/jump_label.h>
 #include <asm/code-patching.h>
 
-#ifdef HAVE_JUMP_LABEL
 void arch_jump_label_transform(struct jump_entry *entry,
 			       enum jump_label_type type)
 {
@@ -22,4 +21,3 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	else
 		patch_instruction(addr, PPC_INST_NOP);
 }
-#endif
diff --git a/arch/powerpc/platforms/powernv/opal-tracepoints.c b/arch/powerpc/platforms/powernv/opal-tracepoints.c
index 1ab7d26c0a2c..f16a43540e30 100644
--- a/arch/powerpc/platforms/powernv/opal-tracepoints.c
+++ b/arch/powerpc/platforms/powernv/opal-tracepoints.c
@@ -4,7 +4,7 @@
 #include <asm/trace.h>
 #include <asm/asm-prototypes.h>
 
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 struct static_key opal_tracepoint_key = STATIC_KEY_INIT;
 
 int opal_tracepoint_regfunc(void)
diff --git a/arch/powerpc/platforms/powernv/opal-wrappers.S b/arch/powerpc/platforms/powernv/opal-wrappers.S
index 251528231a9e..f4875fe3f8ff 100644
--- a/arch/powerpc/platforms/powernv/opal-wrappers.S
+++ b/arch/powerpc/platforms/powernv/opal-wrappers.S
@@ -20,7 +20,7 @@
 	.section	".text"
 
 #ifdef CONFIG_TRACEPOINTS
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 #define OPAL_BRANCH(LABEL)					\
 	ARCH_STATIC_BRANCH(LABEL, opal_tracepoint_key)
 #else
diff --git a/arch/powerpc/platforms/pseries/hvCall.S b/arch/powerpc/platforms/pseries/hvCall.S
index d91412c591ef..50dc9426d0be 100644
--- a/arch/powerpc/platforms/pseries/hvCall.S
+++ b/arch/powerpc/platforms/pseries/hvCall.S
@@ -19,7 +19,7 @@
 	
 #ifdef CONFIG_TRACEPOINTS
 
-#ifndef HAVE_JUMP_LABEL
+#ifndef CONFIG_JUMP_LABEL
 	.section	".toc","aw"
 
 	.globl hcall_tracepoint_refcount
@@ -79,7 +79,7 @@ hcall_tracepoint_refcount:
 	mr	r5,BUFREG;					\
 	__HCALL_INST_POSTCALL
 
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 #define HCALL_BRANCH(LABEL)					\
 	ARCH_STATIC_BRANCH(LABEL, hcall_tracepoint_key)
 #else
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index d3992ced0782..9e52b686a8fa 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -828,7 +828,7 @@ EXPORT_SYMBOL(arch_free_page);
 #endif /* CONFIG_PPC_BOOK3S_64 */
 
 #ifdef CONFIG_TRACEPOINTS
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 struct static_key hcall_tracepoint_key = STATIC_KEY_INIT;
 
 int hcall_tracepoint_regfunc(void)
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index dbfd1730e631..b205c0ff0b22 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -44,7 +44,7 @@ CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"'
 obj-y	:= traps.o time.o process.o base.o early.o setup.o idle.o vtime.o
 obj-y	+= processor.o sys_s390.o ptrace.o signal.o cpcmd.o ebcdic.o nmi.o
 obj-y	+= debug.o irq.o ipl.o dis.o diag.o vdso.o early_nobss.o
-obj-y	+= sysinfo.o jump_label.o lgr.o os_info.o machine_kexec.o pgm_check.o
+obj-y	+= sysinfo.o lgr.o os_info.o machine_kexec.o pgm_check.o
 obj-y	+= runtime_instr.o cache.o fpu.o dumpstack.o guarded_storage.o sthyi.o
 obj-y	+= entry.o reipl.o relocate_kernel.o kdebugfs.o alternative.o
 obj-y	+= nospec-branch.o
@@ -68,6 +68,7 @@ obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o ftrace.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_UPROBES)		+= uprobes.o
+obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o
 
 obj-$(CONFIG_KEXEC_FILE)	+= machine_kexec_file.o kexec_image.o
 obj-$(CONFIG_KEXEC_FILE)	+= kexec_elf.o
diff --git a/arch/s390/kernel/jump_label.c b/arch/s390/kernel/jump_label.c
index 43f8430fb67d..68f415e334a5 100644
--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -10,8 +10,6 @@
 #include <linux/jump_label.h>
 #include <asm/ipl.h>
 
-#ifdef HAVE_JUMP_LABEL
-
 struct insn {
 	u16 opcode;
 	s32 offset;
@@ -102,5 +100,3 @@ void arch_jump_label_transform_static(struct jump_entry *entry,
 {
 	__jump_label_transform(entry, type, 1);
 }
-
-#endif
diff --git a/arch/sparc/kernel/Makefile b/arch/sparc/kernel/Makefile
index cf8640841b7a..97c0e19263d1 100644
--- a/arch/sparc/kernel/Makefile
+++ b/arch/sparc/kernel/Makefile
@@ -118,4 +118,4 @@ pc--$(CONFIG_PERF_EVENTS) := perf_event.o
 obj-$(CONFIG_SPARC64)	+= $(pc--y)
 
 obj-$(CONFIG_UPROBES)	+= uprobes.o
-obj-$(CONFIG_SPARC64)	+= jump_label.o
+obj-$(CONFIG_JUMP_LABEL) += jump_label.o
diff --git a/arch/sparc/kernel/jump_label.c b/arch/sparc/kernel/jump_label.c
index 7f8eac51df33..a4cfaeecaf5e 100644
--- a/arch/sparc/kernel/jump_label.c
+++ b/arch/sparc/kernel/jump_label.c
@@ -9,8 +9,6 @@
 
 #include <asm/cacheflush.h>
 
-#ifdef HAVE_JUMP_LABEL
-
 void arch_jump_label_transform(struct jump_entry *entry,
 			       enum jump_label_type type)
 {
@@ -47,5 +45,3 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	flushi(insn);
 	mutex_unlock(&text_mutex);
 }
-
-#endif
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index ffc823a8312f..022d30768a92 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -305,7 +305,7 @@ vdso_install:
 
 archprepare: checkbin
 checkbin:
-ifndef CC_HAVE_ASM_GOTO
+ifndef CONFIG_CC_HAS_ASM_GOTO
 	@echo Compiler lacks asm-goto support.
 	@exit 1
 endif
diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 352e70cd33e8..e699b2041665 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -337,7 +337,7 @@ For 32-bit we have the following conventions - kernel is built with
  */
 .macro CALL_enter_from_user_mode
 #ifdef CONFIG_CONTEXT_TRACKING
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 	STATIC_JUMP_IF_FALSE .Lafter_call_\@, context_tracking_enabled, def=0
 #endif
 	call enter_from_user_mode
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index aced6c9290d6..ce95b8cbd229 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -140,7 +140,7 @@ extern void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int bit);
 
 #define setup_force_cpu_bug(bit) setup_force_cpu_cap(bit)
 
-#if defined(__clang__) && !defined(CC_HAVE_ASM_GOTO)
+#if defined(__clang__) && !defined(CONFIG_CC_HAS_ASM_GOTO)
 
 /*
  * Workaround for the sake of BPF compilation which utilizes kernel
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 8c0de4282659..7010e1c594c4 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -2,19 +2,6 @@
 #ifndef _ASM_X86_JUMP_LABEL_H
 #define _ASM_X86_JUMP_LABEL_H
 
-#ifndef HAVE_JUMP_LABEL
-/*
- * For better or for worse, if jump labels (the gcc extension) are missing,
- * then the entire static branch patching infrastructure is compiled out.
- * If that happens, the code in here will malfunction.  Raise a compiler
- * error instead.
- *
- * In theory, jump labels and the static branch patching infrastructure
- * could be decoupled to fix this.
- */
-#error asm/jump_label.h included on a non-jump-label kernel
-#endif
-
 #define JUMP_LABEL_NOP_SIZE 5
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/include/asm/rmwcc.h b/arch/x86/include/asm/rmwcc.h
index 4914a3e7c803..033dc7ca49e9 100644
--- a/arch/x86/include/asm/rmwcc.h
+++ b/arch/x86/include/asm/rmwcc.h
@@ -4,7 +4,7 @@
 
 #define __CLOBBERS_MEM(clb...)	"memory", ## clb
 
-#if !defined(__GCC_ASM_FLAG_OUTPUTS__) && defined(CC_HAVE_ASM_GOTO)
+#if !defined(__GCC_ASM_FLAG_OUTPUTS__) && defined(CONFIG_CC_HAS_ASM_GOTO)
 
 /* Use asm goto */
 
@@ -21,7 +21,7 @@ cc_label:								\
 #define __BINARY_RMWcc_ARG	" %1, "
 
 
-#else /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CC_HAVE_ASM_GOTO) */
+#else /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CONFIG_CC_HAS_ASM_GOTO) */
 
 /* Use flags output or a set instruction */
 
@@ -36,7 +36,7 @@ do {									\
 
 #define __BINARY_RMWcc_ARG	" %2, "
 
-#endif /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CC_HAVE_ASM_GOTO) */
+#endif /* defined(__GCC_ASM_FLAG_OUTPUTS__) || !defined(CONFIG_CC_HAS_ASM_GOTO) */
 
 #define GEN_UNARY_RMWcc(op, var, arg0, cc)				\
 	__GEN_RMWcc(op " " arg0, var, cc, __CLOBBERS_MEM())
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 8824d01c0c35..da0b6bc090f3 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -49,7 +49,8 @@ obj-$(CONFIG_COMPAT)	+= signal_compat.o
 obj-y			+= traps.o idt.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o dumpstack.o nmi.o
 obj-$(CONFIG_MODIFY_LDT_SYSCALL)	+= ldt.o
-obj-y			+= setup.o x86_init.o i8259.o irqinit.o jump_label.o
+obj-y			+= setup.o x86_init.o i8259.o irqinit.o
+obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o
 obj-$(CONFIG_IRQ_WORK)  += irq_work.o
 obj-y			+= probe_roms.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index eeea935e9bb5..4c3d9a3d45b2 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -16,8 +16,6 @@
 #include <asm/alternative.h>
 #include <asm/text-patching.h>
 
-#ifdef HAVE_JUMP_LABEL
-
 union jump_code_union {
 	char code[JUMP_LABEL_NOP_SIZE];
 	struct {
@@ -142,5 +140,3 @@ __init_or_module void arch_jump_label_transform_static(struct jump_entry *entry,
 	if (jlstate == JL_STATE_UPDATE)
 		__jump_label_transform(entry, type, text_poke_early, 1);
 }
-
-#endif
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 860bd271619d..4a688ef9e448 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -456,7 +456,7 @@ FOP_END;
 
 /*
  * XXX: inoutclob user must know where the argument is being expanded.
- *      Relying on CC_HAVE_ASM_GOTO would allow us to remove _fault.
+ *      Relying on CONFIG_CC_HAS_ASM_GOTO would allow us to remove _fault.
  */
 #define asm_safe(insn, inoutclob...) \
 ({ \
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 2fd8006153c3..b3419da1a776 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -2,7 +2,7 @@
 #ifndef _DYNAMIC_DEBUG_H
 #define _DYNAMIC_DEBUG_H
 
-#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+#if defined(CONFIG_JUMP_LABEL)
 #include <linux/jump_label.h>
 #endif
 
@@ -38,7 +38,7 @@ struct _ddebug {
 #define _DPRINTK_FLAGS_DEFAULT 0
 #endif
 	unsigned int flags:8;
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 	union {
 		struct static_key_true dd_key_true;
 		struct static_key_false dd_key_false;
@@ -83,7 +83,7 @@ void __dynamic_netdev_dbg(struct _ddebug *descriptor,
 		dd_key_init(key, init)				\
 	}
 
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 
 #define dd_key_init(key, init) key = (init)
 
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 1a0b6f17a5d6..4c3e77687d4e 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -71,10 +71,6 @@
  * Additional babbling in: Documentation/static-keys.txt
  */
 
-#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
-# define HAVE_JUMP_LABEL
-#endif
-
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
@@ -86,7 +82,7 @@ extern bool static_key_initialized;
 				    "%s(): static key '%pS' used before call to jump_label_init()", \
 				    __func__, (key))
 
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 
 struct static_key {
 	atomic_t enabled;
@@ -114,10 +110,10 @@ struct static_key {
 struct static_key {
 	atomic_t enabled;
 };
-#endif	/* HAVE_JUMP_LABEL */
+#endif	/* CONFIG_JUMP_LABEL */
 #endif /* __ASSEMBLY__ */
 
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 #include <asm/jump_label.h>
 #endif
 
@@ -130,7 +126,7 @@ enum jump_label_type {
 
 struct module;
 
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 
 #define JUMP_TYPE_FALSE		0UL
 #define JUMP_TYPE_TRUE		1UL
@@ -184,7 +180,7 @@ extern void static_key_disable_cpuslocked(struct static_key *key);
 	{ .enabled = { 0 },					\
 	  { .entries = (void *)JUMP_TYPE_FALSE } }
 
-#else  /* !HAVE_JUMP_LABEL */
+#else  /* !CONFIG_JUMP_LABEL */
 
 #include <linux/atomic.h>
 #include <linux/bug.h>
@@ -271,7 +267,7 @@ static inline void static_key_disable(struct static_key *key)
 #define STATIC_KEY_INIT_TRUE	{ .enabled = ATOMIC_INIT(1) }
 #define STATIC_KEY_INIT_FALSE	{ .enabled = ATOMIC_INIT(0) }
 
-#endif	/* HAVE_JUMP_LABEL */
+#endif	/* CONFIG_JUMP_LABEL */
 
 #define STATIC_KEY_INIT STATIC_KEY_INIT_FALSE
 #define jump_label_enabled static_key_enabled
@@ -335,7 +331,7 @@ extern bool ____wrong_branch_error(void);
 	static_key_count((struct static_key *)x) > 0;				\
 })
 
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 
 /*
  * Combine the right initial value (type) with the right branch order
@@ -417,12 +413,12 @@ extern bool ____wrong_branch_error(void);
 	unlikely(branch);							\
 })
 
-#else /* !HAVE_JUMP_LABEL */
+#else /* !CONFIG_JUMP_LABEL */
 
 #define static_branch_likely(x)		likely(static_key_enabled(&(x)->key))
 #define static_branch_unlikely(x)	unlikely(static_key_enabled(&(x)->key))
 
-#endif /* HAVE_JUMP_LABEL */
+#endif /* CONFIG_JUMP_LABEL */
 
 /*
  * Advanced usage; refcount, branch is enabled when: count != 0
diff --git a/include/linux/jump_label_ratelimit.h b/include/linux/jump_label_ratelimit.h
index baa8eabbaa56..a49f2b45b3f0 100644
--- a/include/linux/jump_label_ratelimit.h
+++ b/include/linux/jump_label_ratelimit.h
@@ -5,21 +5,19 @@
 #include <linux/jump_label.h>
 #include <linux/workqueue.h>
 
-#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+#if defined(CONFIG_JUMP_LABEL)
 struct static_key_deferred {
 	struct static_key key;
 	unsigned long timeout;
 	struct delayed_work work;
 };
-#endif
 
-#ifdef HAVE_JUMP_LABEL
 extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
 extern void static_key_deferred_flush(struct static_key_deferred *key);
 extern void
 jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
 
-#else	/* !HAVE_JUMP_LABEL */
+#else	/* !CONFIG_JUMP_LABEL */
 struct static_key_deferred {
 	struct static_key  key;
 };
@@ -38,5 +36,5 @@ jump_label_rate_limit(struct static_key_deferred *key,
 {
 	STATIC_KEY_CHECK_USE(key);
 }
-#endif	/* HAVE_JUMP_LABEL */
+#endif	/* CONFIG_JUMP_LABEL */
 #endif	/* _LINUX_JUMP_LABEL_RATELIMIT_H */
diff --git a/include/linux/module.h b/include/linux/module.h
index 904f94628132..c71044644979 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -433,7 +433,7 @@ struct module {
 	unsigned int num_tracepoints;
 	tracepoint_ptr_t *tracepoints_ptrs;
 #endif
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 	struct jump_entry *jump_entries;
 	unsigned int num_jump_entries;
 #endif
diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index bbe99d2b28b4..72cb19c3db6a 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -176,7 +176,7 @@ void nf_unregister_net_hooks(struct net *net, const struct nf_hook_ops *reg,
 int nf_register_sockopt(struct nf_sockopt_ops *reg);
 void nf_unregister_sockopt(struct nf_sockopt_ops *reg);
 
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 extern struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 #endif
 
@@ -198,7 +198,7 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct net *net,
 	struct nf_hook_entries *hook_head = NULL;
 	int ret = 1;
 
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 	if (__builtin_constant_p(pf) &&
 	    __builtin_constant_p(hook) &&
 	    !static_key_false(&nf_hooks_needed[pf][hook]))
diff --git a/include/linux/netfilter_ingress.h b/include/linux/netfilter_ingress.h
index 554c920691dd..a13774be2eb5 100644
--- a/include/linux/netfilter_ingress.h
+++ b/include/linux/netfilter_ingress.h
@@ -8,7 +8,7 @@
 #ifdef CONFIG_NETFILTER_INGRESS
 static inline bool nf_hook_ingress_active(const struct sk_buff *skb)
 {
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 	if (!static_key_false(&nf_hooks_needed[NFPROTO_NETDEV][NF_NETDEV_INGRESS]))
 		return false;
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index 864af10bb1b9..47035b5a46f6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -23,6 +23,9 @@ config CLANG_VERSION
 	int
 	default $(shell,$(srctree)/scripts/clang-version.sh $(CC))
 
+config CC_HAS_ASM_GOTO
+	def_bool $(success,$(srctree)/scripts/gcc-goto.sh $(CC))
+
 config CONSTRUCTORS
 	bool
 	depends on !UML
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 2e62503bea0d..7c8262635b29 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -18,8 +18,6 @@
 #include <linux/cpu.h>
 #include <asm/sections.h>
 
-#ifdef HAVE_JUMP_LABEL
-
 /* mutex to protect coming/going of the the jump_label table */
 static DEFINE_MUTEX(jump_label_mutex);
 
@@ -60,13 +58,13 @@ jump_label_sort_entries(struct jump_entry *start, struct jump_entry *stop)
 static void jump_label_update(struct static_key *key);
 
 /*
- * There are similar definitions for the !HAVE_JUMP_LABEL case in jump_label.h.
+ * There are similar definitions for the !CONFIG_JUMP_LABEL case in jump_label.h.
  * The use of 'atomic_read()' requires atomic.h and its problematic for some
  * kernel headers such as kernel.h and others. Since static_key_count() is not
- * used in the branch statements as it is for the !HAVE_JUMP_LABEL case its ok
+ * used in the branch statements as it is for the !CONFIG_JUMP_LABEL case its ok
  * to have it be a function here. Similarly, for 'static_key_enable()' and
  * 'static_key_disable()', which require bug.h. This should allow jump_label.h
- * to be included from most/all places for HAVE_JUMP_LABEL.
+ * to be included from most/all places for CONFIG_JUMP_LABEL.
  */
 int static_key_count(struct static_key *key)
 {
@@ -796,5 +794,3 @@ static __init int jump_label_test(void)
 }
 early_initcall(jump_label_test);
 #endif /* STATIC_KEYS_SELFTEST */
-
-#endif /* HAVE_JUMP_LABEL */
diff --git a/kernel/module.c b/kernel/module.c
index 38bf28b5cc20..c1d59a90491d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3095,7 +3095,7 @@ static int find_module_sections(struct module *mod, struct load_info *info)
 					     sizeof(*mod->tracepoints_ptrs),
 					     &mod->num_tracepoints);
 #endif
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 	mod->jump_entries = section_objs(info, "__jump_table",
 					sizeof(*mod->jump_entries),
 					&mod->num_jump_entries);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d7f409866cdf..7abb89ab9822 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -24,7 +24,7 @@
 
 DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
-#if defined(CONFIG_SCHED_DEBUG) && defined(HAVE_JUMP_LABEL)
+#if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_JUMP_LABEL)
 /*
  * Debugging: various feature bits
  *
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 141ea9ff210e..78fadf0438ea 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -73,7 +73,7 @@ static int sched_feat_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 
 #define jump_label_key__true  STATIC_KEY_INIT_TRUE
 #define jump_label_key__false STATIC_KEY_INIT_FALSE
@@ -99,7 +99,7 @@ static void sched_feat_enable(int i)
 #else
 static void sched_feat_disable(int i) { };
 static void sched_feat_enable(int i) { };
-#endif /* HAVE_JUMP_LABEL */
+#endif /* CONFIG_JUMP_LABEL */
 
 static int sched_feat_set(char *cmp)
 {
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d31916366d39..a8e72f0ac1c9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4209,7 +4209,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 
 #ifdef CONFIG_CFS_BANDWIDTH
 
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 static struct static_key __cfs_bandwidth_used;
 
 static inline bool cfs_bandwidth_used(void)
@@ -4226,7 +4226,7 @@ void cfs_bandwidth_usage_dec(void)
 {
 	static_key_slow_dec_cpuslocked(&__cfs_bandwidth_used);
 }
-#else /* HAVE_JUMP_LABEL */
+#else /* CONFIG_JUMP_LABEL */
 static bool cfs_bandwidth_used(void)
 {
 	return true;
@@ -4234,7 +4234,7 @@ static bool cfs_bandwidth_used(void)
 
 void cfs_bandwidth_usage_inc(void) {}
 void cfs_bandwidth_usage_dec(void) {}
-#endif /* HAVE_JUMP_LABEL */
+#endif /* CONFIG_JUMP_LABEL */
 
 /*
  * default period for cfs group bandwidth.
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4c7a837d7c14..9a7c3d08b39f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1359,7 +1359,7 @@ enum {
 
 #undef SCHED_FEAT
 
-#if defined(CONFIG_SCHED_DEBUG) && defined(HAVE_JUMP_LABEL)
+#if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_JUMP_LABEL)
 
 /*
  * To support run-time toggling of sched features, all the translation units
@@ -1379,7 +1379,7 @@ static __always_inline bool static_branch_##name(struct static_key *key) \
 extern struct static_key sched_feat_keys[__SCHED_FEAT_NR];
 #define sched_feat(x) (static_branch_##x(&sched_feat_keys[__SCHED_FEAT_##x]))
 
-#else /* !(SCHED_DEBUG && HAVE_JUMP_LABEL) */
+#else /* !(SCHED_DEBUG && CONFIG_JUMP_LABEL) */
 
 /*
  * Each translation unit has its own copy of sysctl_sched_features to allow
@@ -1395,7 +1395,7 @@ static const_debug __maybe_unused unsigned int sysctl_sched_features =
 
 #define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
 
-#endif /* SCHED_DEBUG && HAVE_JUMP_LABEL */
+#endif /* SCHED_DEBUG && CONFIG_JUMP_LABEL */
 
 extern struct static_key_false sched_numa_balancing;
 extern struct static_key_false sched_schedstats;
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index c7c96bc7654a..dbf2b457e47e 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -188,7 +188,7 @@ static int ddebug_change(const struct ddebug_query *query,
 			newflags = (dp->flags & mask) | flags;
 			if (newflags == dp->flags)
 				continue;
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 			if (dp->flags & _DPRINTK_FLAGS_PRINT) {
 				if (!(flags & _DPRINTK_FLAGS_PRINT))
 					static_branch_disable(&dp->key.dd_key_true);
diff --git a/net/core/dev.c b/net/core/dev.c
index 13a82744a00a..a71b7f4981f8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1821,7 +1821,7 @@ EXPORT_SYMBOL_GPL(net_dec_egress_queue);
 #endif
 
 static DEFINE_STATIC_KEY_FALSE(netstamp_needed_key);
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 static atomic_t netstamp_needed_deferred;
 static atomic_t netstamp_wanted;
 static void netstamp_clear(struct work_struct *work)
@@ -1840,7 +1840,7 @@ static DECLARE_WORK(netstamp_work, netstamp_clear);
 
 void net_enable_timestamp(void)
 {
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 	int wanted;
 
 	while (1) {
@@ -1860,7 +1860,7 @@ EXPORT_SYMBOL(net_enable_timestamp);
 
 void net_disable_timestamp(void)
 {
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 	int wanted;
 
 	while (1) {
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index dc240cb47ddf..93aaec3a54ec 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -33,7 +33,7 @@ EXPORT_SYMBOL_GPL(nf_ipv6_ops);
 DEFINE_PER_CPU(bool, nf_skb_duplicated);
 EXPORT_SYMBOL_GPL(nf_skb_duplicated);
 
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 EXPORT_SYMBOL(nf_hooks_needed);
 #endif
@@ -347,7 +347,7 @@ static int __nf_register_net_hook(struct net *net, int pf,
 	if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
 		net_inc_ingress_queue();
 #endif
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 	static_key_slow_inc(&nf_hooks_needed[pf][reg->hooknum]);
 #endif
 	BUG_ON(p == new_hooks);
@@ -405,7 +405,7 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 		if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
 			net_dec_ingress_queue();
 #endif
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 		static_key_slow_dec(&nf_hooks_needed[pf][reg->hooknum]);
 #endif
 	} else {
diff --git a/scripts/gcc-goto.sh b/scripts/gcc-goto.sh
index 083c526073ef..8b980fb2270a 100755
--- a/scripts/gcc-goto.sh
+++ b/scripts/gcc-goto.sh
@@ -3,7 +3,7 @@
 # Test for gcc 'asm goto' support
 # Copyright (C) 2010, Jason Baron <jbaron@redhat.com>
 
-cat << "END" | $@ -x c - -c -o /dev/null >/dev/null 2>&1 && echo "y"
+cat << "END" | $@ -x c - -fno-PIE -c -o /dev/null
 int main(void)
 {
 #if defined(__arm__) || defined(__aarch64__)
diff --git a/tools/arch/x86/include/asm/rmwcc.h b/tools/arch/x86/include/asm/rmwcc.h
index dc90c0c2fae3..fee7983a90b4 100644
--- a/tools/arch/x86/include/asm/rmwcc.h
+++ b/tools/arch/x86/include/asm/rmwcc.h
@@ -2,7 +2,7 @@
 #ifndef _TOOLS_LINUX_ASM_X86_RMWcc
 #define _TOOLS_LINUX_ASM_X86_RMWcc
 
-#ifdef CC_HAVE_ASM_GOTO
+#ifdef CONFIG_CC_HAS_ASM_GOTO
 
 #define __GEN_RMWcc(fullop, var, cc, ...)				\
 do {									\
@@ -20,7 +20,7 @@ cc_label:								\
 #define GEN_BINARY_RMWcc(op, var, vcon, val, arg0, cc)			\
 	__GEN_RMWcc(op " %1, " arg0, var, cc, vcon (val))
 
-#else /* !CC_HAVE_ASM_GOTO */
+#else /* !CONFIG_CC_HAS_ASM_GOTO */
 
 #define __GEN_RMWcc(fullop, var, cc, ...)				\
 do {									\
@@ -37,6 +37,6 @@ do {									\
 #define GEN_BINARY_RMWcc(op, var, vcon, val, arg0, cc)			\
 	__GEN_RMWcc(op " %2, " arg0, var, cc, vcon (val))
 
-#endif /* CC_HAVE_ASM_GOTO */
+#endif /* CONFIG_CC_HAS_ASM_GOTO */
 
 #endif /* _TOOLS_LINUX_ASM_X86_RMWcc */
-- 
2.22.0.rc2

