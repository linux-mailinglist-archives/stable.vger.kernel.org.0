Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889BB45C992
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 17:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242693AbhKXQOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 11:14:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:35070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241850AbhKXQOR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 11:14:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDA1560555;
        Wed, 24 Nov 2021 16:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637770267;
        bh=mhLmVMbk0BJKOicWvUur/RgHJCebPGhLLSszX4OIlQc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rhlAhvby6NnTyGolJY8Vp+tuyzh93IQ1mn6oKfegqQhRDCv7FArcyMyzJz6lgXcxl
         LKfJJqDQF2+ZEkHJxXxOwecLzfTfhZStMkQucNudsGXa0quW+O07n3BLypC2x100JJ
         eHjpIQwuM2uOw7hxtJgW9JbPugMemc7dcih6lyNc=
Date:   Wed, 24 Nov 2021 17:11:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dmitry Osipenko <digetx@gmail.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH 5.10 000/154] 5.10.82-rc1 review
Message-ID: <YZ5kGOT+ifbPgL+B@kroah.com>
References: <20211124115702.361983534@linuxfoundation.org>
 <CA+G9fYsmeKPRicvsjwT3gfQurf-k=15vm+kNCCKfOOoyAQE1oQ@mail.gmail.com>
 <14fbe436-7bd0-5310-6e06-1c3b006b7916@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <14fbe436-7bd0-5310-6e06-1c3b006b7916@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 06:27:43PM +0300, Dmitry Osipenko wrote:
> 24.11.2021 18:16, Naresh Kamboju пишет:
> > On Wed, 24 Nov 2021 at 18:21, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >>
> >> This is the start of the stable review cycle for the 5.10.82 release.
> >> There are 154 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.82-rc1.gz
> >> or in the git tree and branch at:
> >>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> >> and the diffstat can be found below.
> >>
> >> thanks,
> >>
> >> greg k-h
> > 
> > Regression found on arm gcc-11 builds
> > As I have already reported,
> > https://lore.kernel.org/stable/CA+G9fYskrxZvmrjhO32Q9r7mb1AtKdLBm4OvDNvt5v4PTgm4pA@mail.gmail.com/
> > 
> > drivers/cpuidle/cpuidle-tegra.c: In function 'tegra_cpuidle_probe':
> > drivers/cpuidle/cpuidle-tegra.c:349:38: error:
> > 'TEGRA_SUSPEND_NOT_READY' undeclared (first use in this function); did
> > you mean 'TEGRA_SUSPEND_NONE'?
> >   349 |  if (tegra_pmc_get_suspend_mode() == TEGRA_SUSPEND_NOT_READY)
> >       |                                      ^~~~~~~~~~~~~~~~~~~~~~~
> >       |                                      TEGRA_SUSPEND_NONE
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > Due to the following patch,
> > 
> > cpuidle: tegra: Check whether PMC is ready
> > [ Upstream commit bdb1ffdad3b73e4d0538098fc02e2ea87a6b27cd ]
> 
> Hi Greg and all,
> 
> Greg, could you please drop this patch from the stable trees? It
> shouldn't be backported since the actual offending patch which causes
> the "fixed" problem is still pending to be merged. I assumed that all
> patches would be merged much earlier when was typing the commit message,
> but only a part of patches were merged yet. Sorry for noticing this so late.

Now dropped from both 5.15 and 5.10 queues, thanks.

greg k-h
