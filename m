Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDB43EB47B
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 13:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239888AbhHMLU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 07:20:27 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:35224 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239428AbhHMLU1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 07:20:27 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 17DBJrpP022478;
        Fri, 13 Aug 2021 13:19:53 +0200
Date:   Fri, 13 Aug 2021 13:19:53 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, jason@jlekstrand.net,
        Jonathan Gray <jsg@jsg.id.au>
Subject: Re: Determining corresponding mainline patch for stable patches Re:
 [PATCH 5.10 125/135] drm/i915: avoid uninitialised var in eb_parse()
Message-ID: <20210813111953.GB21912@1wt.eu>
References: <20210810172955.660225700@linuxfoundation.org>
 <20210810173000.050147269@linuxfoundation.org>
 <20210811072843.GC10829@duo.ucw.cz>
 <YROARN2fMPzhFMNg@kroah.com>
 <20210811122702.GA8045@duo.ucw.cz>
 <YRPLbV+Dq2xTnv2e@kroah.com>
 <20210813093104.GA20799@duo.ucw.cz>
 <20210813095429.GA21912@1wt.eu>
 <20210813102429.GA28610@duo.ucw.cz>
 <YRZRU4JIh5LQjDfE@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRZRU4JIh5LQjDfE@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 01:02:43PM +0200, Greg Kroah-Hartman wrote:
> > > I ended up writing this trivial script that did the job well for me
> > > and also supported the "git cherry-pick -x" format that I was using
> > > a lot. Feel free to reuse that as a starting point, here it comes, a
> > > bit covered in dust :-)
> > 
> > Please see previous discussion. Yes, I have my regexps, too, but there
> > are variations, and there were even false positives.. One of them is
> > in this email thread.
> > 
> > Greg suggests to simply ignore context and look for SHA1 sum; that
> > does not work, either.
> 
> The number of patches that your regex does not work on is a very tiny %,
> right?  Can't you just handle those "by hand"?

I agree, that's what I used to do as well and this never caused me
any particular difficult. The rare cases where the script emits no ID
just have to be dealt with manually. It used to happen less than once
per series (with series containing ~1k input patches). I'd say that the
amount of failed backports is roughly in the same order of magnitude as
the ones that could be missed this way, this needs to be put in
perspective!

> > So what I'm asking is for single, easy to parse format. I don't quite
> > care what it is, but
> 
> As long as people end up sending us patches as backports, they will get
> the format wrong in odd ways over time.  Heck, we can't even all get a
> simple signed-off-by: right all the time, look at the kernel logs for
> loads of issues where long-time developers mess that one up.

Plus this adds some cognitive load on those writing these patches, which
increases the global effort. It's already difficult enough to figure the
appropriate Cc list when writing a fix, let's not add more burden in this
chain.

> The phrase "perfect is the enemy of good" or something like that applies
> here.  I'm giving you backported patches "for free", the number of ones
> that someone messes up the text on is so small it should be lost in the
> noise...

I'm also defending this on other projects. I find it important that
efforts are reasonably shared. If tolerating 1% failures saves 20%
effort on authors and adds 2% work on recipients, that's a net global
win. You never completely eliminate mistakes anyway, regardless of the
cost.

Willy
