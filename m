Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70D645D8F4
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240283AbhKYLRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:17:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:42678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234393AbhKYLPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 06:15:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99C3960EB5;
        Thu, 25 Nov 2021 11:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637838760;
        bh=hLF0rIs+Hoqak6IjrCLzFaSemE9SOqe0/PXcT9ulWm0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GRtvq9ENNN+rDosxQmBHO7MhiV6NtMXI8pKssBbYm4DL4ykO+LNfrMB+MsfBYTEl3
         UefoLk9h27i7uA3r183URBrPMAjkbw1vULdaZm/lUh0GAJUWjQf0dR01siZjN+uRPG
         rsrQoL+6L+z7gaeoovS77WPGz6rh3s0PY8RtMBWM=
Date:   Thu, 25 Nov 2021 12:12:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        Nadav Amit <namit@vmware.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: mm: hugetlb.c:3455:25: error: implicit declaration of function
 'tlb_flush_pmd_range'
Message-ID: <YZ9voDD6S0xYVUH0@kroah.com>
References: <CA+G9fYv+SjDwfvP=Zgf-gr2RngkrzHO_w6OQzH7wqzU-dOW9+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYv+SjDwfvP=Zgf-gr2RngkrzHO_w6OQzH7wqzU-dOW9+g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 06:52:40PM +0530, Naresh Kamboju wrote:
> Regression found on s390 gcc-11 builds with defconfig
> Following build warnings / errors reported on stable-rc 4.19.
> 
> metadata:
>     git_describe: v4.19.217-324-g451ddd7eb93b
>     git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
>     git_short_log: 451ddd7eb93b (\"Linux 4.19.218-rc1\")
>     target_arch: s390
>     toolchain: gcc-11 / gcc-10 / gcc-9 / gcc-8
> 
> build error :
> --------------
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=s390
> CROSS_COMPILE=s390x-linux-gnu- 'CC=sccache s390x-linux-gnu-gcc'
> 'HOSTCC=sccache gcc'
> arch/s390/kernel/setup.c: In function 'setup_lowcore_dat_off':
> arch/s390/kernel/setup.c:342:9: warning: 'memcpy' reading 128 bytes
> from a region of size 0 [-Wstringop-overread]
>   342 |         memcpy(lc->stfle_fac_list, S390_lowcore.stfle_fac_list,
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   343 |                sizeof(lc->stfle_fac_list));
>       |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> arch/s390/kernel/setup.c:344:9: warning: 'memcpy' reading 128 bytes
> from a region of size 0 [-Wstringop-overread]
>   344 |         memcpy(lc->alt_stfle_fac_list, S390_lowcore.alt_stfle_fac_list,
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   345 |                sizeof(lc->alt_stfle_fac_list));
>       |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> arch/s390/kvm/kvm-s390.c: In function 'kvm_s390_get_machine':
> arch/s390/kvm/kvm-s390.c:1302:9: warning: 'memcpy' reading 128 bytes
> from a region of size 0 [-Wstringop-overread]
>  1302 |         memcpy((unsigned long *)&mach->fac_list,
> S390_lowcore.stfle_fac_list,
>       |
> ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  1303 |                sizeof(S390_lowcore.stfle_fac_list));
>       |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from arch/s390/kernel/lgr.c:13:
> In function 'stfle',
>     inlined from 'lgr_info_get' at arch/s390/kernel/lgr.c:122:2:
> arch/s390/include/asm/facility.h:88:9: warning: 'memcpy' reading 4
> bytes from a region of size 0 [-Wstringop-overread]
>    88 |         memcpy(stfle_fac_list, &S390_lowcore.stfl_fac_list, 4);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In function 'pcpu_prepare_secondary',
>     inlined from '__cpu_up' at arch/s390/kernel/smp.c:878:2:
> arch/s390/kernel/smp.c:271:9: warning: 'memcpy' reading 128 bytes from
> a region of size 0 [-Wstringop-overread]
>   271 |         memcpy(lc->stfle_fac_list, S390_lowcore.stfle_fac_list,
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   272 |                sizeof(lc->stfle_fac_list));
>       |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> arch/s390/kernel/smp.c:273:9: warning: 'memcpy' reading 128 bytes from
> a region of size 0 [-Wstringop-overread]
>   273 |         memcpy(lc->alt_stfle_fac_list, S390_lowcore.alt_stfle_fac_list,
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   274 |                sizeof(lc->alt_stfle_fac_list));
>       |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> mm/hugetlb.c: In function '__unmap_hugepage_range':
> mm/hugetlb.c:3455:25: error: implicit declaration of function
> 'tlb_flush_pmd_range'; did you mean 'tlb_flush_mmu_free'?
> [-Werror=implicit-function-declaration]
>  3455 |                         tlb_flush_pmd_range(tlb, address &
> PUD_MASK, PUD_SIZE);
>       |                         ^~~~~~~~~~~~~~~~~~~
>       |                         tlb_flush_mmu_free
> cc1: some warnings being treated as errors
> 
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> build link:
> -----------
> https://builds.tuxbuild.com/21MfFQQKrxPYUW7b8amBJjt3Ki7/build.log
> 
> build config:
> -------------
> https://builds.tuxbuild.com/21MfFQQKrxPYUW7b8amBJjt3Ki7/config
> 
> # To install tuxmake on your system globally
> # sudo pip3 install -U tuxmake
> tuxmake --runtime podman --target-arch s390 --toolchain gcc-11
> --kconfig defconfig

Thanks, should now be fixed.

greg k-h
