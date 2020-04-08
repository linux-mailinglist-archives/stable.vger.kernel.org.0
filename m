Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713291A1E94
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 12:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbgDHKMN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 8 Apr 2020 06:12:13 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49398 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgDHKMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 06:12:13 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jM7gj-0004in-9o; Wed, 08 Apr 2020 12:12:05 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id B495C10069D; Wed,  8 Apr 2020 12:12:04 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
In-Reply-To: <F2BD5266-A9E5-41C8-AC64-CC33EB401B37@amacapital.net>
References: <877dyqkj3h.fsf@nanos.tec.linutronix.de> <F2BD5266-A9E5-41C8-AC64-CC33EB401B37@amacapital.net>
Date:   Wed, 08 Apr 2020 12:12:04 +0200
Message-ID: <87v9mab823.fsf@nanos.tec.linutronix.de>
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
>> On Apr 7, 2020, at 3:48 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>   Inject #MC
>
> No, not what I meant. Host has two sane choices here IMO:
>
> 1. Tell the guest that the page is gone as part of the wakeup. No #PF or #MC.
>
> 2. Tell guest that it’s resolved and inject #MC when the guest
> retries.  The #MC is a real fault, RIP points to the right place, etc.

Ok, that makes sense.

>>> 1. Access to bad memory results in an async-page-not-present, except
>>> that, it’s not deliverable, the guest is killed.
>> 
>> That's incorrect. The proper reaction is a real #PF. Simply because this
>> is part of the contract of sharing some file backed stuff between host
>> and guest in a well defined "virtio" scenario and not a random access to
>> memory which might be there or not.
>
> The problem is that the host doesn’t know when #PF is safe. It’s sort
> of the same problem that async pf has now.  The guest kernel could
> access the problematic page in the middle of an NMI, under
> pagefault_disable(), etc — getting #PF as a result of CPL0 access to a
> page with a valid guest PTE is simply not part of the x86
> architecture.

Fair enough. 

> Replace copy_to_user() with some access to a gup-ed mapping with no
> extable handler and it doesn’t look so good any more.

In this case the guest needs to die.

> Of course, the guest will oops if this happens, but the guest needs to
> be able to oops cleanly. #PF is too fragile for this because it’s not
> IST, and #PF is the wrong thing anyway — #PF is all about
> guest-virtual-to-guest-physical mappings.  Heck, what would CR2 be?
> The host might not even know the guest virtual address.

It knows, but I can see your point.

>>> 2. Access to bad memory results in #MC.  Sure, #MC is a turd, but it’s
>>> an *architectural* turd. By all means, have a nice simple PV mechanism
>>> to tell the #MC code exactly what went wrong, but keep the overall
>>> flow the same as in the native case.
>> 
>> It's a completely different flow as you evaluate PV turd instead of
>> analysing the MCE banks and the other error reporting facilities.
>
> I’m fine with the flow being different. do_machine_check() could have
> entirely different logic to decide the error in PV.  But I think we
> should reuse the overall flow: kernel gets #MC with RIP pointing to
> the offending instruction. If there’s an extable entry that can handle
> memory failure, handle it. If it’s a user access, handle it.  If it’s
> an unrecoverable error because it was a non-extable kernel access,
> oops or panic.
>
> The actual PV part could be extremely simple: the host just needs to
> tell the guest “this #MC is due to memory failure at this guest
> physical address”.  No banks, no DIMM slot, no rendezvous crap (LMCE),
> no other nonsense.  It would be nifty if the host also told the guest
> what the guest virtual address was if the host knows it.

It does. The EPT violations store:

  - guest-linear address
  - guest-physical address

That's also part of the #VE exception to which Paolo was referring.

Thanks,

        tglx
