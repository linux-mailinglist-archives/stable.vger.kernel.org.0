Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD50F345C58
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 11:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbhCWKzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 06:55:54 -0400
Received: from mail.thorsis.com ([92.198.35.195]:41037 "EHLO mail.thorsis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229452AbhCWKzj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Mar 2021 06:55:39 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Mar 2021 06:55:39 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.thorsis.com (Postfix) with ESMTP id DB1845E8;
        Tue, 23 Mar 2021 11:46:02 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at mail.thorsis.com
Received: from mail.thorsis.com ([127.0.0.1])
        by localhost (mail.thorsis.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id W5N2qbRT1jL0; Tue, 23 Mar 2021 11:46:02 +0100 (CET)
Received: by mail.thorsis.com (Postfix, from userid 109)
        id 2EDCF1FAB; Tue, 23 Mar 2021 11:46:02 +0100 (CET)
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.2
Date:   Tue, 23 Mar 2021 11:45:55 +0100 (CET)
From:   Alexander Dahl <ada@thorsis.com>
To:     nicolas.ferre@microchip.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Message-ID: <1732882030.11903.1616496356027@seven.thorsis.com>
In-Reply-To: <20210217113808.21804-1-nicolas.ferre@microchip.com>
References: <20210217113808.21804-1-nicolas.ferre@microchip.com>
Subject: Re: [PATCH] ARM: dts: at91-sama5d27_som1: fix phy address to 7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Originating-Client: open-xchange-appsuite
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hei hei,

I could not get ethernet to work on SAMA5D27-SOM1-EK1 with kernels v5.10 and v5.11 built by a recent ptxdist based DistroKit BSP, while it used to work with an older v4.19 kernel. Just applying this patch to the tree made ethernet working again, thus:

Tested-by: Alexander Dahl <ada@thorsis.com>

Not sure why it worked with that older kernel, though.

I added Ahmad to Cc, he added board support to DistroKit for that board, and might want to know. And I added the devicetree list to Cc, I wondered why the patch was not there and get_maintainers.pl proposed it.

Thanks for fixing this and greetings
Alex

> nicolas.ferre@microchip.com hat am 17.02.2021 12:38 geschrieben:
> 
>  
> From: Claudiu Beznea <claudiu.beznea@microchip.com>
> 
> Fix the phy address to 7 for Ethernet PHY on SAMA5D27 SOM1. No
> connection established if phy address 0 is used.
> 
> The board uses the 24 pins version of the KSZ8081RNA part, KSZ8081RNA
> pin 16 REFCLK as PHYAD bit [2] has weak internal pull-down.  But at
> reset, connected to PD09 of the MPU it's connected with an internal
> pull-up forming PHYAD[2:0] = 7.
> 
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> Fixes: 2f61929eb10a ("ARM: dts: at91: at91-sama5d27_som1: fix PHY ID")
> Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> Cc: <stable@vger.kernel.org> # 4.14+
> ---
>  arch/arm/boot/dts/at91-sama5d27_som1.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/at91-sama5d27_som1.dtsi b/arch/arm/boot/dts/at91-sama5d27_som1.dtsi
> index 1b1163858b1d..e3251f3e3eaa 100644
> --- a/arch/arm/boot/dts/at91-sama5d27_som1.dtsi
> +++ b/arch/arm/boot/dts/at91-sama5d27_som1.dtsi
> @@ -84,8 +84,8 @@ macb0: ethernet@f8008000 {
>  				pinctrl-0 = <&pinctrl_macb0_default>;
>  				phy-mode = "rmii";
>  
> -				ethernet-phy@0 {
> -					reg = <0x0>;
> +				ethernet-phy@7 {
> +					reg = <0x7>;
>  					interrupt-parent = <&pioA>;
>  					interrupts = <PIN_PD31 IRQ_TYPE_LEVEL_LOW>;
>  					pinctrl-names = "default";
> -- 
> 2.30.0
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
