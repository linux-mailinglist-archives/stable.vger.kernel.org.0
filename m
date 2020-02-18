Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B288162DA0
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 19:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgBRSBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 13:01:55 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2441 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726528AbgBRSBz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 13:01:55 -0500
Received: from LHREML714-CAH.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id E2F98400FDEB56B5A97E;
        Tue, 18 Feb 2020 18:01:53 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML714-CAH.china.huawei.com (10.201.108.37) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 18 Feb 2020 18:01:53 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5; Tue, 18 Feb
 2020 18:01:52 +0000
Subject: Re: [PATCH v2] mtd: spi-nor: Fixup page size for S25FS-S
To:     Vignesh Raghavendra <vigneshr@ti.com>,
        Alexander A Sverdlin <alexander.sverdlin@nokia.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC:     Boris Brezillon <bbrezillon@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>
References: <20200205165736.4964-1-alexander.sverdlin@nokia.com>
 <62a35797-4e78-f6b0-de86-50004bc636ca@huawei.com>
 <385c743e-0d8d-bcdc-7dd8-a1a619380b0a@ti.com>
 <0c894f19-6e19-c90a-afe7-e7f2a086b436@huawei.com>
 <0b5af315-5e1b-31ef-6cb9-eefefc86b425@ti.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <9042100b-eb7a-8285-6127-25d5b0073e94@huawei.com>
Date:   Tue, 18 Feb 2020 18:01:51 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <0b5af315-5e1b-31ef-6cb9-eefefc86b425@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml703-chm.china.huawei.com (10.201.108.52) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/02/2020 04:53, Vignesh Raghavendra wrote:
>> I don't mean to hijack this thread, but I have tried to enable QUAD mode
>> for part s25fl129p1, and it fails in spi_nor_write_16bit_cr_and_check():
>>
>> [ 47.263365] spi-nor spi-PRP0001:00: CR: read back test failed
>> [ 47.306567] spi-nor spi-PRP0001:00: quad mode not supported
>> [ 47.322413] spi-nor: probe of spi-PRP0001:00 failed with error -5
>>
>> Hacking the flags to set SNOR_F_NO_READ_CR, and at least I can
>> successfully probe the driver.
>>
>> Does anyone know if this part does not support reading the config
>> register. The limited datasheet here doesn't mention it, AFAICT:
>>

Hi Vignesh,

>> https://www.cypress.com/file/196851/download
> Above datasheet is for s25fl128p.
> 

Right, I figured this out soon enough. I shouldn't just click on the 
first page which google produces...

> Per, s25fl129p datasheet[1], part does support 0x35 (SPINOR_OP_RDCR)
> command and support 16bit write status register command (0x1)
> 
> Could you debug further and see what exactly fails to match when
> read back fails?

I was trying to figure out the issue. So in 
spi_nor_write_16bit_cr_and_check(), the sr check passes (it holds 0, so 
that may be somewhat inconclusive) but the value for comparison return 0 
in the CR also versus expected 3.

Maybe it is a host driver issue, but I am doubtful.

I can continue to investigate. Any ideas would be appreciated.

> 
> [1]https://www.cypress.com/file/197121/download
> 
> 

Thanks,
John

