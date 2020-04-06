Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D03A19FF00
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 22:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgDFUZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 16:25:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38608 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgDFUZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 16:25:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xuOwKkylxNWAK5JsGTSzYpMwNioJNBL3cpLgcRJMmIk=; b=ysD9wHAaYXhY4cbstXONp2HSoW
        ZSVzDAAVy+rmG0HeJt4CI83tugugTQjr1ZpvMkO5a0H9iRDmQCB0tBMppX3vn+xkSA+f9r5y/4D+N
        XI/qoOaVGp0oAcDWow6rzk2Sv/6zuEdVdRg/OWiDaPzvKYMiJfazQjJ8y3wjDp//Pv0PvZPZ8GQWc
        4Kc//4QWnNUWrPTzzWJeLwf4Q4WWX6YKApc+oN83tSFVBvdUFGTCgBXFRax1iIqMlPrkn7EprdP0r
        5eDF59CRjuRtlq37yzNCNOJHYmVq0HOIgBLwIBhb0SYvsLUP/JlGaI/kMLJ2qtgoBapjoiDOOxWp9
        vr0XqWKw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jLYIu-0006Z3-Ut; Mon, 06 Apr 2020 20:25:09 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5F1C6983962; Mon,  6 Apr 2020 22:25:05 +0200 (CEST)
Date:   Mon, 6 Apr 2020 22:25:05 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Message-ID: <20200406202505.GO2452@worktop.programming.kicks-ass.net>
References: <CALCETrVsc-t=tDRPbCg5dWHDY0NFv2zjz12ahD-vnGPn8T+RXA@mail.gmail.com>
 <87a74s9ehb.fsf@nanos.tec.linutronix.de>
 <87wo7v8g4j.fsf@nanos.tec.linutronix.de>
 <877dzu8178.fsf@nanos.tec.linutronix.de>
 <37440ade-1657-648b-bf72-2b8ca4ac21ce@redhat.com>
 <871rq199oz.fsf@nanos.tec.linutronix.de>
 <CALCETrUHwd8pNr_ZdFqY8vMjJeMdNyw2C+FL6uOUM98SEE9rNQ@mail.gmail.com>
 <87d09l73ip.fsf@nanos.tec.linutronix.de>
 <20200309202215.GM12561@hirez.programming.kicks-ass.net>
 <20200406190951.GA19259@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406190951.GA19259@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 06, 2020 at 03:09:51PM -0400, Vivek Goyal wrote:
> On Mon, Mar 09, 2020 at 09:22:15PM +0100, Peter Zijlstra wrote:
> > On Mon, Mar 09, 2020 at 08:05:18PM +0100, Thomas Gleixner wrote:
> > > Andy Lutomirski <luto@kernel.org> writes:
> > 
> > > > I'm okay with the save/restore dance, I guess.  It's just yet more
> > > > entry crud to deal with architecture nastiness, except that this
> > > > nastiness is 100% software and isn't Intel/AMD's fault.
> > > 
> > > And we can do it in C and don't have to fiddle with it in the ASM
> > > maze.
> > 
> > Right; I'd still love to kill KVM_ASYNC_PF_SEND_ALWAYS though, even if
> > we do the save/restore in do_nmi(). That is some wild brain melt. Also,
> > AFAIK none of the distros are actually shipping a PREEMPT=y kernel
> > anyway, so killing it shouldn't matter much.
> 
> It will be nice if we can retain KVM_ASYNC_PF_SEND_ALWAYS. I have another
> use case outside CONFIG_PREEMPT.
> 
> I am trying to extend async pf interface to also report page fault errors
> to the guest.

Then please start over and design a sane ParaVirt Fault interface. The
current one is utter crap.
