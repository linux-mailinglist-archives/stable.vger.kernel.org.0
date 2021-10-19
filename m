Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A09432DEF
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 08:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhJSGPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 02:15:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhJSGPi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 02:15:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0859260FD8;
        Tue, 19 Oct 2021 06:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634624006;
        bh=5XvzpN1NS7/QBJvAmvCezyZtiT+FW30hqIgwpD5nZes=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ob6FM2t8129ht8gWxLAGXzZSUPEdtrCdGGCHMzcFpswEw8uhS3v0LOWcn2qotwh6E
         ncnpGN9dJrDU5WX8XRfhCuRUXvfF/Y1AG5+eFbbCbyJh7cJt9tvi17mSNhzxg6qjkP
         QQVKGiNtwt7GFnhAS6z2lorwWq/nuObVv6Ej2+EI=
Date:   Tue, 19 Oct 2021 08:13:24 +0200
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
Message-ID: <YW5iBGg4VKP6ZL+O@kroah.com>
References: <20211018132340.682786018@linuxfoundation.org>
 <CA+G9fYtLTmosatvO8VBe-RDjEHEvY01P=Fw5mvRvwbxL31ahOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtLTmosatvO8VBe-RDjEHEvY01P=Fw5mvRvwbxL31ahOA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 19, 2021 at 09:08:08AM +0530, Naresh Kamboju wrote:
> On Mon, 18 Oct 2021 at 19:08, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.14.14 release.
> > There are 151 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.14-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Following build errors noticed while building Linux stable rc 5.14
> with gcc-11 allmodconfig for arm64 architecture.
> 
>   - 5.14.14 gcc-11 arm64 allmodconfig FAILED
> 
> > Sudeep Holla <sudeep.holla@arm.com>
> >     firmware: arm_ffa: Add missing remove callback to ffa_bus_type
> 
> drivers/firmware/arm_ffa/bus.c:96:27: error: initialization of 'int
> (*)(struct device *)' from incompatible pointer type 'void (*)(struct
> device *)' [-Werror=incompatible-pointer-types]
>    96 |         .remove         = ffa_device_remove,
>       |                           ^~~~~~~~~~~~~~~~~
> drivers/firmware/arm_ffa/bus.c:96:27: note: (near initialization for
> 'ffa_bus_type.remove')
> cc1: some warnings being treated as errors
> 
> Build config:
> https://builds.tuxbuild.com/1zhYTWmjxG50Rb8sGtfneME9kLT/config
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks, will go fix this up now.

> steps to reproduce:
> https://builds.tuxbuild.com/1zhYTWmjxG50Rb8sGtfneME9kLT/tuxmake_reproducer.sh

Hm, no, those steps fail for me:
	$ tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11 --kconfig allmodconfig
	E: Unsupported architecture/toolchain combination: arm64/gcc-11

What did I do wrong?

thanks,

greg k-h
