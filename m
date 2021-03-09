Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165B1332B85
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 17:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhCIQIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 11:08:40 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:53936 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbhCIQIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 11:08:14 -0500
Date:   Tue, 09 Mar 2021 16:08:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615306093;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0CLFxvYtbnQu30o06lG6/QY8MyBjV65kC6WDtbUgXPo=;
        b=r07hMu6xjNSdIT2Rybqemaz8oXygEsw1X8cT+chYuvr56UjQoJdwUH2rTpa7fGo2qSBhWq
        KMw4EMO1J+RSKtpaJWbGYWgjFxf/uvzN48VMCj0xs8+LGU2xAggNENm5SwQgTV8kuwjRui
        07piqW4nqSVjtOCQMEFr2Rmzu4kRb4rU+Q9h+8priNFVZTR3Ncjsk7sqg+9/Zsv5iOT9DZ
        bKySXTqy/gi23RC9rsCOsM+3gVq3Tl8/fsf2sEEqLQacUufn0iWwccBsg8M+aS6DmX4Fsk
        3IfOfrll5vxT2VIKkzbZW/hTbXlkbUqYWSTWQJ8FX/FPMk5dr0YMgCN25UlfRQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615306093;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0CLFxvYtbnQu30o06lG6/QY8MyBjV65kC6WDtbUgXPo=;
        b=spQel0pkrdh8jpdoDSf2Cn1TnXG/mXaK+Wb6IsQfDRka4XwSLqLs782n3QMKDxPdt2ZAWr
        G/+meEIPeV+DBiCg==
From:   "tip-bot2 for Joerg Roedel" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sev-es: Introduce ip_within_syscall_gap() helper
Cc:     Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>,
        stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        5.10+@tip-bot2.tec.linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210303141716.29223-2-joro@8bytes.org>
References: <20210303141716.29223-2-joro@8bytes.org>
MIME-Version: 1.0
Message-ID: <161530609259.398.2946836058294820769.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     78a81d88f60ba773cbe890205e1ee67f00502948
Gitweb:        https://git.kernel.org/tip/78a81d88f60ba773cbe890205e1ee67f00502948
Author:        Joerg Roedel <jroedel@suse.de>
AuthorDate:    Wed, 03 Mar 2021 15:17:12 +01:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 08 Mar 2021 14:22:17 +01:00

x86/sev-es: Introduce ip_within_syscall_gap() helper

Introduce a helper to check whether an exception came from the syscall
gap and use it in the SEV-ES code. Extend the check to also cover the
compatibility SYSCALL entry path.

Fixes: 315562c9af3d5 ("x86/sev-es: Adjust #VC IST Stack on entering NMI handler")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org # 5.10+
Link: https://lkml.kernel.org/r/20210303141716.29223-2-joro@8bytes.org
---
 arch/x86/entry/entry_64_compat.S |  2 ++
 arch/x86/include/asm/proto.h     |  1 +
 arch/x86/include/asm/ptrace.h    | 15 +++++++++++++++
 arch/x86/kernel/traps.c          |  3 +--
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index 541fdaf..0051cf5 100644
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
index 2c35f1c..b6a9d51 100644
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
index d8324a2..409f661 100644
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
index 7f5aec7..ac1874a 100644
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
