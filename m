Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7797223CF83
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgHETWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728974AbgHERl5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 13:41:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4278622DA7;
        Wed,  5 Aug 2020 13:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596633585;
        bh=072fN8XULJ3GnIEr8wRSchi/EZ5F0AyXnHwkMRtM7H0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ATKVciyP2hiiV/sTIP+/3bRy8Wt+Ss9WmoAhzw03zM+TBYObx72cq9tBLjd2hZuIB
         /QadkCneyZrKLECnJk6R74hP0T7jrTimV3twXcj/uQyEHSMNoHXCqyG9w3xZ9cQSiZ
         6ZzUV+yHAU14zeRzkccZlZvwGovCB7FttwBqnBaM=
Date:   Wed, 5 Aug 2020 15:20:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 5.7 000/121] 5.7.13-rc2 review
Message-ID: <20200805132003.GE1822283@kroah.com>
References: <20200804072435.385370289@linuxfoundation.org>
 <CA+G9fYs35Eiq1QFM0MOj6Y7gC=YKaiknCPgcJpJ5NMW4Y7qnYQ@mail.gmail.com>
 <20200804082130.GA1768075@kroah.com>
 <CAHk-=whJ=shbf-guMGZkGvxh9fVmbrvUuiWO48+PDFG7J9A9qw@mail.gmail.com>
 <c32ad2216ca3dd83d6d3d740512db9de@kernel.org>
 <20200805095439.GB1634853@kroah.com>
 <813c64c8dbe037b9d84763f56c4dbb7d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <813c64c8dbe037b9d84763f56c4dbb7d@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 05, 2020 at 12:19:58PM +0100, Marc Zyngier wrote:
> On 2020-08-05 10:54, Greg Kroah-Hartman wrote:
> > On Tue, Aug 04, 2020 at 10:23:06PM +0100, Marc Zyngier wrote:
> > > On 2020-08-04 19:33, Linus Torvalds wrote:
> > > > On Tue, Aug 4, 2020 at 1:21 AM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > So Linus's tree is also broken here.
> > > >
> > > > No, there's 835d1c3a9879 ("arm64: Drop unnecessary include from
> > > > asm/smp.h") upstream.
> > > 
> > > My bet is that Greg ended up with this patch backported to
> > > 5.7, but doesn't have 62a679cb2825 ("arm64: simplify ptrauth
> > > initialization") as the latter isn't a fix.
> > > 
> > > I don't think any of these two patches are worth backporting,
> > > to be honest.
> > 
> > I didn't have either of those patches, so I can try applying them to see
> > if the build errors go away.  But if you don't think they should be
> > applied, what should I do?
> > 
> > Here's what I did have queued up:
> > 
> > f227e3ec3b5c ("random32: update the net random state on interrupt and
> > activity")
> > aa54ea903abb ("ARM: percpu.h: fix build error")
> > 1c9df907da83 ("random: fix circular include dependency on arm64 after
> > addition of percpu.h")
> > 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy
> > gcc plugin")
> > c0842fbc1b18 ("random32: move the pseudo-random 32-bit definitions to
> > prandom.h")
> 
> Not what I expected, then. I stand corrected.
> 
> > And that caused the builds to blow up.
> > 
> > So, what should I do here?
> 
> OK, this is getting hairy. I solved it by grabbing:
> 
> d0055da5266a ("arm64: remove ptrauth_keys_install_kernel sync arg")
> 62a679cb2825 ("arm64: simplify ptrauth initialization")
> 
> and at which point you might as well take 835d1c3a9879 despite
> everything I said earlier. And backporting that further down the
> line is fraught with danger.
> 
> I came up with yet another "quality" hack, which gets the job done,
> see below. It is obviously much simpler, but also terribly ugly.

I like it :)

I've taken it for 5.7.y, and modified it a bit for 5.4.y, and don't
think it's needed on anything older, but let's see what blows up...

thanks!

greg k-h
