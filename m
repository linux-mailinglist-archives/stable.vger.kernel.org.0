Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADCA20BF3
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfEPQAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:00:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43088 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727105AbfEPP6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:48 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImK-0006zr-Fx; Thu, 16 May 2019 16:58:44 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001Rj-LS; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Frederic Weisbecker" <frederic@kernel.org>,
        "Dominik Brodowski" <linux@dominikbrodowski.net>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Jon Masters" <jcm@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, x86@kernel.org,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Borislav Petkov" <bp@suse.de>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.38392125@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 67/86] x86/speculation/mds: Clear CPU buffers on exit
 to user
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
[bwh: Backported to 3.16: Add an assembly macro equivalent to
 mds_user_clear_cpu_buffers() and use this in the system call exit path,
 as we don't have prepare_exit_to_usermode()]
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
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
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -262,6 +262,8 @@ DECLARE_STATIC_KEY_FALSE(switch_to_cond_
 DECLARE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
 DECLARE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
+DECLARE_STATIC_KEY_FALSE(mds_user_clear);
+
 #include <asm/segment.h>
 
 /**
@@ -287,5 +289,31 @@ static inline void mds_clear_cpu_buffers
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
+
+#ifdef __ASSEMBLY__
+.macro MDS_USER_CLEAR_CPU_BUFFERS
+#ifdef CONFIG_JUMP_LABEL
+	STATIC_JUMP_IF_FALSE .Lmds_skip_clear_\@, mds_user_clear, def=0
+#endif
+#ifdef CONFIG_X86_64
+	verw	mds_clear_cpu_buffers_ds(%rip)
+#else
+	verw	mds_clear_cpu_buffers_ds
+#endif
+.Lmds_skip_clear_\@:
+.endm
+#endif
+
 #endif /* _ASM_X86_NOSPEC_BRANCH_H_ */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -58,6 +58,12 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_i
 /* Control unconditional IBPB in switch_mm() */
 DEFINE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
+/* Control MDS CPU buffer clear before returning to user space */
+DEFINE_STATIC_KEY_FALSE(mds_user_clear);
+
+/* For use by asm MDS_CLEAR_CPU_BUFFERS */
+const u16 mds_clear_cpu_buffers_ds = __KERNEL_DS;
+
 #ifdef CONFIG_X86_32
 
 static double __initdata x = 4195835.0;
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
@@ -55,6 +55,7 @@
 #include <asm/fixmap.h>
 #include <asm/mach_traps.h>
 #include <asm/alternative.h>
+#include <asm/nospec-branch.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -258,6 +259,14 @@ dotraplinkage void do_double_fault(struc
 		normal_regs->orig_ax = 0;  /* Missing (lost) #GP error code */
 		regs->ip = (unsigned long)general_protection;
 		regs->sp = (unsigned long)&normal_regs->orig_ax;
+
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
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -443,6 +443,7 @@ sysenter_after_call:
 	testl $_TIF_ALLWORK_MASK, %ecx
 	jne sysexit_audit
 sysenter_exit:
+	MDS_USER_CLEAR_CPU_BUFFERS
 /* if something modifies registers it must also disable sysexit */
 	movl PT_EIP(%esp), %edx
 	movl PT_OLDESP(%esp), %ecx
@@ -531,6 +532,7 @@ syscall_exit:
 	jne syscall_exit_work
 
 restore_all:
+	MDS_USER_CLEAR_CPU_BUFFERS
 	TRACE_IRQS_IRET
 restore_all_notrace:
 #ifdef CONFIG_X86_ESPFIX32
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -475,6 +475,7 @@ sysret_check:
 	movl TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET),%edx
 	andl %edi,%edx
 	jnz  sysret_careful
+	MDS_USER_CLEAR_CPU_BUFFERS
 	CFI_REMEMBER_STATE
 	/*
 	 * sysretq will re-enable interrupts:
@@ -870,6 +871,7 @@ retint_swapgs:		/* return to user-space
 	 * The iretq could re-enable interrupts:
 	 */
 	DISABLE_INTERRUPTS(CLBR_ANY)
+	MDS_USER_CLEAR_CPU_BUFFERS
 	TRACE_IRQS_IRETQ
 	/*
 	 * This opens a window where we have a user CR3, but are
@@ -1384,7 +1386,7 @@ paranoid_userspace:
 	GET_THREAD_INFO(%rcx)
 	movl TI_flags(%rcx),%ebx
 	andl $_TIF_WORK_MASK,%ebx
-	jz paranoid_kernel
+	jz paranoid_userspace_done
 	movq %rsp,%rdi			/* &pt_regs */
 	call sync_regs
 	movq %rax,%rsp			/* switch stack for scheduling */
@@ -1406,6 +1408,9 @@ paranoid_schedule:
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
 	jmp paranoid_userspace
+paranoid_userspace_done:
+	MDS_USER_CLEAR_CPU_BUFFERS
+	jmp paranoid_kernel
 	CFI_ENDPROC
 END(paranoid_exit)
 
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -188,6 +188,7 @@ sysenter_dispatch:
 	testl	$_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz	sysexit_audit
 sysexit_from_sys_call:
+	MDS_USER_CLEAR_CPU_BUFFERS
 	andl    $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	/* clear IF, that popfq doesn't enable interrupts early */
 	andl  $~0x200,EFLAGS-R11(%rsp) 
@@ -362,6 +363,7 @@ cstar_dispatch:
 	testl $_TIF_ALLWORK_MASK,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz sysretl_audit
 sysretl_from_sys_call:
+	MDS_USER_CLEAR_CPU_BUFFERS
 	andl $~TS_COMPAT,TI_status+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	RESTORE_ARGS 0,-ARG_SKIP,0,0,0
 	movl RIP-ARGOFFSET(%rsp),%ecx

