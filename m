Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD656408E3
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 16:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbiLBPAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 10:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiLBPAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 10:00:40 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3ABE256B
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 07:00:37 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B0F21100007;
        Fri,  2 Dec 2022 15:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669993236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=59qSwgpaGJCpHjydTIqoo0IPT+OCfNv0dCYixP5EWqg=;
        b=TaAd/jd7DJaOECXA/cSb/SywJ7kSqgK5OydWuWmhvTIXhgKRyyxWmNG6YzOeT/M30zSuhc
        WaSxv3dOkKMXexw8SXTLM6GQ62JgFH4Dk0piZgv5otuzG1rxbAx62Hb7Id5E7/b1WySwjB
        llvxVcds2aETbx3Wqcih+KWrROrFLDc2cuVdGG6Oj8vaO333shCCokqqLGLgX5cBDCqOao
        +krQkRkGSRtUy+yQxAxeAGJDkMiOaJh3jKeyCbwHxZGAtan+cc+iGFxSvf9/aHp3mg0qVR
        RS3eZ5IImxAO+2GZR61FyfapFqnCJs+64n1FfLB2bpk9CRQk/3L6NTMvdw/o/A==
Date:   Fri, 2 Dec 2022 16:00:30 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Marek Vasut <marex@denx.de>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is
 0
Message-ID: <20221202160030.1b8d0b8a@xps-13>
In-Reply-To: <2b6fc52d-60b9-d0f4-ab91-4cf7a8095999@denx.de>
References: <20221202071900.1143950-1-francesco@dolcini.it>
        <20221202101418.6b4b3711@xps-13>
        <Y4nPmzdgaabg3a3/@francesco-nb.int.toradex.com>
        <Y4nSXQirO2N5IRfu@francesco-nb.int.toradex.com>
        <20221202115327.4475d3a2@xps-13>
        <Y4ngOaKq224LIpQc@francesco-nb.int.toradex.com>
        <20221202150556.14c5ae43@xps-13>
        <2b6fc52d-60b9-d0f4-ab91-4cf7a8095999@denx.de>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marek,

marex@denx.de wrote on Fri, 2 Dec 2022 15:31:40 +0100:

> On 12/2/22 15:05, Miquel Raynal wrote:
> > Hi Francesco, =20
>=20
> Hi,
>=20
> [...]
>=20
> > I still strongly disagree with the initial proposal but what I think we
> > can do is:
> >=20
> > 1. To prevent future breakages:
> >    Fix fdt_fixup_mtdparts() in u-boot. This way newer U-Boot + any
> >    kernel should work.
> >=20
> > 2. To help tracking down situations like that:
> >    Keep the warning in ofpart.c but continue to fail.
> >=20
> > 3. To fix the current situation:
> >     Immediately revert commit (and prevent it from being backported):
> >     753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
> >     This way your own boot flow is fixed in the short term. =20
>=20
> Here I disagree, the fix is correct and I think we shouldn't
> proliferate incorrect DTs which don't match the binding document.

I agree we should not proliferate incorrect DTs, so let's use a modern
description then, with a controller and a child node which defines the
chip.

> Rather, if a bootloader generates incorrect (new) DT entries, I
> believe the driver should implement a fixup and warn user about this.
> PC does that as well with broken ACPI tables as far as I can tell.
>=20
> I'm not convinced making a DT non-compliant with bindings again,

I am sorry to say so, but while warnings reported by the tools
should be fixed, it's not because the tool does not scream at you that
the description is valid. We are actively working on enhancing the
schema so that "all" improper descriptions get warnings (see the series
pointed earlier), but in no way this change makes the node compliant
with modern bindings.

I'm not saying the fix is wrong, but let's be pragmatic, it currently
leads to boot failures.

> only to work around a problem induced by bootloader, is the right approach
> here.

When a patch breaks a board and there is no straight fix, you revert
it, then you think harder. That's what I am saying. This is a temporary
solution.

> This would be setting a dangerous example, where anyone could request a D=
T fix to be reverted because their random bootloader does the wrong thing a=
nd with valid DT clean up, something broke.

Please, you know this is not valid DT clean up. We've been decoupling
controller and chip description since 2016. What I am proposing is a
valid DT cleanup, not to the latest standard, but way closer than the
current solution.

> > 4. There is no reason to partially fix a DT like what the above did
> >     besides trying to avoid warnings emitted by the DT check tools. =20
>=20
> Note that the 3. does not partially fix the DT, it fixes the node fully.
>=20
> >     If
> >     complying with modern bindings is a goal (and I think it should
> >     be), then we can modernize this DT without breaking the boot flow:
> >     Instead of only setting #size-cell =3D <0>, you can as well define
> >     in your DT a subnode to define the NAND chip. NAND chips are not
> >     supposed to have #size-cells properties, but in the past they did,
> >     which means #address-cells and #size-cells are allowed (and marked
> >     deprecated in the schema). So in practice, the dt-schema will not
> >     warn you if they are there, which means you can still set
> >     #size-cell =3D <1>. =20
>=20
> I am really not convinced we should hack around this on the DT end and tr=
y to push some sort of convoluted workaround there,

"convoluted workaround" :-)

> instead of fixing it on the driver side (and bootloader side, in the
> long run).
>
> >     Please mind, the tools have been updated very recently to match

s/tools/schema/

> >     what I am describing above, so they will likely still report
> >     errors until v6.2-rc1, see:
> >     https://lore.kernel.org/linux-mtd/20221114090315.848208-1-miquel.ra=
ynal@bootlin.com/
> >=20
> > Does this sound reasonable? =20
>=20
> [...]


Thanks,
Miqu=C3=A8l
