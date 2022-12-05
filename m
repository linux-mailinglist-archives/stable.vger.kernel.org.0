Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFA96429D4
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 14:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiLENt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 08:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiLENtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 08:49:25 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5383711813
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 05:49:24 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 877B92001A;
        Mon,  5 Dec 2022 13:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1670248162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3vlDqhiuz5BOtb58kV/bXhHdfpCf7hpK9ErgXjz36wI=;
        b=ZbhwzuX1eagbTfBT6a6b3hACbNnAaJ1eqrVSS5OEJbPhEoXPF20h1x03YgnAFqMj/rbas8
        lc1x4b90np8c+lLaaMknk3VYTcP8zZYxuOUlMRXbXtw81TscUvl0i+wwlNXL9ZFRkv9zKp
        fZ3FN1ez0jW6MQd+NoKmCx94JAY5xWQvb3Sp5DUHXdPnNIJWcKQkqx5O7UDqMHOkvaNlrG
        C3yG2FGbHbHaTSnss0lifKE9I4PJdvdxoWi7IPtoV7DdqtjvxU+X/1VVs5WklPItImnchA
        ux+PH9jfTcAMwCB9ZMgpWs9umkLRR7ADIsoubNd2plMtx5Ik5k82dR8JUmQrwA==
Date:   Mon, 5 Dec 2022 14:49:17 +0100
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
Message-ID: <20221205144917.6514168a@xps-13>
In-Reply-To: <Y43VdPftDbq6cD2L@francesco-nb.int.toradex.com>
References: <20221202150556.14c5ae43@xps-13>
        <2b6fc52d-60b9-d0f4-ab91-4cf7a8095999@denx.de>
        <20221202160030.1b8d0b8a@xps-13>
        <223b7a4e-3aff-8070-7387-c77d2ded1dd6@denx.de>
        <20221202164904.08d750df@xps-13>
        <0503c46d-c385-74f5-f762-51d87a5ebaff@denx.de>
        <20221202174255.2c1cb2ff@xps-13>
        <e80377c9-1542-d47d-6d35-2efdc15bcbf8@denx.de>
        <20221202175730.231d75d5@xps-13>
        <7afd364c-33b8-38a9-65a6-015b4360db6b@denx.de>
        <Y43VdPftDbq6cD2L@francesco-nb.int.toradex.com>
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

francesco@dolcini.it wrote on Mon, 5 Dec 2022 12:26:44 +0100:

> On Fri, Dec 02, 2022 at 06:08:22PM +0100, Marek Vasut wrote:
> > But here I would say this is a firmware bug and it might have to be han=
dled
> > like a firmware bug, i.e. with fixup in the partition parser. I seem to=
 be
> > changing my opinion here again. =20
>=20
> I was thinking at this over the weekend, and I came to the following
> ideas:
>=20
>  - we need some improvement on the fixup we already have in the
>    partition parser. We cannot ignore the fdt produced by U-Boot - as
>    bad as it is.
>  - the proposed fixup is fine for the immediate need, but it is
>    not going to be enough to cover the general issue with the U-Boot
>    generated partitions. U-Boot might keep generating partitions as direct
>    child of the nand controller even when a partitions{} node is
>    available. In this case the current parser just fails since it looks
>    only into it and it will find it empty.
>  - the current U-Boot only handle partitions{} as a direct child of the
>    nand-controller, the nand-chip is ignored. This is not the way it is
>    supposed to work. U-Boot code would need to be improved.

I've been thinking about it this weekend as well and the current fix
which "just set" s_cell to 1 seems risky for me, it is typically the
type of quick & dirty fix that might even break other board (nobody
knew that U-Boot current logic expected #size-cells to be set in the
DT, what if another "broken" DT expects the opposite...), not
mentioning potential issues with big storages (> 4GiB).

All in all, I really think we should revert the DT change now, reverting
as little to no drawbacks besides a dt_binding_check warning and gives
us time to deal with it properly (both in U-Boot and Linux).

> With all of that said I think that Miquel is right
>=20
> > When a patch breaks a board and there is no straight fix, you revert
> > it, then you think harder. That's what I am saying. This is a temporary
> > solution. =20
>=20
> ?
>=20
> Francesco
>=20
>=20

Thanks,
Miqu=C3=A8l
