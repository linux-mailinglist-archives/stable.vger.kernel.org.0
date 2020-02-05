Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0F2715351A
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 17:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgBEQR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 11:17:56 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2380 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726359AbgBEQR4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 11:17:56 -0500
Received: from LHREML713-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id DBF8AB5E2CA993B7F2BB;
        Wed,  5 Feb 2020 16:17:53 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML713-CAH.china.huawei.com (10.201.108.36) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 5 Feb 2020 16:17:53 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 5 Feb 2020
 16:17:53 +0000
Subject: Re: [PATCH] mtd: spi-nor: Fixup page size for S25FS-S
To:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        <linux-mtd@lists.infradead.org>
CC:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        Richard Weinberger <richard@nod.at>,
        Boris Brezillon <bbrezillon@kernel.org>,
        <stable@vger.kernel.org>, Marek Vasut <marek.vasut@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
References: <20200114134704.4708-1-alexander.sverdlin@nokia.com>
 <2759888e-0a88-cf76-d2c0-3f0f5141f8cd@huawei.com>
 <b376b949-67b1-b3cf-38cd-9f5e5622057d@nokia.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <00dcf18f-2787-c933-4c4d-ce5353686d5d@huawei.com>
Date:   Wed, 5 Feb 2020 16:17:52 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <b376b949-67b1-b3cf-38cd-9f5e5622057d@nokia.com>
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

On 05/02/2020 16:03, Alexander Sverdlin wrote:
> Hello!
> 
> On 05/02/2020 16:32, John Garry wrote:
>> On 14/01/2020 13:47, Alexander X Sverdlin wrote:
>>> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
>>>
>>> Spansion S25FS-S family has an issue in Basic Flash Parameter Table:
>>> DWORD-11 bits 7-4 specify write page size 512 bytes. In reality this
>>> is configurable in the non-volatile CR3NV register and even factory
>>> default configuration is "wrap at 256 bytes". So blind relying on BFPT
>>> breaks write operation on these Flashes.
>>>
>>> All this story is vendor-specific, so add the corresponding fixup hook
>>> which first restores the safe page size of 256 bytes from
>>> struct flash_info but checks is more performant 512 bytes configuration
>>> is active and adjusts the page_size accordingly.
> 
> [...]
> 
>> One of my dev boards has part s25fl129p1, so I would like to try this patch. However it does not apply. Any chance you could resend?
> 

Actually I was testing against linux-next, which I assumed included the 
Maintainers dev tree.

> It was based on spi-nor/next branch of git://git.infradead.org/l2-mtd.git and as I can
> see, 

 From a quick check, that branch does not seem to have seen anything new 
since March 2019.

this branch is unchanged from the last patch submission.

According to the MAINTAINERS file, we have:

SPI NOR SUBSYSTEM
M: Tudor Ambarus <tudor.ambarus@microchip.com>
L: linux-mtd@lists.infradead.org
W: http://www.linux-mtd.infradead.org/
Q: http://patchwork.ozlabs.org/project/linux-mtd/list/
T: git git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git 
spi-nor/next
S: Maintained
F: drivers/mtd/spi-nor/
F: include/linux/mtd/spi-nor.h

Last patch on the spi-nor/next branch is 16th Jan, 2020.

Cheers,
John

> I can re-send if one of the maintainers confirms this wasn't the correct branch
> to base on.
> 
> [...]
> 
>>> Cc: stable@vger.kernel.org
>>> Fixes: f384b352c ("mtd: spi-nor: parse Serial Flash Discoverable Parameters (SFDP) tables")
>>> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
>>> ---
>>>    drivers/mtd/spi-nor/spi-nor.c | 39 +++++++++++++++++++++++++++++++++++++--
>>>    include/linux/mtd/spi-nor.h   |  5 +++++
>>>    2 files changed, 42 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
>>> index 73172d7..18f8705 100644
>>> --- a/drivers/mtd/spi-nor/spi-nor.c
>>> +++ b/drivers/mtd/spi-nor/spi-nor.c
>>> @@ -1711,6 +1711,39 @@ static struct spi_nor_fixups mx25l25635_fixups = {
>>>        .post_bfpt = mx25l25635_post_bfpt_fixups,
>>>    };
>>>    +/* Spansion S25FS-S SFDP workarounds */
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
>>> +     * But is the chip configured for more performant 512 bytes write page
>>> +     * size?
>>> +     */
>>> +    read_opcode = nor->read_opcode;
>>> +
>>> +    nor->read_opcode = SPINOR_OP_RDAR;
>>> +    ret = nor->read(nor, SPINOR_REG_CR3V, 1, &buf);
>>
>> struct spi_nor has no member .read AFAICS.
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
>>> @@ -1903,7 +1936,8 @@ static const struct flash_info spi_nor_ids[] = {
>>>                SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>>        { "s25fl128s1", INFO6(0x012018, 0x4d0180, 64 * 1024, 256,
>>>                SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>> -    { "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, USE_CLSR) },
>>> +    { "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, USE_CLSR)
>>> +            .fixups = &s25fs_s_fixups, },
>>>        { "s25fl256s1", INFO(0x010219, 0x4d01,  64 * 1024, 512, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>>        { "s25fl512s",  INFO6(0x010220, 0x4d0080, 256 * 1024, 256,
>>>                SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
>>> @@ -1913,7 +1947,8 @@ static const struct flash_info spi_nor_ids[] = {
>>>        { "s25sl12800", INFO(0x012018, 0x0300, 256 * 1024,  64, 0) },
>>>        { "s25sl12801", INFO(0x012018, 0x0301,  64 * 1024, 256, 0) },
>>>        { "s25fl129p0", INFO(0x012018, 0x4d00, 256 * 1024,  64, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>> -    { "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>>> +    { "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR)
>>> +            .fixups = &s25fs_s_fixups, },
>>>        { "s25sl004a",  INFO(0x010212,      0,  64 * 1024,   8, 0) },
>>>        { "s25sl008a",  INFO(0x010213,      0,  64 * 1024,  16, 0) },
>>>        { "s25sl016a",  INFO(0x010214,      0,  64 * 1024,  32, 0) },
>>> diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h
>>> index b3d360b..222eee9 100644
>>> --- a/include/linux/mtd/spi-nor.h
>>> +++ b/include/linux/mtd/spi-nor.h
>>> @@ -114,6 +114,7 @@
>>>    /* Used for Spansion flashes only. */
>>>    #define SPINOR_OP_BRWR        0x17    /* Bank register write */
>>>    #define SPINOR_OP_CLSR        0x30    /* Clear status register 1 */
>>> +#define SPINOR_OP_RDAR        0x65    /* Read Any Register */
>>>      /* Used for Micron flashes only. */
>>>    #define SPINOR_OP_RD_EVCR      0x65    /* Read EVCR register */
>>> @@ -149,6 +150,10 @@
>>>    /* Status Register 2 bits. */
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
> 

