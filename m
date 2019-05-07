Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBB016723
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 17:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfEGPqy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 7 May 2019 11:46:54 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:31571 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726197AbfEGPqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 11:46:54 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-181-LGeneRpPP1-n91Ii04Istg-1; Tue, 07 May 2019 16:46:52 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 7 May 2019 16:46:51 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 7 May 2019 16:46:50 +0100
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
Thread-Index: AQHVBLOOpe57oOoUm0iPpfi6TWW3V6ZfXgyAgAAYbgCAACXZIP//9vwAgAARSgCAAAuXAIAAEj/g
Date:   Tue, 7 May 2019 15:46:50 +0000
Message-ID: <9820e70016e0454e89e70d8f7dd90259@AcuMS.aculab.com>
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
        <b4a24fbe906a438798870c5112cde8b2@AcuMS.aculab.com>
 <20190507105724.02abe6f6@gandalf.local.home>
In-Reply-To: <20190507105724.02abe6f6@gandalf.local.home>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: LGeneRpPP1-n91Ii04Istg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt
> Sent: 07 May 2019 15:57
> On Tue, 7 May 2019 14:50:26 +0000
> David Laight <David.Laight@ACULAB.COM> wrote:
> 
> > From: Steven Rostedt
> > > Sent: 07 May 2019 14:14
> > > On Tue, 7 May 2019 12:57:15 +0000
> > > David Laight <David.Laight@ACULAB.COM> wrote:
> 
> > The 'user' (ie the kernel code that needs to emulate the call) doesn't
> > write the data to the stack, just to some per-cpu location.
> > (Actually it could be on the stack at the other end of pt-regs.)
> > So you get to the 'register restore and iret' code with the stack unaltered.
> > It is then a SMOP to replace the %flags saved by the int3 with the %ip
> > saved by the int3, the %ip with the address of the function to call,
> > restore the flags (push and popf) and issue a ret.f to remove the %ip and %cs.
> 
> How would you handle NMIs doing the same thing? Yes, the NMI handlers
> have breakpoints that will need to emulated calls as well.

That means you'd have to use a field in the on-stack pt_regs for the
'address to call' rather than a per-cpu variable.
Then it would all nest.

...
> > Actually that means you can do the following in both modes:
> > 	if not emulated_call_address then pop %ax; iret else
> > 	# assume kernel<->kernel return
> > 	push emulated_call_address;
> > 	push flags_saved_by_int3
> > 	load %ax, return_address_from_iret
> > 	add %ax,#4
> > 	store %ax, first_stack_location_written_by_int3
> > 	load %ax, value_saved_by_int3_entry
> > 	popf
> > 	ret.n
> >
> > The ret.n discards everything from the %ax to the required return address.
> > So 'n' is the size of the int3 frame, so 12 for i386 and 40 for amd64.
> >
> > If the register restore (done just before this code) finished with
> > 'add %sp, sizeof *pt_regs' then the emulated_call_address can be
> > loaded in %ax from the other end of pt_regs.
...
> 
> This all sounds much more complex and fragile than the proposed
> solution. Why would we do this over what is being proposed?

It is all complex and fragile however you do it.

I see a problem with converting the 3 register trap frame to a 5 register
one is that the entry code and exit code both have to know whether
it is necessary or was done.

AFAICT it is actually quite hard to tell from the stack which form it is.
Although the %sp value might tell you because %ss:%sp might only be
pushed when a stack switch happens so the kernel %sp will be a known
value (for the switched to stack).

The advantage of converting the frame is that, as pointed out earlier it
does let you have a pt_regs that always contains %ss:%sp.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

