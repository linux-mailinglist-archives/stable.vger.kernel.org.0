Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F11A401070
	for <lists+stable@lfdr.de>; Sun,  5 Sep 2021 16:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhIEO72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 10:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229566AbhIEO72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 10:59:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7AE460F21;
        Sun,  5 Sep 2021 14:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630853905;
        bh=SeJvBDee3vFwppG4vfbpy5vB8AIiGc4i7mvYhrqC8gk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CwGMOq5W+rOKPNQiYHZ1PGK0Q6vvWs2qEfwtNUBrw/QO45ONvfQmkHn82DQhKTbq1
         MQnnCd8FO98fwMbS9HMiROI3aScX5bz34fjT7AdRMiexmVdf5l6cX9FmQjSPZO2pYq
         1KhcYaKJF9KixK7LQ8Pw1wZWvEwVTM0WE0QqSibo=
Date:   Sun, 5 Sep 2021 16:58:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Subject: Re: kernel/kexec_file.o: failed: Cannot find symbol for section 10:
 .text.unlikely.
Message-ID: <YTTbD+BKRpd0g4hq@kroah.com>
References: <CA+G9fYvMaHgSied79QBs3D=eDVETGH=3gxA8owCSRj313yEhVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvMaHgSied79QBs3D=eDVETGH=3gxA8owCSRj313yEhVg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 05, 2021 at 07:28:35PM +0530, Naresh Kamboju wrote:
> Following build errors noticed while building stable rc Linux 5.13.14
> with gcc-11 for powerpc architecture.
> 
> # to reproduce this build locally:
> tuxmake --target-arch=powerpc --kconfig=defconfig --toolchain=gcc-11
> --wrapper=sccache --environment=KBUILD_BUILD_TIMESTAMP=@1630691419
> --environment=KBUILD_BUILD_USER=tuxmake
> --environment=KBUILD_BUILD_HOST=tuxmake
> --environment=SCCACHE_BUCKET=sccache.tuxbuild.com --runtime=podman
> --image=855116176053.dkr.ecr.us-east-1.amazonaws.com/tuxmake/powerpc_gcc-11
> config default kernel xipkernel modules dtbs dtbs-legacy debugkernel
> headers
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=powerpc
> CROSS_COMPILE=powerpc64le-linux-gnu- 'CC=sccache
> powerpc64le-linux-gnu-gcc' 'HOSTCC=sccache gcc' defconfig
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=powerpc
> CROSS_COMPILE=powerpc64le-linux-gnu- 'CC=sccache
> powerpc64le-linux-gnu-gcc' 'HOSTCC=sccache gcc'
> Cannot find symbol for section 10: .text.unlikely.
> kernel/kexec_file.o: failed
> make[2]: *** [/builds/linux/scripts/Makefile.build:273:
> kernel/kexec_file.o] Error 1
> make[2]: *** Deleting file 'kernel/kexec_file.o'
> 
> 
> Build config:
> https://builds.tuxbuild.com/1xdiIZVZuLCW3X1WO2YT6Fsl19w/config
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> meta data:
> -----------
>     git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
>     git_sha: a603798fb16829e56f80f57879611e67bba4910d
>     git_short_log: a603798fb168 (\Linux 5.13.14\)
>     kconfig:  defconfig
>     kernel_version: 5.13.14
>     target_arch: powerpc
>     toolchain: gcc-11
> 
> steps to reproduce:
> https://builds.tuxbuild.com/1xdiIZVZuLCW3X1WO2YT6Fsl19w/tuxmake_reproducer.sh
> 
> --
> Linaro LKFT
> https://lkft.linaro.org

Is this a regression?  Has this compiler ever been able to build this
arch like this?

thanks,

greg k-h
