Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C07716499
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 15:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfEGNcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 09:32:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56952 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfEGNcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 09:32:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=42YzfIkNTk2bk5895j/W3Ma7gIDhAlzcSAcyLA3vwr8=; b=XafYI8wZ4ZQn0vOhGSCp4A3Y9
        gbrLmqOwPHAqtYd5TT83L8EU1RQsUqDZQaX87iECkQJWeqHG0MnxKzAAcbNrPBg4A+k79zV32IOsL
        TBevSfqa0L0uo1m130yHTyT6f1P0K1f+I+rktJ0BmHU5J1O6ggjAD0QZDAPYjexdxv6FwNV2Evkti
        l+7E37dIOCiJjt5VWSF/7hNPExqZJHzvsoAP3g1a66RJnqCVRW36RMNlkoTi+6vx9sy3EjYIoyHIz
        n63mU3k0uQHXEDHdLC9WfCP4GBMzEf6jXnbPbaSJjC9+cCKH9HENOMlo5T6sA2yvT+LTSznePDvA8
        aMbeUPDGg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hO0CQ-0002vV-BG; Tue, 07 May 2019 13:32:03 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5546B2023ADB5; Tue,  7 May 2019 15:32:00 +0200 (CEST)
Date:   Tue, 7 May 2019 15:32:00 +0200
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
Message-ID: <20190507133200.GP2623@hirez.programming.kicks-ass.net>
References: <20190502195052.0af473cf@gandalf.local.home>
 <20190503092959.GB2623@hirez.programming.kicks-ass.net>
 <20190503092247.20cc1ff0@gandalf.local.home>
 <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
 <CAHk-=wjrOLqBG1qe9C3T=fLN0m=78FgNOGOEL22gU=+Pw6Mu9Q@mail.gmail.com>
 <20190506081951.GJ2606@hirez.programming.kicks-ass.net>
 <20190507085753.GO2606@hirez.programming.kicks-ass.net>
 <b34aa38bdfe84263bc20b60761bf6005@AcuMS.aculab.com>
 <20190507113050.GR2606@hirez.programming.kicks-ass.net>
 <f55e3c951aee4b5686201aaf282cc62b@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f55e3c951aee4b5686201aaf282cc62b@AcuMS.aculab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 12:57:15PM +0000, David Laight wrote:

> > Only the INT3 thing needs 'the gap', but the far bigger change here is
> > that kernel frames now have a complete pt_regs set and all sorts of
> > horrible crap can go away.
> 
> I'm not doubting that generating the 'five register' interrupt stack frame
> for faults in kernel space makes life simpler just suggesting that the
> 'emulated call' can be done by emulating the 'iret' rather than generating
> a gap in the stack.

The thing you suggested doesn't actually work, INT3 can nest.

> > For 32bit 'the gap' happens naturally when building a 5 entry frame. Yes
> > it is possible to build a 5 entry frame on top of the old 3 entry one,
> > but why bother...
> 
> Presumably there is 'horrid' code to generate the gap in 64bit mode?
> (less horrid than 32bit, but still horrid?)
> Or does it copy the entire pt_regs into a local stack frame and use
> that for the iret?

It's in the patch you replied to; it is so small you might have
overlooked it. It simply pushes another copy on top of what was already
there.

> I've just tried to parse the pseudo code for IRET in the intel docs.
> Does anyone find that readable?

No; it's abysmal.

> I wonder if you can force 32bit mode to do a stack switch 'iret'
> by doing something like a far jump to a different %cs ?

I don't think that'll work.
