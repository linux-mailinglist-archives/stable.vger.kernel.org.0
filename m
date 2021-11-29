Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0FC462871
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhK2Xm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbhK2Xm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:42:28 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A65C061746
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 15:39:10 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id b13so13472905plg.2
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 15:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l95pitG8XWSZA2qHHx4PG3DJ3b8PJb5JkgMPwr0r3nQ=;
        b=n0HdvNHnOANn3F8gb2SzjXyCawVgDU1I/FSfqN4L3VS8OcM3yAjGzUy04KrFMU3xIS
         kmb64yaGH+vb0rnaq3h8bmfAOiEMVUf2rEqjd1CMVaq/gKSlCFp92EuE8Mbr8gbfa4dc
         Z6U/l0YQ5Tr1dqs+c0a6ZxVLdBRC+D2ry1AUF/O60228Lgkm5oZFj0x/hbirBow2tw0z
         X5D4xNqJ3WXZldUOP8dWRdb9WVUpWFIMVq1Novb/vvcTYuoTpLyo04eEMxEyOGKI7cQD
         4jxchaejPESUmzw0ST5qz8LSMfPHk/QFnUWuRwaV2eMvber9LQGuz6z1nWQfh6MLCF1P
         4UyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l95pitG8XWSZA2qHHx4PG3DJ3b8PJb5JkgMPwr0r3nQ=;
        b=pYKkLqJTLoe925MoAJRPDFao0ywPf+yaS646NMf01eXX8UVBHlMup4abN1WVTaVJMA
         Kqw3DZhPZG9xAdO4I9s727I5isJoUKg9Vj8e3yDAHejivmSvykEXEYLyZQXGX2Cc2KZI
         VmSZfLQYzxJHS/1iuDPqSCOO3A5akps/jsQ24+cbZKAqCDrhGNIMO+ivnzO3LeFJBCDW
         6bLdyxY5s0Du3Q6hqQLNLuuqoVqJgVq2WwQa7nB+3L+hmKHiS4EtgL8ZPZPfPfBa9YZ1
         xgMwQm/4/R/aEKbatn6GLwJPuzi9k9kx49VLzLJac43fEE/rhvOjh8Cy79UAR+1Io/Rk
         Y20g==
X-Gm-Message-State: AOAM5322+MPZkSw5z18QdlRthiKJvBudqTpod2xcVXrEeo7uOg6AD1C3
        /Y4/5mck1o74XFq7QlHUJh6Nqg==
X-Google-Smtp-Source: ABdhPJzfx5GC1GwB20sQRZs3rVQqpgwhCAI/QvWJnEj5FawPhmFRasku0aLu2CyGaYc+6L3pBrg80Q==
X-Received: by 2002:a17:90b:4f4d:: with SMTP id pj13mr1542168pjb.4.1638229149499;
        Mon, 29 Nov 2021 15:39:09 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id i2sm19595715pfg.90.2021.11.29.15.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 15:39:08 -0800 (PST)
Date:   Mon, 29 Nov 2021 23:39:05 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, stable@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: x86: check PIR even for vCPUs with disabled
 APICv
Message-ID: <YaVkmfqkau2EYuy+@google.com>
References: <20211123004311.2954158-1-pbonzini@redhat.com>
 <20211123004311.2954158-4-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123004311.2954158-4-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 22, 2021 at 07:43:10PM -0500, Paolo Bonzini wrote:
> The IRTE for an assigned device can trigger a POSTED_INTR_VECTOR even
> if APICv is disabled on the vCPU that receives it.  In that case, the
> interrupt will just cause a vmexit and leave the ON bit set together
> with the PIR bit corresponding to the interrupt.
> 
> Right now, the interrupt would not be delivered until APICv is re-enabled.
> However, fixing this is just a matter of always doing the PIR->IRR
> synchronization, even if the vCPU has temporarily disabled APICv.
> 
> This is not a problem for performance, or if anything it is an
> improvement.  First, in the common case where vcpu->arch.apicv_active is
> true, one fewer check has to be performed.  Second, static_call_cond will
> elide the function call if APICv is not present or disabled.  Finally,
> in the case for AMD hardware we can remove the sync_pir_to_irr callback:
> it is only needed for apic_has_interrupt_for_ppr, and that function
> already has a fallback for !APICv.
> 
> Cc: stable@vger.kernel.org
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/lapic.c   |  2 +-
>  arch/x86/kvm/svm/svm.c |  1 -
>  arch/x86/kvm/x86.c     | 18 +++++++++---------
>  3 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 759952dd1222..f206fc35deff 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -707,7 +707,7 @@ static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
>  static int apic_has_interrupt_for_ppr(struct kvm_lapic *apic, u32 ppr)
>  {
>  	int highest_irr;
> -	if (apic->vcpu->arch.apicv_active)
> +	if (kvm_x86_ops.sync_pir_to_irr)
>  		highest_irr = static_call(kvm_x86_sync_pir_to_irr)(apic->vcpu);
>  	else
>  		highest_irr = apic_find_highest_irr(apic);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 5630c241d5f6..d0f68d11ec70 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4651,7 +4651,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.load_eoi_exitmap = svm_load_eoi_exitmap,
>  	.hwapic_irr_update = svm_hwapic_irr_update,
>  	.hwapic_isr_update = svm_hwapic_isr_update,
> -	.sync_pir_to_irr = kvm_lapic_find_highest_irr,
>  	.apicv_post_state_restore = avic_post_state_restore,
>  
>  	.set_tss_addr = svm_set_tss_addr,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 441f4769173e..a8f12c83db4b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4448,8 +4448,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
>  				    struct kvm_lapic_state *s)
>  {
> -	if (vcpu->arch.apicv_active)
> -		static_call(kvm_x86_sync_pir_to_irr)(vcpu);
> +	static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
>  
>  	return kvm_apic_get_state(vcpu, s);
>  }
> @@ -9528,8 +9527,7 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
>  	if (irqchip_split(vcpu->kvm))
>  		kvm_scan_ioapic_routes(vcpu, vcpu->arch.ioapic_handled_vectors);
>  	else {
> -		if (vcpu->arch.apicv_active)
> -			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
> +		static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
>  		if (ioapic_in_kernel(vcpu->kvm))
>  			kvm_ioapic_scan_entry(vcpu, vcpu->arch.ioapic_handled_vectors);
>  	}
> @@ -9802,10 +9800,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  	/*
>  	 * This handles the case where a posted interrupt was
> -	 * notified with kvm_vcpu_kick.
> +	 * notified with kvm_vcpu_kick.  Assigned devices can
> +	 * use the POSTED_INTR_VECTOR even if APICv is disabled,
> +	 * so do it even if APICv is disabled on this vCPU.
>  	 */
> -	if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
> -		static_call(kvm_x86_sync_pir_to_irr)(vcpu);
> +	if (kvm_lapic_enabled(vcpu))
> +		static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
>  
>  	if (kvm_vcpu_exit_request(vcpu)) {
>  		vcpu->mode = OUTSIDE_GUEST_MODE;
> @@ -9849,8 +9849,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
>  			break;
>  
> -		if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
> -			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
> +		if (kvm_lapic_enabled(vcpu))
> +			static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
>  
>  		if (unlikely(kvm_vcpu_exit_request(vcpu))) {
>  			exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
> -- 
> 2.27.0
> 
> 
