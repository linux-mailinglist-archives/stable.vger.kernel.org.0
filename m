Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E75B49101D
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 19:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240127AbiAQSOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 13:14:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58378 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbiAQSOD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 13:14:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42FB0B81185;
        Mon, 17 Jan 2022 18:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D950C36AE7;
        Mon, 17 Jan 2022 18:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642443240;
        bh=mYpBeMKz0JgpoIsxFchzZoJyloTy6gtFSseeegYIyP0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pTFLEjEmocRE2SIcod8His/u6iv/kbKnN6UeV9jbByqVXi5YI3UxABGFj4cI1Kk6X
         Q4Ynm1+TYl1HDl2YqvcEfI8z4pQesFQPxCXGKgfSWIVo1XWJWWZk55OBEraVNE+sVT
         wnrAL+GAVPIrivMYaRDLsZODxj7i9QFnf6ytIdsQ=
Date:   Mon, 17 Jan 2022 19:13:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Maciej W. Rozycki" <macro@embecosm.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tty: Revert the removal of the Cyclades public API
Message-ID: <YeWx5aKmG44sWPEI@kroah.com>
References: <alpine.DEB.2.20.2201141832330.11348@tpp.orcam.me.uk>
 <YeKDD6imTh1Y6GuN@kroah.com>
 <alpine.DEB.2.20.2201151231020.11348@tpp.orcam.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.2201151231020.11348@tpp.orcam.me.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 17, 2022 at 05:55:02PM +0000, Maciej W. Rozycki wrote:
> On Sat, 15 Jan 2022, Greg Kroah-Hartman wrote:
> 
> > On Fri, Jan 14, 2022 at 08:54:05PM +0000, Maciej W. Rozycki wrote:
> > > Fix a user API regression introduced with commit f76edd8f7ce0 ("tty: 
> > > cyclades, remove this orphan"), which removed a part of the API and 
> > > caused compilation errors for user programs using said part, such as 
> > > GCC 9 in its libsanitizer component[1]:
> > > 
> > > .../libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc:160:10: fatal error: linux/cyclades.h: No such file or directory
> > >   160 | #include <linux/cyclades.h>
> > >       |          ^~~~~~~~~~~~~~~~~~
> > > compilation terminated.
> > > make[4]: *** [Makefile:664: sanitizer_platform_limits_posix.lo] Error 1
> > 
> > So all we need is an empty header file?  Why bring back all of the
> > unused structures?
> 
>  Because they have become a part of the published API.  Someone may even 
> use a system using headers from the most recent version of the Linux 
> kernel (though not necessarily running such a kernel) to build software 
> intended to run on an older version that still does implement the API.  
> Times where people individually built pefectly matching software from 
> sources to run on each system they looked after have largely long gone.

For hardware-specific things like this, it's not the same.  I can see
adding the .h file as empty just to keep things building, but if no one
is actually ever using the structures and definitions in the file, it
should stay removed.

In looking at the file itself, it just looks like it wants a single
structure, struct cyclades_monitor, and then never actually does
anything with it.

So I guess I should submit a patch to the llvm developers to remove
these lines and add back the single structure definition to allow this
to keep building now?

> > > Any part of the public API is a contract between the kernel and the 
> > > userland and therefore once there it must not be removed even if its 
> > > implementation side has gone and any relevant calls will now fail 
> > > unconditionally.
> > 
> > Does this code actually use any of these structures?
> 
>  Well, they have been exported, so they have become a part of the API.  
> This user program may not use them, another one will.  If you don't want 
> an API to become public, then do not export it in the first place.

That happened a very long time ago, for hardware that no one has, sorry.

So the "ABI" broke when the driver was removed.  Given that no one has
the hardware, no one noticed the breakage, so there is no breakage :)

> > > Revert the part of the commit referred then that affects the user API, 
> > > bringing the most recent version of <linux/cyclades.h> back verbatim 
> > > modulo the removal of trailing whitespace which used to be there, and 
> > > updating <linux/major.h> accordingly.
> > 
> > Why major.h?  What uses that?  No userspace code should care about that.
> 
>  So it shouldn't have been a part of the user API in the first place.  
> Given that it has become a part of it it has to stay, that's the whole 
> point of having a user API.

But what user program uses that value?  I can't seem to find any, so
pointers would be appreciated.

> > Also, your text here is full of trailing whitespace, so I couldn't take
> > this commit as-is anyway :(
> 
>  Well, `git' is supposed to sort it automatically.  I've been routinely 
> feeding my patches as posted to `git am' for other projects so as to push 
> them and any trailing whitespace (added automatically by my e-mail client, 
> I guess for presentation purposes; not to be confused with `format=flowed' 
> arrangement as indicated by `Content-Type:', which I know to avoid) does 
> get stripped as the command executes, clearly prepared for this situation.
> 
>  The same must have happened for my earlier Linux kernel submissions ever 
> since the switch to `git' back in 2005 as they have been correctly applied 
> and no maintainer including you had an issue with it before.  And I have 
> been using the same e-mail client doing the same all over these years.
> 
>  To double-check I have just fed my submission as it to `git am' and it 
> did strip all the unwanted trailing whitespace.  Does that not happen with 
> your setup now?  Odd.

I did not check, I only responded to your email and saw the whitespace
in it.

I'll gladly take a patch that just adds the one needed structure to keep
this file building.  But that's all that is needed unless someone can
point out other code that needs these definitions.

thanks,

greg k-h
