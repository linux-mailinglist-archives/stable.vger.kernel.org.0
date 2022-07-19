Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EF457A705
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 21:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238610AbiGSTQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 15:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238698AbiGSTQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 15:16:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F315912ABD;
        Tue, 19 Jul 2022 12:16:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07835B81CCF;
        Tue, 19 Jul 2022 19:16:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3022EC341C6;
        Tue, 19 Jul 2022 19:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658258164;
        bh=ryd1VCHXeiBQ/uWJfalnyBO4qew6MPHfrZrRDEW9THg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HdtL8f6vdqdZ86SOKqo+Lb5mgzvUu9qNwBVqah8nxQQ2W4l4arl1uNbmfCkzI6WzJ
         pWDn8FpZrngU6QCVpIRh6Q2nEFkc8M3mE33+660ohfpFQEAKsOkEdazE+ml3iM33/0
         BDGs2qYTjQPlq1yYyphsdkoNmJoCokNBecYdFraM=
Date:   Tue, 19 Jul 2022 21:16:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, John Harrison <John.C.Harrison@intel.com>,
        Tejas Upadhyay <tejas.upadhyay@intel.com>,
        Anusha Srivatsa <anusha.srivatsa@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Message-ID: <YtcC8XuEcnEISxcR@kroah.com>
References: <20220719114714.247441733@linuxfoundation.org>
 <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 11:27:18PM +0530, Naresh Kamboju wrote:
> On Tue, 19 Jul 2022 at 17:49, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.18.13 release.
> > There are 231 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.13-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> There are two regression found
> 
> 1)
> Build regression on i386 with clang-13 and clang-14,
> I do not see this build error on mainline.
> 
> 2) Too many build warnings x86 with gcc-11
> I do not see these build warnings on mainline,
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Details log:
> ------------
> 1. i386 build failures with clang-13 and clang-14
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=1
> ARCH=i386 CROSS_COMPILE=i686-linux-gnu- 'HOSTCC=sccache clang'
> 'CC=sccache clang'
> ld.lld: error: undefined symbol: __udivdi3
> >>> referenced by i915_scatterlist.c
> >>>               gpu/drm/i915/i915_scatterlist.o:(i915_rsgt_from_mm_node) in archive drivers/built-in.a
> make[1]: *** [/builds/linux/Makefile:1162: vmlinux] Error 1
> 
> 
> steps to reproduce:
> --------------------------
> tuxmake --runtime podman --target-arch i386 --toolchain clang-14
> --kconfig https://builds.tuxbuild.com/2CA3gjUTE2s74Bzp3G7q2hBxj1t/config
> LLVM=1 LLVM_IAS=1
> [1] https://builds.tuxbuild.com/2CA3gjUTE2s74Bzp3G7q2hBxj1t/
> 
> 
> 2. Large number of build warnings on x86 with gcc-11,
> I do not see these build warnings on mainline,
> 
> Build link: https://builds.tuxbuild.com/2CA3fVEQKJXLNNGgHvoEmFEjyPq/

Very odd, can you do bisect to track down the offending commits?

My local building test system is not working for unrelated issues (local
heat wave), and my cloud test systems are broken for some other unknown
reason, so I can't test this myself.

thanks,

greg k-h
