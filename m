Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2BE61A2BFD
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 00:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgDHWoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 18:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgDHWoi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 18:44:38 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FE5C20730;
        Wed,  8 Apr 2020 22:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586385878;
        bh=/GnrN3yMhGvFNsv2SWgRpkM+pZY9kGf1n7T0e4pYEj8=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=W6ByfA+fJPdUClhSVfw2/6wxfooL1pCJ8uLCmrKr/wiAhyD+eqmTWb/YRf+fpvH+Q
         BE1LDvJNGk8ocF1DQHjlI28VMZ743t/o42RWmlEyL3sAya2BAZaKkuzlsyqCXjyyna
         AEIivhMWAVQLeN9boW+2av7gAKozpCkn6xzSg0AQ=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 14B233523234; Wed,  8 Apr 2020 15:44:38 -0700 (PDT)
Date:   Wed, 8 Apr 2020 15:44:38 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Laight <David.Laight@aculab.com>,
        Marco Elver <elver@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mark Rutland <mark.rutland@arm.com>,
        mm-commits@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [patch 125/166] lib/list: prevent compiler reloads inside 'safe'
 list iteration
Message-ID: <20200408224438.GA4654@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
 <20200407031042.8o-fYMox-%akpm@linux-foundation.org>
 <CAHk-=wi1h-wBC3Kg2qBhs_R1UGyocGq0cT1eO+12pwBsO+d1ww@mail.gmail.com>
 <20200408202630.GA1666@paulmck-ThinkPad-P72>
 <CAHk-=wicuF-BZj9b_Dbv+Ev8FT4XqULj2qMpkaUgEokNir345A@mail.gmail.com>
 <20200408223757.GG17661@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408223757.GG17661@paulmck-ThinkPad-P72>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 08, 2020 at 03:37:57PM -0700, Paul E. McKenney wrote:
> On Wed, Apr 08, 2020 at 02:14:38PM -0700, Linus Torvalds wrote:
> > On Wed, Apr 8, 2020 at 1:26 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> > >
> > > OK, it sounds like we need to specify what needs to be present in this
> > > sort of commit log.
> > 
> > That would have helped.
> > 
> > But in this case, after having looked more at it, it wasn't that the
> > commit log was not sufficient, it was that the change was wrong.
> > 
> > With a better commit log and a pointer to the KCSAN report, I would
> > have been able to make a better judgment call earlier, and not have
> > had to ask for more information.
> > 
> > But once I figured out what the problem was, it was clear that
> > 
> >  (a) what the i915 driver does is at a minimum questionable, and quite
> > likely actively buggy
> > 
> >  (b) even if it's not buggy in the i915 driver, changing the list
> > traversal macros to use READ_ONCE() would hide other places where it
> > most definitely is buggy.
> 
> Yeah, and I should especially have spotted this last one, given how many
> times I have run into it while using KCSAN within RCU.  ;-/
> 
> In any case, we have review comments, discussion, and the occasional
> controvery for non-KCSAN bug fixes, so it is only reasonable to expect
> a similar process for KCSAN bug reports, right?  My main goal here is
> to make things easier for people reviewing future KCSAN-inspired fixes.
> 
> > > o       The KCSAN splat, optionally including file/line numbers.
> > 
> > I do think that the KCSAN splat - very preferably simplified and with
> > explanations - should basically always be included if KCSAN was the
> > reason.
> > 
> > Of course, the "simplified and with explanations" may be simplified to
> > the point where none of the original splat even remains. Those splats
> > aren't so legible that anybody should feel like they should be
> > included.
> > 
> > Put another way: an analysis that is so thorough that it makes the raw
> > splat data pointless is a *good* thing, and if that means that no
> > splat is needed, all the better.
> 
> Fair point.  The KCSAN splat has the added advantage of immediately
> answering the "but does this really happen?" question, but then again
> that question could also be answered by just stating that the issue was
> found using KCSAN.
> 
> > > o       Detailed description of the problem this splat identifies, for
> > >         example, the code might fail to acquire a necessary lock, a plain
> > >         load might vulnerable to compiler optimizations, and so on.
> > 
> > See above: if the description is detailed enough, then the splat
> > itself becomes much less interesting.
> > 
> > But in this case, for example, it's worth pointing out that the "safe"
> > list accessors are used all over the kernel, and they are very much
> > _not_ thread-safe. The "safe" in them is purely about the current
> > thread removing an entry, not some kind of general thread-safeness.
> > 
> > Which is why I decided I really hated that patch - it basically would
> > make KCSAN unable to find _real_ races elsewhere, because it hid a
> > very special race in the i915 driver.
> > 
> > So I started out with the "that can't be right" kind of general
> > feeling of uneasiness about the patch. I ended up with a much more
> > specific "no, that's very much not right" and no amount of commit log
> > should have saved it.
> > 
> > As mentioned, I suspect that the i915 driver could actually use the
> > RCU-safe list walkers. Their particular use is not about RCU per se,
> > but it has some very similar rules about walking a list concurrently
> > with somebody adding an entry to it.
> > 
> > And the RCU list walkers do end up doing special things to load the
> > next pointer.
> > 
> > Whether we want to say - and document - that "ok, the RCU list walkers
> > are also useful for this non-RCU use case" in general might be worth
> > discussing.

This might work quite well, given the lockdep annotations that Joel
added to list_for_each_entry_rcu().  For example, lockdep_assert_held()
would tell it that it didn't need to be in an RCU reader as long as the
lock passed to lockdep_assert_held() was held at that point.

> > It may be that the i915 use case is so special that it's only worth
> > documenting there.
> 
> If documenting is the right approach, KCSAN's data_race() could be
> thought of as KCSAN-visible documentation.
> 
> I will touch base with Chris separately.

Of these options, what looks best to you?  Or would something else work
better?

							Thanx, Paul
