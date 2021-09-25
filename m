Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFF04181BF
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 13:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237275AbhIYLvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 07:51:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232363AbhIYLvi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Sep 2021 07:51:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 271D661051;
        Sat, 25 Sep 2021 11:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632570603;
        bh=CBqoebMo6StOXMNjvDl4eBDM5PRAhi4ujxLC+stlRzE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bt6PVz4WYsK5wvuBjkAxQ+aTvxjsgS6Zcbx2gCbU6eqeMQ0C4kFI4rl9yNg1wjwMI
         IrNXlYNRcOYWWpOi1t0nxFg8sW8WlAnOAAgXqp8YqVYcYh4qeHU+DBHz1yOTbgM4kz
         UGub1a+tD0Cpqg1XTOej0CYv/9IE65K6gz9A0j5E=
Date:   Sat, 25 Sep 2021 13:50:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Subject: Re: [PATCH 5.14 000/100] 5.14.8-rc1 review
Message-ID: <YU8M6Ba6MNsZoh4x@kroah.com>
References: <20210924124341.214446495@linuxfoundation.org>
 <6ebcc3a5-d57b-8aef-1964-17a210eb9334@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ebcc3a5-d57b-8aef-1964-17a210eb9334@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 24, 2021 at 09:21:48AM -0500, Daniel Díaz wrote:
> Hello!
> 
> On 9/24/21 7:43 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.14.8 release.
> > There are 100 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.8-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Regressions detected.
> 
> While building Perf for arm, arm64, i386 and x86, all with GCC 11, the following errors were encountered:
> 
>   util/parse-events-hybrid.c: In function 'add_hw_hybrid':
>   util/parse-events-hybrid.c:84:17: error: implicit declaration of function 'copy_config_terms'; did you mean 'perf_pmu__config_terms'? [-Werror=implicit-function-declaration]
>      84 |                 copy_config_terms(&terms, config_terms);
>         |                 ^~~~~~~~~~~~~~~~~
>         |                 perf_pmu__config_terms
>   util/parse-events-hybrid.c:88:17: error: implicit declaration of function 'free_config_terms'; did you mean 'perf_pmu__config_terms'? [-Werror=implicit-function-declaration]
>      88 |                 free_config_terms(&terms);
>         |                 ^~~~~~~~~~~~~~~~~
>         |                 perf_pmu__config_terms
>   cc1: all warnings being treated as errors
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

Thanks, found this and will drop the perf patch that was causing it.

greg k-h
