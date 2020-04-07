Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 710631A188E
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 01:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgDGXVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 19:21:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48654 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgDGXVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 19:21:43 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jLxXG-0006vE-7B; Wed, 08 Apr 2020 01:21:38 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id B01FF10069D; Wed,  8 Apr 2020 01:21:37 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Vivek Goyal <vgoyal@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
In-Reply-To: <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com>
References: <20200407172140.GB64635@redhat.com> <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net> <87eeszjbe6.fsf@nanos.tec.linutronix.de> <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com>
Date:   Wed, 08 Apr 2020 01:21:37 +0200
Message-ID: <874ktukhku.fsf@nanos.tec.linutronix.de>
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

> On 07/04/20 22:20, Thomas Gleixner wrote:
>>>> Havind said that, I thought disabling interrupts does not mask exceptions.
>>>> So page fault exception should have been delivered even with interrupts
>>>> disabled. Is that correct? May be there was no vm exit/entry during
>>>> those 10 seconds and that's why.
>> No. Async PF is not a real exception. It has interrupt semantics and it
>> can only be injected when the guest has interrupts enabled. It's bad
>> design.
>
> Page-ready async PF has interrupt semantics.
>
> Page-not-present async PF however does not have interrupt semantics, it
> has to be injected immediately or not at all (falling back to host page
> fault in the latter case).

If interrupts are disabled in the guest then it is NOT injected and the
guest is suspended. So it HAS interrupt semantics. Conditional ones,
i.e. if interrupts are disabled, bail, if not then inject it.

But that does not make it an exception by any means.

It never should have been hooked to #PF in the first place and it never
should have been named that way. The functionality is to opportunisticly
tell the guest to do some other stuff.

So the proper name for this seperate interrupt vector would be:

   VECTOR_OMG_DOS - Opportunisticly Make Guest Do Other Stuff

and the counter part

   VECTOR_STOP_DOS - Stop Doing Other Stuff 

> So page-not-present async PF definitely needs to be an exception, this
> is independent of whether it can be injected when IF=0.

That wants to be a straight #PF. See my reply to Andy.

> Hypervisors do not have any reserved exception vector, and must use
> vectors up to 31, which is why I believe #PF was used in the first place
> (though that predates my involvement in KVM by a few years).

No. That was just bad taste or something worse. It has nothing to do
with exceptions, see above. Stop proliferating the confusion.

> These days, #VE would be a much better exception to use instead (and
> it also has a defined mechanism to avoid reentrancy).

#VE is not going to solve anything.

The idea of OMG_DOS is to (opportunisticly) avoid that the guest (and
perhaps host) sit idle waiting for I/O until the fault has been
resolved. That makes sense as there might be enough other stuff to do
which does not depend on that particular page. If not then fine, the
guest will go idle.

Thanks,

        tglx
