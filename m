Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 903FE642FBD
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 19:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiLESSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 13:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbiLESSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 13:18:41 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFECE101F9;
        Mon,  5 Dec 2022 10:18:37 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DA2091C0004;
        Mon,  5 Dec 2022 18:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1670264316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rzs5vO2necK+4hQNCAUS4xm4OA1j+MgotCla3Sp8mkU=;
        b=M5ZN0CNhsTtEBvzcmt5XR5oQ7+LjASrEO96UiTfR/MLTYwP8Ouufp19EOqWMOfNpvR2lq0
        mkpfXTSXEz4Y/vJV097W/pNGxFH0XxuvJGDsyAgRDlWh5fdyyCzYL+dFM1rXkrKiLWQB9E
        OS3dX6I/RkwX7P0/T6Nf2Agz0tWyVzRMpi3mVWsL76xQoB+3+tp+31+2n67qC9uLIVySa5
        LjtdraluwjJr37ZTnsF7JQ7+zR+Kp5P+dlnGmsoMbaiyE+ACTLixsnmWc8cf+NNKGA0d+e
        c3TauUKrTc9Xq4/nog6jyo/A2h6UeKDquZGHyWcUcmy/A6ILoNPWXt9SYEJ+RA==
Date:   Mon, 5 Dec 2022 19:18:28 +0100
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
Message-ID: <20221205191828.3072d872@xps-13>
In-Reply-To: <f69746b0-51c0-041c-4035-679c27fcba64@denx.de>
References: <20221205152327.26881-1-francesco@dolcini.it>
        <0aa2d48b-35a0-1781-f265-0387d213bdd6@denx.de>
        <20221205185859.433d6cbf@xps-13>
        <f69746b0-51c0-041c-4035-679c27fcba64@denx.de>
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

marex@denx.de wrote on Mon, 5 Dec 2022 19:07:14 +0100:

> On 12/5/22 18:58, Miquel Raynal wrote:
> > Hi Marek, =20
>=20
> Hi,
>=20
> > marex@denx.de wrote on Mon, 5 Dec 2022 17:26:53 +0100:
> >  =20
> >> On 12/5/22 16:23, Francesco Dolcini wrote: =20
> >>> From: Francesco Dolcini <francesco.dolcini@toradex.com>
> >>>
> >>> This reverts commit 753395ea1e45c724150070b5785900b6a44bd5fb.
> >>>
> >>> It introduced a boot regression on colibri-imx7, and potentially any
> >>> other i.MX7 boards with MTD partition list generated into the fdt by
> >>> U-Boot.
> >>>
> >>> While the commit we are reverting here is not obviously wrong, it fix=
es
> >>> only a dt binding checker warning that is non-functional, while it
> >>> introduces a boot regression and there is no obvious fix ready.
> >>>
> >>> Cc: stable@vger.kernel.org
> >>> Fixes: 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
> >>> Link: https://lore.kernel.org/all/Y4dgBTGNWpM6SQXI@francesco-nb.int.t=
oradex.com/
> >>> Link: https://lore.kernel.org/all/20221205144917.6514168a@xps-13/
> >>> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> >>> ---
> >>>    arch/arm/boot/dts/imx7s.dtsi | 4 ++--
> >>>    1 file changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.d=
tsi
> >>> index 03d2e8544a4e..0fc9e6b8b05d 100644
> >>> --- a/arch/arm/boot/dts/imx7s.dtsi
> >>> +++ b/arch/arm/boot/dts/imx7s.dtsi
> >>> @@ -1270,10 +1270,10 @@ dma_apbh: dma-apbh@33000000 {
> >>>    			clocks =3D <&clks IMX7D_NAND_USDHC_BUS_RAWNAND_CLK>;
> >>>    		}; =20
> >>>    > -		gpmi: nand-controller@33002000 { =20
> >>> +		gpmi: nand-controller@33002000{
> >>>    			compatible =3D "fsl,imx7d-gpmi-nand";
> >>>    			#address-cells =3D <1>;
> >>> -			#size-cells =3D <0>;
> >>> +			#size-cells =3D <1>;
> >>>    			reg =3D <0x33002000 0x2000>, <0x33004000 0x4000>;
> >>>    			reg-names =3D "gpmi-nand", "bch";
> >>>    			interrupts =3D <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>; =20
> >>
> >> I suspect this fix should eventually be reverted again, once a proper =
fix is agreed upon in the MTD OF parser, right ? =20
> >=20
> > I guess it's time to migrate to a more modern definition =20
>=20
> Is that the nand-chip@N { status=3D"disabled"; } part ?

I would prefer the controller to be disabled if useless, but otherwise
yes.

>=20
> >, it's not
> > complex to do, there are plenty of examples. This would be IMHO a
> > better step ahead rather than just a cell change. Anyway, I don't mind
> > reverting this once we've sorted this mess out and fixed U-Boot. =20
>=20
> Won't we still have issues with older bootloader versions which paste par=
titions directly into this &gpmi {} node, and which needs to be fixed up in=
 the parser in the end ?

I believe fdt_fixup_mtdparts() should be killed, so we should no longer
have this problem.

Thanks,
Miqu=C3=A8l
