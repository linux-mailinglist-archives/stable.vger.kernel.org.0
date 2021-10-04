Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5234213EF
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 18:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236818AbhJDQXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 12:23:34 -0400
Received: from srv4.3e8.eu ([193.25.101.238]:50710 "EHLO srv4.3e8.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236825AbhJDQXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 12:23:34 -0400
Received: from [IPV6:2003:c6:cf12:5a0:9abc:9583:6f0a:c734] (p200300c6cf1205a09abc95836f0ac734.dip0.t-ipconnect.de [IPv6:2003:c6:cf12:5a0:9abc:9583:6f0a:c734])
        (using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits))
        (No client certificate requested)
        by srv4.3e8.eu (Postfix) with ESMTPSA id 0F4D86002D;
        Mon,  4 Oct 2021 18:21:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=3e8.eu;
        s=mail20170724; t=1633364499;
        bh=7S7LOgvK7iNZhzXkgYBc06MPzFkxnPh65XnsimcMjl8=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=aXHcuvdEIRuf4TsPVWaNEMRS0kJc/j4KGyWK3z8MFgaSGSWHYwEMWeDuD5aBbGNuK
         rmIZNsh1lkQ8QzVK+6RnQqLg/Kw3eOlUZoIPoc9wgbiOizbORLTQfc+UUAkJzwn1WF
         YWACHrZ7yzCwnwWiHojgTEs8BjX4bkyxTg8pv3odmTQk5BNdDcUrZK+PnC1Jj/qy/Y
         BEvF/rq/WLkiyewC70nHzdNtYAvTeVNkjRodFKAI1EP5etwmUhp6/45F54dL8tt6ya
         yG3AmT1DhaOr/vw/QiqtCAJOPX0hzYeOl1Mli5J0Shab+s+AsQkDf9NT9dAdzdkVon
         wMNCUQ7/NBYeA==
Message-ID: <62e191eb-6e85-0c7f-7447-dc2106bb0a4d@3e8.eu>
Date:   Mon, 4 Oct 2021 18:21:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Kestrel seventyfour <kestrelseventyfour@gmail.com>
References: <20210928222258.199726-1-miquel.raynal@bootlin.com>
 <20210928222258.199726-10-miquel.raynal@bootlin.com>
 <20211004174048.608b07ef@xps13>
From:   Jan Hoffmann <jan@3e8.eu>
Subject: Re: [PATCH 9/9] mtd: rawnand: xway: Keep the driver compatible with
 on-die ECC engines
In-Reply-To: <20211004174048.608b07ef@xps13>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Miquèl,

> Hi Jan,
> 
> miquel.raynal@bootlin.com wrote on Wed, 29 Sep 2021 00:22:48 +0200:
> 
>> Following the introduction of the generic ECC engine infrastructure, it
>> was necessary to reorganize the code and move the ECC configuration in
>> the ->attach_chip() hook. Failing to do that properly lead to a first
>> series of fixes supposed to stabilize the situation. Unfortunately, this
>> only fixed the use of software ECC engines, preventing any other kind of
>> engine to be used, including on-die ones.
>>
>> It is now time to (finally) fix the situation by ensuring that we still
>> provide a default (eg. software ECC) but will still support different
>> ECC engines such as on-die ECC engines if properly described in the
>> device tree.
>>
>> There are no changes needed on the core side in order to do this, but we
>> just need to leverage the logic there which allows:
>> 1- a subsystem default (set to Host engines in the raw NAND world)
>> 2- a driver specific default (here set to software ECC engines)
>> 3- any type of engine requested by the user (ie. described in the DT)
>>
>> As the raw NAND subsystem has not yet been fully converted to the ECC
>> engine infrastructure, in order to provide a default ECC engine for this
>> driver we need to set chip->ecc.engine_type *before* calling
>> nand_scan(). During the initialization step, the core will consider this
>> entry as the default engine for this driver. This value may of course
>> be overloaded by the user if the usual DT properties are provided.
>>
>> Fixes: d525914b5bd8 ("mtd: rawnand: xway: Move the ECC initialization to ->attach_chip()")
>> Cc: stable@vger.kernel.org
>> Cc: Jan Hoffmann <jan@3e8.eu>
> 
> I think you already tested this change and validated it, would you mind
> providing your Tested-by?

Yes, I tested this on a device using software ECC (Fritzbox 7412 with
Toshiba NAND chip) and on a device using on-die ECC (Fritzbox 7362 SL
with Micron NAND chip).

Tested-by: Jan Hoffmann <jan@3e8.eu>

>> Cc: Kestrel seventyfour <kestrelseventyfour@gmail.com>
>> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
>> ---
>>   drivers/mtd/nand/raw/xway_nand.c | 12 +++++++++---
>>   1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/raw/xway_nand.c b/drivers/mtd/nand/raw/xway_nand.c
>> index 26751976e502..236fd8c5a958 100644
>> --- a/drivers/mtd/nand/raw/xway_nand.c
>> +++ b/drivers/mtd/nand/raw/xway_nand.c
>> @@ -148,9 +148,8 @@ static void xway_write_buf(struct nand_chip *chip, const u_char *buf, int len)
>>   
>>   static int xway_attach_chip(struct nand_chip *chip)
>>   {
>> -	chip->ecc.engine_type = NAND_ECC_ENGINE_TYPE_SOFT;
>> -
>> -	if (chip->ecc.algo == NAND_ECC_ALGO_UNKNOWN)
>> +	if (chip->ecc.engine_type == NAND_ECC_ENGINE_TYPE_SOFT &&
>> +	    chip->ecc.algo == NAND_ECC_ALGO_UNKNOWN)
>>   		chip->ecc.algo = NAND_ECC_ALGO_HAMMING;
>>   
>>   	return 0;
>> @@ -219,6 +218,13 @@ static int xway_nand_probe(struct platform_device *pdev)
>>   		    | NAND_CON_SE_P | NAND_CON_WP_P | NAND_CON_PRE_P
>>   		    | cs_flag, EBU_NAND_CON);
>>   
>> +	/*
>> +	 * This driver assumes that the default ECC engine should be TYPE_SOFT.
>> +	 * Set ->engine_type before registering the NAND devices in order to
>> +	 * provide a driver specific default value.
>> +	 */
>> +	data->chip.ecc.engine_type = NAND_ECC_ENGINE_TYPE_SOFT;
>> +
>>   	/* Scan to find existence of the device */
>>   	err = nand_scan(&data->chip, 1);
>>   	if (err)
> 
> 
> Thanks,
> Miquèl
> 

Thanks,
Jan
