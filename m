Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CD232C814
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344957AbhCDAdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:33:54 -0500
Received: from 8bytes.org ([81.169.241.247]:57304 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242972AbhCCOSg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Mar 2021 09:18:36 -0500
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id CC9513A7;
        Wed,  3 Mar 2021 15:17:22 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        stable@vger.kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 1/5] x86/sev-es: Introduce ip_within_syscall_gap() helper
Date:   Wed,  3 Mar 2021 15:17:12 +0100
Message-Id: <20210303141716.29223-2-joro@8bytes.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210303141716.29223-1-joro@8bytes.org>
References: <20210303141716.29223-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Introduce a helper to check whether an exception came from the syscall
gap and use it in the SEV-ES code. Extend the check to also cover the
compatibility SYSCALL entry path.

Fixes: 315562c9af3d5 ("x86/sev-es: Adjust #VC IST Stack on entering NMI handler")
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/entry/entry_64_compat.S |  2 ++
 arch/x86/include/asm/proto.h     |  1 +
 arch/x86/include/asm/ptrace.h    | 15 +++++++++++++++
 arch/x86/kernel/traps.c          |  3 +--
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index 541fdaf64045..0051cf5c792d 100644
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -210,6 +210,8 @@ SYM_CODE_START(entry_SYSCALL_compat)
 	/* Switch to the kernel stack */
 	movq	PER_CPU_VAR(cpu_current_top_of_stack), %rsp
 
+SYM_INNER_LABEL(entry_SYSCALL_compat_safe_stack, SYM_L_GLOBAL)
+
 	/* Construct struct pt_regs on stack */
 	pushq	$__USER32_DS		/* pt_regs->ss */
 	pushq	%r8			/* pt_regs->sp */
diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
index 2c35f1c01a2d..b6a9d51d1d79 100644
--- a/arch/x86/include/asm/proto.h
+++ b/arch/x86/include/asm/proto.h
@@ -25,6 +25,7 @@ void __end_SYSENTER_singlestep_region(void);
 void entry_SYSENTER_compat(void);
 void __end_entry_SYSENTER_compat(void);
 void entry_SYSCALL_compat(void);
+void entry_SYSCALL_compat_safe_stack(void);
 void entry_INT80_compat(void);
 #ifdef CONFIG_XEN_PV
 void xen_entry_INT80_compat(void);
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index d8324a236696..409f661481e1 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -94,6 +94,8 @@ struct pt_regs {
 #include <asm/paravirt_types.h>
 #endif
 
+#include <asm/proto.h>
+
 struct cpuinfo_x86;
 struct task_struct;
 
@@ -175,6 +177,19 @@ static inline bool any_64bit_mode(struct pt_regs *regs)
 #ifdef CONFIG_X86_64
 #define current_user_stack_pointer()	current_pt_regs()->sp
 #define compat_user_stack_pointer()	current_pt_regs()->sp
+
+static inline bool ip_within_syscall_gap(struct pt_regs *regs)
+{
+	bool ret = (regs->ip >= (unsigned long)entry_SYSCALL_64 &&
+		    regs->ip <  (unsigned long)entry_SYSCALL_64_safe_stack);
+
+#ifdef CONFIG_IA32_EMULATION
+	ret = ret || (regs->ip >= (unsigned long)entry_SYSCALL_compat &&
+		      regs->ip <  (unsigned long)entry_SYSCALL_compat_safe_stack);
+#endif
+
+	return ret;
+}
 #endif
 
 static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 7f5aec758f0e..ac1874a2a70e 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -694,8 +694,7 @@ asmlinkage __visible noinstr struct pt_regs *vc_switch_off_ist(struct pt_regs *r
 	 * In the SYSCALL entry path the RSP value comes from user-space - don't
 	 * trust it and switch to the current kernel stack
 	 */
-	if (regs->ip >= (unsigned long)entry_SYSCALL_64 &&
-	    regs->ip <  (unsigned long)entry_SYSCALL_64_safe_stack) {
+	if (ip_within_syscall_gap(regs)) {
 		sp = this_cpu_read(cpu_current_top_of_stack);
 		goto sync;
 	}
-- 
2.30.1

