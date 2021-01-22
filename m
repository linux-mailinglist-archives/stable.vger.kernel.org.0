Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38ABF30080A
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 17:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbhAVQAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 11:00:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729361AbhAVP7s (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 10:59:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89AAA22248;
        Fri, 22 Jan 2021 15:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611331148;
        bh=x4JXn/NGT9kOmD86mZTB5+L63oSboexwirGKxvWY8Do=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fdh85FY7JV18I/qn12cwtKYZWjDWlaqkgQkRpwOON4FTphz1UxTyppjll+TcCbP0K
         qrPqbvg0hzTOWqUTnpppgxguwrGL+/L/dlSA9G76B+7CZhYep9D/rplrj6FgXmPe83
         5J6mTONaF9HvpsPbErdZoOEbw9cCcw0EQaiIieO0=
Date:   Fri, 22 Jan 2021 16:59:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-mips@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 4.14 00/50] 4.14.217-rc1 review
Message-ID: <YAr2Sae/oDOH/E5X@kroah.com>
References: <20210122135735.176469491@linuxfoundation.org>
 <CA+G9fYus+rnoxpZqhn35fMz4ZPQvYjkKFKSCsOhFtrHzbu1pZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYus+rnoxpZqhn35fMz4ZPQvYjkKFKSCsOhFtrHzbu1pZw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 08:50:43PM +0530, Naresh Kamboju wrote:
> On Fri, 22 Jan 2021 at 19:45, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.14.217 release.
> > There are 50 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.217-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> MIPS: cavium_octeon_defconfig and nlm_xlp_defconfig builds breaks
> due to this patch on 4.14, 4.9 and 4.4
> 
> > Al Viro <viro@zeniv.linux.org.uk>
> >     MIPS: Fix malformed NT_FILE and NT_SIGINFO in 32bit coredumps
> 
> Build error:
> arch/mips/kernel/binfmt_elfo32.c:116:
> /arch/mips/kernel/../../../fs/binfmt_elf.c: In function 'fill_siginfo_note':
> /arch/mips/kernel/../../../fs/binfmt_elf.c:1575:23: error: passing
> argument 1 of 'copy_siginfo_to_user' from incompatible pointer type
> [-Werror=incompatible-pointer-types]
>   copy_siginfo_to_user((user_siginfo_t __user *) csigdata, siginfo);
>                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> MIPS build failed
>     * gcc-10-cavium_octeon_defconfig - FAILED
>     * gcc-10-nlm_xlp_defconfig - FAILED
>     * gcc-8-cavium_octeon_defconfig - FAILED
>     * gcc-8-nlm_xlp_defconfig - FAILED
>     * gcc-9-cavium_octeon_defconfig - FAILED
>     * gcc-9-nlm_xlp_defconfig - FAILED
> 
> Build log link,
> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/980489009#L162

Ugh, I had already dropped that from other kernels before, forgot to do
so here, sorry about, will go do that now and push out -rc2 for all 3 of
these branches.

thanks,

greg k-h
