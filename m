Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97169344874
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 16:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhCVPAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 11:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230113AbhCVPA2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 11:00:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FC4F619AA;
        Mon, 22 Mar 2021 15:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616425226;
        bh=Tdl+jH0DCIHhMb38FkH2YhNtJCVJTdPV88LbcXPwM1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VuDjKR5WvLIrDs4yXI1DXjAtxGW73aRo6U1NreSlOD5tU+Q4+Z7qVKuoBY6gln5VN
         4KpYhsfzp70ugauxrjHmRc/oZY2SoVUEC4DOQotflhTPPLS57MRzfyq2ugmp/ZXcjS
         3EFa4qkWQH4HD0dfjXxDio6zvI0jRroM97AtKrjs=
Date:   Mon, 22 Mar 2021 16:00:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Kamal Dasu <kdasu.kdev@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        lkft-triage@lists.linaro.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH 5.10 103/157] MIPS: kernel: Reserve exception base early
 to prevent corruption
Message-ID: <YFixCO3CMwh+TThB@kroah.com>
References: <20210322121933.746237845@linuxfoundation.org>
 <20210322121937.040307268@linuxfoundation.org>
 <CA+G9fYuSdE7U-D+mn82bR3e33NzpDEFsD9B6EgXAj3sKMLxfeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuSdE7U-D+mn82bR3e33NzpDEFsD9B6EgXAj3sKMLxfeQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 22, 2021 at 07:44:05PM +0530, Naresh Kamboju wrote:
> On Mon, 22 Mar 2021 at 18:14, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> >
> > [ Upstream commit bd67b711bfaa02cf19e88aa2d9edae5c1c1d2739 ]
> >
> > BMIPS is one of the few platforms that do change the exception base.
> > After commit 2dcb39645441 ("memblock: do not start bottom-up allocations
> > with kernel_end") we started seeing BMIPS boards fail to boot with the
> > built-in FDT being corrupted.
> >
> > Before the cited commit, early allocations would be in the [kernel_end,
> > RAM_END] range, but after commit they would be within [RAM_START +
> > PAGE_SIZE, RAM_END].
> >
> > The custom exception base handler that is installed by
> > bmips_ebase_setup() done for BMIPS5000 CPUs ends-up trampling on the
> > memory region allocated by unflatten_and_copy_device_tree() thus
> > corrupting the FDT used by the kernel.
> >
> > To fix this, we need to perform an early reservation of the custom
> > exception space. Additional we reserve the first 4k (1k for R3k) for
> > either normal exception vector space (legacy CPUs) or special vectors
> > like cache exceptions.
> >
> > Huge thanks to Serge for analysing and proposing a solution to this
> > issue.
> >
> > Fixes: 2dcb39645441 ("memblock: do not start bottom-up allocations with kernel_end")
> > Reported-by: Kamal Dasu <kdasu.kdev@gmail.com>
> > Debugged-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > Acked-by: Mike Rapoport <rppt@linux.ibm.com>
> > Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> > Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
> > Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  arch/mips/include/asm/traps.h    |  3 +++
> >  arch/mips/kernel/cpu-probe.c     |  6 ++++++
> >  arch/mips/kernel/cpu-r3k-probe.c |  3 +++
> >  arch/mips/kernel/traps.c         | 10 +++++-----
> 
> mipc tinyconfig and allnoconfig builds failed on stable-rc 5.10 branch
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=mips
> CROSS_COMPILE=mips-linux-gnu- 'CC=sccache mips-linux-gnu-gcc'
> 'HOSTCC=sccache gcc'
> WARNING: modpost: vmlinux.o(.text+0x6a88): Section mismatch in
> reference from the function reserve_exception_space() to the function
> .meminit.text:memblock_reserve()
> The function reserve_exception_space() references
> the function __meminit memblock_reserve().
> This is often because reserve_exception_space lacks a __meminit
> annotation or the annotation of memblock_reserve is wrong.
> 
> FATAL: modpost: Section mismatches detected.
> Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.
> make[2]: *** [/builds/linux/scripts/Makefile.modpost:59:
> vmlinux.symvers] Error 1
> 
> Here is the list of build failed,
>  - gcc-8-allnoconfig
>  - gcc-8-tinyconfig
>  - gcc-9-allnoconfig
>  - gcc-9-tinyconfig
>  - gcc-10-allnoconfig
>  - gcc-10-tinyconfig
>  - clang-10-tinyconfig
>  - clang-10-allnoconfig
>  - clang-11-allnoconfig
>  - clang-11-tinyconfig
>  - clang-12-tinyconfig
>  - clang-12-allnoconfig
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> 
> link:
> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1117167411#L142
> 
> steps to reproduce:
> ---------------------------
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
> 
> tuxmake --runtime podman --target-arch mips --toolchain gcc-10
> --kconfig tinyconfig
> 

Thanks for letting me know, I'll go drop this and push out a new -rc...

greg k-h
