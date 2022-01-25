Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA6D49B2C3
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 12:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380822AbiAYLOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 06:14:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58562 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380647AbiAYLLq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 06:11:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A1AA6167E;
        Tue, 25 Jan 2022 11:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1755AC340E0;
        Tue, 25 Jan 2022 11:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643109104;
        bh=YS06zIvlnkJE5Far5hDwEfLX+8yJSh26b2g6RKbyPD4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IVmSkAnMWJ6rSObPn4mlTZUPTjL1RaMFaMxw+rrDDEUkm8CRlrri4zFA3CZc3v0m6
         KRzWwf/YkKCQGwF9N4GadTiwSB7mXkYyKYojzUYcPtXE01eXEm8SIkrNNndrA3o0jY
         dJ7cxI+NA2dmHyVx+z2l1IAD8CTSpDXS+64Hy29w=
Date:   Tue, 25 Jan 2022 12:11:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/320] 5.4.174-rc1 review
Message-ID: <Ye/a7UZCEzBWXe66@kroah.com>
References: <20220124183953.750177707@linuxfoundation.org>
 <e2c9b01d-0500-645f-b4cc-f8dcb769996e@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e2c9b01d-0500-645f-b4cc-f8dcb769996e@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 05:39:58PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 1/24/22 12:39, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.174 release.
> > There are 320 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.174-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Regressions detected on arm, arm64, i386, x86, parisc.
> 
> This is on Perf on arm, arm64, i386, x86:
> 
>   libbpf.c: In function 'bpf_object__elf_collect':
>   libbpf.c:1581:31: error: invalid type argument of '->' (have 'GElf_Shdr' {aka 'Elf64_Shdr'})
>    1581 |                         if (sh->sh_type != SHT_PROGBITS)
>         |                               ^~
>   libbpf.c:1585:31: error: invalid type argument of '->' (have 'GElf_Shdr' {aka 'Elf64_Shdr'})
>    1585 |                         if (sh->sh_type != SHT_PROGBITS)
>         |                               ^~
>   make[4]: *** [/builds/linux/tools/build/Makefile.build:97: /home/tuxbuild/.cache/tuxmake/builds/current/staticobjs/libbpf.o] Error 1

libbpf is not perf :)

Anyway, I'll go drop the offending libbpf patch, thanks.

> This is from PA-RISC with gcc-8, gcc-9, gcc-10, gcc-11:
> 
>   /builds/linux/drivers/parisc/sba_iommu.c: In function 'sba_io_pdir_entry':
>   /builds/linux/arch/parisc/include/asm/special_insns.h:11:3: error: expected ':' or ')' before 'ASM_EXCEPTIONTABLE_ENTRY'
>      ASM_EXCEPTIONTABLE_ENTRY(8b, 9b) \
>      ^~~~~~~~~~~~~~~~~~~~~~~~
> 
> 
> Bisection of the latter points to "parisc: Fix lpa and lpa_user defines".

thanks, will go drop this one from 5.4.

greg k-h
