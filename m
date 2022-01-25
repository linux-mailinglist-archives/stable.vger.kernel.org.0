Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D1B49B2B6
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 12:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352568AbiAYLJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 06:09:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55926 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380383AbiAYLHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 06:07:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 559FF6168C;
        Tue, 25 Jan 2022 11:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F26C340E0;
        Tue, 25 Jan 2022 11:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643108819;
        bh=TbnkLQTiTeqIDmw4aTBz+3S4Bt7hZRynS2urFHdSxWg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=chZ5AF4mA741MxVMvKpivMYwdgbZpkckdRsNc+Td/8HWvDIEMRzFzsMDnZbDN7J4i
         fcbBEz8Pl/iT4G2sUhjrh60LVRLinwPUAbW9eltla13lZY8BvbN139BFEbpPNliFma
         /8S1gR3ziDtUaBGfBI7F3+O+sIREgEpguBW6a2ug=
Date:   Tue, 25 Jan 2022 12:06:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/846] 5.15.17-rc1 review
Message-ID: <Ye/Z0Z376A6BHKhC@kroah.com>
References: <20220124184100.867127425@linuxfoundation.org>
 <374e9357-35eb-3555-3fe5-7b72c3a77a39@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <374e9357-35eb-3555-3fe5-7b72c3a77a39@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 04:50:45PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 1/24/22 12:31, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.17 release.
> > There are 846 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.17-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Regressions detected on arm, arm64, i386, x86.
> 
> This is one from arm64:
>   /builds/linux/arch/arm64/mm/extable.c: In function 'fixup_exception':
>   /builds/linux/arch/arm64/mm/extable.c:17:13: error: implicit declaration of function 'in_bpf_jit' [-Werror=implicit-function-declaration]
>      17 |         if (in_bpf_jit(regs))
>         |             ^~~~~~~~~~
>   cc1: some warnings being treated as errors
>   make[3]: *** [/builds/linux/scripts/Makefile.build:277: arch/arm64/mm/extable.o] Error 1
> 
> This is another one, in Perf (arm, arm64, i386, x86):
>   libbpf.c: In function 'bpf_object__elf_collect':
>   libbpf.c:3038:31: error: invalid type argument of '->' (have 'GElf_Shdr' {aka 'Elf64_Shdr'})
>    3038 |                         if (sh->sh_type != SHT_PROGBITS)
>         |                               ^~
>   libbpf.c:3042:31: error: invalid type argument of '->' (have 'GElf_Shdr' {aka 'Elf64_Shdr'})
>    3042 |                         if (sh->sh_type != SHT_PROGBITS)
>         |                               ^~
>   make[4]: *** [/builds/linux/tools/build/Makefile.build:97: /home/tuxbuild/.cache/tuxmake/builds/current/staticobjs/libbpf.o] Error 1
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 

Thanks, should be fixed in -rc2.

greg k-h
