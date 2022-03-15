Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB64B4DA2B3
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 19:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiCOSw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 14:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351195AbiCOSw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 14:52:56 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E15158839
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 11:51:41 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A5CEB100003;
        Tue, 15 Mar 2022 18:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647370300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mtIJ/RT9AyMm2r6Q6e8jZJ4WZp0suD6YNlNWzDzCarw=;
        b=WJ756feOVINa7LY3fsskeGvcAHj1xeB3HxgbrRLBh0R6GMXuiQbB38iwaPzVdkp6r6xnvX
        cO8UxVpSBdHIIgImZEkGFsUC3O1H9VqmacH3+n1lNhtgz6/0jn/A3SmRr/MQNm2rI0X63G
        U4Jeo9xn5c3/W9jj2aYisLpL7kVCJ/Hg4nVMl5o/fCbebU9X3bH1RhZGPVRRIn8Q5bqpgn
        tN60yHSnY5jAioMbMCyzQUjnMX1rS/vKhD9/XHnNs0zp2hme5RPGVwLLVCa4wmyHIm0opc
        astTmS/msm0ezUVFEpywNgnnJL20/jFX5ji3bbGr3nQyFQlk1/JUndzNfZ0mHw==
Date:   Tue, 15 Mar 2022 19:51:37 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Tokunori Ikegami <ikegami.t@gmail.com>
Cc:     linux-mtd@lists.infradead.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Message-ID: <20220315195137.6e371f8f@xps13>
In-Reply-To: <20220315165607.390070-4-ikegami.t@gmail.com>
References: <20220315165607.390070-1-ikegami.t@gmail.com>
        <20220315165607.390070-4-ikegami.t@gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tokunori,

ikegami.t@gmail.com wrote on Wed, 16 Mar 2022 01:56:07 +0900:

> As pointed out by this bug report [1], the buffered write is now broken on

                                       , buffered writes are now broken

> S29GL064N. The reason is that changed the buffered write to use chip_good
> instead of chip_ready.

"This issue comes from a rework which switched from using chip_good()
to chip_ready(), because <explain the difference here>."

[please note I am just trying to understand what the root cause is,
please rephrase if I'm wrong].

> One way to solve the issue is to revert the change
> partially to use chip_ready for S29GL064N since the way of least surprise.

s/since the way of least surprise//


>=20
> [1] https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengut=
ronix.de/
>=20
> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check c=
orrect value")
> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Cc: Miquel Raynal <miquel.raynal@bootlin.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Vignesh Raghavendra <vigneshr@ti.com>
> Cc: linux-mtd@lists.infradead.org

I think you can get rid of all the above Cc: tags and just copy all 3
of us + the mailing list when sending your v4.

> Cc: stable@vger.kernel.org
> ---

Please also include a Fixes/stable tag in the patch before (2/3) to explain
that both patches are required in order to fix the issue and the current pa=
tch alone won't apply.

You should mention that with a nice comment below the three dashes ("---") =
in patch 2/3 as well.

>  drivers/mtd/chips/cfi_cmdset_0002.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_=
cmdset_0002.c
> index 8f3f0309dc03..fa11db066c99 100644
> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
> @@ -867,10 +867,20 @@ static int __xipram chip_good(struct map_info *map,=
 struct flchip *chip,
>  	return chip_check(map, chip, addr, &expected);
>  }
> =20
> +static bool __xipram cfi_use_chip_ready_for_write(struct map_info *map)
> +{
> +	struct cfi_private *cfi =3D map->fldrv_priv;
> +
> +	return cfi->mfr =3D=3D CFI_MFR_AMD && cfi->id =3D=3D S29GL064N_MN12;
> +}
> +
>  static int __xipram chip_good_for_write(struct map_info *map,
>  					struct flchip *chip, unsigned long addr,
>  					map_word expected)
>  {
> +	if (cfi_use_chip_ready_for_write(map))
> +		return chip_ready(map, chip, addr);
> +
>  	return chip_good(map, chip, addr, expected);
>  }
> =20

This is much more understandable.

Vignesh, perhaps it would be better to provide a way for manufacturers
to overload certain callbacks instead of applying quirks like this in
the code. But that will come in a second time of course.


Thanks,
Miqu=C3=A8l
