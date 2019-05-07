Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23B416457
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 15:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfEGNOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 09:14:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbfEGNOH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 09:14:07 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70D8B2053B;
        Tue,  7 May 2019 13:14:04 +0000 (UTC)
Date:   Tue, 7 May 2019 09:14:02 -0400
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
Message-ID: <20190507091403.556daba7@gandalf.local.home>
In-Reply-To: <f55e3c951aee4b5686201aaf282cc62b@AcuMS.aculab.com>
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
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 May 2019 12:57:15 +0000
David Laight <David.Laight@ACULAB.COM> wrote:

> > Only the INT3 thing needs 'the gap', but the far bigger change here is
> > that kernel frames now have a complete pt_regs set and all sorts of
> > horrible crap can go away.  
> 
> I'm not doubting that generating the 'five register' interrupt stack frame
> for faults in kernel space makes life simpler just suggesting that the
> 'emulated call' can be done by emulating the 'iret' rather than generating
> a gap in the stack.

But how would the user put something on the stack? I don't see how
emulating an iret helps here. Can you write some pseudo code to explain
what you mean. I also believe the gap is only added for kernel->kernel
entries.

> 
> > For 32bit 'the gap' happens naturally when building a 5 entry frame. Yes
> > it is possible to build a 5 entry frame on top of the old 3 entry one,
> > but why bother...  
> 
> Presumably there is 'horrid' code to generate the gap in 64bit mode?
> (less horrid than 32bit, but still horrid?)
> Or does it copy the entire pt_regs into a local stack frame and use
> that for the iret?

On x86_64, the gap is only done for int3 and nothing else, thus it is
much less horrid. That's because x86_64 has a sane pt_regs storage for
all exceptions.

-- Steve
