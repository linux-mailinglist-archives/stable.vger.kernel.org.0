Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3788C46287E
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhK2XpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbhK2XpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:45:12 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9806C061748
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 15:41:54 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id q16so17700845pgq.10
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 15:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PDG0Bl8E6wlHiv8lfcoAy+JyQ0H+H21DxcHuwLiwAi8=;
        b=YHhv+ReJo9k2w1FFWtWlaPGT1O4O9PwdOFSROBlMrHS8iqi5qQAzDpbGhh7/DS718i
         yu8BBK8pMQIGNcMLZUYYZv2N5HOxKmDgwW71n/w2kqsplpyfq4XD+gUjgvfggIaK2hc2
         zoaWFXGPA4Bqtuq59fzBlki05ld9qNBD1Gcr63c92sNaIBJojY+uNCkSdXUG6gT9Ibp5
         AEZbTddRaD9q5lEwRKGtt4bGTW27j/MrQf01dZDxve9uRPofhTueAQWzR5h4yHAii/Ws
         Gqz3tJmbN7pRgTgbzCROImBo4dC3q+zaCDskXhSthAcDmqxTXO1wsTSf7ekTd5MfUuyv
         rX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PDG0Bl8E6wlHiv8lfcoAy+JyQ0H+H21DxcHuwLiwAi8=;
        b=khD6dvGJOKNYrcANZXRYfToV1EpWZMm0ddUFpKbWbq8gkFwkc8FzKYUW9czFSappIT
         12q5q1wdv2X8inm+bur3g0ZAml3Gx4dOlkvaDuc+f7dtryrSNxltgDffeFdnNUHpNw/9
         0dQQBnslkLdI6Wv19MA3o233UQXm/NjrH4ZGy09xKbpO42ER7I8HKoCCeNNHfOyGqgFs
         dxxh163qHa7eGwVanLzLW0hCm71W/ireNbG/a1UykrMv5yP6ssmgXkgYNPa8GFuVTlWw
         5uaD8qJEtJ6u+TJyEnYXhcTkGYp40biuD13iNsaXZ1WznBeBw1TgbDJKwSFyNIiekr74
         KD7g==
X-Gm-Message-State: AOAM532Nh/Eg9uBDGiGGsqiJpzBrUZkao0IBkSaw2rhnkq8AAch15JZc
        EroR0JF3NrjLVm1TR2Xe3Mz9IJ6hmKxFHA==
X-Google-Smtp-Source: ABdhPJxuBGPuA+T2tL92nF8nTaKDlOozw7oEPFI09uY+LONaAJeW35fY35HO46VjMrr8r0+nE/lVvg==
X-Received: by 2002:a63:4918:: with SMTP id w24mr23854492pga.598.1638229314214;
        Mon, 29 Nov 2021 15:41:54 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id t4sm19332194pfq.163.2021.11.29.15.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 15:41:53 -0800 (PST)
Date:   Mon, 29 Nov 2021 23:41:50 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, stable@vger.kernel.org
Subject: Re: [PATCH 4/4] KVM: x86: Use a stable condition around all VT-d PI
 paths
Message-ID: <YaVlPso5X2dM+kXC@google.com>
References: <20211123004311.2954158-1-pbonzini@redhat.com>
 <20211123004311.2954158-5-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123004311.2954158-5-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 22, 2021 at 07:43:11PM -0500, Paolo Bonzini wrote:
> Currently, checks for whether VT-d PI can be used refer to the current
> status of the feature in the current vCPU; or they more or less pick
> vCPU 0 in case a specific vCPU is not available.
> 
> However, these checks do not attempt to synchronize with changes to
> the IRTE.  In particular, there is no path that updates the IRTE when
> APICv is re-activated on vCPU 0; and there is no path to wakeup a CPU
> that has APICv disabled, if the wakeup occurs because of an IRTE
> that points to a posted interrupt.
> 
> To fix this, always go through the VT-d PI path as long as there are
> assigned devices and APICv is available on both the host and the VM side.
> Since the relevant condition was copied over three times, take the hint
> and factor it into a separate function.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/vmx/posted_intr.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 5f81ef092bd4..1c94783b5a54 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -5,6 +5,7 @@
>  #include <asm/cpu.h>
>  
>  #include "lapic.h"
> +#include "irq.h"
>  #include "posted_intr.h"
>  #include "trace.h"
>  #include "vmx.h"
> @@ -77,13 +78,18 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  		pi_set_on(pi_desc);
>  }
>  
> +static bool vmx_can_use_vtd_pi(struct kvm *kvm)
> +{
> +	return irqchip_in_kernel(kvm) && enable_apicv &&
> +		kvm_arch_has_assigned_device(kvm) &&
> +		irq_remapping_cap(IRQ_POSTING_CAP);
> +}
> +
>  void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
>  {
>  	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>  
> -	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
> -		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
> -		!kvm_vcpu_apicv_active(vcpu))
> +	if (!vmx_can_use_vtd_pi(vcpu->kvm))
>  		return;
>  
>  	/* Set SN when the vCPU is preempted */
> @@ -141,9 +147,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>  	struct pi_desc old, new;
>  	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>  
> -	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
> -		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
> -		!kvm_vcpu_apicv_active(vcpu))
> +	if (!vmx_can_use_vtd_pi(vcpu->kvm))
>  		return 0;
>  
>  	WARN_ON(irqs_disabled());
> @@ -270,9 +274,7 @@ int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
>  	struct vcpu_data vcpu_info;
>  	int idx, ret = 0;
>  
> -	if (!kvm_arch_has_assigned_device(kvm) ||
> -	    !irq_remapping_cap(IRQ_POSTING_CAP) ||
> -	    !kvm_vcpu_apicv_active(kvm->vcpus[0]))
> +	if (!vmx_can_use_vtd_pi(kvm))
>  		return 0;
>  
>  	idx = srcu_read_lock(&kvm->irq_srcu);
> -- 
> 2.27.0
> 
