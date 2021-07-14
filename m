Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8493C87CB
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 17:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239621AbhGNPin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 11:38:43 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:46024 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S239584AbhGNPin (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 11:38:43 -0400
Received: from callcc.thunk.org (96-65-121-81-static.hfc.comcastbusiness.net [96.65.121.81])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 16EFZTW3011784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Jul 2021 11:35:30 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 8F7244202F5; Wed, 14 Jul 2021 11:35:29 -0400 (EDT)
Date:   Wed, 14 Jul 2021 11:35:29 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: 5.13.2-rc and others have many not for stable
Message-ID: <YO8EQZF4+iQ13QU/@mit.edu>
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com>
 <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
 <YO6r1k7CIl16o61z@kroah.com>
 <YO7sNd+6Vlw+hw3y@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YO7sNd+6Vlw+hw3y@sashalap>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 14, 2021 at 09:52:53AM -0400, Sasha Levin wrote:
> On Wed, Jul 14, 2021 at 11:18:14AM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Jul 13, 2021 at 06:28:13PM -0700, Andrew Morton wrote:
> > > Alternatively I could just invent a new tag to replace the "Fixes:"
> > > ("Fixes-no-backport?") to be used on patches which fix a known previous
> > > commit but which we don't want backported.
> > 
> > No please, that's not needed, I'll just ignore these types of patches
> > now, and will go drop these from the queues.
> > 
> > Sasha, can you also add these to your "do not apply" script as well?
> 
> Sure, but I don't see how this is viable in the long term. Look at
> distros that don't follow LTS trees and cherry pick only important
> fixes, and see how many of those don't have a stable@ tag.

I've been talking to an enterprise distro who chooses not to use the
LTS releases, and it's mainly because they tried it, and there was too
many regressions leading to their customers filing problem reports
which get escalated to their engineers, leading to unhappy customers
and extra work for their engineers.  (And they have numbers to back up
this assertion; this isn't just a gut feel sort of thing.)

There are a couple of ways of solving it.  Once is that perhaps we
need to have more people testing the stable trees --- and not just for
functional regressions but also for performance regressions.  Ideally
we would be doing lots of performance regression testing all the time,
for all releases, and not just for the stable kernels, but the reality
is that performance testing takes a lot of time, effort, and in some
cases large amounts of expensive equipment.

We have syzbot and the zero-day bot; perhaps we can see if some
company might be interested in setting up a "perfbot"?

Another solution (and these don't have to be mutually exclusive) might
be for maintainers can explicitly state that certain patches shouldn't
be backported into stable kernels.  I think having an explicit
"No-Backport: <Reason>" might be useful, since it documents why a
maintainer requested that the patch not be backported, and being an
explicit tag, it makes it clear that it wasn't just a case of the
developer forgetting the "Cc: stable" tag.  This makes it much better
than implicit rules such as "If from: akpm then don't backport" hidden
in various stable maintainers' scripts.

						- Ted
