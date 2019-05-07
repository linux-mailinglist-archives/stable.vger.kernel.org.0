Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95C3E16418
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 14:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfEGM5U convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 7 May 2019 08:57:20 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:20715 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726197AbfEGM5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 08:57:20 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-90--vy_klLVNSOvRBjrRdIVmQ-1; Tue, 07 May 2019 13:57:17 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue,
 7 May 2019 13:57:15 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 7 May 2019 13:57:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Peter Zijlstra' <peterz@infradead.org>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Linux List Kernel Mailing" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Andy Lutomirski" <luto@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Jiri Kosina" <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Juergen Gross <jgross@suse.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "Joerg Roedel" <jroedel@suse.de>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: RE: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
Thread-Topic: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call
 functions
Thread-Index: AQHVBLOOpe57oOoUm0iPpfi6TWW3V6ZfXgyAgAAYbgCAACXZIA==
Date:   Tue, 7 May 2019 12:57:15 +0000
Message-ID: <f55e3c951aee4b5686201aaf282cc62b@AcuMS.aculab.com>
References: <20190502185225.0cdfc8bc@gandalf.local.home>
 <20190502193129.664c5b2e@gandalf.local.home>
 <20190502195052.0af473cf@gandalf.local.home>
 <20190503092959.GB2623@hirez.programming.kicks-ass.net>
 <20190503092247.20cc1ff0@gandalf.local.home>
 <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
 <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
 <20190506081951.GJ2606@hirez.programming.kicks-ass.net>
 <20190507085753.GO2606@hirez.programming.kicks-ass.net>
 <b34aa38bdfe84263bc20b60761bf6005@AcuMS.aculab.com>
 <20190507113050.GR2606@hirez.programming.kicks-ass.net>
In-Reply-To: <20190507113050.GR2606@hirez.programming.kicks-ass.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: -vy_klLVNSOvRBjrRdIVmQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra
> Sent: 07 May 2019 12:31
> To: David Laight
> On Tue, May 07, 2019 at 09:18:51AM +0000, David Laight wrote:
> > From: Peter Zijlstra
> > > Sent: 07 May 2019 09:58
> > ...
> > > +	/*
> > > +	 * When we're here from kernel mode; the (exception) stack looks like:
> > > +	 *
> > > +	 * 4*4(%esp) - <previous context>
> > > +	 * 3*4(%esp) - flags
> > > +	 * 2*4(%esp) - cs
> > > +	 * 1*4(%esp) - ip
> > > +	 * 0*4(%esp) - orig_eax
> >
> > Am I right in thinking that this is the only 'INT3' stack frame that
> > needs to be 'fiddled' with?
> > And that the 'emulate a call instruction' has verified that is the case??
> > So the %cs is always the kernel %cs.
> 
> Only the INT3 thing needs 'the gap', but the far bigger change here is
> that kernel frames now have a complete pt_regs set and all sorts of
> horrible crap can go away.

I'm not doubting that generating the 'five register' interrupt stack frame
for faults in kernel space makes life simpler just suggesting that the
'emulated call' can be done by emulating the 'iret' rather than generating
a gap in the stack.

> For 32bit 'the gap' happens naturally when building a 5 entry frame. Yes
> it is possible to build a 5 entry frame on top of the old 3 entry one,
> but why bother...

Presumably there is 'horrid' code to generate the gap in 64bit mode?
(less horrid than 32bit, but still horrid?)
Or does it copy the entire pt_regs into a local stack frame and use
that for the iret?

I've just tried to parse the pseudo code for IRET in the intel docs.
Does anyone find that readable?
I wonder if you can force 32bit mode to do a stack switch 'iret'
by doing something like a far jump to a different %cs ?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

