Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A82337D21D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240840AbhELSEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243991AbhELR5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 13:57:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CC226101A;
        Wed, 12 May 2021 17:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620842203;
        bh=uPk0tjKHI/wUcLVdmGHeXXyKlhgkkSi7MDoFAUTa6Oc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FDm4sadzByuZig7gHU3hlHkcwVKy+igRBpOZaEb3HkHqysfLWf21vFMXnki9E5+sb
         T6NfPBn7SIHe6/8HaShYDZIHuKbI4mrQfnA2HJ5x3FzAaVKPKeuAaarWY4It+3xxuc
         +amRBuKPR2yhEaiLkC0VsFfCq5bdlkkRk5Y5naSw=
Date:   Wed, 12 May 2021 19:56:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: Re: [PATCH 5.12 000/677] 5.12.4-rc1 review
Message-ID: <YJwW2bNXGZw5kmpo@kroah.com>
References: <20210512144837.204217980@linuxfoundation.org>
 <CA+G9fYufHvM+C=39gtk5CF-r4sYYpRkQFGsmKrkdQcXj_XKFag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYufHvM+C=39gtk5CF-r4sYYpRkQFGsmKrkdQcXj_XKFag@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 10:53:04PM +0530, Naresh Kamboju wrote:
> On Wed, 12 May 2021 at 21:27, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.12.4 release.
> > There are 677 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.4-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> MIPS Clang build regression detected.
> MIPS gcc-10,9 and 8 build PASS.
> 
> > Maciej W. Rozycki <macro@orcam.me.uk>
> >     MIPS: Reinstate platform `__div64_32' handler
> 
> mips clang build breaks on stable rc 5.4 .. 5.12 due to below warnings / errors
>  - mips (defconfig) with clang-12
>  - mips (tinyconfig) with clang-12
>  - mips (allnoconfig) with clang-12
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=mips
> CROSS_COMPILE=mips-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
> clang'
> kernel/time/hrtimer.c:318:2: error: couldn't allocate output register
> for constraint 'x'
>         do_div(tmp, (u32) div);
>         ^
> include/asm-generic/div64.h:243:11: note: expanded from macro 'do_div'
>                 __rem = __div64_32(&(n), __base);       \
>                         ^
> arch/mips/include/asm/div64.h:74:11: note: expanded from macro '__div64_32'
>                 __asm__("divu   $0, %z1, %z2"                           \
>                         ^
> 1 error generated.

Does this also show up in Linus's tree?  The same MIPS patch is there as
well from what I can tell.

thanks,

greg k-h
