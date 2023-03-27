Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD846C9ECA
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 11:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbjC0JBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 05:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbjC0JAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 05:00:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5406187
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 01:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679907483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u0K5CZY+NXJwZw0Rihp1Vuy/uuADkaGO2qThx55jqJM=;
        b=hj5lodzorapih3n8WqL3hPm+Fks26hswx0fRM9fT8VW984K74FIavUTO4lecywPX5FUX6u
        BIRk84eFAfBkE6loFs+xPbjPUHmfj6WZl/jyTccg177fVNOlSHLh565l8lgIqwfUOHhxgY
        D1O8ppqNodzDihUDZAfoxDxyBci03rU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-nbc4WLioM2uvwYSAzGpDiA-1; Mon, 27 Mar 2023 04:58:01 -0400
X-MC-Unique: nbc4WLioM2uvwYSAzGpDiA-1
Received: by mail-ed1-f72.google.com with SMTP id k12-20020a50c8cc000000b004accf30f6d3so11611711edh.14
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 01:58:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679907481;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u0K5CZY+NXJwZw0Rihp1Vuy/uuADkaGO2qThx55jqJM=;
        b=VExmJoxoSzVmydwBtOJNJhG4HuVsWL+BlJ1WsD4lbBXG2lOqZs8KyidRvR+BzTuWjS
         vT+Ooq1TMyT4ApYMdi/SKj2SAn9+6ImAqOD4E1AUDBt1Mu7j9RGt40qCEOeCTxlnDnUn
         kdV81XqTffxSEMMNZLlOOxYRHIm3qVwikPBruq5HbGlJJG8ALnpL4d28DE2ZDNHasU6x
         tAGsdo6p+9ylBYtT+ZSvkIlENvIxQ9GgnqHjf1rdFpMB9iEowjSWucI+mW0/ptcLtG39
         LeACIKw+cmvEhdrU7OHHZcik99JSMxEkLk3b0BX/1f0Z3LgEWOdNSkqbJgioV+R7UN9W
         vMvw==
X-Gm-Message-State: AAQBX9f9uUsZe5iyCIXh3LRqDPcmhm7AIL7a3L4aKvBk3Ndv0dmeWWnB
        23rNRHsVqfA6FIrpJNuhYEGfcIckLs4rWpUMoyi2WuSeJt8dBkVLLRDKc9Gh6C3Xh5Zr+3jjPyR
        DNHsROCL3pO3O75Zy13b03R65PqJKwwQfjJ3pvtKCydxVczskbE7f7OQBzXjPgCYACIt8mJsEs7
        BY
X-Received: by 2002:a17:906:14cf:b0:8a6:e075:e364 with SMTP id y15-20020a17090614cf00b008a6e075e364mr11729383ejc.26.1679907480857;
        Mon, 27 Mar 2023 01:58:00 -0700 (PDT)
X-Google-Smtp-Source: AKy350YzXx1awvwkX+fEgvumj6+GHSmG5iDCpAd/o9IgdsARmwwcbXihmYzwXAeNrNoX5lt7Z9UZOA==
X-Received: by 2002:a17:906:14cf:b0:8a6:e075:e364 with SMTP id y15-20020a17090614cf00b008a6e075e364mr11729360ejc.26.1679907480529;
        Mon, 27 Mar 2023 01:58:00 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id d7-20020a1709067f0700b00882f9130eafsm13772654ejr.26.2023.03.27.01.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 01:57:59 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     jpiotrowski@linux.microsoft.com, linux-kernel@vger.kernel.org
Cc:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>, stable@vger.kernel.org
Subject: Re: [RESEND PATCH v2] KVM: SVM: Flush Hyper-V TLB when required
In-Reply-To: <20230324145233.4585-1-jpiotrowski@linux.microsoft.com>
References: <20230324144500.4216-1-jpiotrowski@microsoft.com>
 <20230324145233.4585-1-jpiotrowski@linux.microsoft.com>
Date:   Mon, 27 Mar 2023 10:57:58 +0200
Message-ID: <87tty6o9k9.fsf@redhat.com>
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

jpiotrowski@linux.microsoft.com writes:

> From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
>
> The Hyper-V "EnlightenedNptTlb" enlightenment is always enabled when KVM
> is running on top of Hyper-V and Hyper-V exposes support for it (which
> is always). On AMD CPUs this enlightenment results in ASID invalidations
> not flushing TLB entries derived from the NPT. To force the underlying
> (L0) hypervisor to rebuild its shadow page tables, an explicit hypercall
> is needed.
>
> The original KVM implementation of Hyper-V's "EnlightenedNptTlb" on SVM
> only added remote TLB flush hooks. This worked out fine for a while, as
> sufficient remote TLB flushes where being issued in KVM to mask the
> problem. Since v5.17, changes in the TDP code reduced the number of
> flushes and the out-of-sync TLB prevents guests from booting
> successfully.
>
> Split svm_flush_tlb_current() into separate callbacks for the 3 cases
> (guest/all/current), and issue the required Hyper-V hypercall when a
> Hyper-V TLB flush is needed. The most important case where the TLB flush
> was missing is when loading a new PGD, which is followed by what is now
> svm_flush_tlb_current().
>
> Cc: stable@vger.kernel.org # v5.17+
> Fixes: 1e0c7d40758b ("KVM: SVM: hyper-v: Remote TLB flush for SVM")
> Link: https://lore.kernel.org/lkml/43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com/
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
> ---
> Resending because I accidentally used the wrong "From:" address and it bounced
> from some recipients.
>
> Changes since v1:
> - lookup enlightened_npt_tlb in vmcb to determine whether to do the
>   flush
> - when KVM wants a hyperv_flush_guest_mapping() call, don't try to
>   optimize it out
> - don't hide hyperv flush behind helper, make it visible in
>   svm.c
>
>  arch/x86/kvm/kvm_onhyperv.h     |  5 +++++
>  arch/x86/kvm/svm/svm.c          | 37 ++++++++++++++++++++++++++++++---
>  arch/x86/kvm/svm/svm_onhyperv.h | 15 +++++++++++++
>  3 files changed, 54 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
> index 287e98ef9df3..67b53057e41c 100644
> --- a/arch/x86/kvm/kvm_onhyperv.h
> +++ b/arch/x86/kvm/kvm_onhyperv.h
> @@ -12,6 +12,11 @@ int hv_remote_flush_tlb_with_range(struct kvm *kvm,
>  int hv_remote_flush_tlb(struct kvm *kvm);
>  void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
>  #else /* !CONFIG_HYPERV */
> +static inline int hv_remote_flush_tlb(struct kvm *kvm)
> +{
> +	return -1;
> +}

Nitpick: -ENOTSUPP?

> +
>  static inline void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
>  {
>  }
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 252e7f37e4e2..f25bc3cbb250 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3729,7 +3729,7 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>  	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
>  }
>  
> -static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
> +static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> @@ -3753,6 +3753,37 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
>  		svm->current_vmcb->asid_generation--;
>  }
>  
> +static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
> +{
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

Nitpick: it could also make sense to yell with a WARN_ON_ONCE() or
something if hyperv_flush_guest_mapping() ever fails.

> +
> +	svm_flush_tlb_asid(vcpu);
> +}
> +
> +static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * When running on Hyper-V with EnlightenedNptTlb enabled, remote TLB
> +	 * flushes should be routed to hv_remote_flush_tlb() without requesting
> +	 * a "regular" remote flush.  Reaching this point means either there's
> +	 * a KVM bug or a prior hv_remote_flush_tlb() call failed, both of
> +	 * which might be fatal to the guest.  Yell, but try to recover.
> +	 */
> +	if (WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
> +		hv_remote_flush_tlb(vcpu->kvm);
> +
> +	svm_flush_tlb_asid(vcpu);
> +}
> +
>  static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -4745,10 +4776,10 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
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
> index cff838f15db5..786d46d73a8e 100644
> --- a/arch/x86/kvm/svm/svm_onhyperv.h
> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
> @@ -6,6 +6,8 @@
>  #ifndef __ARCH_X86_KVM_SVM_ONHYPERV_H__
>  #define __ARCH_X86_KVM_SVM_ONHYPERV_H__
>  
> +#include <asm/mshyperv.h>
> +
>  #if IS_ENABLED(CONFIG_HYPERV)
>  
>  #include "kvm_onhyperv.h"
> @@ -15,6 +17,14 @@ static struct kvm_x86_ops svm_x86_ops;
>  
>  int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu);
>  
> +static inline bool svm_hv_is_enlightened_tlb_enabled(struct kvm_vcpu *vcpu)
> +{
> +	struct hv_vmcb_enlightenments *hve = &to_svm(vcpu)->vmcb->control.hv_enlightenments;
> +
> +	return ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB &&
> +	       !!hve->hv_enlightenments_control.enlightened_npt_tlb;
> +}
> +
>  static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
>  {
>  	struct hv_vmcb_enlightenments *hve = &vmcb->control.hv_enlightenments;
> @@ -80,6 +90,11 @@ static inline void svm_hv_update_vp_id(struct vmcb *vmcb, struct kvm_vcpu *vcpu)
>  }
>  #else
>  
> +static inline bool svm_hv_is_enlightened_tlb_enabled(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}
> +
>  static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
>  {
>  }

Apart from the two nitpicks above,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

