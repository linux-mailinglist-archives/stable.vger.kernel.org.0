Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36E66ECE96
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbjDXNdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbjDXNd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:33:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144AD8690
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:33:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B82CB62332
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8EBC433D2;
        Mon, 24 Apr 2023 13:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343188;
        bh=/W9s31DHC7xP0Q+IyCK4NLGcdW4czDtsgWCdEtzKh/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMZk132QcwXAv8QNVH1qmKXVROJbT5mfoNA+kC+8IPQp5krflQuCG/F8wBM7n1JTq
         /7ugOjDAJmbcACoPDj4S4uxC5MCc6NArUwQcWmjudxfGDlTnKuD0DQGLsOtm7UZgA2
         8rnSNw0Kdmz/JbjvKeLcVcSKvM632rsOakdIay04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.2 097/110] LoongArch: Make -mstrict-align configurable
Date:   Mon, 24 Apr 2023 15:17:59 +0200
Message-Id: <20230424131140.190795824@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhuacai@loongson.cn>

commit 41596803302d83a67a80dc1efef4e51ac46acabb upstream.

Introduce Kconfig option ARCH_STRICT_ALIGN to make -mstrict-align be
configurable.

Not all LoongArch cores support h/w unaligned access, we can use the
-mstrict-align build parameter to prevent unaligned accesses.

CPUs with h/w unaligned access support:
Loongson-2K2000/2K3000/3A5000/3C5000/3D5000.

CPUs without h/w unaligned access support:
Loongson-2K500/2K1000.

This option is enabled by default to make the kernel be able to run on
all LoongArch systems. But you can disable it manually if you want to
run kernel only on systems with h/w unaligned access support in order to
optimise for performance.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/Kconfig         |   19 +++++++++++++++++++
 arch/loongarch/Makefile        |    5 +++++
 arch/loongarch/kernel/Makefile |    4 +++-
 arch/loongarch/kernel/traps.c  |    9 +++++++--
 4 files changed, 34 insertions(+), 3 deletions(-)

--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -94,6 +94,7 @@ config LOONGARCH
 	select HAVE_DYNAMIC_FTRACE_WITH_ARGS
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS
 	select HAVE_EBPF_JIT
+	select HAVE_EFFICIENT_UNALIGNED_ACCESS if !ARCH_STRICT_ALIGN
 	select HAVE_EXIT_THREAD
 	select HAVE_FAST_GUP
 	select HAVE_FTRACE_MCOUNT_RECORD
@@ -441,6 +442,24 @@ config ARCH_IOREMAP
 	  protection support. However, you can enable LoongArch DMW-based
 	  ioremap() for better performance.
 
+config ARCH_STRICT_ALIGN
+	bool "Enable -mstrict-align to prevent unaligned accesses" if EXPERT
+	default y
+	help
+	  Not all LoongArch cores support h/w unaligned access, we can use
+	  -mstrict-align build parameter to prevent unaligned accesses.
+
+	  CPUs with h/w unaligned access support:
+	  Loongson-2K2000/2K3000/3A5000/3C5000/3D5000.
+
+	  CPUs without h/w unaligned access support:
+	  Loongson-2K500/2K1000.
+
+	  This option is enabled by default to make the kernel be able to run
+	  on all LoongArch systems. But you can disable it manually if you want
+	  to run kernel only on systems with h/w unaligned access support in
+	  order to optimise for performance.
+
 config KEXEC
 	bool "Kexec system call"
 	select KEXEC_CORE
--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -91,10 +91,15 @@ KBUILD_CPPFLAGS += -DVMLINUX_LOAD_ADDRES
 # instead of .eh_frame so we don't discard them.
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 
+ifdef CONFIG_ARCH_STRICT_ALIGN
 # Don't emit unaligned accesses.
 # Not all LoongArch cores support unaligned access, and as kernel we can't
 # rely on others to provide emulation for these accesses.
 KBUILD_CFLAGS += $(call cc-option,-mstrict-align)
+else
+# Optimise for performance on hardware supports unaligned access.
+KBUILD_CFLAGS += $(call cc-option,-mno-strict-align)
+endif
 
 KBUILD_CFLAGS += -isystem $(shell $(CC) -print-file-name=include)
 
--- a/arch/loongarch/kernel/Makefile
+++ b/arch/loongarch/kernel/Makefile
@@ -8,13 +8,15 @@ extra-y		:= vmlinux.lds
 obj-y		+= head.o cpu-probe.o cacheinfo.o env.o setup.o entry.o genex.o \
 		   traps.o irq.o idle.o process.o dma.o mem.o io.o reset.o switch.o \
 		   elf.o syscall.o signal.o time.o topology.o inst.o ptrace.o vdso.o \
-		   alternative.o unaligned.o unwind.o
+		   alternative.o unwind.o
 
 obj-$(CONFIG_ACPI)		+= acpi.o
 obj-$(CONFIG_EFI) 		+= efi.o
 
 obj-$(CONFIG_CPU_HAS_FPU)	+= fpu.o
 
+obj-$(CONFIG_ARCH_STRICT_ALIGN)	+= unaligned.o
+
 ifdef CONFIG_FUNCTION_TRACER
   ifndef CONFIG_DYNAMIC_FTRACE
     obj-y += mcount.o ftrace.o
--- a/arch/loongarch/kernel/traps.c
+++ b/arch/loongarch/kernel/traps.c
@@ -371,9 +371,14 @@ int no_unaligned_warning __read_mostly =
 
 asmlinkage void noinstr do_ale(struct pt_regs *regs)
 {
-	unsigned int *pc;
 	irqentry_state_t state = irqentry_enter(regs);
 
+#ifndef CONFIG_ARCH_STRICT_ALIGN
+	die_if_kernel("Kernel ale access", regs);
+	force_sig_fault(SIGBUS, BUS_ADRALN, (void __user *)regs->csr_badvaddr);
+#else
+	unsigned int *pc;
+
 	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, regs->csr_badvaddr);
 
 	/*
@@ -397,8 +402,8 @@ asmlinkage void noinstr do_ale(struct pt
 sigbus:
 	die_if_kernel("Kernel ale access", regs);
 	force_sig_fault(SIGBUS, BUS_ADRALN, (void __user *)regs->csr_badvaddr);
-
 out:
+#endif
 	irqentry_exit(regs, state);
 }
 


