Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAF1421F46
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 09:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbhJEHLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 03:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232561AbhJEHLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 03:11:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E13861425;
        Tue,  5 Oct 2021 07:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633417795;
        bh=LolzeVyvQ9Fdg5AkSm3PkTTdmlFXrwEm0GL30clzJto=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GxilFPaiS6TAr3bQVhm56wzc4JTQjhYIvMLUUju0F9keWMASsTqBJHwvoAeWZytso
         Ur8dqOIpN+fTIf/wdtaPFZ0UTFw/lePh/6iKtPZQpDMYrttaVpHfyAyOw72sYVcNmQ
         mRHXK3IXIDTJUwxNyEfqn2W/2Sbk1Jag8/alf8pjr3JSV0NZ9PT2pN7njnXka7FMkp
         VOeUvM84aserRlVX5MRJBD5CQv70yEU+3ydIDnQWT0DZ7LdIr9xBFl51zKPfZQSUew
         +zSLr7O8WiPyBbJBjOCQeUnn+AT9lJvJIQr27kiO+Aa2PBONDGxVKGpnSSdUjAOE1D
         QdRa/lhHU2QiQ==
Date:   Tue, 5 Oct 2021 15:09:49 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Frieder Schrempf <frieder@fris.de>
Cc:     devicetree@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: Re: [PATCH 4/8] arm64: dts: imx8mm-kontron: Fix reg_rst_eth2 and
 reg_vdd_5v regulators
Message-ID: <20211005070949.GB20743@dragon>
References: <20210930155633.2745201-1-frieder@fris.de>
 <20210930155633.2745201-5-frieder@fris.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930155633.2745201-5-frieder@fris.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 30, 2021 at 05:56:27PM +0200, Frieder Schrempf wrote:
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> The regulator reg_vdd_5v represents the fixed 5V supply on the board which
> can't be switched off. Mark it as always-on.
> 
> The regulator reg_rst_eth2 should keep the reset signal of the USB ethernet
> adapter deassertet anytime. Fix the polarity and mark it as always-on.

It seems to be wrong from the beginning that the reset is modelled by a
regulator.

> 
> Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> ---
>  arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> index 62ba3bd08a0c..f2c8ccefd1bf 100644
> --- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> +++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> @@ -70,7 +70,9 @@ reg_rst_eth2: regulator-rst-eth2 {
>  		regulator-name = "rst-usb-eth2";
>  		pinctrl-names = "default";
>  		pinctrl-0 = <&pinctrl_usb_eth2>;
> -		gpio = <&gpio3 2 GPIO_ACTIVE_LOW>;
> +		gpio = <&gpio3 2 GPIO_ACTIVE_HIGH>;
> +		enable-active-high;
> +		regulator-always-on;
>  	};
>  
>  	reg_vdd_5v: regulator-5v {
> @@ -78,6 +80,7 @@ reg_vdd_5v: regulator-5v {
>  		regulator-name = "vdd-5v";
>  		regulator-min-microvolt = <5000000>;
>  		regulator-max-microvolt = <5000000>;
> +		regulator-always-on;

You do not have any on/off control over the regulator.  So how does this
always-on property make any difference?

Shawn

>  	};
>  };
>  
> -- 
> 2.33.0
> 
