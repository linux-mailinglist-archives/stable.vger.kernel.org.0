Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95BEF17FF86
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgCJNwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:52:33 -0400
Received: from foss.arm.com ([217.140.110.172]:37482 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726390AbgCJNwd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:52:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5D9E130E;
        Tue, 10 Mar 2020 06:52:32 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 26C433F6CF;
        Tue, 10 Mar 2020 06:52:31 -0700 (PDT)
Date:   Tue, 10 Mar 2020 13:52:24 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        'Chris Wilson' <chris@chris-wilson.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>, elver@google.com
Subject: Re: [PATCH] list: Prevent compiler reloads inside 'safe' list
 iteration
Message-ID: <20200310135224.GA54660@lakrids.cambridge.arm.com>
References: <20200310092119.14965-1-chris@chris-wilson.co.uk>
 <2e936d8fd2c445beb08e6dd3ee1f3891@AcuMS.aculab.com>
 <158384100886.16414.15741589015363013386@build.alporthouse.com>
 <723d527a4ad349b78bf11d52eba97c0e@AcuMS.aculab.com>
 <20200310125031.GY2935@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310125031.GY2935@paulmck-ThinkPad-P72>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 05:50:31AM -0700, Paul E. McKenney wrote:
> On Tue, Mar 10, 2020 at 12:23:34PM +0000, David Laight wrote:
> > From: Chris Wilson
> > > Sent: 10 March 2020 11:50
> > > 
> > > Quoting David Laight (2020-03-10 11:36:41)
> > > > From: Chris Wilson
> > > > > Sent: 10 March 2020 09:21
> > > > > Instruct the compiler to read the next element in the list iteration
> > > > > once, and that it is not allowed to reload the value from the stale
> > > > > element later. This is important as during the course of the safe
> > > > > iteration, the stale element may be poisoned (unbeknownst to the
> > > > > compiler).
> > > >
> > > > Eh?
> > > > I thought any function call will stop the compiler being allowed
> > > > to reload the value.
> > > > The 'safe' loop iterators are only 'safe' against called
> > > > code removing the current item from the list.
> > > >
> > > > > This helps prevent kcsan warnings over 'unsafe' conduct in releasing the
> > > > > list elements during list_for_each_entry_safe() and friends.
> > > >
> > > > Sounds like kcsan is buggy ????
> 
> Adding Marco on CC for his thoughts.
> 
> > > The warning kcsan gave made sense (a strange case where the emptying the
> > > list from inside the safe iterator would allow that list to be taken
> > > under a global mutex and have one extra request added to it. The
> > > list_for_each_entry_safe() should be ok in this scenario, so long as the
> > > next element is read before this element is dropped, and the compiler is
> > > instructed not to reload the element.
> > 
> > Normally the loop iteration code has to hold the mutex.
> > I guess it can be released inside the loop provided no other
> > code can ever delete entries.
> > 
> > > kcsan is a little more insistent on having that annotation :)
> > > 
> > > In this instance I would say it was a false positive from kcsan, but I
> > > can see why it would complain and suspect that given a sufficiently
> > > aggressive compiler, we may be caught out by a late reload of the next
> > > element.
> > 
> > If you have:
> > 	for (; p; p = next) {
> > 		next = p->next;
> > 		external_function_call(void);
> > 	}
> > the compiler must assume that the function call
> > can change 'p->next' and read it before the call.
> 
> That "must assume" is a statement of current compiler technology.
> Given the progress over the past forty years, I would not expect this
> restriction to hold forever. 

FWIW, this is exactly the sort of assumption that link time optimization
is likely to render invalid going forward, and LTO is starting to be
used today (e.g. to enable SW CFI stuff with clang).

Given that, I don't think that core kernel primitives can rely on this
assumption.

Thanks,
Mark.
