Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A3535961F
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 09:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhDIHOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 03:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbhDIHOe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 03:14:34 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B31C061760;
        Fri,  9 Apr 2021 00:14:21 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id k25so4927654iob.6;
        Fri, 09 Apr 2021 00:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VTmdTMBzyKToChcb7ZNRkSEhVlJj9wYY6YTSsfntQ4M=;
        b=r7N+hcQdTvq0JWsBEaJzKqcA99+gvM2DgXx2mft9eZhCtEyNxJRbaVpA3wmE2Kx/yo
         vwCIuAYH7r2IZfmMQMiVMFZ2rsMOhdoAvn2eMPbXhXPBUKCy3E0QBdWUBCpLMY1UmpRH
         fTQzNH53D+EJdKiXU2HXmvWHlpT0B1t9j2lBlyh7Ws06GazyKK0ohKzxvbqqJSllsC1z
         S+XwT6flttyBxhMLEE0tGQK8aC705bM63m8r2IvCHqgdT331mDkBgL2eqcrvRBDLGi9T
         BHm3jfz2qNWSTwKmgrtCP1yAR7hd/zLW6rYL5iLsR8Ct4TjQNl1M49S9UfIzt8/6WXkg
         azGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VTmdTMBzyKToChcb7ZNRkSEhVlJj9wYY6YTSsfntQ4M=;
        b=MhxqsAdRgopZgM1/3VH14VGTWPD2+yIQuDT3FnrUiyTK25yRifgKN8dQW2jXVr4UmM
         uPxsbQy4e8I+h6K11FZlJrAqelcs1btPIeT6BIikhtnQdhyuuTgfZtHQqceke69vD3aS
         aBBuAreuzBpFCtr0s88Ju/mbFvpFResdjvijR40vlDPIFTlAgEcNgqIy4Mm/JN1WsNGn
         EpHGRHyD/yU9RJuwqiIQj53SfkzPZIJy8I8ZdJLsI47rdYkzxRk+0sOp8sp4IvURa55I
         CARoeBu1KffZbXLUUP+ALxw5q4f2npyVaoF4xBCWHAtGkQKFPHuW1Z+B9I1FMvoq/4xW
         rxNA==
X-Gm-Message-State: AOAM531aM/6ExrJk6CEyk8tOtGHHN9AWHEfZ5McXJrD5jzYDxLszCuZ4
        47becHGGPBu4QRBF6Vcgl87AzRm+AVbzu/Jvmvw=
X-Google-Smtp-Source: ABdhPJyegJp7g4Zxdu3DE79gjWENGNF4EzjQ+x6DRHH5+i6AQhWscsxus5BtJCDiwwPjzgXn8tt/jOGBQHdYJiJNo50=
X-Received: by 2002:a02:ba1a:: with SMTP id z26mr9802353jan.43.1617952461183;
 Fri, 09 Apr 2021 00:14:21 -0700 (PDT)
MIME-Version: 1.0
References: <20201127112114.3219360-1-pbonzini@redhat.com> <20201127112114.3219360-3-pbonzini@redhat.com>
In-Reply-To: <20201127112114.3219360-3-pbonzini@redhat.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Fri, 9 Apr 2021 15:14:10 +0800
Message-ID: <CAJhGHyCdqgtvK98_KieG-8MUfg1Jghd+H99q+FkgL0ZuqnvuAw@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86: Fix split-irqchip vs interrupt injection
 window request
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Filippo Sironi <sironi@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "v4.7+" <stable@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 27, 2020 at 7:26 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
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
>      return kvm_arch_interrupt_allowed(vcpu) &&
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
>         bool req_int_win =
>                 dm_request_for_irq_injection(vcpu) &&
>                 kvm_cpu_accept_dm_intr(vcpu);
>
> should be kept in sync with kvm_vcpu_ready_for_interrupt_injection():
> it is unnecessary to ask the processor for an interrupt window
> if we would not be able to return to userspace.  Therefore, the
> complex conditional is really the correct implementation of
> kvm_cpu_accept_dm_intr(vcpu).  It all makes sense:
>
> - we can accept an interrupt from userspace if there is a place
>   to stash it (and, for irqchip split, ExtINTs are not masked).
>   Interrupts from userspace _can_ be accepted even if right now
>   EFLAGS.IF=0.

Hello, Paolo

If userspace does KVM_INTERRUPT, vcpu->arch.interrupt.injected is
set immediately, and in inject_pending_event(), we have

        else if (!vcpu->arch.exception.pending) {
                if (vcpu->arch.nmi_injected) {
                        kvm_x86_ops.set_nmi(vcpu);
                        can_inject = false;
                } else if (vcpu->arch.interrupt.injected) {
                        kvm_x86_ops.set_irq(vcpu);
                        can_inject = false;
                }
        }

I'm curious about that can the kvm_x86_ops.set_irq() here be possible
to queue the irq with EFLAGS.IF=0? If not, which code prevents it?

I'm asking about this because I just noticed that interrupt can
be queued when exception pending, and this patch relaxed it even
more.

Note: interrupt can NOT be queued when exception pending
until 664f8e26b00c7 ("KVM: X86: Fix loss of exception which
has not yet been injected") which I think is dangerous.

Thanks
Lai

>
> - in order to tell userspace we will inject its interrupt ("IRQ
>   window open" i.e. kvm_vcpu_ready_for_interrupt_injection), both
>   KVM and the vCPU need to be ready to accept the interrupt.
>
> ... and this is what the patch implements.
>
> Reported-by: David Woodhouse <dwmw@amazon.co.uk>
> Analyzed-by: David Woodhouse <dwmw@amazon.co.uk>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/irq.c              |  2 +-
>  arch/x86/kvm/x86.c              | 17 +++++++----------
>  3 files changed, 9 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d44858b69353..ddaf3e01a854 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1655,6 +1655,7 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
>  int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
>  int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v);
>  int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
> +int kvm_cpu_has_extint(struct kvm_vcpu *v);
>  int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
>  int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
>  void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
> diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
> index e2d49a506e7f..fa01f07e449e 100644
> --- a/arch/x86/kvm/irq.c
> +++ b/arch/x86/kvm/irq.c
> @@ -40,7 +40,7 @@ static int pending_userspace_extint(struct kvm_vcpu *v)
>   * check if there is pending interrupt from
>   * non-APIC source without intack.
>   */
> -static int kvm_cpu_has_extint(struct kvm_vcpu *v)
> +int kvm_cpu_has_extint(struct kvm_vcpu *v)
>  {
>         /*
>          * FIXME: interrupt.injected represents an interrupt that it's
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 447edc0d1d5a..54124b6211df 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4051,21 +4051,22 @@ static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
>
>  static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
>  {
> -       return (!lapic_in_kernel(vcpu) ||
> -               kvm_apic_accept_pic_intr(vcpu));
> +       /*
> +        * We can accept userspace's request for interrupt injection
> +        * as long as we have a place to store the interrupt number.
> +        * The actual injection will happen when the CPU is able to
> +        * deliver the interrupt.
> +        */
> +       if (kvm_cpu_has_extint(vcpu))
> +               return false;
> +
> +       /* Acknowledging ExtINT does not happen if LINT0 is masked.  */
> +       return !(lapic_in_kernel(vcpu) && !kvm_apic_accept_pic_intr(vcpu));
>  }
>
> -/*
> - * if userspace requested an interrupt window, check that the
> - * interrupt window is open.
> - *
> - * No need to exit to userspace if we already have an interrupt queued.
> - */
>  static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
>  {
>         return kvm_arch_interrupt_allowed(vcpu) &&
> -               !kvm_cpu_has_interrupt(vcpu) &&
> -               !kvm_event_needs_reinjection(vcpu) &&
>                 kvm_cpu_accept_dm_intr(vcpu);
>  }
>
> --
> 2.28.0
>
