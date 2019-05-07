Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62BA416618
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 16:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfEGO5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 10:57:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbfEGO5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 10:57:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E695120578;
        Tue,  7 May 2019 14:57:25 +0000 (UTC)
Date:   Tue, 7 May 2019 10:57:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Peter Zijlstra' <peterz@infradead.org>,
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
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call
 functions
Message-ID: <20190507105724.02abe6f6@gandalf.local.home>
In-Reply-To: <b4a24fbe906a438798870c5112cde8b2@AcuMS.aculab.com>
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
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 May 2019 14:50:26 +0000
David Laight <David.Laight@ACULAB.COM> wrote:

> From: Steven Rostedt
> > Sent: 07 May 2019 14:14
> > On Tue, 7 May 2019 12:57:15 +0000
> > David Laight <David.Laight@ACULAB.COM> wrote:

> The 'user' (ie the kernel code that needs to emulate the call) doesn't
> write the data to the stack, just to some per-cpu location.
> (Actually it could be on the stack at the other end of pt-regs.)
> So you get to the 'register restore and iret' code with the stack unaltered.
> It is then a SMOP to replace the %flags saved by the int3 with the %ip
> saved by the int3, the %ip with the address of the function to call,
> restore the flags (push and popf) and issue a ret.f to remove the %ip and %cs.

How would you handle NMIs doing the same thing? Yes, the NMI handlers
have breakpoints that will need to emulated calls as well.

> 
> (Actually you need to add 4 to the callers %ip address to allow for the
> difference between the size of int3 (hopefully 0xcc, not 0xcd 0x3).)
> 
> > > > For 32bit 'the gap' happens naturally when building a 5 entry frame. Yes
> > > > it is possible to build a 5 entry frame on top of the old 3 entry one,
> > > > but why bother...  
> > >
> > > Presumably there is 'horrid' code to generate the gap in 64bit mode?
> > > (less horrid than 32bit, but still horrid?)
> > > Or does it copy the entire pt_regs into a local stack frame and use
> > > that for the iret?  
> > 
> > On x86_64, the gap is only done for int3 and nothing else, thus it is
> > much less horrid. That's because x86_64 has a sane pt_regs storage for
> > all exceptions.  
> 
> Well, in particular, it always loads %sp as part of the iret.
> So you can create a gap and the cpu will remove it for you.
> 
> In 64bit mode you could overwrite the %ss with the return address
> to the caller restore %eax and %flags, push the function address
> and use ret.n to jump to the function subtracting the right amount
> from %esp.
> 
> Actually that means you can do the following in both modes:
> 	if not emulated_call_address then pop %ax; iret else
> 	# assume kernel<->kernel return
> 	push emulated_call_address;
> 	push flags_saved_by_int3
> 	load %ax, return_address_from_iret
> 	add %ax,#4
> 	store %ax, first_stack_location_written_by_int3
> 	load %ax, value_saved_by_int3_entry
> 	popf
> 	ret.n
> 
> The ret.n discards everything from the %ax to the required return address.
> So 'n' is the size of the int3 frame, so 12 for i386 and 40 for amd64.
> 
> If the register restore (done just before this code) finished with
> 'add %sp, sizeof *pt_regs' then the emulated_call_address can be
> loaded in %ax from the other end of pt_regs.
> 
> This all reminds me of fixing up the in-kernel faults that happen
> when loading the user segment registers during 'return to user'
> fault in kernel space.

This all sounds much more complex and fragile than the proposed
solution. Why would we do this over what is being proposed?

-- Steve
