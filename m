Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7283E4DC37E
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 11:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbiCQKCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 06:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbiCQKCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 06:02:37 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F4FD4479
        for <stable@vger.kernel.org>; Thu, 17 Mar 2022 03:01:20 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 22HA17D3012110;
        Thu, 17 Mar 2022 05:01:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1647511267;
        bh=Pyx1gIv+JI704o72I6w4zCNmHpZz4LEk6x5A6OzlhWM=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=VLKNuD7GEoW9Gb2m+X1QilMDotoZJw3ASoh/IkGf5o8igy9tx5SsIEwFNzv9AQDH1
         MVAXV4gQ7gaqfQFBhCx8PptO8HPlxhoU8AD4EdNE8lLd7MWkAzdXMX73oEETCXTlts
         7K6RnNFr6Zx2hOcJmuVr3Lu5ajzmxd3K9xk90sc4=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 22HA17XD026689
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Mar 2022 05:01:07 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 17
 Mar 2022 05:01:06 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Thu, 17 Mar 2022 05:01:06 -0500
Received: from [10.250.234.22] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 22HA14Jg034230;
        Thu, 17 Mar 2022 05:01:05 -0500
Message-ID: <01fed0aa-8844-1db9-f167-e7e7944bc092@ti.com>
Date:   Thu, 17 Mar 2022 15:31:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4 2/3] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Tokunori Ikegami <ikegami.t@gmail.com>
CC:     <linux-mtd@lists.infradead.org>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        <stable@vger.kernel.org>
References: <20220316155455.162362-1-ikegami.t@gmail.com>
 <20220316155455.162362-3-ikegami.t@gmail.com> <20220316182100.6e2e5876@xps13>
From:   Vignesh Raghavendra <vigneshr@ti.com>
In-Reply-To: <20220316182100.6e2e5876@xps13>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 16/03/22 10:51 pm, Miquel Raynal wrote:
> Hi Tokunori,
> 
> ikegami.t@gmail.com wrote on Thu, 17 Mar 2022 00:54:54 +0900:
> 
>> As pointed out by this bug report [1], buffered writes are now broken on
>> S29GL064N. This issue comes from a rework which switched from using chip_good()
>> to chip_ready(), because DQ true data 0xFF is read on S29GL064N and an error
>> returned by chip_good().
> 
> Vignesh, I believe you understand this issue better than I do, can you
> propose an improved commit log?

How about:

Since commit dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to
check correct value") buffered writes fail on S29GL064N. This is
because, on S29GL064N, reads return 0xFF at the end of DQ polling for
write completion, where as, chip_good() check expects actual data
written to the last location to be returned post DQ polling completion.
Fix is to revert to using chip_good() for S29GL064N which only checks
for DQ lines to settle down to determine write completion.

> 
>> One way to solve the issue is to revert the change
>> partially to use chip_ready for S29GL064N.
>>
>> [1] https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
>>
>> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
>> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
>> Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
>> Cc: stable@vger.kernel.org
>> ---
>>  drivers/mtd/chips/cfi_cmdset_0002.c | 25 +++++++++++++++++++++----
>>  1 file changed, 21 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
>> index e68ddf0f7fc0..6c57f85e1b8e 100644
>> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
>> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
>> @@ -866,6 +866,23 @@ static int __xipram chip_check(struct map_info *map, struct flchip *chip,
>>  		chip_check(map, chip, addr, &datum); \
>>  	})
>>  
>> +static bool __xipram cfi_use_chip_ready_for_write(struct map_info *map)
> 
> At the very least I would call this function:
> cfi_use_chip_ready_for_writes()
> 
> Yet, I still don't fully get what chip_ready is versus chip_good.
> 
>> +{
>> +	struct cfi_private *cfi = map->fldrv_priv;
>> +
>> +	return cfi->mfr == CFI_MFR_AMD && cfi->id == 0x0c01;
>> +}
>> +
>> +static int __xipram chip_good_for_write(struct map_info *map,
>> +					struct flchip *chip, unsigned long addr,
>> +					map_word expected)
>> +{
>> +	if (cfi_use_chip_ready_for_write(map))
>> +		return chip_ready(map, chip, addr);
> 
> If possible and not too invasive I would definitely add a "quirks" flag
> somewhere instead of this cfi_use_chip_ready_for_write() check.
> 
> Anyway, I would move this to the chip_good() implementation directly so
> we partially hide the quirks complexity from the core.

Yeah, unfortunately this driver does not use quirk flags and tends to
hide quirks behind bool functions like above

Regards
Vignesh
