Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE0C1163DC
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 14:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfEGMmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 08:42:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38860 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfEGMmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 08:42:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=81opB8G7Ipd0tVreem0atOppp7UchqtWU6V9nRjg3jM=; b=gYkz85TyaiCt6SSCYspfu7uf9
        jrbc5Y4/InQcMFAT0lSX2OtfOHyC7APTtxe7YAvNjuUX2ihF5HCVIc6jH2JgTZGSaGI1e0PKeEZmt
        XnPXmbtxl5YVqwGOFgPjLYhvKx1yPuZqmO+6TPlK+x51gIogJjQGwTE5q2MedgGWpcfx/aGUiq1S8
        Z8ikXYv0UkkBzGkghK3nRMHvHYV+LJWXiG+YyIv06fEAuoLkx95svxUFDcbWJI2H3IMiWwEvZ3Hx+
        NPcwK8hTflUo0JgfVKgMRLR8T03VTctYK6VVILJqOOqyUf7CTrnrDBnr/UGJKx7pREwTGjydZREIz
        8T9xtBqXQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hNzPa-0007Bf-CG; Tue, 07 May 2019 12:41:34 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D30DC201E11CE; Tue,  7 May 2019 14:41:31 +0200 (CEST)
Date:   Tue, 7 May 2019 14:41:31 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
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
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
Message-ID: <20190507124131.GO2623@hirez.programming.kicks-ass.net>
References: <20190502193129.664c5b2e@gandalf.local.home>
 <20190502195052.0af473cf@gandalf.local.home>
 <20190503092959.GB2623@hirez.programming.kicks-ass.net>
 <20190503092247.20cc1ff0@gandalf.local.home>
 <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
 <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
 <20190506081951.GJ2606@hirez.programming.kicks-ass.net>
 <20190507085753.GO2606@hirez.programming.kicks-ass.net>
 <20190507092731.GH2650@hirez.programming.kicks-ass.net>
 <20190507082716.73cd5a01@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507082716.73cd5a01@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 08:27:16AM -0400, Steven Rostedt wrote:
> On Tue, 7 May 2019 11:27:31 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > FWIW, both these trampolines assume a kprobe will not
> > int3_emulate_{push/call}(), for both bitnesses.
> > 
> > But then; I'm thinking kprobes should be inspection only and not modify
> > things. So that might just be good enough.
> 
> I believe there are kprobe calls that do modify things. Note, they can
> modify regs->ip. 

The kprobe pre_handler as used by kretprobes does, and that is indeed
handled by the trampolines.

> Kprobes sets the FTRACE_OPS_FL_IPMODIFY flag, thus
> they can never be put at the same location that is being live patched.

OK, so do we want to allow kprobes that also modify regs->sp ? Because
then we need to change these trampolines a bit.

I'd prefer not to allow kprobes this.
