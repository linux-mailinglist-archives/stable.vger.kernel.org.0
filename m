Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30CBE6B0281
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 10:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCHJMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 04:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjCHJMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 04:12:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E9D14217;
        Wed,  8 Mar 2023 01:12:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87F8F61707;
        Wed,  8 Mar 2023 09:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D734C4339B;
        Wed,  8 Mar 2023 09:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678266749;
        bh=X25NHtkaVuP8yZUf1SSkHKndCYcAYvikXlaaxG/lrKo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MebCWkTsoFxh9dSWo5YOIBwwmUvFg1WQmNvHC9UDGDJdkzgBY1f9YQ//WBGEVgUjo
         bQYn2sG4oA3XF/igN0MeiA53Kd7bpz8SeuCLEeP7fs9cX+Z4CgwnKuNaYIxeQPlZwM
         oDnbr2MxsDd7C4YeHu4Btke0vsaD7tWr/JZtk2iM=
Date:   Wed, 8 Mar 2023 10:12:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        pali@kernel.org, christophe.leroy@csgroup.eu, mpe@ellerman.id.au
Subject: Re: [PATCH 6.2 0000/1001] 6.2.3-rc1 review
Message-ID: <ZAhReYn2rPbdgQnj@kroah.com>
References: <20230307170022.094103862@linuxfoundation.org>
 <81cd2720-0414-1213-3826-31bd240d5c75@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81cd2720-0414-1213-3826-31bd240d5c75@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 06:01:42PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 07/03/23 10:46, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.2.3 release.
> > There are 1001 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 09 Mar 2023 16:57:34 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.3-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> We see a regression with PowerPC's ppc64e_defconfig, using GCC 8 and GCC 12:
> -----8<-----
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:237: arch/powerpc/boot/crt0.o] Error 1
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:237: arch/powerpc/boot/crtsavres.o] Error 1
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/cuboot.o] Error 1
> [...]
> make[2]: Target 'arch/powerpc/boot/zImage' not remade because of errors.
> make[1]: *** [/builds/linux/arch/powerpc/Makefile:247: zImage] Error 2
> make[1]: Target '__all' not remade because of errors.
> make: *** [Makefile:242: __sub-make] Error 2
> make: Target '__all' not remade because of errors.
> ----->8-----
> 
> Bisection points to "powerpc/boot: Don't always pass -mcpu=powerpc when building 32-bit uImage" (upstream ff7c76f66d8bad4e694c264c789249e1d3a8205d).
> 
> Reproducer:
>   tuxmake \
>     --runtime podman \
>     --target-arch powerpc \
>     --toolchain gcc-8 \
>     --kconfig ppc64e_defconfig \
>     config debugkernel dtbs kernel modules xipkernel

Thanks, now dropping this from all trees.

greg k-h
