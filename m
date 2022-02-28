Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A3A4C70C8
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 16:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbiB1PgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 10:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiB1PgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 10:36:14 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BAE69CD1
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 07:35:35 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 21SFZOO4073276;
        Mon, 28 Feb 2022 09:35:24 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1646062524;
        bh=jBRTdblN1RAmc+4Nczn8RlsQ7gDEaz21mwBipojhJ7Q=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=PS/cMYq5au6dzgrnCq4DJyWTyJw0LRODiYXFnuyk1tSoObC4V/P4PknzYuJYjaYCt
         qgwOUJwLCRRl800D+sUMXZchtSlSsAkG081dqAhA54J0f5RYU0011rSwskFCCuWISo
         9GTTgNw9KYtPQW38wpDqPfaReXzqGTRl+plHLaOQ=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 21SFZOPm081253
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Feb 2022 09:35:24 -0600
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 28
 Feb 2022 09:35:23 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 28 Feb 2022 09:35:23 -0600
Received: from [10.250.233.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 21SFZLxK077386;
        Mon, 28 Feb 2022 09:35:22 -0600
Message-ID: <e9cb486d-b775-896c-93b5-3a1154bd9f3e@ti.com>
Date:   Mon, 28 Feb 2022 21:04:52 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] mtd: cfi_cmdset_0002: Use chip_ready() for write on
 S29GL064N
Content-Language: en-US
To:     Tokunori Ikegami <ikegami.t@gmail.com>
CC:     <linux-mtd@lists.infradead.org>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        <stable@vger.kernel.org>
References: <20220214182011.8493-1-ikegami.t@gmail.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
In-Reply-To: <20220214182011.8493-1-ikegami.t@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 14/02/22 11:50 pm, Tokunori Ikegami wrote:
> The regression issue has been caused on S29GL064N and reported it.
> Also the change mentioned is to use chip_good() for buffered write.
> So disable the change on S29GL064N and use chip_ready() as before.
> 
> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Cc: linux-mtd@lists.infradead.org
> Cc: stable@vger.kernel.org
> ---
Thanks for working on the fix.

Please CC maintainers from

./scripts/get_maintainer.pl -f drivers/mtd/chips/cfi_cmdset_0002.c

Else, patch would not get attention in time.

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

Can we use per device private flag? Else this wont work on systems with
multiple CFI flashes with one of them being S29GL064N_MN12.

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
Unrelated change?

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

Why even read oldd and curd if !expected ?

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
