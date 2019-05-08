Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A54217E33
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 18:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbfEHQhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 12:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727502AbfEHQhy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 12:37:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E5BB216F4;
        Wed,  8 May 2019 16:37:50 +0000 (UTC)
Date:   Wed, 8 May 2019 12:37:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20190508123748.1737b8b5@gandalf.local.home>
In-Reply-To: <CAHk-=wg5_fwx_-ybD9TLQE4rAUqtYzO2CAmpciWTkDn3dtKMOw@mail.gmail.com>
References: <CAHk-=wjLXmOn=Cp=uOfO4gE01eN_-UcOUyrMTTw5-f_OfPO48Q@mail.gmail.com>
        <20190506225819.11756974@oasis.local.home>
        <CAHk-=wh4FCNBLe8OyDZt2Tr+k9JhhTsg3H8R4b55peKcf0b6eQ@mail.gmail.com>
        <20190506232158.13c9123b@oasis.local.home>
        <CAHk-=wi4vPg4pu6RvxQrUuBL4Vgwd2G2iaEJVVumny+cBOWMZw@mail.gmail.com>
        <CAHk-=wg2_okyU8mpkGCUrudgfg8YmNetSD8=scNbOkN+imqZdQ@mail.gmail.com>
        <20190507111227.1d4268d7@gandalf.local.home>
        <CAHk-=wjYdj+vvV8uUA8eaUSxOhu=xuQxdo-dtM927j0-3hSkEw@mail.gmail.com>
        <20190507163440.GV2606@hirez.programming.kicks-ass.net>
        <CAHk-=wiuue37opWK5QaQ9f6twqDZuSratdP-1bK6kD9-Az5WnA@mail.gmail.com>
        <20190507172159.5t3bm3mjkwagvite@treble>
        <20190507172418.67ef6fc3@gandalf.local.home>
        <CAHk-=wg5_fwx_-ybD9TLQE4rAUqtYzO2CAmpciWTkDn3dtKMOw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 May 2019 21:50:52 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > It's been a bane of mine for some time.  
> 
> Guys, I have basically a one-liner patch for your hangups.
> 
> It's called "rename 'sp' to 'user_sp' on x86-32".
> 
> Then we make the 'sp' field on x86-64 be a union, so that you can call
> it user_sp or sp as you wish.
> 
> Yeah, it's really more than one line, because obviously the users will
> need chaning, but honestly, that would be a _real_ cleanup. Make the
> register match what it actually is.

But is it? Sure, it will be a reminder that it's different for x86-32,
but that still doesn't take away the fact that pt_regs on x86_32 is an
anomaly! Where else do we have part of a data structure that can't be
read because it can possibly fault? If regs is a valid pointer, one
would think that simply reading regs->sp (or regs->user_sp) would be no
more dangerous than reading regs->ip.

The difference between entry_32.S from entry_64.S causes it to spill
into C code, making the x86_64 code more difficult to deal with. Sure,
10 to 15 years ago, all your arguments would make sense. But today, who
uses x86_32?  Perhaps you may use it in a VM, but I asked a few
developers when was the last time they used one, they told me 5 to 7
years ago. I only boot x86_32 to test to make sure I didn't break it.

Yes, your diffstat is really nice to the changes to entry_32.S, but at
what cost? To make the x86_64 code more complex? That whole returning
the regs in the int3 handler makes no sense on x86_64, but yet we would
need to do it to handle x86_32. Why burden the architecture of today
and tomorrow with the architecture of yesterday? x86_32 is becoming
more obsolete by the day. It baffles me why we wouldn't want to contain
its complexity in a single file then to spread it out like wildfire
across the generic x86 code.

The &regs->sp hack is just one more rung in the complex learning curve
ladder of becoming a Linux kernel developer.

-- Steve
