Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3E7598F86
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 23:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241929AbiHRVZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 17:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347037AbiHRVZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 17:25:16 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14649EA160;
        Thu, 18 Aug 2022 14:17:26 -0700 (PDT)
Received: from nicolas-tpx395.localdomain (192-222-136-102.qc.cable.ebox.net [192.222.136.102])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: nicolas)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 10B05660037D;
        Thu, 18 Aug 2022 22:17:11 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1660857433;
        bh=KE0bQCqNtR+z+ksSI4I4sg0fOlUJH2F/9l/R0xeYO+U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DQfoSdbAkNSPx81fc4H4bxwQbs7bvPPoYktXNZCJ7bB2f3xrzadMZxR2D/0hk/+Jq
         UbhfJZsWzD4NfTQ4mKM4P/320wJoRYHOIuMWn8/rb6sIc+weuRBCbe6lUBrC9QkJD+
         Sp6s34Ae66PjHnspNfxF08vtHrwOLIBUnDJx/IOyFIkki58/PTI0d4IAHd8UxYI0pg
         irPIPFf6QODS+LuzvfkhTzDlu/wh5rnHeZe76qBx4nXPHBDcWAvmVRoAA5SiYLHV64
         prkIEfGfgAu1weyyppxzD9T7wuTrrLDD7FE7EApyRpwysOdGJG2aPQBg41t7bKPAFc
         5JbRy9nso92tA==
Message-ID: <212924d309cb8594fc61e1c5bb2ad07d5bb9312d.camel@collabora.com>
Subject: Re: [PATCH v1 3/3] media: cedrus: Fix endless loop in
 cedrus_h265_skip_bits()
From:   Nicolas Dufresne <nicolas.dufresne@collabora.com>
To:     Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        linux-media@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>
Cc:     kernel@collabora.com, stable@vger.kernel.org,
        linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Date:   Thu, 18 Aug 2022 17:17:02 -0400
In-Reply-To: <2182ae07-4c0a-5937-7acc-3fad68d28baa@collabora.com>
References: <20220818203308.439043-1-nicolas.dufresne@collabora.com>
         <20220818203308.439043-4-nicolas.dufresne@collabora.com>
         <2182ae07-4c0a-5937-7acc-3fad68d28baa@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le jeudi 18 ao=C3=BBt 2022 =C3=A0 23:39 +0300, Dmitry Osipenko a =C3=A9crit=
=C2=A0:
> On 8/18/22 23:33, Nicolas Dufresne wrote:
> > From: Dmitry Osipenko <dmitry.osipenko@collabora.com>
> >=20
> > The busy status bit may never de-assert if number of programmed skip
> > bits is incorrect, resulting in a kernel hang because the bit is polled
> > endlessly in the code. Fix it by adding timeout for the bit-polling.
> > This problem is reproducible by setting the data_bit_offset field of
> > the HEVC slice params to a wrong value by userspace.
> >=20
> > Cc: stable@vger.kernel.org
> > Reported-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
> > Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > ---
> >  drivers/staging/media/sunxi/cedrus/cedrus_h265.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c b/drivers=
/staging/media/sunxi/cedrus/cedrus_h265.c
> > index f703c585d91c5..f0bc118021b0a 100644
> > --- a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
> > @@ -227,6 +227,7 @@ static void cedrus_h265_pred_weight_write(struct ce=
drus_dev *dev,
> >  static void cedrus_h265_skip_bits(struct cedrus_dev *dev, int num)
> >  {
> >  	int count =3D 0;
> > +	u32 reg;
>=20
> This "reg" variable isn't needed anymore after switching to
> cedrus_wait_for(). Sorry, I missed it :)

Good catch thanks, will fix.

>=20
> >  	while (count < num) {
> >  		int tmp =3D min(num - count, 32);
> > @@ -234,8 +235,9 @@ static void cedrus_h265_skip_bits(struct cedrus_dev=
 *dev, int num)
> >  		cedrus_write(dev, VE_DEC_H265_TRIGGER,
> >  			     VE_DEC_H265_TRIGGER_FLUSH_BITS |
> >  			     VE_DEC_H265_TRIGGER_TYPE_N_BITS(tmp));
> > -		while (cedrus_read(dev, VE_DEC_H265_STATUS) & VE_DEC_H265_STATUS_VLD=
_BUSY)
> > -			udelay(1);
> > +
> > +		if (cedrus_wait_for(dev, VE_DEC_H265_STATUS, VE_DEC_H265_STATUS_VLD_=
BUSY))
> > +			dev_err_ratelimited(dev->dev, "timed out waiting to skip bits\n");
> > =20
> >  		count +=3D tmp;
> >  	}
>=20
>=20

