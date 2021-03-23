Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813C0345C5B
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 11:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhCWK42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 06:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhCWK4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 06:56:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED747C061756
        for <stable@vger.kernel.org>; Tue, 23 Mar 2021 03:56:00 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1lOehb-0003uq-5I; Tue, 23 Mar 2021 11:55:59 +0100
Subject: Re: [PATCH] ARM: dts: at91-sama5d27_som1: fix phy address to 7
To:     Alexander Dahl <ada@thorsis.com>, nicolas.ferre@microchip.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        stable@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Oleksij Rempel <ore@pengutronix.de>
References: <20210217113808.21804-1-nicolas.ferre@microchip.com>
 <1732882030.11903.1616496356027@seven.thorsis.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <ddedd53b-6087-f7a5-3c41-2b91fec35980@pengutronix.de>
Date:   Tue, 23 Mar 2021 11:55:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1732882030.11903.1616496356027@seven.thorsis.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Alexander,

On 23.03.21 11:45, Alexander Dahl wrote:
> Hei hei,
> 
> I could not get ethernet to work on SAMA5D27-SOM1-EK1 with kernels v5.10 and v5.11 built by a recent ptxdist based DistroKit BSP, while it used to work with an older v4.19 kernel. Just applying this patch to the tree made ethernet working again, thus:
> 
> Tested-by: Alexander Dahl <ada@thorsis.com>
> 
> Not sure why it worked with that older kernel, though.

Thanks for investigating! Seems that somehow PHY broadcast worked on this
board with older kernels (and current barebox), but no longer does with
newer kernels.

A bisection could shed some light onto what broke this.

As the KSZ8081 driver disables broadcast in the phy config init, this change
looks appropriate regardless. The fixes tag doesn't refer to an upstream
commit though. This should probably read:
Fixes: af690fa37e39 ("ARM: dts: at91: at91-sama5d27_som1: add sama5d27 SoM1 support")

With this addressed:

Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

You could send a proper patch and stick your S-o-b under it.

Cheers,
Ahmad

> 
> I added Ahmad to Cc, he added board support to DistroKit for that board, and might want to know. And I added the devicetree list to Cc, I wondered why the patch was not there and get_maintainers.pl proposed it.
> 
> Thanks for fixing this and greetings
> Alex
> 
>> nicolas.ferre@microchip.com hat am 17.02.2021 12:38 geschrieben:
>>
>>  
>> From: Claudiu Beznea <claudiu.beznea@microchip.com>
>>
>> Fix the phy address to 7 for Ethernet PHY on SAMA5D27 SOM1. No
>> connection established if phy address 0 is used.
>>
>> The board uses the 24 pins version of the KSZ8081RNA part, KSZ8081RNA
>> pin 16 REFCLK as PHYAD bit [2] has weak internal pull-down.  But at
>> reset, connected to PD09 of the MPU it's connected with an internal
>> pull-up forming PHYAD[2:0] = 7.
>>
>> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
>> Fixes: 2f61929eb10a ("ARM: dts: at91: at91-sama5d27_som1: fix PHY ID")
>> Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
>> Cc: <stable@vger.kernel.org> # 4.14+
>> ---
>>  arch/arm/boot/dts/at91-sama5d27_som1.dtsi | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/at91-sama5d27_som1.dtsi b/arch/arm/boot/dts/at91-sama5d27_som1.dtsi
>> index 1b1163858b1d..e3251f3e3eaa 100644
>> --- a/arch/arm/boot/dts/at91-sama5d27_som1.dtsi
>> +++ b/arch/arm/boot/dts/at91-sama5d27_som1.dtsi
>> @@ -84,8 +84,8 @@ macb0: ethernet@f8008000 {
>>  				pinctrl-0 = <&pinctrl_macb0_default>;
>>  				phy-mode = "rmii";
>>  
>> -				ethernet-phy@0 {
>> -					reg = <0x0>;
>> +				ethernet-phy@7 {
>> +					reg = <0x7>;
>>  					interrupt-parent = <&pioA>;
>>  					interrupts = <PIN_PD31 IRQ_TYPE_LEVEL_LOW>;
>>  					pinctrl-names = "default";
>> -- 
>> 2.30.0
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
