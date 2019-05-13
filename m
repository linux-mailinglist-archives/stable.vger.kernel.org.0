Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65DA21BBA6
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 19:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbfEMRSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 13:18:55 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:41960 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfEMRSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 May 2019 13:18:55 -0400
Received: from svr-orw-mbx-01.mgc.mentorg.com ([147.34.90.201])
        by relay1.mentorg.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        id 1hQEat-0003zZ-7u from George_Davis@mentor.com ; Mon, 13 May 2019 10:18:31 -0700
Received: from localhost (147.34.91.1) by svr-orw-mbx-01.mgc.mentorg.com
 (147.34.90.201) with Microsoft SMTP Server (TLS) id 15.0.1320.4; Mon, 13 May
 2019 10:18:28 -0700
Date:   Mon, 13 May 2019 13:18:27 -0400
From:   "George G. Davis" <george_davis@mentor.com>
To:     Fabio Estevam <festevam@gmail.com>, <stable@vger.kernel.org>
CC:     <shawnguo@kernel.org>, <andrew@lunn.ch>, <baruch@tkos.co.il>,
        <ken.lin@advantech.com>, <smoch@web.de>,
        <stwiss.opensource@diasemi.com>, <linux-imx@nxp.com>,
        <kernel@pengutronix.de>, Marc Kleine-Budde <mkl@pengutronix.de>,
        <aford173@gmail.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] ARM: dts: imx: Fix the AR803X phy-mode
Message-ID: <20190513171826.GA18591@mam-gdavis-lt>
References: <20190403221241.4753-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190403221241.4753-1-festevam@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: svr-orw-mbx-03.mgc.mentorg.com (147.34.90.203) To
 svr-orw-mbx-01.mgc.mentorg.com (147.34.90.201)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Wed, Apr 03, 2019 at 07:12:41PM -0300, Fabio Estevam wrote:
> Commit 6d4cd041f0af ("net: phy: at803x: disable delay only for RGMII mode")
> exposed an issue on imx DTS files using AR8031/AR8035 PHYs.
> 
> The end result is that the boards can no longer obtain an IP address
> via UDHCP, for example.
> 
> Quoting Andrew Lunn:
> 
> "The problem here is, all the DTs were broken since day 0. However,
> because the PHY driver was also broken, nobody noticed and it
> worked. Now that the PHY driver has been fixed, all the bugs in the
> DTs now become an issue"
> 
> To fix this problem, the phy-mode property needs to be "rgmii-id",  which
> has the following meaning as per 
> Documentation/devicetree/bindings/net/ethernet.txt:
> 
> "RGMII with internal RX and TX delays provided by the PHY, the MAC should
> not add the RX or TX delays in this case)"
> 
> Tested on imx6-sabresd, imx6sx-sdb and imx7d-pico boards with
> successfully restored networking.
> 
> Based on the initial submission from Steve Twiss for the
> imx6qdl-sabresd.
> 
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> Tested-by: Baruch Siach <baruch@tkos.co.il>
> Tested-by: Soeren Moch <smoch@web.de>
> Tested-by: Steve Twiss <stwiss.opensource@diasemi.com>
> Tested-by: Adam Thomson <Adam.Thomson@diasemi.com>
> Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
> Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
> Changes since v2:
> - Also fixed imx6q-ba16
> - Removed stable tag as it does not apply cleanly on older
> stable trees. I can manually generate versions for stable
> trees after this one hits mainline.

Please add this commit to the v5.1.x stable queue to resolve NFS root breakage
in v5.1. I can confirm that it applies cleanly to v5.1.1 and resolves NFS root
breakage that occurs on i.MX6 boards in v5.1.x, tested on imx6q-sabreauto.dts
and imx6q-sabresd.dts. Although the fix should be backported to pre-v5.1.x
stable series as well, it does not cause problems for pre-v5.1 but results in
NFS root breakage for v5.1.x.

TIA!

> 
>  arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi | 2 +-
>  arch/arm/boot/dts/imx6dl-riotboard.dts        | 2 +-
>  arch/arm/boot/dts/imx6q-ba16.dtsi             | 2 +-
>  arch/arm/boot/dts/imx6q-marsboard.dts         | 2 +-
>  arch/arm/boot/dts/imx6q-tbs2910.dts           | 2 +-
>  arch/arm/boot/dts/imx6qdl-apf6.dtsi           | 2 +-
>  arch/arm/boot/dts/imx6qdl-sabreauto.dtsi      | 2 +-
>  arch/arm/boot/dts/imx6qdl-sabresd.dtsi        | 2 +-
>  arch/arm/boot/dts/imx6qdl-sr-som.dtsi         | 2 +-
>  arch/arm/boot/dts/imx6qdl-wandboard.dtsi      | 2 +-
>  arch/arm/boot/dts/imx6sx-sabreauto.dts        | 2 +-
>  arch/arm/boot/dts/imx6sx-sdb.dtsi             | 2 +-
>  arch/arm/boot/dts/imx7d-pico.dtsi             | 2 +-
>  13 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi b/arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi
> index fb01fa6e4224..3cae139e6396 100644
> --- a/arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi
> +++ b/arch/arm/boot/dts/imx6-logicpd-baseboard.dtsi
> @@ -216,7 +216,7 @@
>  &fec {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_enet>;
> -	phy-mode = "rgmii";
> +	phy-mode = "rgmii-id";
>  	phy-reset-duration = <10>;
>  	phy-reset-gpios = <&gpio1 24 GPIO_ACTIVE_LOW>;
>  	phy-supply = <&reg_enet>;
> diff --git a/arch/arm/boot/dts/imx6dl-riotboard.dts b/arch/arm/boot/dts/imx6dl-riotboard.dts
> index 65c184bb8fb0..d9de49efa802 100644
> --- a/arch/arm/boot/dts/imx6dl-riotboard.dts
> +++ b/arch/arm/boot/dts/imx6dl-riotboard.dts
> @@ -92,7 +92,7 @@
>  &fec {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_enet>;
> -	phy-mode = "rgmii";
> +	phy-mode = "rgmii-id";
>  	phy-reset-gpios = <&gpio3 31 GPIO_ACTIVE_LOW>;
>  	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
>  			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
> diff --git a/arch/arm/boot/dts/imx6q-ba16.dtsi b/arch/arm/boot/dts/imx6q-ba16.dtsi
> index adc9455e42c7..37c63402157b 100644
> --- a/arch/arm/boot/dts/imx6q-ba16.dtsi
> +++ b/arch/arm/boot/dts/imx6q-ba16.dtsi
> @@ -171,7 +171,7 @@
>  &fec {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_enet>;
> -	phy-mode = "rgmii";
> +	phy-mode = "rgmii-id";
>  	status = "okay";
>  };
>  
> diff --git a/arch/arm/boot/dts/imx6q-marsboard.dts b/arch/arm/boot/dts/imx6q-marsboard.dts
> index d8ccb533b6b7..84b30bd6908f 100644
> --- a/arch/arm/boot/dts/imx6q-marsboard.dts
> +++ b/arch/arm/boot/dts/imx6q-marsboard.dts
> @@ -110,7 +110,7 @@
>  &fec {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_enet>;
> -	phy-mode = "rgmii";
> +	phy-mode = "rgmii-id";
>  	phy-reset-gpios = <&gpio3 31 GPIO_ACTIVE_LOW>;
>  	status = "okay";
>  };
> diff --git a/arch/arm/boot/dts/imx6q-tbs2910.dts b/arch/arm/boot/dts/imx6q-tbs2910.dts
> index 2ce8399a10ba..bfff87ce2e1f 100644
> --- a/arch/arm/boot/dts/imx6q-tbs2910.dts
> +++ b/arch/arm/boot/dts/imx6q-tbs2910.dts
> @@ -98,7 +98,7 @@
>  &fec {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_enet>;
> -	phy-mode = "rgmii";
> +	phy-mode = "rgmii-id";
>  	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
>  	status = "okay";
>  };
> diff --git a/arch/arm/boot/dts/imx6qdl-apf6.dtsi b/arch/arm/boot/dts/imx6qdl-apf6.dtsi
> index 1ebf29f43a24..4738c3c1ab50 100644
> --- a/arch/arm/boot/dts/imx6qdl-apf6.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-apf6.dtsi
> @@ -51,7 +51,7 @@
>  &fec {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_enet>;
> -	phy-mode = "rgmii";
> +	phy-mode = "rgmii-id";
>  	phy-reset-duration = <10>;
>  	phy-reset-gpios = <&gpio1 24 GPIO_ACTIVE_LOW>;
>  	status = "okay";
> diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
> index 1280de50a984..f3404dd10537 100644
> --- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
> @@ -292,7 +292,7 @@
>  &fec {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_enet>;
> -	phy-mode = "rgmii";
> +	phy-mode = "rgmii-id";
>  	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
>  			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
>  	fsl,err006687-workaround-present;
> diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> index a0705066ccba..185fb17a3500 100644
> --- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> @@ -202,7 +202,7 @@
>  &fec {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_enet>;
> -	phy-mode = "rgmii";
> +	phy-mode = "rgmii-id";
>  	phy-reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
>  	status = "okay";
>  };
> diff --git a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
> index 4ccb7afc4b35..6d7f6b9035bc 100644
> --- a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
> @@ -53,7 +53,7 @@
>  &fec {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_microsom_enet_ar8035>;
> -	phy-mode = "rgmii";
> +	phy-mode = "rgmii-id";
>  	phy-reset-duration = <2>;
>  	phy-reset-gpios = <&gpio4 15 GPIO_ACTIVE_LOW>;
>  	status = "okay";
> diff --git a/arch/arm/boot/dts/imx6qdl-wandboard.dtsi b/arch/arm/boot/dts/imx6qdl-wandboard.dtsi
> index b7d5fb421404..50d9a989e06a 100644
> --- a/arch/arm/boot/dts/imx6qdl-wandboard.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-wandboard.dtsi
> @@ -224,7 +224,7 @@
>  &fec {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_enet>;
> -	phy-mode = "rgmii";
> +	phy-mode = "rgmii-id";
>  	phy-reset-gpios = <&gpio3 29 GPIO_ACTIVE_LOW>;
>  	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
>  			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
> diff --git a/arch/arm/boot/dts/imx6sx-sabreauto.dts b/arch/arm/boot/dts/imx6sx-sabreauto.dts
> index b0ee324afe58..315044ccd65f 100644
> --- a/arch/arm/boot/dts/imx6sx-sabreauto.dts
> +++ b/arch/arm/boot/dts/imx6sx-sabreauto.dts
> @@ -75,7 +75,7 @@
>  &fec1 {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_enet1>;
> -	phy-mode = "rgmii";
> +	phy-mode = "rgmii-id";
>  	phy-handle = <&ethphy1>;
>  	fsl,magic-packet;
>  	status = "okay";
> diff --git a/arch/arm/boot/dts/imx6sx-sdb.dtsi b/arch/arm/boot/dts/imx6sx-sdb.dtsi
> index 08ede56c3f10..f6972deb5e39 100644
> --- a/arch/arm/boot/dts/imx6sx-sdb.dtsi
> +++ b/arch/arm/boot/dts/imx6sx-sdb.dtsi
> @@ -191,7 +191,7 @@
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_enet1>;
>  	phy-supply = <&reg_enet_3v3>;
> -	phy-mode = "rgmii";
> +	phy-mode = "rgmii-id";
>  	phy-handle = <&ethphy1>;
>  	phy-reset-gpios = <&gpio2 7 GPIO_ACTIVE_LOW>;
>  	status = "okay";
> diff --git a/arch/arm/boot/dts/imx7d-pico.dtsi b/arch/arm/boot/dts/imx7d-pico.dtsi
> index 3fd595a71202..6f50ebf31a0a 100644
> --- a/arch/arm/boot/dts/imx7d-pico.dtsi
> +++ b/arch/arm/boot/dts/imx7d-pico.dtsi
> @@ -92,7 +92,7 @@
>  			  <&clks IMX7D_ENET1_TIME_ROOT_CLK>;
>  	assigned-clock-parents = <&clks IMX7D_PLL_ENET_MAIN_100M_CLK>;
>  	assigned-clock-rates = <0>, <100000000>;
> -	phy-mode = "rgmii";
> +	phy-mode = "rgmii-id";
>  	phy-handle = <&ethphy0>;
>  	fsl,magic-packet;
>  	phy-reset-gpios = <&gpio6 11 GPIO_ACTIVE_LOW>;

-- 
Regards,
George
