Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1656F3C62FE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 20:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236061AbhGLS5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 14:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236052AbhGLS5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 14:57:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2C6F61221;
        Mon, 12 Jul 2021 18:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626116061;
        bh=6FlVRup+haoO14SFNrM2GwJKIqFzhrX/it8SC/NvuCE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FGqsXp01a4HmETyFhL+5ojrVBu1PHy/oUWEMDQGceuUhKe0uTr0NW7LZs0zMyQdZ4
         Bj5paSOO1/wVDb7PDwzwma/FRnSUd2xVjzCypLrGPLW1MrF938t0IWu5j8LVcUh/AZ
         W+IORi0Ahm6obq3zz797NtxVXY6cTyGwraeQiqfM=
Date:   Mon, 12 Jul 2021 20:54:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>, nathanl@linux.ibm.com
Subject: Re: [PATCH 5.4 000/348] 5.4.132-rc1 review
Message-ID: <YOyP28+HzWMTVghS@kroah.com>
References: <20210712060659.886176320@linuxfoundation.org>
 <CA+G9fYu6+hex77zTHTCopRvSVpCfxPjLydEL3Ew+92poZkncSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYu6+hex77zTHTCopRvSVpCfxPjLydEL3Ew+92poZkncSw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 06:37:26PM +0530, Naresh Kamboju wrote:
> On Mon, 12 Jul 2021 at 11:45, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.132 release.
> > There are 348 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.132-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> 
> Regressions found on powerpc:
> 
>  - build/gcc-10-cell_defconfig
>  - build/gcc-8-defconfig
>  - build/gcc-10-defconfig
>  - build/gcc-9-defconfig
>  - build/gcc-9-maple_defconfig
>  - build/gcc-8-maple_defconfig
>  - build/gcc-8-cell_defconfig
>  - build/gcc-10-maple_defconfig
>  - build/gcc-9-cell_defconfig
> 
> The following patch caused build warnings / errors on powerpc.
> 
> > Michael Ellerman <mpe@ellerman.id.au>
> >     powerpc/stacktrace: Fix spurious "stale" traces in raise_backtrace_ipi()
> 
> 
> Build error:
> ------------
> arch/powerpc/kernel/stacktrace.c: In function 'raise_backtrace_ipi':
> arch/powerpc/kernel/stacktrace.c:248:5: error: implicit declaration of
> function 'udelay' [-Werror=implicit-function-declaration]
>   248 |     udelay(1);
>       |     ^~~~~~
> cc1: all warnings being treated as errors
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> steps to reproduce:
> -------------------------
> # TuxMake is a command line tool and Python library that provides
> # portable and repeatable Linux kernel builds across a variety of
> # architectures, toolchains, kernel configurations, and make targets.
> #
> # TuxMake supports the concept of runtimes.
> # See https://docs.tuxmake.org/runtimes/, for that to work it requires
> # that you install podman or docker on your system.
> #
> # To install tuxmake on your system globally:
> # sudo pip3 install -U tuxmake
> #
> # See https://docs.tuxmake.org/ for complete documentation.
> 
> tuxmake --runtime podman --target-arch powerpc --toolchain gcc-10
> --kconfig defconfig
> 
> 
> build log link,
> https://builds.tuxbuild.com/1vChzZyzmKmQCN2cLMtRBR5kbdI/

Pushed out a -rc2.

thanks,

greg k-h
