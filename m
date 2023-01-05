Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64CBB65EF9C
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 16:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjAEPDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 10:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbjAEPDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 10:03:12 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE60754719
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 07:03:10 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7D41FC000E;
        Thu,  5 Jan 2023 15:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1672930989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v/xznkGPQwTeG4bHpL4r891nCd3yrThL8ZKY9wDZ2Gg=;
        b=jm8r0jcpx9x34cK+o7W8v2T7DRCCDzjb5jqDjKb8cUdEuGXvxPCM2fjJ/QGGmXbrstl0t6
        mIzIxPlje+6fAQ87uUcwvjLlwIEegJ3Wc8mY2yPkEDz9mEnO3xf14Cc47ewoGKpp/p/WJd
        JlrCIN3+y1UYHo87o0gYBpBV1TLXuKcohTuZW1s1V4gJpC3fCilyT0BBZfxz/fF0rvAU8Z
        6UU7OUeq2UIb2SOi/z78UKCeeL7Tyel+QZnds+ZqLGr/EKGujWz8aW1plyRbuZUiu1rtgl
        u0VDRwAGexIMfJjrsp35JLs6RU0JtFyhvc8JQQg+hENz+1/PIISx4adctv1zPg==
Date:   Thu, 5 Jan 2023 16:03:05 +0100
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
Message-ID: <20230105160305.5b08f3e1@xps-13>
In-Reply-To: <f689c22c-dd93-8143-c730-2af4d472bd0f@denx.de>
References: <Y5wiAPvPU+YY39oX@francesco-nb.int.toradex.com>
        <6f5f5b32-d7fe-13cc-b52d-83a27bd9f53e@denx.de>
        <20221216120155.4b78e5cf@xps-13>
        <Y5xmi62hR6JeYUt1@francesco-nb.int.toradex.com>
        <20221216143720.3c8923d8@xps-13>
        <fb55a784-eda3-8916-1413-581b9436b3f2@denx.de>
        <20221216163501.1c2ace21@xps-13>
        <Y5ydGhn/qYUalamm@francesco-nb.int.toradex.com>
        <20230102104004.6abae6da@xps-13>
        <20230105123334.7f90c289@xps-13>
        <Y7bG7GFDMS6bmQ4d@francesco-nb.int.toradex.com>
        <f689c22c-dd93-8143-c730-2af4d472bd0f@denx.de>
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


marex@denx.de wrote on Thu, 5 Jan 2023 15:51:10 +0100:

> On 1/5/23 13:47, Francesco Dolcini wrote:
> > Hello Miquel, =20
>=20
> Hi,
>=20
> [...]
>=20
> >> Let's move forward with this. Let's assume my fears are baseless. We
> >> might consider the situation where someone tries to hide the partitions
> >> by setting #size-cell to 0 even wronger and too unlikely. Hopefully we
> >> will not break any other existing setups by applying an always-on fix.=
 =20
> >=20
> > Nice, good! =20
>=20
> Indeed
>=20
> >> I would still like to see U-Boot partitions handling evolve, at least:
> >> - fix #size-cells in fdt_fixup_mtd()
> >> - avoid the fdt_fixup_mtd() call from Collibri boards (ie. an example
> >>    that can be followed by the other users) =20
> >=20
> > Fine, I can do it.
> >=20
> > However I am just not 100% sure about your proposal, I wonder if we
> > should just deprecate this function or we should fix it. =20
>=20
> I would say fix it.

Well, I think these are two orthogonal changes. The function should be
deprecated *and* fixed for the existing users?

> > The exact end result will depend on the discussion with the U-Boot
> > folks, but I absolutely agree that the current situation needs to
> > change. I'll keep you in CC on those patches.
> >  =20
> >> On Linux side let's fix #size-cells like you proposed without filtering
> >> against a list of compatibles. We however need to improve the
> >> heuristics:
> >> - Do it only when there are partitions declared within a NAND
> >>    controller node.
> >> - Change the warning to avoid mentioning backward compatibility, just
> >>    mention this is utterly wrong and thus the value will be set to 1
> >>    instead of 0.
> >> - Mention in the comment above this only works on systems with <4GiB
> >>    chips.
> >> If you think about other conditions please feel free to add them.
> >>
> >> Do you concur? =20
> > Yes, I do agree. =20
>=20
> Same here, agreed, thanks.
>=20
> [...]


Thanks,
Miqu=C3=A8l
