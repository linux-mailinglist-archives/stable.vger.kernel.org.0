Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3425835D2A8
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 23:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbhDLVoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 17:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240497AbhDLVoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 17:44:03 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B26C06175F
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 14:43:41 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id l76so10411556pga.6
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 14:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LTAUlRV+90mXaog4LE7DEsSgTnXw1ApT5g7eDZ+3hQQ=;
        b=EOQdsGxc+trZ9fBNqii1aYmL+oejnNTIpAmeJxEDRtdv4sfpgl7CUHgZDeu0bzilfo
         Ad1P6/PTP7qzpUVzhfxZkSse+TSPAK5HIfUeanowvW60r32lgP66yn+90YMmPzDHeS+Q
         gN0qv9EKIq2UrdKOuGWLEZInZ9IbXf3jXjeaq+okQNM70WNHO2oyNe40kGKx6q3fp3hj
         3nEDYeAVKe2W5jj8S48nyesHC432eKHVfm72/FI3OZh8IblL7iMO1ZqcghmMvMrLxV+M
         EfxoVNNr9U1B4spOlvqUCL9Pjj0WFo3+f2J+r4kojtqyQNEJbPGP7ywIk1aRVsG5zHyT
         i2yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LTAUlRV+90mXaog4LE7DEsSgTnXw1ApT5g7eDZ+3hQQ=;
        b=p+HD4EBiw4vRAWopaq7jZcb/msxQ6nBtHU3du/fzJvb4I+yxcWiAAoyL0qQyOYKU3d
         5nrp+ClGIYzR/IyCvrsL5qtufmkyK9rtrd9NW2+PyvQwtF3SaGmTNkYJ7bZlXepRkkY7
         ZejIXkGqDhEJImZ3m/mgJ82jJwGooMRLVaxV9c2izjIlx5Ba6NjppCPXjf6SDflEUFU7
         sDu9BOK/UyLqknoSUzAki8+3mjoH7ft5nZAl6Prq+82z6GDjQaXElcRIxVEZ9a0BdNJb
         14YVip+E1j3Xla2BMIUbghk1H4SpYwVqajQk/sZqW/XJzz9mOKbphclkx9FTY4kWhS7m
         sucw==
X-Gm-Message-State: AOAM530KdaU5DQul61V0knk4+zXf1HSojntmrTAFtLJBs4mNUSNo65X0
        /83H9udaJdliXi2OuU7oKoSgxw==
X-Google-Smtp-Source: ABdhPJzHRXu/pBnp+xlAC/tzDGNIdRDWyySF7tk5goKiPbjZXsGgZ8G7eIRRFRHas8vMljy5GHXXZQ==
X-Received: by 2002:a63:d50c:: with SMTP id c12mr11168928pgg.145.1618263820594;
        Mon, 12 Apr 2021 14:43:40 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 77sm12720008pgf.55.2021.04.12.14.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 14:43:39 -0700 (PDT)
Date:   Mon, 12 Apr 2021 21:43:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Filippo Sironi <sironi@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "v4.7+" <stable@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 2/2] KVM: x86: Fix split-irqchip vs interrupt injection
 window request
Message-ID: <YHS/BxMiO6I1VOEY@google.com>
References: <20201127112114.3219360-1-pbonzini@redhat.com>
 <20201127112114.3219360-3-pbonzini@redhat.com>
 <CAJhGHyCdqgtvK98_KieG-8MUfg1Jghd+H99q+FkgL0ZuqnvuAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyCdqgtvK98_KieG-8MUfg1Jghd+H99q+FkgL0ZuqnvuAw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021, Lai Jiangshan wrote:
> On Fri, Nov 27, 2020 at 7:26 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > kvm_cpu_accept_dm_intr and kvm_vcpu_ready_for_interrupt_injection are
> > a hodge-podge of conditions, hacked together to get something that
> > more or less works.  But what is actually needed is much simpler;
> > in both cases the fundamental question is, do we have a place to stash
> > an interrupt if userspace does KVM_INTERRUPT?
> >
> > In userspace irqchip mode, that is !vcpu->arch.interrupt.injected.
> > Currently kvm_event_needs_reinjection(vcpu) covers it, but it is
> > unnecessarily restrictive.
> >
> > In split irqchip mode it's a bit more complicated, we need to check
> > kvm_apic_accept_pic_intr(vcpu) (the IRQ window exit is basically an INTACK
> > cycle and thus requires ExtINTs not to be masked) as well as
> > !pending_userspace_extint(vcpu).  However, there is no need to
> > check kvm_event_needs_reinjection(vcpu), since split irqchip keeps
> > pending ExtINT state separate from event injection state, and checking
> > kvm_cpu_has_interrupt(vcpu) is wrong too since ExtINT has higher
> > priority than APIC interrupts.  In fact the latter fixes a bug:
> > when userspace requests an IRQ window vmexit, an interrupt in the
> > local APIC can cause kvm_cpu_has_interrupt() to be true and thus
> > kvm_vcpu_ready_for_interrupt_injection() to return false.  When this
> > happens, vcpu_run does not exit to userspace but the interrupt window
> > vmexits keep occurring.  The VM loops without any hope of making progress.
> >
> > Once we try to fix these with something like
> >
> >      return kvm_arch_interrupt_allowed(vcpu) &&
> > -        !kvm_cpu_has_interrupt(vcpu) &&
> > -        !kvm_event_needs_reinjection(vcpu) &&
> > -        kvm_cpu_accept_dm_intr(vcpu);
> > +        (!lapic_in_kernel(vcpu)
> > +         ? !vcpu->arch.interrupt.injected
> > +         : (kvm_apic_accept_pic_intr(vcpu)
> > +            && !pending_userspace_extint(v)));
> >
> > we realize two things.  First, thanks to the previous patch the complex
> > conditional can reuse !kvm_cpu_has_extint(vcpu).  Second, the interrupt
> > window request in vcpu_enter_guest()
> >
> >         bool req_int_win =
> >                 dm_request_for_irq_injection(vcpu) &&
> >                 kvm_cpu_accept_dm_intr(vcpu);
> >
> > should be kept in sync with kvm_vcpu_ready_for_interrupt_injection():
> > it is unnecessary to ask the processor for an interrupt window
> > if we would not be able to return to userspace.  Therefore, the
> > complex conditional is really the correct implementation of
> > kvm_cpu_accept_dm_intr(vcpu).  It all makes sense:
> >
> > - we can accept an interrupt from userspace if there is a place
> >   to stash it (and, for irqchip split, ExtINTs are not masked).
> >   Interrupts from userspace _can_ be accepted even if right now
> >   EFLAGS.IF=0.
> 
> Hello, Paolo
> 
> If userspace does KVM_INTERRUPT, vcpu->arch.interrupt.injected is
> set immediately, and in inject_pending_event(), we have
> 
>         else if (!vcpu->arch.exception.pending) {
>                 if (vcpu->arch.nmi_injected) {
>                         kvm_x86_ops.set_nmi(vcpu);
>                         can_inject = false;
>                 } else if (vcpu->arch.interrupt.injected) {
>                         kvm_x86_ops.set_irq(vcpu);
>                         can_inject = false;
>                 }
>         }
> 
> I'm curious about that can the kvm_x86_ops.set_irq() here be possible
> to queue the irq with EFLAGS.IF=0? If not, which code prevents it?

The interrupt is only directly injected if the local APIC is _not_ in-kernel.
If userspace is managing the local APIC, my understanding is that userspace is
also responsible for honoring EFLAGS.IF, though KVM aids userspace by updating
vcpu->run->ready_for_interrupt_injection when exiting to userspace.  When
userspace is modeling the local APIC, that resolves to
kvm_vcpu_ready_for_interrupt_injection():

	return kvm_arch_interrupt_allowed(vcpu) &&
		kvm_cpu_accept_dm_intr(vcpu);

where kvm_arch_interrupt_allowed() checks EFLAGS.IF (and an edge case related to
nested virtualization).  KVM also captures EFLAGS.IF in vcpu->run->if_flag.
For whatever reason, QEMU checks both vcpu->run flags before injecting an IRQ,
maybe to handle a case where QEMU itself clears EFLAGS.IF?
 
> I'm asking about this because I just noticed that interrupt can
> be queued when exception pending, and this patch relaxed it even
> more.
> 
> Note: interrupt can NOT be queued when exception pending
> until 664f8e26b00c7 ("KVM: X86: Fix loss of exception which
> has not yet been injected") which I think is dangerous.
