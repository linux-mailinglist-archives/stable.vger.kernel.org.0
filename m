Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3A465E9FA
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 12:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbjAELd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 06:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbjAELdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 06:33:42 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC9711A27
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 03:33:40 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 115D520010;
        Thu,  5 Jan 2023 11:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1672918418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=czix4WDiCzpW3gGaXbhaVHkR8drxG1fsG3atEPzhoE8=;
        b=E98RZEZil+eOZnuosJNaIyf29QcPtWzut/isscPsVXu2r8jb+ceMRofLb2GJg9QwFchFCe
        Ri9pjxxDF568W8/pTwqkmArc4ylao8PityZ+Fo3jU0R/aOhIDWTkHqw+CZluG6+vaHftRx
        NTkfyrFPC15rbjBWQTnIN/aK9US9TJam8c5JEM0WANz8zSqnOx4RnUptxqwmjOC6dR+b/G
        KhtwNSsMZKa7aYoCUcGUoZc60wSBB+QPVLTU8AcXEQrkCldRFlrUoDZuDrdLdSx/xNyodI
        w8J7rIwdP6gSmXCUITvKx2Mn4LgWuyI0dPGrCkejB10l7RrbYPvi+K/mSphrTQ==
Date:   Thu, 5 Jan 2023 12:33:34 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Francesco Dolcini <francesco@dolcini.it>
Cc:     Marek Vasut <marex@denx.de>, Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is
 0
Message-ID: <20230105123334.7f90c289@xps-13>
In-Reply-To: <20230102104004.6abae6da@xps-13>
References: <Y5wiAPvPU+YY39oX@francesco-nb.int.toradex.com>
        <6f5f5b32-d7fe-13cc-b52d-83a27bd9f53e@denx.de>
        <20221216120155.4b78e5cf@xps-13>
        <Y5xmi62hR6JeYUt1@francesco-nb.int.toradex.com>
        <20221216143720.3c8923d8@xps-13>
        <fb55a784-eda3-8916-1413-581b9436b3f2@denx.de>
        <20221216163501.1c2ace21@xps-13>
        <Y5ydGhn/qYUalamm@francesco-nb.int.toradex.com>
        <20230102104004.6abae6da@xps-13>
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

Hi Francesco,

miquel.raynal@bootlin.com wrote on Mon, 2 Jan 2023 10:40:04 +0100:

> Hi Francesco,
>=20
> francesco@dolcini.it wrote on Fri, 16 Dec 2022 17:30:18 +0100:
>=20
> > On Fri, Dec 16, 2022 at 04:35:01PM +0100, Miquel Raynal wrote: =20
> > > marex@denx.de wrote on Fri, 16 Dec 2022 15:32:28 +0100:   =20
> > > > The second part of the message, as far as I understand it, is
> > > > "ignore problems this will cause to users of boards we do not know
> > > > about, let them run into unbootable systems after some linux kernel
> > > > update,    =20
> > >=20
> > > Now you know what kernel update will break them, so you can prevent it
> > > from happening.=20
> > >=20
> > > For boards without even a dtsi in the kernel, should we care?   =20
> >=20
> > Would caring for those boards not be just exact the same as caring for
> > some UEFI/ACPI mess for which no source code is normally available and
> > nobody really known at which point the various vendors have forked their
> > source code from some Intel or AMD or whatever reference code? =20
>=20
> I am sorry I don't know UEFI/ACPI well enough to discuss it.
>=20
> > IMHO we should care for the multiple reason I have already written in my
> > previous emails.
> >=20
> > And honestly, just as a side comment, I would feel way more happy
> > to know that the elevator control system in the elevator I use everyday
> > or the chemical industrial plan HMI next to my home is running an up to
> > date Linux system that is not affected by known security vulnerabilities
> > and they did stop updating it just because there was some random bug
> > preventing the updated kernel to boot and nobody had the time/skill to
> > investigate and fix it. [1] =20
>=20
> The issue comes from a very specific U-Boot function that should have
> never existed. I hope people working on chemical plants do not make
> use of these and will not disregard the "your DT is broken there [...]"
> warning we plan to add right before their updated board will fail. We
> are not living people in the dark, I agreed for a warning, but I don't
> think applying the proposed fix blindly is wise and future-proof.

Let's move forward with this. Let's assume my fears are baseless. We
might consider the situation where someone tries to hide the partitions
by setting #size-cell to 0 even wronger and too unlikely. Hopefully we
will not break any other existing setups by applying an always-on fix.

I would still like to see U-Boot partitions handling evolve, at least:
- fix #size-cells in fdt_fixup_mtd()
- avoid the fdt_fixup_mtd() call from Collibri boards (ie. an example
  that can be followed by the other users)

On Linux side let's fix #size-cells like you proposed without filtering
against a list of compatibles. We however need to improve the
heuristics:
- Do it only when there are partitions declared within a NAND
  controller node.
- Change the warning to avoid mentioning backward compatibility, just
  mention this is utterly wrong and thus the value will be set to 1
  instead of 0.
- Mention in the comment above this only works on systems with <4GiB
  chips.
If you think about other conditions please feel free to add them.

Do you concur?

Thanks,
Miqu=C3=A8l
