Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 039AE16652
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 17:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbfEGPMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 11:12:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726556AbfEGPMc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 11:12:32 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 126A7205ED;
        Tue,  7 May 2019 15:12:28 +0000 (UTC)
Date:   Tue, 7 May 2019 11:12:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
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
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call
 functions
Message-ID: <20190507111227.1d4268d7@gandalf.local.home>
In-Reply-To: <CAHk-=wg2_okyU8mpkGCUrudgfg8YmNetSD8=scNbOkN+imqZdQ@mail.gmail.com>
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
        <20190506145745.17c59596@gandalf.local.home>
        <CAHk-=witfFBW2O5v6g--FmqnAFsMkKNLosTFfWyaoJ7euQF8kQ@mail.gmail.com>
        <20190506162915.380993f9@gandalf.local.home>
        <CAHk-=wi5KBWUOvM94aTOPnoJ5L_aQG=vgLQ4SxxZDeQD0pF2tQ@mail.gmail.com>
        <20190506174511.2f8b696b@gandalf.local.home>
        <CAHk-=wj3R_s0RTJOmTBNaUPhu4fz2shNBUr4M6Ej65UYSNCs-g@mail.gmail.com>
        <20190506210416.2489a659@oasis.local.home>
        <CAHk-=whZwqzbu-=1r_j_cXfd=ta1q7RFCuneqBZfQQhS_P-BmQ@mail.gmail.com>
        <20190506215353.14a8ef78@oasis.local.home>
        <CAHk-=wjLXmOn=Cp=uOfO4gE01eN_-UcOUyrMTTw5-f_OfPO48Q@mail.gmail.com>
        <20190506225819.11756974@oasis.local.home>
        <CAHk-=wh4FCNBLe8OyDZt2Tr+k9JhhTsg3H8R4b55peKcf0b6eQ@mail.gmail.com>
        <20190506232158.13c9123b@oasis.local.home>
        <CAHk-=wi4vPg4pu6RvxQrUuBL4Vgwd2G2iaEJVVumny+cBOWMZw@mail.gmail.com>
        <CAHk-=wg2_okyU8mpkGCUrudgfg8YmNetSD8=scNbOkN+imqZdQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 May 2019 07:54:53 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> And honestly, I absolutely despise PeterZ's patch. The notion that we
> should suddenly say that "oh, the i386 kernel stack is odd" after 28
> years of having that standard i386 stack is just crazy. And this:
> 
>  arch/x86/entry/entry_32.S            | 136 ++++++++++++++++++++++++++++-------
> ...
>  12 files changed, 323 insertions(+), 140 deletions(-)
> 
> 
> vs this:
> 
>  arch/x86/entry/entry_32.S            |  7 +++-
> ...
>  6 files changed, 120 insertions(+), 13 deletions(-)
> 
> is still pretty damn conclusive. Not to mention that the simple
> approach had a truly mindbogglingly simple solution with no actual
> subtle changes anywhere else.
> 
> So I still claim that we should do my patch. Because it is SIMPLE.
> It's straightforward, and I can explain every single line in it. Even
> if I spent *way* too long until I realized that the "trivial"
> memmove() wasn't so trivial.

Yes, band-aids are usually simpler than a proper fix. We have 28 years
of hacks built on hacks. There's a lot of hacks in the C code to handle
the differences between the crappy way x86_32 does pt_regs and the
proper way x86_64 does them.

If the goal was just to add another band-aid to this, we now have one
more subtle work around caused by two different methods being handled
by a single code base.

I don't look at Peter's patch and think "this is the solution for int3
emulate calls". I see Peter's patch as "Thanks God, we are finally
getting rid of the cause of all theses work around hacks all over the
place! and oh by the way, we can easily implement int3 call emulation
because of it".

To implement your way, we need to change how the int3 handler works.
It will be the only exception handler having to return regs, otherwise
it will crash.

Sure, it's an easily solution for the one off change of emulating
calls, but it's just another complex work around that nobody is going
to understand in 5 years.

-- Steve
