Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA32A4DB717
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 18:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350447AbiCPR0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 13:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiCPR0v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 13:26:51 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8ABF9FE5
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 10:25:36 -0700 (PDT)
Received: from relay12.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::232])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 4B99ECF7B9
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 17:15:24 +0000 (UTC)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 300CA200005;
        Wed, 16 Mar 2022 17:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647450920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G6gLMMNOG4h/Lqkhq9E4+xt9ZMxIqvlsfo82rAng1Io=;
        b=Xxo5i2+RXvU5DTAm9d98tXIa8WbrZh2KcglxmLlAdAOsl9CxYHDQigOVyqiR2Vi69/PUg2
        qAGZm9LI++GkLoskozLCW799RaWubMK4GviLlfiArHlqUCTvctUnCJHRR26/y+kw6oLPD7
        3D1VT8SrVQUSUFt7R70+DgjPpZZjabqB32m+wet+VMYTn54IFr6eZSyGUIC49ObkGK4er9
        QNGO2JEK1wJ78Dj4vfJoQfNaAonlABD8sZhcb62bd82g1QBYgBDU3130Ji29WBQSXUMg4E
        cRuO322RGAz1k6BgwCNIZuCpiqEW8edgZHYnbIKoB+kAhLRtuFMCZ/frFw9DmQ==
Date:   Wed, 16 Mar 2022 18:15:19 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Tokunori Ikegami <ikegami.t@gmail.com>
Cc:     linux-mtd@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mtd: cfi_cmdset_0002: Move and rename
 chip_check/chip_ready/chip_good_for_write
Message-ID: <20220316181519.0ec5bc97@xps13>
In-Reply-To: <20220316155455.162362-2-ikegami.t@gmail.com>
References: <20220316155455.162362-1-ikegami.t@gmail.com>
        <20220316155455.162362-2-ikegami.t@gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tokunori,

ikegami.t@gmail.com wrote on Thu, 17 Mar 2022 00:54:53 +0900:

> This is a preparation patch for the functional change in preparation to a=
 change
> expected to fix the buffered writes on S29GL064N.

This is a preparation patch for the S29GL064N buffer writes fix. There
is no functional change.

>=20
> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check c=
orrect value")
> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/mtd/chips/cfi_cmdset_0002.c | 77 ++++++++++++-----------------
>  1 file changed, 32 insertions(+), 45 deletions(-)
>=20
> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_=
cmdset_0002.c
> index a761134fd3be..e68ddf0f7fc0 100644
> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
> @@ -801,22 +801,12 @@ static struct mtd_info *cfi_amdstd_setup(struct mtd=
_info *mtd)
>  	return NULL;
>  }
> =20
> -/*
> - * Return true if the chip is ready.
> - *
> - * Ready is one of: read mode, query mode, erase-suspend-read mode (in a=
ny
> - * non-suspended sector) and is indicated by no toggle bits toggling.
> - *
> - * Note that anything more complicated than checking if no bits are togg=
ling
> - * (including checking DQ5 for an error status) is tricky to get working
> - * correctly and is therefore not done	(particularly with interleaved ch=
ips
> - * as each chip must be checked independently of the others).
> - */
> -static int __xipram chip_ready(struct map_info *map, struct flchip *chip,
> -			       unsigned long addr)
> +static int __xipram chip_check(struct map_info *map, struct flchip *chip,
> +			       unsigned long addr, map_word *expected)
>  {
>  	struct cfi_private *cfi =3D map->fldrv_priv;
> -	map_word d, t;
> +	map_word oldd, curd;
> +	int ret;
> =20
>  	if (cfi_use_status_reg(cfi)) {
>  		map_word ready =3D CMD(CFI_SR_DRB);
> @@ -826,17 +816,35 @@ static int __xipram chip_ready(struct map_info *map=
, struct flchip *chip,
>  		 */
>  		cfi_send_gen_cmd(0x70, cfi->addr_unlock1, chip->start, map, cfi,
>  				 cfi->device_type, NULL);
> -		d =3D map_read(map, addr);
> +		curd =3D map_read(map, addr);
> =20
> -		return map_word_andequal(map, d, ready, ready);
> +		return map_word_andequal(map, curd, ready, ready);

A lot of the diff is just a rename. I am not against a rename if you
feel it's better, but in this order:
1: prepare the fix
2: fix
3: rename/define id's, whatever

>  	}
> =20
> -	d =3D map_read(map, addr);
> -	t =3D map_read(map, addr);
> +	oldd =3D map_read(map, addr);
> +	curd =3D map_read(map, addr);
> +
> +	ret =3D map_word_equal(map, oldd, curd);
> =20
> -	return map_word_equal(map, d, t);
> +	if (!ret || !expected)
> +		return ret;
> +
> +	return map_word_equal(map, curd, *expected);
>  }
> =20
> +/*
> + * Return true if the chip is ready.
> + *
> + * Ready is one of: read mode, query mode, erase-suspend-read mode (in a=
ny
> + * non-suspended sector) and is indicated by no toggle bits toggling.
> + *
> + * Note that anything more complicated than checking if no bits are togg=
ling
> + * (including checking DQ5 for an error status) is tricky to get working
> + * correctly and is therefore not done	(particularly with interleaved ch=
ips
> + * as each chip must be checked independently of the others).
> + */
> +#define chip_ready(map, chip, addr) chip_check(map, chip, addr, NULL)

I don't see the point of such a define. Just get rid of it.

> +
>  /*
>   * Return true if the chip is ready and has the correct value.
>   *
> @@ -852,32 +860,11 @@ static int __xipram chip_ready(struct map_info *map=
, struct flchip *chip,
>   * as each chip must be checked independently of the others).
>   *
>   */
> -static int __xipram chip_good(struct map_info *map, struct flchip *chip,
> -			      unsigned long addr, map_word expected)
> -{
> -	struct cfi_private *cfi =3D map->fldrv_priv;
> -	map_word oldd, curd;
> -
> -	if (cfi_use_status_reg(cfi)) {
> -		map_word ready =3D CMD(CFI_SR_DRB);
> -
> -		/*
> -		 * For chips that support status register, check device
> -		 * ready bit
> -		 */
> -		cfi_send_gen_cmd(0x70, cfi->addr_unlock1, chip->start, map, cfi,
> -				 cfi->device_type, NULL);
> -		curd =3D map_read(map, addr);
> -
> -		return map_word_andequal(map, curd, ready, ready);
> -	}
> -
> -	oldd =3D map_read(map, addr);
> -	curd =3D map_read(map, addr);
> -
> -	return	map_word_equal(map, oldd, curd) &&
> -		map_word_equal(map, curd, expected);
> -}
> +#define chip_good(map, chip, addr, expected) \
> +	({ \
> +		map_word datum =3D expected; \
> +		chip_check(map, chip, addr, &datum); \
> +	})

What is this for? Same here, I don't see the point. Please get rid of
all these unnecessary helpers which do nothing, besides complicating
user's life.

>  static int get_chip(struct map_info *map, struct flchip *chip, unsigned =
long adr, int mode)
>  {


Thanks,
Miqu=C3=A8l
