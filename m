Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B407845DAC6
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 14:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355062AbhKYNQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 08:16:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347841AbhKYNOK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 08:14:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8D3D60F55;
        Thu, 25 Nov 2021 13:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637845859;
        bh=KWodulOmDNOeWdh0ObvftNcoQALnb0o7UR853ZJlNJk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B7Vt0v75KzlsGz6+pPV7cGBh05EByM2rqO8HCoHxUINqZXf/EipVYwKOBM13i02Td
         ZfKx6NLX+kudXkcsak/x7YRX3gZNtuMKwnjZCwt0Rvm1HEDN3HQ0wAZApN4s42vejA
         B2kQJ8wKmSrUzLuGll6akUOLQdfYlVE4yIRJmAyY=
Date:   Thu, 25 Nov 2021 14:10:54 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, Nadav Amit <namit@vmware.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkft-triage@lists.linaro.org
Subject: Re: tlb.h:208:54: error: 'PMD_SIZE' undeclared
Message-ID: <YZ+LXsfEBalZejLc@kroah.com>
References: <CA+G9fYvU4yoOx7BEBxJXRVZx4pO5fYPRELmkNz+iBu7kdN_9Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvU4yoOx7BEBxJXRVZx4pO5fYPRELmkNz+iBu7kdN_9Ew@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 06:04:20PM +0530, Naresh Kamboju wrote:
> Regression found on arm gcc-11 builds with tinyconfig and allnoconfig.
> Following build warnings / errors reported on stable-rc 4.9.
> 
> metadata:
>     git_describe: v4.9.290-208-gb2ae18f41670
>     git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
>     git_short_log: b2ae18f41670 (\"Linux 4.9.291-rc1\")
>     target_arch: arm
>     toolchain: gcc-11 / gcc-10 / gcc-9 / gcc-8
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
> 
> When __unmap_hugepage_range() calls to huge_pmd_unshare() succeed, a TLB
> flush is missing.  This TLB flush must be performed before releasing the
> i_mmap_rwsem, in order to prevent an unshared PMDs page from being
> released and reused before the TLB flush took place.
> 
> Arguably, a comprehensive solution would use mmu_gather interface to
> batch the TLB flushes and the PMDs page release, however it is not an
> easy solution: (1) try_to_unmap_one() and try_to_migrate_one() also call
> huge_pmd_unshare() and they cannot use the mmu_gather interface; and (2)
> deferring the release of the page reference for the PMDs page until
> after i_mmap_rwsem is dropeed can confuse huge_pmd_unshare() into
> thinking PMDs are shared when they are not.
> 
> Fix __unmap_hugepage_range() by adding the missing TLB flush, and
> forcing a flush when unshare is successful.
> 
> Fixes: 24669e58477e ("hugetlb: use mmu_gather instead of a temporary
> linked list for accumulating pages)" # 3.6
> Signed-off-by: Nadav Amit <namit@vmware.com>
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 
> 
> build link:
> -----------
> https://builds.tuxbuild.com//21Mf9eMMjq4oO5ZflMwRCPssSc0/build.log
> 
> build config:
> -------------
> https://builds.tuxbuild.com//21Mf9eMMjq4oO5ZflMwRCPssSc0/config
> 
> # To install tuxmake on your system globally
> # sudo pip3 install -U tuxmake
> tuxmake --runtime podman --target-arch arm --toolchain gcc-11
> --kconfig tinyconfig

Should now be resolved in -rc2.

thanks,

greg k-h
