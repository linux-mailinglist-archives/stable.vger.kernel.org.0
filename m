Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B68B303CDE
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 13:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403784AbhAZMWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 07:22:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392625AbhAZMWc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 07:22:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C21FC2255F;
        Tue, 26 Jan 2021 12:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611663711;
        bh=R+qCX+iitLR6N2a9j20Ffz0Ns9MoiFQ7HN+GcDZ3V2Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z3AAKr0NkGK5w/cjcJH30seVArDE6P1QkLcLG3YSApt6Js5aFnfQZD4iENxWdnsHv
         YBNv8u41XpWIFpxq9KMdJ6cl85KviBGKF3k2JNsQBCF4jyhud9ZBZSxNABqi+jo36j
         ev48dEfji3QfUBu8Cxe32ICdL1HwJiPZrsSPB+TU=
Date:   Tue, 26 Jan 2021 13:21:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, sagar.kadam@sifive.com,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 00/88] 5.4.93-rc2 review
Message-ID: <YBAJXDW+gY5J9K3B@kroah.com>
References: <20210126094301.457437398@linuxfoundation.org>
 <CA+G9fYtqJDKOwFGevaOmmK7gbKgo61CpL70yyG2daOxvRp5FSQ@mail.gmail.com>
 <YA/6KP4DNVkpSBA5@kroah.com>
 <CA+G9fYsvMq0W-4gSq4=D8at+J286vSzTx6SavSLjOpNoW8UUkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsvMq0W-4gSq4=D8at+J286vSzTx6SavSLjOpNoW8UUkQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021 at 04:58:53PM +0530, Naresh Kamboju wrote:
> On Tue, 26 Jan 2021 at 16:46, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jan 26, 2021 at 04:43:51PM +0530, Naresh Kamboju wrote:
> > > On Tue, 26 Jan 2021 at 15:33, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.4.93 release.
> > > > There are 88 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Thu, 28 Jan 2021 09:42:44 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.93-rc2.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > As Daniel pointed in the other email thread,
> > > riscv failed build:
> > >      * clang-10-defconfig -  FAILED
> > >      * clang-11-defconfig -  FAILED
> > >      * gcc-8-defconfig -  FAILED
> > >      * gcc-9-defconfig -  FAILED
> > >      * gcc-10-defconfig -  FAILED
> > >
> > > the riscv build failed due to the below commit.
> > >
> > > > Sagar Shrikant Kadam <sagar.kadam@sifive.com>
> > > >     dts: phy: add GPIO number and active state used for phy reset
> > >
> > > make --silent --keep-going --jobs=8
> > > O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=riscv
> > > CROSS_COMPILE=riscv64-linux-gnu- 'CC=sccache riscv64-linux-gnu-gcc'
> > > 'HOSTCC=sccache gcc'
> > > arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts:88.27-28 syntax error
> > > FATAL ERROR: Unable to parse input tree
> > >
> > > Build log,
> > > https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/986616680
> >
> > Crap, forgot that one.  Will go drop it now and push out a -rc3.  Is
> > this an issue for 5.10.y?
> 
> No.
> 5.10 builds are successful.

Wonderful, thanks for letting me know.

This round of kernels were a pain for some reason...

greg k-h
