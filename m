Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6F730F87E
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 17:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238135AbhBDQuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 11:50:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238118AbhBDQsy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 11:48:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFECC64DA3;
        Thu,  4 Feb 2021 16:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612457293;
        bh=XFs0VAuDxw0PgpvNH4+/XNKhcukc6dJkT0donvjsDTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dvEQU7mD+yC4zlV1QyQpO5Xfg/BZT8mIXuk35br3aM/07obutBF6xlhhreIOcOsbg
         DxooHzE7Wl3KjQNCA6/bUMUfwJ9JTP/bHOkOc28izycBGDNVto+Qdbl9qzVyblD4bZ
         wuq+av0rOpALgXYkrhGZTETw/EJXSVplEYLyFuXE=
Date:   Thu, 4 Feb 2021 17:48:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Jiri Slaby' <jirislaby@kernel.org>,
        Jari Ruusu <jariruusu@protonmail.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>
Subject: Re: Kernel version numbers after 4.9.255 and 4.4.255
Message-ID: <YBwlSi85/IA5HytP@kroah.com>
References: <7pR0YCctzN9phpuEChlL7_SS6auHOM80bZBcGBTZPuMkc6XjKw7HUXf9vZUPi-IaV2gTtsRVXgywQbja8xpzjGRDGWJsVYSGQN5sNuX1yaQ=@protonmail.com>
 <YBuSJqIG+AeqDuMl@kroah.com>
 <78ada91b-21ee-563f-9f75-3cbaeffafad4@kernel.org>
 <YBu1d0+nfbWGfMtj@kroah.com>
 <a85b7749-38b2-8ce9-c15a-8acb9a54c5b5@kernel.org>
 <b17b4c3b2e4b45f9b10206b276b7d831@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b17b4c3b2e4b45f9b10206b276b7d831@AcuMS.aculab.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 04, 2021 at 04:28:19PM +0000, David Laight wrote:
> From: Jiri Slaby
> > Sent: 04 February 2021 11:01
> > 
> > On 04. 02. 21, 9:51, Greg Kroah-Hartman wrote:
> > >> It might work somewhere, but there are a lot of (X * 65536 + Y * 256 + Z)
> > >> assumptions all around the world. So this doesn't look like a good idea.
> > >
> > > Ok, so what happens if we "wrap"?  What will break with that?  At first
> > > glance, I can't see anything as we keep the padding the same, and our
> > > build scripts seem to pick the number up from the Makefile and treat it
> > > like a string.
> > >
> > > It's only the crazy out-of-tree kernel stuff that wants to do minor
> > > version checks that might go boom.  And frankly, I'm not all that
> > > concerned if they have problems :)
> > 
> > Agreed. But currently, sublevel won't "wrap", it will "overflow" to
> > patchlevel. And that might be a problem. So we might need to update the
> > header generation using e.g. "sublevel & 0xff" (wrap around) or
> > "sublevel > 255 : 255 : sublevel" (be monotonic and get stuck at 255).
> > 
> > In both LINUX_VERSION_CODE generation and KERNEL_VERSION proper.
> 
> A full wrap might catch checks for less than (say) 4.4.2 which
> might be present to avoid very early versions.

Who does that?

> So sticking at 255 or wrapping onto (say) 128 to 255 might be better.

Better how?

> I'm actually intrigued about how often you expect people to update
> systems running these LTS kernels.

Whenever they can, and should.

> At a release every week it takes 5 years to run out of sublevels.
> No one is going to reboot a server anywhere near that often.

Why not?

Usually kernels this old are stuck in legacy embedded systems, like last
year's new phone models :)

thanks,

greg k-h
