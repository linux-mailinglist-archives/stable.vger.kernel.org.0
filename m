Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A246311BF1
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 08:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBFHXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 02:23:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229715AbhBFHXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Feb 2021 02:23:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8643864FD1;
        Sat,  6 Feb 2021 07:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612596190;
        bh=13wxReQcfjFneIEOZSyiWPFborDcoVVkk5DRCF3mq4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=poRfP7Dr3sqni1xZBHNINNWJKnP5CRzJXXfjXBa/m0jjk5pqThMhs2EpeGFZebu4Q
         2cKrEXae3cpeK29/rgVBugHpqFvLF7m9jLTqBZDNJM8GUGH1qDrFveeAqkokjTDEb4
         Db2hDDvRXcXA6GUzl5h3WdUd78hL3EroJhHCw+As=
Date:   Sat, 6 Feb 2021 08:23:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Jari Ruusu <jariruusu@protonmail.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        masahiroy@kernel.org
Subject: Re: Kernel version numbers after 4.9.255 and 4.4.255
Message-ID: <YB5D2iX5s53Q8MB6@kroah.com>
References: <7pR0YCctzN9phpuEChlL7_SS6auHOM80bZBcGBTZPuMkc6XjKw7HUXf9vZUPi-IaV2gTtsRVXgywQbja8xpzjGRDGWJsVYSGQN5sNuX1yaQ=@protonmail.com>
 <YBuSJqIG+AeqDuMl@kroah.com>
 <78ada91b-21ee-563f-9f75-3cbaeffafad4@kernel.org>
 <YBu1d0+nfbWGfMtj@kroah.com>
 <20210205090659.GA22517@amd>
 <YB0Q3UUzTUmgvH7V@kroah.com>
 <20210205184412.GA20410@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205184412.GA20410@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 07:44:12PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > Ugh, I thought this was an internal representation, not an external one
> > > > :(
> > > > 
> > > > > It might work somewhere, but there are a lot of (X * 65536 + Y * 256 + Z)
> > > > > assumptions all around the world. So this doesn't look like a good idea.
> > > > 
> > > > Ok, so what happens if we "wrap"?  What will break with that?  At first
> > > > glance, I can't see anything as we keep the padding the same, and our
> > > > build scripts seem to pick the number up from the Makefile and treat it
> > > > like a string.
> > > > 
> > > > It's only the crazy out-of-tree kernel stuff that wants to do minor
> > > > version checks that might go boom.  And frankly, I'm not all that
> > > > concerned if they have problems :)
> > > > 
> > > > So, let's leave it alone and just see what happens!
> > > 
> > > Yeah, stable is a great place to do the experiments. Not that this is
> > > the first time :-(.
> > 
> > How else can we "test this out"?
> > 
> > Should I do an "empty" release of 4.4.256 and see if anyone complains?
> 
> It seems that would be bad idea, as it would cause problems when stuff
> is compiled on 4.4.256, not simply by running it.
> 
> Sasha's patch seems like one option that could work.
> 
> Even safer option is to switch to 4.4.255-st1, 4.4.255-st2 ... scheme.

Using EXTRAVERSION would work, but it is effectivly the same thing as
nothing exports that to userspace through the LINUX_VERSION macro.

So clamping the version like Sasha's patches seems to be the best
solution.

thanks,

greg k-h
