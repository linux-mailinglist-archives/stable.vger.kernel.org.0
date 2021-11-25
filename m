Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C609E45DA9C
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 14:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351893AbhKYNEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 08:04:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353997AbhKYNCA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 08:02:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53FA860187;
        Thu, 25 Nov 2021 12:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637845129;
        bh=ktjngJ2/FeECqMmLlRKeC9UC1fcA0HHoCKJVLEwGJHo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cFxw8vE6qVkKblQpGBDmucSzWrdWesEq0MRVlMYvBFaWzreEZWqWdUUukTmIkyx59
         aA/UXIBTDedRtwIL6RpTffs9mMB4aWhGpklZX1ocuKGIb+TmQAeQrUr0XVmZXWpztW
         Rdr11ORHKWRG9hiWDxNwLc6W/+brwv21P74kQnYI=
Date:   Thu, 25 Nov 2021 13:58:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Nadav Amit <namit@vmware.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 4.9 000/207] 4.9.291-rc1 review
Message-ID: <YZ+Ie3bhYDXYDvUP@kroah.com>
References: <20211124115703.941380739@linuxfoundation.org>
 <CA+G9fYuZqV51ZGQd-ySaDqSQ_YDJHYav4KW4B0zEq1Rh2_KCDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuZqV51ZGQd-ySaDqSQ_YDJHYav4KW4B0zEq1Rh2_KCDA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 08:42:27PM +0530, Naresh Kamboju wrote:
> On Wed, 24 Nov 2021 at 17:44, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.9.291 release.
> > There are 207 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.291-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Regression found on arm gcc-11 builds with tinyconfig and allnoconfig.
> As a reported in this email,
> 
> https://lore.kernel.org/stable/CA+G9fYvU4yoOx7BEBxJXRVZx4pO5fYPRELmkNz+iBu7kdN_9Ew@mail.gmail.com/
> 
> 
> build error :
> --------------
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm
> CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
> arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
> In file included from arch/arm/include/asm/tlb.h:28,
>                  from arch/arm/mm/init.c:34:
> include/asm-generic/tlb.h: In function 'tlb_flush_pmd_range':
> include/asm-generic/tlb.h:208:54: error: 'PMD_SIZE' undeclared (first
> use in this function); did you mean 'PUD_SIZE'?
>   208 |         if (tlb->page_size != 0 && tlb->page_size != PMD_SIZE)
>       |                                                      ^~~~~~~~
>       |                                                      PUD_SIZE
> include/asm-generic/tlb.h:208:54: note: each undeclared identifier is
> reported only once for each function it appears in
> make[2]: *** [scripts/Makefile.build:307: arch/arm/mm/init.o] Error 1
> make[2]: Target '__build' not remade because of errors.
> make[1]: *** [Makefile:1036: arch/arm/mm] Error 2
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Patch pointing to,
> 
> hugetlbfs: flush TLBs correctly after huge_pmd_unshare
> commit a4a118f2eead1d6c49e00765de89878288d4b890 upstream.

Should be fixed in -rc2
