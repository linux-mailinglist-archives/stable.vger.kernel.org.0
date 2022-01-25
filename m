Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F55F49B297
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 12:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380333AbiAYLGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 06:06:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33158 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380014AbiAYLFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 06:05:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C48AEB817AC;
        Tue, 25 Jan 2022 11:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D55BC340E5;
        Tue, 25 Jan 2022 11:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643108701;
        bh=39FnnUyDGSOvgkUBb+00t+cCFGHIMLKaoIpyavhQQ6w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n7tds+Ihf2R3fBDWT3me6dMPRYOh/Rh6ng3tva9fEieGIHl8prhSj/xeQog+q6Rl+
         BIlwBpFT1MMY17jZGPREjVqSOB/jNYSwakCdiUUdDq88dcQyF4rhjRUE4WTzQZr7Pk
         yABMAHofUknEbO/VFS+VCcFewmHRkK0murp0YE3k=
Date:   Tue, 25 Jan 2022 12:04:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/563] 5.10.94-rc1 review
Message-ID: <Ye/ZWs2+taBOscQA@kroah.com>
References: <20220124184024.407936072@linuxfoundation.org>
 <12c8fd1e-431e-9a59-9e7a-e8d856c088b9@linaro.org>
 <67b47645-016c-2d23-4710-b3743b073766@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <67b47645-016c-2d23-4710-b3743b073766@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 07:54:58PM -0800, Florian Fainelli wrote:
> 
> 
> On 1/24/2022 3:00 PM, Daniel Díaz wrote:
> > Hello!
> > 
> > On 1/24/22 12:36, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.94 release.
> > > There are 563 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.94-rc1.gz
> > > 
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > linux-5.10.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Regressions detected on arm, arm64, i386, x86.
> > 
> > This is from arm64:
> >    /builds/linux/arch/arm64/mm/extable.c: In function 'fixup_exception':
> >    /builds/linux/arch/arm64/mm/extable.c:17:13: error: implicit
> > declaration of function 'in_bpf_jit'
> > [-Werror=implicit-function-declaration]
> >       17 |         if (in_bpf_jit(regs))
> >          |             ^~~~~~~~~~
> >    cc1: some warnings being treated as errors
> >    make[3]: *** [/builds/linux/scripts/Makefile.build:280:
> > arch/arm64/mm/extable.o] Error 1
> > 
> > And from Perf on arm, arm64, i386, x86:
> >    libbpf.c: In function 'bpf_object__elf_collect':
> >    libbpf.c:2873:31: error: invalid type argument of '->' (have
> > 'GElf_Shdr' {aka 'Elf64_Shdr'})
> >     2873 |                         if (sh->sh_type != SHT_PROGBITS)
> >          |                               ^~
> >    libbpf.c:2877:31: error: invalid type argument of '->' (have
> > 'GElf_Shdr' {aka 'Elf64_Shdr'})
> >     2877 |                         if (sh->sh_type != SHT_PROGBITS)
> >          |                               ^~
> >    make[4]: *** [/builds/linux/tools/build/Makefile.build:97:
> > /home/tuxbuild/.cache/tuxmake/builds/current/staticobjs/libbpf.o] Error
> > 1
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Same here.

Thanks, I'll go drop this from all 3 trees now.

greg k-h
