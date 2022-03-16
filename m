Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C88C4DB703
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 18:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbiCPRWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 13:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349592AbiCPRWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 13:22:23 -0400
X-Greylist: delayed 340 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Mar 2022 10:21:04 PDT
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9055AA6D
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 10:21:03 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B2EE360002;
        Wed, 16 Mar 2022 17:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647451262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ih15VBjRPSQG+DNyYyWCmqshCK/OfYo4dXjKXcrJa5I=;
        b=EIf9UM4WGpEpYyyNC2IB1zyjWu9ApTH9jSaQdHgWig+MDvNW03WkAZCWqH7kUw8pTmJnlb
        4J5K8gsUycSLJISGo6f0npQpMEEV4+BJSlv7v2K23IydgFbgL+D6IltJd03N+fTv5pW0uS
        EZCnyEITrnkpl2EAujGpniFIHVW3kaCIF2SRtNHfLPYBKdY3TdgFluB36etfDZTEL47Ksl
        WRC212hRCSp1SK/0TsobL1f0l2/C3uTwMqrOyjzflRPx+y9BMWxMX7KmhS7cYekuwgxEde
        J/DzKuaKansYBUC3ReddwpA2BwuPnofVq8UMbb0LRlFiFrYg9QM2f+Rlboq68g==
Date:   Wed, 16 Mar 2022 18:21:00 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Tokunori Ikegami <ikegami.t@gmail.com>
Cc:     linux-mtd@lists.infradead.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH v4 2/3] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Message-ID: <20220316182100.6e2e5876@xps13>
In-Reply-To: <20220316155455.162362-3-ikegami.t@gmail.com>
References: <20220316155455.162362-1-ikegami.t@gmail.com>
        <20220316155455.162362-3-ikegami.t@gmail.com>
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

ikegami.t@gmail.com wrote on Thu, 17 Mar 2022 00:54:54 +0900:

> As pointed out by this bug report [1], buffered writes are now broken on
> S29GL064N. This issue comes from a rework which switched from using chip_=
good()
> to chip_ready(), because DQ true data 0xFF is read on S29GL064N and an er=
ror
> returned by chip_good().

Vignesh, I believe you understand this issue better than I do, can you
propose an improved commit log?

> One way to solve the issue is to revert the change
> partially to use chip_ready for S29GL064N.
>=20
> [1] https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengut=
ronix.de/
>=20
> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check c=
orrect value")
> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/mtd/chips/cfi_cmdset_0002.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_=
cmdset_0002.c
> index e68ddf0f7fc0..6c57f85e1b8e 100644
> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
> @@ -866,6 +866,23 @@ static int __xipram chip_check(struct map_info *map,=
 struct flchip *chip,
>  		chip_check(map, chip, addr, &datum); \
>  	})
> =20
> +static bool __xipram cfi_use_chip_ready_for_write(struct map_info *map)

At the very least I would call this function:
cfi_use_chip_ready_for_writes()

Yet, I still don't fully get what chip_ready is versus chip_good.

> +{
> +	struct cfi_private *cfi =3D map->fldrv_priv;
> +
> +	return cfi->mfr =3D=3D CFI_MFR_AMD && cfi->id =3D=3D 0x0c01;
> +}
> +
> +static int __xipram chip_good_for_write(struct map_info *map,
> +					struct flchip *chip, unsigned long addr,
> +					map_word expected)
> +{
> +	if (cfi_use_chip_ready_for_write(map))
> +		return chip_ready(map, chip, addr);

If possible and not too invasive I would definitely add a "quirks" flag
somewhere instead of this cfi_use_chip_ready_for_write() check.

Anyway, I would move this to the chip_good() implementation directly so
we partially hide the quirks complexity from the core.

> +
> +	return chip_good(map, chip, addr, expected);
> +}
> +
>  static int get_chip(struct map_info *map, struct flchip *chip, unsigned =
long adr, int mode)
>  {
>  	DECLARE_WAITQUEUE(wait, current);
> @@ -1686,7 +1703,7 @@ static int __xipram do_write_oneword_once(struct ma=
p_info *map,
>  		 * "chip_good" to avoid the failure due to scheduling.
>  		 */
>  		if (time_after(jiffies, timeo) &&
> -		    !chip_good(map, chip, adr, datum)) {
> +		    !chip_good_for_write(map, chip, adr, datum)) {
>  			xip_enable(map, chip, adr);
>  			printk(KERN_WARNING "MTD %s(): software timeout\n", __func__);
>  			xip_disable(map, chip, adr);
> @@ -1694,7 +1711,7 @@ static int __xipram do_write_oneword_once(struct ma=
p_info *map,
>  			break;
>  		}
> =20
> -		if (chip_good(map, chip, adr, datum)) {
> +		if (chip_good_for_write(map, chip, adr, datum)) {
>  			if (cfi_check_err_status(map, chip, adr))
>  				ret =3D -EIO;
>  			break;
> @@ -1966,14 +1983,14 @@ static int __xipram do_write_buffer_wait(struct m=
ap_info *map,
>  		 * "chip_good" to avoid the failure due to scheduling.
>  		 */
>  		if (time_after(jiffies, timeo) &&
> -		    !chip_good(map, chip, adr, datum)) {
> +		    !chip_good_for_write(map, chip, adr, datum)) {
>  			pr_err("MTD %s(): software timeout, address:0x%.8lx.\n",
>  			       __func__, adr);
>  			ret =3D -EIO;
>  			break;
>  		}
> =20
> -		if (chip_good(map, chip, adr, datum)) {
> +		if (chip_good_for_write(map, chip, adr, datum)) {
>  			if (cfi_check_err_status(map, chip, adr))
>  				ret =3D -EIO;
>  			break;


Thanks,
Miqu=C3=A8l
