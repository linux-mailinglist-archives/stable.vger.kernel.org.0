Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6BF5630A1
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 11:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbiGAJsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 05:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236474AbiGAJsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 05:48:06 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1D076E8C
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 02:48:01 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 36B3A1BF210;
        Fri,  1 Jul 2022 09:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656668880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gyTxDhBLFffQoAQWpdfCYpKV1FuXiRgegvXhr3OWAi8=;
        b=DS5umpkO4oDSUNKUhvNDfOFicRck4JdLt3CN+ooR4SIUqXtUjEVMv33hVwrM7nT/qbDZM1
        udhIGliEnb/lPObkrApb2Z9jGSt8hTq4NQGRhjaypgeXwea4ILwEyJTKaei9dkPmXAni6F
        lzRgxsakdpcLRKwjm8zQy3Tk9LYyPa6jVhJtErdnSJFLwDYaJn3GeJIXUGCu6sEZl0gqzu
        3lekSwH9WRnKUHwdKJZTpyhsncAvZ93AQoC0d6++IAECLetM85H79Ug1zR2V0GlYA0ZNgS
        pfGVe47GaJXcMrD8n2LCi4+uelmc0qbgX+4YtHeGPYrXS/Xu+L32oPDaKNcA6A==
Date:   Fri, 1 Jul 2022 11:47:56 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-mtd@lists.infradead.org, Han Xu <han.xu@nxp.com>,
        kernel@pengutronix.de, stable@vger.kernel.org, richard@nod.at
Subject: Re: [PATCH] [REALLY REALLY BROKEN] mtd: rawnand: gpmi: Fix setting
 busy timeout setting
Message-ID: <20220701114756.467f8a03@xps-13>
In-Reply-To: <20220701091909.GE2387@pengutronix.de>
References: <20220614083138.3455683-1-s.hauer@pengutronix.de>
        <20220701091909.GE2387@pengutronix.de>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sascha,

+ Richard

s.hauer@pengutronix.de wrote on Fri, 1 Jul 2022 11:19:09 +0200:

> On Tue, Jun 14, 2022 at 10:31:38AM +0200, Sascha Hauer wrote:
> > The DEVICE_BUSY_TIMEOUT value is described in the Reference Manual as:
> >=20
> > | Timeout waiting for NAND Ready/Busy or ATA IRQ. Used in WAIT_FOR_READY
> > | mode. This value is the number of GPMI_CLK cycles multiplied by 4096.
> >=20
> > So instead of multiplying the value in cycles with 4096, we have to
> > divide it by that value. Use DIV_ROUND_UP to make sure we are on the
> > safe side, especially when the calculated value in cycles is smaller
> > than 4096 as typically the case.
> >=20
> > This bug likely never triggered because any timeout !=3D 0 usually will
> > do. In my case the busy timeout in cycles was originally calculated as
> > 2408, which multiplied with 4096 is 0x968000. The lower 16 bits were
> > taken for the 16 bit wide register field, so the register value was
> > 0x8000. With 2970bf5a32f0 ("mtd: rawnand: gpmi: fix controller timings
> > setting") however the value in cycles became 2384, which multiplied
> > with 4096 is 0x950000. The lower 16 bit are 0x0 now resulting in an
> > intermediate timeout when reading from NAND.
> >=20
> > Fixes: b1206122069aa ("mtd: rawnand: gpmi: use core timings instead of =
an empirical derivation")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >=20
> > Just a resend with +Cc: stable@vger.kernel.org
> >=20
> >  drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/n=
and/raw/gpmi-nand/gpmi-nand.c
> > index 0b68d05846e18..889e403299568 100644
> > --- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> > +++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> > @@ -890,7 +890,7 @@ static int gpmi_nfc_compute_timings(struct gpmi_nan=
d_data *this,
> >  	hw->timing0 =3D BF_GPMI_TIMING0_ADDRESS_SETUP(addr_setup_cycles) |
> >  		      BF_GPMI_TIMING0_DATA_HOLD(data_hold_cycles) |
> >  		      BF_GPMI_TIMING0_DATA_SETUP(data_setup_cycles);
> > -	hw->timing1 =3D BF_GPMI_TIMING1_BUSY_TIMEOUT(busy_timeout_cycles * 40=
96);
> > +	hw->timing1 =3D BF_GPMI_TIMING1_BUSY_TIMEOUT(DIV_ROUND_UP(busy_timeou=
t_cycles, 4096)); =20
>=20
> This patch is broken. The change itself is fine, but busy_timeout_cycles
> is calculated wrong.
>=20
> busy_timeout_cycles is calculated based on sdr->tR_max which is the page
> read time. This timeout is also used for the page program and block
> erase operations which have orders of magnitude bigger timeouts. This
> means with this patch the controller times out on pages programs and
> block erase operations. With the current code this timeout will be
> silent as the timeout interrupt is not active.
>=20
> ** THIS PATCH WILL CAUSE DATA LOSS ON YOUR NAND!! **
>=20
> Fortunately this patch hasn't been included in any mainline release, but
> unfortunately it showed up in several stable kernels. Don't use
> v5.4.202, v5.10.127, v5.15.51 or v5.18.8 on i.MX[678] or i.MX28 boards
> with NAND.
>=20
> I am sorry for the trouble I have likely caused. I am working on a fix
> and will post it later the day.

Oh crap. Just for the record I'm leaving for several weeks today, so
please don't forget to keep Richard in copy, he will apply the fix of
the fix when ready.

Richard, looks like a pretty busy cycle, sorry for all this trouble :-/

Thanks,
Miqu=C3=A8l
