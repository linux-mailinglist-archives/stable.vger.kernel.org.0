Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB6415433C
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 12:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgBFLjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 06:39:03 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2386 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726687AbgBFLjD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 06:39:03 -0500
Received: from LHREML711-CAH.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 5B506B2E9A5132123161;
        Thu,  6 Feb 2020 11:39:01 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML711-CAH.china.huawei.com (10.201.108.34) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 6 Feb 2020 11:39:01 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 6 Feb 2020
 11:39:00 +0000
Subject: Re: [PATCH v2] mtd: spi-nor: Fixup page size for S25FS-S
To:     Alexander A Sverdlin <alexander.sverdlin@nokia.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        Richard Weinberger <richard@nod.at>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Marek Vasut" <marek.vasut@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Boris Brezillon <bbrezillon@kernel.org>
References: <20200205165736.4964-1-alexander.sverdlin@nokia.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <62a35797-4e78-f6b0-de86-50004bc636ca@huawei.com>
Date:   Thu, 6 Feb 2020 11:38:59 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200205165736.4964-1-alexander.sverdlin@nokia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml720-chm.china.huawei.com (10.201.108.71) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/02/2020 16:57, Alexander A Sverdlin wrote:
> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> 
> Spansion S25FS-S family has an issue in Basic Flash Parameter Table:
> DWORD-11 bits 7-4 specify write page size 512 bytes. In reality this
> is configurable in the non-volatile CR3NV register and even factory
> default configuration is "wrap at 256 bytes". So blind relying on BFPT
> breaks write operation on these Flashes.
> 
> All this story is vendor-specific, so add the corresponding fixup hook
> which first restores the safe page size of 256 bytes from
> struct flash_info but checks is more performant 512 bytes configuration
> is active and adjusts the page_size accordingly.
> 
> Cc: stable@vger.kernel.org
> Fixes: f384b352c ("mtd: spi-nor: parse Serial Flash Discoverable Parameters (SFDP) tables")
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> ---
> Changelog:
> v2: Thankfully rebased on the hint from John Garry
> 
>   drivers/mtd/spi-nor/spi-nor.c | 39 +++++++++++++++++++++++++++++++++++++--
>   include/linux/mtd/spi-nor.h   |  5 +++++
>   2 files changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
> index 928a660..c0a5041 100644
> --- a/drivers/mtd/spi-nor/spi-nor.c
> +++ b/drivers/mtd/spi-nor/spi-nor.c
> @@ -2302,6 +2302,39 @@ static struct spi_nor_fixups gd25q256_fixups = {
>   	.default_init = gd25q256_default_init,
>   };
>   

Hi Alexander,

Thanks for the quick turnaround. But, sorry to say, this does not look 
right:

> +/* Spansion S25FS-S SFDP workarounds */
> +static int s25fs_s_post_bfpt_fixups(struct spi_nor *nor,
> +	const struct sfdp_parameter_header *bfpt_header,
> +	const struct sfdp_bfpt *bfpt,
> +	struct spi_nor_flash_parameter *params)
> +{
> +	const struct flash_info *info = nor->info;
> +	u8 read_opcode, buf;
> +	int ret;
> +
> +	/* Default is safe */
> +	params->page_size = info->page_size;
> +
> +	/*
> +	 * But is the chip configured for more performant 512 bytes write page
> +	 * size?
> +	 */
> +	read_opcode = nor->read_opcode;
> +
> +	nor->read_opcode = SPINOR_OP_RDAR;
> +	ret = nor->read(nor, SPINOR_REG_CR3V, 1, &buf);

The read method is now gone from struct spi_nor, moved into 
spi_nor.controller_ops. And we also support spi_mem ops now.

In fact, I find that the SFDP signature is not correct for me for this 
part, so I need to check that first...

Thanks,
John

> +	if (!ret && (buf & CR3V_02H_V))
> +		params->page_size = 512;
> +
> +	nor->read_opcode = read_opcode;
> +
> +	return ret;
> +}
> +
> +static const struct spi_nor_fixups s25fs_s_fixups = {
> +	.post_bfpt = s25fs_s_post_bfpt_fixups,
> +};
> +
>   /* NOTE: double check command sets and memory organization when you add
>    * more nor chips.  This current list focusses on newer chips, which
>    * have been converging on command sets which including JEDEC ID.
> @@ -2536,7 +2569,8 @@ static const struct flash_info spi_nor_ids[] = {
>   			SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>   	{ "s25fl128s1", INFO6(0x012018, 0x4d0180, 64 * 1024, 256,
>   			SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
> -	{ "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, USE_CLSR) },
> +	{ "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, USE_CLSR)
> +			.fixups = &s25fs_s_fixups, },
>   	{ "s25fl256s1", INFO(0x010219, 0x4d01,  64 * 1024, 512, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>   	{ "s25fl512s",  INFO6(0x010220, 0x4d0080, 256 * 1024, 256,
>   			SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
> @@ -2546,7 +2580,8 @@ static const struct flash_info spi_nor_ids[] = {
>   	{ "s25sl12800", INFO(0x012018, 0x0300, 256 * 1024,  64, 0) },
>   	{ "s25sl12801", INFO(0x012018, 0x0301,  64 * 1024, 256, 0) },
>   	{ "s25fl129p0", INFO(0x012018, 0x4d00, 256 * 1024,  64, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
> -	{ "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
> +	{ "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR)
> +			.fixups = &s25fs_s_fixups, },
>   	{ "s25sl004a",  INFO(0x010212,      0,  64 * 1024,   8, 0) },
>   	{ "s25sl008a",  INFO(0x010213,      0,  64 * 1024,  16, 0) },
>   	{ "s25sl016a",  INFO(0x010214,      0,  64 * 1024,  32, 0) },
> diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h
> index 5abd91c..7ce3e79 100644
> --- a/include/linux/mtd/spi-nor.h
> +++ b/include/linux/mtd/spi-nor.h
> @@ -116,6 +116,7 @@
>   /* Used for Spansion flashes only. */
>   #define SPINOR_OP_BRWR		0x17	/* Bank register write */
>   #define SPINOR_OP_CLSR		0x30	/* Clear status register 1 */
> +#define SPINOR_OP_RDAR		0x65	/* Read Any Register */
>   
>   /* Used for Micron flashes only. */
>   #define SPINOR_OP_RD_EVCR      0x65    /* Read EVCR register */
> @@ -150,6 +151,10 @@
>   #define SR2_QUAD_EN_BIT1	BIT(1)
>   #define SR2_QUAD_EN_BIT7	BIT(7)
>   
> +/* Used for Spansion flashes RDAR command only. */
> +#define SPINOR_REG_CR3V		0x800004
> +#define CR3V_02H_V		BIT(4)	/* Page Buffer Wrap */
> +
>   /* Supported SPI protocols */
>   #define SNOR_PROTO_INST_MASK	GENMASK(23, 16)
>   #define SNOR_PROTO_INST_SHIFT	16
> 

