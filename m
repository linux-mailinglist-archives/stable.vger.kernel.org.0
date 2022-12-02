Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D602640551
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 11:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbiLBKya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 05:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233250AbiLBKxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 05:53:52 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F49D0394
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 02:53:37 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BA35820004;
        Fri,  2 Dec 2022 10:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669978413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/xbDowsjdVxGHiCknMNfQWZp8ui3AZGVt031X2dFPgs=;
        b=V0G7HbGVHu1UnQcFOkheErwQ54WBVfssvbvblVvAgBmx2/cx07Wal5slnmzOCj2mHSdCZT
        YefGXDygzc/XOR2ApaE0zcUcJ/FkG6jbDuje8RBXRdeECWF405vrCpCnhxrHa4wNSA9zUK
        QR/nXDeMQLRr1AV/hpTTmGFTQg3Gx85OkgD6vYnqn17a721nUP6htat0+vYd6e3yCF+exk
        fT6byoQdarowANubLCUHizmAnEXebaR9HoPnF+DxHdq8xQV+tvW63souC5VUlj1QlFrF3I
        iTfpNzAyL5tomVH96yN3nCH/tadjyBct/q8cOc8gYi9AOOGxJVK4Kt9pVggE+Q==
Date:   Fri, 2 Dec 2022 11:53:27 +0100
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
Message-ID: <20221202115327.4475d3a2@xps-13>
In-Reply-To: <Y4nSXQirO2N5IRfu@francesco-nb.int.toradex.com>
References: <20221202071900.1143950-1-francesco@dolcini.it>
        <20221202101418.6b4b3711@xps-13>
        <Y4nPmzdgaabg3a3/@francesco-nb.int.toradex.com>
        <Y4nSXQirO2N5IRfu@francesco-nb.int.toradex.com>
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

francesco@dolcini.it wrote on Fri, 2 Dec 2022 11:24:29 +0100:

> On Fri, Dec 02, 2022 at 11:12:43AM +0100, Francesco Dolcini wrote:
> > Hello Miquel,
> >=20
> > On Fri, Dec 02, 2022 at 10:14:18AM +0100, Miquel Raynal wrote: =20
> > > francesco@dolcini.it wrote on Fri,  2 Dec 2022 08:19:00 +0100: =20
> > > > From: Francesco Dolcini <francesco.dolcini@toradex.com>
> > > >=20
> > > > Add a fallback mechanism to handle the case in which #size-cells is=
 set
> > > > to <0>. According to the DT binding the nand controller node should=
 have
> > > > set it to 0 and this is not compatible with the legacy way of
> > > > specifying partitions directly as child nodes of the nand-controlle=
r node. =20
> > >=20
> > > I understand the problem, I understand the fix, but I have to say, I
> > > strongly dislike it :) Touching an mtd core driver to fix a single
> > > broken use case like that is... problematic, for the least. =20
> > I just noticed it 2 days after this patch was backported to a stable
> > kernel, I am just the first one to notice, we are not talking about a s=
ingle
> > use case.
> >  =20
> > > I am sorry but if a 6.0 kernel breaks because: =20
> > Not only kernel 6.0 is currently broken. This patch is going to be
> > backported to any stable kernel given the fixes tag it has.
> >  =20
> > > If you really want to workaround U-Boot, either you revert that patch
> > > or you just fix the DT description instead. The parent/child/partitio=
ns
> > > scheme has been enforced for maybe 5 years now and for a good reason:=
 a
> > > NAND controller with partitions does not make _any_ sense. There are
> > > plenty of examples out there, imx7-colibri.dtsi has received many
> > > updates since its introduction (for the best), so why not this one? =
=20
> >=20
> > I can and I will update imx7-colibri.dtsi (patch coming),

:thumb_up:

> > but is this
> > good enough given the kind of boot failure regression this introduce? We
> > are going to have old u-boot around that will not work with it, and the=
 =20
>=20
> Just another piece of information, support for the partitions node in
> U-Boot was added in version v2022.04 [1], we are not talking about ancient
> old legacy stuff.

If it is so recent, then this is what needs to be fixed, and it should
not bother "many" people because 2022.04 is not so old.

So I am a bit lost, IIUC what is currently broken is:
- U-Boot > 2022.04 and any version of Linux with the backport?

> If I add the partitions node as a child of my nand controller, as I was
> planning to do and I wrote 10 lines above, I will create a new flavor of
> non-booting system with U-Boot older than v2022.04 :-/

I think there is a little confusion here. You are referring to the NAND
controller node, the commit refers to the NAND chip node. What this
commit does looks fine because it just tries to use the partitions {}
node rather than the NAND chip node and if the partitions {} node
already exist, I expect #address-cells and #size-cells to be defined
and be !=3D 0 already.

Here is a proper description:

nand-controller {
	#address-cells =3D <1>;
	#size-cells =3D <0>;
	nand-chip {
		partitions {
			#address-cells =3D <1 or 2>;
			#size-cells =3D <1 or 2>;
			partition@x { };
			partition@y { };
		};
	};

	/* Here you can very well have another nand-chip node with
	 * another reg property which represents its own CS and another
	 * set of partitions.
	 */
};

> U-Boot older than v2022.04 will update the nand controller node never
> the less, the partition node will still be there and Linux will use it,
> but it will be empty since nobody populate it.
>=20
> Francesco
>=20
> [1] commit 36fee2f7621e ("common: fdt_support: add support for "partition=
s" subnode to fdt_fixup_mtdparts()")


Thanks,
Miqu=C3=A8l
