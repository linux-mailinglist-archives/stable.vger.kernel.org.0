Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1671A2759
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 18:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbgDHQlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 12:41:52 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50183 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgDHQlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 12:41:52 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jMDlp-0001ln-OL; Wed, 08 Apr 2020 18:41:45 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id E278510069D; Wed,  8 Apr 2020 18:41:44 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
In-Reply-To: <20200408153824.GO20730@hirez.programming.kicks-ass.net>
References: <20200407172140.GB64635@redhat.com> <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net> <87eeszjbe6.fsf@nanos.tec.linutronix.de> <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com> <874ktukhku.fsf@nanos.tec.linutronix.de> <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com> <87pncib06x.fsf@nanos.tec.linutronix.de> <20200408153824.GO20730@hirez.programming.kicks-ass.net>
Date:   Wed, 08 Apr 2020 18:41:44 +0200
Message-ID: <87h7xuaq0n.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
> On Wed, Apr 08, 2020 at 03:01:58PM +0200, Thomas Gleixner wrote:
>> And it comes with restrictions:
>> 
>>     The Do Other Stuff event can only be delivered when guest IF=1.
>> 
>>     If guest IF=0 then the host has to suspend the guest until the
>>     situation is resolved.
>> 
>>     The 'Situation resolved' event must also wait for a guest IF=1 slot.
>
> Moo, can we pretty please already kill that ALWAYS and IF nonsense? That
> results in that terrifyingly crap HLT loop. That needs to die with
> extreme prejudice.
>
> So the host only inject these OMFG_DOS things when the guest is in
> luserspace -- which it can see in the VMCS state IIRC. And then using
> #VE for the make-it-go signal is far preferred over the currentl #PF
> abuse.

Yes, but this requires software based injection.

>> If you just want to solve Viveks problem, then its good enough. I.e. the
>> file truncation turns the EPT entries into #VE convertible entries and
>> the guest #VE handler can figure it out. This one can be injected
>> directly by the hardware, i.e. you don't need a VMEXIT.
>
> That sounds like something that doesn't actually need the whole
> 'async'/do-something-else-for-a-while crap, right? It's a #PF trap from
> kernel space where we need to report fail.

Fail or fixup via extable.

>> If you want the opportunistic do other stuff mechanism, then #VE has
>> exactly the same problems as the existing async "PF". It's not magicaly
>> making that go away.
>
> We need to somehow have the guest teach the host how to tell if it can
> inject that OMFG_DOS thing or not. Injecting it only to then instantly
> exit again is stupid and expensive.

Not if the injection is actually done by the hardware. Then the guest
handles #VE and tells the host what to do.

> Clearly we don't want to expose preempt_count and make that ABI, but is
> there some way we can push a snippet of code to the host that instructs
> the host how to determine if it can sleep or not? I realize that pushing
> actual x86 .text is a giant security problem, so perhaps a snipped of
> BPF that the host can verify, which it can run on the guest image ?

*SHUDDER*

> Make it a hard error (guest cpu dies) to inject the OMFG_DOS signal on a
> context that cannot put the task to sleep.

With the hardware based #VE and a hypercall which tells the host how to
handle the EPT fixup (suspend the vcpu or let it continue and do the
completion later) you don't have to play any games on the host. If the
guest tells the host the wrong thing, then the guest will have to mop up
the pieces.

Thanks,

        tglx
