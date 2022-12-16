Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8797364EE02
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 16:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiLPPfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 10:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiLPPfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 10:35:08 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17B6186E6
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 07:35:06 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 85EA52000E;
        Fri, 16 Dec 2022 15:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1671204904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CRNxLa3NwvaxA4E499bmTCzKgHqaavDobietvg9MgYY=;
        b=Q4c9niRO1LOcj7mMPp04sNlIfybgVDeXp6jqcaYz3yfg7H1z3mU4HMQLDEGJpwHU95lQ5C
        2fda/CNFNvfq0MwqGiHTBHXgGiNVr2Jl8Ze7X+ElZ73Hz15ONq4rrgx2r1l/zpLVjD5KAR
        g3qMo4Y02PIGJjhYZrzRQEq/fXd1NIjShAYCKBuGvSRGd+epcQ7tBxBDywgp2i/d2fgs6j
        XefI0PBloXW6k9iWOPoM3Ntowd6tFILovV8N28va1jjmu308UwCEGJgSV3l3VU2+A8K1cR
        /WzPg8izSs9F//BxKxQ5owY7Ovwz3SFhnu2Yeh4LOtWUr5+XIRmoC/XHJjhDdg==
Date:   Fri, 16 Dec 2022 16:35:01 +0100
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
Message-ID: <20221216163501.1c2ace21@xps-13>
In-Reply-To: <fb55a784-eda3-8916-1413-581b9436b3f2@denx.de>
References: <Y5wiAPvPU+YY39oX@francesco-nb.int.toradex.com>
        <6f5f5b32-d7fe-13cc-b52d-83a27bd9f53e@denx.de>
        <20221216120155.4b78e5cf@xps-13>
        <Y5xmi62hR6JeYUt1@francesco-nb.int.toradex.com>
        <20221216143720.3c8923d8@xps-13>
        <fb55a784-eda3-8916-1413-581b9436b3f2@denx.de>
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

marex@denx.de wrote on Fri, 16 Dec 2022 15:32:28 +0100:

> On 12/16/22 14:37, Miquel Raynal wrote:
>=20
> Hi,
>=20
> [...]
>=20
> >>> What? =20
> >>
> >> Let me rephrase, I was not clear enough.
> >> =20
> >>> Since when my proposal is breaking boards? My proposal leads to a
> >>> situation where:
> >>> - If you have a board that has an inconsistent description but worked,
> >>>    it will still work.
> >>> - If you have a board that has a consistent description and worked, it
> >>>    will still work.
> >>> - If your have a board that has an inconsistent description and got
> >>>    broken *recently* by another change (typically you "fix" the DT in
> >>>    Linux to comply with the bindings), then you get a warning that le=
ads
> >>>    you on the right path, you then update your bootloader if you can,
> >>>    but either way you add your machine compatible to the list of devi=
ces
> >>>    which need the early fix and your boot is fixed. =20
> >>
> >> This implies that we can proactively catch all the affected boards. I =
do
> >> not believe this is reasonable and because of that my comment before
> >> about creating regression to the users. =20
> >=20
> > I really don't understand the reasoning here.
> >=20
> > What I say is: let's fix the boards known to be incorrectly described
> > when we break them so they continue working with a broken firmware. =20
>=20
> The second part of the message, as far as I understand it, is "ignore pro=
blems this will cause to users of boards we do not know about, let them run=
 into unbootable systems after some linux kernel update,=20

Now you know what kernel update will break them, so you can prevent it
from happening.=20

For boards without even a dtsi in the kernel, should we care?

> and once they suffer through system recovery, make them add compatible
> string to the arch-side workaround".
>=20
> > What regression could this possibly bring? I don't care about catching
> > the 2k boards out there which work but wrongly describe their
> > partitions. If they work, they will continue working. =20
>=20
> Those boards would start failing once the Linux-side DT size-cells is cor=
rected.
>=20
> Also, this got missed in the previous discussion. If you use only board c=
ompatible string in arch-side workaround, the workaround would be applied e=
ven on systems with updated bootloaders, which is likely not what we want.

If the heuristics here needs to be improved somehow, let's discuss that ;)

> > You and Marek say: let's blindly always change a property in the DT, no
> > matter if the board is broken, even if we don't know if this is the
> > right thing to do, and apply this to the entire world. =20
>=20
> As far as I can tell, if we have partitions in the NAND controller node a=
nd size-cells=3D0, then the right thing to do is to override size-cells to =
1 , because partitions with size-cells=3D0 make no sense.

How do you know the firmware did not set #size-cell=3D0 on purpose to
avoid using the partitions? How would this be more stupid than
updating partitions without setting #size-cell to the right value? Can
you be so sure every board in the world will never do that? And how do
you handle the 64-bit case as well? You _do_no_know_ what applies in
all the cases, guessing is dangerous here, you'll just support new
broken cases or even break existing setups! What you do know however is
what applies for a number of cases your clearly identified. Applying
this logic to *all* cases in simply _broken_ and utterly stupid (tm). I
don't know how to express that so we stop bike-shedding.

> If the heuristics here needs to be improved somehow, let's discuss that.
>=20
> > But with this approach you're not worried about regressions.
> >=20
> > I am sorry it does not stand. =20
>=20
> [...]

Thanks,
Miqu=C3=A8l
