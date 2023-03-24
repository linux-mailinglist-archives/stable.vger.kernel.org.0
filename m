Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B516C7F8A
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 15:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbjCXOKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 10:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjCXOKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 10:10:12 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD0510E4
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 07:10:10 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y186-20020a62cec3000000b00627df3d6ec4so1087720pfg.12
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 07:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679667009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CWpcOYM2XWdXOX3DlpY8mPmjLbjuakzNMgAVwLPKkxc=;
        b=APuFpvTRs+G0tqYU6GjklJqvlwAO/FbYF6pULMa9UiTV3xhuR6XFgLpwP/3AS0fDnL
         1VJ/oQ46lFeA/ngjf7/D6y1xFH/wrwjMhiTsezesbRerWK51sUaTsFfjaPPoNSZifhS9
         AC8QidsSsOA5Oh+KEw9OF81JPQb2YCGk2nI5Xko9+ViIPuc1eOBXByEgtCJkM3CrOGlS
         q+xe/6X+x7mi22t2Xri+niSlETuU7kIB/SzfGcWLLnj5KFZXYmtR0dtoCazsaLz+VJlu
         6nTt85/2YeP0g7X/VNtEoydsPbhomrPv/1Rmh2WUYHEn5YrgQPlKHAVKTI6/q3RjLro4
         HDZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679667009;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CWpcOYM2XWdXOX3DlpY8mPmjLbjuakzNMgAVwLPKkxc=;
        b=F3d3qxnqKh9npRAo05ikfBOF9IuPMbrWvOPn5LDkvWmnkRNGMk/88kS3+/qfk7NycL
         c8p5oiCsm90RVFacAH5sUljnCFf/t9Wq/KIkWUL3cT6qoiXXe3bHTuJYj+Ch9gyqgFJk
         +Gtb5TJoTOlXbKN/IGaE7/hnQ5rPzCIVFBSDnZa1C4WEjXSzXBD2XzR6Xmp4uNh5qslq
         69Ql3gsWKzhsMFQsUxchfJewkGbMnKXCnuNo3vXXu3chW71mgw4Bk3TxLMe7eS8cY+lm
         MIOXjp/SFveD6+IwNfLA9qxKuo0qrkSPvkxSb2gnZJGnUTkNeBBJ80HUvdyAeKcONbFD
         IDjA==
X-Gm-Message-State: AAQBX9e27VPCZbC2FLWdyH5MorekfXiJxTes5PAOGuLwzIfIi/VKIrvL
        j5XSB01vzDJ1oFOcZqKbRaXoSfsQL/w=
X-Google-Smtp-Source: AKy350ZUuFkmCA3HcKPpAu99ntzkTrfHSFERhqOOxLfptgWxyXdemoDjpqd3FxcKPMV0XHd7ES5TaPj1rVo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c101:b0:1a1:e48b:98b8 with SMTP id
 1-20020a170902c10100b001a1e48b98b8mr1028100pli.10.1679667009722; Fri, 24 Mar
 2023 07:10:09 -0700 (PDT)
Date:   Fri, 24 Mar 2023 07:10:08 -0700
In-Reply-To: <0a9ba6e6-d976-c3fa-372e-81fba85210ab@linux.microsoft.com>
Mime-Version: 1.0
References: <20230320185110.1346829-1-jpiotrowski@linux.microsoft.com>
 <ZBsqxeRDh+iV8qmm@google.com> <0a9ba6e6-d976-c3fa-372e-81fba85210ab@linux.microsoft.com>
Message-ID: <ZB2vQHl0tSbhsDao@google.com>
Subject: Re: [PATCH] KVM: SVM: Flush Hyper-V TLB when required
From:   Sean Christopherson <seanjc@google.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 24, 2023, Jeremi Piotrowski wrote:
> I have the #ifdef version ready to send out, but what do you think about this:

Oh, nice!  Yeah, that works, I didn't see the stub for hyperv_flush_guest_mapping().

> @@ -3753,6 +3753,39 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
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
> +	if (IS_ENABLED(CONFIG_HYPERV) &&

No need for the IS_ENABLED(CONFIG_HYPERV) check here, the svm_hv_is_enlightened_tlb_enabled()
stub that's provided for CONFIG_HYPERV=n will guard this properly

	if (svm_hv_is_enlightened_tlb_enabled(vcpu) && VALID_PAGE(root_tdp))
		hyperv_flush_guest_mapping(root_tdp);

> +	    svm_hv_is_enlightened_tlb_enabled(vcpu) &&
> +	    VALID_PAGE(root_tdp))
> +		hyperv_flush_guest_mapping(root_tdp);
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
> +	if (IS_ENABLED(CONFIG_HYPERV) && WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
> +		hv_remote_flush_tlb(vcpu->kvm);

And then

	if (WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
		hv_remote_flush_tlb(vcpu->kvm);


> +
> +	svm_flush_tlb_asid(vcpu);
> +}
> +
>  static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -4745,10 +4778,10 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
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
> index cff838f15db5..4c9e0d4ba3dd 100644
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
> +		!!hve->hv_enlightenments_control.enlightened_npt_tlb;

Uber nit, align the indentation (7 spaces instead of 1 tab):

	return ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB &&
	       !!hve->hv_enlightenments_control.enlightened_npt_tlb;
