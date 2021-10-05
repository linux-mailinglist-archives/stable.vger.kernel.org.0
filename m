Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771A9421F57
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 09:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbhJEHWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 03:22:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230526AbhJEHWj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 03:22:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E092361409;
        Tue,  5 Oct 2021 07:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633418449;
        bh=N7hQX43Kc4fE1oxsGIaIgA7jCH+iDTQUQqbND1FQvec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fQx/oH/Qe3bDAJIP7MxqLrVxADMwPDT+NeIDwVwCPVs/ndILpILM8+xyr/nwBfSRa
         qYPNEuOVdLZr4EOEULM0AZSnyvMPelUd+ELNseGJYzeaPuzl2KBTKEe2LQiO8mPZAA
         u71EXhikzdVPvxoitG6yAmEicZSq2jihmdxkJdfYeJIUtZiT8mFCrA4lEI9D2LLRvw
         tn0LsQEZ82LXJiXP5fgUMBPNMUZzkvLbiK/Xq7ytIKkL2j53eKF0f0/LVNZ2C+yxUe
         /3t6OgC0Np5i4id8X2NIgcub1Arj2WYlG9FowDp3ZKqB41pF27EFEX1beKeMkJcE46
         dy1SO9AJl7hiw==
Date:   Tue, 5 Oct 2021 15:20:43 +0800
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
Subject: Re: [PATCH 6/8] arm64: dts: imx8mm-kontron: Fix connection type for
 VSC8531 RGMII PHY
Message-ID: <20211005072042.GD20743@dragon>
References: <20210930155633.2745201-1-frieder@fris.de>
 <20210930155633.2745201-7-frieder@fris.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930155633.2745201-7-frieder@fris.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 30, 2021 at 05:56:29PM +0200, Frieder Schrempf wrote:
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> Previously we falsely relied on the PHY driver to unconditionally
> enable the internal RX delay. Since the following fix for the PHY
> driver this is not the case anymore:
> 
> commit 7b005a1742be ("net: phy: mscc: configure both RX and TX internal
> delays for RGMII")
> 
> In order to enable the delay we need to set the connection type to
> "rgmii-rxid".

Could you share some details of the issue that the delay is not enabled,
e.g. how broken the Ethernet support is without this change?

Shawn

> 
> Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> ---
>  arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> index dbf11e03ecce..0e4509287a92 100644
> --- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> +++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> @@ -114,7 +114,7 @@ &ecspi3 {
>  &fec1 {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_enet>;
> -	phy-connection-type = "rgmii";
> +	phy-connection-type = "rgmii-rxid";
>  	phy-handle = <&ethphy>;
>  	status = "okay";
>  
> -- 
> 2.33.0
> 
