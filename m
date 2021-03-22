Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684853446DA
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 15:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhCVOOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 10:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbhCVOOS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 10:14:18 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CF7C061762
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 07:14:17 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id u9so21532869ejj.7
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 07:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+4yh4MCaMjCQZ43lV2b3NMY6HnAMnpQQHM0Vz8ZLtI8=;
        b=ks6UgnX43wsvsZOr+tvl4pF7ZmWygwrO3DHEgdKqCXz+YQxpFvXH2tP8ZNAeqC+QcP
         QGFYnM0MwEG6yrWilism7U6AEteYYQ7/R5FHokF9NzzfbwCbNw4vUTnYUP3lb70JI0Cr
         dfB60Y38wPG80kD4YInbugTSZF09sR8E3aBIUtJ58v44JDl3yMcvyOEj+ljZu9hge1ur
         akjI5xrobOdNTyEElrEb6zJr4NABzOCSBOWlqvevdnBe3UbOAr3NPOLX64hmjmd5Tx8I
         l85+hHhdrf4fLKk0oNgUFEDi6y4KzFIZUJ0M0+dLzLq1I3ox9yLr6aXQ1jd3ZDh7ub5B
         B53w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+4yh4MCaMjCQZ43lV2b3NMY6HnAMnpQQHM0Vz8ZLtI8=;
        b=g7YwMhAJPkPkYUHORV+E3PB2pzysGsTotpdfStEJZs1cwkEo10IRtbEuaLw9FiMnBK
         PONT38dXE6mXMLLAIof0BMuR+o/otPm3P9o4E1UKnOqFoIufBhc+LcLFcJduhUHA5KNb
         S5Zst4sisHmEMiqpxIBSzeuBSYLMS75ddKEOA+7URpaG19Wb/efnq9SgRtvvgJVCBior
         gzhomn65jCYAqkcBQ+HfCWyG64iUSw6wLZpzxQaq1iFEIBtuFEcmQMJtAmvmOyzvL2c9
         rzT5yPn46bnSNYhZRn+ddxOd0vbcv5gDnxuVPRWJo/jAhz1rpvN4Mrv5XESZ0xVtmKPM
         7yYw==
X-Gm-Message-State: AOAM533c2hAO2sZQoD2dCDQ2zKe/ByOHVZaT1pRbnDAWRgijS4Meeaam
        port7004JdMLUKJqrhz4Qk9nS4FeY7WedyHj15cTAg==
X-Google-Smtp-Source: ABdhPJxtrbtv7CNwA1UI5v7Ipmfc6jya2hFUTvNiJoK0oHZMpmXsnK+fBBudUF7c8CwvUThB5YW1qnlEQFmoX/Um/Lg=
X-Received: by 2002:a17:907:720a:: with SMTP id dr10mr11853474ejc.375.1616422456310;
 Mon, 22 Mar 2021 07:14:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210322121933.746237845@linuxfoundation.org> <20210322121937.040307268@linuxfoundation.org>
In-Reply-To: <20210322121937.040307268@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 22 Mar 2021 19:44:05 +0530
Message-ID: <CA+G9fYuSdE7U-D+mn82bR3e33NzpDEFsD9B6EgXAj3sKMLxfeQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 103/157] MIPS: kernel: Reserve exception base early
 to prevent corruption
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        lkft-triage@lists.linaro.org, linux-mips@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Mar 2021 at 18:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>
> [ Upstream commit bd67b711bfaa02cf19e88aa2d9edae5c1c1d2739 ]
>
> BMIPS is one of the few platforms that do change the exception base.
> After commit 2dcb39645441 ("memblock: do not start bottom-up allocations
> with kernel_end") we started seeing BMIPS boards fail to boot with the
> built-in FDT being corrupted.
>
> Before the cited commit, early allocations would be in the [kernel_end,
> RAM_END] range, but after commit they would be within [RAM_START +
> PAGE_SIZE, RAM_END].
>
> The custom exception base handler that is installed by
> bmips_ebase_setup() done for BMIPS5000 CPUs ends-up trampling on the
> memory region allocated by unflatten_and_copy_device_tree() thus
> corrupting the FDT used by the kernel.
>
> To fix this, we need to perform an early reservation of the custom
> exception space. Additional we reserve the first 4k (1k for R3k) for
> either normal exception vector space (legacy CPUs) or special vectors
> like cache exceptions.
>
> Huge thanks to Serge for analysing and proposing a solution to this
> issue.
>
> Fixes: 2dcb39645441 ("memblock: do not start bottom-up allocations with kernel_end")
> Reported-by: Kamal Dasu <kdasu.kdev@gmail.com>
> Debugged-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> Acked-by: Mike Rapoport <rppt@linux.ibm.com>
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/mips/include/asm/traps.h    |  3 +++
>  arch/mips/kernel/cpu-probe.c     |  6 ++++++
>  arch/mips/kernel/cpu-r3k-probe.c |  3 +++
>  arch/mips/kernel/traps.c         | 10 +++++-----

mipc tinyconfig and allnoconfig builds failed on stable-rc 5.10 branch

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=mips
CROSS_COMPILE=mips-linux-gnu- 'CC=sccache mips-linux-gnu-gcc'
'HOSTCC=sccache gcc'
WARNING: modpost: vmlinux.o(.text+0x6a88): Section mismatch in
reference from the function reserve_exception_space() to the function
.meminit.text:memblock_reserve()
The function reserve_exception_space() references
the function __meminit memblock_reserve().
This is often because reserve_exception_space lacks a __meminit
annotation or the annotation of memblock_reserve is wrong.

FATAL: modpost: Section mismatches detected.
Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.
make[2]: *** [/builds/linux/scripts/Makefile.modpost:59:
vmlinux.symvers] Error 1

Here is the list of build failed,
 - gcc-8-allnoconfig
 - gcc-8-tinyconfig
 - gcc-9-allnoconfig
 - gcc-9-tinyconfig
 - gcc-10-allnoconfig
 - gcc-10-tinyconfig
 - clang-10-tinyconfig
 - clang-10-allnoconfig
 - clang-11-allnoconfig
 - clang-11-tinyconfig
 - clang-12-tinyconfig
 - clang-12-allnoconfig

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

link:
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1117167411#L142

steps to reproduce:
---------------------------
# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.


tuxmake --runtime podman --target-arch mips --toolchain gcc-10
--kconfig tinyconfig


--
Linaro LKFT
https://lkft.linaro.org
