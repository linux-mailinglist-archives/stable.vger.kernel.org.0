Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCEF124D31
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 17:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbfLRQY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 11:24:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:57508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727640AbfLRQY1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 11:24:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1B90227BF;
        Wed, 18 Dec 2019 16:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576686266;
        bh=Q4e5j7/4SLJOPMSxB0NtqZ2Ns2coqYzN2mxr/D2rKHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NfbBJ5mVaBqNsDOFvJFJkcmF3fQO8TrBQspcO7Db7utJfSe19fPU5IRiGdvVpveEk
         xkcb5e3vuftjSycAgRkp0JKOt/wqbA9GRoTxKCeSa/drLrd7CeJpvrenGvjQgDbfLj
         vi8UnC5pD+mNa7zBxmLob/dNS8kWJ2lFkx0g2nz8=
Date:   Wed, 18 Dec 2019 17:24:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Siddharth Kapoor <ksiddharth@google.com>, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Kernel panic on Google Pixel devices due to regulator patch
Message-ID: <20191218162424.GA482612@kroah.com>
References: <CAJRo92+eD9F6Q60yVY2PfwaPWO_8Dts8QwH7mhpJaem7SpLihg@mail.gmail.com>
 <20191218113458.GA3219@sirena.org.uk>
 <20191218122157.GA17086@kroah.com>
 <20191218131114.GD3219@sirena.org.uk>
 <20191218142219.GB234539@kroah.com>
 <20191218161806.GF3219@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218161806.GF3219@sirena.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 04:18:06PM +0000, Mark Brown wrote:
> On Wed, Dec 18, 2019 at 03:22:19PM +0100, Greg KH wrote:
> > On Wed, Dec 18, 2019 at 01:11:14PM +0000, Mark Brown wrote:
> > > On Wed, Dec 18, 2019 at 01:21:57PM +0100, Greg KH wrote:
> 
> > > > It is, but it's the latest stable kernel (well close to), and your patch
> > > > was tagged by you to be backported to here, so if there's a problem with
> > > > a stable branch, I want to know about it as I don't want to see
> > > > regressions happen in it.
> 
> > > I don't track what's in older stable kernels, it wanted to go back at
> > > least one kernel revision but the issue has been around since forever.
> 
> > Ok, you can always mark patches that way if you want to :)
> 
> That's what a tag to stable with no particular revision attached to it
> is isn't it?

No, that means "drag it as far back as Greg can easily do it" :)

> > > If you don't want to be messing with timing luck then you probably want
> > > to be having a look at what Sasha's bot is doing, it's picking up a lot
> > > of things that are *well* into this sort of territory (and the bad
> > > interactions with out of tree code territory).  I personally would not
> > > be using stable these days if I wasn't prepared to be digging into
> > > something like this.
> 
> > I watch what his bot is doing, and we have tons of testing happening as
> > well, which is reflected by the fact that THIS WAS CAUGHT HERE.  This is
> 
> You don't have anywhere near the level of testing that you'd need to
> cover what the bot is trying to pull in, the subsystem and driver
> coverage is extremely thin relative to the enthusiasm with which things
> are being picked up.  All the pushback I see in review is on me for 
> being conservative about what gets pulled into stable and worrying about
> interactions with out of tree code.
> 
> > a sign that things are working, it's just that some SoC trees are slower
> > than mainline by a few months, and that's fine.  It's worlds better than
> > the SoC trees that are no where close to mainline, and as such, totally
> > insecure :)
> 
> What you appear to have caught here is an interaction with some
> unreviewed vendor code - how much of that is going on in the vendor
> trees you're not testing?  If we want to encourage people to pull in
> stable we should be paying attention to that sort of stuff.

I get weekly merge reports from all of the major SoC vendors when they
pull these releases into their tree and run through their full suite of
tests.  So I am paying attention to this type of thing.

What I need to figure out here is what is going wrong and why the SoC's
testing did not catch this.  That's going to take a bit longer...

thanks,

greg k-h
