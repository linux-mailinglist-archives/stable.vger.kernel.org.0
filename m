Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF04572414
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbiGLS4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234908AbiGLSzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:55:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6D4EABD0;
        Tue, 12 Jul 2022 11:46:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6A5A0CE1D67;
        Tue, 12 Jul 2022 18:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F84C3411C;
        Tue, 12 Jul 2022 18:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651577;
        bh=GIEThlDtnvK8qlEc+Re+qg9RuqDWS0iY9Tzeocl1874=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zzhv3C6wY6DV12cpo5YuTqkGL18+Gy5W72iZBav8yxsKBe9RB4YqMTTlA5bofMQeu
         cQF5QhbplZrkr2VgbJFfN4GGkhX03BHgCmxBDKNv1RK3ntIVKQcFbDA6vqkUZcSbXE
         CbzEtMTuRzUVT4X/MCvt6CbBLZsWo2zrd4sS4lzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 120/130] KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS
Date:   Tue, 12 Jul 2022 20:39:26 +0200
Message-Id: <20220712183252.013664249@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit fc02735b14fff8c6678b521d324ade27b1a3d4cf upstream.

On eIBRS systems, the returns in the vmexit return path from
__vmx_vcpu_run() to vmx_vcpu_run() are exposed to RSB poisoning attacks.

Fix that by moving the post-vmexit spec_ctrl handling to immediately
after the vmexit.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    1 
 arch/x86/kernel/cpu/bugs.c           |    4 ++
 arch/x86/kvm/vmx/run_flags.h         |    1 
 arch/x86/kvm/vmx/vmenter.S           |   49 +++++++++++++++++++++++++++--------
 arch/x86/kvm/vmx/vmx.c               |   48 ++++++++++++++++++++--------------
 arch/x86/kvm/vmx/vmx.h               |    1 
 6 files changed, 73 insertions(+), 31 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -275,6 +275,7 @@ static inline void indirect_branch_predi
 
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
+extern u64 x86_spec_ctrl_current;
 extern void write_spec_ctrl_current(u64 val, bool force);
 extern u64 spec_ctrl_current(void);
 
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -186,6 +186,10 @@ void __init check_bugs(void)
 #endif
 }
 
+/*
+ * NOTE: For VMX, this function is not called in the vmexit path.
+ * It uses vmx_spec_ctrl_restore_host() instead.
+ */
 void
 x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
 {
--- a/arch/x86/kvm/vmx/run_flags.h
+++ b/arch/x86/kvm/vmx/run_flags.h
@@ -3,5 +3,6 @@
 #define __KVM_X86_VMX_RUN_FLAGS_H
 
 #define VMX_RUN_VMRESUME	(1 << 0)
+#define VMX_RUN_SAVE_SPEC_CTRL	(1 << 1)
 
 #endif /* __KVM_X86_VMX_RUN_FLAGS_H */
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -33,9 +33,10 @@
 
 /**
  * __vmx_vcpu_run - Run a vCPU via a transition to VMX guest mode
- * @vmx:	struct vcpu_vmx * (forwarded to vmx_update_host_rsp)
+ * @vmx:	struct vcpu_vmx *
  * @regs:	unsigned long * (to guest registers)
- * @flags:	VMX_RUN_VMRESUME: use VMRESUME instead of VMLAUNCH
+ * @flags:	VMX_RUN_VMRESUME:	use VMRESUME instead of VMLAUNCH
+ *		VMX_RUN_SAVE_SPEC_CTRL: save guest SPEC_CTRL into vmx->spec_ctrl
  *
  * Returns:
  *	0 on VM-Exit, 1 on VM-Fail
@@ -54,6 +55,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
 #endif
 	push %_ASM_BX
 
+	/* Save @vmx for SPEC_CTRL handling */
+	push %_ASM_ARG1
+
+	/* Save @flags for SPEC_CTRL handling */
+	push %_ASM_ARG3
+
 	/*
 	 * Save @regs, _ASM_ARG2 may be modified by vmx_update_host_rsp() and
 	 * @regs is needed after VM-Exit to save the guest's register values.
@@ -148,25 +155,23 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL
 	mov %r15, VCPU_R15(%_ASM_AX)
 #endif
 
-	/* IMPORTANT: RSB must be stuffed before the first return. */
-	FILL_RETURN_BUFFER %_ASM_BX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
-
-	/* Clear RAX to indicate VM-Exit (as opposed to VM-Fail). */
-	xor %eax, %eax
+	/* Clear return value to indicate VM-Exit (as opposed to VM-Fail). */
+	xor %ebx, %ebx
 
 .Lclear_regs:
 	/*
-	 * Clear all general purpose registers except RSP and RAX to prevent
+	 * Clear all general purpose registers except RSP and RBX to prevent
 	 * speculative use of the guest's values, even those that are reloaded
 	 * via the stack.  In theory, an L1 cache miss when restoring registers
 	 * could lead to speculative execution with the guest's values.
 	 * Zeroing XORs are dirt cheap, i.e. the extra paranoia is essentially
 	 * free.  RSP and RAX are exempt as RSP is restored by hardware during
-	 * VM-Exit and RAX is explicitly loaded with 0 or 1 to return VM-Fail.
+	 * VM-Exit and RBX is explicitly loaded with 0 or 1 to hold the return
+	 * value.
 	 */
+	xor %eax, %eax
 	xor %ecx, %ecx
 	xor %edx, %edx
-	xor %ebx, %ebx
 	xor %ebp, %ebp
 	xor %esi, %esi
 	xor %edi, %edi
@@ -184,6 +189,28 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL
 	/* "POP" @regs. */
 	add $WORD_SIZE, %_ASM_SP
 
+	/*
+	 * IMPORTANT: RSB filling and SPEC_CTRL handling must be done before
+	 * the first unbalanced RET after vmexit!
+	 *
+	 * For retpoline, RSB filling is needed to prevent poisoned RSB entries
+	 * and (in some cases) RSB underflow.
+	 *
+	 * eIBRS has its own protection against poisoned RSB, so it doesn't
+	 * need the RSB filling sequence.  But it does need to be enabled
+	 * before the first unbalanced RET.
+         */
+
+	FILL_RETURN_BUFFER %_ASM_CX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
+
+	pop %_ASM_ARG2	/* @flags */
+	pop %_ASM_ARG1	/* @vmx */
+
+	call vmx_spec_ctrl_restore_host
+
+	/* Put return value in AX */
+	mov %_ASM_BX, %_ASM_AX
+
 	pop %_ASM_BX
 #ifdef CONFIG_X86_64
 	pop %r12
@@ -203,7 +230,7 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL
 	ud2
 .Lvmfail:
 	/* VM-Fail: set return value to 1 */
-	mov $1, %eax
+	mov $1, %_ASM_BX
 	jmp .Lclear_regs
 
 SYM_FUNC_END(__vmx_vcpu_run)
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -943,6 +943,14 @@ unsigned int __vmx_vcpu_run_flags(struct
 	if (vmx->loaded_vmcs->launched)
 		flags |= VMX_RUN_VMRESUME;
 
+	/*
+	 * If writes to the SPEC_CTRL MSR aren't intercepted, the guest is free
+	 * to change it directly without causing a vmexit.  In that case read
+	 * it after vmexit and store it in vmx->spec_ctrl.
+	 */
+	if (unlikely(!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL)))
+		flags |= VMX_RUN_SAVE_SPEC_CTRL;
+
 	return flags;
 }
 
@@ -6685,6 +6693,26 @@ void noinstr vmx_update_host_rsp(struct
 	}
 }
 
+void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
+					unsigned int flags)
+{
+	u64 hostval = this_cpu_read(x86_spec_ctrl_current);
+
+	if (!cpu_feature_enabled(X86_FEATURE_MSR_SPEC_CTRL))
+		return;
+
+	if (flags & VMX_RUN_SAVE_SPEC_CTRL)
+		vmx->spec_ctrl = __rdmsr(MSR_IA32_SPEC_CTRL);
+
+	/*
+	 * If the guest/host SPEC_CTRL values differ, restore the host value.
+	 */
+	if (vmx->spec_ctrl != hostval)
+		native_wrmsrl(MSR_IA32_SPEC_CTRL, hostval);
+
+	barrier_nospec();
+}
+
 static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
 	switch (to_vmx(vcpu)->exit_reason.basic) {
@@ -6837,26 +6865,6 @@ reenter_guest:
 	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
 	vmx_vcpu_enter_exit(vcpu, vmx, __vmx_vcpu_run_flags(vmx));
 
-	/*
-	 * We do not use IBRS in the kernel. If this vCPU has used the
-	 * SPEC_CTRL MSR it may have left it on; save the value and
-	 * turn it off. This is much more efficient than blindly adding
-	 * it to the atomic save/restore list. Especially as the former
-	 * (Saving guest MSRs on vmexit) doesn't even exist in KVM.
-	 *
-	 * For non-nested case:
-	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 *
-	 * For nested case:
-	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 */
-	if (unlikely(!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL)))
-		vmx->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
-
-	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
-
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs))
 		current_evmcs->hv_clean_fields |=
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -366,6 +366,7 @@ void vmx_set_virtual_apic_mode(struct kv
 struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
+void vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx, unsigned int flags);
 unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx);
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs,
 		    unsigned int flags);


