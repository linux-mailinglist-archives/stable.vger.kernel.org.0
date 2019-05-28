Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7902C537
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 13:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfE1LQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 07:16:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36273 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfE1LQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 07:16:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id s17so19774554wru.3
        for <stable@vger.kernel.org>; Tue, 28 May 2019 04:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=m2nsIiu2xmXeWsYUgRHVpMlsXmoMPRxeUORAALMIKSI=;
        b=F8AFn2T8q0YuEbe8O1YmusdB4KKX4+W7+bSwB31soLQqW7nM+xmlU7TAZMFkFdHJLB
         Jy1WVb8qw8KkVqWiofCzb5Ey2TiQlhTVZFu8lRZeL0GtHBtn4yicUcWTdye2K+uayqkC
         jqFubNh1Hl8MPRKXzBgIS8CoL7co65suY5UoU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=m2nsIiu2xmXeWsYUgRHVpMlsXmoMPRxeUORAALMIKSI=;
        b=RoAuv0boBYTu0Qa6fHXJ0gOyUWQX2hKyhNKbAFS6LY47qX/4yvIhUdNQytiyHGluAS
         4ndFIdRpv9bR01A/5k2gx5t5VcX13iAALUz1l6wKTiQXhWMYocGEMJeT99QD8aBAfrlv
         RoLyDuhl+CB7ZMOSqr+cog7bcOV0Lpg+czwD+YAXHVIXMWwUWN8bMoBE4cwn2FezVgVW
         df3OAHBgCqJhfGRP0GRZGF6dyVRugp88b6NrSl1sdtMKIYKeMTk+oYR17Jh3zgfyOsRv
         V37j5C/y/SNLWEeE/NJU3t9jWtPI1i56QkUTvVH3j+uha8+ABdFGbc/MJUS3K0lMv4uK
         +bWA==
X-Gm-Message-State: APjAAAW5RNytgTCrzlS8l1qAC6qcSqxo4B3TUsJrSNBWTbc7RH4kkNWJ
        mNe0LUXRICQp7Sl8TfNC9360lA==
X-Google-Smtp-Source: APXvYqz5nIcFjokXYBk+792MqQz8LkCQtBXoFpS+E23Bk9wHZ1kkRwZndDs817gSoTcwICsJyRkaDQ==
X-Received: by 2002:adf:9bd2:: with SMTP id e18mr27122695wrc.210.1559042166403;
        Tue, 28 May 2019 04:16:06 -0700 (PDT)
Received: from andrea (86.100.broadband17.iol.cz. [109.80.100.86])
        by smtp.gmail.com with ESMTPSA id h17sm16048029wrq.79.2019.05.28.04.16.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 04:16:05 -0700 (PDT)
Date:   Tue, 28 May 2019 13:15:58 +0200
From:   Andrea Parri <andrea.parri@amarulasolutions.com>
To:     Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20190528111558.GA9106@andrea>
References: <20190522132250.26499-1-mark.rutland@arm.com>
 <20190523083013.GA4616@andrea>
 <20190523101926.GA3370@lakrids.cambridge.arm.com>
 <20190524103731.GN2606@hirez.programming.kicks-ass.net>
 <20190524111807.GS2650@hirez.programming.kicks-ass.net>
 <20190524114220.GA4260@fuggles.cambridge.arm.com>
 <20190524115231.GN2623@hirez.programming.kicks-ass.net>
 <20190524224340.GA3792@andrea>
 <20190528104719.GN2623@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528104719.GN2623@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 28, 2019 at 12:47:19PM +0200, Peter Zijlstra wrote:
> On Sat, May 25, 2019 at 12:43:40AM +0200, Andrea Parri wrote:
> > > ---
> > > Subject: Documentation/atomic_t.txt: Clarify pure non-rmw usage
> > > 
> > > Clarify that pure non-RMW usage of atomic_t is pointless, there is
> > > nothing 'magical' about atomic_set() / atomic_read().
> > > 
> > > This is something that seems to confuse people, because I happen upon it
> > > semi-regularly.
> > > 
> > > Acked-by: Will Deacon <will.deacon@arm.com>
> > > Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > ---
> > >  Documentation/atomic_t.txt | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/Documentation/atomic_t.txt b/Documentation/atomic_t.txt
> > > index dca3fb0554db..89eae7f6b360 100644
> > > --- a/Documentation/atomic_t.txt
> > > +++ b/Documentation/atomic_t.txt
> > > @@ -81,9 +81,11 @@ SEMANTICS
> > >  
> > >  The non-RMW ops are (typically) regular LOADs and STOREs and are canonically
> > >  implemented using READ_ONCE(), WRITE_ONCE(), smp_load_acquire() and
> > > -smp_store_release() respectively.
> > > +smp_store_release() respectively. Therefore, if you find yourself only using
> > > +the Non-RMW operations of atomic_t, you do not in fact need atomic_t at all
> > > +and are doing it wrong.
> > 
> > The counterargument (not so theoretic, just look around in the kernel!) is:
> > we all 'forget' to use READ_ONCE() and WRITE_ONCE(), it should be difficult
> > or more difficult to forget to use atomic_read() and atomic_set()...   IAC,
> > I wouldn't call any of them 'wrong'.
> 
> I'm thinking you mean that the type system isn't helping us with
> READ/WRITE_ONCE() like it does with atomic_t ?

Yep.


> And while I agree that
> there is room for improvement there, that doesn't mean we should start
> using atomic*_t all over the place for that.

Agreed.  But this still doesn't explain that "and are doing it wrong",
AFAICT; maybe just remove that part?

  Andrea


> 
> Part of the problem with READ/WRITE_ONCE() is that it serves a dual
> purpose; we've tried to untangle that at some point, but Linus wasn't
> having it.
