Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C865F30EB
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiJCNN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiJCNNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:13:10 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C1C52808;
        Mon,  3 Oct 2022 06:12:44 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.174.77])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 9D83C42FBA;
        Mon,  3 Oct 2022 13:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664802748;
        bh=/77iGLKneom/Y0rZ3SxFeWDli+1rxZRA6Hhmnco0M84=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=PG+GdAPLWLB2K/9io3yfT/U3cbjmQglcDLHGmY6ICyr2mUYBTT+eJaWB+hOd6VCUq
         Wghw8y1gRNYT51BZmL9PFg/6Hb29pyK3yCZ3Gr8GflJmqKg4JhJaNlo1v0KxHcAnkR
         MUfLU1ESTV7Ug1Nz59dprT82tmX04tdrZnn8/1j2ZwYDHr30/kL0DegKR5Zb4bgv1j
         xRsH9mnvoIbFOiD2mCnk8J+9Grj0KWrwk5pbpzwwgM6i2IdseeSeWzSxlths+QsBAm
         orye3ccDkuHM0+mWaJwCwwfaNT9Npg7AZwFBRlSWx5tfkw+5yVd1e0jw+WvGRVqs6x
         pZ8mwCWy2avTw==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org
Subject: [PATCH 5.4 26/37] KVM: VMX: Flatten __vmx_vcpu_run()
Date:   Mon,  3 Oct 2022 10:10:27 -0300
Message-Id: <20221003131038.12645-27-cascardo@canonical.com>
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

commit 8bd200d23ec42d66ccd517a72dd0b9cc6132d2fd upstream.

Move the vmx_vm{enter,exit}() functionality into __vmx_vcpu_run().  This
will make it easier to do the spec_ctrl handling before the first RET.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: remove ENDBR]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[cascardo: no unwinding save/restore]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 arch/x86/kvm/vmx/vmenter.S | 114 ++++++++++++-------------------------
 1 file changed, 37 insertions(+), 77 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 63cd7fbab0ac..e209c24db0c9 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -29,72 +29,6 @@
 
 	.text
 
-/**
- * vmx_vmenter - VM-Enter the current loaded VMCS
- *
- * %RFLAGS.ZF:	!VMCS.LAUNCHED, i.e. controls VMLAUNCH vs. VMRESUME
- *
- * Returns:
- *	%RFLAGS.CF is set on VM-Fail Invalid
- *	%RFLAGS.ZF is set on VM-Fail Valid
- *	%RFLAGS.{CF,ZF} are cleared on VM-Success, i.e. VM-Exit
- *
- * Note that VMRESUME/VMLAUNCH fall-through and return directly if
- * they VM-Fail, whereas a successful VM-Enter + VM-Exit will jump
- * to vmx_vmexit.
- */
-ENTRY(vmx_vmenter)
-	/* EFLAGS.ZF is set if VMCS.LAUNCHED == 0 */
-	je 2f
-
-1:	vmresume
-	ret
-
-2:	vmlaunch
-	ret
-
-3:	cmpb $0, kvm_rebooting
-	je 4f
-	ret
-4:	ud2
-
-	.pushsection .fixup, "ax"
-5:	jmp 3b
-	.popsection
-
-	_ASM_EXTABLE(1b, 5b)
-	_ASM_EXTABLE(2b, 5b)
-
-ENDPROC(vmx_vmenter)
-
-/**
- * vmx_vmexit - Handle a VMX VM-Exit
- *
- * Returns:
- *	%RFLAGS.{CF,ZF} are cleared on VM-Success, i.e. VM-Exit
- *
- * This is vmx_vmenter's partner in crime.  On a VM-Exit, control will jump
- * here after hardware loads the host's state, i.e. this is the destination
- * referred to by VMCS.HOST_RIP.
- */
-ENTRY(vmx_vmexit)
-#ifdef CONFIG_RETPOLINE
-	ALTERNATIVE "jmp .Lvmexit_skip_rsb", "", X86_FEATURE_RETPOLINE
-	/* Preserve guest's RAX, it's used to stuff the RSB. */
-	push %_ASM_AX
-
-	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
-	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
-
-	/* Clear RFLAGS.CF and RFLAGS.ZF to preserve VM-Exit, i.e. !VM-Fail. */
-	or $1, %_ASM_AX
-
-	pop %_ASM_AX
-.Lvmexit_skip_rsb:
-#endif
-	ret
-ENDPROC(vmx_vmexit)
-
 /**
  * __vmx_vcpu_run - Run a vCPU via a transition to VMX guest mode
  * @vmx:	struct vcpu_vmx * (forwarded to vmx_update_host_rsp)
@@ -127,8 +61,7 @@ ENTRY(__vmx_vcpu_run)
 	/* Copy @launched to BL, _ASM_ARG3 is volatile. */
 	mov %_ASM_ARG3B, %bl
 
-	/* Adjust RSP to account for the CALL to vmx_vmenter(). */
-	lea -WORD_SIZE(%_ASM_SP), %_ASM_ARG2
+	lea (%_ASM_SP), %_ASM_ARG2
 	call vmx_update_host_rsp
 
 	/* Load @regs to RAX. */
@@ -157,11 +90,25 @@ ENTRY(__vmx_vcpu_run)
 	/* Load guest RAX.  This kills the @regs pointer! */
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
-	/* Enter guest mode */
-	call vmx_vmenter
+	/* Check EFLAGS.ZF from 'testb' above */
+	je .Lvmlaunch
 
-	/* Jump on VM-Fail. */
-	jbe 2f
+/*
+ * If VMRESUME/VMLAUNCH and corresponding vmexit succeed, execution resumes at
+ * the 'vmx_vmexit' label below.
+ */
+.Lvmresume:
+	vmresume
+	jmp .Lvmfail
+
+.Lvmlaunch:
+	vmlaunch
+	jmp .Lvmfail
+
+	_ASM_EXTABLE(.Lvmresume, .Lfixup)
+	_ASM_EXTABLE(.Lvmlaunch, .Lfixup)
+
+SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 
 	/* Temporarily save guest's RAX. */
 	push %_ASM_AX
@@ -188,9 +135,13 @@ ENTRY(__vmx_vcpu_run)
 	mov %r15, VCPU_R15(%_ASM_AX)
 #endif
 
+	/* IMPORTANT: RSB must be stuffed before the first return. */
+	FILL_RETURN_BUFFER %_ASM_BX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
+
 	/* Clear RAX to indicate VM-Exit (as opposed to VM-Fail). */
 	xor %eax, %eax
 
+.Lclear_regs:
 	/*
 	 * Clear all general purpose registers except RSP and RAX to prevent
 	 * speculative use of the guest's values, even those that are reloaded
@@ -200,7 +151,7 @@ ENTRY(__vmx_vcpu_run)
 	 * free.  RSP and RAX are exempt as RSP is restored by hardware during
 	 * VM-Exit and RAX is explicitly loaded with 0 or 1 to return VM-Fail.
 	 */
-1:	xor %ebx, %ebx
+	xor %ebx, %ebx
 	xor %ecx, %ecx
 	xor %edx, %edx
 	xor %esi, %esi
@@ -219,8 +170,8 @@ ENTRY(__vmx_vcpu_run)
 
 	/* "POP" @regs. */
 	add $WORD_SIZE, %_ASM_SP
-	pop %_ASM_BX
 
+	pop %_ASM_BX
 #ifdef CONFIG_X86_64
 	pop %r12
 	pop %r13
@@ -233,11 +184,20 @@ ENTRY(__vmx_vcpu_run)
 	pop %_ASM_BP
 	ret
 
-	/* VM-Fail.  Out-of-line to avoid a taken Jcc after VM-Exit. */
-2:	mov $1, %eax
-	jmp 1b
+.Lfixup:
+	cmpb $0, kvm_rebooting
+	jne .Lvmfail
+	ud2
+.Lvmfail:
+	/* VM-Fail: set return value to 1 */
+	mov $1, %eax
+	jmp .Lclear_regs
+
 ENDPROC(__vmx_vcpu_run)
 
+
+.section .text, "ax"
+
 /**
  * vmread_error_trampoline - Trampoline from inline asm to vmread_error()
  * @field:	VMCS field encoding that failed
-- 
2.34.1

