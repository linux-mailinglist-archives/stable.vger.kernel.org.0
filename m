Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3258561FD21
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 19:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbiKGSQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 13:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiKGSPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 13:15:44 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23E9E89
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 10:14:48 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id h193so11133451pgc.10
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 10:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QasqPQzP7eJ/H7hHGRTPNLRys7iXrHupZXBdQcX1hWo=;
        b=HtUL9UohLcZq+MhSEzfN560OLWZocNPongmq5buGVITHj6hcIMyPq2QZqK2cEwXytF
         MYnceFcpe8FoRY4cIobBuWjWce4Eg8lHITPe7iCv4VdKRhMGtta7nhP5NuyGZiNqUAgc
         ESRSZNObJExFTzpjB8HmCQ6eS22ZCMkWfEwU8KzNaVkcpcIVLWX2cECdKX6iE+C9C6ul
         xmBVMWcVD00hZYc4UYQiRwTqL9dNBc9cv2EysjtHMOmgyp3o7Ex6Wyex+0jmf94Kfv8z
         trqAPqq06VYY3DbkvVZibrcw3/JeRVMx4rvdiKsE0O3UmlI1ozkbcxbTz+7G7BOq/a3g
         DWDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QasqPQzP7eJ/H7hHGRTPNLRys7iXrHupZXBdQcX1hWo=;
        b=wbISTsj4XMqW+t0h32cOzenXwXEG3nCADQEzfgqgEKz2HrPi/gPKIk1ZiAxg+XvOa7
         IkWf99HJh2Q0yGhWByPo0SJQpQn65j2jvZ1+hPvSG+Iyd7gtRlGY7RsAQrM9mvi41G5B
         VwZeu97o8Opv3Avvw1JOxA5Wn9+y6WYpFZuMg2dd6pxczYHU3IrphVeH3o/91UGXiEb1
         7sCbWi6iEXIlaoE7SnOTb51Z0lEmPetlyQantbKVcYUjIzEXurdn5eIwxRwpJkPzESZc
         tjULOhGKMnbJ6M/qGjcHJwDEutk5u6dwe+7XVtHtFKbO8As0fjqLuC09EkRLe98Qr6ZU
         r+rA==
X-Gm-Message-State: ACrzQf1zP5mgfiVaqDLs3L2kVR0JcVGeI1e/3NfpMedevR0BcxkhqCp1
        T3MfdgFHmrZ27RqHs9exd2xJpg==
X-Google-Smtp-Source: AMsMyM6Y/hAojKJkbFb26Nsup1zpx4xVFW0ldlk+OBwkVsvFY1VY64pd14IKiL1SQ7F5oc6gK3BQOg==
X-Received: by 2002:a05:6a00:4504:b0:56b:3ed4:1fac with SMTP id cw4-20020a056a00450400b0056b3ed41facmr51655876pfb.73.1667844888309;
        Mon, 07 Nov 2022 10:14:48 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ei15-20020a17090ae54f00b00213d08fa459sm4671359pjb.17.2022.11.07.10.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 10:14:47 -0800 (PST)
Date:   Mon, 7 Nov 2022 18:14:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/8] KVM: SVM: extract VMCB accessors to a new file
Message-ID: <Y2lLFEt3tQBoZTDe@google.com>
References: <20221107145436.276079-1-pbonzini@redhat.com>
 <20221107145436.276079-2-pbonzini@redhat.com>
 <Y2k7o8i/qhBm9bpC@google.com>
 <3ca5e8b6-c786-2f15-8f81-fd6353c43692@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ca5e8b6-c786-2f15-8f81-fd6353c43692@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022, Paolo Bonzini wrote:
> On 11/7/22 18:08, Sean Christopherson wrote:
> > What about making KVM self-sufficient?
> 
> You mean having a different asm-offsets.h file just for arch/x86/kvm/?

Yeah.

> > The includes in asm-offsets.c are quite ugly
> > 
> >   #include "../kvm/vmx/vmx.h"
> >   #include "../kvm/svm/svm.h"
> > 
> > or as a stopgap to make backporting easier, just include kvm_cache_regs.h?
> 
> The problem is that the _existing_ include of kvm_cache_regs.h in svm.h
> fails, with
> 
> arch/x86/kernel/../kvm/svm/svm.h:25:10: fatal error: kvm_cache_regs.h: No
> such file or directory
>    25 | #include "kvm_cache_regs.h"
>       |          ^~~~~~~~~~~~~~~~~~
> compilation terminated.

Duh.  Now the changelog makes more sense...

> The other two solutions here are:
> 
> 1) move kvm_cache_regs.h to arch/x86/include/asm/ so it can be included
> normally
> 
> 2) extract the structs to arch/x86/kvm/svm/svm_types.h and include that from
> asm-offsets.h, basically the opposite of this patch.
> 
> (2) is my preference if having a different asm-offsets.h file turns out to
> be too complex.  We can do the same for VMX as well.

What about adding dedicated structs to hold the non-regs params for VM-Enter and
VMRUN?  Grabbing stuff willy-nilly in the assembly code makes the flows difficult
to read as there's nothing in the C code that describes what fields are actually
used.  And due to 32-bit's restriction on the number of params, maintaining the
ad hoc approach will be annoying as passing in new info will require shuffling,
and any KVM refactorings will need updates to asm-offsets.c, e.g. "spec_ctrl"
should really live in "struct kvm_vcpu" since it's common to both AMD and Intel.

That would also allow fixing the bugs introduced by commit bb06650634d3 ("KVM:
VMX: Convert launched argument to flags").  nested_vmx_check_vmentry_hw() never
fully enters the guest; at worst, it triggers a "VM-Exit on VM-Enter" consistency
check.  Thus there's no need to load the guest's spec control and zero chance that
the guest can write to spec control.

E.g. as a very rough starting point

---
 arch/x86/include/asm/kvm_host.h |  8 ++++++++
 arch/x86/kvm/svm/svm.c          | 13 ++++++++++---
 arch/x86/kvm/svm/svm.h          |  4 ++--
 arch/x86/kvm/vmx/nested.c       |  8 ++++++--
 arch/x86/kvm/vmx/run_flags.h    |  8 --------
 arch/x86/kvm/vmx/vmx.c          | 32 +++++++++-----------------------
 arch/x86/kvm/vmx/vmx.h          |  4 +---
 7 files changed, 36 insertions(+), 41 deletions(-)
 delete mode 100644 arch/x86/kvm/vmx/run_flags.h

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 415113dea951..d56fe6151656 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -204,6 +204,14 @@ enum exit_fastpath_completion {
 };
 typedef enum exit_fastpath_completion fastpath_t;
 
+struct kvm_vmrun_params {
+	...
+};
+
+struct kvm_vmenter_params {
+	...
+};
+
 struct x86_emulate_ctxt;
 struct x86_exception;
 union kvm_smram;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 627c126cd9bb..7df9ea3ad3f1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3925,16 +3925,23 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_intercepted)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_vmrun_params vmrun = {
+		.regs = vcpu->arch.regs,
+		.vmcb01 = svm->vmcb01.ptr,
+		.vmcb = svm->current_vmcb->ptr,
+		.spec_ctrl = svm->current_vmcb->ptr,
+		.spec_ctrl_intercepted = spec_ctrl_intercepted,
+	};
 
 	guest_state_enter_irqoff();
 
 	if (sev_es_guest(vcpu->kvm)) {
-		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
+		__svm_sev_es_vcpu_run(&params);
 	} else {
 		struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
 
-		__svm_vcpu_run(svm, __sme_page_pa(sd->save_area),
-			       spec_ctrl_intercepted);
+		params.save_save_pa = __sme_page_pa(sd->save_area);
+		__svm_vcpu_run(vcpu->arch.regs, &params);
 	}
 
 	guest_state_exit_irqoff();
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9d940d8736f0..bf321b755a15 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -483,7 +483,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
 /* vmenter.S */
 
-void __svm_sev_es_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
-void __svm_vcpu_run(struct vcpu_svm *svm, unsigned long hsave_pa, bool spec_ctrl_intercepted);
+void __svm_sev_es_vcpu_run(struct kvm_vmrun_params *params);
+void __svm_vcpu_run(unsigned long *regs, struct kvm_vmrun_params *params);
 
 #endif
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 61a2e551640a..da6c9b8c3a4f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3058,6 +3058,11 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 
 static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 {
+	struct kvm_vmenter_params params = {
+		.launched = vmx->loaded_vmcs->launched,
+		.spec_ctrl = this_cpu_read(x86_spec_ctrl_current),
+		.spec_ctrl_intercepted = true,
+	};
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
 	bool vm_fail;
@@ -3094,8 +3099,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 		vmx->loaded_vmcs->host_state.cr4 = cr4;
 	}
 
-	vm_fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
-				 __vmx_vcpu_run_flags(vmx));
+	vm_fail = __vmx_vcpu_run(vcpu->arch.regs, &params);
 
 	if (vmx->msr_autoload.host.nr)
 		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
deleted file mode 100644
index edc3f16cc189..000000000000
--- a/arch/x86/kvm/vmx/run_flags.h
+++ /dev/null
@@ -1,8 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __KVM_X86_VMX_RUN_FLAGS_H
-#define __KVM_X86_VMX_RUN_FLAGS_H
-
-#define VMX_RUN_VMRESUME	(1 << 0)
-#define VMX_RUN_SAVE_SPEC_CTRL	(1 << 1)
-
-#endif /* __KVM_X86_VMX_RUN_FLAGS_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 05a747c9a9ff..307380cd2000 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -847,24 +847,6 @@ static bool msr_write_intercepted(struct vcpu_vmx *vmx, u32 msr)
 	return vmx_test_msr_bitmap_write(vmx->loaded_vmcs->msr_bitmap, msr);
 }
 
-unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
-{
-	unsigned int flags = 0;
-
-	if (vmx->loaded_vmcs->launched)
-		flags |= VMX_RUN_VMRESUME;
-
-	/*
-	 * If writes to the SPEC_CTRL MSR aren't intercepted, the guest is free
-	 * to change it directly without causing a vmexit.  In that case read
-	 * it after vmexit and store it in vmx->spec_ctrl.
-	 */
-	if (unlikely(!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL)))
-		flags |= VMX_RUN_SAVE_SPEC_CTRL;
-
-	return flags;
-}
-
 static __always_inline void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 		unsigned long entry, unsigned long exit)
 {
@@ -7065,9 +7047,14 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 }
 
 static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
-					struct vcpu_vmx *vmx,
-					unsigned long flags)
+					struct vcpu_vmx *vmx)
 {
+	struct kvm_vmenter_params params = {
+		.launched = vmx->loaded_vmcs->launched,
+		.spec_ctrl = vmx->spec_ctrl,
+		.spec_ctrl_intercepted = msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL),
+	};
+
 	guest_state_enter_irqoff();
 
 	/* L1D Flush includes CPU buffer clear to mitigate MDS */
@@ -7084,8 +7071,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	if (vcpu->arch.cr2 != native_read_cr2())
 		native_write_cr2(vcpu->arch.cr2);
 
-	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
-				   flags);
+	vmx->fail = __vmx_vcpu_run(vcpu->arch.regs, &params);
 
 	vcpu->arch.cr2 = native_read_cr2();
 
@@ -7185,7 +7171,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	kvm_wait_lapic_expire(vcpu);
 
 	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
-	vmx_vcpu_enter_exit(vcpu, vmx, __vmx_vcpu_run_flags(vmx));
+	vmx_vcpu_enter_exit(vcpu, vmx);
 
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs)) {
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a3da84f4ea45..4eb196f88b47 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -421,9 +421,7 @@ struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
 void vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx, unsigned int flags);
-unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx);
-bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs,
-		    unsigned int flags);
+bool __vmx_vcpu_run(unsigned long *regs, struct kvm_vmenter_params *params);
 int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
 

base-commit: 0443d79faa4575a5871b54801ed4a36eecce32e3
-- 
