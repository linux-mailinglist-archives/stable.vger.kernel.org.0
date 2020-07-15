Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D73F220E73
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 15:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgGONvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 09:51:52 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:39503 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729086AbgGONvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 09:51:52 -0400
X-Originating-IP: 93.29.109.196
Received: from aptenodytes (196.109.29.93.rev.sfr.net [93.29.109.196])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id B7D4820008;
        Wed, 15 Jul 2020 13:51:46 +0000 (UTC)
Date:   Wed, 15 Jul 2020 15:51:45 +0200
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, stable@vger.kernel.org,
        kernel@collabora.com, Maxime Ripard <mripard@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: cedrus: Propagate OUTPUT resolution to CAPTURE
Message-ID: <20200715135145.GA2019248@aptenodytes>
References: <20200514153903.341287-1-nicolas.dufresne@collabora.com>
 <3c8a235ebb0bf76bcffeb8c6b983cd4c95d77459.camel@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <3c8a235ebb0bf76bcffeb8c6b983cd4c95d77459.camel@collabora.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed 15 Jul 20, 08:57, Ezequiel Garcia wrote:
> It seems this one felt thru the cracks. Sorry for the delay.
>=20
> On Thu, 2020-05-14 at 11:39 -0400, Nicolas Dufresne wrote:
> > As per spec, the CAPTURE resolution should be automatically set based on
> > the OTUPUT resolution. This patch properly propagate width/height to the
> > capture when the OUTPUT format is set and override the user provided
> > width/height with configured OUTPUT resolution when the CAPTURE fmt is
> > updated.
> >=20
> > This also prevents userspace from selecting a CAPTURE resolution that is
> > too small, avoiding unwanted page faults.
> >=20
> > Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
>=20
> This looks correct.

Looks like there's no issue with alignment (that will get applied as well),
which was a possible concern.

Thanks for reviewing!

Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
>=20
> Thanks,
> Ezequiel
>=20
> > ---
> >  drivers/staging/media/sunxi/cedrus/cedrus_video.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/driver=
s/staging/media/sunxi/cedrus/cedrus_video.c
> > index 16d82309e7b6..a6d6b15adc2e 100644
> > --- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> > @@ -247,6 +247,8 @@ static int cedrus_try_fmt_vid_cap(struct file *file=
, void *priv,
> >  		return -EINVAL;
> > =20
> >  	pix_fmt->pixelformat =3D fmt->pixelformat;
> > +	pix_fmt->width =3D ctx->src_fmt.width;
> > +	pix_fmt->height =3D ctx->src_fmt.height;
> >  	cedrus_prepare_format(pix_fmt);
> > =20
> >  	return 0;
> > @@ -319,11 +321,14 @@ static int cedrus_s_fmt_vid_out(struct file *file=
, void *priv,
> >  		break;
> >  	}
> > =20
> > -	/* Propagate colorspace information to capture. */
> > +	/* Propagate format information to capture. */
> >  	ctx->dst_fmt.colorspace =3D f->fmt.pix.colorspace;
> >  	ctx->dst_fmt.xfer_func =3D f->fmt.pix.xfer_func;
> >  	ctx->dst_fmt.ycbcr_enc =3D f->fmt.pix.ycbcr_enc;
> >  	ctx->dst_fmt.quantization =3D f->fmt.pix.quantization;
> > +	ctx->dst_fmt.width =3D ctx->src_fmt.width;
> > +	ctx->dst_fmt.height =3D ctx->src_fmt.height;
> > +	cedrus_prepare_format(&ctx->dst_fmt);
> > =20
> >  	return 0;
> >  }
> > --=20
> > 2.26.2
> >=20
> >=20
>=20
>=20

--=20
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAl8PCfAACgkQ3cLmz3+f
v9Hn4Af9EzN5gnaUQKr1CzXC653L4rnjwlGYHhQ1ctQj7EtF8LgF6iugRO1UMIF9
nKLxp3yyElrKlWAE3DpaVDmb4cilu8IzSeO3T6f9XtUwaAhJcsmP+QEeQ3QLT2R/
yclIp4Nv7u93jYLvPDXKLf4BPQ1Gjrrhh1R9fEda+GV/lVkaY6jzFBoGwPRCr7Ix
t0FWyHNrOH+FfAAWm+gmqWB4Molnl3cd1vYcvWBbM8Yf7VbDL3DyvUA6NhUCcs64
f5OUBpJVGArH7HxL/sHB7pmqG4pcsQeljXE1GPuV77+/AJ/AlvpVslpWyC4sOx1C
PdDbVhi/dtKugkhQNAtUN2fnmFHRAg==
=49po
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
