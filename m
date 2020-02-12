Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3203015AF53
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 19:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgBLSAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 13:00:23 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2418 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726728AbgBLSAX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Feb 2020 13:00:23 -0500
Received: from LHREML714-CAH.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id C0F5658CB99D5FE7F742;
        Wed, 12 Feb 2020 18:00:20 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML714-CAH.china.huawei.com (10.201.108.37) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 12 Feb 2020 18:00:20 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 12 Feb
 2020 18:00:20 +0000
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
        chenxiang <chenxiang66@hisilicon.com>
References: <20200205165736.4964-1-alexander.sverdlin@nokia.com>
 <62a35797-4e78-f6b0-de86-50004bc636ca@huawei.com>
 <385c743e-0d8d-bcdc-7dd8-a1a619380b0a@ti.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <0c894f19-6e19-c90a-afe7-e7f2a086b436@huawei.com>
Date:   Wed, 12 Feb 2020 18:00:19 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <385c743e-0d8d-bcdc-7dd8-a1a619380b0a@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml720-chm.china.huawei.com (10.201.108.71) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/02/2020 05:03, Vignesh Raghavendra wrote:
> Hi Alexander,
> 
> On 06/02/20 5:08 pm, John Garry wrote:
>> On 05/02/2020 16:57, Alexander A Sverdlin wrote:
>>> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
>>>
> [...]
>>> +static int s25fs_s_post_bfpt_fixups(struct spi_nor *nor,
>>> +    const struct sfdp_parameter_header *bfpt_header,
>>> +    const struct sfdp_bfpt *bfpt,
>>> +    struct spi_nor_flash_parameter *params)
>>> +{
>>> +    const struct flash_info *info = nor->info;
>>> +    u8 read_opcode, buf;
>>> +    int ret;
>>> +
>>> +    /* Default is safe */
>>> +    params->page_size = info->page_size;
>>> +
>>> +    /*
>>> +     * But is the chip configured for more performant 512 bytes write
>>> page
>>> +     * size?
>>> +     */
>>> +    read_opcode = nor->read_opcode;
>>> +
>>> +    nor->read_opcode = SPINOR_OP_RDAR;
>>> +    ret = nor->read(nor, SPINOR_REG_CR3V, 1, &buf);
>>
>> The read method is now gone from struct spi_nor, moved into
>> spi_nor.controller_ops. And we also support spi_mem ops now.
>>
> 
> Yes, please rebase patch on top of latest spi-nor/next or linux-next tree at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git spi-nor/next
> 
> Regards
> Vignesh
> 

I don't mean to hijack this thread, but I have tried to enable QUAD mode 
for part s25fl129p1, and it fails in spi_nor_write_16bit_cr_and_check():

[ 47.263365] spi-nor spi-PRP0001:00: CR: read back test failed
[ 47.306567] spi-nor spi-PRP0001:00: quad mode not supported
[ 47.322413] spi-nor: probe of spi-PRP0001:00 failed with error -5

Hacking the flags to set SNOR_F_NO_READ_CR, and at least I can 
successfully probe the driver.

Does anyone know if this part does not support reading the config 
register. The limited datasheet here doesn't mention it, AFAICT:

https://www.cypress.com/file/196851/download

Thanks,
John

> 
>>
>>> +    if (!ret && (buf & CR3V_02H_V))
>>> +        params->page_size = 512;
>>> +
>>> +    nor->read_opcode = read_opcode;
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static const struct spi_nor_fixups s25fs_s_fixups = {
>>> +    .post_bfpt = s25fs_s_post_bfpt_fixups,
>>> +};
>>> +
>>>    /* NOTE: double check command sets and memory organization when you add
>>>     * more nor chips.  This current list focusses on newer chips, which
>>>     * have been converging on command sets which including JEDEC ID.
>>> @@ -2536,7 +2569,8 @@ static const struct flash_info spi_nor_ids[] = {
>>>                SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>>        { "s25fl128s1", INFO6(0x012018, 0x4d0180, 64 * 1024, 256,
>>>                SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>> -    { "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, USE_CLSR) },
>>> +    { "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, USE_CLSR)
>>> +            .fixups = &s25fs_s_fixups, },
>>>        { "s25fl256s1", INFO(0x010219, 0x4d01,  64 * 1024, 512,
>>> SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>>        { "s25fl512s",  INFO6(0x010220, 0x4d0080, 256 * 1024, 256,
>>>                SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
>>> @@ -2546,7 +2580,8 @@ static const struct flash_info spi_nor_ids[] = {
>>>        { "s25sl12800", INFO(0x012018, 0x0300, 256 * 1024,  64, 0) },
>>>        { "s25sl12801", INFO(0x012018, 0x0301,  64 * 1024, 256, 0) },
>>>        { "s25fl129p0", INFO(0x012018, 0x4d00, 256 * 1024,  64,
>>> SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>> -    { "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256,
>>> SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>> +    { "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256,
>>> SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR)
>>> +            .fixups = &s25fs_s_fixups, },
>>>        { "s25sl004a",  INFO(0x010212,      0,  64 * 1024,   8, 0) },
>>>        { "s25sl008a",  INFO(0x010213,      0,  64 * 1024,  16, 0) },
>>>        { "s25sl016a",  INFO(0x010214,      0,  64 * 1024,  32, 0) },
>>> diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h
>>> index 5abd91c..7ce3e79 100644
>>> --- a/include/linux/mtd/spi-nor.h
>>> +++ b/include/linux/mtd/spi-nor.h
>>> @@ -116,6 +116,7 @@
>>>    /* Used for Spansion flashes only. */
>>>    #define SPINOR_OP_BRWR        0x17    /* Bank register write */
>>>    #define SPINOR_OP_CLSR        0x30    /* Clear status register 1 */
>>> +#define SPINOR_OP_RDAR        0x65    /* Read Any Register */
>>>      /* Used for Micron flashes only. */
>>>    #define SPINOR_OP_RD_EVCR      0x65    /* Read EVCR register */
>>> @@ -150,6 +151,10 @@
>>>    #define SR2_QUAD_EN_BIT1    BIT(1)
>>>    #define SR2_QUAD_EN_BIT7    BIT(7)
>>>    +/* Used for Spansion flashes RDAR command only. */
>>> +#define SPINOR_REG_CR3V        0x800004
>>> +#define CR3V_02H_V        BIT(4)    /* Page Buffer Wrap */
>>> +
>>>    /* Supported SPI protocols */
>>>    #define SNOR_PROTO_INST_MASK    GENMASK(23, 16)
>>>    #define SNOR_PROTO_INST_SHIFT    16
>>>
>>
>>
>> ______________________________________________________
>> Linux MTD discussion mailing list
>> http://lists.infradead.org/mailman/listinfo/linux-mtd/
> 

