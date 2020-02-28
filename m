Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3F6172F09
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 04:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730540AbgB1DBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 22:01:14 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:34306 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730445AbgB1DBO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 22:01:14 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F062346E2200175944E4;
        Fri, 28 Feb 2020 11:01:11 +0800 (CST)
Received: from [127.0.0.1] (10.74.219.194) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Fri, 28 Feb 2020
 11:01:05 +0800
Subject: Re: [PATCH] mtd: spi-nor: Fixup page size and map selection for
 S25FS-S
To:     Alexander A Sverdlin <alexander.sverdlin@nokia.com>,
        <linux-mtd@lists.infradead.org>
References: <20200227123657.26030-1-alexander.sverdlin@nokia.com>
CC:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        Richard Weinberger <richard@nod.at>,
        John Garry <john.garry@huawei.com>, <stable@vger.kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "Boris Brezillon" <bbrezillon@kernel.org>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <18cdef63-75e3-97c3-2a22-4969d4997af9@hisilicon.com>
Date:   Fri, 28 Feb 2020 11:01:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20200227123657.26030-1-alexander.sverdlin@nokia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.219.194]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi，

在 2020/2/27 20:36, Alexander A Sverdlin 写道:
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
> To read CR3V RDAR command is required which in turn requires addr width
> and read latency to be configured, which was not the case before. Setting
> these parameters is also later required for sector map selection, because:
>
> JESD216 allows "variable address length" and "variable latency" in
> Configuration Detection Command Descriptors, in other words "as-is".
> And they are still unset during Sector Map Parameter Table parsing,
> which led to "map_id" determined erroneously as 0 for, e.g. S25FS128S.
>
> New warning is added to catch the potential misconfiguration with other
> chips.
>
> Link: http://lists.infradead.org/pipermail/linux-mtd/2020-February/093950.html
> Link: http://lists.infradead.org/pipermail/linux-mtd/2018-December/085956.html
> Fixes: f384b352cbf0 ("mtd: spi-nor: parse Serial Flash Discoverable Parameters (SFDP) tables")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> ---
> Yes, this is a combination of two previously sent patches as it turned out,
> width/dummy quirk is necessary even earlier, during post_bfpt fixup.
>
>   drivers/mtd/spi-nor/spi-nor.c | 132 +++++++++++++++++++++++++++++++++++++++++-
>   include/linux/mtd/spi-nor.h   |  11 ++++
>   2 files changed, 141 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
> index 1224247..1d0e2ef 100644
> --- a/drivers/mtd/spi-nor/spi-nor.c
> +++ b/drivers/mtd/spi-nor/spi-nor.c
> @@ -2326,6 +2326,122 @@ static struct spi_nor_fixups gd25q256_fixups = {
>   	.default_init = gd25q256_default_init,
>   };
>   
> +/*
> + * Return true if it was possible to read something known and non-zero with
> + * the probed parameters. struct spi_nor is updated in this case as well.
> + */
> +static bool spi_nor_probe_width_and_dummy(struct spi_nor *nor, u8 width,
> +					  u8 dummy)
> +{
> +	u8 read_opcode = nor->read_opcode;
> +	u8 savedw = nor->addr_width;
> +	u8 savedd = nor->read_dummy;
> +	int ret;
> +	u8 buf;
> +
> +	nor->addr_width = width;
> +	nor->read_dummy = dummy;
> +	nor->read_opcode = SPINOR_OP_RDAR;
> +	ret = spi_nor_read_data(nor, SPINOR_REG_CR2V, 1, &buf);
> +	nor->read_opcode = read_opcode;
> +
> +	if (ret == 1 && (CR2V_RL(buf) == dummy) &&
> +	    (!!(buf & CR2V_AL) == (width == 4)))
> +		return true;
> +
> +	nor->addr_width = savedw;
> +	nor->read_dummy = savedd;
> +
> +	return false;
> +}
> +
> +/*
> + * JESD216 allows to omit particular address length or latency specification in
> + * the header and at this point they are still unset, so we need some
> + * heuristics. One example is S25FS128S.
> + *
> + * It was observed that RDAR with incorrect parameters result in all-zeroes or
> + * all-ones reads. That's why probed dummy is limited to 14 and loops are built
> + * in a way to probe width 3 and 0 dummy bits last to avoid false-positive
> + * (refer to CR2 mapping). 8 dummy bits are probed on the first iteration.
> + */
> +static void spi_nor_fixup_width_and_dummy(struct spi_nor *nor)
> +{
> +	u8 width_min = 3;
> +	u8 width_max = 4;
> +	u8 dummy_min = 0;
> +	u8 dummy_max = 14;
> +	u8 w, d;
> +
> +	if (nor->addr_width && nor->read_dummy)
> +		return;
> +
> +	if (nor->addr_width) {
> +		width_min = nor->addr_width;
> +		width_max = nor->addr_width;
> +	}
> +	if (nor->read_dummy) {
> +		dummy_min = nor->read_dummy;
> +		dummy_max = nor->read_dummy;
> +	}
> +
> +	for (w = width_min; w <= width_max; ++w)
> +		for (d = 8; d <= dummy_max; ++d)
> +			if (d >= dummy_min &&
> +			    spi_nor_probe_width_and_dummy(nor, w, d))
> +				return;
> +	for (w = width_max; w >= width_min; --w)
> +		for (d = 7; d >= dummy_min; --d)
> +			if (d <= dummy_max &&
> +			    spi_nor_probe_width_and_dummy(nor, w, d))
> +				return;
> +}
> +
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
> +	/*
> +	 * RDAR command below requires nor->addr_width and nor->dummy correctly
> +	 * set. spi_nor_get_map_in_use() later requires them as well.
> +	 */
> +	spi_nor_fixup_width_and_dummy(nor);
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
> +	ret = spi_nor_read_data(nor, SPINOR_REG_CR3V, 1, &buf);
> +	nor->read_opcode = read_opcode;
> +
> +	switch (ret) {
> +	case 0:
> +		return -EIO;
> +	case 1:
> +		if (buf & CR3V_02H_V)
> +			params->page_size = 512;
> +		return 0;
> +	}
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
> @@ -2560,7 +2676,8 @@ static const struct flash_info spi_nor_ids[] = {
>   			SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>   	{ "s25fl128s1", INFO6(0x012018, 0x4d0180, 64 * 1024, 256,
>   			SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
> -	{ "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, USE_CLSR) },
> +	{ "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, USE_CLSR)
> +			.fixups = &s25fs_s_fixups, },
>   	{ "s25fl256s1", INFO(0x010219, 0x4d01,  64 * 1024, 512, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
>   	{ "s25fl512s",  INFO6(0x010220, 0x4d0080, 256 * 1024, 256,
>   			SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
> @@ -2570,7 +2687,8 @@ static const struct flash_info spi_nor_ids[] = {
>   	{ "s25sl12800", INFO(0x012018, 0x0300, 256 * 1024,  64, 0) },
>   	{ "s25sl12801", INFO(0x012018, 0x0301,  64 * 1024, 256, 0) },
>   	{ "s25fl129p0", INFO(0x012018, 0x4d00, 256 * 1024,  64, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
> -	{ "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR) },
> +	{ "s25fl129p1", INFO(0x012018, 0x4d01,  64 * 1024, 256, SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ | USE_CLSR)
> +			.fixups = &s25fs_s_fixups, },

It seems SFDP is not supported on s25fl129p (you can check it on 
https://www.cypress.com/file/400586/download), so is it necessary to add 
this for this type flash?


>   	{ "s25sl004a",  INFO(0x010212,      0,  64 * 1024,   8, 0) },
>   	{ "s25sl008a",  INFO(0x010213,      0,  64 * 1024,  16, 0) },
>   	{ "s25sl016a",  INFO(0x010214,      0,  64 * 1024,  32, 0) },
> @@ -3897,6 +4015,16 @@ static const u32 *spi_nor_get_map_in_use(struct spi_nor *nor, const u32 *smpt,
>   		nor->read_opcode = SMPT_CMD_OPCODE(smpt[i]);
>   		addr = smpt[i + 1];
>   
> +		switch (nor->read_opcode) {
> +		case SPINOR_OP_RDAR:
> +			if (nor->read_dummy && nor->addr_width)
> +				break;
> +			dev_warn(nor->dev, "OP 0x%02x width %u dummy %u\n",
> +				 nor->read_opcode, nor->addr_width,
> +				 nor->read_dummy);
> +			break;
> +		}
> +
>   		err = spi_nor_read_raw(nor, addr, 1, buf);
>   		if (err) {
>   			ret = ERR_PTR(err);
> diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h
> index de90724..1e21592 100644
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
> @@ -152,6 +153,16 @@
>   #define SR2_QUAD_EN_BIT1	BIT(1)
>   #define SR2_QUAD_EN_BIT7	BIT(7)
>   
> +/* Used for Spansion flashes RDAR command only. */
> +#define SPINOR_REG_CR2V		0x800003
> +#define CR2V_AL			BIT(7)	/* Address Length */
> +/* Read Latency */
> +#define CR2V_RL_MASK		GENMASK(3, 0)
> +#define CR2V_RL(_nbits)		((_nbits) & CR2V_RL_MASK)
> +
> +#define SPINOR_REG_CR3V		0x800004
> +#define CR3V_02H_V		BIT(4)	/* Page Buffer Wrap */
> +
>   /* Supported SPI protocols */
>   #define SNOR_PROTO_INST_MASK	GENMASK(23, 16)
>   #define SNOR_PROTO_INST_SHIFT	16


