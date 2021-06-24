Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DBB3B29C6
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 09:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhFXH4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 03:56:53 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:32101 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231630AbhFXH4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 03:56:53 -0400
Received: from [10.0.28.232] (unknown [10.0.28.232])
        by uho.ysoft.cz (Postfix) with ESMTP id BC3ADA569F;
        Thu, 24 Jun 2021 09:54:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1624521272;
        bh=NLbC23T/7+8xoV0rmoXID7prCSKbvpa0QbG1PLnUIew=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=TEC7utTQy3A7Yr8msK6gXy1ad1IgOVo/x4eSaE4l954cF7MCxyH68lLTofBWWCOs+
         e1rJa/UDIA2MB8wv1dFQcxuOJru11Y0gty+hTtT/UdQAv0OeA8Y+kfZpUHvB02lo6V
         qFit4l2SxdKK51tolQ0c7V/fiCOVoqTqVphjSTuY=
Subject: Re: [RFC 2/2] ARM: dts: imx6dl-yapp4: Fix lp5562 driver probe
To:     Pavel Machek <pavel@ucw.cz>, Rob Herring <robh+dt@kernel.org>
Cc:     Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        stable@vger.kernel.org
References: <1621003477-11250-1-git-send-email-michal.vokac@ysoft.com>
 <1621003477-11250-3-git-send-email-michal.vokac@ysoft.com>
 <20210623201347.GC8540@amd>
From:   =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>
Message-ID: <bca714c6-9bdd-ae20-9427-c2ea77a31f99@ysoft.com>
Date:   Thu, 24 Jun 2021 09:54:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210623201347.GC8540@amd>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23. 06. 21 22:13, Pavel Machek wrote:
> On Fri 2021-05-14 16:44:37, Michal Vokáč wrote:
>> Since the LED multicolor framework support was added in commit
>> 92a81562e695 ("leds: lp55xx: Add multicolor framework support to lp55xx")
>> LEDs on this platform stopped working.
>>
>> Author of the framework attempted to accommodate this DT to the
>> framework in commit b86d3d21cd4c ("ARM: dts: imx6dl-yapp4: Add reg property
>> to the lp5562 channel node") but that is not sufficient. A color property
>> is now required even if the multicolor framework is not used, otherwise
>> the driver probe fails:
>>
>>    lp5562: probe of 1-0030 failed with error -22
>>
>> Add the color property to fix this and remove the actually unused white
>> channel.
>>
>> Fixes: b86d3d21cd4c ("ARM: dts: imx6dl-yapp4: Add reg property to the lp5562 channel node")
> 
> I believe this is for arm maintainers to take...

Hi Pavel,

Thank you for your reply.
As described in the cover letter, my primary intention was to bring
attention to the problem. Addition of the multicolor framework broke
devicetree forward compatibility. The old devicetrees does not work
with newer kernels. Addition of the multicolor framework caused the
color property to become a required one even if the framework is
not enabled in kernel config nor used in the dts. So the reality and
the dt-bindings documentation do not match.

IMO this could be fixed in two ways. First is adapt the dt-binding
documentation to match the reality. State that the color property is
always required. With this we need to fix all the examples and dts
files by adding the color property. This is quite tricky because we
do not always know the color and it also becomes required for the
led-controller node. See the error reported by Rob's bot for patch 1/2:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/leds/leds-lp55xx.example.dt.yaml: led-controller@32: 'color' is a required property
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/leds/leds-lp55xx.yaml

Second option is to fix this in the LED driver. The driver should not
require the color property if the multicolor framework is not enabled.

I would really like to know Rob's opinion here.
  
>> diff --git a/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi b/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
>> index 7d2c72562c73..3107bf7fbce5 100644
>> --- a/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
>> +++ b/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi
>> @@ -5,6 +5,7 @@
>>   #include <dt-bindings/gpio/gpio.h>
>>   #include <dt-bindings/interrupt-controller/irq.h>
>>   #include <dt-bindings/input/input.h>
>> +#include <dt-bindings/leds/common.h>
>>   #include <dt-bindings/pwm/pwm.h>
>>   
>>   / {
>> @@ -271,6 +272,7 @@
>>   			led-cur = /bits/ 8 <0x20>;
>>   			max-cur = /bits/ 8 <0x60>;
>>   			reg = <0>;
>> +			color = <LED_COLOR_ID_RED>;
>>   		};
>>   
>>   		chan@1 {
>> @@ -278,6 +280,7 @@
>>   			led-cur = /bits/ 8 <0x20>;
>>   			max-cur = /bits/ 8 <0x60>;
>>   			reg = <1>;
>> +			color = <LED_COLOR_ID_GREEN>;
>>   		};
>>   
>>   		chan@2 {
>> @@ -285,13 +288,7 @@
>>   			led-cur = /bits/ 8 <0x20>;
>>   			max-cur = /bits/ 8 <0x60>;
>>   			reg = <2>;
>> -		};
>> -
>> -		chan@3 {
>> -			chan-name = "W";
>> -			led-cur = /bits/ 8 <0x0>;
>> -			max-cur = /bits/ 8 <0x0>;
>> -			reg = <3>;
>> +			color = <LED_COLOR_ID_BLUE>;
>>   		};
>>   	};
>>   
> 
> What is going on here? "White" channel seems to have disappeared?

Yes, it is described in the commit message. I know this is not optimal.
The white channel is actually not used on this platform. So the right
approach would be to add the white color property in this fix commit
and remove the whole chan@3 node in next commit. I can do it that way.

Michal
