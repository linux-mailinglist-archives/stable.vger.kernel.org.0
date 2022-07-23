Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E7757EE4F
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238997AbiGWKKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239163AbiGWKJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:09:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E715FCBD09;
        Sat, 23 Jul 2022 03:02:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BE0B611BD;
        Sat, 23 Jul 2022 10:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1A3C341C0;
        Sat, 23 Jul 2022 10:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570533;
        bh=N3qLSRnfhNQQ+z7m0DDtKuNmKRtrSS1K8O0XNISvmOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+2szLaPqLGpxa/ObTAdxq0Utrw84gQIMXBouoqOT4CKMeVhjjHE7VPgJoSrQR5zz
         MZ+pmC/1KtHjIj45Nnv8fASJhJzrbpKDxKQ+avXFINrvp78bmGlAp0KD50b3vKIb64
         sO0GWeUuppoo7pmj8rZYjFRgCuBSW+lt8TSaWE0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 119/148] KVM: VMX: Convert launched argument to flags
Date:   Sat, 23 Jul 2022 11:55:31 +0200
Message-Id: <20220723095257.638599760@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit bb06650634d3552c0f8557e9d16aa1a408040e28 upstream.

Convert __vmx_vcpu_run()'s 'launched' argument to 'flags', in
preparation for doing SPEC_CTRL handling immediately after vmexit, which
will need another flag.

This is much easier than adding a fourth argument, because this code
supports both 32-bit and 64-bit, and the fourth argument on 32-bit would
have to be pushed on the stack.

Note that __vmx_vcpu_run_flags() is called outside of the noinstr
critical section because it will soon start calling potentially
traceable functions.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c    |    2 +-
 arch/x86/kvm/vmx/run_flags.h |    7 +++++++
 arch/x86/kvm/vmx/vmenter.S   |    9 +++++----
 arch/x86/kvm/vmx/vmx.c       |   17 ++++++++++++++---
 arch/x86/kvm/vmx/vmx.h       |    5 ++++-
 5 files changed, 31 insertions(+), 9 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/run_flags.h

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3077,7 +3077,7 @@ static int nested_vmx_check_vmentry_hw(s
 	}
 
 	vm_fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
-				 vmx->loaded_vmcs->launched);
+				 __vmx_vcpu_run_flags(vmx));
 
 	if (vmx->msr_autoload.host.nr)
 		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
--- /dev/null
+++ b/arch/x86/kvm/vmx/run_flags.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_VMX_RUN_FLAGS_H
+#define __KVM_X86_VMX_RUN_FLAGS_H
+
+#define VMX_RUN_VMRESUME	(1 << 0)
+
+#endif /* __KVM_X86_VMX_RUN_FLAGS_H */
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -5,6 +5,7 @@
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/nospec-branch.h>
 #include <asm/segment.h>
+#include "run_flags.h"
 
 #define WORD_SIZE (BITS_PER_LONG / 8)
 
@@ -34,7 +35,7 @@
  * __vmx_vcpu_run - Run a vCPU via a transition to VMX guest mode
  * @vmx:	struct vcpu_vmx * (forwarded to vmx_update_host_rsp)
  * @regs:	unsigned long * (to guest registers)
- * @launched:	%true if the VMCS has been launched
+ * @flags:	VMX_RUN_VMRESUME: use VMRESUME instead of VMLAUNCH
  *
  * Returns:
  *	0 on VM-Exit, 1 on VM-Fail
@@ -59,7 +60,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	 */
 	push %_ASM_ARG2
 
-	/* Copy @launched to BL, _ASM_ARG3 is volatile. */
+	/* Copy @flags to BL, _ASM_ARG3 is volatile. */
 	mov %_ASM_ARG3B, %bl
 
 	lea (%_ASM_SP), %_ASM_ARG2
@@ -69,7 +70,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	mov (%_ASM_SP), %_ASM_AX
 
 	/* Check if vmlaunch or vmresume is needed */
-	testb %bl, %bl
+	testb $VMX_RUN_VMRESUME, %bl
 
 	/* Load guest registers.  Don't clobber flags. */
 	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
@@ -92,7 +93,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
 	/* Check EFLAGS.ZF from 'testb' above */
-	je .Lvmlaunch
+	jz .Lvmlaunch
 
 	/*
 	 * After a successful VMRESUME/VMLAUNCH, control flow "magically"
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -936,6 +936,16 @@ static bool msr_write_intercepted(struct
 	return true;
 }
 
+unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
+{
+	unsigned int flags = 0;
+
+	if (vmx->loaded_vmcs->launched)
+		flags |= VMX_RUN_VMRESUME;
+
+	return flags;
+}
+
 static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 		unsigned long entry, unsigned long exit)
 {
@@ -6688,7 +6698,8 @@ static fastpath_t vmx_exit_handlers_fast
 }
 
 static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
-					struct vcpu_vmx *vmx)
+					struct vcpu_vmx *vmx,
+					unsigned long flags)
 {
 	/*
 	 * VMENTER enables interrupts (host state), but the kernel state is
@@ -6725,7 +6736,7 @@ static noinstr void vmx_vcpu_enter_exit(
 		native_write_cr2(vcpu->arch.cr2);
 
 	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
-				   vmx->loaded_vmcs->launched);
+				   flags);
 
 	vcpu->arch.cr2 = native_read_cr2();
 
@@ -6824,7 +6835,7 @@ reenter_guest:
 	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
 
 	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
-	vmx_vcpu_enter_exit(vcpu, vmx);
+	vmx_vcpu_enter_exit(vcpu, vmx, __vmx_vcpu_run_flags(vmx));
 
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -13,6 +13,7 @@
 #include "vmcs.h"
 #include "vmx_ops.h"
 #include "cpuid.h"
+#include "run_flags.h"
 
 extern const u32 vmx_msr_index[];
 
@@ -365,7 +366,9 @@ void vmx_set_virtual_apic_mode(struct kv
 struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
-bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
+unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx);
+bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs,
+		    unsigned int flags);
 int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
 


