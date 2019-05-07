Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3128A16960
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 19:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfEGRix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 13:38:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48376 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfEGRiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 13:38:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JOIMQ2PwgSE1LhNwkWDe6YdOB+QHfRQcSFVAFTagnHc=; b=sb4uWI6EOfMhfhDCgpKA1PsTt
        7AhxjT2DW9CBAQi3QL28CeYK4IdpuEgwnbOH7iFySchxnUvQeMB5XWF7okxzl8rcTv0UfkZqZIZgP
        +VTGovbm0Nrgrhzot5tqQS7B4Qz5sOAs5QQoT9WLkUcOLm2z4uZ3WVDfGMg+E494qMmCmHSh9IhuK
        sCNzI0WjeVto0407AhNmb4eni+BMJHFALTFvTKoxt5Ak7fwsvdcvfxHIA2gN82rLNcp70nc8lx6Ul
        WqJH7yyS5UnLJnUXruUW0UaNb0SzWWtj6c+cT1YIoPCqOJE6YuoYPdPLam2cVWhhRBfmZksBl7MfW
        KDVqGkpcA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hO42w-0000jD-Rr; Tue, 07 May 2019 17:38:31 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 12157207E85C5; Tue,  7 May 2019 19:38:29 +0200 (CEST)
Date:   Tue, 7 May 2019 19:38:29 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
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
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
Message-ID: <20190507173829.GY2606@hirez.programming.kicks-ass.net>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiuue37opWK5QaQ9f6twqDZuSratdP-1bK6kD9-Az5WnA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

The ftrace_regs_caller, the kprobe tramplines, the unwinder, they all
have 'funny' bits because pt_regs isn't 'right'.

> So the whole "let's clean up x86-32 to look like x86-64, which got
> things right" is to me a completely bogus argument. x86-64 got the
> "yes, push ss/sp unconditionally" part right, but got a lot of other
> things horribly wrong. So this is all just one small detail that
> differs, across two architectures that are similar but have very
> different warts.

It's a detail that leaks into the C code. Yes SWAPGS is horrible crap,
but C code doesn't much care. The partial pt_regs thing otoh comes up a
fair number of times.

Anyway; I think we're at the point where we'll have to agree to
disagree (or maybe slightly past it).
