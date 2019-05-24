Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F380297A9
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 13:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391381AbfEXLyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 07:54:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49178 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391378AbfEXLyF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 07:54:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vVkD+yS+6mY3ND8nY872UeMHSULOVyjDtscm+0lgvtc=; b=Dy0aSOZbCrVtrIo8dC0PzlUHX
        uFjvE/MFtcTUu5HIH7+jBtdgszhIPRaXs1lCTo3Bk8K784xoTIXK0SpZuzRHKaTidrLbfA9kASK2h
        YOYRaERfDnMZVsM1gw582GINE4uLOMLbwVub24179V+GnxUelKob/P3Pq4B2pr6szy7k0O56XVa5r
        2QecVZ8IzRq4rzgnJd/ywlC51c3JBP53P3kp/2EgJVQmOjCqOjA/p8FL1Mr4g4nLPNMnYz/J6Cm2p
        gJ323St9pi8uoLuX6aipNMh8SKXqD4ptdPWllpqyo2L18brt0NaDiH/HU2IakAidNo36uECiVaKEC
        xPtBx64og==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hU8kU-0008N3-D0; Fri, 24 May 2019 11:52:34 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AC0A620670583; Fri, 24 May 2019 13:52:31 +0200 (CEST)
Date:   Fri, 24 May 2019 13:52:31 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Will Deacon <will.deacon@arm.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
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
Message-ID: <20190524115231.GN2623@hirez.programming.kicks-ass.net>
References: <20190522132250.26499-1-mark.rutland@arm.com>
 <20190523083013.GA4616@andrea>
 <20190523101926.GA3370@lakrids.cambridge.arm.com>
 <20190524103731.GN2606@hirez.programming.kicks-ass.net>
 <20190524111807.GS2650@hirez.programming.kicks-ass.net>
 <20190524114220.GA4260@fuggles.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524114220.GA4260@fuggles.cambridge.arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 24, 2019 at 12:42:20PM +0100, Will Deacon wrote:

> > diff --git a/Documentation/atomic_t.txt b/Documentation/atomic_t.txt
> > index dca3fb0554db..125c95ddbbc0 100644
> > --- a/Documentation/atomic_t.txt
> > +++ b/Documentation/atomic_t.txt
> > @@ -83,6 +83,9 @@ The non-RMW ops are (typically) regular LOADs and STOREs and are canonically
> >  implemented using READ_ONCE(), WRITE_ONCE(), smp_load_acquire() and
> >  smp_store_release() respectively.
> >  
> 
> Not sure you need a new paragraph here.
> 
> > +Therefore, if you find yourself only using the Non-RMW operations of atomic_t,
> > +you do not in fact need atomic_t at all and are doing it wrong.
> > +
> 
> That makes sense to me, although I now find that the sentence below is a bit
> confusing because it sounds like it's a caveat relating to only using
> Non-RMW ops.
> 
> >  The one detail to this is that atomic_set{}() should be observable to the RMW
> >  ops. That is:
> 
> How about changing this to be:
> 
>   "A subtle detail of atomic_set{}() is that it should be observable..."

Done, find below.

---
Subject: Documentation/atomic_t.txt: Clarify pure non-rmw usage

Clarify that pure non-RMW usage of atomic_t is pointless, there is
nothing 'magical' about atomic_set() / atomic_read().

This is something that seems to confuse people, because I happen upon it
semi-regularly.

Acked-by: Will Deacon <will.deacon@arm.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 Documentation/atomic_t.txt | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/atomic_t.txt b/Documentation/atomic_t.txt
index dca3fb0554db..89eae7f6b360 100644
--- a/Documentation/atomic_t.txt
+++ b/Documentation/atomic_t.txt
@@ -81,9 +81,11 @@ SEMANTICS
 
 The non-RMW ops are (typically) regular LOADs and STOREs and are canonically
 implemented using READ_ONCE(), WRITE_ONCE(), smp_load_acquire() and
-smp_store_release() respectively.
+smp_store_release() respectively. Therefore, if you find yourself only using
+the Non-RMW operations of atomic_t, you do not in fact need atomic_t at all
+and are doing it wrong.
 
-The one detail to this is that atomic_set{}() should be observable to the RMW
+A subtle detail of atomic_set{}() is that it should be observable to the RMW
 ops. That is:
 
   C atomic-set
