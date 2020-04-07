Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D481F1A16AA
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 22:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgDGUUl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 7 Apr 2020 16:20:41 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48531 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgDGUUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 16:20:41 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jLui2-0004ak-1Y; Tue, 07 Apr 2020 22:20:34 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 595CA101273; Tue,  7 Apr 2020 22:20:33 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Andy Lutomirski <luto@amacapital.net>,
        Vivek Goyal <vgoyal@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
In-Reply-To: <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net>
References: <20200407172140.GB64635@redhat.com> <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net>
Date:   Tue, 07 Apr 2020 22:20:33 +0200
Message-ID: <87eeszjbe6.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:
>> On Apr 7, 2020, at 10:21 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> Whether interrupts are enabled or not check only happens before we decide
>> if async pf protocol should be followed or not. Once we decide to
>> send PAGE_NOT_PRESENT, later notification PAGE_READY does not check
>> if interrupts are enabled or not. And it kind of makes sense otherwise
>> guest process will wait infinitely to receive PAGE_READY.
>> 
>> I modified the code a bit to disable interrupt and wait 10 seconds (after
>> getting PAGE_NOT_PRESENT message). And I noticed that error async pf
>> got delivered after 10 seconds after enabling interrupts. So error
>> async pf was not lost because interrupts were disabled.

Async PF is not the same as a real #PF. It just hijacked the #PF vector
because someone thought this is a brilliant idea.

>> Havind said that, I thought disabling interrupts does not mask exceptions.
>> So page fault exception should have been delivered even with interrupts
>> disabled. Is that correct? May be there was no vm exit/entry during
>> those 10 seconds and that's why.

No. Async PF is not a real exception. It has interrupt semantics and it
can only be injected when the guest has interrupts enabled. It's bad
design.

> My point is that the entire async pf is nonsense. There are two types of events right now:
>
> “Page not ready”: normally this isn’t even visible to the guest — the
> guest just waits. With async pf, the idea is to try to tell the guest
> that a particular instruction would block and the guest should do
> something else instead. Sending a normal exception is a poor design,
> though: the guest may not expect this instruction to cause an
> exception. I think KVM should try to deliver an *interrupt* and, if it
> can’t, then just block the guest.

That's pretty much what it does, just that it runs this through #PF and
has the checks for interrupts disabled - i.e can't right now' around
that. If it can't then KVM schedules the guest out until the situation
has been resolved.

> “Page ready”: this is a regular asynchronous notification just like,
> say, a virtio completion. It should be an ordinary interrupt.  Some in
> memory data structure should indicate which pages are ready.
>
> “Page is malfunctioning” is tricky because you *must* deliver the
> event. x86’s #MC is not exactly a masterpiece, but it does kind of
> work.

Nooooo. This does not need #MC at all. Don't even think about it.

The point is that the access to such a page is either happening in user
space or in kernel space with a proper exception table fixup.

That means a real #PF is perfectly fine. That can be injected any time
and does not have the interrupt semantics of async PF.

So now lets assume we distangled async PF from #PF and made it a regular
interrupt, then the following situation still needs to be dealt with:

   guest -> access faults

host -> injects async fault

   guest -> handles and blocks the task

host figures out that the page does not exist anymore and now needs to
fixup the situation.

host -> injects async wakeup

   guest -> returns from aysnc PF interrupt and retries the instruction
            which faults again.

host -> knows by now that this is a real fault and injects a proper #PF

   guest -> #PF runs and either sends signal to user space or runs
            the exception table fixup for a kernel fault.

Thanks,

        tglx




