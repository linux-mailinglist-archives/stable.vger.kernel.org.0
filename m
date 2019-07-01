Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE1E720BE4
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfEPP6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:58:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43022 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727088AbfEPP6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:48 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImK-0006zl-Fd; Thu, 16 May 2019 16:58:44 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001Rq-Ms; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Borislav Petkov" <bp@suse.de>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Jon Masters" <jcm@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Frederic Weisbecker" <frederic@kernel.org>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.866567195@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 68/86] x86/speculation/mds: Conditionally clear CPU
 buffers on idle entry
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

commit 07f07f55a29cb705e221eda7894dd67ab81ef343 upstream.

Add a static key which controls the invocation of the CPU buffer clear
mechanism on idle entry. This is independent of other MDS mitigations
because the idle entry invocation to mitigate the potential leakage due to
store buffer repartitioning is only necessary on SMT systems.

Add the actual invocations to the different halt/mwait variants which
covers all usage sites. mwaitx is not patched as it's not available on
Intel CPUs.

The buffer clear is only invoked before entering the C-State to prevent
that stale data from the idling CPU is spilled to the Hyper-Thread sibling
after the Store buffer got repartitioned and all entries are available to
the non idle sibling.

When coming out of idle the store buffer is partitioned again so each
sibling has half of it available. Now CPU which returned from idle could be
speculatively exposed to contents of the sibling, but the buffers are
flushed either on exit to user space or on VMENTER.

When later on conditional buffer clearing is implemented on top of this,
then there is no action required either because before returning to user
space the context switch will set the condition flag which causes a flush
on the return to user path.

Note, that the buffer clearing on idle is only sensible on CPUs which are
solely affected by MSBDS and not any other variant of MDS because the other
MDS variants cannot be mitigated when SMT is enabled, so the buffer
clearing on idle would be a window dressing exercise.

This intentionally does not handle the case in the acpi/processor_idle
driver which uses the legacy IO port interface for C-State transitions for
two reasons:

 - The acpi/processor_idle driver was replaced by the intel_idle driver
   almost a decade ago. Anything Nehalem upwards supports it and defaults
   to that new driver.

 - The legacy IO port interface is likely to be used on older and therefore
   unaffected CPUs or on systems which do not receive microcode updates
   anymore, so there is no point in adding that.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Jon Masters <jcm@redhat.com>
Tested-by: Jon Masters <jcm@redhat.com>
[bwh: Backported to 3.16:
 - Drop change in _mwaitx()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/Documentation/x86/mds.rst
+++ b/Documentation/x86/mds.rst
@@ -149,3 +149,45 @@ Mitigation points
      This takes the paranoid exit path only when the INT1 breakpoint is in
      kernel space. #DB on a user space address takes the regular exit path,
      so no extra mitigation required.
+
+
+2. C-State transition
+^^^^^^^^^^^^^^^^^^^^^
+
+   When a CPU goes idle and enters a C-State the CPU buffers need to be
+   cleared on affected CPUs when SMT is active. This addresses the
+   repartitioning of the store buffer when one of the Hyper-Threads enters
+   a C-State.
+
+   When SMT is inactive, i.e. either the CPU does not support it or all
+   sibling threads are offline CPU buffer clearing is not required.
+
+   The idle clearing is enabled on CPUs which are only affected by MSBDS
+   and not by any other MDS variant. The other MDS variants cannot be
+   protected against cross Hyper-Thread attacks because the Fill Buffer and
+   the Load Ports are shared. So on CPUs affected by other variants, the
+   idle clearing would be a window dressing exercise and is therefore not
+   activated.
+
+   The invocation is controlled by the static key mds_idle_clear which is
+   switched depending on the chosen mitigation mode and the SMT state of
+   the system.
+
+   The buffer clear is only invoked before entering the C-State to prevent
+   that stale data from the idling CPU from spilling to the Hyper-Thread
+   sibling after the store buffer got repartitioned and all entries are
+   available to the non idle sibling.
+
+   When coming out of idle the store buffer is partitioned again so each
+   sibling has half of it available. The back from idle CPU could be then
+   speculatively exposed to contents of the sibling. The buffers are
+   flushed either on exit to user space or on VMENTER so malicious code
+   in user space or the guest cannot speculatively access them.
+
+   The mitigation is hooked into all variants of halt()/mwait(), but does
+   not cover the legacy ACPI IO-Port mechanism because the ACPI idle driver
+   has been superseded by the intel_idle driver around 2010 and is
+   preferred on all affected CPUs which are expected to gain the MD_CLEAR
+   functionality in microcode. Aside of that the IO-Port mechanism is a
+   legacy interface which is only used on older systems which are either
+   not affected or do not receive microcode updates anymore.
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -4,6 +4,9 @@
 #include <asm/processor-flags.h>
 
 #ifndef __ASSEMBLY__
+
+#include <asm/nospec-branch.h>
+
 /*
  * Interrupt control:
  */
@@ -46,11 +49,13 @@ static inline void native_irq_enable(voi
 
 static inline void native_safe_halt(void)
 {
+	mds_idle_clear_cpu_buffers();
 	asm volatile("sti; hlt": : :"memory");
 }
 
 static inline void native_halt(void)
 {
+	mds_idle_clear_cpu_buffers();
 	asm volatile("hlt": : :"memory");
 }
 
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -4,6 +4,7 @@
 #include <linux/sched.h>
 
 #include <asm/cpufeature.h>
+#include <asm/nospec-branch.h>
 
 #define MWAIT_SUBSTATE_MASK		0xf
 #define MWAIT_CSTATE_MASK		0xf
@@ -27,6 +28,8 @@ static inline void __monitor(const void
 
 static inline void __mwait(unsigned long eax, unsigned long ecx)
 {
+	mds_idle_clear_cpu_buffers();
+
 	/* "mwait %eax, %ecx;" */
 	asm volatile(".byte 0x0f, 0x01, 0xc9;"
 		     :: "a" (eax), "c" (ecx));
@@ -34,6 +37,8 @@ static inline void __mwait(unsigned long
 
 static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 {
+	mds_idle_clear_cpu_buffers();
+
 	trace_hardirqs_on();
 	/* "mwait %eax, %ecx;" */
 	asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -263,6 +263,7 @@ DECLARE_STATIC_KEY_FALSE(switch_mm_cond_
 DECLARE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 
 DECLARE_STATIC_KEY_FALSE(mds_user_clear);
+DECLARE_STATIC_KEY_FALSE(mds_idle_clear);
 
 #include <asm/segment.h>
 
@@ -300,6 +301,17 @@ static inline void mds_user_clear_cpu_bu
 		mds_clear_cpu_buffers();
 }
 
+/**
+ * mds_idle_clear_cpu_buffers - Mitigation for MDS vulnerability
+ *
+ * Clear CPU buffers if the corresponding static key is enabled
+ */
+static inline void mds_idle_clear_cpu_buffers(void)
+{
+	if (static_branch_likely(&mds_idle_clear))
+		mds_clear_cpu_buffers();
+}
+
 #endif /* __ASSEMBLY__ */
 
 #ifdef __ASSEMBLY__
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -60,6 +60,9 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_always
 
 /* Control MDS CPU buffer clear before returning to user space */
 DEFINE_STATIC_KEY_FALSE(mds_user_clear);
+/* Control MDS CPU buffer clear before idling (halt, mwait) */
+DEFINE_STATIC_KEY_FALSE(mds_idle_clear);
+EXPORT_SYMBOL_GPL(mds_idle_clear);
 
 /* For use by asm MDS_CLEAR_CPU_BUFFERS */
 const u16 mds_clear_cpu_buffers_ds = __KERNEL_DS;

