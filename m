Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7424181B6
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 13:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244519AbhIYLrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 07:47:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232363AbhIYLq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Sep 2021 07:46:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06A2F6124B;
        Sat, 25 Sep 2021 11:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632570324;
        bh=lK1CIJn/awmHTElf/vL2G+f6q5CDRXPrzTyaVPBPT48=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xx/318jwxiMjor+ABfHnMZNS6v+ZTDg/yXSt/qGatay99U+ipGTHzblC/dnM2JCb9
         Op5CEEzXYZG3Qdbtvb88+rMOEKoRwGgLX50QzmyCqb2q2SetrMiqE5XyR9Fa5MvqSn
         8ADzophhUny7TV4llR9cWlT1n0WHbiIPZB0KVOVk=
Date:   Sat, 25 Sep 2021 13:45:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/23] 4.4.285-rc1 review
Message-ID: <YU8L0dPBq1br51Ip@kroah.com>
References: <20210924124327.816210800@linuxfoundation.org>
 <eab2f99b-8be2-2ca3-27de-d98cb36b327c@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eab2f99b-8be2-2ca3-27de-d98cb36b327c@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 24, 2021 at 08:50:21AM -0500, Daniel Díaz wrote:
> Hello!
> 
> On 9/24/21 7:43 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.285 release.
> > There are 23 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.285-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Regressions detected.
> 
> While building mxs_defconfig for arm, the following error was encountered:
> 
>   /builds/linux/arch/arm/mach-mxs/mach-mxs.c:285:26: warning: duplicate 'const' declaration specifier [-Wduplicate-decl-specifier]
>     285 | static const struct gpio const tx28_gpios[] __initconst = {
>         |                          ^~~~~
>   /builds/linux/drivers/pwm/pwm-mxs.c: In function 'mxs_pwm_probe':
>   /builds/linux/drivers/pwm/pwm-mxs.c:164:24: error: implicit declaration of function 'dev_err_probe'; did you mean 'device_reprobe'? [-Werror=implicit-function-declaration]
>     164 |                 return dev_err_probe(&pdev->dev, ret, "failed to reset PWM\n");
>         |                        ^~~~~~~~~~~~~
>         |                        device_reprobe
>   cc1: some warnings being treated as errors
>   make[3]: *** [/builds/linux/scripts/Makefile.build:280: drivers/pwm/pwm-mxs.o] Error 1
> 
> This is also seen in other branches (from 4.4 to 5.4). To reproduce this build locally:
> 
>   tuxmake \
>     --target-arch=arm \
>     --kconfig=mxs_defconfig \
>     --toolchain=gcc-11 \
>     --runtime=podman \
>     config default kernel xipkernel modules dtbs dtbs-legacy debugkernel headers

Now dropped from all 4.4 - 5.4 kernels, thanks!  I'll push out a -rc2
soon with all of these fixed up...

greg k-h
