Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1AA4181B9
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 13:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240182AbhIYLuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 07:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232363AbhIYLuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Sep 2021 07:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48FFF61051;
        Sat, 25 Sep 2021 11:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632570524;
        bh=a8UuZo3bdG6rQb3Nr5aIHDfG0/Lp/a4tXLoF5g9XDug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hzgTcokKVKwurHrhLXKYEKMNE0VYLV6skwDcvXHT6LpF2/Yj/0s3YsEcGfk2O4iQp
         qQaF8AWHwWzL+V4qrsBJDQnVF3JHBh98zS9CLuygLNkgC91ltfhbR0eDahtKWhbl86
         xixcPXw8RrbEoshlFE+j1X7Vr3KsBPmqCOAdYhyE=
Date:   Sat, 25 Sep 2021 13:48:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Subject: Re: [PATCH 5.10 00/63] 5.10.69-rc1 review
Message-ID: <YU8MmXDKrHi1SLQh@kroah.com>
References: <20210924124334.228235870@linuxfoundation.org>
 <c7a38a76-18b0-efaa-efed-f73e53e58277@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c7a38a76-18b0-efaa-efed-f73e53e58277@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 24, 2021 at 09:12:04AM -0500, Daniel Díaz wrote:
> Hello!
> 
> On 9/24/21 7:44 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.69 release.
> > There are 63 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.69-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Regressions detected.
> 
> While building Perf for arm, arm64, i386 and x86, all with GCC 11, the following error was encountered:
> 
>   util/dso.c: In function 'dso__build_id_equal':
>   util/dso.c:1345:26: error: implicit declaration of function 'memchr_inv'; did you mean 'memchr'? [-Werror=implicit-function-declaration]
>    1345 |                         !memchr_inv(&dso->bid.data[bid->size], 0,
>         |                          ^~~~~~~~~~
>         |                          memchr
>   cc1: all warnings being treated as errors
>   make[4]: *** [/builds/linux/tools/build/Makefile.build:96: /home/tuxbuild/.cache/tuxmake/builds/current/util/dso.o] Error 1
> 
> To reproduce this build locally (for instance):
>   tuxmake \
>     --target-arch=x86_64 \
>     --kconfig=defconfig \
>     --kconfig-add=https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft.config \
>     --kconfig-add=https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft-crypto.config \
>     --kconfig-add=https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/distro-overrides.config \
>     --kconfig-add=https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/systemd.config \
>     --kconfig-add=https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/virtio.config \
>     --kconfig-add=CONFIG_IGB=y \
>     --kconfig-add=CONFIG_UNWINDER_FRAME_POINTER=y \
>     --kconfig-add=CONFIG_FTRACE_SYSCALLS=y \
>     --toolchain=gcc-11 \
>     --runtime=podman \
>     perf

Thanks, will go pick up the needed string.h change for this.

greg k-h
