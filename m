Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C1C6E257C
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 16:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjDNOU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 10:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjDNOUZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 10:20:25 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05431F2
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 07:20:13 -0700 (PDT)
Received: (Authenticated sender: paul.kocialkowski@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 180301BF20E;
        Fri, 14 Apr 2023 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1681482012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Endbai5Wtr/9vuFfP6fUW/UnSHOPzkJ5+aimTNOZOxw=;
        b=hMTPPdbfZaB9+acnifekGW0jRfzKK7bjGLTlElyEb9SY+hHftJquSHeaZPIxjR290reCla
        MXyp2dgblj7PTn9ncfgJ9ruHbGKwgSM383sCCkxU3c0xuk0ltkS/m6UQNQB7cvxM+pXr/F
        eDZDt2fqVhf97tn3C9gkgGXVBit8iOiKOmAG0Dn0wy7xgXIFPBztJ5BtcDbo1mpwsvkbx/
        rkflB5Z/wFeE26zAqdW4rVXz24B8uDHAFkcBleb3CiodLmOeJxPAA2EyHN2MjRqy3mRkw8
        aWs7eeZrjk6l4prMfbWBAkpqqd2Z0CoN7raluPrIfRMTDOEx0h7eij++FlGoXQ==
Date:   Fri, 14 Apr 2023 16:20:10 +0200
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Chris Morgan <macroalpha82@gmail.com>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
        Sandy Huang <hjc@rock-chips.com>,
        dri-devel@lists.freedesktop.org,
        linux-rockchip@lists.infradead.org,
        Michael Riesch <michael.riesch@wolfvision.net>,
        kernel@pengutronix.de, stable@vger.kernel.org
Subject: Re: [PATCH] drm/rockchip: vop2: fix suspend/resume
Message-ID: <ZDlhGv0seSoxFlJ5@aptenodytes>
References: <20230413144347.3506023-1-s.hauer@pengutronix.de>
 <64381f5b.050a0220.1533e.41e2@mx.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="F/Caj+68jhUiV1a5"
Content-Disposition: inline
In-Reply-To: <64381f5b.050a0220.1533e.41e2@mx.google.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--F/Caj+68jhUiV1a5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu 13 Apr 23, 10:27, Chris Morgan wrote:
> On Thu, Apr 13, 2023 at 04:43:47PM +0200, Sascha Hauer wrote:
> > During a suspend/resume cycle the VO power domain will be disabled and
> > the VOP2 registers will reset to their default values. After that the
> > cached register values will be out of sync and the read/modify/write
> > operations we do on the window registers will result in bogus values
> > written. Fix this by re-initializing the register cache each time we
> > enable the VOP2. With this the VOP2 will show a picture after a
> > suspend/resume cycle whereas without this the screen stays dark.

I was actually tracking the very same bug this week!

Thanks a lot for fixing this, it would certainly have taken me a while to
think about regmap cache maintenance. Good thinking :)

Your patch fixes the issue on my side but I have a suggestion below:

> > Fixes: 604be85547ce4 ("drm/rockchip: Add VOP2 driver")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >  drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >=20
> > diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu=
/drm/rockchip/rockchip_drm_vop2.c
> > index ba3b817895091..d9daa686b014d 100644
> > --- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
> > +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
> > @@ -215,6 +215,8 @@ struct vop2 {
> >  	struct vop2_win win[];
> >  };
> > =20
> > +static const struct regmap_config vop2_regmap_config;
> > +
> >  static struct vop2_video_port *to_vop2_video_port(struct drm_crtc *crt=
c)
> >  {
> >  	return container_of(crtc, struct vop2_video_port, crtc);
> > @@ -839,6 +841,12 @@ static void vop2_enable(struct vop2 *vop2)
> >  		return;
> >  	}
> > =20
> > +	ret =3D regmap_reinit_cache(vop2->map, &vop2_regmap_config);
> > +	if (ret) {
> > +		drm_err(vop2->drm, "failed to reinit cache: %d\n", ret);
> > +		return;
> > +	}

It seems that regmap has regcache_mark_dirty() for this purpose, which is
perhaps more adapted than reinitializing cache (unless I'm missing somethin=
g).
Note that I haven't tested it at this point.

Cheers,

Paul

> >  	if (vop2->data->soc_id =3D=3D 3566)
> >  		vop2_writel(vop2, RK3568_OTP_WIN_EN, 1);
> > =20
> > --=20
> > 2.39.2
> >=20
>=20
> I confirmed this works on my Anbernic RG353P which uses the rk3566 SOC.
> Before applying the patch I displayed a color pattern with modetest
> before suspend and it appeared correctly. Then I suspended and resumed
> the device, attempted to display the same color pattern, and only got
> a single pixel on an otherwise blank display. After applying the patch
> I performed the same test and the color pattern appeared correctly
> both before and after suspend (and the display was no longer blank
> after resume from suspend).
>=20
> Tested-by: Chris Morgan <macromorgan@hotmail.com>

--=20
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

--F/Caj+68jhUiV1a5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAmQ5YRoACgkQ3cLmz3+f
v9HdZQgAmtDCuSSWB0Bgv4bn8Ph09JaLozvmj9xSRJJG9H0RozDSKbfDm8UT+FtP
c8MIfxRr+Y9UH1/VoNuII0l0cdVEQ370/Fu3uAUGkw04+rthZIdB9YK+EeJfBzsX
Xp7JhOzmHjA0tmgAxQ2/d4fe3uMowS+R8dfssURA4eWjjSezPIeF8Obv/Qofm/93
1+iq6KzPSTUHVlrseEN1ULWU7m3ZVul6B1CKhuKdEJZ+0vgZC32ieEOciwH/V9G0
+d6RwA0MqbuPtduj1vXyCk2jQ9xeOPgRiNMUaT4YE0CXc5+L0OjFK1SBIVjB0bsw
jr/LZxrwHNIxuq9BCtAemQBDgbpimg==
=iJZJ
-----END PGP SIGNATURE-----

--F/Caj+68jhUiV1a5--
