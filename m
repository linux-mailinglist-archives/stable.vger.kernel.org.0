Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBAB16905
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 19:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfEGRWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 13:22:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39462 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbfEGRWN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 13:22:13 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B8B1F81E0A;
        Tue,  7 May 2019 17:22:10 +0000 (UTC)
Received: from treble (ovpn-123-166.rdu2.redhat.com [10.10.123.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E22B45C21F;
        Tue,  7 May 2019 17:22:01 +0000 (UTC)
Date:   Tue, 7 May 2019 12:21:59 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
Message-ID: <20190507172159.5t3bm3mjkwagvite@treble>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wiuue37opWK5QaQ9f6twqDZuSratdP-1bK6kD9-Az5WnA@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 07 May 2019 17:22:12 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 10:08:50AM -0700, Linus Torvalds wrote:
> On Tue, May 7, 2019 at 9:34 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > Would you consider my approach later on, under the guise of unification?
> 
> WHY?
> 
> The *only* advantage of your patch is that trivial "look up kernel stack" macro.
> 
> Seriously. There's absolutely nothing else.
> 
> Is that macro ugly? Yes. But it's directly explainable by just
> pointing to the architecture documentation.
> 
> It's a one-liner hack.
> 
> And for that, you want to complicate the x86-32 entry and exit code?
> 
> Do we have different emulation for "push" on 32-bit and 64-bit? Yes.
> But again, that's just how the hardware works. This is not some
> "generic hw-independent code". This is literally emulating
> instructions that care about instruction encoding and bit size
> details, where there are certainly _similarities_ (and in the case of
> 'call', they look bit-identical), but it's also not like "same code"
> is a big argument. That's why we have a helper function, to hide the
> details.
> 
> I point to my diffstat once again. It's smaller, and I argue that it
> is actually conceptually *simpler* to simply say "this is how the
> architecture works".
> 
> And yes, I realize that I may be biased by the fact that I simply know
> i386 so well, so to me it simply makes more sense to just work with
> what the hardware gives us. The i386 exception model with the kernel
> stack nesting is a *hell* of a lot simpler than the x86-64 one. The
> fact is, x86-64 messed things up, and swapgs and friends are an
> abomination against God.
> 
> So the whole "let's clean up x86-32 to look like x86-64, which got
> things right" is to me a completely bogus argument. x86-64 got the
> "yes, push ss/sp unconditionally" part right, but got a lot of other
> things horribly wrong. So this is all just one small detail that
> differs, across two architectures that are similar but have very
> different warts.
> 
> But that diffstat is still hard, cold, unbiased data.

regs->sp is *undefined* on x86-32.  We're damning our future selves to
have to always remember to use that darn kernel_stack_pointer() helper
for eternity just because of x86-32.

There have already been several bugs related to that.  Because regs->sp
is there, so why wouldn't you use it?

If we truly want the code to reflect the HW, then we should have a
pt_regs_kernel and a pt_regs_user on 32-bit.  I'm pretty sure we don't
want to go there...

IMO, we either need to make the pt_regs struct(s) match the HW behavior,
or make entry code match pt_regs.  But this in-between thing just
creates a bunch of headaches.

-- 
Josh
