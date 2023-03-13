Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4FA6B7FA5
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 18:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjCMRl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 13:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCMRl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 13:41:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457CA6C8A8;
        Mon, 13 Mar 2023 10:41:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8787ACE1126;
        Mon, 13 Mar 2023 17:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E76FC433EF;
        Mon, 13 Mar 2023 17:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678729311;
        bh=A6j3R8KEfNZMmxp5Zyw8332q03DR+wg12HFr1SVO/QA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m1PtW3uke+FPaAPZihBeOaBXr/yHwIaXn44FdZblfxRzbYlDP8WJEOogUClc3SsXR
         BnjKiGRPRq3xwUBZ59WurJpvYbkf7GUvs7jTc7vLK3rq4jSgRLfa6XaqWgMozfCQjC
         SAt5HtahBMU9alNmTmsmoPYSumWkp43WdemQAd6U=
Date:   Mon, 13 Mar 2023 18:41:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZA9gXRMvQj2TO0W3@kroah.com>
References: <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzH8Ve05SRLYPnR@sashalap>
 <ZAzOgw8Ui4kh1Z3D@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAzOgw8Ui4kh1Z3D@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 10:54:59AM -0800, Eric Biggers wrote:
> On Sat, Mar 11, 2023 at 01:26:57PM -0500, Sasha Levin wrote:
> > 
> > "job"? do you think I'm paid to do this work?
> 
> > Why would I stonewall improvements to the process?
> > 
> > I'm getting a bunch of suggestions and complaints that I'm not implementing
> > those suggestions fast enough on my spare time.
> > 
> > > One of the first things I would do if I was maintaining the stable kernels is to
> > > set up a way to automatically run searches on the mailing lists, and then take
> > > advantage of that in the stable process in various ways.  Not having that is the
> > > root cause of a lot of the issues with the current process, IMO.
> > 
> > "if I was maintaining the stable kernels" - why is this rellevant? give
> > us the tool you've proposed below and we'll be happy to use it. Heck,
> > don't give it to us, use it to review the patches we're sending out for
> > review and let us know if we've missed anything.
> 
> It's kind of a stretch to claim that maintaining the stable kernels is not part
> of your and Greg's jobs.  But anyway, the real problem is that it's currently
> very hard for others to contribute, given the unique role the stable maintainers
> have and the lack of documentation about it.  Each of the two maintainers has
> their own scripts, and it is not clear how they use them and what processes they
> follow.

Just a comment here about our scripts and process.

Our scripts are different as we both currently do different things for
the stable trees.  I have almost no scripts for finding patches, all I
use is a git hook that dumps emails into a mbox and then go through them
and queue them up to the quilt trees based on if they are valid or not
after review.

My scripts primarily are for doing a release, not building the patches
up.

That being said, I do have 2 scripts I use to run on an existing tree or
series to verify that the fixes are all present already (i.e. if we have
fixes for the fixes), but that's not really relevant for this discussion.

Those, and my big "treat the filesystem as a git database" hack can be
found in this repo:
	https://git.sr.ht/~gregkh/linux-stable_commit_tree/
if you are curious, these are probably the relevant scripts if you are
curious:
	https://git.sr.ht/~gregkh/linux-stable_commit_tree/tree/master/item/find_fixes_in_queue
	https://git.sr.ht/~gregkh/linux-stable_commit_tree/tree/master/item/find_fixes_in_range

And I use:
	https://git.sr.ht/~gregkh/linux-stable_commit_tree/tree/master/item/id_found_in
all the time to determine if a SHA1 is in any stable releases.

> (Even just stable-kernel-rules.rst is totally incorrect these days.)

I do not understand this, what is not correct?

It's how to get patches merged into stable kernels, we go
above-and-beyond that for those developers and maintainers that do NOT
follow those rules.  If everyone followed them, we wouldn't be having
this discussion at all :)

> Actually I still don't even know where your scripts are!  They are not in
> stable-queue/scripts, it seems those are only Greg's scripts?  And if I built
> something, how do I know you would even use it?  You likely have all sorts of
> requirements that I don't even know about.

I think what you are talking about here would require new work.  New
tools to dig in the commits to extract "here's the whole series of
patches" would be wonderful, but as others have pointed out, it is
_very_ common to have a cc: stable as the first few commits in a series,
and then the rest have nothing to do with a stable tree.

But when doing something like what AUTOSEL does, digging up the whole
series would be great.  We have tools that can match up every commit in
the tree to a specific email message (presentations on the tool and how
it works have been a previous LinuxCon conferences), but if we can use
lore.kernel.org for it, that would probably help everyone out.

And that's why I use the Link: tag, as Ted pointed out, for everything
that I apply to all of the subsystems I work with.  While I know Linus
doesn't like it, I think it is quite valuable as it makes it so that
_anyone_ can instantly find the thread where the patch came from, and no
external tools are required.

Anyway, as always, I gladly accept help with figuring out what commits
to apply to stable kernels.  I've always said this, and Sasha has
stepped up in an amazing way here over the years, creating tools based
on collaboration with many others (see his presentations at conferences
with Julia) on how to dig into the kernel repo to find patches that we
all forget to tag for stable kernels and he sends them out for review.

If you want to help out and do much the same thing using different sorts
of tools, or come up with other ways of finding the bugfixes that are in
there that are not properly tagged, wonderful, I will gladly accept
them, I have never turned down help like this.

And that's what I ask from companies all the time when they say "what
can we do to help out?"  A simple thing to do is dig in your vendor
trees and send me the fixes that you have backported there.  I know
distros have this (and some distros help out and do this, I'll call out
Debian for being very good here), and some companies do submit their
backports as well (Amazon and Hawaii are good, Android also does a good
job), but they are rare compared to all of the groups that I know use
Linux.

Anyway, if anyone noticed the big problems this weekend with the stable
releases were due to patches that were actually tagged with "cc: stable"
so that's kind of proof that we all are human and even when we think a
fix is enough, it can cause problems when it hits real world testing.

We are all human, the best we can do is when confronted with "hey, this
fix causes a problem" is revert it and get the fix out to people as
quick as possible.  That includes fixes picked from tools like AUTOSEL
as well as manual tags, there is no difference here in our response.

thanks,

greg k-h
