Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9D6E3991
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 19:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439957AbfJXRNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 13:13:23 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9280 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439946AbfJXRNX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 13:13:23 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5db1dbba0002>; Thu, 24 Oct 2019 10:13:30 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 24 Oct 2019 10:13:21 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 24 Oct 2019 10:13:21 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 24 Oct
 2019 17:13:20 +0000
Received: from [10.21.133.51] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 24 Oct
 2019 17:13:18 +0000
Subject: Re: [PATCH] spi: Fix SPI_CS_HIGH setting when using native and GPIO
 CS
To:     Gregory CLEMENT <gregory.clement@bootlin.com>,
        Mark Brown <broonie@kernel.org>, <linux-spi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191018152929.3287-1-gregory.clement@bootlin.com>
 <dfabf9eb-4f81-91e5-55dc-caea0cdabd2d@nvidia.com> <87zhhqp4wf.fsf@FE-laptop>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <4be58f82-eeb1-83a5-4c83-1e86f3b82769@nvidia.com>
Date:   Thu, 24 Oct 2019 18:13:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <87zhhqp4wf.fsf@FE-laptop>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1571937210; bh=IGHxywHeWHbvWN/dGZiODRU1Pgz0qNdz6PS2iL/zybc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=MM/18hyCWxGXMxY6YT9ReV/7/ZgXYKVgBZMHvbH4pc2hpiV43cLaFtS00fWFPWRDL
         erOSBvWRwITrxAmnu2xrjxMScAx1CyoARtjFmjxmuecIcturc7XchVXhRhRHkK1EhZ
         RUa/+fsDshDTE0sfaPU98V/ztsOr5bWkKCNLPzlDx2xEQGuwFGCB4vYCaWyOgFVAze
         b2qg3RWIFVcZwaqmRVm02T8T6xHLsg6CP2Bvz7tZfhgr3LQRfn9Mq1vr652b1mczLM
         t3YFFCZdh8Yaz054QJzum2+fA47872r3mtNIn1caKFtR/05p0aoV4hRfHuuav11qYR
         4tTyid1yiKBpQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 24/10/2019 15:57, Gregory CLEMENT wrote:
> Hello Jon,
> 
>> On 18/10/2019 16:29, Gregory CLEMENT wrote:
>>> When improving the CS GPIO support at core level, the SPI_CS_HIGH
>>> has been enabled for all the CS lines used for a given SPI controller.
>>>
>>> However, the SPI framework allows to have on the same controller native
>>> CS and GPIO CS. The native CS may not support the SPI_CS_HIGH, so they
>>> should not be setup automatically.
>>>
>>> With this patch the setting is done only for the CS that will use a
>>> GPIO as CS
>>>
>>> Fixes: f3186dd87669 ("spi: Optionally use GPIO descriptors for CS GPIOs")
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
>>> ---
>>>  drivers/spi/spi.c | 18 +++++++++---------
>>>  1 file changed, 9 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
>>> index 5414a10afd65..1b68acc28c8f 100644
>>> --- a/drivers/spi/spi.c
>>> +++ b/drivers/spi/spi.c
>>> @@ -1880,15 +1880,7 @@ static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
>>>  		spi->mode |= SPI_3WIRE;
>>>  	if (of_property_read_bool(nc, "spi-lsb-first"))
>>>  		spi->mode |= SPI_LSB_FIRST;
>>> -
>>> -	/*
>>> -	 * For descriptors associated with the device, polarity inversion is
>>> -	 * handled in the gpiolib, so all chip selects are "active high" in
>>> -	 * the logical sense, the gpiolib will invert the line if need be.
>>> -	 */
>>> -	if (ctlr->use_gpio_descriptors)
>>> -		spi->mode |= SPI_CS_HIGH;
>>> -	else if (of_property_read_bool(nc, "spi-cs-high"))
>>> +	if (of_property_read_bool(nc, "spi-cs-high"))
>>>  		spi->mode |= SPI_CS_HIGH;
>>>  
>>>  	/* Device DUAL/QUAD mode */
>>> @@ -1952,6 +1944,14 @@ static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
>>>  	}
>>>  	spi->chip_select = value;
>>>  
>>> +	/*
>>> +	 * For descriptors associated with the device, polarity inversion is
>>> +	 * handled in the gpiolib, so all gpio chip selects are "active high"
>>> +	 * in the logical sense, the gpiolib will invert the line if need be.
>>> +	 */
>>> +	if ((ctlr->use_gpio_descriptors) && ctlr->cs_gpiods[spi->chip_select])
>>> +		spi->mode |= SPI_CS_HIGH;
>>> +
>>
>> This patch is causing a boot regression on one of our Tegra boards. 
>> Bisect is pointing to this commit and reverting on top of today's -next
>> fixes the problem. 
>>
>> This patch is causing the following NULL pointer crash which I assume is
>> because we have not checked if 'ctlr->cs_gpiods' is valid before
>> dereferencing ...
> 
> I've just submitted a fixe for it
> 
> https://patchwork.kernel.org/patch/11209839/

Great! Thanks, Jon

-- 
nvpublic
