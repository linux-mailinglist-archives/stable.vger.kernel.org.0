Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B018817FDE7
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgCJMuN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 10 Mar 2020 08:50:13 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:51478 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728558AbgCJMuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 08:50:13 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 20508636-1500050 
        for multiple; Tue, 10 Mar 2020 12:50:09 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <723d527a4ad349b78bf11d52eba97c0e@AcuMS.aculab.com>
References: <20200310092119.14965-1-chris@chris-wilson.co.uk> <2e936d8fd2c445beb08e6dd3ee1f3891@AcuMS.aculab.com> <158384100886.16414.15741589015363013386@build.alporthouse.com> <723d527a4ad349b78bf11d52eba97c0e@AcuMS.aculab.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] list: Prevent compiler reloads inside 'safe' list iteration
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Message-ID: <158384460847.16414.11779622376668751989@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Tue, 10 Mar 2020 12:50:08 +0000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting David Laight (2020-03-10 12:23:34)
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
> > 
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
>         for (; p; p = next) {
>                 next = p->next;
>                 external_function_call(void);
>         }
> the compiler must assume that the function call
> can change 'p->next' and read it before the call.
> 
> Is this a list with strange locking rules?

Yes.

> The only deletes are from within the loop.

All deletes are within the mutex.

> Adds and deletes are locked.

There's just one special case where after the very last element of all
lists for an engine is removed, a global mutex is taken and one new
element is added to one of the lists to track powering off the engine.

> The list traversal isn't locked.

There's rcu traversal of the list as well.
 
> I suspect kcsan bleats because it doesn't assume the compiler
> will use a single instruction/memory operation to read p->next.
> That is just stupid.

kcsan is looking for a write to a pointer after a read that is not in
the same locking chain. While I have satisfied lockdep that I am not
insane, I'm worrying in case kcsan has a valid objection to the
potential data race in the safe list iterator.
-Chris
