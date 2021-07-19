Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15DB3CCDC7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 08:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhGSGNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 02:13:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229916AbhGSGNG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 02:13:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAADD61009;
        Mon, 19 Jul 2021 06:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626675006;
        bh=9Xkxp7fQFwANVRM0WqLxiEkC8wny/9xqb44M1wtP5TM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2aaI0PA0ZkxeJi0ny6sAIIK58tRuO+ZeCKV7IMmKzeA+gJRs0I/BSyb+0Ira5ry6t
         XfvSO3fSM1ybAe0NxrFklwNFjsdFGg1K3haYWaBc+JI2R1VTf3t29FKNYheJ/p6/Cv
         rfW6k65rJVp3EC6PfSx69JZSt3yR5VLH/U2F/K4k=
Date:   Mon, 19 Jul 2021 08:10:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sven Schnelle <svens@linux.ibm.com>
Cc:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        linux- stable <stable@vger.kernel.org>, hca@linux.ibm.com
Subject: Re: [PATCH 5.12 000/242] 5.12.18-rc1 review
Message-ID: <YPUXPEiTrpKoKf+t@kroah.com>
References: <20210715182551.731989182@linuxfoundation.org>
 <CAEUSe7_+8fQZ=1+jcxJVTRw0DYttGmR-aBdobZ0GWYQi3Vg97w@mail.gmail.com>
 <yt9dim16lv3u.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yt9dim16lv3u.fsf@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 07:40:21AM +0200, Sven Schnelle wrote:
> Hi Daniel,
> 
> Daniel Díaz <daniel.diaz@linaro.org> writes:
> 
> > Hello!
> >
> > On Thu, 15 Jul 2021 at 13:56, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >> This is the start of the stable review cycle for the 5.12.18 release.
> >> There are 242 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.18-rc1.gz
> >> or in the git tree and branch at:
> >>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> >> and the diffstat can be found below.
> >>
> >> thanks,
> >>
> >> greg k-h
> >
> > Build regressions have been found on this release candidate (and on 5.13-rc).
> >
> > ## Regressions (compared to v5.12.17)
> > * s390, build
> >   - clang-10-allnoconfig
> >   - clang-10-defconfig
> >   - clang-10-tinyconfig
> >   - clang-11-allnoconfig
> >   - clang-11-defconfig
> >   - clang-11-tinyconfig
> >   - clang-12-allnoconfig
> >   - clang-12-defconfig
> >   - clang-12-tinyconfig
> >   - gcc-8-allnoconfig
> >   - gcc-8-defconfig
> >   - gcc-8-tinyconfig
> >   - gcc-9-allnoconfig
> >   - gcc-9-defconfig
> >   - gcc-9-tinyconfig
> >   - gcc-10-allnoconfig
> >   - gcc-10-defconfig
> >   - gcc-10-tinyconfig
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > [...]
> >> Sven Schnelle <svens@linux.ibm.com>
> >>     s390/signal: switch to using vdso for sigreturn and syscall restart
> > [...]
> >
> > Our bisections pointed to this commit. Reverting it made the build pass again.
> 
> If https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1428532107
> is the logfile for this problem, than i see the following in the log:
> 
> make --silent --keep-going --jobs=8 O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- 'CC=sccache s390x-linux-gnu-gcc' 'HOSTCC=sccache gcc'
> /bin/sh: 1: /builds/linux/arch/s390/kernel/vdso64/gen_vdso_offsets.sh: Permission denied
> 
> However, in the patch this script is 755, and other architecture are
> using this for a while now - can you check what the permission are when
> you're trying to build the kernel?

Yes, the problem is that when handling patches, we can not change the
permissions on files.  That causes this file to not be added with
execute permissions.  This has generally been considered a bad thing
anyway, and other scripts that relied on being executable have been
changed over time to not be that way and be explicitly run by the
calling script.

But it looks like th gen_vdso_offsets.sh script has not been changed on
any arch to do that yet.  It is one of the few hold outs.

Also, this feels like a HUGE change for a stable tree, adding new
features like this, are you sure it's all needed?

thanks,

greg k-h
