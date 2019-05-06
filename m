Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 844B414B59
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 15:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbfEFN4g convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 6 May 2019 09:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfEFN4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 09:56:36 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EEB02054F;
        Mon,  6 May 2019 13:56:32 +0000 (UTC)
Date:   Mon, 6 May 2019 09:56:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
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
        Joerg Roedel <jroedel@suse.de>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call
 functions
Message-ID: <20190506095631.6f71ad7c@gandalf.local.home>
In-Reply-To: <20190506081951.GJ2606@hirez.programming.kicks-ass.net>
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
        <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
        <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
        <20190502185225.0cdfc8bc@gandalf.local.home>
        <20190502193129.664c5b2e@gandalf.local.home>
        <20190502195052.0af473cf@gandalf.local.home>
        <20190503092959.GB2623@hirez.programming.kicks-ass.net>
        <20190503092247.20cc1ff0@gandalf.local.home>
        <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
        <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
        <20190506081951.GJ2606@hirez.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 6 May 2019 10:19:51 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, May 03, 2019 at 11:57:22AM -0700, Linus Torvalds wrote:
> > On Fri, May 3, 2019 at 9:21 AM Andy Lutomirski <luto@amacapital.net> wrote:  
> > >
> > > So here’s a somewhat nutty suggestion: how about we tweak the 32-bit
> > > entry code to emulate the sane 64-bit frame, not just for int3 but
> > > always?  
> > 
> > What would the code actually end up looking like? I don't necessarily
> > object, since that kernel_stack_pointer() thing certainly looks
> > horrible, but honestly, my suggestion to just pass in the 'struct
> > pt_regs' and let the call emulation fix it up would have also worked,
> > and avoided that bug (and who knows what else might be hiding).
> > 
> > I really think that you're now hitting all the special case magic
> > low-level crap that I wanted to avoid.  
> 
> This did actually boot on first try; so there must be something horribly
> wrong...
> 
> Now, I know you like that other approach; but I figured I should at
> least show you what this one looks like. Maybe I've been staring at
> entry_32.S too much, but I really don't dislike this.

I can test this too. I was hoping to get this in by this merge window.
I spent 3 hours yesterday trying to get Linus's version working on
i386 with no success. Not sure how much time Linus will have to look at
this, as he just opened the merge window.

Again, I think Peter's solution here is the more elegant one. But as
long as we get *a* solution, I'll be happy. And my time to work on it
has pretty much already been depleted.

-- Steve
