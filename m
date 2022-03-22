Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB9F4E36C9
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 03:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235544AbiCVCoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 22:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235473AbiCVCoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 22:44:15 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F57549680
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 19:42:49 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id e5so2539659pls.4
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 19:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rEY/h+4Sphr0hAcylYNk2Yi0tkyfCG6fY8IoqjvLISs=;
        b=pMq1IK2/MsNaini+cWJAPY8v6lDfRGOCPp9vZ4pYUlMd4ORcdU2ETbsu3Wc4b2mn6P
         KDuFqPCqsEeHi/5lTzJh9HARLqlGPGCP9uV96une4gIf+/TILqUPI4YpoKGS1/GM76Ih
         dAMheLYvGTEJLsE+S0R0Q3gcOMWELyry349XMGnYm9zpvLY8T+dpB1JloHW3YXSQvSD9
         GblRvhsRI1DiHf4+5wx8OjxbPkh5r44In8LhSb/fMV9ah0t1kcvqVs346bAeWFX28vfn
         BAxk57QM+wLNFErgB2R18gkfzW7q1yoOqtzgQPujgkPPhPQFj18LOORqV6RqExo9JjOt
         5Izw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rEY/h+4Sphr0hAcylYNk2Yi0tkyfCG6fY8IoqjvLISs=;
        b=nwqQuh/pTzaDJx7OyFkSlPlcb4Gh+056JcC6MOUPfPStKd58ueob/nqPBi5x4XSYKf
         XokmpgvVtg2Eo+nMYSddFFnzja6CLWJAgkqDhUqt9qHcwwVOHRWtS/e2+o7KyfNnGPFu
         Y0zVidMkbeWg+y4ha2Q0Hly5SNsGUNqrXAlae1Uo+gK4ALqsn0pZzyJbxtM/vWMH60D2
         oM1qshzFTRZgEeZ4qwyfJZIxhdRvrNFpHeOoC1ejIkj6D5HKEl5fCzGY8KrOYKRAmaif
         kofexARpEOKZGoGS8q25QthgDVv96INqrNNIPNCpRnFLxcy3VzvmgcSvr/AVq0zsGEZ1
         AAbQ==
X-Gm-Message-State: AOAM533TWtXOQor6ct4NRHG0DGZ/JexdHAPaSi6ZNVoMl+E1b/HoSC2a
        uV0JeTTMjf7XO23YL96toC0=
X-Google-Smtp-Source: ABdhPJydaDcy3GFhYZJU5jDclfHGMnQOlokHTjIv8xDMjZUzOLN5KBHfD5tarxsdTdmZ1lU4X296XQ==
X-Received: by 2002:a17:902:ce90:b0:154:3029:97e6 with SMTP id f16-20020a170902ce9000b00154302997e6mr13983574plg.111.1647916968584;
        Mon, 21 Mar 2022 19:42:48 -0700 (PDT)
Received: from [192.168.122.100] (133-175-21-116.tokyo.ap.gmo-isp.jp. [133.175.21.116])
        by smtp.gmail.com with ESMTPSA id i7-20020a628707000000b004fa6eb33b02sm13144543pfe.49.2022.03.21.19.42.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 19:42:48 -0700 (PDT)
Message-ID: <8a193154-e840-6c15-13bf-42267ab72807@gmail.com>
Date:   Tue, 22 Mar 2022 11:42:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4 2/3] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Content-Language: en-US
To:     Vignesh Raghavendra <vigneshr@ti.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     linux-mtd@lists.infradead.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, stable@vger.kernel.org
References: <20220316155455.162362-1-ikegami.t@gmail.com>
 <20220316155455.162362-3-ikegami.t@gmail.com> <20220316182100.6e2e5876@xps13>
 <01fed0aa-8844-1db9-f167-e7e7944bc092@ti.com>
From:   Tokunori Ikegami <ikegami.t@gmail.com>
In-Reply-To: <01fed0aa-8844-1db9-f167-e7e7944bc092@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2022/03/17 19:01, Vignesh Raghavendra wrote:
>
> On 16/03/22 10:51 pm, Miquel Raynal wrote:
>> Hi Tokunori,
>>
>> ikegami.t@gmail.com wrote on Thu, 17 Mar 2022 00:54:54 +0900:
>>
>>> As pointed out by this bug report [1], buffered writes are now broken on
>>> S29GL064N. This issue comes from a rework which switched from using chip_good()
>>> to chip_ready(), because DQ true data 0xFF is read on S29GL064N and an error
>>> returned by chip_good().
>> Vignesh, I believe you understand this issue better than I do, can you
>> propose an improved commit log?
> How about:
>
> Since commit dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to
> check correct value") buffered writes fail on S29GL064N. This is
> because, on S29GL064N, reads return 0xFF at the end of DQ polling for
> write completion, where as, chip_good() check expects actual data
> written to the last location to be returned post DQ polling completion.
> Fix is to revert to using chip_good() for S29GL064N which only checks
> for DQ lines to settle down to determine write completion.

Fixed the commit message as suggested by the version 5 patch.

>>> One way to solve the issue is to revert the change
>>> partially to use chip_ready for S29GL064N.
>>>
>>> [1] https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
>>>
>>> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
>>> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
>>> Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
>>> Cc: stable@vger.kernel.org
>>> ---
>>>   drivers/mtd/chips/cfi_cmdset_0002.c | 25 +++++++++++++++++++++----
>>>   1 file changed, 21 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
>>> index e68ddf0f7fc0..6c57f85e1b8e 100644
>>> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
>>> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
>>> @@ -866,6 +866,23 @@ static int __xipram chip_check(struct map_info *map, struct flchip *chip,
>>>   		chip_check(map, chip, addr, &datum); \
>>>   	})
>>>   
>>> +static bool __xipram cfi_use_chip_ready_for_write(struct map_info *map)
>> At the very least I would call this function:
>> cfi_use_chip_ready_for_writes()
>>
>> Yet, I still don't fully get what chip_ready is versus chip_good.
>>
>>> +{
>>> +	struct cfi_private *cfi = map->fldrv_priv;
>>> +
>>> +	return cfi->mfr == CFI_MFR_AMD && cfi->id == 0x0c01;
>>> +}
>>> +
>>> +static int __xipram chip_good_for_write(struct map_info *map,
>>> +					struct flchip *chip, unsigned long addr,
>>> +					map_word expected)
>>> +{
>>> +	if (cfi_use_chip_ready_for_write(map))
>>> +		return chip_ready(map, chip, addr);
>> If possible and not too invasive I would definitely add a "quirks" flag
>> somewhere instead of this cfi_use_chip_ready_for_write() check.
>>
>> Anyway, I would move this to the chip_good() implementation directly so
>> we partially hide the quirks complexity from the core.
> Yeah, unfortunately this driver does not use quirk flags and tends to
> hide quirks behind bool functions like above

Added the quirks flag as mentioned.

Regards,
Ikegami

>
> Regards
> Vignesh
