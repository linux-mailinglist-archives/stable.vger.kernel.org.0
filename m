Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A58413244
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 18:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbfECQdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 12:33:33 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52484 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728429AbfECQdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 12:33:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7bDJVEAFBygjACU1RaANjjdiCUPrX9ag+EiTnO6DWPM=; b=ukMFMm5h9lQf5WvEOBr+T3kfZM
        r8r0CfSRKhD1HcNUjEmSwY8nkSDOrw/qrvpP5IUeaPWn0uqu+H8ujJnZijEzYL50HrovRcbh1KCPi
        Xi7YFpfcaHQCeyAOkmZqoJsDycMEA+JowfpGogZ7WT9RnZTuTBhhbvw6Unjh2xepqHmXA8ke/XDPd
        2xluE4/HuIxcpEFNYoD8YMxvijgtfi8qb8wAkbgt2HmaiX2lMWoToHWt5nDMRuBiEmm+Fq+UnVyKY
        K7ysWZkcvWc8B11IHi5aHLYqcb16V8SSEPWf5W2vVXvX4KoNIZm8WziBlgUbZfv1FZ3vHiwdVed+K
        QryDkasA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hMb7J-0005mB-Gk; Fri, 03 May 2019 16:32:57 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B51CA286B6527; Fri,  3 May 2019 18:32:55 +0200 (CEST)
Date:   Fri, 3 May 2019 18:32:55 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20190503163255.GG2606@hirez.programming.kicks-ass.net>
References: <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
 <20190502181811.GY2623@hirez.programming.kicks-ass.net>
 <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
 <20190502202146.GZ2623@hirez.programming.kicks-ass.net>
 <20190502185225.0cdfc8bc@gandalf.local.home>
 <20190502193129.664c5b2e@gandalf.local.home>
 <20190502195052.0af473cf@gandalf.local.home>
 <20190503092959.GB2623@hirez.programming.kicks-ass.net>
 <20190503092247.20cc1ff0@gandalf.local.home>
 <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2045370D-38D8-406C-9E94-C1D483E232C9@amacapital.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 03, 2019 at 09:20:55AM -0700, Andy Lutomirski wrote:
> > On May 3, 2019, at 6:22 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > On Fri, 3 May 2019 11:29:59 +0200
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > 
> >> OMG, WTF, ARGH... That code is fsck'ing horrible. I'd almost argue to
> >> always do the INT3 thing, just to avoid games like that.

> So here’s a somewhat nutty suggestion: how about we tweak the 32-bit
> entry code to emulate the sane 64-bit frame, not just for int3 but
> always? 

Basically what I wrote above, right? I'd be fine with that... Linus?
