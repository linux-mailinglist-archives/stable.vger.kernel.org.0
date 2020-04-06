Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4AE1A0025
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 23:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgDFVci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 17:32:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45743 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgDFVch (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 17:32:37 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jLZM7-0001C1-U3; Mon, 06 Apr 2020 23:32:32 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 5FC34100C47; Mon,  6 Apr 2020 23:32:31 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
In-Reply-To: <20200406190951.GA19259@redhat.com>
References: <87ftek9ngq.fsf@nanos.tec.linutronix.de> <CALCETrVsc-t=tDRPbCg5dWHDY0NFv2zjz12ahD-vnGPn8T+RXA@mail.gmail.com> <87a74s9ehb.fsf@nanos.tec.linutronix.de> <87wo7v8g4j.fsf@nanos.tec.linutronix.de> <877dzu8178.fsf@nanos.tec.linutronix.de> <37440ade-1657-648b-bf72-2b8ca4ac21ce@redhat.com> <871rq199oz.fsf@nanos.tec.linutronix.de> <CALCETrUHwd8pNr_ZdFqY8vMjJeMdNyw2C+FL6uOUM98SEE9rNQ@mail.gmail.com> <87d09l73ip.fsf@nanos.tec.linutronix.de> <20200309202215.GM12561@hirez.programming.kicks-ass.net> <20200406190951.GA19259@redhat.com>
Date:   Mon, 06 Apr 2020 23:32:31 +0200
Message-ID: <87wo6sjo5s.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:
> On Mon, Mar 09, 2020 at 09:22:15PM +0100, Peter Zijlstra wrote:
>> On Mon, Mar 09, 2020 at 08:05:18PM +0100, Thomas Gleixner wrote:
>> > Andy Lutomirski <luto@kernel.org> writes:
>> 
>> > > I'm okay with the save/restore dance, I guess.  It's just yet more
>> > > entry crud to deal with architecture nastiness, except that this
>> > > nastiness is 100% software and isn't Intel/AMD's fault.
>> > 
>> > And we can do it in C and don't have to fiddle with it in the ASM
>> > maze.
>> 
>> Right; I'd still love to kill KVM_ASYNC_PF_SEND_ALWAYS though, even if
>> we do the save/restore in do_nmi(). That is some wild brain melt. Also,
>> AFAIK none of the distros are actually shipping a PREEMPT=y kernel
>> anyway, so killing it shouldn't matter much.
>
> It will be nice if we can retain KVM_ASYNC_PF_SEND_ALWAYS. I have another
> use case outside CONFIG_PREEMPT.
>
> I am trying to extend async pf interface to also report page fault errors
> to the guest.
>
> https://lore.kernel.org/kvm/20200331194011.24834-1-vgoyal@redhat.com/
>
> Right now async page fault interface assumes that host will always be
> able to successfully resolve the page fault and sooner or later PAGE_READY
> event will be sent to guest. And there is no mechnaism to report the
> errors back to guest.
>
> I am trying to add enhance virtiofs to directly map host page cache in guest.
>
> https://lore.kernel.org/linux-fsdevel/20200304165845.3081-1-vgoyal@redhat.com/
>
> There it is possible that a file page on host is mapped in guest and file
> got truncated and page is not there anymore. Guest tries to access it,
> and it generates async page fault. On host we will get -EFAULT and I 
> need to propagate it back to guest so that guest can either send SIGBUS
> to process which caused this. Or if kernel was trying to do memcpy(),
> then be able to use execpetion table error handling and be able to
> return with error.  (memcpy_mcflush()).
>
> For the second case to work, I will need async pf events to come in
> even if guest is in kernel and CONFIG_PREEMPT=n.

What?

> So it would be nice if we can keep KVM_ASYNC_PF_SEND_ALWAYS around.

No. If you want this stuff to be actually useful and correct, then
please redesign it from scratch w/o abusing #PF. It want's to be a
separate vector and then the pagefault resulting from your example above
becomes a real #PF without any bells and whistels.

Thanks,

        tglx


