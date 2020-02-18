Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6271161FF0
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 05:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgBREx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 23:53:27 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:48466 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgBREx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 23:53:27 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01I4qW3l124315;
        Mon, 17 Feb 2020 22:52:32 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582001552;
        bh=OFRxooe9h3KsikOUaCvlPYQYVXr5H+31/6ElIndnyoI=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=YS2E3Y89G52EGyFiL9+PnCHXJi98uWAt9EZ6zZzPAgg6n6K6DxRRcn0KILASxpf7g
         yPg5lQ0w8XUUqRXWCMteje3J0zCt8xl5KMZz4HsWeBPG306ETZM0SMk7wfs8yv5jys
         fudNJjloM9bCvKih4N9BVyPhWWZ8h4dhUXuP8kj0=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01I4qW3Z000661;
        Mon, 17 Feb 2020 22:52:32 -0600
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 17
 Feb 2020 22:52:31 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 17 Feb 2020 22:52:32 -0600
Received: from [172.24.145.136] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01I4qS3m027141;
        Mon, 17 Feb 2020 22:52:28 -0600
Subject: Re: [PATCH v2] mtd: spi-nor: Fixup page size for S25FS-S
To:     John Garry <john.garry@huawei.com>,
        Alexander A Sverdlin <alexander.sverdlin@nokia.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC:     Boris Brezillon <bbrezillon@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        chenxiang <chenxiang66@hisilicon.com>
References: <20200205165736.4964-1-alexander.sverdlin@nokia.com>
 <62a35797-4e78-f6b0-de86-50004bc636ca@huawei.com>
 <385c743e-0d8d-bcdc-7dd8-a1a619380b0a@ti.com>
 <0c894f19-6e19-c90a-afe7-e7f2a086b436@huawei.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <0b5af315-5e1b-31ef-6cb9-eefefc86b425@ti.com>
Date:   Tue, 18 Feb 2020 10:23:07 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <0c894f19-6e19-c90a-afe7-e7f2a086b436@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/02/20 11:30 pm, John Garry wrote:
> On 07/02/2020 05:03, Vignesh Raghavendra wrote:
>> Hi Alexander,
>>
>> On 06/02/20 5:08 pm, John Garry wrote:
>>> On 05/02/2020 16:57, Alexander A Sverdlin wrote:
>>>> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
>>>>
>> [...]
[...]
> 
> I don't mean to hijack this thread, but I have tried to enable QUAD mode
> for part s25fl129p1, and it fails in spi_nor_write_16bit_cr_and_check():
> 
> [ 47.263365] spi-nor spi-PRP0001:00: CR: read back test failed
> [ 47.306567] spi-nor spi-PRP0001:00: quad mode not supported
> [ 47.322413] spi-nor: probe of spi-PRP0001:00 failed with error -5
> 
> Hacking the flags to set SNOR_F_NO_READ_CR, and at least I can
> successfully probe the driver.
> 
> Does anyone know if this part does not support reading the config
> register. The limited datasheet here doesn't mention it, AFAICT:
> 
> https://www.cypress.com/file/196851/download

Above datasheet is for s25fl128p.

Per, s25fl129p datasheet[1], part does support 0x35 (SPINOR_OP_RDCR)
command and support 16bit write status register command (0x1)

Could you debug further and see what exactly fails to match when
read back fails?

[1]https://www.cypress.com/file/197121/download


Regards
Vignesh

> 
> Thanks,
> John
> 
>>
>>>
>>>> +    if (!ret && (buf & CR3V_02H_V))
>>>> +        params->page_size = 512;
>>>> +
>>>> +    nor->read_opcode = read_opcode;
>>>> +
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +static const struct spi_nor_fixups s25fs_s_fixups = {
>>>> +    .post_bfpt = s25fs_s_post_bfpt_fixups,
>>>> +};
>>>> +
>>>>    /* NOTE: double check command sets and memory organization when
>>>> you add
>>>>     * more nor chips.  This current list focusses on newer chips, which
>>>>     * have been converging on command sets which including JEDEC ID.
>>>> @@ -2536,7 +2569,8 @@ static const struct flash_info spi_nor_ids[] = {
>>>>                SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>>>        { "s25fl128s1", INFO6(0x012018, 0x4d0180, 64 * 1024, 256,
>>>>                SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>>> -    { "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128,
>>>> USE_CLSR) },
>>>> +    { "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, USE_CLSR)
>>>> +            .fixups = &s25fs_s_fixups, },
>>>>        { "s25fl256s1", INFO(0x010219, 0x4d01,  64 * 1024, 512,
>>>> SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>>>        { "s25fl512s",  INFO6(0x010220, 0x4d0080, 256 * 1024, 256,
>>>>                SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
>>>> @@ -2546,7 +2580,8 @@ static const struct flash_info spi_nor_ids[] = {
>>>>        { "s25sl12800", INFO(0x012018, 0x0300, 256 * 1024,  64, 0) },
>>>>        { "s25sl12801", INFO(0x012018, 0x0301,  64 * 1024, 256, 0) },
>>>>        { "s25fl129p0", INFO(0x012018, 0x4d00, 256 * 1024,  64,
>>>> SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>>> -    { "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256,
>>>> SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>>> +    { "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256,
>>>> SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR)
>>>> +            .fixups = &s25fs_s_fixups, },
>>>>        { "s25sl004a",  INFO(0x010212,      0,  64 * 1024,   8, 0) },
>>>>        { "s25sl008a",  INFO(0x010213,      0,  64 * 1024,  16, 0) },
>>>>        { "s25sl016a",  INFO(0x010214,      0,  64 * 1024,  32, 0) },
>>>> diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h
>>>> index 5abd91c..7ce3e79 100644
>>>> --- a/include/linux/mtd/spi-nor.h
>>>> +++ b/include/linux/mtd/spi-nor.h
>>>> @@ -116,6 +116,7 @@
>>>>    /* Used for Spansion flashes only. */
>>>>    #define SPINOR_OP_BRWR        0x17    /* Bank register write */
>>>>    #define SPINOR_OP_CLSR        0x30    /* Clear status register 1 */
>>>> +#define SPINOR_OP_RDAR        0x65    /* Read Any Register */
>>>>      /* Used for Micron flashes only. */
>>>>    #define SPINOR_OP_RD_EVCR      0x65    /* Read EVCR register */
>>>> @@ -150,6 +151,10 @@
>>>>    #define SR2_QUAD_EN_BIT1    BIT(1)
>>>>    #define SR2_QUAD_EN_BIT7    BIT(7)
>>>>    +/* Used for Spansion flashes RDAR command only. */
>>>> +#define SPINOR_REG_CR3V        0x800004
>>>> +#define CR3V_02H_V        BIT(4)    /* Page Buffer Wrap */
>>>> +
>>>>    /* Supported SPI protocols */
>>>>    #define SNOR_PROTO_INST_MASK    GENMASK(23, 16)
>>>>    #define SNOR_PROTO_INST_SHIFT    16
>>>>
>>>
>>>
>>> ______________________________________________________
>>> Linux MTD discussion mailing list
>>> http://lists.infradead.org/mailman/listinfo/linux-mtd/
>>
> 

-- 
Regards
Vignesh
