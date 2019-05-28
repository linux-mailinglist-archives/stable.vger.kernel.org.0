Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3472C4B6
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 12:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfE1KsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 06:48:12 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47004 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbfE1KsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 06:48:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RkNAaQnFGQavYiriTPKlPs3zV7ehPx3Q5wBuIkfcSyQ=; b=N5gqwYZkhKw5xd3HaXD+oKNxk
        7cRQ/oGaV9aX3rkUf1/5FQZvH0tG0X10+CakLOYduKuyAweNgLDRjVZLuAfR5zF78tlCFV5cG12O0
        Kax9nSIj/coHdRxD34yq9onu0e9K1Mr44je4DrL6JDwx+4oh3fcA5VVZ2wGvbCMPvYbc1Z4XwoHiq
        r0zY0HFL8GBkP5HgiyfQeWSWB4sXQF1YADcr9jy16IyVumfhGZf9hEbfNJ5B2KMXjC06XUQ0WBf4S
        vqzvEOhRbrWwZPUwjlviUQEOuppvCpbmPhtc1XdKrYnD7mPn7Pf6/Oko6DmCTy8yR5tZDMyTjyQKe
        ygubRKysA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hVZda-00033A-HC; Tue, 28 May 2019 10:47:22 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0AB552072908C; Tue, 28 May 2019 12:47:20 +0200 (CEST)
Date:   Tue, 28 May 2019 12:47:19 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andrea Parri <andrea.parri@amarulasolutions.com>
Cc:     Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, aou@eecs.berkeley.edu, arnd@arndb.de,
        bp@alien8.de, catalin.marinas@arm.com, davem@davemloft.net,
        fenghua.yu@intel.com, heiko.carstens@de.ibm.com,
        herbert@gondor.apana.org.au, ink@jurassic.park.msu.ru,
        jhogan@kernel.org, linux@armlinux.org.uk, mattst88@gmail.com,
        mingo@kernel.org, mpe@ellerman.id.au, palmer@sifive.com,
        paul.burton@mips.com, paulus@samba.org, ralf@linux-mips.org,
        rth@twiddle.net, stable@vger.kernel.org, tglx@linutronix.de,
        tony.luck@intel.com, vgupta@synopsys.com,
        gregkh@linuxfoundation.org, jhansen@vmware.com, vdasa@vmware.com,
        aditr@vmware.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 00/18] locking/atomic: atomic64 type cleanup
Message-ID: <20190528104719.GN2623@hirez.programming.kicks-ass.net>
References: <20190522132250.26499-1-mark.rutland@arm.com>
 <20190523083013.GA4616@andrea>
 <20190523101926.GA3370@lakrids.cambridge.arm.com>
 <20190524103731.GN2606@hirez.programming.kicks-ass.net>
 <20190524111807.GS2650@hirez.programming.kicks-ass.net>
 <20190524114220.GA4260@fuggles.cambridge.arm.com>
 <20190524115231.GN2623@hirez.programming.kicks-ass.net>
 <20190524224340.GA3792@andrea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524224340.GA3792@andrea>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 25, 2019 at 12:43:40AM +0200, Andrea Parri wrote:
> > ---
> > Subject: Documentation/atomic_t.txt: Clarify pure non-rmw usage
> > 
> > Clarify that pure non-RMW usage of atomic_t is pointless, there is
> > nothing 'magical' about atomic_set() / atomic_read().
> > 
> > This is something that seems to confuse people, because I happen upon it
> > semi-regularly.
> > 
> > Acked-by: Will Deacon <will.deacon@arm.com>
> > Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  Documentation/atomic_t.txt | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/atomic_t.txt b/Documentation/atomic_t.txt
> > index dca3fb0554db..89eae7f6b360 100644
> > --- a/Documentation/atomic_t.txt
> > +++ b/Documentation/atomic_t.txt
> > @@ -81,9 +81,11 @@ SEMANTICS
> >  
> >  The non-RMW ops are (typically) regular LOADs and STOREs and are canonically
> >  implemented using READ_ONCE(), WRITE_ONCE(), smp_load_acquire() and
> > -smp_store_release() respectively.
> > +smp_store_release() respectively. Therefore, if you find yourself only using
> > +the Non-RMW operations of atomic_t, you do not in fact need atomic_t at all
> > +and are doing it wrong.
> 
> The counterargument (not so theoretic, just look around in the kernel!) is:
> we all 'forget' to use READ_ONCE() and WRITE_ONCE(), it should be difficult
> or more difficult to forget to use atomic_read() and atomic_set()...   IAC,
> I wouldn't call any of them 'wrong'.

I'm thinking you mean that the type system isn't helping us with
READ/WRITE_ONCE() like it does with atomic_t ? And while I agree that
there is room for improvement there, that doesn't mean we should start
using atomic*_t all over the place for that.

Part of the problem with READ/WRITE_ONCE() is that it serves a dual
purpose; we've tried to untangle that at some point, but Linus wasn't
having it.
