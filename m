Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9445167F8
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 18:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfEGQfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 12:35:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40306 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEGQfY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 12:35:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OwZTZ1ye0D7Ag0dmc5Qr6LUWP6U5n+yawypfjqqzLy4=; b=ZlA04PGR8vVdeot8a14D0ychS
        eWlNjZpfHpgXS1NucZeTFXBN6jJkNeLPtBeU8nc6mOgBgLRA1xaPZuwO3hTJ77EaFcmQFRWUBCeqP
        pO44MV2/RaY16zho2uINk0qCw4dSVUhH10mHw3LlTxvGNWIJ52/B93mC630NkcbkEWz4NZtDvSoY6
        dXyLN3Nt8Adquvr7tqbkZzVGmNW9CrqxJ+5NkPrpdKvDDW3jx9uFyc5VIRe/3NoO8SWwXSOAaaS/1
        M6ADRbzJItWnPrqpwVoIpbeAlzU/AHKAqtcQkPYt/aIoQVcTZy6A4Rk3O551zLBoYmjkiO2TyskkC
        miJyDezIw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hO33D-0001Qi-BY; Tue, 07 May 2019 16:34:43 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C52CC20F40185; Tue,  7 May 2019 18:34:40 +0200 (CEST)
Date:   Tue, 7 May 2019 18:34:40 +0200
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
Message-ID: <20190507163440.GV2606@hirez.programming.kicks-ass.net>
References: <CAHk-=whZwqzbu-=1r_j_cXfd=ta1q7RFCuneqBZfQQhS_P-BmQ@mail.gmail.com>
 <20190506215353.14a8ef78@oasis.local.home>
 <CAHk-=wjLXmOn=Cp=uOfO4gE01eN_-UcOUyrMTTw5-f_OfPO48Q@mail.gmail.com>
 <20190506225819.11756974@oasis.local.home>
 <CAHk-=wh4FCNBLe8OyDZt2Tr+k9JhhTsg3H8R4b55peKcf0b6eQ@mail.gmail.com>
 <20190506232158.13c9123b@oasis.local.home>
 <CAHk-=wi4vPg4pu6RvxQrUuBL4Vgwd2G2iaEJVVumny+cBOWMZw@mail.gmail.com>
 <CAHk-=wg2_okyU8mpkGCUrudgfg8YmNetSD8=scNbOkN+imqZdQ@mail.gmail.com>
 <20190507111227.1d4268d7@gandalf.local.home>
 <CAHk-=wjYdj+vvV8uUA8eaUSxOhu=xuQxdo-dtM927j0-3hSkEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjYdj+vvV8uUA8eaUSxOhu=xuQxdo-dtM927j0-3hSkEw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 08:31:14AM -0700, Linus Torvalds wrote:
> The reality is that changing something fundamental like the kernel
> stack at this point for an architecture that will not change in the
> future is silly.

In my eyes it makes sense because i386 is a minority architecture at
this point, and 'nobody' wants to care about how its different if they
don't have to.

> The reality is that Peter's patch is much bigger than mine, because it
> needed a lot of other changes *because* it did that change.

Yes, I change the way stack layout works on i386, and yes that affects a
lot of code. _However_ all of that code is now more like x86_64 than it
was.

Earlier you said that kernel_stack_pointer() was a horrible thing; and
most/all the code that I ended up touching was similarly horrible.

Would you consider my approach later on, under the guise of unification?
We can work on it for a while, and make sure all the iffy bits are
sorted, no need to rush?
