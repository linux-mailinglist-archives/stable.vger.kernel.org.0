Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17F142E788
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 06:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbhJOEPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 00:15:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233083AbhJOEPA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Oct 2021 00:15:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F9AA61168;
        Fri, 15 Oct 2021 04:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634271174;
        bh=ep/IXH3UxYH/vOBTWCg7qNPyVSjQ3xGnQubpgz0v/V4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n6LAhMRKZOIopPXdzW0rHn0TXO9aq6GW48M95bssT/Qu4/N/zKrqxhEC+tdhU4LXx
         37HChB1W3b8uppBWdpYXJa+B5jEuFb3dLe8w0Xl9YWTxb/IT8jI5bBVPAfVabk5SNI
         0BFoipCGiQ/R8iG4KucsrtUfqilWjEVxSWMNV7bF8Tissco4BmKrQCfmMpx3E5cSFv
         F7osaIOhPrLvwyaurfG7ggqIZaClT76RNMrpOCmHyqijwhjBNTsy9UoXbmD0heoCZG
         zVtz8ENURA5dAofGoZ433BOAdlSWnQivCpQ+63WCi1ude9iKDYKjQyDfcHcNVlJ0lP
         322unydic2xsQ==
Date:   Fri, 15 Oct 2021 12:12:40 +0800
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
Subject: Re: [PATCH 5/8] arm64: dts: imx8mm-kontron: Fix CAN SPI clock
 frequency
Message-ID: <20211015041239.GH22881@dragon>
References: <20210930155633.2745201-1-frieder@fris.de>
 <20210930155633.2745201-6-frieder@fris.de>
 <20211005071230.GC20743@dragon>
 <37c1845d-9323-3187-ed0b-b9795758649d@kontron.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37c1845d-9323-3187-ed0b-b9795758649d@kontron.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 05, 2021 at 07:17:13PM +0200, Frieder Schrempf wrote:
> On 05.10.21 09:12, Shawn Guo wrote:
> > On Thu, Sep 30, 2021 at 05:56:28PM +0200, Frieder Schrempf wrote:
> >> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> >>
> >> The MCP2515 can be used with an SPI clock of up to 10 MHz. Set the
> >> limit accordingly to prevent any performance issues caused by the
> >> really low clock speed of 100 kHz.
> > 
> > Could you share some testing result of this change?
> 
> Without this change, receiving CAN messages on the board beyond a
> certain bitrate will cause overrun errors (see 'ip -det -stat link show
> can0').
> 
> With this fix, receiving messages on the bus works without any overrun
> errors for bitrates up to 1 MBit.
> 
> 
> > 
> >>
> >> Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
> > 
> > It's really an optimization rather than fix, isn't it?
> 
> It removes the arbitrarily low limit on the SPI frequency, that was
> caused by a typo in the original dts. As the usage of the CAN bus is
> seriously affected by this I would consider it a fix. But if you think
> otherwise, feel free to remove the Fixes tag.

Put all these good information into commit log, and I will be happy to
take it as a fix.

Shawn

> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> >> ---
> >>  arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> >> index f2c8ccefd1bf..dbf11e03ecce 100644
> >> --- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> >> +++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> >> @@ -98,7 +98,7 @@ can0: can@0 {
> >>  		clocks = <&osc_can>;
> >>  		interrupt-parent = <&gpio4>;
> >>  		interrupts = <28 IRQ_TYPE_EDGE_FALLING>;
> >> -		spi-max-frequency = <100000>;
> >> +		spi-max-frequency = <10000000>;
> >>  		vdd-supply = <&reg_vdd_3v3>;
> >>  		xceiver-supply = <&reg_vdd_5v>;
> >>  	};
> >> -- 
> >> 2.33.0
> >>
