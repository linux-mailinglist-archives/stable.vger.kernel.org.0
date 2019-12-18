Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBF1212495A
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 15:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfLROWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 09:22:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbfLROWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 09:22:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3489221582;
        Wed, 18 Dec 2019 14:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576678941;
        bh=/UjqDyzjbvIKHTulD+dMMrNEcLl1BmQiEXTeF2hiEDs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UNljiLX6NgVr8aVUAQdnaMDRxGmGnHfXjIzUrGe+S1id4TqMcCjOD6HAM3DVEvCu5
         llSJDu4YKTWDLGhkycByZ4C8qOv5xYaUWcyqk+y+Fe1OggEXydqkjka2fXLDdQXT6r
         AHj9uMAE6ItVxY9TCgvsGi8Qo1DPtnHIXAkwYSI0=
Date:   Wed, 18 Dec 2019 15:22:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Siddharth Kapoor <ksiddharth@google.com>, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Kernel panic on Google Pixel devices due to regulator patch
Message-ID: <20191218142219.GB234539@kroah.com>
References: <CAJRo92+eD9F6Q60yVY2PfwaPWO_8Dts8QwH7mhpJaem7SpLihg@mail.gmail.com>
 <20191218113458.GA3219@sirena.org.uk>
 <20191218122157.GA17086@kroah.com>
 <20191218131114.GD3219@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218131114.GD3219@sirena.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 01:11:14PM +0000, Mark Brown wrote:
> On Wed, Dec 18, 2019 at 01:21:57PM +0100, Greg KH wrote:
> > On Wed, Dec 18, 2019 at 11:34:58AM +0000, Mark Brown wrote:
> > > On Tue, Dec 17, 2019 at 11:51:55PM +0800, Siddharth Kapoor wrote:
> 
> > > > I would like to share a concern with the regulator patch which is part of
> > > > 4.9.196 LTS kernel.
> 
> > > That's an *extremely* old kernel.
> 
> > It is, but it's the latest stable kernel (well close to), and your patch
> > was tagged by you to be backported to here, so if there's a problem with
> > a stable branch, I want to know about it as I don't want to see
> > regressions happen in it.
> 
> I don't track what's in older stable kernels, it wanted to go back at
> least one kernel revision but the issue has been around since forever.

Ok, you can always mark patches that way if you want to :)

> > > I've got nothing to do with the stable kernels so there's nothing I can
> > > do here, sorry.
> 
> > Should I revert it everywhere?  This patch reads as it should be fixing
> > problems, not causing them :)
> 
> The main targets were whatever Debian and Ubuntu are shipping (and to a
> lesser extent SuSE or RHEL but they don't use stable directly), it's
> less relevant to anything that only gets used on embedded stuff.  It's
> right on the knife edge of what I'd backport but since that's way less
> enthusiastic than stable is in general these days.

I've reverted it now from 4.14.y and 4.9.y.

> > > Possibly your GPU supplies need to be flagged as always on, possibly
> > > your GPU driver is forgetting to enable some supplies it needs, or
> > > possibly there's a missing always-on constraint on one of the regulators
> > > depending on how the driver expects this to work (if it's a proprietary
> > > driver it shouldn't be using the regulator API itself).  I'm quite
> > > surprised you've not seen any issue before given that the supplies would
> > > still be being disabled earlier.
> 
> > Timing "luck" is probably something we shouldn't be messing with in
> > stable kernels.  How about I revert this for the 4.14 and older releases
> > and let new devices deal with the timing issues when they are brought up
> > on new hardware?
> 
> To be clear this is more a straight up bug in their stuff than the sort
> of thing you'd normally think of as a race condition, we're talking
> about moving the timing by 30 seconds here.  The case that we saw
> already was just a clear and obvious bug that was made more visible (the
> driver was using the wrong name for a supply so lookups were always
> failing but some sequence of events meant it didn't produce big runtime
> failures).
> 
> If you don't want to be messing with timing luck then you probably want
> to be having a look at what Sasha's bot is doing, it's picking up a lot
> of things that are *well* into this sort of territory (and the bad
> interactions with out of tree code territory).  I personally would not
> be using stable these days if I wasn't prepared to be digging into
> something like this.

I watch what his bot is doing, and we have tons of testing happening as
well, which is reflected by the fact that THIS WAS CAUGHT HERE.  This is
a sign that things are working, it's just that some SoC trees are slower
than mainline by a few months, and that's fine.  It's worlds better than
the SoC trees that are no where close to mainline, and as such, totally
insecure :)

thanks,

greg k-h
