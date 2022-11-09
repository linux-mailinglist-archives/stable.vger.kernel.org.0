Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2763F6224AB
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 08:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiKIHb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 02:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKIHb4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 02:31:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECB118B2D;
        Tue,  8 Nov 2022 23:31:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F20F3618CE;
        Wed,  9 Nov 2022 07:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B85C433D6;
        Wed,  9 Nov 2022 07:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667979114;
        bh=EOWmyD03SDZ1GYkeV4mq1oxpNen0gztZFYKYOEiHA3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BKHNMgZYpu3EKtFbQOtQe9XFAtwTK8BopniL6PbxhiaHbigtKn3CN+0shHEsF85dr
         Q/Gm8WBuKmz960HL5jqZa1E5TtBDJ1OvSXOyEoqYKdmSdnUrpnMNf1v+9aQgNt/TTT
         zKiupQnSBNNT4e7VZxARrO7j6tqcnDzsGlO9FkCs=
Date:   Wed, 9 Nov 2022 08:31:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     sashal@kernel.org, stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 000/118] 5.10.154-rc1 review
Message-ID: <Y2tXZzfzWaeJvWis@kroah.com>
References: <20221108133340.718216105@linuxfoundation.org>
 <Y2pxr88XE+XP6uNc@duo.ucw.cz>
 <Y2q0A/sbF65Z8UBs@kroah.com>
 <Y2rAK1mD2n8wIMm2@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2rAK1mD2n8wIMm2@duo.ucw.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 08, 2022 at 09:46:35PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > This is the start of the stable review cycle for the 5.10.154 release.
> > > > There are 118 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > 
> > > I'm getting build errors with the dtbs:
> > > 
> > > Error: arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:1296.24-25 syntax error
> > > 10169FATAL ERROR: Unable to parse input tree
> > > 10170make[2]: *** [scripts/Makefile.lib:326: arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-cx.dtb] Error 1
> > > 10171make[2]: *** Waiting for unfinished jobs....
> > > 10172Error: arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:1296.24-25 syntax error
> > > 10173FATAL ERROR: Unable to parse input tree
> > > 10174make[2]: *** [scripts/Makefile.lib:326: arch/arm64/boot/dts/freescale/fsl-lx2160a-honeycomb.dtb] Error 1
> > > 10175  DTC     arch/arm64/boot/dts/renesas/r8a774b1-hihope-rzg2n-rev2.dtb
> > > 10176  DTC     arch/arm64/boot/dts/allwinner/sun50i-h5-bananapi-m2-plus-v1.2.dtb
> > > 10177  DTC     arch/arm64/boot/dts/renesas/r8a774b1-hihope-rzg2n-rev2-ex.dtb
> > > 10178Error: arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:1296.24-25 syntax error
> > > 10179FATAL ERROR: Unable to parse input tree
> > > 10180make[2]: *** [scripts/Makefile.lib:326: arch/arm64/boot/dts/freescale/fsl-lx2160a-qds.dtb] Error 1
> > > 10181  DTC     arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dtb
> > > 10182
> > > 
> > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/3291098692
> > 
> > Odd.
> > 
> > Sasha, any ideas what went wrong here, but not in the other
> > branches?
> 
> I believe it is this commit:
> 
>  |4f9355148 c126a0 .: 5.10| arm64: dts: lx2160a: specify clock frequencies for the MDIO controllers
> 
> pavel@duo:~/cip/krc$ grep -ri QORIQ_CLK_PLL_DIV .
> ./arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:					    QORIQ_CLK_PLL_DIV(2)>;
> ./arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:					    QORIQ_CLK_PLL_DIV(2)>;
> pavel@duo:~/cip/krc$ 
> 
> The macro QORIQ_CLK_PLL_DIV is not defined in 5.10, so it confuses
> parser. I guess it should be dropped, or dependencies should be added.
> 
> We need this:
> 
> include/dt-bindings/clock/fsl,qoriq-clockgen.h:#define QORIQ_CLK_PLL_DIV(x)     ((x) - 1)
> 
> Which was added in commit 4cb15934ba05b49784d9d47778af308e7ea50b69 to
> mainline. That's not only dependency. 

Ok, let me just rip this series out, if anyone with this hardware really
needs it on old 5.10, they can provide a working backported set of
patches.

thanks,

greg k-h
