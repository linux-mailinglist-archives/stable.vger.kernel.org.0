Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8221A2277
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 15:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgDHNCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 09:02:05 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49787 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727896AbgDHNCF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 09:02:05 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jMALA-0006b0-1S; Wed, 08 Apr 2020 15:02:00 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 077EB10069D; Wed,  8 Apr 2020 15:01:58 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Vivek Goyal <vgoyal@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
In-Reply-To: <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com>
References: <20200407172140.GB64635@redhat.com> <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net> <87eeszjbe6.fsf@nanos.tec.linutronix.de> <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com> <874ktukhku.fsf@nanos.tec.linutronix.de> <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com>
Date:   Wed, 08 Apr 2020 15:01:58 +0200
Message-ID: <87pncib06x.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:
> On 08/04/20 01:21, Thomas Gleixner wrote:
>>>> No. Async PF is not a real exception. It has interrupt semantics and it
>>>> can only be injected when the guest has interrupts enabled. It's bad
>>>> design.
>>>
>>> Page-ready async PF has interrupt semantics.
>>>
>>> Page-not-present async PF however does not have interrupt semantics, it
>>> has to be injected immediately or not at all (falling back to host page
>>> fault in the latter case).
>> 
>> If interrupts are disabled in the guest then it is NOT injected and the
>> guest is suspended. So it HAS interrupt semantics. Conditional ones,
>> i.e. if interrupts are disabled, bail, if not then inject it.
>
> Interrupts can be delayed by TPR or STI/MOV SS interrupt window, async
> page faults cannot (again, not the page-ready kind).

Can we pretty please stop using the term async page fault? It's just
wrong and causes more confusion than anything else.

What this does is really what I called Opportunistic Make Guest Do Other
Stuff. And it has neither true exception nor true interrupt semantics.

It's a software event which is injected into the guest to let the guest
do something else than waiting for the actual #PF cause to be
resolved. It's part of a software protocol between host and guest.

And it comes with restrictions:

    The Do Other Stuff event can only be delivered when guest IF=1.

    If guest IF=0 then the host has to suspend the guest until the
    situation is resolved.

    The 'Situation resolved' event must also wait for a guest IF=1 slot.

> Page-not-present async page faults are almost a perfect match for the
> hardware use of #VE (and it might even be possible to let the
> processor deliver the exceptions).  There are other advantages:
>
> - the only real problem with using #PF (with or without
> KVM_ASYNC_PF_SEND_ALWAYS) seems to be the NMI reentrancy issue, which
> would not be there for #VE.
>
> - #VE are combined the right way with other exceptions (the
> benign/contributory/pagefault stuff)
>
> - adjusting KVM and Linux to use #VE instead of #PF would be less than
> 100 lines of code.

If you just want to solve Viveks problem, then its good enough. I.e. the
file truncation turns the EPT entries into #VE convertible entries and
the guest #VE handler can figure it out. This one can be injected
directly by the hardware, i.e. you don't need a VMEXIT.

If you want the opportunistic do other stuff mechanism, then #VE has
exactly the same problems as the existing async "PF". It's not magicaly
making that go away.

One possible solution might be to make all recoverable EPT entries
convertible and let the HW inject #VE for those.

So the #VE handler in the guest would have to do:

       if (!recoverable()) {
       		if (user_mode)
                	send_signal();
                else if (!fixup_exception())
                	die_hard();
                goto done;  
       }                 

       store_ve_info_in_pv_page();

       if (!user_mode(regs) || !preemptible()) {
       		hypercall_resolve_ept(can_continue = false);
       } else {
                init_completion();
       		hypercall_resolve_ept(can_continue = true);
                wait_for_completion();
       }

or something like that.

The hypercall to resolve the EPT fail on the host acts on the
can_continue argument.

If false, it suspends the guest vCPU and only returns when done.

If true it kicks the resolve process and returns to the guest which
suspends the task and tries to do something else.

The wakeup side needs to be a regular interrupt and cannot go through
#VE.

Thanks,

        tglx
