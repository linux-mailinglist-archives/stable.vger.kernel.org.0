Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9B65F537F
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiJELfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJELeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:34:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F263E75382;
        Wed,  5 Oct 2022 04:33:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C98AB81D49;
        Wed,  5 Oct 2022 11:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27C5C433C1;
        Wed,  5 Oct 2022 11:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969620;
        bh=7M23J4fV8jXLrfsiVX3ag2XZNuw765APqSW6hUGCSQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xUflmJk25t+IvovQ+MpjMdE0swzFegqDQldy0lqNFPS5tXPl7EgAQEu3ITCM2zeAK
         lgUj2pf2Y3qrQ0chh7NYgnuq0c85p6GjmI8liR4/bgVd01o62ptv3RZgnzsXK9fel8
         ZDcHONbFU5gShjTwOzaOcbjm1Gww8tqLM9XWoi4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.4 27/51] KVM: VMX: Convert launched argument to flags
Date:   Wed,  5 Oct 2022 13:32:15 +0200
Message-Id: <20221005113211.524153712@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c    |    2 +-
 arch/x86/kvm/vmx/run_flags.h |    7 +++++++
 arch/x86/kvm/vmx/vmenter.S   |    9 +++++----
 arch/x86/kvm/vmx/vmx.c       |   12 +++++++++++-
 arch/x86/kvm/vmx/vmx.h       |    5 ++++-
 5 files changed, 28 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/run_flags.h

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2865,7 +2865,7 @@ static int nested_vmx_check_vmentry_hw(s
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
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -863,6 +863,16 @@ static bool msr_write_intercepted(struct
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
@@ -6627,7 +6637,7 @@ static void vmx_vcpu_run(struct kvm_vcpu
 		write_cr2(vcpu->arch.cr2);
 
 	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
-				   vmx->loaded_vmcs->launched);
+				   __vmx_vcpu_run_flags(vmx));
 
 	vcpu->arch.cr2 = read_cr2();
 
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -10,6 +10,7 @@
 #include "capabilities.h"
 #include "ops.h"
 #include "vmcs.h"
+#include "run_flags.h"
 
 extern const u32 vmx_msr_index[];
 extern u64 host_efer;
@@ -336,7 +337,9 @@ void vmx_set_virtual_apic_mode(struct kv
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
-bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
+unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx);
+bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs,
+		    unsigned int flags);
 
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1


