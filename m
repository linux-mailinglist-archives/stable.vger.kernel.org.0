Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE5164098D
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 16:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbiLBPtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 10:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiLBPtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 10:49:15 -0500
X-Greylist: delayed 17737 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 02 Dec 2022 07:49:12 PST
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F56AD33F
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 07:49:12 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9180D20015;
        Fri,  2 Dec 2022 15:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669996151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DQFtCkqo0CS4WybTtvswvMI7R2OV7c6arm4hFMGtwQI=;
        b=IImA+1x5pxVbR5NTTmWENxTn4kQG0X1onXsn6BK3OlrolpzI61AkWVsXCdBWcOn231p5H7
        buvzRoQP6f/FA1e6ieCdYgFNXdz4qS0vmkv/ZVuKuE9h1eaVZU29L9daKh+KTyoRslKBVJ
        pSB5kcocI7gYcRuRIoDKDjPYAM0SEczsUGfFUnCwa0jNCD8aYRiakpGlpyNCKmJ3hYZJzj
        B+S0hQWohVCAi8hh3IYbJU2tmGtCJTawKCQBEWplj9Q++eJkdVulhmlHOs16N7M3SM85zi
        ZDnkbIsL6tj5y8XE8NUvUvqeVfnlAuTDXUiaCgXdn1uUd+6p2kv3NHXjZiH8pw==
Date:   Fri, 2 Dec 2022 16:49:04 +0100
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
Message-ID: <20221202164904.08d750df@xps-13>
In-Reply-To: <223b7a4e-3aff-8070-7387-c77d2ded1dd6@denx.de>
References: <20221202071900.1143950-1-francesco@dolcini.it>
        <20221202101418.6b4b3711@xps-13>
        <Y4nPmzdgaabg3a3/@francesco-nb.int.toradex.com>
        <Y4nSXQirO2N5IRfu@francesco-nb.int.toradex.com>
        <20221202115327.4475d3a2@xps-13>
        <Y4ngOaKq224LIpQc@francesco-nb.int.toradex.com>
        <20221202150556.14c5ae43@xps-13>
        <2b6fc52d-60b9-d0f4-ab91-4cf7a8095999@denx.de>
        <20221202160030.1b8d0b8a@xps-13>
        <223b7a4e-3aff-8070-7387-c77d2ded1dd6@denx.de>
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

marex@denx.de wrote on Fri, 2 Dec 2022 16:23:29 +0100:

> On 12/2/22 16:00, Miquel Raynal wrote:
> > Hi Marek, =20
>=20
> Hi,
>=20
> > marex@denx.de wrote on Fri, 2 Dec 2022 15:31:40 +0100:
> >  =20
> >> On 12/2/22 15:05, Miquel Raynal wrote: =20
> >>> Hi Francesco, =20
> >>
> >> Hi,
> >>
> >> [...]
> >> =20
> >>> I still strongly disagree with the initial proposal but what I think =
we
> >>> can do is:
> >>>
> >>> 1. To prevent future breakages:
> >>>     Fix fdt_fixup_mtdparts() in u-boot. This way newer U-Boot + any
> >>>     kernel should work.
> >>>
> >>> 2. To help tracking down situations like that:
> >>>     Keep the warning in ofpart.c but continue to fail.
> >>>
> >>> 3. To fix the current situation:
> >>>      Immediately revert commit (and prevent it from being backported):
> >>>      753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
> >>>      This way your own boot flow is fixed in the short term. =20
> >>
> >> Here I disagree, the fix is correct and I think we shouldn't
> >> proliferate incorrect DTs which don't match the binding document. =20
> >=20
> > I agree we should not proliferate incorrect DTs, so let's use a modern
> > description then =20
>=20
> Yes please !
>=20
> > , with a controller and a child node which defines the
> > chip. =20
>=20
> But what if there is no chip connected to the controller node ?
>=20
> If I understand the proposal here right (please correct me if I'm wrong),=
 then:

Good idea to summarize.

>=20
> 1) This is the original, old, wrong binding:
> &gpmi {
>    #size-cells =3D <1>;
>    ...
>    partition@N { ... };
> };

Yes.

>=20
>=20
> 2) This is the newer, but still wrong binding:
> &gpmi {
>    #size-cells =3D <0>;
>    ...
>    partitions {
>      partition@N { ... };
>    };
> };

Well, this is wrong description, but it would work (for compat reasons,
even though I don't think this is considered valid DT by the schemas).

>=20
> 3) This is the newest binding, what we want:
> &gpmi {
>    #size-cells =3D <0>;
>    ...
>    nand-chip {
>      partitions {
>        partition@N { ... };
>      };
>    };
> };

Yes

>=20
> But if there is no physical nand chip connected to the controller, would =
we end up with empty nand-chip node in DT, like this?
> &gpmi {
>    #size-cells =3D <X>;
>    ...
>    nand-chip { /* empty */ };
> };

Is this really a concern? If there is no NAND chip, the controller
should be disabled, no? I guess technically you could even use the
status property in the nand-chip node...

However, it should not be empty, at the very least a reg property
should indicate on which CS it is wired, as expected there:
https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git/tree/Document=
ation/devicetree/bindings/mtd/nand-chip.yaml?h=3Dmtd/next

But, as nand-chip.yaml references mtd.yaml, you can as well use
whatever is described here:
https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git/tree/Document=
ation/devicetree/bindings/mtd/mtd.yaml?h=3Dmtd/next

> What would be the gpmi controller size cells (X) in that case, still 0, r=
ight ? So how does that help solve this problem, wouldn't U-Boot still popu=
late the partitions directly under the gpmi node or into partitions sub-nod=
e ?

The commit that was pointed in the original fix clearly stated that the
NAND chip node was targeted, not the NAND controller node. I hope this
is correctly supported in U-Boot though. So if there is a NAND chip
subnode, I suppose U-Boot would try to create the partitions that are
inside, or even in the sub "partitions" container.

> >> Rather, if a bootloader generates incorrect (new) DT entries, I
> >> believe the driver should implement a fixup and warn user about this.
> >> PC does that as well with broken ACPI tables as far as I can tell.
> >>
> >> I'm not convinced making a DT non-compliant with bindings again, =20
> >=20
> > I am sorry to say so, but while warnings reported by the tools
> > should be fixed, it's not because the tool does not scream at you that
> > the description is valid. We are actively working on enhancing the
> > schema so that "all" improper descriptions get warnings (see the series
> > pointed earlier), but in no way this change makes the node compliant
> > with modern bindings.
> >=20
> > I'm not saying the fix is wrong, but let's be pragmatic, it currently
> > leads to boot failures. =20
>=20
> I fully agree that we do have a problem, and that it trickled into stable=
 makes it even worse. Maybe I don't fully understand the thing with nand-ch=
ip proposal, see my question above, esp. the last part.
>=20
> >> only to work around a problem induced by bootloader, is the right appr=
oach
> >> here. =20
> >=20
> > When a patch breaks a board and there is no straight fix, you revert
> > it, then you think harder. That's what I am saying. This is a temporary
> > solution. =20
>=20
> Isn't this patch the straight fix, at least until the bootloader can be u=
pdated to generate the nand-chip node correctly ?
>=20
> >> This would be setting a dangerous example, where anyone could request =
a DT fix to be reverted because their random bootloader does the wrong thin=
g and with valid DT clean up, something broke. =20
> >=20
> > Please, you know this is not valid DT clean up. We've been decoupling
> > controller and chip description since 2016. What I am proposing is a
> > valid DT cleanup, not to the latest standard, but way closer than the
> > current solution. =20
>=20
> I think I really need one more explanation of the nand-chip part above.

I hope things are clearer now.

Thanks,
Miqu=C3=A8l
