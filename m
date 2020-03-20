Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C45018CD05
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 12:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgCTLbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 07:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbgCTLbp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 07:31:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D40C20739;
        Fri, 20 Mar 2020 11:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584703905;
        bh=tTcOXZo0nL9GBpGGAe+mQ4BXz8O0aZpM1T7UEN2GAQ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ty0ZOgL/K/MDE+655bhH/q+p2hiTWd3XSw2V2wo8zY8gNsDhxF0iijCR5rCSdQbon
         OdcdI16AoYlbKn5DJhcSqJqzo0kCTP7+61ziZrfXtU9PFQ1ADjbpkZGMNAPT2ZEwZp
         0Dr//aGv9ce0nPAHuhbBehU0TNDoEaaejzjW1I00=
Date:   Fri, 20 Mar 2020 12:31:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/60] 5.4.27-rc1 review
Message-ID: <20200320113142.GA488593@kroah.com>
References: <20200319123919.441695203@linuxfoundation.org>
 <bfdce3ef-5fe9-8dab-1695-be3d33727529@roeck-us.net>
 <20200320105513.GA450546@kroah.com>
 <CA+G9fYtR4eynoMt6r313FHgEhftDobn2SE9PFiDR=7_wZNfSTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtR4eynoMt6r313FHgEhftDobn2SE9PFiDR=7_wZNfSTQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 20, 2020 at 04:53:14PM +0530, Naresh Kamboju wrote:
> On Fri, 20 Mar 2020 at 16:25, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Mar 19, 2020 at 04:55:20PM -0700, Guenter Roeck wrote:
> > > On 3/19/20 6:03 AM, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.4.27 release.
> > > > There are 60 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > >
> > > Build results:
> > >       total: 158 pass: 158 fail: 0
> > > Qemu test results:
> > >       total: 427 pass: 425 fail: 2
> > > Failed tests:
> > >       mipsel64:64r6el_defconfig:notests:smp:ide:hd
> > >       mipsel64:64r6el_defconfig:notests:smp:ide:cd
> > >
> > > Building mipsel64:64r6el_defconfig:notests:smp:ide:hd ... failed
> > > ------------
> > > Error log:
> > > arch/mips/vdso/vdso.so.dbg.raw: PIC 'jalr t9' calls are not supported
> > >
> > > I was unable to figure out why I only see this problem in v5.4.y.
> > > The build error is easy to reproduce with gcc 9.2.0 and "64r6el_defconfig".
> >
> > I've dropped a bunch of mips vdso patches from 5.5 and 5.4 queues now
> > and will push out new -rcs with those in them to hopefully resolve these
> > issues.
> 
> amr64 and arm build failed on stable-rc 5.4 and 5.5
> 
>  # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu- HOSTCC=gcc CC="sccache
> aarch64-linux-gnu-gcc" O=build Image
>  #
>  ../drivers/mmc/host/sdhci-tegra.c: In function ‘sdhci_tegra_probe’:
>  ../drivers/mmc/host/sdhci-tegra.c:1556:21: error:
> ‘MMC_CAP_NEED_RSP_BUSY’ undeclared (first use in this function); did
> you mean ‘MMC_CAP_NEEDS_POLL’?
>   1556 | host->mmc->caps |= MMC_CAP_NEED_RSP_BUSY;
>   | ^~~~~~~~~~~~~~~~~~~~~
>   | MMC_CAP_NEEDS_POLL

Crap, I didn't build for arm.  I'll go push out -rc3 for this issue now,
sorry for the noise...

greg k-h
