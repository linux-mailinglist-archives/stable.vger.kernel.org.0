Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3558D5722CD
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbiGLSkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiGLSkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D99BFAD8;
        Tue, 12 Jul 2022 11:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 722F76186E;
        Tue, 12 Jul 2022 18:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A55BC3411E;
        Tue, 12 Jul 2022 18:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651218;
        bh=xgz+phWSzPt31Ph3dA4Jf3eDUzJaXACYi/OnM6XS898=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDHE9zUccj1pn4NUuo1ZgQpHc3tAW+4rHvTTuoOT+CIq+qKZEavdQJ7/t6HS9lZEH
         5PyCggeyo1Qp/wwIN4CV5DiJzWwtOO6g7Wx7gPeh0TSVTyqw1Lwh55eFg2y/3YL7sc
         X9E3R2TDyrLBIE2iRBmkAPKsobB6ebPwX9pGwVq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 002/130] KVM/nVMX: Use __vmx_vcpu_run in nested_vmx_check_vmentry_hw
Date:   Tue, 12 Jul 2022 20:37:28 +0200
Message-Id: <20220712183246.500111511@linuxfoundation.org>
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

From: Uros Bizjak <ubizjak@gmail.com>

commit 150f17bfab37e981ba03b37440638138ff2aa9ec upstream.

Replace inline assembly in nested_vmx_check_vmentry_hw
with a call to __vmx_vcpu_run.  The function is not
performance critical, so (double) GPR save/restore
in __vmx_vcpu_run can be tolerated, as far as performance
effects are concerned.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
[sean: dropped versioning info from changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20201231002702.2223707-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c  |   32 +++-----------------------------
 arch/x86/kvm/vmx/vmenter.S |    2 +-
 arch/x86/kvm/vmx/vmx.c     |    2 --
 arch/x86/kvm/vmx/vmx.h     |    1 +
 4 files changed, 5 insertions(+), 32 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -12,6 +12,7 @@
 #include "nested.h"
 #include "pmu.h"
 #include "trace.h"
+#include "vmx.h"
 #include "x86.h"
 
 static bool __read_mostly enable_shadow_vmcs = 1;
@@ -3075,35 +3076,8 @@ static int nested_vmx_check_vmentry_hw(s
 		vmx->loaded_vmcs->host_state.cr4 = cr4;
 	}
 
-	asm(
-		"sub $%c[wordsize], %%" _ASM_SP "\n\t" /* temporarily adjust RSP for CALL */
-		"cmp %%" _ASM_SP ", %c[host_state_rsp](%[loaded_vmcs]) \n\t"
-		"je 1f \n\t"
-		__ex("vmwrite %%" _ASM_SP ", %[HOST_RSP]") "\n\t"
-		"mov %%" _ASM_SP ", %c[host_state_rsp](%[loaded_vmcs]) \n\t"
-		"1: \n\t"
-		"add $%c[wordsize], %%" _ASM_SP "\n\t" /* un-adjust RSP */
-
-		/* Check if vmlaunch or vmresume is needed */
-		"cmpb $0, %c[launched](%[loaded_vmcs])\n\t"
-
-		/*
-		 * VMLAUNCH and VMRESUME clear RFLAGS.{CF,ZF} on VM-Exit, set
-		 * RFLAGS.CF on VM-Fail Invalid and set RFLAGS.ZF on VM-Fail
-		 * Valid.  vmx_vmenter() directly "returns" RFLAGS, and so the
-		 * results of VM-Enter is captured via CC_{SET,OUT} to vm_fail.
-		 */
-		"call vmx_vmenter\n\t"
-
-		CC_SET(be)
-	      : ASM_CALL_CONSTRAINT, CC_OUT(be) (vm_fail)
-	      :	[HOST_RSP]"r"((unsigned long)HOST_RSP),
-		[loaded_vmcs]"r"(vmx->loaded_vmcs),
-		[launched]"i"(offsetof(struct loaded_vmcs, launched)),
-		[host_state_rsp]"i"(offsetof(struct loaded_vmcs, host_state.rsp)),
-		[wordsize]"i"(sizeof(ulong))
-	      : "memory"
-	);
+	vm_fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
+				 vmx->loaded_vmcs->launched);
 
 	if (vmx->msr_autoload.host.nr)
 		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -44,7 +44,7 @@
  * they VM-Fail, whereas a successful VM-Enter + VM-Exit will jump
  * to vmx_vmexit.
  */
-SYM_FUNC_START(vmx_vmenter)
+SYM_FUNC_START_LOCAL(vmx_vmenter)
 	/* EFLAGS.ZF is set if VMCS.LAUNCHED == 0 */
 	je 2f
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6687,8 +6687,6 @@ static fastpath_t vmx_exit_handlers_fast
 	}
 }
 
-bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
-
 static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 					struct vcpu_vmx *vmx)
 {
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -365,6 +365,7 @@ void vmx_set_virtual_apic_mode(struct kv
 struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
+bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
 


