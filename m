Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 833381A2A4B
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 22:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbgDHU0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 16:26:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728221AbgDHU0b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 16:26:31 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA932206F7;
        Wed,  8 Apr 2020 20:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586377591;
        bh=Rf///vS7hUQYNaKEa5vTJDy89qODrzFaodSfFgOA/EA=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=wFjIOlDGvPMkug1U0zNPHfrxuIhe5ziZ0z/CBAAOzbM9iy5HZk4DF47NuUuGoxU6b
         3t/xZ688gP574PXvZR3OZLOzyTo7XvWH0UZTCmwnBd4CRBG0pdfwhMYKGgVyRLzoVx
         j9u+J1l7Ie1lJtH2ZUvcqaHTE5YKbamI1R6/5mQk=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id BC9D03523234; Wed,  8 Apr 2020 13:26:30 -0700 (PDT)
Date:   Wed, 8 Apr 2020 13:26:30 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Laight <David.Laight@aculab.com>,
        Marco Elver <elver@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mark Rutland <mark.rutland@arm.com>,
        mm-commits@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [patch 125/166] lib/list: prevent compiler reloads inside 'safe'
 list iteration
Message-ID: <20200408202630.GA1666@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
 <20200407031042.8o-fYMox-%akpm@linux-foundation.org>
 <CAHk-=wi1h-wBC3Kg2qBhs_R1UGyocGq0cT1eO+12pwBsO+d1ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi1h-wBC3Kg2qBhs_R1UGyocGq0cT1eO+12pwBsO+d1ww@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 08:44:35AM -0700, Linus Torvalds wrote:
> On Mon, Apr 6, 2020 at 8:10 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > From: Chris Wilson <chris@chris-wilson.co.uk>
> > Subject: lib/list: prevent compiler reloads inside 'safe' list iteration
> >
> > Instruct the compiler to read the next element in the list iteration
> > once, and that it is not allowed to reload the value from the stale
> > element later. This is important as during the course of the safe
> > iteration, the stale element may be poisoned (unbeknownst to the
> > compiler).
> 
> Andrew, Chris, this one looks rather questionable to me.
> 
> How the heck would the ->next pointer be changed without the compiler
> being aware of it? That implies a bug to begin with - possibly an
> inline asm that changes kernel memory without having a memory clobber.
> 
> Quite fundamentally, the READ_ONCE() doesn't seem to fix anything. If
> something else can change the list _concurrently_, it's still
> completely broken, and hiding the KASAN report is just hiding a bug.
> 
> What and where was the actual KASAN issue? The commit log doesn't say...

OK, it sounds like we need to specify what needs to be present in this
sort of commit log.  Please accept my apologies for this specification
not already being in place.

How about the following?

o	The KCSAN splat, optionally including file/line numbers.

o	Any non-default Kconfig options that are required to reproduce
	the problem, along with any other repeat-by information.

o	Detailed description of the problem this splat identifies, for
	example, the code might fail to acquire a necessary lock, a plain
	load might vulnerable to compiler optimizations, and so on.

o	If available, references to or excerpts from the comments
	and documentation defining the design rules that the old code
	violates.

o	If the commit's effect is to silence the warning with no other
	algorithmic change, an explanation as to why this is the right
	thing to do.  Continuing the plain-load example above, that
	load might be controlling a loop and the compiler might choose
	to hoist the load out of the loop, potentially resulting in an
	infinite loop.

	Another example might be diagnostic code where the accesses are
	not really part of the concurrency design, but where we need
	KCSAN checking the other code that implements that design.

Thoughts?  Additions?  Subtractions?

							Thanx, Paul
