Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB65B4E36C1
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 03:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbiCVClW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 22:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbiCVClV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 22:41:21 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10EB1D30C
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 19:39:54 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id bc27so11640093pgb.4
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 19:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4zT38W/g3Nlr5yWulzhtGBybnz/7yz2x7YGjZPuQI/k=;
        b=hLL+roDqm7W+xRi4+GuFdSbzPUWo+gNAt1Gqr4yhI0t7jOMmtUqkePjf7KzLpBk0pL
         Idc2bZIftCtqRbxz6i/KxPJ1R2oyrpdtnb9ajbPnCYYTfZIoR74Vf4lNNIz0lb7+HxAB
         G6T3QSVPfLtOds39XblzMmg/lTluBuIZO4gp9463lekRxwUD8b8g8WMZFV8dG1fR6Dlt
         56Kt7EPUmQsE3/+FTjcTW5csMTIxKAknKjRr2nu5ZgK8VgJk22Umli8+k7+RpKdWhX9D
         GIeHCb9mKIG2e7szp8ySUJl2NwPp4IJ270xru5dL3/1LDMLcSuq+9fnpkWHTopxgtyrg
         RFMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4zT38W/g3Nlr5yWulzhtGBybnz/7yz2x7YGjZPuQI/k=;
        b=j9roK3FWk+cO5cP/0+3KDup472mVWzLb6U7uCnAclQs6MeKbE4KEToS0L6YKjPoVqN
         NyLEs3ndXUjAwczzS0LHGbqUYxczdS2nzUpPa3sguR/qL0UgNhTUK3mmGw1Wb8mxlHCX
         fkdLyO1IoHzs/kyHod2nbhnEP02RBNN5ewIAn4L+zUnT9F5tpLkyDSG12nltFEO9tddi
         dDxClFJ/saqGWX0XeL06a+ERgP4KPDSZzd/U8ZJBAfZW2sulwgWHxKBKQbFVghneUn6e
         pcNNqnTo7KITmuxeCULapwlN8VN79qpaKaL93AwtNGRzEK04/mec2nlhgWvtHqE66neb
         jN7w==
X-Gm-Message-State: AOAM530dUFzSBptLu0JlPeh3A+nPunjpHQ8z9NaZ7lXBSUyTTrbd0p/b
        aBBHwvylukAXgX8n4yIIYZw=
X-Google-Smtp-Source: ABdhPJxiSHJ1ylSMabnIDO7zYp4X5PXuw9twxYJKtZru9KM23TEAqcwhkyxFsXToYcYvra1MASeZqQ==
X-Received: by 2002:a05:6a00:781:b0:4f4:2a:2d89 with SMTP id g1-20020a056a00078100b004f4002a2d89mr26694381pfu.13.1647916793925;
        Mon, 21 Mar 2022 19:39:53 -0700 (PDT)
Received: from [192.168.122.100] (133-175-21-116.tokyo.ap.gmo-isp.jp. [133.175.21.116])
        by smtp.gmail.com with ESMTPSA id gb5-20020a17090b060500b001c6d46f7e75sm752580pjb.30.2022.03.21.19.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 19:39:53 -0700 (PDT)
Message-ID: <faae174c-bb3f-e4e2-dc6c-b79186d9804c@gmail.com>
Date:   Tue, 22 Mar 2022 11:39:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4 2/3] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     linux-mtd@lists.infradead.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, stable@vger.kernel.org
References: <20220316155455.162362-1-ikegami.t@gmail.com>
 <20220316155455.162362-3-ikegami.t@gmail.com> <20220316182100.6e2e5876@xps13>
From:   Tokunori Ikegami <ikegami.t@gmail.com>
In-Reply-To: <20220316182100.6e2e5876@xps13>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Miquèl-san,

On 2022/03/17 2:21, Miquel Raynal wrote:
> Hi Tokunori,
>
> ikegami.t@gmail.com wrote on Thu, 17 Mar 2022 00:54:54 +0900:
>
>> As pointed out by this bug report [1], buffered writes are now broken on
>> S29GL064N. This issue comes from a rework which switched from using chip_good()
>> to chip_ready(), because DQ true data 0xFF is read on S29GL064N and an error
>> returned by chip_good().
> Vignesh, I believe you understand this issue better than I do, can you
> propose an improved commit log?
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
>>   drivers/mtd/chips/cfi_cmdset_0002.c | 25 +++++++++++++++++++++----
>>   1 file changed, 21 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
>> index e68ddf0f7fc0..6c57f85e1b8e 100644
>> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
>> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
>> @@ -866,6 +866,23 @@ static int __xipram chip_check(struct map_info *map, struct flchip *chip,
>>   		chip_check(map, chip, addr, &datum); \
>>   	})
>>   
>> +static bool __xipram cfi_use_chip_ready_for_write(struct map_info *map)
> At the very least I would call this function:
> cfi_use_chip_ready_for_writes()
>
> Yet, I still don't fully get what chip_ready is versus chip_good.
This was deleted as to use the quirks flag instead.
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
> If possible and not too invasive I would definitely add a "quirks" flag
> somewhere instead of this cfi_use_chip_ready_for_write() check.
Added the quirks flag by the version 5 patch.
>
> Anyway, I would move this to the chip_good() implementation directly so
> we partially hide the quirks complexity from the core.

Yes also added the chip_good to check the quirks flag.

Regards,
Ikegami

>
>> +
>> +	return chip_good(map, chip, addr, expected);
>> +}
>> +
>>   static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr, int mode)
>>   {
>>   	DECLARE_WAITQUEUE(wait, current);
>> @@ -1686,7 +1703,7 @@ static int __xipram do_write_oneword_once(struct map_info *map,
>>   		 * "chip_good" to avoid the failure due to scheduling.
>>   		 */
>>   		if (time_after(jiffies, timeo) &&
>> -		    !chip_good(map, chip, adr, datum)) {
>> +		    !chip_good_for_write(map, chip, adr, datum)) {
>>   			xip_enable(map, chip, adr);
>>   			printk(KERN_WARNING "MTD %s(): software timeout\n", __func__);
>>   			xip_disable(map, chip, adr);
>> @@ -1694,7 +1711,7 @@ static int __xipram do_write_oneword_once(struct map_info *map,
>>   			break;
>>   		}
>>   
>> -		if (chip_good(map, chip, adr, datum)) {
>> +		if (chip_good_for_write(map, chip, adr, datum)) {
>>   			if (cfi_check_err_status(map, chip, adr))
>>   				ret = -EIO;
>>   			break;
>> @@ -1966,14 +1983,14 @@ static int __xipram do_write_buffer_wait(struct map_info *map,
>>   		 * "chip_good" to avoid the failure due to scheduling.
>>   		 */
>>   		if (time_after(jiffies, timeo) &&
>> -		    !chip_good(map, chip, adr, datum)) {
>> +		    !chip_good_for_write(map, chip, adr, datum)) {
>>   			pr_err("MTD %s(): software timeout, address:0x%.8lx.\n",
>>   			       __func__, adr);
>>   			ret = -EIO;
>>   			break;
>>   		}
>>   
>> -		if (chip_good(map, chip, adr, datum)) {
>> +		if (chip_good_for_write(map, chip, adr, datum)) {
>>   			if (cfi_check_err_status(map, chip, adr))
>>   				ret = -EIO;
>>   			break;
>
> Thanks,
> Miquèl
