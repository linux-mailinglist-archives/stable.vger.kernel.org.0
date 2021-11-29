Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA36462856
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhK2Xh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbhK2Xh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:37:29 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722C3C061748
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 15:34:11 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id j11so7817404pgs.2
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 15:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V+grPLT6Bm3LhOVZVdNMjtG46j07YUiETl+a4utgQZk=;
        b=EtJujCxQlViEVHo2kgejeoQDRVoY9ANAeyj1xNgJln48hBzh6oVuTC+ZmM91X0+WpY
         a+yYH6PsYg55uEyor2vPdmg2dLXM4Gj2jDkZdTaT2x3+SQcMr750PrRhZESV9bf7y13s
         hlQvo17V6G4wbwxBtgecPc0PxgDVia+LWju/Sz6sUwd4ilNlAR2PaT/49nyZZSZOlZEU
         E4Ve7e+xFUicAGZOoqkNPLwcckkR5AvFAnnPBLOrmF8/O1pMAHHwRw7SkucEfgdmfZp5
         LOuvmeWES1DtRoCG9HqfnUFDOKeDeUoSyiq+zrxPfxcnkg04H4vVC3xasA6HBq7zCKzG
         DuSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V+grPLT6Bm3LhOVZVdNMjtG46j07YUiETl+a4utgQZk=;
        b=symXZlxyLuKVqtzBTofQ2HgL5xichcoiNkiSYWsbruCXSO3L2gzLvu8EQVpsZcuH0a
         4b9KN+Fzxows2IB58f443xHO+xXCRC8u/0GlpIQNTHDutYWn0CtlZ7Y/6km4GSRNJI3N
         M7InDQm5kfZ0IgRlI9+62+saRY4vsRD2vt4jn2aD8AZFFWD/TVsTGhCZP+ccElSESls8
         EmnksjJR//qHnKN7IMBvIMQkncjSg81AqjitniIr99HkyQjC6yviKNY/g6+NMK6H8RYj
         xya5aVKSnminUfBpvQ/Lf9QluvaoojISeROfX/o2gVFmLyiNHQ18biuUJ+0YxI0NxUpZ
         nC1Q==
X-Gm-Message-State: AOAM532BMLYsWGSWXVeGYf783K0xOYgIKwPyLuGPL/uZu8e2dLjBwRnA
        jVlJABXxenXhPiv+R3mlXuvNlg==
X-Google-Smtp-Source: ABdhPJwLGvFjaNBvgrufSbjdJ8H6tplhXNHnW2JND2X5sR2Kyov4IRBsozN6q0njvyeYoUwuqUAgfw==
X-Received: by 2002:a65:6145:: with SMTP id o5mr6810928pgv.134.1638228850750;
        Mon, 29 Nov 2021 15:34:10 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id pj12sm373641pjb.51.2021.11.29.15.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 15:34:09 -0800 (PST)
Date:   Mon, 29 Nov 2021 23:34:06 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: VMX: prepare sync_pir_to_irr for running with
 APICv disabled
Message-ID: <YaVjbgiv/6Zqunzx@google.com>
References: <20211123004311.2954158-1-pbonzini@redhat.com>
 <20211123004311.2954158-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123004311.2954158-3-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 22, 2021 at 07:43:09PM -0500, Paolo Bonzini wrote:
> If APICv is disabled for this vCPU, assigned devices may
> still attempt to post interrupts.  In that case, we need
> to cancel the vmentry and deliver the interrupt with
> KVM_REQ_EVENT.  Extend the existing code that handles
> injection of L1 interrupts into L2 to cover this case
> as well.
> 
> vmx_hwapic_irr_update is only called when APICv is active
> so it would be confusing to add a check for
> vcpu->arch.apicv_active in there.  Instead, just use
> vmx_set_rvi directly in vmx_sync_pir_to_irr.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: David Matlack <dmatlack@google.com>

(Although I agree with Sean's suggestions and 1 nit below.)

> ---
>  arch/x86/kvm/vmx/vmx.c | 35 +++++++++++++++++++++++------------
>  1 file changed, 23 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ba66c171d951..cccf1eab58ac 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6264,7 +6264,7 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
>  	int max_irr;
>  	bool max_irr_updated;
>  
> -	if (KVM_BUG_ON(!vcpu->arch.apicv_active, vcpu->kvm))
> +	if (KVM_BUG_ON(!enable_apicv, vcpu->kvm))
>  		return -EIO;
>  
>  	if (pi_test_on(&vmx->pi_desc)) {
> @@ -6276,20 +6276,31 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
>  		smp_mb__after_atomic();
>  		max_irr_updated =
>  			kvm_apic_update_irr(vcpu, vmx->pi_desc.pir, &max_irr);
> -
> -		/*
> -		 * If we are running L2 and L1 has a new pending interrupt
> -		 * which can be injected, this may cause a vmexit or it may
> -		 * be injected into L2.  Either way, this interrupt will be
> -		 * processed via KVM_REQ_EVENT, not RVI, because we do not use
> -		 * virtual interrupt delivery to inject L1 interrupts into L2.
> -		 */
> -		if (is_guest_mode(vcpu) && max_irr_updated)
> -			kvm_make_request(KVM_REQ_EVENT, vcpu);
>  	} else {
>  		max_irr = kvm_lapic_find_highest_irr(vcpu);
> +		max_irr_updated = false;
>  	}
> -	vmx_hwapic_irr_update(vcpu, max_irr);
> +
> +	/*
> +	 * If virtual interrupt delivery is not in use, the interrupt
> +	 * will be processed via KVM_REQ_EVENT, not RVI.  This can happen
> +	 * in two cases:
> +	 *
> +	 * 1) If we are running L2 and L1 has a new pending interrupt
> +	 * which can be injected, this may cause a vmexit or it may
> +	 * be injected into L2.  We do not use virtual interrupt
> +	 * delivery to inject L1 interrupts into L2.
> +	 *
> +	 * 2) If APICv is disabled for this vCPU, assigned devices may
> +	 * still attempt to post interrupts.  The posted interrupt
> +	 * vector will cause a vmexit and the subsequent entry will
> +	 * call sync_pir_to_irr.
> +	 */
> +	if (!is_guest_mode(vcpu) && vcpu->arch.apicv_active)
> +		vmx_set_rvi(max_irr);
> +	else if (max_irr_updated)
> +		kvm_make_request(KVM_REQ_EVENT, vcpu);

nit: In the version of this code that is currently in kvm/queue the
indentation of the previous 3 lines uses spaces instead of tabs. I see
tabs in this mail though.

> +
>  	return max_irr;
>  }
>  
> -- 
> 2.27.0
> 
> 
