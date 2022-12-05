Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE2C642F89
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 19:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiLESA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 13:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiLESAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 13:00:25 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336781AF35;
        Mon,  5 Dec 2022 10:00:24 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B3392C0003;
        Mon,  5 Dec 2022 18:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1670263222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bdDAK4fk0/LkRHjnH0BkmGmCTYghTKYbvgGTDqO6qbw=;
        b=RJT+NX/HjGkRaEKxNE1nU6nMYtt5KlOk/54xxD7j7LG3edYFnqlkLjSH0uPt283JmMZcVN
        fyW5E1/3qI1zBegF9fgDNIkazpfB9v2dBmAPEeX94sVZblmKCmt/qeG7WgDxchOLaJ0W1U
        JPjOwdCHxDpzHQsceatybjmpQmxFYrHCKvBde5QuNv1sPmmMr4AKiI4SQCthSQsPVTLrSx
        wtgYrAANr2kNkKn01T857747NGoF9JzEYGKEqMZGM5IyUk61RRv5tpTaiCxAwryULlUNof
        3YHj42zSTzS0JsXQpL9wxHPYBR6bewIvZJT3Ob7IE7SvlObK3toCDf/8zLbhCg==
Date:   Mon, 5 Dec 2022 18:58:59 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Marek Vasut <marex@denx.de>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, linux-mtd@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v1] Revert "ARM: dts: imx7: Fix NAND controller
 size-cells"
Message-ID: <20221205185859.433d6cbf@xps-13>
In-Reply-To: <0aa2d48b-35a0-1781-f265-0387d213bdd6@denx.de>
References: <20221205152327.26881-1-francesco@dolcini.it>
        <0aa2d48b-35a0-1781-f265-0387d213bdd6@denx.de>
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

Hi Marek,

marex@denx.de wrote on Mon, 5 Dec 2022 17:26:53 +0100:

> On 12/5/22 16:23, Francesco Dolcini wrote:
> > From: Francesco Dolcini <francesco.dolcini@toradex.com>
> >=20
> > This reverts commit 753395ea1e45c724150070b5785900b6a44bd5fb.
> >=20
> > It introduced a boot regression on colibri-imx7, and potentially any
> > other i.MX7 boards with MTD partition list generated into the fdt by
> > U-Boot.
> >=20
> > While the commit we are reverting here is not obviously wrong, it fixes
> > only a dt binding checker warning that is non-functional, while it
> > introduces a boot regression and there is no obvious fix ready.
> >=20
> > Cc: stable@vger.kernel.org
> > Fixes: 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
> > Link: https://lore.kernel.org/all/Y4dgBTGNWpM6SQXI@francesco-nb.int.tor=
adex.com/
> > Link: https://lore.kernel.org/all/20221205144917.6514168a@xps-13/
> > Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> > ---
> >   arch/arm/boot/dts/imx7s.dtsi | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
> > index 03d2e8544a4e..0fc9e6b8b05d 100644
> > --- a/arch/arm/boot/dts/imx7s.dtsi
> > +++ b/arch/arm/boot/dts/imx7s.dtsi
> > @@ -1270,10 +1270,10 @@ dma_apbh: dma-apbh@33000000 {
> >   			clocks =3D <&clks IMX7D_NAND_USDHC_BUS_RAWNAND_CLK>;
> >   		}; =20
> >   > -		gpmi: nand-controller@33002000 { =20
> > +		gpmi: nand-controller@33002000{
> >   			compatible =3D "fsl,imx7d-gpmi-nand";
> >   			#address-cells =3D <1>;
> > -			#size-cells =3D <0>;
> > +			#size-cells =3D <1>;
> >   			reg =3D <0x33002000 0x2000>, <0x33004000 0x4000>;
> >   			reg-names =3D "gpmi-nand", "bch";
> >   			interrupts =3D <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>; =20
>=20
> I suspect this fix should eventually be reverted again, once a proper fix=
 is agreed upon in the MTD OF parser, right ?

I guess it's time to migrate to a more modern definition, it's not
complex to do, there are plenty of examples. This would be IMHO a
better step ahead rather than just a cell change. Anyway, I don't mind
reverting this once we've sorted this mess out and fixed U-Boot.

Cheers,
Miqu=C3=A8l
