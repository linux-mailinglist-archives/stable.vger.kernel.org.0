Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B94D6C5154
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 17:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjCVQyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 12:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjCVQyc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 12:54:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC4334C34
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 09:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679504020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lSqchAgov7/BVMZ88CzwRn7huP/ESioH9t1tU66+QZE=;
        b=M4u68xBFrM4XN3MYd4XhTblU7eYxxLdOqYD6OOXpXk95n/888LRu2+NCEOAwrrTdaegpYc
        MQaCe72yKkuK1zMYURU7YUHYmnR5CFV/N0yuPG5u6O/uxlacfBiA1KeWGttQsS0MdjDRxq
        cqsPFqYXyymC0xwHFyX6UEIEd7zUs3s=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-VeMwqODPPRKpMwG7BolQGA-1; Wed, 22 Mar 2023 12:53:39 -0400
X-MC-Unique: VeMwqODPPRKpMwG7BolQGA-1
Received: by mail-qt1-f197.google.com with SMTP id c11-20020ac85a8b000000b003bfdd43ac76so11159773qtc.5
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 09:53:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679504019;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lSqchAgov7/BVMZ88CzwRn7huP/ESioH9t1tU66+QZE=;
        b=DBEPfngAiKaX08BpKnbQUTOqnDayeorgoZYC2sudhmtfHqINX5wxCUu96mQaMKu6mu
         FxXDro84mhUcDZYXhxVyLTv8+1b00mnacZWxfMIgLaOHQDsVH0bP6hQuowVdTUBhfEl2
         1wwQ2p4AUFASgk0F7ycj+9bXwYc21dqkfRPANJzQ04fKzFgNKi7Lg2rVt2iswEcOzV3H
         PXtzdSjLn7eZzgdyxf3SqvCqwSUMOUeIr0roUMZIOwy/rRf3Kb6bY1bQoSBC9BYJyCUD
         ab9QoYEwE8mHgwn4gChwRNBjvBLuCHg1T/JxLNU4fEUziQzVhwJSj2+QwULlD0suYBEn
         x5Jw==
X-Gm-Message-State: AO0yUKUTNAuxH0IPtI/rOXfkoyzxa9v6R/TpR2NeNBHstGiKA+JOx7qU
        +hfwGTjeSWdKHfVXXmHwKwSdYV5GZue40Lsx+PI648GGNr5V0ocdXgNdpAdrs22mBnvfqsnw9NS
        hQFKJUhbSzVQf6n+NxDOU2yNapR5RhGNshPw0d7Qf+slOTfmgN9UGbFanX0CX7wrD+n5vRUNNU8
        Pu
X-Received: by 2002:ac8:5c93:0:b0:3e0:3187:faf3 with SMTP id r19-20020ac85c93000000b003e03187faf3mr7732810qta.13.1679504018977;
        Wed, 22 Mar 2023 09:53:38 -0700 (PDT)
X-Google-Smtp-Source: AK7set/XuHfBLgaYfXJuF1m9TykXD1p0Szji6Dr+q2Cc9/7c225OCLwq/0cUsTdwNLFELxyvdFn/Jw==
X-Received: by 2002:ac8:5c93:0:b0:3e0:3187:faf3 with SMTP id r19-20020ac85c93000000b003e03187faf3mr7732774qta.13.1679504018583;
        Wed, 22 Mar 2023 09:53:38 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id s189-20020a372cc6000000b007429961e15csm11837907qkh.118.2023.03.22.09.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 09:53:38 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Flush Hyper-V TLB when required
In-Reply-To: <ZBsqxeRDh+iV8qmm@google.com>
References: <20230320185110.1346829-1-jpiotrowski@linux.microsoft.com>
 <ZBsqxeRDh+iV8qmm@google.com>
Date:   Wed, 22 Mar 2023 17:53:34 +0100
Message-ID: <87355wralt.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

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
> globally shared root.
>
> Somewhat of a moot point, but setting hv_root_tdp to root_tdp is also wrong.  KVM's
> behavior is that hv_root_tdp points at a valid root if and only if all vCPUs share
> said root.  E.g. invoking this when vCPUs have different roots will "corrupt"
> hv_root_tdp and possibly cause a remote flush to do the wrong thing.
>
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
> ---
>  arch/x86/kvm/svm/svm.c          | 39 ++++++++++++++++++++++++++++++---
>  arch/x86/kvm/svm/svm_onhyperv.h |  7 ++++++
>  2 files changed, 43 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 70183d2271b5..ab97fe8f1d81 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3746,7 +3746,7 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>  	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
>  }
>  
> -static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
> +static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> @@ -3770,6 +3770,39 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
>  		svm->current_vmcb->asid_generation--;
>  }
>  
> +static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
> +{
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	hpa_t root_tdp = vcpu->arch.mmu->root.hpa;
> +
> +	/*
> +	 * When running on Hyper-V with EnlightenedNptTlb enabled, explicitly
> +	 * flush the NPT mappings via hypercall as flushing the ASID only
> +	 * affects virtual to physical mappings, it does not invalidate guest
> +	 * physical to host physical mappings.
> +	 */
> +	if (svm_hv_is_enlightened_tlb_enabled(vcpu) && VALID_PAGE(root_tdp))
> +		hyperv_flush_guest_mapping(root_tdp);
> +#endif
> +	svm_flush_tlb_asid(vcpu);
> +}
> +
> +static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
> +{
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	/*
> +	 * When running on Hyper-V with EnlightenedNptTlb enabled, remote TLB
> +	 * flushes should be routed to hv_remote_flush_tlb() without requesting
> +	 * a "regular" remote flush.  Reaching this point means either there's
> +	 * a KVM bug or a prior hv_remote_flush_tlb() call failed, both of
> +	 * which might be fatal to the the guest.  Yell, but try to recover.
> +	 */
> +	if (WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
> +		hv_remote_flush_tlb(vcpu->kvm);
> +#endif
> +	svm_flush_tlb_asid(vcpu);
> +}
> +
>  static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -4762,10 +4795,10 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.set_rflags = svm_set_rflags,
>  	.get_if_flag = svm_get_if_flag,
>  
> -	.flush_tlb_all = svm_flush_tlb_current,
> +	.flush_tlb_all = svm_flush_tlb_all,
>  	.flush_tlb_current = svm_flush_tlb_current,
>  	.flush_tlb_gva = svm_flush_tlb_gva,
> -	.flush_tlb_guest = svm_flush_tlb_current,
> +	.flush_tlb_guest = svm_flush_tlb_asid,
>  
>  	.vcpu_pre_run = svm_vcpu_pre_run,
>  	.vcpu_run = svm_vcpu_run,
> diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
> index cff838f15db5..d91e019fb7da 100644
> --- a/arch/x86/kvm/svm/svm_onhyperv.h
> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
> @@ -15,6 +15,13 @@ static struct kvm_x86_ops svm_x86_ops;
>  
>  int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu);
>  
> +static inline bool svm_hv_is_enlightened_tlb_enabled(struct kvm_vcpu *vcpu)
> +{
> +	struct hv_vmcb_enlightenments *hve = &to_svm(vcpu)->vmcb->control.hv_enlightenments;
> +
> +	return !!hve->hv_enlightenments_control.enlightened_npt_tlb;

In theory, we should not look at Hyper-V enlightenments in VMCB control
just because our kernel has CONFIG_HYPERV enabled. I'd suggest we add a
real check that we're running on Hyper-V and we can do it the same way
it is done in svm_hv_hardware_setup()/svm_hv_init_vmcb():

	return (ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB)
		&& !!hve->hv_enlightenments_control.enlightened_npt_tlb;

(untested).

> +}
> +
>  static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
>  {
>  	struct hv_vmcb_enlightenments *hve = &vmcb->control.hv_enlightenments;
>
> base-commit: 50f13998451effea5c5fdc70fe576f8b435d6224

-- 
Vitaly

