Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51D35F30F3
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiJCNNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiJCNNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:13:18 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AB852DCC;
        Mon,  3 Oct 2022 06:12:48 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.174.77])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 6857F42EBB;
        Mon,  3 Oct 2022 13:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664802755;
        bh=p+dhzt+mCu3Jb3Vfaup5mHGu8hqMrbFdStOAYJ32xDE=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=nvi/4oAfUj8uixHvw7IagCMtHFH+ZMNnNQkrlRM/p3JGc7Nx4krU31GeQkogHWa9K
         F6wRPgBYNXXnCxI+qldlL1Sniwq+PD0eiYZWnXDFu+nxZC4Lxu3A6PS8z+pJ9q4dE/
         a+Mz7LZPg6SOWQZk8PrzWMu+pdil1GXltI/R5PRpZVMhpMT79LaYvysvwxAdgX/cNM
         5TpksH4R9YJF5Hz0eBqOI0PM1EYbobnWrGZFlL8rstFSPJXZ6t0ITZBwIwhN94Zxl+
         +SJhW28s2vaFwaD3e1ATQV64TIh5hQX41io6e91pTpShxmqNdVugibsLEa7RKiR6uD
         fhxnIBIjwL3Dw==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org
Subject: [PATCH 5.4 28/37] KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS
Date:   Mon,  3 Oct 2022 10:10:29 -0300
Message-Id: <20221003131038.12645-29-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221003131038.12645-1-cascardo@canonical.com>
References: <20221003131038.12645-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
---
 arch/x86/include/asm/nospec-branch.h |  1 +
 arch/x86/kernel/cpu/bugs.c           |  4 +++
 arch/x86/kvm/vmx/run_flags.h         |  1 +
 arch/x86/kvm/vmx/vmenter.S           | 49 +++++++++++++++++++++-------
 arch/x86/kvm/vmx/vmx.c               | 48 +++++++++++++++------------
 arch/x86/kvm/vmx/vmx.h               |  1 +
 6 files changed, 73 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 3c78a1b3451c..a95eec0cb787 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -296,6 +296,7 @@ static inline void indirect_branch_prediction_barrier(void)
 
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
+extern u64 x86_spec_ctrl_current;
 extern void write_spec_ctrl_current(u64 val, bool force);
 extern u64 spec_ctrl_current(void);
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 7198ae236a20..223282a5dc1c 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -185,6 +185,10 @@ void __init check_bugs(void)
 #endif
 }
 
+/*
+ * NOTE: For VMX, this function is not called in the vmexit path.
+ * It uses vmx_spec_ctrl_restore_host() instead.
+ */
 void
 x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
 {
diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
index 57f4c664ea9c..edc3f16cc189 100644
--- a/arch/x86/kvm/vmx/run_flags.h
+++ b/arch/x86/kvm/vmx/run_flags.h
@@ -3,5 +3,6 @@
 #define __KVM_X86_VMX_RUN_FLAGS_H
 
 #define VMX_RUN_VMRESUME	(1 << 0)
+#define VMX_RUN_SAVE_SPEC_CTRL	(1 << 1)
 
 #endif /* __KVM_X86_VMX_RUN_FLAGS_H */
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index d1cbb0a6d0ea..2d68dc96e672 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -32,9 +32,10 @@
 
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
@@ -53,6 +54,12 @@ ENTRY(__vmx_vcpu_run)
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
@@ -136,23 +143,21 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
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
-	xor %ebx, %ebx
+	xor %eax, %eax
 	xor %ecx, %ecx
 	xor %edx, %edx
 	xor %esi, %esi
@@ -172,6 +177,28 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
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
@@ -191,7 +218,7 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 	ud2
 .Lvmfail:
 	/* VM-Fail: set return value to 1 */
-	mov $1, %eax
+	mov $1, %_ASM_BX
 	jmp .Lclear_regs
 
 ENDPROC(__vmx_vcpu_run)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 41de3d6d1c27..85d5dfb261f5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -870,6 +870,14 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
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
 
@@ -6550,6 +6558,26 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
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
 static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -6643,26 +6671,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	vmx_enable_fb_clear(vmx);
 
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
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 880a26ba49af..4d5be4610af8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -337,6 +337,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
+void vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx, unsigned int flags);
 unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx);
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs,
 		    unsigned int flags);
-- 
2.34.1

