Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527CC1B992D
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 10:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgD0IAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 04:00:12 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3311 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726243AbgD0IAM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Apr 2020 04:00:12 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 70D572938F279006524B;
        Mon, 27 Apr 2020 16:00:09 +0800 (CST)
Received: from [10.65.58.147] (10.65.58.147) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Mon, 27 Apr 2020
 15:59:59 +0800
Subject: Re: [PATCH] mtd: spi-nor: Fixup page size and map selection for
 S25FS-S
To:     John Garry <john.garry@huawei.com>, <Tudor.Ambarus@microchip.com>
References: <20200227123657.26030-1-alexander.sverdlin@nokia.com>
 <60b272c1-ab6a-7a7a-6f56-03d7c7daf8bc@nokia.com>
 <43ae2554-06c8-59f9-153e-094a326166c2@huawei.com>
 <2955278.kW1ZWP0GTs@192.168.0.120>
 <d42386c8-9c31-ed9c-d8e7-8d09e43b46fb@huawei.com>
CC:     <alexander.sverdlin@nokia.com>, <chenxiang66@hisilicon.com>,
        <linux-mtd@lists.infradead.org>, <richard@nod.at>,
        <stable@vger.kernel.org>, <marek.vasut@gmail.com>,
        <computersforpeace@gmail.com>, <dwmw2@infradead.org>,
        <bbrezillon@kernel.org>
From:   Yicong Yang <yangyicong@hisilicon.com>
Message-ID: <0f4a949e-ff1f-f8c6-bdd0-7ebd5f1118b1@hisilicon.com>
Date:   Mon, 27 Apr 2020 16:03:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <d42386c8-9c31-ed9c-d8e7-8d09e43b46fb@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.58.147]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi John and Tudor,


On 2020/4/27 15:27, John Garry wrote:
> + Yicong Yang
>
> Hi Tudor,
>
>>
>> On Monday, March 2, 2020 8:25:48 PM EEST John Garry wrote:
>>> So do you know how we can tell if the part is s25fl129p1 or S25FS128S?
>>> Is it based on family id? For the part of my board, it has the same id
>>> according to "s25fl129p1" entry in the spi-nor driver, yet the SFDP
>>> signature is not present (signature reads as 0x4d182001 vs expected
>>
>>   0x4d182001 looks like the flash id, but in reversed order.
>>
>>> 0x50444653). I printed the family id, and it is 81h, which seems to
>>> align with S25FS (which should support SFDP). Confused.
>>>
>>
>> We can differentiate between flashes by the family id:  80h for FL-S and 81h
>> for FS-S. If I understood correctly your flash id is 0x01, 0x20, 0x18, 0x4d,
>> 0x01, 0x81. According to the spansion datasheets, this should identify with a
>> s25fs128s1 entry. Please check the patch from below, let me know if it's ok.
>>
>>> What's more, the spi-nor probe is failing for this part since I enabled
>>> quad spi. So I am interested to know if there is some differences
>>> between these part families for that.
>>
>> In which conditions is it failing? Please open a separate thread.
>
> So my colleague Yicon debugged this, and it seems to be an issue with our controller. The background is that we can blacklist certain commands in firmware, and some relevant commands were blacklisted such that quad enable failed.
>
> But we have it working now, I think. Yicon can confirm (or start a thread please for outstanding issues).

Yes, now the flash is fully enabled. It's the firmware matters, not about the kernel drivers nor the flash.

>
>> diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
>> index 88183eba8ac1..ea72f0e5be73 100644
>> --- a/drivers/mtd/spi-nor/spansion.c
>> +++ b/drivers/mtd/spi-nor/spansion.c
>> @@ -22,6 +22,9 @@ static const struct flash_info spansion_parts[] = {
>>          { "s25fl128s1", INFO6(0x012018, 0x4d0180, 64 * 1024, 256,
>>                                SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
>>                                USE_CLSR) },
>> +       { "s25fs128s1", INFO6(0x012018, 0x4d0181,  64 * 1024, 256,
>> +                             SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
>> +                             USE_CLSR) },
>
> I wasn't sure if you wanted to add a separate entry if it has same properties as other part, due to extra maintenance. It is nice to know the exact part, though.

The flash need some post bfpt fixup. As the page size may configured as 512byte, not the 256byte
parsed from bfpt. So a separate entry is needed. Both Alexander and Sergei provide the solution,
and I add it in my patch.

Regards,
Yicong

>
>>          { "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128,
>>                               SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
>>                               USE_CLSR) },
>>
>>
>> .
>>
>
> .
>

