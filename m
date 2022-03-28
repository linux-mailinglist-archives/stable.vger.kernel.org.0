Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C224E92C2
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 12:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbiC1KvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 06:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbiC1KvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 06:51:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88973DDDB
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 03:49:32 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1nYmwD-0006pS-Ct; Mon, 28 Mar 2022 12:49:29 +0200
Message-ID: <0101a00f-a5a1-a4f7-7c6d-cd468805f284@pengutronix.de>
Date:   Mon, 28 Mar 2022 12:49:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v4 2/3] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Content-Language: en-US
To:     Tokunori Ikegami <ikegami.t@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     linux-mtd@lists.infradead.org, stable@vger.kernel.org
References: <20220316155455.162362-1-ikegami.t@gmail.com>
 <20220316155455.162362-3-ikegami.t@gmail.com> <20220316182100.6e2e5876@xps13>
 <01fed0aa-8844-1db9-f167-e7e7944bc092@ti.com>
 <201907b1-c43a-8c45-7ab1-4a4606591bef@pengutronix.de>
 <e4142a59-6193-8dd9-0562-fd3310067b09@gmail.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <e4142a59-6193-8dd9-0562-fd3310067b09@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22.03.22 03:49, Tokunori Ikegami wrote:
> Hi Ahmad-san,
> 
> On 2022/03/17 23:16, Ahmad Fatoum wrote:
>> Hello Vignesh,
>>
>> On 17.03.22 11:01, Vignesh Raghavendra wrote:
>>>
>>> On 16/03/22 10:51 pm, Miquel Raynal wrote:
>>>> Hi Tokunori,
>>>>
>>>> ikegami.t@gmail.com wrote on Thu, 17 Mar 2022 00:54:54 +0900:
>>>>
>>>>> As pointed out by this bug report [1], buffered writes are now broken on
>>>>> S29GL064N. This issue comes from a rework which switched from using chip_good()
>>>>> to chip_ready(), because DQ true data 0xFF is read on S29GL064N and an error
>>>>> returned by chip_good().
>>>> Vignesh, I believe you understand this issue better than I do, can you
>>>> propose an improved commit log?
>>> How about:
>>>
>>> Since commit dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to
>>> check correct value") buffered writes fail on S29GL064N. This is
>>> because, on S29GL064N, reads return 0xFF at the end of DQ polling for
>>> write completion, where as, chip_good() check expects actual data
>>> written to the last location to be returned post DQ polling completion.
>>> Fix is to revert to using chip_good() for S29GL064N which only checks
>>> for DQ lines to settle down to determine write completion.
>> Message sounds good to me with one remark: The issue is independent of
>> whether buffered writes are used or not. It's just because buffered writes
>> are the default, that it was broken by dfeae1073583 ("mtd: cfi_cmdset_0002:
>> Change write buffer to check correct value"). The word write case was broken
>> by 37c673ade35c ("mtd: cfi_cmdset_0002: Use chip_good() to retry in
>> do_write_oneword()"), so the commit message should probably reference
>> both. as this commit indeed fixes both FORCE_WORD_WRITE == 0 and == 1.
> 
> Is this really caused the error on do_write_oneword by the changed?
> Actually it was changed to use chip_good instead of chip_ready.
> But before the change still do_write_oneword uses both chip_ready and chip_good.
> So it seems that it is possible to be caused the error before the change also.

Oh, I think you're right. Disregard my suggestion for the other
Fixes: entry then.

> By the way could you please try to test the version 5 patches again?

Just did so for v7. Sorry for the delay.

Cheers,
Ahmad

> 
> Regards,
> Ikegami
> 
>>
>> Thanks,
>> Ahmad
>>
>>
>>>>> One way to solve the issue is to revert the change
>>>>> partially to use chip_ready for S29GL064N.
>>>>>
>>>>> [1] https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
>>>>>
>>>>> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
>>>>> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
>>>>> Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
>>>>> Cc: stable@vger.kernel.org
>>>>> ---
>>>>>   drivers/mtd/chips/cfi_cmdset_0002.c | 25 +++++++++++++++++++++----
>>>>>   1 file changed, 21 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
>>>>> index e68ddf0f7fc0..6c57f85e1b8e 100644
>>>>> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
>>>>> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
>>>>> @@ -866,6 +866,23 @@ static int __xipram chip_check(struct map_info *map, struct flchip *chip,
>>>>>           chip_check(map, chip, addr, &datum); \
>>>>>       })
>>>>>   +static bool __xipram cfi_use_chip_ready_for_write(struct map_info *map)
>>>> At the very least I would call this function:
>>>> cfi_use_chip_ready_for_writes()
>>>>
>>>> Yet, I still don't fully get what chip_ready is versus chip_good.
>>>>
>>>>> +{
>>>>> +    struct cfi_private *cfi = map->fldrv_priv;
>>>>> +
>>>>> +    return cfi->mfr == CFI_MFR_AMD && cfi->id == 0x0c01;
>>>>> +}
>>>>> +
>>>>> +static int __xipram chip_good_for_write(struct map_info *map,
>>>>> +                    struct flchip *chip, unsigned long addr,
>>>>> +                    map_word expected)
>>>>> +{
>>>>> +    if (cfi_use_chip_ready_for_write(map))
>>>>> +        return chip_ready(map, chip, addr);
>>>> If possible and not too invasive I would definitely add a "quirks" flag
>>>> somewhere instead of this cfi_use_chip_ready_for_write() check.
>>>>
>>>> Anyway, I would move this to the chip_good() implementation directly so
>>>> we partially hide the quirks complexity from the core.
>>> Yeah, unfortunately this driver does not use quirk flags and tends to
>>> hide quirks behind bool functions like above
>>>
>>> Regards
>>> Vignesh
>>>
>>
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
