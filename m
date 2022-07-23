Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7D557EE48
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238796AbiGWKJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238925AbiGWKJF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:09:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E002CCA766;
        Sat, 23 Jul 2022 03:02:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7380EB82C22;
        Sat, 23 Jul 2022 10:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6796C341C0;
        Sat, 23 Jul 2022 10:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570530;
        bh=uSCrARfkJXjP+FlPoukAD3jkic9RSZrM1HUIDh5lzKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MiLgZR8icW7ygDGNM8ecXdJdvYflSUYhypB2LJQhmUUU9cUfgrlMyskcIFdsMhhme
         u3yZKXZEjhNFJP/TkuT0ABJF3DzVHYlWBk/Fu0HqwLpUUQ/6hIWF8ebWgSr2pMrbiZ
         +jSaVLeG5RSkwqmMcTECgLB865L4vqnkAf/F1dDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 118/148] KVM: VMX: Flatten __vmx_vcpu_run()
Date:   Sat, 23 Jul 2022 11:55:30 +0200
Message-Id: <20220723095257.391891551@linuxfoundation.org>
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
---
 arch/x86/kvm/vmx/vmenter.S |  118 +++++++++++++++++----------------------------
 1 file changed, 45 insertions(+), 73 deletions(-)

--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -31,68 +31,6 @@
 .section .noinstr.text, "ax"
 
 /**
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
-SYM_FUNC_START_LOCAL(vmx_vmenter)
-	/* EFLAGS.ZF is set if VMCS.LAUNCHED == 0 */
-	je 2f
-
-1:	vmresume
-	RET
-
-2:	vmlaunch
-	RET
-
-3:	cmpb $0, kvm_rebooting
-	je 4f
-	RET
-4:	ud2
-
-	_ASM_EXTABLE(1b, 3b)
-	_ASM_EXTABLE(2b, 3b)
-
-SYM_FUNC_END(vmx_vmenter)
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
-SYM_FUNC_START(vmx_vmexit)
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
-	RET
-SYM_FUNC_END(vmx_vmexit)
-
-/**
  * __vmx_vcpu_run - Run a vCPU via a transition to VMX guest mode
  * @vmx:	struct vcpu_vmx * (forwarded to vmx_update_host_rsp)
  * @regs:	unsigned long * (to guest registers)
@@ -124,8 +62,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	/* Copy @launched to BL, _ASM_ARG3 is volatile. */
 	mov %_ASM_ARG3B, %bl
 
-	/* Adjust RSP to account for the CALL to vmx_vmenter(). */
-	lea -WORD_SIZE(%_ASM_SP), %_ASM_ARG2
+	lea (%_ASM_SP), %_ASM_ARG2
 	call vmx_update_host_rsp
 
 	/* Load @regs to RAX. */
@@ -154,11 +91,36 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	/* Load guest RAX.  This kills the @regs pointer! */
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
-	/* Enter guest mode */
-	call vmx_vmenter
+	/* Check EFLAGS.ZF from 'testb' above */
+	je .Lvmlaunch
 
-	/* Jump on VM-Fail. */
-	jbe 2f
+	/*
+	 * After a successful VMRESUME/VMLAUNCH, control flow "magically"
+	 * resumes below at 'vmx_vmexit' due to the VMCS HOST_RIP setting.
+	 * So this isn't a typical function and objtool needs to be told to
+	 * save the unwind state here and restore it below.
+	 */
+	UNWIND_HINT_SAVE
+
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
+
+	/* Restore unwind state from before the VMRESUME/VMLAUNCH. */
+	UNWIND_HINT_RESTORE
 
 	/* Temporarily save guest's RAX. */
 	push %_ASM_AX
@@ -185,9 +147,13 @@ SYM_FUNC_START(__vmx_vcpu_run)
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
@@ -197,7 +163,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	 * free.  RSP and RAX are exempt as RSP is restored by hardware during
 	 * VM-Exit and RAX is explicitly loaded with 0 or 1 to return VM-Fail.
 	 */
-1:	xor %ecx, %ecx
+	xor %ecx, %ecx
 	xor %edx, %edx
 	xor %ebx, %ebx
 	xor %ebp, %ebp
@@ -216,8 +182,8 @@ SYM_FUNC_START(__vmx_vcpu_run)
 
 	/* "POP" @regs. */
 	add $WORD_SIZE, %_ASM_SP
-	pop %_ASM_BX
 
+	pop %_ASM_BX
 #ifdef CONFIG_X86_64
 	pop %r12
 	pop %r13
@@ -230,9 +196,15 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	pop %_ASM_BP
 	RET
 
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
 SYM_FUNC_END(__vmx_vcpu_run)
 
 


