Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0B542E780
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 06:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbhJOELS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 00:11:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhJOELR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Oct 2021 00:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BECF56058D;
        Fri, 15 Oct 2021 04:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634270951;
        bh=9wYm3/Ll/jdCBRIBMa/tBI8ZuMw1Bu4NWha2opzSxxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qnmgFXiUhKMpnzEMW25QN3ISvoR/hFcdtG9WibPtzTgAEwCOGBoTRKX6+AEFVJeOE
         Wa7lrGomgZKJv8uA3WTt/VyFmOFDOAichm8mU+YoUzjHjKUH+YnWa/CWJbzEW9gsFO
         jGtostUbsgEh5rjWd/F2opcNMKaNFKk+Z+N3bWkBpPyKWTV0uDmxWOJpR/3+EsXr7e
         bmiAzgiqM//+4ZQolnROtYThQ1oROfe2iYcR+K5ad3OBmmdVtUWg8OpeTw/avcbTHa
         Xk4wBzeqINZfx1x6v91ezroeFoWNcQH3DAlsLiCHuREfqD3yR1bYMWIREw1YaYokO/
         z0Gp54GQ8p6UA==
Date:   Fri, 15 Oct 2021 12:09:05 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     Frieder Schrempf <frieder@fris.de>, devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: Re: [PATCH 4/8] arm64: dts: imx8mm-kontron: Fix reg_rst_eth2 and
 reg_vdd_5v regulators
Message-ID: <20211015040904.GG22881@dragon>
References: <20210930155633.2745201-1-frieder@fris.de>
 <20210930155633.2745201-5-frieder@fris.de>
 <20211005070949.GB20743@dragon>
 <725cc24e-f264-60ea-e30c-c50a61f7fe88@kontron.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <725cc24e-f264-60ea-e30c-c50a61f7fe88@kontron.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 05, 2021 at 07:06:57PM +0200, Frieder Schrempf wrote:
> On 05.10.21 09:09, Shawn Guo wrote:
> > On Thu, Sep 30, 2021 at 05:56:27PM +0200, Frieder Schrempf wrote:
> >> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> >>
> >> The regulator reg_vdd_5v represents the fixed 5V supply on the board which
> >> can't be switched off. Mark it as always-on.
> >>
> >> The regulator reg_rst_eth2 should keep the reset signal of the USB ethernet
> >> adapter deassertet anytime. Fix the polarity and mark it as always-on.
> > 
> > It seems to be wrong from the beginning that the reset is modelled by a
> > regulator.
> 
> Right, but at least at the time when I upstreamed this, there was no way
> to pass the reset GPIO to a USB device driver and using a regulator
> seems to be an accepted workaround as far as I understand.

Do we have the solution in usb driver now?  If so, we should probably
switch to that, instead of patching the workaround?

Shawn

> 
> > 
> >>
> >> Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> >> ---
> >>  arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 5 ++++-
> >>  1 file changed, 4 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> >> index 62ba3bd08a0c..f2c8ccefd1bf 100644
> >> --- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> >> +++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> >> @@ -70,7 +70,9 @@ reg_rst_eth2: regulator-rst-eth2 {
> >>  		regulator-name = "rst-usb-eth2";
> >>  		pinctrl-names = "default";
> >>  		pinctrl-0 = <&pinctrl_usb_eth2>;
> >> -		gpio = <&gpio3 2 GPIO_ACTIVE_LOW>;
> >> +		gpio = <&gpio3 2 GPIO_ACTIVE_HIGH>;
> >> +		enable-active-high;
> >> +		regulator-always-on;
> >>  	};
> >>  
> >>  	reg_vdd_5v: regulator-5v {
> >> @@ -78,6 +80,7 @@ reg_vdd_5v: regulator-5v {
> >>  		regulator-name = "vdd-5v";
> >>  		regulator-min-microvolt = <5000000>;
> >>  		regulator-max-microvolt = <5000000>;
> >> +		regulator-always-on;
> > 
> > You do not have any on/off control over the regulator.  So how does this
> > always-on property make any difference?
> 
> Right, this doesn't make a difference and is definitely not a fix, I
> will drop it. Anyway, this regulator is just there for completeness of
> the hardware description.
> 
> > 
> >>  	};
> >>  };
> >>  
> >> -- 
> >> 2.33.0
> >>
