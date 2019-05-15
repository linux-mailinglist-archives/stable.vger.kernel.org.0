Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4272C1F286
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbfEOLLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:11:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729414AbfEOLLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87DBC20843;
        Wed, 15 May 2019 11:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918706;
        bh=FTEsq0Izl/156k72JmWu9fo5PR4FGCZvEiY5YIAEHuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NiNE72SpCcZnRsaOS1X4EN7nNM4XZrMMnTwoMtoBoGNfYHblNW7NsXBnIxADmK55A
         trcElUgGdjEnanqaJ4Q+xjoot01HRj6avf8CK+MONSqc2FKMFfaj6o2zSfpNDE47Pz
         ASyj0D0rOTFdQe7Sv+cY2Cl66RQAkHfvGEzgh7Y4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Jon Masters <jcm@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 234/266] x86/speculation/mds: Clear CPU buffers on exit to user
Date:   Wed, 15 May 2019 12:55:41 +0200
Message-Id: <20190515090730.918029836@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 04dcbdb8057827b043b3c71aa397c4c63e67d086 upstream.

Add a static key which controls the invocation of the CPU buffer clear
mechanism on exit to user space and add the call into
prepare_exit_to_usermode() and do_nmi() right before actually returning.

Add documentation which kernel to user space transition this covers and
explain why some corner cases are not mitigated.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Jon Masters <jcm@redhat.com>
Tested-by: Jon Masters <jcm@redhat.com>
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/x86/mds.rst            |   52 +++++++++++++++++++++++++++++++++++
 arch/x86/entry/common.c              |    3 ++
 arch/x86/include/asm/nospec-branch.h |   13 ++++++++
 arch/x86/kernel/cpu/bugs.c           |    3 ++
 arch/x86/kernel/nmi.c                |    4 ++
 arch/x86/kernel/traps.c              |    8 +++++
 6 files changed, 83 insertions(+)

--- a/Documentation/x86/mds.rst
+++ b/Documentation/x86/mds.rst
@@ -97,3 +97,55 @@ According to current knowledge additiona
 itself are not required because the necessary gadgets to expose the leaked
 data cannot be controlled in a way which allows exploitation from malicious
 user space or VM guests.
+
+Mitigation points
+-----------------
+
+1. Return to user space
+^^^^^^^^^^^^^^^^^^^^^^^
+
+   When transitioning from kernel to user space the CPU buffers are flushed
+   on affected CPUs when the mitigation is not disabled on the kernel
+   command line. The migitation is enabled through the static key
+   mds_user_clear.
+
+   The mitigation is invoked in prepare_exit_to_usermode() which covers
+   most of the kernel to user space transitions. There are a few exceptions
+   which are not invoking prepare_exit_to_usermode() on return to user
+   space. These exceptions use the paranoid exit code.
+
+   - Non Maskable Interrupt (NMI):
+
+     Access to sensible data like keys, credentials in the NMI context is
+     mostly theoretical: The CPU can do prefetching or execute a
+     misspeculated code path and thereby fetching data which might end up
+     leaking through a buffer.
+
+     But for mounting other attacks the kernel stack address of the task is
+     already valuable information. So in full mitigation mode, the NMI is
+     mitigated on the return from do_nmi() to provide almost complete
+     coverage.
+
+   - Double fault (#DF):
+
+     A double fault is usually fatal, but the ESPFIX workaround, which can
+     be triggered from user space through modify_ldt(2) is a recoverable
+     double fault. #DF uses the paranoid exit path, so explicit mitigation
+     in the double fault handler is required.
+
+   - Machine Check Exception (#MC):
+
+     Another corner case is a #MC which hits between the CPU buffer clear
+     invocation and the actual return to user. As this still is in kernel
+     space it takes the paranoid exit path which does not clear the CPU
+     buffers. So the #MC handler repopulates the buffers to some
+     extent. Machine checks are not reliably controllable and the window is
+     extremly small so mitigation would just tick a checkbox that this
+     theoretical corner case is covered. To keep the amount of special
+     cases small, ignore #MC.
+
+   - Debug Exception (#DB):
+
+     This takes the paranoid exit path only when the INT1 breakpoint is in
+     kernel space. #DB on a user space address takes the regular exit path,
+     so no extra mitigation required.
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -28,6 +28,7 @@
 #include <asm/vdso.h>
 #include <asm/uaccess.h>
 #include <asm/cpufeature.h>
+#include <asm/nospec-branch.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/syscalls.h>
@@ -295,6 +296,8 @@ __visible inline void prepare_exit_to_us
 #endif
 
 	user_enter();
+
+	mds_user_clear_cpu_buffers();
 }
 
 #define SYSCALL_EXIT_WORK_FLAGS				\
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -262,6 +262,8 @@ DECLARE_STATIC_KEY_FALSE(switch_to_cond_
 DECLARE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
 DECLARE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
+DECLARE_STATIC_KEY_FALSE(mds_user_clear);
+
 #include <asm/segment.h>
 
 /**
@@ -287,6 +289,17 @@ static inline void mds_clear_cpu_buffers
 	asm volatile("verw %[ds]" : : [ds] "m" (ds) : "cc");
 }
 
+/**
+ * mds_user_clear_cpu_buffers - Mitigation for MDS vulnerability
+ *
+ * Clear CPU buffers if the corresponding static key is enabled
+ */
+static inline void mds_user_clear_cpu_buffers(void)
+{
+	if (static_branch_likely(&mds_user_clear))
+		mds_clear_cpu_buffers();
+}
+
 #endif /* __ASSEMBLY__ */
 
 /*
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -58,6 +58,9 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_i
 /* Control unconditional IBPB in switch_mm() */
 DEFINE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
+/* Control MDS CPU buffer clear before returning to user space */
+DEFINE_STATIC_KEY_FALSE(mds_user_clear);
+
 void __init check_bugs(void)
 {
 	identify_boot_cpu();
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -29,6 +29,7 @@
 #include <asm/mach_traps.h>
 #include <asm/nmi.h>
 #include <asm/x86_init.h>
+#include <asm/nospec-branch.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/nmi.h>
@@ -522,6 +523,9 @@ nmi_restart:
 		write_cr2(this_cpu_read(nmi_cr2));
 	if (this_cpu_dec_return(nmi_state))
 		goto nmi_restart;
+
+	if (user_mode(regs))
+		mds_user_clear_cpu_buffers();
 }
 NOKPROBE_SYMBOL(do_nmi);
 
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -61,6 +61,7 @@
 #include <asm/alternative.h>
 #include <asm/fpu/xstate.h>
 #include <asm/trace/mpx.h>
+#include <asm/nospec-branch.h>
 #include <asm/mpx.h>
 #include <asm/vm86.h>
 
@@ -337,6 +338,13 @@ dotraplinkage void do_double_fault(struc
 		regs->ip = (unsigned long)general_protection;
 		regs->sp = (unsigned long)&normal_regs->orig_ax;
 
+		/*
+		 * This situation can be triggered by userspace via
+		 * modify_ldt(2) and the return does not take the regular
+		 * user space exit, so a CPU buffer clear is required when
+		 * MDS mitigation is enabled.
+		 */
+		mds_user_clear_cpu_buffers();
 		return;
 	}
 #endif


