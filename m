Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E9C37EDB8
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387993AbhELUla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387194AbhELUdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 16:33:02 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AC30C0612AD;
        Wed, 12 May 2021 13:23:49 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id BA9D992009C; Wed, 12 May 2021 22:22:21 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id AD48792009B;
        Wed, 12 May 2021 22:22:21 +0200 (CEST)
Date:   Wed, 12 May 2021 22:22:21 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Nathan Chancellor <nathan@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: Re: [PATCH 5.12 000/677] 5.12.4-rc1 review
In-Reply-To: <YJwnb4BwQEr7xFsV@kroah.com>
Message-ID: <alpine.DEB.2.21.2105122213440.3032@angie.orcam.me.uk>
References: <20210512144837.204217980@linuxfoundation.org> <CA+G9fYufHvM+C=39gtk5CF-r4sYYpRkQFGsmKrkdQcXj_XKFag@mail.gmail.com> <YJwW2bNXGZw5kmpo@kroah.com> <CA+G9fYvbe9L=3uJk2+5fR_e2-fnw=UXSDRnHh+u3nMFeOjOwjg@mail.gmail.com> <YJwjuJrYiyS/eeR8@kroah.com>
 <8615959b-9054-5c9f-0afa-f15672274d12@kernel.org> <YJwnb4BwQEr7xFsV@kroah.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 12 May 2021, Greg Kroah-Hartman wrote:

> > > > > > mips clang build breaks on stable rc 5.4 .. 5.12 due to below warnings / errors
> > > > > >   - mips (defconfig) with clang-12
> > > > > >   - mips (tinyconfig) with clang-12
> > > > > >   - mips (allnoconfig) with clang-12
> > > > > > 
> > > > > > make --silent --keep-going --jobs=8
> > > > > > O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=mips
> > > > > > CROSS_COMPILE=mips-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
> > > > > > clang'
> > > > > > kernel/time/hrtimer.c:318:2: error: couldn't allocate output register
> > > > > > for constraint 'x'
> > > > > >          do_div(tmp, (u32) div);
> > > > > >          ^
> > > > > > include/asm-generic/div64.h:243:11: note: expanded from macro 'do_div'
> > > > > >                  __rem = __div64_32(&(n), __base);       \
> > > > > >                          ^
> > > > > > arch/mips/include/asm/div64.h:74:11: note: expanded from macro '__div64_32'
> > > > > >                  __asm__("divu   $0, %z1, %z2"                           \
> > > > > >                          ^
> > > > > > 1 error generated.
> > > > > 
> > > > > Does this also show up in Linus's tree?  The same MIPS patch is there as
> > > > > well from what I can tell.
> > > > 
> > > > No.
> > > > Linus's tree builds MIPS clang successfully.
> > > 
> > > Ick, ok, I'll go drop this and let a MIPS developer send us the correct
> > > thing.
> > > 
> > > thanks!
> > > 
> > > greg k-h
> > > 
> > 
> > I think you just need to grab commits c1d337d45ec0 ("MIPS: Avoid DIVU in
> > `__div64_32' is result would be zero") and 25ab14cbe9d1 ("MIPS: Avoid
> > handcoded DIVU in `__div64_32' altogether") to fix this up.
> 
> It was easier for me to drop it, let's see if any MIPS developers (are
> there any anymore?) care enough to send the proper series.

 Thomas, I told you it would work better if the original fix was replaced 
ahead of a pull request to Linus rather than updated with the follow-ups.  

 Will you be able to fix up the mess in this case?  I can offer no more 
than just the commits quoted above, there's no better fix.

  Maciej
