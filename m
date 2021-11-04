Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F7744572A
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 17:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhKDQXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 12:23:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231586AbhKDQXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 12:23:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8DA261139;
        Thu,  4 Nov 2021 16:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636042837;
        bh=cuc2mHzEfr1O4iWbeSX9KkIIt0iUpCLMEbZV0m/30qk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qUhuMbbpxlVeRRv12SoOd/ozvZx+isKZGzi0uJwTCrxuAnCP5Hx/9iTTQ+EipAA62
         5sjNTc5YvI4m5nJ0Xll9zP7OQjOuwBs3aPL7ivIro3ZbBXGVv2yVuBdwHyojhX2BOw
         j/dlYyfqMVydSQco1rnRBAf3Fc17CuGYjCbykJWc=
Date:   Thu, 4 Nov 2021 17:20:34 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Subject: Re: [PATCH 5.10 00/16] 5.10.78-rc1 review
Message-ID: <YYQIUhHkv3kUY+UC@kroah.com>
References: <20211104141159.561284732@linuxfoundation.org>
 <3971a9b4-ebb6-a789-2143-31cf257d0d38@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3971a9b4-ebb6-a789-2143-31cf257d0d38@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 04, 2021 at 09:53:57AM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 11/4/21 8:12 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.78 release.
> > There are 16 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.78-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Regressions detected.
> 
> Build failures on all architectures and all toolchains (GCC 8, 9, 10, 11; Clang 10, 11, 12, 13, nightly):
> - arc
> - arm (32-bits)
> - arm (64-bits)
> - i386
> - mips
> - parisc
> - ppc
> - riscv
> - s390
> - sh
> - sparc
> - x86
> 
> Failures look like this:
> 
>   In file included from /builds/linux/include/linux/kernel.h:11,
>                    from /builds/linux/include/linux/list.h:9,
>                    from /builds/linux/include/linux/smp.h:12,
>                    from /builds/linux/include/linux/kernel_stat.h:5,
>                    from /builds/linux/mm/memory.c:42:
>   /builds/linux/mm/memory.c: In function 'finish_fault':
>   /builds/linux/mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHWPoisoned'; did you mean 'PageHWPoison'? [-Werror=implicit-function-declaration]
>    3929 |  if (unlikely(PageHasHWPoisoned(page)))
>         |               ^~~~~~~~~~~~~~~~~
>   /builds/linux/include/linux/compiler.h:78:42: note: in definition of macro 'unlikely'
>      78 | # define unlikely(x) __builtin_expect(!!(x), 0)
>         |                                          ^
>   cc1: some warnings being treated as errors
> 
> and this:
> 
>   /builds/linux/mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHWPoisoned' [-Werror,-Wimplicit-function-declaration]
>           if (unlikely(PageHasHWPoisoned(page)))
>                        ^
> 
>   /builds/linux/mm/page_alloc.c:1237:4: error: implicit declaration of function 'ClearPageHasHWPoisoned' [-Werror,-Wimplicit-function-declaration]
>                           ClearPageHasHWPoisoned(page);
>                           ^
>   /builds/linux/mm/page_alloc.c:1237:4: note: did you mean 'ClearPageHWPoison'?
> 

What configuration?  This builds for me on x86 here on allmodconfig.

thanks,

greg k-h
