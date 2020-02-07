Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4167A1551AD
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 06:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725851AbgBGFDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 00:03:36 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:35666 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgBGFDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 00:03:36 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01752q9W130484;
        Thu, 6 Feb 2020 23:02:52 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1581051772;
        bh=erIMCRx9fjvY7yhdtjzBeMd16LGFEZD4T/l0xF/Y/BA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=I/k7PL9qrBl7x0JqPAU321lz7GAg0ubXo+g/zwu54r3pssMnWGLz2e0FZu/TkGp9w
         T/WfhJlPcnphGb0EdczgIBxu/wMjQaRWX2LVuaK7xgElfu90+GQGaYYE6JbFbgJKo3
         bLJ51ulwBFR/Wl9EZpCvF0x0b+mczgNPjLlKVgUw=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01752pF4077144;
        Thu, 6 Feb 2020 23:02:52 -0600
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 6 Feb
 2020 23:02:51 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 6 Feb 2020 23:02:51 -0600
Received: from [172.24.145.136] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01752mgu030727;
        Thu, 6 Feb 2020 23:02:48 -0600
Subject: Re: [PATCH v2] mtd: spi-nor: Fixup page size for S25FS-S
To:     John Garry <john.garry@huawei.com>,
        Alexander A Sverdlin <alexander.sverdlin@nokia.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        Richard Weinberger <richard@nod.at>,
        Boris Brezillon <bbrezillon@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
References: <20200205165736.4964-1-alexander.sverdlin@nokia.com>
 <62a35797-4e78-f6b0-de86-50004bc636ca@huawei.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <385c743e-0d8d-bcdc-7dd8-a1a619380b0a@ti.com>
Date:   Fri, 7 Feb 2020 10:33:27 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <62a35797-4e78-f6b0-de86-50004bc636ca@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Alexander,

On 06/02/20 5:08 pm, John Garry wrote:
> On 05/02/2020 16:57, Alexander A Sverdlin wrote:
>> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
>>
[...]
>> +static int s25fs_s_post_bfpt_fixups(struct spi_nor *nor,
>> +    const struct sfdp_parameter_header *bfpt_header,
>> +    const struct sfdp_bfpt *bfpt,
>> +    struct spi_nor_flash_parameter *params)
>> +{
>> +    const struct flash_info *info = nor->info;
>> +    u8 read_opcode, buf;
>> +    int ret;
>> +
>> +    /* Default is safe */
>> +    params->page_size = info->page_size;
>> +
>> +    /*
>> +     * But is the chip configured for more performant 512 bytes write
>> page
>> +     * size?
>> +     */
>> +    read_opcode = nor->read_opcode;
>> +
>> +    nor->read_opcode = SPINOR_OP_RDAR;
>> +    ret = nor->read(nor, SPINOR_REG_CR3V, 1, &buf);
> 
> The read method is now gone from struct spi_nor, moved into
> spi_nor.controller_ops. And we also support spi_mem ops now.
> 

Yes, please rebase patch on top of latest spi-nor/next or linux-next tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git spi-nor/next

Regards
Vignesh


> 
>> +    if (!ret && (buf & CR3V_02H_V))
>> +        params->page_size = 512;
>> +
>> +    nor->read_opcode = read_opcode;
>> +
>> +    return ret;
>> +}
>> +
>> +static const struct spi_nor_fixups s25fs_s_fixups = {
>> +    .post_bfpt = s25fs_s_post_bfpt_fixups,
>> +};
>> +
>>   /* NOTE: double check command sets and memory organization when you add
>>    * more nor chips.  This current list focusses on newer chips, which
>>    * have been converging on command sets which including JEDEC ID.
>> @@ -2536,7 +2569,8 @@ static const struct flash_info spi_nor_ids[] = {
>>               SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>       { "s25fl128s1", INFO6(0x012018, 0x4d0180, 64 * 1024, 256,
>>               SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>> -    { "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, USE_CLSR) },
>> +    { "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, USE_CLSR)
>> +            .fixups = &s25fs_s_fixups, },
>>       { "s25fl256s1", INFO(0x010219, 0x4d01,  64 * 1024, 512,
>> SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>       { "s25fl512s",  INFO6(0x010220, 0x4d0080, 256 * 1024, 256,
>>               SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
>> @@ -2546,7 +2580,8 @@ static const struct flash_info spi_nor_ids[] = {
>>       { "s25sl12800", INFO(0x012018, 0x0300, 256 * 1024,  64, 0) },
>>       { "s25sl12801", INFO(0x012018, 0x0301,  64 * 1024, 256, 0) },
>>       { "s25fl129p0", INFO(0x012018, 0x4d00, 256 * 1024,  64,
>> SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>> -    { "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256,
>> SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>> +    { "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256,
>> SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR)
>> +            .fixups = &s25fs_s_fixups, },
>>       { "s25sl004a",  INFO(0x010212,      0,  64 * 1024,   8, 0) },
>>       { "s25sl008a",  INFO(0x010213,      0,  64 * 1024,  16, 0) },
>>       { "s25sl016a",  INFO(0x010214,      0,  64 * 1024,  32, 0) },
>> diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h
>> index 5abd91c..7ce3e79 100644
>> --- a/include/linux/mtd/spi-nor.h
>> +++ b/include/linux/mtd/spi-nor.h
>> @@ -116,6 +116,7 @@
>>   /* Used for Spansion flashes only. */
>>   #define SPINOR_OP_BRWR        0x17    /* Bank register write */
>>   #define SPINOR_OP_CLSR        0x30    /* Clear status register 1 */
>> +#define SPINOR_OP_RDAR        0x65    /* Read Any Register */
>>     /* Used for Micron flashes only. */
>>   #define SPINOR_OP_RD_EVCR      0x65    /* Read EVCR register */
>> @@ -150,6 +151,10 @@
>>   #define SR2_QUAD_EN_BIT1    BIT(1)
>>   #define SR2_QUAD_EN_BIT7    BIT(7)
>>   +/* Used for Spansion flashes RDAR command only. */
>> +#define SPINOR_REG_CR3V        0x800004
>> +#define CR3V_02H_V        BIT(4)    /* Page Buffer Wrap */
>> +
>>   /* Supported SPI protocols */
>>   #define SNOR_PROTO_INST_MASK    GENMASK(23, 16)
>>   #define SNOR_PROTO_INST_SHIFT    16
>>
> 
> 
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/

-- 
Regards
Vignesh
