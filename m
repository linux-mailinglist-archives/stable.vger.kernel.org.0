Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1702432E91
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 08:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhJSGuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 02:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234026AbhJSGuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 02:50:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 265B760F56;
        Tue, 19 Oct 2021 06:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634626080;
        bh=vIawcnn8K7nDu0LC/rzRPqDISbQx6Hr8NmhDx9Cug58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sB4sP3Z5GjonkVSWDUom0lppPfKnxY6CaS31HjneE1Ig8WOtoBG3poi2OSKj9+zXC
         ZwkIKwa3y2F7Qu5VQJNOKj3S+ZUsZC/K/fLbIc6AUV/mAQtBWNDGlBq2TLCp73XzpB
         YDSFgvYcdcjacX1ZTwlZoXM0UDakFA8ZP7faC2zc=
Date:   Tue, 19 Oct 2021 08:47:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: Re: [PATCH 5.14 000/151] 5.14.14-rc1 review
Message-ID: <YW5qHvEHtkxCwOBh@kroah.com>
References: <20211018132340.682786018@linuxfoundation.org>
 <CA+G9fYtLTmosatvO8VBe-RDjEHEvY01P=Fw5mvRvwbxL31ahOA@mail.gmail.com>
 <YW5iBGg4VKP6ZL+O@kroah.com>
 <CA+G9fYv3mpZMZjoarc6=WNNzrer+xFX_diqVKMy1VFV=xhKpTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYv3mpZMZjoarc6=WNNzrer+xFX_diqVKMy1VFV=xhKpTg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 19, 2021 at 12:04:13PM +0530, Naresh Kamboju wrote:
> On Tue, 19 Oct 2021 at 11:43, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Oct 19, 2021 at 09:08:08AM +0530, Naresh Kamboju wrote:
> > > On Mon, 18 Oct 2021 at 19:08, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.14.14 release.
> > > > There are 151 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.14-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > Following build errors noticed while building Linux stable rc 5.14
> > > with gcc-11 allmodconfig for arm64 architecture.
> > >
> > >   - 5.14.14 gcc-11 arm64 allmodconfig FAILED
> > >
> > > > Sudeep Holla <sudeep.holla@arm.com>
> > > >     firmware: arm_ffa: Add missing remove callback to ffa_bus_type
> > >
> > > drivers/firmware/arm_ffa/bus.c:96:27: error: initialization of 'int
> > > (*)(struct device *)' from incompatible pointer type 'void (*)(struct
> > > device *)' [-Werror=incompatible-pointer-types]
> > >    96 |         .remove         = ffa_device_remove,
> > >       |                           ^~~~~~~~~~~~~~~~~
> > > drivers/firmware/arm_ffa/bus.c:96:27: note: (near initialization for
> > > 'ffa_bus_type.remove')
> > > cc1: some warnings being treated as errors
> > >
> > > Build config:
> > > https://builds.tuxbuild.com/1zhYTWmjxG50Rb8sGtfneME9kLT/config
> > >
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > Thanks, will go fix this up now.
> >
> > > steps to reproduce:
> > > https://builds.tuxbuild.com/1zhYTWmjxG50Rb8sGtfneME9kLT/tuxmake_reproducer.sh
> >
> > Hm, no, those steps fail for me:
> >         $ tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11 --kconfig allmodconfig
> >         E: Unsupported architecture/toolchain combination: arm64/gcc-11
> >
> > What did I do wrong?
> 
> May i request to force install and try,
> 
> $ pip install --force-reinstall tuxmake
> $ tuxmake --version              # this should get tuxmake 0.29.0
> $ tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
> --kconfig allmodconfig

Ah much better, I had an older version of tuxmake here.

Now it fails with an expected permission problem:
Error: writing blob: adding layer with blob "sha256:10348114f214e2f07f30fa82aaa743c1750b2a9025cc8bec19f3f4f2b087a96d": Error processing tar file(exit status 1): potentially insufficient UIDs or GIDs available in user namespace (requested 0:42 for /etc/gshadow): Check /etc/subuid and /etc/subgid: lchown /etc/gshadow: invalid argument
E: Runtime preparation failed: failed to pull remote image docker.io/tuxmake/arm64_gcc-11

Note, I will not run kernel builds or random containers downloaded from
the internet as root, sorry :)

thanks,

greg k-h
