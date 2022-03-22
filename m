Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF864E36ED
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 03:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbiCVCul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 22:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235577AbiCVCuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 22:50:40 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27AE027B10
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 19:49:14 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q5so5094218plg.3
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 19:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=54lx3anSvHU8zNxE3mHWLM2bGAsQ9YpvqZlOWx8YeIA=;
        b=LtwobuA36KRtNKc+oTz1V7RjskiU7j+cG86e/9jG37okEGu11UOaVgMzuHeRO6OpTl
         2RA7IZRdKnDufPI5M0hCrrk4rkU8Q9EyuBTKhJs79TIkRNUzNfXExkV7VYLuZRKAnHQH
         MstdFQbA4rxouCpLlO7XrlOJFTyHRjA2V5ojpZuc9kUDYecnM4p1+iPkG8nOgKBpMeld
         rciu0aYMHWo4VU3Q/mzIq3Va/6dOrEP+YjyG5YkTqCIRIfHQ6z4rAa2IotKAKF+nBst5
         QeV5sTgvDYtKu1XJJd3MntmjJyV5yc0qjs1i44WYnebtWJyX4ZDpRZGB4oPtRdZyz7s/
         c6+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=54lx3anSvHU8zNxE3mHWLM2bGAsQ9YpvqZlOWx8YeIA=;
        b=oIQHAJ+8EqqutU7MG6JraZ6iBV8UGvQk0zTnF2/WtuccUUhPM/VpRwdT6MVblx2w5w
         QRm1PH+BcWBrgoCVRCxihN07roZcFyhdcUebBTDiypHQkb5OMITx/mX/VAgRd/OA4+ic
         MtQLSbDPh2+AinB75+xK0kpsk8JjC8y13fA/lf6I334wlwEQ42R/5BrAkNHt1I5fyNkw
         LHaLx9DQlvTT5SgQhD0VNs6oj2vhezI0CsEtBstkWNoe5AJbPVjN1o5hUGADrjIGd7hc
         HYi82C2OxxC5xiJiOJwVbt0X+H528qdBxHU+jbKq8rNyRd4obOG2kUuAg0OpIlv/QIGx
         sz9w==
X-Gm-Message-State: AOAM5324n/Ezqj+IiL6j6J4idDqaFzo6XwN3kIlEm6A1KOtgwqdHt36I
        8IaXlbxvOtb0IxvIIjJ41bQ=
X-Google-Smtp-Source: ABdhPJzMssKrUjUoshJuCIJz519Vh3hllw08sufUIjgReljk1VAYTOMBrev1yDwYqNXDUVm/TN5kgw==
X-Received: by 2002:a17:90b:38d2:b0:1c7:1326:ec98 with SMTP id nn18-20020a17090b38d200b001c71326ec98mr2433826pjb.18.1647917353527;
        Mon, 21 Mar 2022 19:49:13 -0700 (PDT)
Received: from [192.168.122.100] (133-175-21-116.tokyo.ap.gmo-isp.jp. [133.175.21.116])
        by smtp.gmail.com with ESMTPSA id kk11-20020a17090b4a0b00b001c73933d803sm741128pjb.10.2022.03.21.19.49.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 19:49:13 -0700 (PDT)
Message-ID: <e4142a59-6193-8dd9-0562-fd3310067b09@gmail.com>
Date:   Tue, 22 Mar 2022 11:49:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4 2/3] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Content-Language: en-US
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     linux-mtd@lists.infradead.org, stable@vger.kernel.org
References: <20220316155455.162362-1-ikegami.t@gmail.com>
 <20220316155455.162362-3-ikegami.t@gmail.com> <20220316182100.6e2e5876@xps13>
 <01fed0aa-8844-1db9-f167-e7e7944bc092@ti.com>
 <201907b1-c43a-8c45-7ab1-4a4606591bef@pengutronix.de>
From:   Tokunori Ikegami <ikegami.t@gmail.com>
In-Reply-To: <201907b1-c43a-8c45-7ab1-4a4606591bef@pengutronix.de>
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

Hi Ahmad-san,

On 2022/03/17 23:16, Ahmad Fatoum wrote:
> Hello Vignesh,
>
> On 17.03.22 11:01, Vignesh Raghavendra wrote:
>>
>> On 16/03/22 10:51 pm, Miquel Raynal wrote:
>>> Hi Tokunori,
>>>
>>> ikegami.t@gmail.com wrote on Thu, 17 Mar 2022 00:54:54 +0900:
>>>
>>>> As pointed out by this bug report [1], buffered writes are now broken on
>>>> S29GL064N. This issue comes from a rework which switched from using chip_good()
>>>> to chip_ready(), because DQ true data 0xFF is read on S29GL064N and an error
>>>> returned by chip_good().
>>> Vignesh, I believe you understand this issue better than I do, can you
>>> propose an improved commit log?
>> How about:
>>
>> Since commit dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to
>> check correct value") buffered writes fail on S29GL064N. This is
>> because, on S29GL064N, reads return 0xFF at the end of DQ polling for
>> write completion, where as, chip_good() check expects actual data
>> written to the last location to be returned post DQ polling completion.
>> Fix is to revert to using chip_good() for S29GL064N which only checks
>> for DQ lines to settle down to determine write completion.
> Message sounds good to me with one remark: The issue is independent of
> whether buffered writes are used or not. It's just because buffered writes
> are the default, that it was broken by dfeae1073583 ("mtd: cfi_cmdset_0002:
> Change write buffer to check correct value"). The word write case was broken
> by 37c673ade35c ("mtd: cfi_cmdset_0002: Use chip_good() to retry in
> do_write_oneword()"), so the commit message should probably reference
> both. as this commit indeed fixes both FORCE_WORD_WRITE == 0 and == 1.

Is this really caused the error on do_write_oneword by the changed?
Actually it was changed to use chip_good instead of chip_ready.
But before the change still do_write_oneword uses both chip_ready and 
chip_good.
So it seems that it is possible to be caused the error before the change 
also.

By the way could you please try to test the version 5 patches again?

Regards,
Ikegami

>
> Thanks,
> Ahmad
>
>
>>>> One way to solve the issue is to revert the change
>>>> partially to use chip_ready for S29GL064N.
>>>>
>>>> [1] https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
>>>>
>>>> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
>>>> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
>>>> Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
>>>> Cc: stable@vger.kernel.org
>>>> ---
>>>>   drivers/mtd/chips/cfi_cmdset_0002.c | 25 +++++++++++++++++++++----
>>>>   1 file changed, 21 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
>>>> index e68ddf0f7fc0..6c57f85e1b8e 100644
>>>> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
>>>> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
>>>> @@ -866,6 +866,23 @@ static int __xipram chip_check(struct map_info *map, struct flchip *chip,
>>>>   		chip_check(map, chip, addr, &datum); \
>>>>   	})
>>>>   
>>>> +static bool __xipram cfi_use_chip_ready_for_write(struct map_info *map)
>>> At the very least I would call this function:
>>> cfi_use_chip_ready_for_writes()
>>>
>>> Yet, I still don't fully get what chip_ready is versus chip_good.
>>>
>>>> +{
>>>> +	struct cfi_private *cfi = map->fldrv_priv;
>>>> +
>>>> +	return cfi->mfr == CFI_MFR_AMD && cfi->id == 0x0c01;
>>>> +}
>>>> +
>>>> +static int __xipram chip_good_for_write(struct map_info *map,
>>>> +					struct flchip *chip, unsigned long addr,
>>>> +					map_word expected)
>>>> +{
>>>> +	if (cfi_use_chip_ready_for_write(map))
>>>> +		return chip_ready(map, chip, addr);
>>> If possible and not too invasive I would definitely add a "quirks" flag
>>> somewhere instead of this cfi_use_chip_ready_for_write() check.
>>>
>>> Anyway, I would move this to the chip_good() implementation directly so
>>> we partially hide the quirks complexity from the core.
>> Yeah, unfortunately this driver does not use quirk flags and tends to
>> hide quirks behind bool functions like above
>>
>> Regards
>> Vignesh
>>
>
