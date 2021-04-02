Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6576A35305D
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 22:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhDBUlu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 2 Apr 2021 16:41:50 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:37289 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbhDBUls (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Apr 2021 16:41:48 -0400
X-Greylist: delayed 1454 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Apr 2021 16:41:48 EDT
Received: from relay6-d.mail.gandi.net (unknown [217.70.183.198])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 28287C067E
        for <stable@vger.kernel.org>; Fri,  2 Apr 2021 20:16:23 +0000 (UTC)
X-Originating-IP: 91.175.115.186
Received: from localhost (91-175-115-186.subs.proxad.net [91.175.115.186])
        (Authenticated sender: gregory.clement@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 23715C0002;
        Fri,  2 Apr 2021 20:15:57 +0000 (UTC)
From:   Gregory CLEMENT <gregory.clement@bootlin.com>
To:     Marek =?utf-8?Q?Beh=C3=BAn?= <kabel@kernel.org>
Cc:     Marek =?utf-8?Q?Beh=C3=BAn?= <kabel@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        stable@vger.kernel.org
Subject: Re: [PATCH mvebu-dt] ARM: dts: turris-omnia: configure LED[2]/INTn
 pin as interrupt pin
In-Reply-To: <20210220231144.32325-1-kabel@kernel.org>
References: <20210220231144.32325-1-kabel@kernel.org>
Date:   Fri, 02 Apr 2021 22:15:57 +0200
Message-ID: <87eefscuiq.fsf@BL-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marek,

> Use the `marvell,reg-init` DT property to configure the LED[2]/INTn pin
> of the Marvell 88E1514 ethernet PHY on Turris Omnia into interrupt mode.
>
> Without this the pin is by default in LED[2] mode, and the Marvell PHY
> driver configures LED[2] into "On - Link, Blink - Activity" mode.
>
> This fixes the issue where the pca9538 GPIO/interrupt controller (which
> can't mask interrupts in HW) received too many interrupts and after a
> time started ignoring the interrupt with error message:
>   IRQ 71: nobody cared
>
> There is a work in progress to have the Marvell PHY driver support
> parsing PHY LED nodes from OF and registering the LEDs as Linux LED
> class devices. Once this is done the PHY driver can also automatically
> set the pin into INTn mode if it does not find LED[2] in OF.
>
> Until then, though, we fix this via `marvell,reg-init` DT property.
>
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Reported-by: Rui Salvaterra <rsalvaterra@gmail.com>
> Fixes: 26ca8b52d6e1 ("ARM: dts: add support for Turris Omnia")
> Cc: Uwe Kleine-König <uwe@kleine-koenig.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory CLEMENT <gregory.clement@bootlin.com>
> Cc: <stable@vger.kernel.org>


Applied on mvebu/fixes

Thanks,

Gregory

>
> ---
>
> This patch fixes bug introduced with the commit that added Turris
> Omnia's DTS (26ca8b52d6e1), but will not apply cleanly because there is
> commit 8ee4a5f4f40d which changed node name and node compatible
> property and this commit did not go into stable.
>
> So either commit 8ee4a5f4f40d has also to go into stable before this, or
> this patch has to be fixed a little in order to apply to 4.14+.
>
> Please let me know how should I handle this.
>
> ---
>  arch/arm/boot/dts/armada-385-turris-omnia.dts | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/boot/dts/armada-385-turris-omnia.dts b/arch/arm/boot/dts/armada-385-turris-omnia.dts
> index 646a06420c77..b0f3fd8e1429 100644
> --- a/arch/arm/boot/dts/armada-385-turris-omnia.dts
> +++ b/arch/arm/boot/dts/armada-385-turris-omnia.dts
> @@ -389,6 +389,7 @@ &mdio {
>  	phy1: ethernet-phy@1 {
>  		compatible = "ethernet-phy-ieee802.3-c22";
>  		reg = <1>;
> +		marvell,reg-init = <3 18 0 0x4985>;
>  
>  		/* irq is connected to &pcawan pin 7 */
>  	};
> -- 
> 2.26.2
>

-- 
Gregory Clement, Bootlin
Embedded Linux and Kernel engineering
http://bootlin.com
