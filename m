Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169B36402FF
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 10:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbiLBJO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 04:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbiLBJO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 04:14:26 -0500
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9989DBA60A
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 01:14:24 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 193101BF216;
        Fri,  2 Dec 2022 09:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669972463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mo+eSjGRNKIzkQtyYbswTdgChJlhTFTWdGiiawXOxBI=;
        b=VdhNUhNp8yqwDIE7OuxejSu6Dr4RHeTfyVcIJZ5G8h7bbIXyBBgg0RRGGSWEkM5GgrgxkM
        t9nIVpFkYMg7rxsaIrXm+mSsspuXCjl59NGOk0hP01XMqLUjPpQ6efmBjFE0hLbUNomTvA
        zhcla/lwYfWI+GrvAdoAIMapwNRYOKrNw7uL9DRZmOqkdKe9OlrUaHZtgqiTba/9zyo3o0
        HieI0tG3U8hUM6at+spQzIccZyYRHsQzeOwckry6hDvgcDTU3uP9jdMleLVG52DMQ9ai2y
        4wUWf7UA685CoEs8+JUvJXq10x6eGHkCDkc4Ny6LJm99FDsugtgIh0yX8B/RZQ==
Date:   Fri, 2 Dec 2022 10:14:18 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Francesco Dolcini <francesco@dolcini.it>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org, Marek Vasut <marex@denx.de>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is
 0
Message-ID: <20221202101418.6b4b3711@xps-13>
In-Reply-To: <20221202071900.1143950-1-francesco@dolcini.it>
References: <20221202071900.1143950-1-francesco@dolcini.it>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Francesco,

francesco@dolcini.it wrote on Fri,  2 Dec 2022 08:19:00 +0100:

> From: Francesco Dolcini <francesco.dolcini@toradex.com>
>=20
> Add a fallback mechanism to handle the case in which #size-cells is set
> to <0>. According to the DT binding the nand controller node should have
> set it to 0 and this is not compatible with the legacy way of
> specifying partitions directly as child nodes of the nand-controller node.

I understand the problem, I understand the fix, but I have to say, I
strongly dislike it :) Touching an mtd core driver to fix a single
broken use case like that is... problematic, for the least.

I am sorry but if a 6.0 kernel breaks because:
- a legacy scheme is used in the description
- u-boot still does not conform to the DT standard
- a patch tries to make a tool happy
Then the solution is clearly not an 'mtd core' mainline patch.

If you really want to workaround U-Boot, either you revert that patch
or you just fix the DT description instead. The parent/child/partitions
scheme has been enforced for maybe 5 years now and for a good reason: a
NAND controller with partitions does not make _any_ sense. There are
plenty of examples out there, imx7-colibri.dtsi has received many
updates since its introduction (for the best), so why not this one?

Cheers,
Miqu=C3=A8l

> This fixes a boot failure on colibri-imx7 and potentially other boards.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
> Link: https://lore.kernel.org/all/Y4dgBTGNWpM6SQXI@francesco-nb.int.torad=
ex.com/
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> ---
>  drivers/mtd/parsers/ofpart_core.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/drivers/mtd/parsers/ofpart_core.c b/drivers/mtd/parsers/ofpa=
rt_core.c
> index 192190c42fc8..aa3b7fa61e50 100644
> --- a/drivers/mtd/parsers/ofpart_core.c
> +++ b/drivers/mtd/parsers/ofpart_core.c
> @@ -122,6 +122,17 @@ static int parse_fixed_partitions(struct mtd_info *m=
aster,
> =20
>  		a_cells =3D of_n_addr_cells(pp);
>  		s_cells =3D of_n_size_cells(pp);
> +		if (s_cells =3D=3D 0) {
> +			/*
> +			 * Use #size-cells =3D <1> for backward compatibility
> +			 * in case #size-cells is set to <0> and firmware adds
> +			 * OF partitions without setting it.
> +			 */
> +			pr_warn_once("%s: ofpart partition %pOF (%pOF) #size-cells is <0>, us=
ing <1> for backward compatibility.\n",
> +				     master->name, pp,
> +				     mtd_node);
> +			s_cells =3D 1;
> +		}
>  		if (len / 4 !=3D a_cells + s_cells) {
>  			pr_debug("%s: ofpart partition %pOF (%pOF) error parsing reg property=
.\n",
>  				 master->name, pp,

