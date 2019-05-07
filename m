Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00AF116606
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 16:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbfEGOug convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 7 May 2019 10:50:36 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:48836 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726351AbfEGOub (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 10:50:31 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-7-I_Am4TTIPMSjeYoUfKjqyA-1;
 Tue, 07 May 2019 15:50:28 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 7 May 2019 15:50:26 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 7 May 2019 15:50:26 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Steven Rostedt' <rostedt@goodmis.org>
CC:     'Peter Zijlstra' <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
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
Thread-Index: AQHVBLOOpe57oOoUm0iPpfi6TWW3V6ZfXgyAgAAYbgCAACXZIP//9vwAgAARSgA=
Date:   Tue, 7 May 2019 14:50:26 +0000
Message-ID: <b4a24fbe906a438798870c5112cde8b2@AcuMS.aculab.com>
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
        <f55e3c951aee4b5686201aaf282cc62b@AcuMS.aculab.com>
 <20190507091403.556daba7@gandalf.local.home>
In-Reply-To: <20190507091403.556daba7@gandalf.local.home>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: I_Am4TTIPMSjeYoUfKjqyA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt
> Sent: 07 May 2019 14:14
> On Tue, 7 May 2019 12:57:15 +0000
> David Laight <David.Laight@ACULAB.COM> wrote:
> 
> > > Only the INT3 thing needs 'the gap', but the far bigger change here is
> > > that kernel frames now have a complete pt_regs set and all sorts of
> > > horrible crap can go away.
> >
> > I'm not doubting that generating the 'five register' interrupt stack frame
> > for faults in kernel space makes life simpler just suggesting that the
> > 'emulated call' can be done by emulating the 'iret' rather than generating
> > a gap in the stack.
> 
> But how would the user put something on the stack? I don't see how
> emulating an iret helps here. Can you write some pseudo code to explain
> what you mean. I also believe the gap is only added for kernel->kernel
> entries.

The 'user' (ie the kernel code that needs to emulate the call) doesn't
write the data to the stack, just to some per-cpu location.
(Actually it could be on the stack at the other end of pt-regs.)
So you get to the 'register restore and iret' code with the stack unaltered.
It is then a SMOP to replace the %flags saved by the int3 with the %ip
saved by the int3, the %ip with the address of the function to call,
restore the flags (push and popf) and issue a ret.f to remove the %ip and %cs.

(Actually you need to add 4 to the callers %ip address to allow for the
difference between the size of int3 (hopefully 0xcc, not 0xcd 0x3).)

> > > For 32bit 'the gap' happens naturally when building a 5 entry frame. Yes
> > > it is possible to build a 5 entry frame on top of the old 3 entry one,
> > > but why bother...
> >
> > Presumably there is 'horrid' code to generate the gap in 64bit mode?
> > (less horrid than 32bit, but still horrid?)
> > Or does it copy the entire pt_regs into a local stack frame and use
> > that for the iret?
> 
> On x86_64, the gap is only done for int3 and nothing else, thus it is
> much less horrid. That's because x86_64 has a sane pt_regs storage for
> all exceptions.

Well, in particular, it always loads %sp as part of the iret.
So you can create a gap and the cpu will remove it for you.

In 64bit mode you could overwrite the %ss with the return address
to the caller restore %eax and %flags, push the function address
and use ret.n to jump to the function subtracting the right amount
from %esp.

Actually that means you can do the following in both modes:
	if not emulated_call_address then pop %ax; iret else
	# assume kernel<->kernel return
	push emulated_call_address;
	push flags_saved_by_int3
	load %ax, return_address_from_iret
	add %ax,#4
	store %ax, first_stack_location_written_by_int3
	load %ax, value_saved_by_int3_entry
	popf
	ret.n

The ret.n discards everything from the %ax to the required return address.
So 'n' is the size of the int3 frame, so 12 for i386 and 40 for amd64.

If the register restore (done just before this code) finished with
'add %sp, sizeof *pt_regs' then the emulated_call_address can be
loaded in %ax from the other end of pt_regs.

This all reminds me of fixing up the in-kernel faults that happen
when loading the user segment registers during 'return to user'
fault in kernel space.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

