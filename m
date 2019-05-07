Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16CFD162D5
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 13:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfEGLcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 07:32:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38388 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfEGLcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 07:32:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0G0Op7qzdUllIx217BDIX7hQDFmNR1hjBEmN3uH/wmM=; b=bv9hlo2+IqIluXyx1IyzYf4+2
        XhumvYALMGJMgM81v5ZLGPqY5LRZT67zik8hBt/625x5jxWyUACHPwDUiRtMLRjyLFvSehE0YE9hA
        WGGaAEm4Vl0gGDXvotmBnc3tECB82fSuKQ8Sex3m4R/NZ4WI2ti48nUQA8iUYzqb3GENub4IxQS9M
        xUX1h7wMqORpAYUeAvaWgn5ss/K6KKU3WqkmIEqdjHnLl1vrosMXNaFZEhI6TOJsXytb/c3vdR6P3
        dD4e/QeMf+TEl7i2H86GUAZAY5cVEe9letJOB7J9cES996O5TlJTAZ3VCmQ+UyU3Pmz+Q62/LWc8F
        7dDh57edQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hNyJB-0006Sy-Su; Tue, 07 May 2019 11:30:54 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D03FC2063D744; Tue,  7 May 2019 13:30:50 +0200 (CEST)
Date:   Tue, 7 May 2019 13:30:50 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
Message-ID: <20190507113050.GR2606@hirez.programming.kicks-ass.net>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b34aa38bdfe84263bc20b60761bf6005@AcuMS.aculab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 09:18:51AM +0000, David Laight wrote:
> From: Peter Zijlstra
> > Sent: 07 May 2019 09:58
> ...
> > +	/*
> > +	 * When we're here from kernel mode; the (exception) stack looks like:
> > +	 *
> > +	 * 4*4(%esp) - <previous context>
> > +	 * 3*4(%esp) - flags
> > +	 * 2*4(%esp) - cs
> > +	 * 1*4(%esp) - ip
> > +	 * 0*4(%esp) - orig_eax
> 
> Am I right in thinking that this is the only 'INT3' stack frame that
> needs to be 'fiddled' with?
> And that the 'emulate a call instruction' has verified that is the case??
> So the %cs is always the kernel %cs.

Only the INT3 thing needs 'the gap', but the far bigger change here is
that kernel frames now have a complete pt_regs set and all sorts of
horrible crap can go away.

For 32bit 'the gap' happens naturally when building a 5 entry frame. Yes
it is possible to build a 5 entry frame on top of the old 3 entry one,
but why bother...
