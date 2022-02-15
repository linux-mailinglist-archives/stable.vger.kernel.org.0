Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0C74B66F1
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 10:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbiBOJFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 04:05:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235600AbiBOJFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 04:05:44 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEF9115973
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 01:05:33 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1nJtm5-0002SP-HO; Tue, 15 Feb 2022 10:05:29 +0100
Message-ID: <f5ccdd13-2ec2-1c1e-be98-d13930fd87cb@pengutronix.de>
Date:   Tue, 15 Feb 2022 10:05:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: Re: [PATCH] mtd: cfi_cmdset_0002: Use chip_ready() for write on
 S29GL064N
To:     Tokunori Ikegami <ikegami.t@gmail.com>, vigneshr@ti.com
Cc:     linux-mtd@lists.infradead.org, stable@vger.kernel.org
References: <20220214182011.8493-1-ikegami.t@gmail.com>
Content-Language: en-US
In-Reply-To: <20220214182011.8493-1-ikegami.t@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14.02.22 19:20, Tokunori Ikegami wrote:
> The regression issue has been caused on S29GL064N and reported it.
> Also the change mentioned is to use chip_good() for buffered write.
> So disable the change on S29GL064N and use chip_ready() as before.
> 
> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Cc: linux-mtd@lists.infradead.org
> Cc: stable@vger.kernel.org

Link: https://lore.kernel.org/linux-mtd/cedb1604-e024-2738-5b33-15703a653803@gmail.com/

I think a reference to the original thread may be useful.

Thanks for the fix!
Ahmad

> ---
>  drivers/mtd/chips/cfi_cmdset_0002.c | 105 ++++++++++++++++------------
>  1 file changed, 59 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
> index a761134fd3be..a0dfc8ace899 100644
> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
> @@ -48,6 +48,7 @@
>  #define SST49LF040B		0x0050
>  #define SST49LF008A		0x005a
>  #define AT49BV6416		0x00d6
> +#define S29GL064N_MN12		0x0c01
>  
>  /*
>   * Status Register bit description. Used by flash devices that don't
> @@ -109,6 +110,8 @@ static struct mtd_chip_driver cfi_amdstd_chipdrv = {
>  	.module		= THIS_MODULE
>  };
>  
> +static bool use_chip_good_for_write;
> +
>  /*
>   * Use status register to poll for Erase/write completion when DQ is not
>   * supported. This is indicated by Bit[1:0] of SoftwareFeatures field in
> @@ -283,6 +286,17 @@ static void fixup_use_write_buffers(struct mtd_info *mtd)
>  }
>  #endif /* !FORCE_WORD_WRITE */
>  
> +static void fixup_use_chip_good_for_write(struct mtd_info *mtd)
> +{
> +	struct map_info *map = mtd->priv;
> +	struct cfi_private *cfi = map->fldrv_priv;
> +
> +	if (cfi->mfr == CFI_MFR_AMD && cfi->id == S29GL064N_MN12)
> +		return;
> +
> +	use_chip_good_for_write = true;
> +}
> +
>  /* Atmel chips don't use the same PRI format as AMD chips */
>  static void fixup_convert_atmel_pri(struct mtd_info *mtd)
>  {
> @@ -462,7 +476,7 @@ static struct cfi_fixup cfi_fixup_table[] = {
>  	{ CFI_MFR_AMD, 0x0056, fixup_use_secsi },
>  	{ CFI_MFR_AMD, 0x005C, fixup_use_secsi },
>  	{ CFI_MFR_AMD, 0x005F, fixup_use_secsi },
> -	{ CFI_MFR_AMD, 0x0c01, fixup_s29gl064n_sectors },
> +	{ CFI_MFR_AMD, S29GL064N_MN12, fixup_s29gl064n_sectors },
>  	{ CFI_MFR_AMD, 0x1301, fixup_s29gl064n_sectors },
>  	{ CFI_MFR_AMD, 0x1a00, fixup_s29gl032n_sectors },
>  	{ CFI_MFR_AMD, 0x1a01, fixup_s29gl032n_sectors },
> @@ -474,6 +488,7 @@ static struct cfi_fixup cfi_fixup_table[] = {
>  #if !FORCE_WORD_WRITE
>  	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_use_write_buffers },
>  #endif
> +	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_use_chip_good_for_write },
>  	{ 0, 0, NULL }
>  };
>  static struct cfi_fixup jedec_fixup_table[] = {
> @@ -801,42 +816,61 @@ static struct mtd_info *cfi_amdstd_setup(struct mtd_info *mtd)
>  	return NULL;
>  }
>  
> -/*
> - * Return true if the chip is ready.
> - *
> - * Ready is one of: read mode, query mode, erase-suspend-read mode (in any
> - * non-suspended sector) and is indicated by no toggle bits toggling.
> - *
> - * Note that anything more complicated than checking if no bits are toggling
> - * (including checking DQ5 for an error status) is tricky to get working
> - * correctly and is therefore not done	(particularly with interleaved chips
> - * as each chip must be checked independently of the others).
> - */
> -static int __xipram chip_ready(struct map_info *map, struct flchip *chip,
> -			       unsigned long addr)
> +static int __xipram chip_check(struct map_info *map, struct flchip *chip,
> +			       unsigned long addr, map_word *expected)
>  {
>  	struct cfi_private *cfi = map->fldrv_priv;
> -	map_word d, t;
> +	map_word oldd, curd;
> +	int ret;
>  
>  	if (cfi_use_status_reg(cfi)) {
>  		map_word ready = CMD(CFI_SR_DRB);
> +
>  		/*
>  		 * For chips that support status register, check device
>  		 * ready bit
>  		 */
>  		cfi_send_gen_cmd(0x70, cfi->addr_unlock1, chip->start, map, cfi,
>  				 cfi->device_type, NULL);
> -		d = map_read(map, addr);
> +		curd = map_read(map, addr);
>  
> -		return map_word_andequal(map, d, ready, ready);
> +		return map_word_andequal(map, curd, ready, ready);
>  	}
>  
> -	d = map_read(map, addr);
> -	t = map_read(map, addr);
> +	oldd = map_read(map, addr);
> +	curd = map_read(map, addr);
> +
> +	ret = map_word_equal(map, oldd, curd);
> +
> +	if (!ret || !expected)
> +		return ret;
> +
> +	return map_word_equal(map, curd, *expected);
> +}
> +
> +static int __xipram chip_good_for_write(struct map_info *map,
> +					struct flchip *chip, unsigned long addr,
> +					map_word expected)
> +{
> +	if (use_chip_good_for_write)
> +		return chip_check(map, chip, addr, &expected);
>  
> -	return map_word_equal(map, d, t);
> +	return chip_check(map, chip, addr, NULL);
>  }
>  
> +/*
> + * Return true if the chip is ready.
> + *
> + * Ready is one of: read mode, query mode, erase-suspend-read mode (in any
> + * non-suspended sector) and is indicated by no toggle bits toggling.
> + *
> + * Note that anything more complicated than checking if no bits are toggling
> + * (including checking DQ5 for an error status) is tricky to get working
> + * correctly and is therefore not done	(particularly with interleaved chips
> + * as each chip must be checked independently of the others).
> + */
> +#define chip_ready(map, chip, addr) chip_check(map, chip, addr, NULL)
> +
>  /*
>   * Return true if the chip is ready and has the correct value.
>   *
> @@ -855,28 +889,7 @@ static int __xipram chip_ready(struct map_info *map, struct flchip *chip,
>  static int __xipram chip_good(struct map_info *map, struct flchip *chip,
>  			      unsigned long addr, map_word expected)
>  {
> -	struct cfi_private *cfi = map->fldrv_priv;
> -	map_word oldd, curd;
> -
> -	if (cfi_use_status_reg(cfi)) {
> -		map_word ready = CMD(CFI_SR_DRB);
> -
> -		/*
> -		 * For chips that support status register, check device
> -		 * ready bit
> -		 */
> -		cfi_send_gen_cmd(0x70, cfi->addr_unlock1, chip->start, map, cfi,
> -				 cfi->device_type, NULL);
> -		curd = map_read(map, addr);
> -
> -		return map_word_andequal(map, curd, ready, ready);
> -	}
> -
> -	oldd = map_read(map, addr);
> -	curd = map_read(map, addr);
> -
> -	return	map_word_equal(map, oldd, curd) &&
> -		map_word_equal(map, curd, expected);
> +	return chip_check(map, chip, addr, &expected);
>  }
>  
>  static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr, int mode)
> @@ -1699,7 +1712,7 @@ static int __xipram do_write_oneword_once(struct map_info *map,
>  		 * "chip_good" to avoid the failure due to scheduling.
>  		 */
>  		if (time_after(jiffies, timeo) &&
> -		    !chip_good(map, chip, adr, datum)) {
> +		    !chip_good_for_write(map, chip, adr, datum)) {
>  			xip_enable(map, chip, adr);
>  			printk(KERN_WARNING "MTD %s(): software timeout\n", __func__);
>  			xip_disable(map, chip, adr);
> @@ -1707,7 +1720,7 @@ static int __xipram do_write_oneword_once(struct map_info *map,
>  			break;
>  		}
>  
> -		if (chip_good(map, chip, adr, datum)) {
> +		if (chip_good_for_write(map, chip, adr, datum)) {
>  			if (cfi_check_err_status(map, chip, adr))
>  				ret = -EIO;
>  			break;
> @@ -1979,14 +1992,14 @@ static int __xipram do_write_buffer_wait(struct map_info *map,
>  		 * "chip_good" to avoid the failure due to scheduling.
>  		 */
>  		if (time_after(jiffies, timeo) &&
> -		    !chip_good(map, chip, adr, datum)) {
> +		    !chip_good_for_write(map, chip, adr, datum)) {
>  			pr_err("MTD %s(): software timeout, address:0x%.8lx.\n",
>  			       __func__, adr);
>  			ret = -EIO;
>  			break;
>  		}
>  
> -		if (chip_good(map, chip, adr, datum)) {
> +		if (chip_good_for_write(map, chip, adr, datum)) {
>  			if (cfi_check_err_status(map, chip, adr))
>  				ret = -EIO;
>  			break;


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
