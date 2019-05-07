Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5EC16173
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 11:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbfEGJvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 05:51:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37100 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfEGJvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 05:51:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WjYr1hVNE4iAw+7Hs4O5qCYhwgcyd/TjnQU+ylXG3fM=; b=2PrdrVaeBWK5E/7b/rRbhiuH/
        GqK++COdKlCtPkcX95fgrq2I6Q64ZR8LsSFu8ifvUL65m3x9EUrbgQ8mwJfHdOJFcP6p7Csh/sQg7
        BYp5B7mtEoPWCaUjRmNbDS5cHedj5cUB3Zi5M4RDPIQr7Q4SDbsB1haee3elg/NwXNU5TIcDEmGCc
        KYsf7ikSD5F1IHYJnF59ly4uHlMnNhUteGUIZopd3cN8Ht97Dkl5cbfaGzJG6Z8PRf2V+K7gwSKix
        gPsXj26qVM2fzQLkLc/ejAjJtLq0PC5vEPG4BQz+4hUEsxVoTWkqvP+MbifhCWRAOiKS57g0owZJp
        GTS8ReStg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hNwkb-0005Mq-0z; Tue, 07 May 2019 09:51:05 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 709F72023ADB7; Tue,  7 May 2019 11:51:03 +0200 (CEST)
Date:   Tue, 7 May 2019 11:51:03 +0200
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
Message-ID: <20190507095103.GP2606@hirez.programming.kicks-ass.net>
References: <20190506145745.17c59596@gandalf.local.home>
 <CAHk-=witfFBW2O5v6g--FmqnAFsMkKNLosTFfWyaoJ7euQF8kQ@mail.gmail.com>
 <20190506162915.380993f9@gandalf.local.home>
 <CAHk-=wi5KBWUOvM94aTOPnoJ5L_aQG=vgLQ4SxxZDeQD0pF2tQ@mail.gmail.com>
 <20190506174511.2f8b696b@gandalf.local.home>
 <CAHk-=wj3R_s0RTJOmTBNaUPhu4fz2shNBUr4M6Ej65UYSNCs-g@mail.gmail.com>
 <20190506210416.2489a659@oasis.local.home>
 <CAHk-=whZwqzbu-=1r_j_cXfd=ta1q7RFCuneqBZfQQhS_P-BmQ@mail.gmail.com>
 <20190506215353.14a8ef78@oasis.local.home>
 <CAHk-=wjLXmOn=Cp=uOfO4gE01eN_-UcOUyrMTTw5-f_OfPO48Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjLXmOn=Cp=uOfO4gE01eN_-UcOUyrMTTw5-f_OfPO48Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 06, 2019 at 07:22:06PM -0700, Linus Torvalds wrote:
> We do *not* have very strict guarantees for D$-vs-I$ coherency on x86,
> but we *do* have very strict guarantees for D$-vs-D$ coherency. And so
> we could use the D$ coherency to give us atomicity guarantees for
> loading and storing the instruction offset for instruction emulation,
> in ways we can *not* use the D$-to-I$ guarantees and just executing it
> directly.
> 
> So while we still need those nasty IPI's to guarantee the D$-vs-I$
> coherency in the "big picture" model and to get the serialization with
> the actual 'int3' exception right, we *could* just do all the other
> parts of the instruction emulation using the D$ coherency.
> 
> So we could do the actual "call offset" write with a single atomic
> 4-byte locked cycle (just use "xchg" to write - it's always locked).
> And similarly we could do the call offset *read* with a single locked
> cycle (cmpxchg with a 0 value, for example). It would be atomic even
> if it crosses a cacheline boundary.

Very 'soon', x86 will start to #AC if you do unaligned LOCK prefixed
instructions. The problem is that while aligned LOCK instructions can do
the atomicity with the coherency protocol, unaligned (esp, line or page
boundary crossing ones) needs that bus-lock thing the SDM talks about.

For giggles, write yourself a while(1) loop that XCHGs across a
page-boundary and see what it does to the rest of the system.

So _please_, do not rely on unaligned atomic ops. We really want them to
do the way of the Dodo.
