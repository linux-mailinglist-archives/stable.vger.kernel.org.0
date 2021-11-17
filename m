Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637A145424F
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 09:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbhKQIHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 03:07:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234361AbhKQIHU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 03:07:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 471A56128E;
        Wed, 17 Nov 2021 08:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637136261;
        bh=/bUNu6RYIDPX9QryFzHMAfZKyVd7ptBfWpCDj/JWskM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0UYu0JFzLLO1TEVV5fsYRhvGUSzAThkMIake97IVs/qYDAlSofde4nQeGrhoOx0n5
         UUAyv55GwBoFyGK7Nwx1idDWA+6DKO2g+uLWV/99iHrhTNv7KqKwvlzGKaN+PpXF4z
         w7Av/1ZB9CDpWx+lOf76PKaShfnJgbnvk9s4ZmYg=
Date:   Wed, 17 Nov 2021 09:04:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Scott Bruce <smbruce@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/927] 5.15.3-rc2 review
Message-ID: <YZS3gwvOOXu0Vmzv@kroah.com>
References: <20211116142631.571909964@linuxfoundation.org>
 <4ef11d86-28f6-69c8-ed79-926d39bdc13d@gmail.com>
 <CAPOoXdHjqm=9K5BHc8p48NEf0jzZ92yiZZFQwmhGMxcTAX020w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPOoXdHjqm=9K5BHc8p48NEf0jzZ92yiZZFQwmhGMxcTAX020w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 09:41:07PM -0800, Scott Bruce wrote:
> On 11/16/21 13:59, Scott Bruce wrote:
> > On 11/16/21 07:01, Greg Kroah-Hartman wrote:
> >> This is the start of the stable review cycle for the 5.15.3 release.
> >> There are 927 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc2.gz
> >>
> >> or in the git tree and branch at:
> >>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >> linux-5.15.y
> >> and the diffstat can be found below.
> >>
> >> thanks,
> >>
> >> greg k-h
> >>
> >
> > Regression found on x86-64 AMD (ASUS GA503QR, Cezanne platform)
> > somewhere between 7f9a9d5d9983 and 5.15.3-rc1. The very early -rc1 tag
> > from a day and a half ago boots fine, -rc1 final and -rc2 boot into a
> > kernel panic during init.
> >
> > Unfortunately I can't gather any useful debug info from the panic as the
> > relevant bits are instantly pushed off the screen by rest of the dump.
> >
> > Here's what I'm left with on screen after the panic, hopefully someone
> > can get something useful out of it:
> > https://photos.app.goo.gl/6FrYPfZCY6YdnPDz6
> >
> > I'll bisect and try to narrow this down some today but I'm running
> > builds on my laptop while I work so it won't be super quick.
> >
> > Scott
> 
> Reverting c3fc9d9e8f2dc518a8ce3c77f833a11b47865944 "x86: Fix
> __get_wchan() for !STACKTRACE" resolves this issue.
> 
> With this revert in place 5.15.3-rc2 boots successfully with no dmesg
> regressions on my AMD Cezanne laptop, I'll wait for actual use
> tomorrow to leave a proper
> tested by.

This is odd.  Do you see the same issues in 5.16-rc1?  We want this
commit in here as we "need" bc9bbb81730e ("x86: Fix get_wchan() to
support the ORC unwinder") because it fixes things that are reported to
be broken.

thanks,

greg k-h
