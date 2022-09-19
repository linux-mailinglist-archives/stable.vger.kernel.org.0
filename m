Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487895BD0EB
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 17:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiISP3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 11:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiISP3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 11:29:36 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A316298;
        Mon, 19 Sep 2022 08:29:33 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 63EABC000F;
        Mon, 19 Sep 2022 15:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1663601372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I4z0wAfhWmBzoy4sUboCNYs+LN4FIyNd2HWuXMFVd9g=;
        b=gJd8bul7ZIQzyBFirA9lSz/50UmUcod3OU/y7+q91EGzV+8Wg/xDxxqhCKlemJKa8M9Zs1
        7j9ncEw7AgQyGzQtrUTU1o55Dy+PG2hWXAvymqy3jMs1o9AtZ2ZQGb8NThOgjF/Dtx1SaZ
        vhkebnVVyRxyf/Be2NH3jsM+gvmYsmgzbzDyAYnh0lRpi+zdNG2sHWG8+C+zEcMtnymozs
        hseXuXkuRhSRXQlyeL7OKv8bECA7JM7YTYvYJKPNH71NgcxJojXRVV9k18EFXykWqqgsyR
        ANWAX6Ao//H8hBB//olHkgW7y5GxaT+tVlliQu5kVziFmK0Wu2AfMYpLt2LiVA==
Date:   Mon, 19 Sep 2022 17:29:28 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     <Tudor.Ambarus@microchip.com>
Cc:     <richard@nod.at>, <vigneshr@ti.com>, <peda@axentia.se>,
        <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Claudiu.Beznea@microchip.com>, <bbrezillon@kernel.org>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] mtd: rawnand: atmel: Unmap streaming DMA mappings
Message-ID: <20220919172928.6f918ab2@xps-13>
In-Reply-To: <86158844-b314-bee8-c5b8-0b757c6b6ab0@microchip.com>
References: <20220728074014.145406-1-tudor.ambarus@microchip.com>
        <86158844-b314-bee8-c5b8-0b757c6b6ab0@microchip.com>
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

Hello Tudor,

Tudor.Ambarus@microchip.com wrote on Wed, 7 Sep 2022 09:06:39 +0000:

> On 7/28/22 10:40, Tudor Ambarus wrote:
> > Every dma_map_single() call should have its dma_unmap_single() counterp=
art,
> > because the DMA address space is a shared resource and one could render=
 the
> > machine unusable by consuming all DMA addresses.
> >=20
> > Cc: stable@vger.kernel.org
> > Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
> > Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> > ---
> >  drivers/mtd/nand/raw/atmel/nand-controller.c | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c b/drivers/mtd=
/nand/raw/atmel/nand-controller.c
> > index 6ef14442c71a..330d2dafdd2d 100644
> > --- a/drivers/mtd/nand/raw/atmel/nand-controller.c
> > +++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
> > @@ -405,6 +405,7 @@ static int atmel_nand_dma_transfer(struct atmel_nan=
d_controller *nc,
> > =20
> >  	dma_async_issue_pending(nc->dmac);
> >  	wait_for_completion(&finished);
> > +	dma_unmap_single(nc->dev, buf_dma, len, dir);
> > =20
> >  	return 0;
> >   =20
>=20
> Hi, Richard, Miquel,
>=20
> Would you please consider to include this patch in your queue?

I'm catching up only now so as we're at -rc6 and I want things to lay a
bit in -next I don't plan to send a Fixes PR, all the fixes
exceptionally will go through the usual PR as anyway they won't be
ready before the merge window opens.

> If yes, please add the following tag, it solves a regression:
>=20
> Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@a=
xentia.se/

Ok.

Thanks,
Miqu=C3=A8l
