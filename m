Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74164457A0
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 17:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhKDQzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 12:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231877AbhKDQzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 12:55:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3795261216;
        Thu,  4 Nov 2021 16:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636044764;
        bh=yRVr9keMGKNSa+th5PoR/sf/KzW0RShCR838UP56c10=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dqRK/3xxaVyETPIofpyT8Oo+Q4pnqtyXmiF1KEObnxUnuojTcya0U+tl3tsdSj9k2
         hboScg7Kj2MAhhp3Vqd/5Kdpeif3MA7eCWjLQ5s7W3kNJ38/m+Ppp3e8Mm0fyVTIJQ
         4on4ufcheSgi8TlkCdBWqqUv10YSSwQ4HlqpXuFo=
Date:   Thu, 4 Nov 2021 17:52:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 5.10 00/16] 5.10.78-rc1 review
Message-ID: <YYQP2jGVxhMUlcMH@kroah.com>
References: <20211104141159.561284732@linuxfoundation.org>
 <3971a9b4-ebb6-a789-2143-31cf257d0d38@linaro.org>
 <YYQIUhHkv3kUY+UC@kroah.com>
 <acabc414-164b-cd65-6a1a-cf912d8621d7@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <acabc414-164b-cd65-6a1a-cf912d8621d7@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 09:46:49AM -0700, Guenter Roeck wrote:
> On 11/4/21 9:20 AM, Greg Kroah-Hartman wrote:
> > On Thu, Nov 04, 2021 at 09:53:57AM -0600, Daniel Díaz wrote:
> > > Hello!
> > > 
> > > On 11/4/21 8:12 AM, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.10.78 release.
> > > > There are 16 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.78-rc1.gz
> > > > or in the git tree and branch at:
> > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > Regressions detected.
> > > 
> > > Build failures on all architectures and all toolchains (GCC 8, 9, 10, 11; Clang 10, 11, 12, 13, nightly):
> > > - arc
> > > - arm (32-bits)
> > > - arm (64-bits)
> > > - i386
> > > - mips
> > > - parisc
> > > - ppc
> > > - riscv
> > > - s390
> > > - sh
> > > - sparc
> > > - x86
> > > 
> > > Failures look like this:
> > > 
> > >    In file included from /builds/linux/include/linux/kernel.h:11,
> > >                     from /builds/linux/include/linux/list.h:9,
> > >                     from /builds/linux/include/linux/smp.h:12,
> > >                     from /builds/linux/include/linux/kernel_stat.h:5,
> > >                     from /builds/linux/mm/memory.c:42:
> > >    /builds/linux/mm/memory.c: In function 'finish_fault':
> > >    /builds/linux/mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHWPoisoned'; did you mean 'PageHWPoison'? [-Werror=implicit-function-declaration]
> > >     3929 |  if (unlikely(PageHasHWPoisoned(page)))
> > >          |               ^~~~~~~~~~~~~~~~~
> > >    /builds/linux/include/linux/compiler.h:78:42: note: in definition of macro 'unlikely'
> > >       78 | # define unlikely(x) __builtin_expect(!!(x), 0)
> > >          |                                          ^
> > >    cc1: some warnings being treated as errors
> > > 
> > > and this:
> > > 
> > >    /builds/linux/mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHWPoisoned' [-Werror,-Wimplicit-function-declaration]
> > >            if (unlikely(PageHasHWPoisoned(page)))
> > >                         ^
> > > 
> > >    /builds/linux/mm/page_alloc.c:1237:4: error: implicit declaration of function 'ClearPageHasHWPoisoned' [-Werror,-Wimplicit-function-declaration]
> > >                            ClearPageHasHWPoisoned(page);
> > >                            ^
> > >    /builds/linux/mm/page_alloc.c:1237:4: note: did you mean 'ClearPageHWPoison'?
> > > 
> > 
> > What configuration?  This builds for me on x86 here on allmodconfig.
> > 
> 
> defconfig, and anything with CONFIG_MEMORY_FAILURE=n or CONFIG_TRANSPARENT_HUGEPAGE=n.
> Fix needs upstream commit e66435936756d (presumably, I did not check).

Odd, no, I don't think that commit will help.

I'll go drop the offending commit now and push out a -rc2.

thanks,

greg k-h
