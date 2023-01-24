Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33950679655
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 12:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbjAXLNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 06:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233796AbjAXLNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 06:13:36 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F5FCC1A
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 03:13:34 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30OBD5h9029965;
        Tue, 24 Jan 2023 05:13:05 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1674558785;
        bh=EVHvEUsUbr7V09O6nsqlAU52oeFWF1tJ7m0+wq6YHIc=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=e7pq5l7goAGx2zt0lSUZkXfjUp6eZ9ZukRP7TAc0VzhyuM4wBydt7y7zT6gmILkSG
         6pVd9Nv8m6ssdm+IvGTfzc+I6qjxFqzAMYzdpezFZXIvoNravJClhmlBwBWCw9jvwT
         rv1D9Hk0AXWlXBuWVtJtGib8Kusj8yDUaCVxMX9w=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30OBD5N1001456
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Jan 2023 05:13:05 -0600
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 24
 Jan 2023 05:13:05 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 24 Jan 2023 05:13:05 -0600
Received: from [10.250.234.171] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30OBCxJu022065;
        Tue, 24 Jan 2023 05:12:59 -0600
Message-ID: <073bb72e-ed53-ef40-1860-c0957d88e0c6@ti.com>
Date:   Tue, 24 Jan 2023 16:42:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: Re: [PATCH 1/2] mtd: spi-nor: spansion: Consider reserved bits in
 CFR5 register
Content-Language: en-US
To:     Pratyush Yadav <ptyadav@amazon.de>
CC:     Tudor Ambarus <tudor.ambarus@linaro.org>,
        <Takahiro.Kuwano@infineon.com>, <tkuw584924@gmail.com>,
        <linux-mtd@lists.infradead.org>, <pratyush@kernel.org>,
        <michael@walle.cc>, <miquel.raynal@bootlin.com>, <richard@nod.at>,
        <Bacem.Daassi@infineon.com>, <stable@vger.kernel.org>
References: <493d9a10-aaf3-70f6-36c3-9a2cf39f0759@linaro.org>
 <20230110164703.83413-1-tudor.ambarus@linaro.org>
 <mafs0v8kxb9mb.fsf_-_@amazon.de>
 <e02d6aa5-2189-4afb-2521-6034feaa3460@ti.com>
 <mafs0tu0gfc1z.fsf_-_@amazon.de>
From:   Dhruva Gole <d-gole@ti.com>
In-Reply-To: <mafs0tu0gfc1z.fsf_-_@amazon.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 24/01/23 16:13, Pratyush Yadav wrote:
> On Mon, Jan 23 2023, Dhruva Gole wrote:
>
>> Hi Pratyush,
>>
>> On 23/01/23 20:07, Pratyush Yadav wrote:
>>> +Cc Dhruva
>> I had already reviewed this, but now I have locally applied the patches,
>> to linux master and built and tested - seems okay,
>>> Hi Tudor,
>>>
>>> On Tue, Jan 10 2023, Tudor Ambarus wrote:
>>>
>>>> CFR5[6] is reserved bit and must be always 1. Set it to comply with flash
>>>> requirements. While fixing SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_{EN, DS}
>>>> definition, stop using magic numbers and describe the missing bit fields
>>>> in CFR5 register. This is useful for both readability and future possible
>>>> addition of Octal STR mode support.
>>>>
>>>> Fixes: c3266af101f2 ("mtd: spi-nor: spansion: add support for Cypress Semper flash")
>>>> Cc: stable@vger.kernel.org
>>>> Reported-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
>>>> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
>>>> ---
>>>>  drivers/mtd/spi-nor/spansion.c | 9 +++++++--
>>>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
>>>> index b621cdfd506f..07fe0f6fdfe3 100644
>>>> --- a/drivers/mtd/spi-nor/spansion.c
>>>> +++ b/drivers/mtd/spi-nor/spansion.c
>>>> @@ -21,8 +21,13 @@
>>>>  #define SPINOR_REG_CYPRESS_CFR3V               0x00800004
>>>>  #define SPINOR_REG_CYPRESS_CFR3V_PGSZ          BIT(4) /* Page size. */
>>>>  #define SPINOR_REG_CYPRESS_CFR5V               0x00800006
>>>> -#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN    0x3
>>>> -#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS    0
>>>> +#define SPINOR_REG_CYPRESS_CFR5_BIT6           BIT(6)
>>> Perhaps comment here that this bit is reserved. Otherwise it is not
>>> obvious what this does and why we are setting it without going through
>>> git-blame. No need for a re-roll, I think it is fine if you add this
>>> when applying.
>>>
>>>> +#define SPINOR_REG_CYPRESS_CFR5_DDR            BIT(1)
>>>> +#define SPINOR_REG_CYPRESS_CFR5_OPI            BIT(0)
>>>> +#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN                            \
>>>> +       (SPINOR_REG_CYPRESS_CFR5_BIT6 | SPINOR_REG_CYPRESS_CFR5_DDR |   \
>>>> +        SPINOR_REG_CYPRESS_CFR5_OPI)
>>>> +#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS    SPINOR_REG_CYPRESS_CFR5_BIT6
>>> I would say don't fix what isn't broken. But if you do, test it. Do you
>>> or Takahiro have a Cypress S28* flash to test this change on? If no,
>>> then perhaps Dhruva can help here since TI uses this flash on a bunch of
>>> their boards?
>>>
>>> The change looks fine to me with the above comment added, I just would
>>> like someone to test it once.
>> Tested OSPI_S_FUNC_DD_RW_ERASESIZE_UBIFS from ltp-ddt and test seemed to pass on my
>> AM625 SK EVM having an OSPI NOR S28HS512T Flash.
> Thanks.
>
> BTW, one interesting bit about this in case you didn't know already.
> Since this is playing with Octal DTR enable/disable, you might also want
> to double-check you are actually using Octal DTR mode. This can be done
> by looking at the SPI NOR debugfs entry (usually in
> /sys/kernel/debug/spi-nor). You can "cat params" and see what protocols
> are being used, and make sure 8D-8D-8D is being used.
Yes, I believe 8D-8D-8D is being used.
Here's the output:
...
root@am62xx-evm:~# cat /sys/kernel/debug/spi-nor/spi0.0/params
name            s28hs512t
id              34 5b 1a 0f 03 90
size            64.0 MiB
write size      16
page size       256
address nbytes  4
flags           4B_OPCODES | HAS_4BAIT | HAS_16BIT_SR | IO_MODE_EN_VOLATILE | SOFT_RESET

opcodes
 read           0xee
  dummy cycles  24
 erase          0xd8
 program        0x12
 8D extension   repeat

protocols
 read           8D-8D-8D
 write          8D-8D-8D
 register       8D-8D-8D

erase commands
 21 (4.00 KiB) [2]
 dc (256 KiB) [3]
 c7 (64.0 MiB)

sector map
 region (in hex)   | erase mask | flags
 ------------------+------------+----------
 00000000-0001ffff |     [  2 ] |
 00020000-0003ffff |     [   3] | overlaid
 00040000-03ffffff |     [   3] |
...

Also, the raw read speed is about 40 MBPS
The frequency we set from DT is 25 MHz,
assuming 1MB is transfered every cycle's rising and falling edge,
ie. 25*2 = 50 MBPS is ideal speed.

>
> AM625 SK _should_ be using 8D-8D-8D mode already, but I think it is
> useful if you know how to confirm this assumption :-)
>
>>> Reviewed-by: Pratyush Yadav <ptyadav@amazon.de>
>> For this series,
>>
>> Tested-by: Dhruva Gole <d-gole@ti.com>
>>
>>>>  #define SPINOR_OP_CYPRESS_RD_FAST              0xee
>>>>
>>>>  /* Cypress SPI NOR flash operations. */

-- 
Best regards,
Dhruva Gole
Texas Instruments Incorporated

