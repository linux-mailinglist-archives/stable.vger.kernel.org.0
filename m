Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AF235DD50
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 13:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345098AbhDMLDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 07:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345186AbhDMLDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 07:03:48 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B553C06175F;
        Tue, 13 Apr 2021 04:03:29 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id 7so12042322ilz.0;
        Tue, 13 Apr 2021 04:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SaQgaohvFRse8y7sF4qogtAi4k/YBL2bzDFsmdJBavY=;
        b=DGpGEmKGP9Wcnn+JS5iPztOqsliXtOJ6fLtlbkr3oUuvarZefDCbhdQMV9rWTlrds6
         wVHOwrYEI+99+2IGpmIWMLE1wpDIn2CXsqVN03ai7Hr0HO/V+oV8Q9L1lafgVFx2N1Nq
         Yjp6zRrZh67xGBCgJlAuBnb4BUQzEPlP/ztzsxfRhFa04D9JaACtsymqEWnej2UBjzn0
         SKzrmYaI1W+LGaLJvxWC2qOpEjrjJXQDccufw9sl37yZexj4AeNZ0gATKYofrkypsGKK
         N6xL1b4cyfjUWNGopXT6QwjwOkFswUYd1+8eU1ds8KBVb5U2RII2lYVxAvgYYGPh5wXA
         KuUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SaQgaohvFRse8y7sF4qogtAi4k/YBL2bzDFsmdJBavY=;
        b=CEMLWsyACSBXDcgdZZsHFI7XkakS9MqfbjgtEKcdTOCh4C+b9za5/Pzx276XdOnSvW
         oaP+0a0wNsXs8x6GFnmPrMyXcaHlI+Gg0cU170qAyEbKMnpIajoEdiB9aZylVQnk/O/4
         6shl4mH891G5lSRKjSjbC12wtWGW99Kb3eG7aNUOdImwt916vqOd4I8eCVgCxwfUP2Uh
         c2apmar3Qx1uTks5+VLZgEIIza27vfdbvVaTmZb9kcZgqbCmUQE/6INEsOJMsHTaaqkI
         1Foe2VoE/Nu+aldYGdLS8JnxlpXU9dNZpZnmYrwlZLSvelCQmB7yeeu8NdCZ6cmsVXGZ
         Sk1Q==
X-Gm-Message-State: AOAM531vF79Cl93KrC/ZGiDzzMirL0GzB58o7yGzVG+Ogx5qqTsJsgf2
        7rg/l8PpZNeYnHkcxtPBXwlhu/R+JPMJQdrhbuI=
X-Google-Smtp-Source: ABdhPJx1z9NLxTOUwTs565vCjlORC+kL0RY4GMGpIY2nljUMLDWzexizGFY+fWG/FlfOwOVgOUTLKxemLbute+nsrDk=
X-Received: by 2002:a92:ac0f:: with SMTP id r15mr27223305ilh.52.1618311808723;
 Tue, 13 Apr 2021 04:03:28 -0700 (PDT)
MIME-Version: 1.0
References: <20201127112114.3219360-1-pbonzini@redhat.com> <20201127112114.3219360-3-pbonzini@redhat.com>
 <CAJhGHyCdqgtvK98_KieG-8MUfg1Jghd+H99q+FkgL0ZuqnvuAw@mail.gmail.com> <YHS/BxMiO6I1VOEY@google.com>
In-Reply-To: <YHS/BxMiO6I1VOEY@google.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Tue, 13 Apr 2021 19:03:17 +0800
Message-ID: <CAJhGHyAcnwkCfTcnxXcgAHnF=wPbH2EDp7H+e74ce+oNOWJ=_Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86: Fix split-irqchip vs interrupt injection
 window request
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Filippo Sironi <sironi@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "v4.7+" <stable@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 13, 2021 at 5:43 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 09, 2021, Lai Jiangshan wrote:
> > On Fri, Nov 27, 2020 at 7:26 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > >
> > > kvm_cpu_accept_dm_intr and kvm_vcpu_ready_for_interrupt_injection are
> > > a hodge-podge of conditions, hacked together to get something that
> > > more or less works.  But what is actually needed is much simpler;
> > > in both cases the fundamental question is, do we have a place to stash
> > > an interrupt if userspace does KVM_INTERRUPT?
> > >
> > > In userspace irqchip mode, that is !vcpu->arch.interrupt.injected.
> > > Currently kvm_event_needs_reinjection(vcpu) covers it, but it is
> > > unnecessarily restrictive.
> > >
> > > In split irqchip mode it's a bit more complicated, we need to check
> > > kvm_apic_accept_pic_intr(vcpu) (the IRQ window exit is basically an INTACK
> > > cycle and thus requires ExtINTs not to be masked) as well as
> > > !pending_userspace_extint(vcpu).  However, there is no need to
> > > check kvm_event_needs_reinjection(vcpu), since split irqchip keeps
> > > pending ExtINT state separate from event injection state, and checking
> > > kvm_cpu_has_interrupt(vcpu) is wrong too since ExtINT has higher
> > > priority than APIC interrupts.  In fact the latter fixes a bug:
> > > when userspace requests an IRQ window vmexit, an interrupt in the
> > > local APIC can cause kvm_cpu_has_interrupt() to be true and thus
> > > kvm_vcpu_ready_for_interrupt_injection() to return false.  When this
> > > happens, vcpu_run does not exit to userspace but the interrupt window
> > > vmexits keep occurring.  The VM loops without any hope of making progress.
> > >
> > > Once we try to fix these with something like
> > >
> > >      return kvm_arch_interrupt_allowed(vcpu) &&
> > > -        !kvm_cpu_has_interrupt(vcpu) &&
> > > -        !kvm_event_needs_reinjection(vcpu) &&
> > > -        kvm_cpu_accept_dm_intr(vcpu);
> > > +        (!lapic_in_kernel(vcpu)
> > > +         ? !vcpu->arch.interrupt.injected
> > > +         : (kvm_apic_accept_pic_intr(vcpu)
> > > +            && !pending_userspace_extint(v)));
> > >
> > > we realize two things.  First, thanks to the previous patch the complex
> > > conditional can reuse !kvm_cpu_has_extint(vcpu).  Second, the interrupt
> > > window request in vcpu_enter_guest()
> > >
> > >         bool req_int_win =
> > >                 dm_request_for_irq_injection(vcpu) &&
> > >                 kvm_cpu_accept_dm_intr(vcpu);
> > >
> > > should be kept in sync with kvm_vcpu_ready_for_interrupt_injection():
> > > it is unnecessary to ask the processor for an interrupt window
> > > if we would not be able to return to userspace.  Therefore, the
> > > complex conditional is really the correct implementation of
> > > kvm_cpu_accept_dm_intr(vcpu).  It all makes sense:
> > >
> > > - we can accept an interrupt from userspace if there is a place
> > >   to stash it (and, for irqchip split, ExtINTs are not masked).
> > >   Interrupts from userspace _can_ be accepted even if right now
> > >   EFLAGS.IF=0.
> >
> > Hello, Paolo
> >
> > If userspace does KVM_INTERRUPT, vcpu->arch.interrupt.injected is
> > set immediately, and in inject_pending_event(), we have
> >
> >         else if (!vcpu->arch.exception.pending) {
> >                 if (vcpu->arch.nmi_injected) {
> >                         kvm_x86_ops.set_nmi(vcpu);
> >                         can_inject = false;
> >                 } else if (vcpu->arch.interrupt.injected) {
> >                         kvm_x86_ops.set_irq(vcpu);
> >                         can_inject = false;
> >                 }
> >         }
> >
> > I'm curious about that can the kvm_x86_ops.set_irq() here be possible
> > to queue the irq with EFLAGS.IF=0? If not, which code prevents it?
>
> The interrupt is only directly injected if the local APIC is _not_ in-kernel.
> If userspace is managing the local APIC, my understanding is that userspace is
> also responsible for honoring EFLAGS.IF, though KVM aids userspace by updating
> vcpu->run->ready_for_interrupt_injection when exiting to userspace.  When
> userspace is modeling the local APIC, that resolves to
> kvm_vcpu_ready_for_interrupt_injection():
>
>         return kvm_arch_interrupt_allowed(vcpu) &&
>                 kvm_cpu_accept_dm_intr(vcpu);
>
> where kvm_arch_interrupt_allowed() checks EFLAGS.IF (and an edge case related to
> nested virtualization).  KVM also captures EFLAGS.IF in vcpu->run->if_flag.
> For whatever reason, QEMU checks both vcpu->run flags before injecting an IRQ,
> maybe to handle a case where QEMU itself clears EFLAGS.IF?

If userspace is managing the local APIC, the user VMM would insert IRQ
when kvm_run->ready_for_interrupt_injection=1 since this flags
implied EFLAGS.IF before this patch (for example gVisor checks this only
instead of kvm_run->if_flag).  This patch claims that it has a place to
stash the IRQ when EFLAGS.IF=0, but inject_pending_event() seams to ignore
EFLAGS.IF and queues the IRQ to the guest directly in the first branch
of using "kvm_x86_ops.set_irq(vcpu)".

I have encountered a problem but failed to exactly dissect it with
some internal code involved.

It is somewhat possible that it has resulted from Li Wanpeng's patch
(I replied to this patch because this patch relaxes the condition even
more without reasons for how it suppresses/stashes IRQ to the guest).

When a guest APP userspace hits an exception and vmexit and returns to
the user VMM (gVisor) in conditions combined, and the user VMM wants to
queue an IRQ to it: It is now EFLAGS.IF=1 and ready_for_interrupt_injection=1
and user VMM happily queues the IRQ. In inject_pending_event(), the IRQ is
lower priority and the earlier exception is queued to the guest first.  But
the IRQ can't be continuously suppressed and it is queued at the beginning
of the exception handler where EFLAGS.IF=0.
(Before Li Wanpeng's patch, ready_for_interrupt_injection=0, since
there is an exception pending)

All above is just my guess.  But I want to know more clues.
And this patch says:

 : we can accept an interrupt from userspace if there is a place
 : to stash it (and, for irqchip split, ExtINTs are not masked).
 : Interrupts from userspace _can_ be accepted even if right now
 : EFLAGS.IF=0.

So it might help me for analyzing if I knew how this
behavior is achieved since inject_pending_event() doesn't
check EFLAGS.IF=0 for the first using "kvm_x86_ops.set_irq(vcpu)".

Thanks

Lai.

>
> > I'm asking about this because I just noticed that interrupt can
> > be queued when exception pending, and this patch relaxed it even
> > more.
> >
> > Note: interrupt can NOT be queued when exception pending
> > until 664f8e26b00c7 ("KVM: X86: Fix loss of exception which
> > has not yet been injected") which I think is dangerous.
