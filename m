Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3642C9D56
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389237AbgLAJWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:22:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389220AbgLAJI1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 04:08:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606813619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S8eqZj7fPMFZ00nLqUWB8YSuSEn9DKOcT/A5jGQUnIw=;
        b=Vtv1NXN3E0C9TS8lIRaewrWMSrn3w0WF4P2XdyWoLOV5iDTyOJf7g7nc8MwsMNslPsY3BF
        fcsk4MePMu3Rw4yXOP3FJ9YU/+nXk+Xvzg1xc/4T2FZv/fK55PJxXHy0pPSdxviJ/aKVM7
        h30k/0BjOcbfNTuhZz5eb2QcCqJlIck=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-qEbYp9zLM_GJJJZMomLNHQ-1; Tue, 01 Dec 2020 04:06:58 -0500
X-MC-Unique: qEbYp9zLM_GJJJZMomLNHQ-1
Received: by mail-ej1-f71.google.com with SMTP id k15so844665ejg.8
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 01:06:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S8eqZj7fPMFZ00nLqUWB8YSuSEn9DKOcT/A5jGQUnIw=;
        b=uoWzTzdL8yNkpp5/ySYOuqWpfQHuz7jlnXR+EDvBUFoogiBOWG0Ytnz/IuI4LsQI3y
         bd8XNrYI5Suh5XHnhRF//OtW+K/f0FkOMV0AaKoy1ROfktrkW8wqpAbVfJXPEXaE+xsK
         cgJDNun7oklTygn2lDLsWc8dmGip/kkYtXUnPX7us3HKKzEB9OouWXNuonPdC9de87KO
         RDW0K+ovvXPNGaB3ABQEkcfHOx6kA25PYuofgrrj9tdrjeff0dwhWJz7ec8292q7m1cu
         1x+MEmll9m62F7UaZx20PzMvlUd7E+kFYUJDVi+Mkm4w6OrtfC3csDY1jjc7F1/YwRri
         9L5g==
X-Gm-Message-State: AOAM530lw6qY7zHm01H4rK16MIUfaQAX+PTuawvVp0xjK/nUJjx4trdN
        UodnuvckfZsvDsJ9yF6L46OqqJGOv1k3NNBqXEHRCHYYWBvi7fAuaXyWWM9owNXcAisTO5BSTMY
        wg6hcFtGx9UNCv4Rv
X-Received: by 2002:a05:6402:714:: with SMTP id w20mr2013397edx.252.1606813616605;
        Tue, 01 Dec 2020 01:06:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwsGaRmELbAzEX8fHKL0sbBJshDojcjnaqhBer5fplEH//fj1holAlI/77GZeJgnCFN8urpCw==
X-Received: by 2002:a05:6402:714:: with SMTP id w20mr2013380edx.252.1606813616386;
        Tue, 01 Dec 2020 01:06:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p91sm485315edp.9.2020.12.01.01.06.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 01:06:55 -0800 (PST)
Subject: Re: [PATCH 4.19 08/57] KVM: x86: Fix split-irqchip vs interrupt
 injection window request
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Nikos Tsironis <ntsironis@arrikto.com>
References: <20201201084647.751612010@linuxfoundation.org>
 <20201201084648.690944071@linuxfoundation.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d29c4b25-33f6-8d99-7a45-8f4e06f5ade6@redhat.com>
Date:   Tue, 1 Dec 2020 10:06:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201201084648.690944071@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/12/20 09:53, Greg Kroah-Hartman wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> commit 71cc849b7093bb83af966c0e60cb11b7f35cd746 upstream.

Since you did not apply "KVM: x86: handle !lapic_in_kernel case in 
kvm_cpu_*_extint" to 4.19 or earlier, please leave this one out as well.

Thanks,

Paolo

> kvm_cpu_accept_dm_intr and kvm_vcpu_ready_for_interrupt_injection are
> a hodge-podge of conditions, hacked together to get something that
> more or less works.  But what is actually needed is much simpler;
> in both cases the fundamental question is, do we have a place to stash
> an interrupt if userspace does KVM_INTERRUPT?
> 
> In userspace irqchip mode, that is !vcpu->arch.interrupt.injected.
> Currently kvm_event_needs_reinjection(vcpu) covers it, but it is
> unnecessarily restrictive.
> 
> In split irqchip mode it's a bit more complicated, we need to check
> kvm_apic_accept_pic_intr(vcpu) (the IRQ window exit is basically an INTACK
> cycle and thus requires ExtINTs not to be masked) as well as
> !pending_userspace_extint(vcpu).  However, there is no need to
> check kvm_event_needs_reinjection(vcpu), since split irqchip keeps
> pending ExtINT state separate from event injection state, and checking
> kvm_cpu_has_interrupt(vcpu) is wrong too since ExtINT has higher
> priority than APIC interrupts.  In fact the latter fixes a bug:
> when userspace requests an IRQ window vmexit, an interrupt in the
> local APIC can cause kvm_cpu_has_interrupt() to be true and thus
> kvm_vcpu_ready_for_interrupt_injection() to return false.  When this
> happens, vcpu_run does not exit to userspace but the interrupt window
> vmexits keep occurring.  The VM loops without any hope of making progress.
> 
> Once we try to fix these with something like
> 
>       return kvm_arch_interrupt_allowed(vcpu) &&
> -        !kvm_cpu_has_interrupt(vcpu) &&
> -        !kvm_event_needs_reinjection(vcpu) &&
> -        kvm_cpu_accept_dm_intr(vcpu);
> +        (!lapic_in_kernel(vcpu)
> +         ? !vcpu->arch.interrupt.injected
> +         : (kvm_apic_accept_pic_intr(vcpu)
> +            && !pending_userspace_extint(v)));
> 
> we realize two things.  First, thanks to the previous patch the complex
> conditional can reuse !kvm_cpu_has_extint(vcpu).  Second, the interrupt
> window request in vcpu_enter_guest()
> 
>          bool req_int_win =
>                  dm_request_for_irq_injection(vcpu) &&
>                  kvm_cpu_accept_dm_intr(vcpu);
> 
> should be kept in sync with kvm_vcpu_ready_for_interrupt_injection():
> it is unnecessary to ask the processor for an interrupt window
> if we would not be able to return to userspace.  Therefore,
> kvm_cpu_accept_dm_intr(vcpu) is basically !kvm_cpu_has_extint(vcpu)
> ANDed with the existing check for masked ExtINT.  It all makes sense:
> 
> - we can accept an interrupt from userspace if there is a place
>    to stash it (and, for irqchip split, ExtINTs are not masked).
>    Interrupts from userspace _can_ be accepted even if right now
>    EFLAGS.IF=0.
> 
> - in order to tell userspace we will inject its interrupt ("IRQ
>    window open" i.e. kvm_vcpu_ready_for_interrupt_injection), both
>    KVM and the vCPU need to be ready to accept the interrupt.
> 
> ... and this is what the patch implements.
> 
> Reported-by: David Woodhouse <dwmw@amazon.co.uk>
> Analyzed-by: David Woodhouse <dwmw@amazon.co.uk>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Nikos Tsironis <ntsironis@arrikto.com>
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> Tested-by: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>   arch/x86/include/asm/kvm_host.h |    1 +
>   arch/x86/kvm/irq.c              |    2 +-
>   arch/x86/kvm/x86.c              |   18 ++++++++++--------
>   3 files changed, 12 insertions(+), 9 deletions(-)
> 
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1472,6 +1472,7 @@ int kvm_test_age_hva(struct kvm *kvm, un
>   void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
>   int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v);
>   int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
> +int kvm_cpu_has_extint(struct kvm_vcpu *v);
>   int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
>   int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
>   void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
> --- a/arch/x86/kvm/irq.c
> +++ b/arch/x86/kvm/irq.c
> @@ -52,7 +52,7 @@ static int pending_userspace_extint(stru
>    * check if there is pending interrupt from
>    * non-APIC source without intack.
>    */
> -static int kvm_cpu_has_extint(struct kvm_vcpu *v)
> +int kvm_cpu_has_extint(struct kvm_vcpu *v)
>   {
>   	/*
>   	 * FIXME: interrupt.injected represents an interrupt whose
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3351,21 +3351,23 @@ static int kvm_vcpu_ioctl_set_lapic(stru
>   
>   static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
>   {
> +	/*
> +	 * We can accept userspace's request for interrupt injection
> +	 * as long as we have a place to store the interrupt number.
> +	 * The actual injection will happen when the CPU is able to
> +	 * deliver the interrupt.
> +	 */
> +	if (kvm_cpu_has_extint(vcpu))
> +		return false;
> +
> +	/* Acknowledging ExtINT does not happen if LINT0 is masked.  */
>   	return (!lapic_in_kernel(vcpu) ||
>   		kvm_apic_accept_pic_intr(vcpu));
>   }
>   
> -/*
> - * if userspace requested an interrupt window, check that the
> - * interrupt window is open.
> - *
> - * No need to exit to userspace if we already have an interrupt queued.
> - */
>   static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
>   {
>   	return kvm_arch_interrupt_allowed(vcpu) &&
> -		!kvm_cpu_has_interrupt(vcpu) &&
> -		!kvm_event_needs_reinjection(vcpu) &&
>   		kvm_cpu_accept_dm_intr(vcpu);
>   }
>   
> 
> 

