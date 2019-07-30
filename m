Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1AC07AAAA
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 16:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbfG3OOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 10:14:53 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40422 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727338AbfG3OOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 10:14:53 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: sre)
        with ESMTPSA id 06DF828A5E8
Received: by earth.universe (Postfix, from userid 1000)
        id 27ED63C0943; Tue, 30 Jul 2019 16:14:48 +0200 (CEST)
Date:   Tue, 30 Jul 2019 16:14:48 +0200
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.2 048/215] drm/omap: dont check dispc timings for DSI
Message-ID: <20190730141448.hvmkffa4s23pweci@earth.universe>
References: <20190729190739.971253303@linuxfoundation.org>
 <20190729190748.832081009@linuxfoundation.org>
 <20190730113751.GB21815@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2voqpcm7kqxghyvb"
Content-Disposition: inline
In-Reply-To: <20190730113751.GB21815@amd>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2voqpcm7kqxghyvb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 30, 2019 at 01:37:51PM +0200, Pavel Machek wrote:
> On Mon 2019-07-29 21:20:44, Greg Kroah-Hartman wrote:
> > [ Upstream commit ad9df7d91b4a6e8f4b20c2bf539ac09b3b2ad6eb ]
> >=20
> > While most display types only forward their VM to the DISPC, this
> > is not true for DSI. DSI calculates the VM for DISPC based on its
> > own, but it's not identical. Actually the DSI VM is not even a valid
> > DISPC VM making this check fail. Let's restore the old behaviour
> > and avoid checking the DISPC VM for DSI here.
> >=20
> > Fixes: 7c27fa57ef31 ("drm/omap: Call dispc timings check operation dire=
ctly")
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> > Tested-by: Tony Lindgren <tony@atomide.com>
> > Tested-by: Pavel Machek <pavel@ucw.cz>
> > Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> > Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>=20
> Not sure if this is good idea for stable. IIRC there's series of
> patches to enable display on droid4 (etc), which is useful, but this
> patch is not going to do any good on its own.

It does not hurt to have it. I know that some people have out of
tree omapdrm DSI drivers and those also need this regression fix.

-- Sebastian

>=20
> 								Pavel
>=20
> >  drivers/gpu/drm/omapdrm/omap_crtc.c | 18 ++++++++++++++----
> >  1 file changed, 14 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/gpu/drm/omapdrm/omap_crtc.c b/drivers/gpu/drm/omap=
drm/omap_crtc.c
> > index 8712af79a49c..4c43dd282acc 100644
> > --- a/drivers/gpu/drm/omapdrm/omap_crtc.c
> > +++ b/drivers/gpu/drm/omapdrm/omap_crtc.c
> > @@ -384,10 +384,20 @@ static enum drm_mode_status omap_crtc_mode_valid(=
struct drm_crtc *crtc,
> >  	int r;
> > =20
> >  	drm_display_mode_to_videomode(mode, &vm);
> > -	r =3D priv->dispc_ops->mgr_check_timings(priv->dispc, omap_crtc->chan=
nel,
> > -					       &vm);
> > -	if (r)
> > -		return r;
> > +
> > +	/*
> > +	 * DSI might not call this, since the supplied mode is not a
> > +	 * valid DISPC mode. DSI will calculate and configure the
> > +	 * proper DISPC mode later.
> > +	 */
> > +	if (omap_crtc->pipe->output->next =3D=3D NULL ||
> > +	    omap_crtc->pipe->output->next->type !=3D OMAP_DISPLAY_TYPE_DSI) {
> > +		r =3D priv->dispc_ops->mgr_check_timings(priv->dispc,
> > +						       omap_crtc->channel,
> > +						       &vm);
> > +		if (r)
> > +			return r;
> > +	}
> > =20
> >  	/* Check for bandwidth limit */
> >  	if (priv->max_bandwidth) {
>=20
> --=20
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/b=
log.html



--2voqpcm7kqxghyvb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAl1AUNQACgkQ2O7X88g7
+poS5g//YmueoR3bKp2q+77bUwb7W+OhoUliO31RrKvQ/d5HaNu1HwV9XqUJ9QrB
ujOV8iozVKup60KZDYSuQ2L3CAocmeIx3dTl4BfWENnhJlBGb3yZF8W9JkC+dKiq
rIFvgSZZh+Jvyt1SffYG+TW9xEK7jTBDAnu0UgR6JU/79RRBrBA6lvNkYrNojV4o
DBGUaepe0wR/im0xGxlJYVuwruvDOKD8BRrV1V1JajctFx/pZOGZLX4qjgtQnPG1
dxp5i7l9j8LKpBwD6SrXg1hJr/e6H+n9Sh04iEVy7WRrZSSEL/UlX+CO/d0LVR3R
mOJcK9bC687HvGovK57Ru9BgObeypGQoLbUn1nU3O9A2jNiLyi5zTTzBrFqPuIhv
AaqoYAmnM0Nr3Hb6UJg2dvpGW4HgTu4mgsS1CFv7w/Ca4jE7PSv2we3t9C7T+rUe
jnRF6Ar27dI5TePYAhX2OpA34oEKgDOcJcO6hrrDeoTJfc73dKm4/ZdKT1V5NvLr
C5pVCsXXqaMM0w1XJlGWskC0e2I0WBarGroA/JXfia7HZOgN5uqlAyFHF9Vf1zKG
tH+pDSW2BzK9wQmvdkjyL/RmAE7ehwOIY3bU2wvrz5vTfH0TSbzIBitml7u5iT8Q
8oy8QOK3uo/ikKESp/2x5cRnJ8YSHcSct2itlXVAkpkxhBDTSLg=
=8pit
-----END PGP SIGNATURE-----

--2voqpcm7kqxghyvb--
