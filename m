Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04103642BC4
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 16:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbiLEPaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 10:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbiLEP3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 10:29:43 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0857B1EAF5
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 07:28:49 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3246EE000D;
        Mon,  5 Dec 2022 15:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1670254128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sP26xDjMNjXwN9L7mGsr9oYGyxwn1e1sH95nLFtr/6U=;
        b=NFwxKSWb+bCfZmD3rIdek9EVGn6gVCmbl53Rfox4SRaUt8DTVzdE/7NtOstE6+B3SN6Wk7
        ut75j/yWfvol1ezJrspcvTWXsKkt4opVBSRwFhysjS0xFqZgR+K8GiE+PFQ2mw0sTZUVEv
        kJpuY1HYEf93asulKEQXy5miw9vxHcntW5g7y4jo9KHahSco8pR+1Na5QlS43Ni1CTAAWl
        ytcF1bRzBH1nJcxhdse38vK/4AVZafQ2irWVOkUHRvCpj8LMNeOBHtTlcS6Dx0+ITx3dX5
        FI5GbyXhABGajLmk0B4W2EKzNcoG8W50SQaBjNpSi6otfyW2Q4d/elgurGiXrQ==
Date:   Mon, 5 Dec 2022 16:28:44 +0100
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
Message-ID: <20221205162844.5dc28b8b@xps-13>
In-Reply-To: <Y43WSCsvfnfbcMPQ@francesco-nb.int.toradex.com>
References: <20221202115327.4475d3a2@xps-13>
        <Y4ngOaKq224LIpQc@francesco-nb.int.toradex.com>
        <20221202150556.14c5ae43@xps-13>
        <2b6fc52d-60b9-d0f4-ab91-4cf7a8095999@denx.de>
        <20221202160030.1b8d0b8a@xps-13>
        <223b7a4e-3aff-8070-7387-c77d2ded1dd6@denx.de>
        <20221202164904.08d750df@xps-13>
        <0503c46d-c385-74f5-f762-51d87a5ebaff@denx.de>
        <20221202174255.2c1cb2ff@xps-13>
        <Y4ozwovVIVhQHHkn@francesco-nb.int.toradex.com>
        <Y43WSCsvfnfbcMPQ@francesco-nb.int.toradex.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Francesco,

francesco@dolcini.it wrote on Mon, 5 Dec 2022 12:30:16 +0100:

> Hello Miquel
>=20
> On Fri, Dec 02, 2022 at 06:20:02PM +0100, Francesco Dolcini wrote:
> > On Fri, Dec 02, 2022 at 05:42:55PM +0100, Miquel Raynal wrote: =20
> > > Please also do it with the NAND chip described. If, when the NAND chip
> > > is described U-Boot tries to create partitions in the controller node,
> > > then the situation is even worse than I thought. But I believe =20
> >=20
> > It's like that for U-Boot older than v2022.04 ... and IMO we cannot
> > ignore it.
> >=20
> > Said that from the code U-Boot looks into a `partition{}` node only as a
> > direct child of the nand-controller, if there is a nand-chip in between
> > the nand-controller{} and the partitions{} it will just ignore it.
> >=20
> > I could try to see what it is doing exactly, but I would need a little
> > bit more time, I just tried changing the DTS as wrote I got a non
> > bootable system. =20
>=20
> If I have a nand-chip { partitions {} } described in the dts U-Boot
> (even the latest one) ignores it and generates the partition as child of
> the nand controller, the linux parser however see that partitions{}
> exists, even if empty, and ignore the partition directly defined as
> child of the nand controller.
>=20
> TL;DR: parser fails and boot fails according to that.

Yeah I get that. For me the longterm goal should be to just kill that
function. We have proper DT support today, Linux knows how to read the
mtdparts cmdline variable, so there is no need for anything else. I
guess in U-Boot we should just:
- warn users of this function that the function is deprecated and they
  should update their machine support
- just migrate to another solution on the colibri board

What do you think?

Thanks,
Miqu=C3=A8l
