Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFA06C7F01
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 14:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjCXNmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 09:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjCXNml (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 09:42:41 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4333B22CAE;
        Fri, 24 Mar 2023 06:42:34 -0700 (PDT)
Received: from [192.168.2.41] (77-166-152-30.fixed.kpn.net [77.166.152.30])
        by linux.microsoft.com (Postfix) with ESMTPSA id D9C2320FC0F4;
        Fri, 24 Mar 2023 06:42:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D9C2320FC0F4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1679665353;
        bh=3VmvwDnyZDj00X2K5h4ET9mKtkFs5KXH1uhyiV8j9oc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=olblbITm9AAKyCGEw5DWI6TL+Ek/dKIeyI/kHSDPl6G3X/5aA0o7+3lQ5EzsX/lhA
         welEMeO/NIfvMwaI3wv8gDK6yG4V+glTL5ooIpy+ZHD1jcBdSja1Xvv0VOAx8ac0fO
         gz0W0Rzuc39GURTsCg01gQZ1IYVfjywUTzE7tDlo=
Message-ID: <0a9ba6e6-d976-c3fa-372e-81fba85210ab@linux.microsoft.com>
Date:   Fri, 24 Mar 2023 14:42:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] KVM: SVM: Flush Hyper-V TLB when required
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>, stable@vger.kernel.org
References: <20230320185110.1346829-1-jpiotrowski@linux.microsoft.com>
 <ZBsqxeRDh+iV8qmm@google.com>
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <ZBsqxeRDh+iV8qmm@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/22/2023 5:20 PM, Sean Christopherson wrote:
> On Mon, Mar 20, 2023, Jeremi Piotrowski wrote:
>> ---
>>  arch/x86/kvm/kvm_onhyperv.c | 23 +++++++++++++++++++++++
>>  arch/x86/kvm/kvm_onhyperv.h |  5 +++++
>>  arch/x86/kvm/svm/svm.c      | 18 +++++++++++++++---
>>  3 files changed, 43 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
>> index 482d6639ef88..036e04c0a161 100644
>> --- a/arch/x86/kvm/kvm_onhyperv.c
>> +++ b/arch/x86/kvm/kvm_onhyperv.c
>> @@ -94,6 +94,29 @@ int hv_remote_flush_tlb(struct kvm *kvm)
>>  }
>>  EXPORT_SYMBOL_GPL(hv_remote_flush_tlb);
>>  
>> +void hv_flush_tlb_current(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_arch *kvm_arch = &vcpu->kvm->arch;
>> +	hpa_t root_tdp = vcpu->arch.mmu->root.hpa;
>> +
>> +	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb && VALID_PAGE(root_tdp)) {
>> +		spin_lock(&kvm_arch->hv_root_tdp_lock);
>> +		if (kvm_arch->hv_root_tdp != root_tdp) {
>> +			hyperv_flush_guest_mapping(root_tdp);
>> +			kvm_arch->hv_root_tdp = root_tdp;
> 
> In a vacuum, accessing kvm_arch->hv_root_tdp in the flush path is wrong.  This
> likely fixes the issues you are seeing because the KVM bug only affects the case
> when KVM is loading a new root (that used to be valid), in which case hv_root_tdp
> is guaranteed to be different.  But KVM should not rely on that behavior, i.e. if
> KVM says flush, then we flush.  There might be scenarios where the flush is
> unnecessary, but those flushes should be elided by the code that knows the flush
> is unnecessary, not in this common code just because the target root is the
> globally shared root> 

That's fair, and I'm fine with doing the flush unconditionally to fix the issue at
this time.

But eliding the flushes higher up will require bubbling up more knowledge about
the enlightened TLB and the fact that hyperv_flush_guest_mapping() already acts
across all cpus. And we would still want to call svm_flush_tlb_asid() anyway, right?

> Somewhat of a moot point, but setting hv_root_tdp to root_tdp is also wrong.  KVM's
> behavior is that hv_root_tdp points at a valid root if and only if all vCPUs share
> said root.  E.g. invoking this when vCPUs have different roots will "corrupt"
> hv_root_tdp and possibly cause a remote flush to do the wrong thing.> 

Oh, that's right. I'm dropping this for now.

>> +		}
>> +		spin_unlock(&kvm_arch->hv_root_tdp_lock);
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(hv_flush_tlb_current);
>> +
>> +void hv_flush_tlb_all(struct kvm_vcpu *vcpu)
>> +{
>> +	if (WARN_ON_ONCE(kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb))
> 
> Hmm, looking at the KVM code, AFAICT KVM only enables enlightened_npt_tlb for L1
> (L1 from KVM's perspective) as svm_hv_init_vmcb() is only ever called with vmcb01,
> never with vmcb02.  I don't know if that's intentional, but I do think it means
> KVM can skip the Hyper-V flush for vmcb02 and instead rely on the ASID flush,
> i.e. KVM can do the Hyper-V iff enlightened_npt_tlb is set in the current VMCB.
> And that should continue to work if KVM does ever enabled enlightened_npt_tlb for L2.
> 
>> +		hv_remote_flush_tlb(vcpu->kvm);
>> +}
>> +EXPORT_SYMBOL_GPL(hv_flush_tlb_all);
> 
> I'd rather not add helpers to the common KVM code.  I do like minimizing the amount
> of #ifdeffery, but defining these as common helpers makes it seem like VMX-on-HyperV
> is broken, i.e. raises the question of why VMX doesn't use these helpers when running
> on Hyper-V.
> 
> I'm thinking this?
> 

I have the #ifdef version ready to send out, but what do you think about this:

diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
index 287e98ef9df3..b3ee0bb7e95f 100644
--- a/arch/x86/kvm/kvm_onhyperv.h
+++ b/arch/x86/kvm/kvm_onhyperv.h
@@ -12,6 +12,11 @@ int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 int hv_remote_flush_tlb(struct kvm *kvm);
 void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
 #else /* !CONFIG_HYPERV */
+static inline int hv_remote_flush_tlb(struct kvm *kvm)
+{
+	return -1;
+}
+
 static inline void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
 {
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 252e7f37e4e2..e707511a91e3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3729,7 +3729,7 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
 }
 
-static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
+static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3753,6 +3753,39 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
 		svm->current_vmcb->asid_generation--;
 }
 
+static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	hpa_t root_tdp = vcpu->arch.mmu->root.hpa;
+
+	/*
+	 * When running on Hyper-V with EnlightenedNptTlb enabled, explicitly
+	 * flush the NPT mappings via hypercall as flushing the ASID only
+	 * affects virtual to physical mappings, it does not invalidate guest
+	 * physical to host physical mappings.
+	 */
+	if (IS_ENABLED(CONFIG_HYPERV) &&
+	    svm_hv_is_enlightened_tlb_enabled(vcpu) &&
+	    VALID_PAGE(root_tdp))
+		hyperv_flush_guest_mapping(root_tdp);
+
+	svm_flush_tlb_asid(vcpu);
+}
+
+static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * When running on Hyper-V with EnlightenedNptTlb enabled, remote TLB
+	 * flushes should be routed to hv_remote_flush_tlb() without requesting
+	 * a "regular" remote flush.  Reaching this point means either there's
+	 * a KVM bug or a prior hv_remote_flush_tlb() call failed, both of
+	 * which might be fatal to the guest.  Yell, but try to recover.
+	 */
+	if (IS_ENABLED(CONFIG_HYPERV) && WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
+		hv_remote_flush_tlb(vcpu->kvm);
+
+	svm_flush_tlb_asid(vcpu);
+}
+
 static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4745,10 +4778,10 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_rflags = svm_set_rflags,
 	.get_if_flag = svm_get_if_flag,
 
-	.flush_tlb_all = svm_flush_tlb_current,
+	.flush_tlb_all = svm_flush_tlb_all,
 	.flush_tlb_current = svm_flush_tlb_current,
 	.flush_tlb_gva = svm_flush_tlb_gva,
-	.flush_tlb_guest = svm_flush_tlb_current,
+	.flush_tlb_guest = svm_flush_tlb_asid,
 
 	.vcpu_pre_run = svm_vcpu_pre_run,
 	.vcpu_run = svm_vcpu_run,
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index cff838f15db5..4c9e0d4ba3dd 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -6,6 +6,8 @@
 #ifndef __ARCH_X86_KVM_SVM_ONHYPERV_H__
 #define __ARCH_X86_KVM_SVM_ONHYPERV_H__

+#include <asm/mshyperv.h>
+
 #if IS_ENABLED(CONFIG_HYPERV)

 #include "kvm_onhyperv.h"
@@ -15,6 +17,14 @@ static struct kvm_x86_ops svm_x86_ops;
 
 int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu);
 
+static inline bool svm_hv_is_enlightened_tlb_enabled(struct kvm_vcpu *vcpu)
+{
+	struct hv_vmcb_enlightenments *hve = &to_svm(vcpu)->vmcb->control.hv_enlightenments;
+
+	return ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB &&
+		!!hve->hv_enlightenments_control.enlightened_npt_tlb;
+}
+
 static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 {
 	struct hv_vmcb_enlightenments *hve = &vmcb->control.hv_enlightenments;
@@ -80,6 +90,11 @@ static inline void svm_hv_update_vp_id(struct vmcb *vmcb, struct kvm_vcpu *vcpu)
 }
 #else
 
+static inline bool svm_hv_is_enlightened_tlb_enabled(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 {
 }


