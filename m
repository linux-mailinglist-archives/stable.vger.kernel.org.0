Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 449631A185A
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 00:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDGWtE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 7 Apr 2020 18:49:04 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48633 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgDGWtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 18:49:04 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jLx1W-0006aF-UM; Wed, 08 Apr 2020 00:48:52 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 4BE3D10069D; Wed,  8 Apr 2020 00:48:50 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
In-Reply-To: <B85606B0-71B5-4B7D-A892-293CB9C1B434@amacapital.net>
References: <87eeszjbe6.fsf@nanos.tec.linutronix.de> <B85606B0-71B5-4B7D-A892-293CB9C1B434@amacapital.net>
Date:   Wed, 08 Apr 2020 00:48:50 +0200
Message-ID: <877dyqkj3h.fsf@nanos.tec.linutronix.de>
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
>> On Apr 7, 2020, at 1:20 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> ﻿Andy Lutomirski <luto@amacapital.net> writes:
>>> “Page is malfunctioning” is tricky because you *must* deliver the
>>> event. x86’s #MC is not exactly a masterpiece, but it does kind of
>>> work.
>> 
>> Nooooo. This does not need #MC at all. Don't even think about it.
>
> Yessssssssssss.  Please do think about it. :)

I stared too much into that code recently that even thinking about it
hurts. :)

>> The point is that the access to such a page is either happening in user
>> space or in kernel space with a proper exception table fixup.
>> 
>> That means a real #PF is perfectly fine. That can be injected any time
>> and does not have the interrupt semantics of async PF.
>
> The hypervisor has no way to distinguish between
> MOV-and-has-valid-stack-and-extable-entry and
> MOV-definitely-can’t-fault-here.  Or, for that matter,
> MOV-in-do_page_fault()-will-recurve-if-it-faults.

The mechanism which Vivek wants to support has a well defined usage
scenario, i.e. either user space or kernel-valid-stack+extable-entry.

So why do you want to route that through #MC? 

>> So now lets assume we distangled async PF from #PF and made it a regular
>> interrupt, then the following situation still needs to be dealt with:
>> 
>>   guest -> access faults
>> 
>> host -> injects async fault
>> 
>>   guest -> handles and blocks the task
>> 
>> host figures out that the page does not exist anymore and now needs to
>> fixup the situation.
>> 
>> host -> injects async wakeup
>> 
>>   guest -> returns from aysnc PF interrupt and retries the instruction
>>            which faults again.
>> 
>> host -> knows by now that this is a real fault and injects a proper #PF
>> 
>>   guest -> #PF runs and either sends signal to user space or runs
>>            the exception table fixup for a kernel fault.
>
> Or guest blows up because the fault could not be recovered using #PF.

Not for the use case at hand. And for that you really want to use
regular #PF.

The scenario I showed above is perfectly legit:

   guest:
        copy_to_user()          <- Has extable
           -> FAULT

host:
   Oh, page is not there, give me some time to figure it out.

   inject async fault

   guest:
        handles async fault interrupt, enables interrupts, blocks

host:
   Situation resolved, shared file was truncated. Tell guest
  
   Inject #MC

   guest:
        handles #MC completely out of context because the faulting
        task is scheduled out.

        Rumage through wait lists (how do you protect them?) and find
        the waiter.

        Schedule irq_work to actually mark the waiter as failed and wake
        it up.

Sorry, but that's not really an improvement. That's worse. 

> I can see two somewhat sane ways to make this work.
>
> 1. Access to bad memory results in an async-page-not-present, except
> that, it’s not deliverable, the guest is killed.

That's incorrect. The proper reaction is a real #PF. Simply because this
is part of the contract of sharing some file backed stuff between host
and guest in a well defined "virtio" scenario and not a random access to
memory which might be there or not.

Look at it from the point where async whatever does not exist at all:

   guest:
        copy_to_user()          <- Has extable
           -> FAULT

host:
        suspend guest and resolve situation

        if (page swapped in)
           resume_guest();
        else
           inject_pf();

And this inject_pf() does not care whether it kills the guest or makes
it double/triple fault or whatever.

The 'tell the guest to do something else while host tries to sort it'
opportunistic thingy turns this into:

   guest:
        copy_to_user()          <- Has extable
           -> FAULT

host:
        tell guest to do something else, i.e. guest suspends task

        if (page swapped in)
           tell guest to resume suspended task
        else
           tell guest to resume suspended task

   guest resumes and faults again

host:
           inject_pf();

which is pretty much equivalent.

> 2. Access to bad memory results in #MC.  Sure, #MC is a turd, but it’s
> an *architectural* turd. By all means, have a nice simple PV mechanism
> to tell the #MC code exactly what went wrong, but keep the overall
> flow the same as in the native case.

It's a completely different flow as you evaluate PV turd instead of
analysing the MCE banks and the other error reporting facilities.

> I think I like #2 much better. It has another nice effect: a good
> implementation will serve as a way to exercise the #MC code without
> needing to muck with EINJ or with whatever magic Tony uses. The
> average kernel developer does not have access to a box with testable
> memory failure reporting.

Yes, because CPU dudes decided that documenting the testability
mechanisms is a bad thing. They surely exist and for Nehalem at least
the ECC error injection mechanism was documented and usable.

But to actually make soemthing useful you need to emulate the bank
interface on the hypervisor and expose the errors to the guest. The MCE
injection mechanism has some awful way to "emulate" MSR reads for
that. See mce_rdmsr(). *SHUDDER*

Thanks,

        tglx

