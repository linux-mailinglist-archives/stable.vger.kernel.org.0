Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1A53D64E1
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240352AbhGZQNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 12:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239756AbhGZQLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 12:11:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4100E60462;
        Mon, 26 Jul 2021 16:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627318288;
        bh=jenQ/CVQ01VrBAqQU+YZZlOof19gHyOisvFtVCrzQCc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jw1WQDqrzvzKtTs7IUmttyA9+5G/lxW5fE82JB/A+l3xnTw2xeEz2chs7GNFqFIcX
         +VnZ/0I/H+zkjmEtJucm52XIXwqI7o8YkLEIzRgCe5AheLIASlVY/HRlN2wFOeeEE7
         dinf8pF7hCi4dltdkz/iyLQhLrqeNeDOLBYpVUYQ=
Date:   Mon, 26 Jul 2021 18:51:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.13 000/223] 5.13.6-rc1 review
Message-ID: <YP7oDvwaAuwoek1h@kroah.com>
References: <20210726153846.245305071@linuxfoundation.org>
 <99b34fe9-0f1f-c94f-58d5-cfb43de98d76@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <99b34fe9-0f1f-c94f-58d5-cfb43de98d76@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 11:43:10AM -0500, Daniel Díaz wrote:
> Hello!
> 
> On 7/26/21 10:36 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.13.6 release.
> > There are 223 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.6-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Build regressions detected across plenty of architectures and configurations:
> 
>   /builds/linux/net/core/dev.c: In function 'gro_list_prepare':
>   /builds/linux/net/core/dev.c:5988:72: error: 'TC_SKB_EXT' undeclared (first use in this function)
>    5988 |                         struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
>         |                                                                        ^~~~~~~~~~
>   /builds/linux/net/core/dev.c:5988:72: note: each undeclared identifier is reported only once for each function it appears in
>   /builds/linux/net/core/dev.c:5993:47: error: invalid use of undefined type 'struct tc_skb_ext'
>    5993 |                                 diffs |= p_ext->chain ^ skb_ext->chain;
>         |                                               ^~
>   /builds/linux/net/core/dev.c:5993:64: error: invalid use of undefined type 'struct tc_skb_ext'
>    5993 |                                 diffs |= p_ext->chain ^ skb_ext->chain;
>         |                                                                ^~
>   make[3]: *** [/builds/linux/scripts/Makefile.build:273: net/core/dev.o] Error 1
>   make[3]: Target '__build' not remade because of errors.
>   make[2]: *** [/builds/linux/scripts/Makefile.build:516: net/core] Error 2
>   make[2]: Target '__build' not remade because of errors.
>   make[1]: *** [/builds/linux/Makefile:1853: net] Error 2
>   make[1]: Target '__all' not remade because of errors.
>   make: *** [Makefile:220: __sub-make] Error 2
> 
> 
> Here's a summary:
> * arc: 10 total, 4 passed, 6 failed
> * arm: 193 total, 18 passed, 175 failed
> * arm64: 27 total, 12 passed, 15 failed
> * dragonboard-410c: 1 total, 0 passed, 1 failed
> * hi6220-hikey: 1 total, 0 passed, 1 failed
> * i386: 26 total, 12 passed, 14 failed
> * mips: 45 total, 15 passed, 30 failed
> * parisc: 9 total, 6 passed, 3 failed
> * powerpc: 27 total, 6 passed, 21 failed
> * riscv: 21 total, 14 passed, 7 failed
> * s390: 18 total, 12 passed, 6 failed
> * sh: 18 total, 6 passed, 12 failed
> * sparc: 9 total, 6 passed, 3 failed
> * x15: 1 total, 0 passed, 1 failed
> * x86: 1 total, 0 passed, 1 failed
> * x86_64: 27 total, 12 passed, 15 failed
> 
> All failed, except allnoconfig, tinyconfig, and a few others here and there.
> 
> Same applies for 5.10.

Ah, I missed:
	9615fe36b31d ("skbuff: Fix build with SKB extensions disabled")
will fix that and push out a 5.13.y and 5.10.y update now...

thanks,

greg k-h
