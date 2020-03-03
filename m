Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E53177A3A
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 16:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgCCPTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 10:19:38 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2505 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728330AbgCCPTi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 10:19:38 -0500
Received: from lhreml703-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id A8D7073E6D8D73F92C0F;
        Tue,  3 Mar 2020 15:19:36 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml703-cah.china.huawei.com (10.201.108.44) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 3 Mar 2020 15:19:32 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 3 Mar 2020
 15:19:32 +0000
Subject: Re: [PATCH] mtd: spi-nor: Fixup page size and map selection for
 S25FS-S
To:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        <linux-mtd@lists.infradead.org>
CC:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        Richard Weinberger <richard@nod.at>, <stable@vger.kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Boris Brezillon <bbrezillon@kernel.org>
References: <20200227123657.26030-1-alexander.sverdlin@nokia.com>
 <18cdef63-75e3-97c3-2a22-4969d4997af9@hisilicon.com>
 <60b272c1-ab6a-7a7a-6f56-03d7c7daf8bc@nokia.com>
 <43ae2554-06c8-59f9-153e-094a326166c2@huawei.com>
 <5d6f3062-677f-3d0d-b0d7-7c97c658ed89@nokia.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <1f87b621-5c6e-3ac2-9559-d5b4ba9b0067@huawei.com>
Date:   Tue, 3 Mar 2020 15:19:31 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <5d6f3062-677f-3d0d-b0d7-7c97c658ed89@nokia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml725-chm.china.huawei.com (10.201.108.76) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/03/2020 14:27, Alexander Sverdlin wrote:

Hi Alexander,

> 
> On 02/03/2020 19:25, John Garry wrote:
>>>>> -    { "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>>>> +    { "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR)
>>>>> +            .fixups = &s25fs_s_fixups, },
>>>>
>>>> It seems SFDP is not supported on s25fl129p (you can check it on https://www.cypress.com/file/400586/download), so is it necessary to add this for this type flash?
>>>
>>> Yes, all of the above is necessary to repair S25FS128S, which supports SFDP and lands
>>> in the above table entry.
>>
>> So do you know how we can tell if the part is s25fl129p1 or S25FS128S? Is it based on family id? For the part of my board, it has the same id according to "s25fl129p1" entry in the spi-nor driver, yet the SFDP signature is not present (signature reads as 0x4d182001 vs expected 0x50444653). I printed the family id, and it is 81h, which seems to align with S25FS (which should support SFDP). Confused.
>>
>> What's more, the spi-nor probe is failing for this part since I enabled quad spi. So I am interested to know if there is some differences between these part families for that.
> 
> I'd say, one can distinguish them by the fact one does support SFDP and another doesn't.
> Is it really necessary to distinguish them?

Well it would help me to know for sure which part is on my board :)

As an example of a relevant difference, S25FS128S datasheet has CR1V and 
CR1NV, but S25FL129 only has a single configuration register, and this 
is related to quad mode enable, which I am debugging.

BTW, Have you tried to enable quad mode for your S25FS-S part?

Thanks,
John
