Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B65A6B5632
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 01:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjCKAIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 19:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjCKAIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 19:08:48 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C392B56FC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 16:08:46 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id n1-20020a170902968100b0019cf3c5728fso3603539plp.19
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 16:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678493326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JrNRsMPiLpefyL6WtEvB2cdT+o9uzZpkE5/Q3sdl9dE=;
        b=Ca41b410IVdcWIvsrLx927yaQhibmYOOml2UdmxU8G8crdhuDkSQUBNXDYEdKCDz1/
         DHVKw548a1nK0I1beKdDtQwKxhja2vJNIyoZIlsGlvfcbeAg5lC8eBdy4WxuwzkAPobO
         vDZTL3Fn7Gk3eKVVPPGwi7pKc8gnI9ybXchm2TpKQ30g7JagC4XOetkUi1bMgfVZ0al2
         Spy5DiOHtmWx9zq5xoi7COLBBfYl8r+eG8uTQPNCX9ZUprM+SBPWPRGfpnFyw3X/aOlk
         eNygye1pxZ0fzR6wdl3Ym8mkETBlaSHUU/jAbr7QZvTMfMbs3q5As7JdK1MsAS/FDK1o
         Adpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678493326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JrNRsMPiLpefyL6WtEvB2cdT+o9uzZpkE5/Q3sdl9dE=;
        b=FjsafgQPdu689GgbKas32olnP18IWE6gp838jYtP+Faqf/PXf8A/808hs4BX3LeXT3
         M2rLNnUZX88bu2/ZrQBmuUkb3f2lAlrduuXgH2y4whme4UneaO5Tjz3UFwdXgB8he0rO
         lNy4t3liES21b0zrQnQn94HYkiKO6U34gjTCqTg3LlRPMtsIfQ3Ub/WUWraf5Y/3N3yj
         9C/tp4XbxZ8K1M9U0Wv6lW3OKebhle+skBgDSgSj4CIvLVWViDaFtdbT6IVZ8MGVEUDr
         dp0P8HOv4wiP63qrGkOUguFwfQsQ/FI4H2LfYsHDhgysDXoTvLQjsIUhWSPpv0lnA1lW
         90NQ==
X-Gm-Message-State: AO0yUKX0wcRtJ+0WyrSFSXzVfa0wWjjpDtw2FgnPT/Jja+UNsZeS3BKZ
        lzsxqbPauSYBDUlsb6RMpdZs2sNJ39c=
X-Google-Smtp-Source: AK7set9IoD+dD9w2QkIkrM52NZXyqqpLS3xDjiRnFd2WyshgF4ym/5cYI3RY19DjxALAx5DnKG6zapWWF3s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:b948:0:b0:507:4c56:f4a9 with SMTP id
 v8-20020a63b948000000b005074c56f4a9mr6533093pgo.3.1678493325770; Fri, 10 Mar
 2023 16:08:45 -0800 (PST)
Date:   Sat, 11 Mar 2023 00:08:44 +0000
In-Reply-To: <20230310234304.2908714-1-pbonzini@redhat.com>
Mime-Version: 1.0
References: <20230310234304.2908714-1-pbonzini@redhat.com>
Message-ID: <ZAvGjCqfKgsSEQhZ@google.com>
Subject: Re: [PATCH] KVM: nVMX: add missing consistency checks for CR0 and CR4
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Reima ISHII <ishiir@g.ecc.u-tokyo.ac.jp>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 10, 2023, Paolo Bonzini wrote:
> The effective values of the guest CR0 and CR4 registers may differ from
> those included in the VMCS12.  In particular, disabling EPT forces
> CR4.PAE=1 and disabling unrestricted guest mode forces CR0.PG=CR0.PE=1.
> 
> Therefore, checks on these bits cannot be delegated to the processor
> and must be performed by KVM.
> 
> Reported-by: Reima ISHII <ishiir@g.ecc.u-tokyo.ac.jp>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index d93c715cda6a..43693e4772ff 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3047,6 +3047,19 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>  					   vmcs12->guest_ia32_perf_global_ctrl)))
>  		return -EINVAL;
>  
> +	if (CC((vmcs12->guest_cr0 & (X86_CR0_PG | X86_CR0_PE)) == X86_CR0_PG))
> +		return -EINVAL;
> +
> +#ifdef CONFIG_X86_64

The #ifdef isn't necessary, attempting to set for a 32-bit host should be rejected
by nested_vmx_check_controls() since nested_vmx_setup_ctls_msrs() clears the bit.
Ditto for the host logic related to VM_EXIT_HOST_ADDR_SPACE_SIZE, which looks
suspiciously similar ;-)

I'd rather delete the #ifdef in nested_vmx_check_host_state() and do something
similar here, e.g.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7c4f5ca405c7..3e367ec5086a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2903,7 +2903,7 @@ static int nested_vmx_check_address_space_size(struct kvm_vcpu *vcpu,
 static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
                                       struct vmcs12 *vmcs12)
 {
-       bool ia32e;
+       bool ia32e = !!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE);
 
        if (CC(!nested_host_cr0_valid(vcpu, vmcs12->host_cr0)) ||
            CC(!nested_host_cr4_valid(vcpu, vmcs12->host_cr4)) ||
@@ -2923,12 +2923,6 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
                                           vmcs12->host_ia32_perf_global_ctrl)))
                return -EINVAL;
 
-#ifdef CONFIG_X86_64
-       ia32e = !!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE);
-#else
-       ia32e = false;
-#endif
-
        if (ia32e) {
                if (CC(!(vmcs12->host_cr4 & X86_CR4_PAE)))
                        return -EINVAL;


> +	ia32e = !!(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE);
> +#else
> +	ia32e = false;
> +#endif
> +	if (CC(ia32e &&
> +	       (!(vmcs12->guest_cr4 & X86_CR4_PAE) ||
> +		!(vmcs12->guest_cr0 & X86_CR0_PG))))
> +		return -EINVAL;

This is a lot easier to read IMO, and has the advantage of more precisely
identifying the failure in the tracepoint.

	if (CC(ia32e && !(vmcs12->guest_cr4 & X86_CR4_PAE)) ||
	    CC(ia32e && !(vmcs12->guest_cr4 & X86_CR0_PG)))
		return -EINVAL;

> +
>  	/*
>  	 * If the load IA32_EFER VM-entry control is 1, the following checks
>  	 * are performed on the field for the IA32_EFER MSR:
> @@ -3058,7 +3071,6 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>  	 */
>  	if (to_vmx(vcpu)->nested.nested_run_pending &&
>  	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_EFER)) {
> -		ia32e = (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) != 0;
>  		if (CC(!kvm_valid_efer(vcpu, vmcs12->guest_ia32_efer)) ||
>  		    CC(ia32e != !!(vmcs12->guest_ia32_efer & EFER_LMA)) ||
>  		    CC(((vmcs12->guest_cr0 & X86_CR0_PG) &&
> -- 
> 2.39.1
> 
