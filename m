Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0308933BAB2
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235665AbhCOOKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234634AbhCOOEg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29096601FD;
        Mon, 15 Mar 2021 14:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817075;
        bh=a5dFQLmPODNEZdfFFdpwNGbuv6Bx/XSnfOSNpPuOyGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJlHo4YNvfq4neZiUkQWgDZeGHQAFzso3VPlk6zFoaxhmILd5l1Jrx6OA5BY1nZ9t
         X5K/MOxZwC8oL7CbzbLK+5fvSABWvKoIWgdypuG/2t2zuJ8z0F52oY7fhxxCC05ypv
         BxdA2oD+QmVYT8kVoPTsVTZh1CEfsjgJiHK5v3Is=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.11 287/306] x86/sev-es: Introduce ip_within_syscall_gap() helper
Date:   Mon, 15 Mar 2021 14:55:50 +0100
Message-Id: <20210315135517.388600712@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Joerg Roedel <jroedel@suse.de>

commit 78a81d88f60ba773cbe890205e1ee67f00502948 upstream.

Introduce a helper to check whether an exception came from the syscall
gap and use it in the SEV-ES code. Extend the check to also cover the
compatibility SYSCALL entry path.

Fixes: 315562c9af3d5 ("x86/sev-es: Adjust #VC IST Stack on entering NMI handler")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org # 5.10+
Link: https://lkml.kernel.org/r/20210303141716.29223-2-joro@8bytes.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64_compat.S |    2 ++
 arch/x86/include/asm/proto.h     |    1 +
 arch/x86/include/asm/ptrace.h    |   15 +++++++++++++++
 arch/x86/kernel/traps.c          |    3 +--
 4 files changed, 19 insertions(+), 2 deletions(-)

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
--- a/arch/x86/include/asm/proto.h
+++ b/arch/x86/include/asm/proto.h
@@ -25,6 +25,7 @@ void __end_SYSENTER_singlestep_region(vo
 void entry_SYSENTER_compat(void);
 void __end_entry_SYSENTER_compat(void);
 void entry_SYSCALL_compat(void);
+void entry_SYSCALL_compat_safe_stack(void);
 void entry_INT80_compat(void);
 #ifdef CONFIG_XEN_PV
 void xen_entry_INT80_compat(void);
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -94,6 +94,8 @@ struct pt_regs {
 #include <asm/paravirt_types.h>
 #endif
 
+#include <asm/proto.h>
+
 struct cpuinfo_x86;
 struct task_struct;
 
@@ -175,6 +177,19 @@ static inline bool any_64bit_mode(struct
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
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -694,8 +694,7 @@ asmlinkage __visible noinstr struct pt_r
 	 * In the SYSCALL entry path the RSP value comes from user-space - don't
 	 * trust it and switch to the current kernel stack
 	 */
-	if (regs->ip >= (unsigned long)entry_SYSCALL_64 &&
-	    regs->ip <  (unsigned long)entry_SYSCALL_64_safe_stack) {
+	if (ip_within_syscall_gap(regs)) {
 		sp = this_cpu_read(cpu_current_top_of_stack);
 		goto sync;
 	}


