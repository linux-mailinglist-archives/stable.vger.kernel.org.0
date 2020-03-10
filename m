Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC84C17FDC7
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgCJMud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbgCJMuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:50:32 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA3A12468D;
        Tue, 10 Mar 2020 12:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844631;
        bh=4nXPnykUsacARlS2dVosm+pERhdkOACkmujynfGKPDc=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=LxJaWEYOLamJTgK85rUm0S/gisC6gK1qb5rPeeF4ZttSvr+VX0xdaDonSnclURJVU
         Oy2hFi/tprPB5V1gzSnp2yfjyegJUdbpT81qPOYJlhED/knyJfBTC/PU3PI7ZVMup4
         dhN3oqm5xBXAa4kcjPbXcmCra5t10+x/VnV3oK6c=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 5558E35226CF; Tue, 10 Mar 2020 05:50:31 -0700 (PDT)
Date:   Tue, 10 Mar 2020 05:50:31 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Chris Wilson' <chris@chris-wilson.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>, elver@google.com
Subject: Re: [PATCH] list: Prevent compiler reloads inside 'safe' list
 iteration
Message-ID: <20200310125031.GY2935@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200310092119.14965-1-chris@chris-wilson.co.uk>
 <2e936d8fd2c445beb08e6dd3ee1f3891@AcuMS.aculab.com>
 <158384100886.16414.15741589015363013386@build.alporthouse.com>
 <723d527a4ad349b78bf11d52eba97c0e@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <723d527a4ad349b78bf11d52eba97c0e@AcuMS.aculab.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 12:23:34PM +0000, David Laight wrote:
> From: Chris Wilson
> > Sent: 10 March 2020 11:50
> > 
> > Quoting David Laight (2020-03-10 11:36:41)
> > > From: Chris Wilson
> > > > Sent: 10 March 2020 09:21
> > > > Instruct the compiler to read the next element in the list iteration
> > > > once, and that it is not allowed to reload the value from the stale
> > > > element later. This is important as during the course of the safe
> > > > iteration, the stale element may be poisoned (unbeknownst to the
> > > > compiler).
> > >
> > > Eh?
> > > I thought any function call will stop the compiler being allowed
> > > to reload the value.
> > > The 'safe' loop iterators are only 'safe' against called
> > > code removing the current item from the list.
> > >
> > > > This helps prevent kcsan warnings over 'unsafe' conduct in releasing the
> > > > list elements during list_for_each_entry_safe() and friends.
> > >
> > > Sounds like kcsan is buggy ????

Adding Marco on CC for his thoughts.

> > The warning kcsan gave made sense (a strange case where the emptying the
> > list from inside the safe iterator would allow that list to be taken
> > under a global mutex and have one extra request added to it. The
> > list_for_each_entry_safe() should be ok in this scenario, so long as the
> > next element is read before this element is dropped, and the compiler is
> > instructed not to reload the element.
> 
> Normally the loop iteration code has to hold the mutex.
> I guess it can be released inside the loop provided no other
> code can ever delete entries.
> 
> > kcsan is a little more insistent on having that annotation :)
> > 
> > In this instance I would say it was a false positive from kcsan, but I
> > can see why it would complain and suspect that given a sufficiently
> > aggressive compiler, we may be caught out by a late reload of the next
> > element.
> 
> If you have:
> 	for (; p; p = next) {
> 		next = p->next;
> 		external_function_call(void);
> 	}
> the compiler must assume that the function call
> can change 'p->next' and read it before the call.

That "must assume" is a statement of current compiler technology.
Given the progress over the past forty years, I would not expect this
restriction to hold forever.  Yes, we can and probably will get the
compiler implementers to give us command-line flags to suppress global
analysis.  But given the progress in compilers that I have seen over
the past 4+ decades, I would expect that the day will come when we won't
want to be using those command-line flags.

But if you want to ignore KCSAN's warnings, you are free to do so.

> Is this a list with strange locking rules?
> The only deletes are from within the loop.
> Adds and deletes are locked.
> The list traversal isn't locked.
> 
> I suspect kcsan bleats because it doesn't assume the compiler
> will use a single instruction/memory operation to read p->next.
> That is just stupid.

Heh!  If I am still around, I will ask you for your evaluation of the
above statement in 40 years.  Actually, 10 years will likely suffice.  ;-)

							Thanx, Paul
