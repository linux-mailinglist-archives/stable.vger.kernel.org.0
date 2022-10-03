Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8766D5F30E9
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiJCNNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiJCNNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:13:05 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E4352830;
        Mon,  3 Oct 2022 06:12:45 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.174.77])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 05A7742FB6;
        Mon,  3 Oct 2022 13:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664802751;
        bh=Olf5oOzpczF4h5w3yULKp7C1WWZ7MtN+gShoL8D94QI=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=j+wG6Tm+sFQsf+5CMyV1XMxkGNgBkFQGGhGc7TXpEkoDDvDSnS06hpvy+9fNDXo/6
         RDIn2lNb/7/CJ+dUg+/eN2NdImltvbR3qIzRN8yDM8RXPuGHfMhYxXR+sJ/v8emsHW
         ryFBe3sT862L01QAP7l0CxH9GLTcCmK70Lwz2pRAh0KxvZW4ep3+i3dq3vo94Ru9E4
         0iAqr2hid3+azN8qN50BkyU5uHWxYDGHj783UG2cGi/It6XjzqF4jljkxllHrMQi3t
         ugPk874sIsteCZRd3DDYzBLE7qjiUdzRFkT/bqKd/D5A4KMUlCzcwcVZVo5b5YaoPO
         Xr+/5JK1mQ+kw==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org
Subject: [PATCH 5.4 27/37] KVM: VMX: Convert launched argument to flags
Date:   Mon,  3 Oct 2022 10:10:28 -0300
Message-Id: <20221003131038.12645-28-cascardo@canonical.com>
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
---
 arch/x86/kvm/vmx/nested.c    |  2 +-
 arch/x86/kvm/vmx/run_flags.h |  7 +++++++
 arch/x86/kvm/vmx/vmenter.S   |  9 +++++----
 arch/x86/kvm/vmx/vmx.c       | 12 +++++++++++-
 arch/x86/kvm/vmx/vmx.h       |  5 ++++-
 5 files changed, 28 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/run_flags.h

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e1947ef3cd7b..a7b62a00913e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2865,7 +2865,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 	}
 
 	vm_fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
-				 vmx->loaded_vmcs->launched);
+				 __vmx_vcpu_run_flags(vmx));
 
 	if (vmx->msr_autoload.host.nr)
 		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
new file mode 100644
index 000000000000..57f4c664ea9c
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
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index e209c24db0c9..d1cbb0a6d0ea 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -4,6 +4,7 @@
 #include <asm/bitsperlong.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/nospec-branch.h>
+#include "run_flags.h"
 
 #define WORD_SIZE (BITS_PER_LONG / 8)
 
@@ -33,7 +34,7 @@
  * __vmx_vcpu_run - Run a vCPU via a transition to VMX guest mode
  * @vmx:	struct vcpu_vmx * (forwarded to vmx_update_host_rsp)
  * @regs:	unsigned long * (to guest registers)
- * @launched:	%true if the VMCS has been launched
+ * @flags:	VMX_RUN_VMRESUME: use VMRESUME instead of VMLAUNCH
  *
  * Returns:
  *	0 on VM-Exit, 1 on VM-Fail
@@ -58,7 +59,7 @@ ENTRY(__vmx_vcpu_run)
 	 */
 	push %_ASM_ARG2
 
-	/* Copy @launched to BL, _ASM_ARG3 is volatile. */
+	/* Copy @flags to BL, _ASM_ARG3 is volatile. */
 	mov %_ASM_ARG3B, %bl
 
 	lea (%_ASM_SP), %_ASM_ARG2
@@ -68,7 +69,7 @@ ENTRY(__vmx_vcpu_run)
 	mov (%_ASM_SP), %_ASM_AX
 
 	/* Check if vmlaunch or vmresume is needed */
-	testb %bl, %bl
+	testb $VMX_RUN_VMRESUME, %bl
 
 	/* Load guest registers.  Don't clobber flags. */
 	mov VCPU_RBX(%_ASM_AX), %_ASM_BX
@@ -91,7 +92,7 @@ ENTRY(__vmx_vcpu_run)
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
 	/* Check EFLAGS.ZF from 'testb' above */
-	je .Lvmlaunch
+	jz .Lvmlaunch
 
 /*
  * If VMRESUME/VMLAUNCH and corresponding vmexit succeed, execution resumes at
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fd3fb3cf0264..41de3d6d1c27 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -863,6 +863,16 @@ static bool msr_write_intercepted(struct vcpu_vmx *vmx, u32 msr)
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
@@ -6627,7 +6637,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		write_cr2(vcpu->arch.cr2);
 
 	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
-				   vmx->loaded_vmcs->launched);
+				   __vmx_vcpu_run_flags(vmx));
 
 	vcpu->arch.cr2 = read_cr2();
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a6a35dc3743e..880a26ba49af 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -10,6 +10,7 @@
 #include "capabilities.h"
 #include "ops.h"
 #include "vmcs.h"
+#include "run_flags.h"
 
 extern const u32 vmx_msr_index[];
 extern u64 host_efer;
@@ -336,7 +337,9 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
-bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
+unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx);
+bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs,
+		    unsigned int flags);
 
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
-- 
2.34.1

