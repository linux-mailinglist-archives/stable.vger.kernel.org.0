Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AC93A0C61
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 08:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhFIG1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 02:27:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230096AbhFIG1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 02:27:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC0CE61040;
        Wed,  9 Jun 2021 06:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623219926;
        bh=8hvt6+ZkRROs1PtG4jACBGU3OkGalj2mK9AeMaRtTHo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kf8O9zBR01nzRZVPwUNwKoK+6Ys/lzDk1nQl6HFstNiKOCHrobWlbRbmelep5xIwc
         QHZiDYG8jSDAGFNLtTsFy041CRFVVJl2OtXQpNR28ht3UVQTJtzIYMIVSy01GhmRIN
         d7GiYglOUdNRisekPwpZpqoE21Il7kZVqKUVKchE=
Date:   Wed, 9 Jun 2021 08:25:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Ludwig Zenz <lzenz@dh-electronics.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH 4.19 28/58] ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5
 regulators
Message-ID: <YMBe07JJemw4zH97@kroah.com>
References: <20210608175932.263480586@linuxfoundation.org>
 <20210608175933.214613488@linuxfoundation.org>
 <CA+G9fYvFujaoUqbLh_gcfnPjUVVQD=VHqi6k2ruf57BO1tR5ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvFujaoUqbLh_gcfnPjUVVQD=VHqi6k2ruf57BO1tR5ag@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 09, 2021 at 12:43:46AM +0530, Naresh Kamboju wrote:
> On Wed, 9 Jun 2021 at 00:08, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Marek Vasut <marex@denx.de>
> >
> > commit 8967b27a6c1c19251989c7ab33c058d16e4a5f53 upstream.
> >
> > Per schematic, both PU and SOC regulator are supplied from LTC3676 SW1
> > via VDDSOC_IN rail, add the PU input. Both VDD1P1, VDD2P5 are supplied
> > from LTC3676 SW2 via VDDHIGH_IN rail, add both inputs.
> >
> > While no instability or problems are currently observed, the regulators
> > should be fully described in DT and that description should fully match
> > the hardware, else this might lead to unforseen issues later. Fix this.
> >
> > Fixes: 52c7a088badd ("ARM: dts: imx6q: Add support for the DHCOM iMX6 SoM and PDK2")
> > Reviewed-by: Fabio Estevam <festevam@gmail.com>
> > Signed-off-by: Marek Vasut <marex@denx.de>
> > Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
> > Cc: Fabio Estevam <festevam@gmail.com>
> > Cc: Ludwig Zenz <lzenz@dh-electronics.com>
> > Cc: NXP Linux Team <linux-imx@nxp.com>
> > Cc: Shawn Guo <shawnguo@kernel.org>
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
> > Signed-off-by: Shawn Guo <shawnguo@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  arch/arm/boot/dts/imx6q-dhcom-som.dtsi |   12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > --- a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
> > +++ b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
> > @@ -407,6 +407,18 @@
> >         vin-supply = <&sw1_reg>;
> >  };
> >
> > +&reg_pu {
> > +       vin-supply = <&sw1_reg>;
> > +};
> > +
> > +&reg_vdd1p1 {
> > +       vin-supply = <&sw2_reg>;
> > +};
> > +
> > +&reg_vdd2p5 {
> > +       vin-supply = <&sw2_reg>;
> > +};
> > +
> >  &uart1 {
> >         pinctrl-names = "default";
> >         pinctrl-0 = <&pinctrl_uart1>;
> 
> arm dtb build failed on stable rc 4.19
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm
> CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
> arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
> Error: /builds/linux/arch/arm/boot/dts/imx6q-dhcom-som.dtsi:414.1-12
> Label or path reg_vdd1p1 not found
> Error: /builds/linux/arch/arm/boot/dts/imx6q-dhcom-som.dtsi:418.1-12
> Label or path reg_vdd2p5 not found
> FATAL ERROR: Syntax error parsing input tree
> make[2]: *** [scripts/Makefile.lib:294:
> arch/arm/boot/dts/imx6q-dhcom-pdk2.dtb] Error 1
> 
> Reported-by:  Linux Kernel Functional Testing <lkft@linaro.org>
> 
> build url:
> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1328891505#L477
> 
> Config:
> https://builds.tuxbuild.com/1tg0YjTz4ow5CkHv0bzTc05pVs5/config

Thanks, will go delete this and push out a -rc2.

greg k-h
