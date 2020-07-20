Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C046226861
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388351AbgGTQSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387706AbgGTQNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 12:13:05 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5A4C061794;
        Mon, 20 Jul 2020 09:13:05 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: nicolas)
        with ESMTPSA id 2FEF6290061
Message-ID: <77cc8d67c6016c6cefb3d2b93ae212cc02bac064.camel@collabora.com>
Subject: Re: [PATCH 1/2] media: coda: Fix reported H264 profile
From:   Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Robert Beckett <bob.beckett@collabora.com>,
        kernel@collabora.com, stable@vger.kernel.org
Date:   Mon, 20 Jul 2020 12:13:00 -0400
In-Reply-To: <51175cb496644aaa5d5004630925ead4c6f0ddc7.camel@pengutronix.de>
References: <20200717034923.219524-1-ezequiel@collabora.com>
         <51175cb496644aaa5d5004630925ead4c6f0ddc7.camel@pengutronix.de>
Organization: Collabora
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-yA5jdyyuXrf/LlHFsfE9"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-yA5jdyyuXrf/LlHFsfE9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 17 juillet 2020 =C3=A0 10:14 +0200, Philipp Zabel a =C3=A9crit =
:
> On Fri, 2020-07-17 at 00:49 -0300, Ezequiel Garcia wrote:
> > From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> >=20
> > The CODA960 manual states that ASO/FMO features of baseline are not
> > supported, so for this reason this driver should only report
> > constrained baseline support.
>=20
> I know the encoder doesn't support this, but is this also true of the
> decoder? The i.MX6DQ Reference Manual explicitly lists H.264/AVC decoder
> support for both baseline profile and constrained base line profile.
>=20
> > This fixes negotiation issue with constrained baseline content
> > on GStreamer 1.17.1.
> >=20
> > Cc: stable@vger.kernel.org
> > Fixes: 42a68012e67c2 ("media: coda: add read-only h.264 decoder profile=
/level controls")
> > Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> >  drivers/media/platform/coda/coda-common.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/=
platform/coda/coda-common.c
> > index 3ab3d976d8ca..c641d1608825 100644
> > --- a/drivers/media/platform/coda/coda-common.c
> > +++ b/drivers/media/platform/coda/coda-common.c
> > @@ -2335,8 +2335,8 @@ static void coda_encode_ctrls(struct coda_ctx *ct=
x)
> >  		V4L2_CID_MPEG_VIDEO_H264_CHROMA_QP_INDEX_OFFSET, -12, 12, 1, 0);
> >  	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
> >  		V4L2_CID_MPEG_VIDEO_H264_PROFILE,
> > -		V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE, 0x0,
> > -		V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE);
> > +		V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE, 0x0,
> > +		V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE);
>=20
> Encoder support is listed as baseline, not constrained baseline, in the
> manual, but the SPS NALs produced by the encoder start with:
>   00 00 00 01 67 42 40
>                     ^
> so that is profile_idc=3D66, constraint_set1_flag=3D=3D1, constrained bas=
eline
> indeed. I think this change is correct.
>=20
> >  	if (ctx->dev->devtype->product =3D=3D CODA_HX4 ||
> >  	    ctx->dev->devtype->product =3D=3D CODA_7541) {
> >  		v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
> > @@ -2417,7 +2417,7 @@ static void coda_decode_ctrls(struct coda_ctx *ct=
x)
> >  	ctx->h264_profile_ctrl =3D v4l2_ctrl_new_std_menu(&ctx->ctrls,
> >  		&coda_ctrl_ops, V4L2_CID_MPEG_VIDEO_H264_PROFILE,
> >  		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH,
> > -		~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE) |
> > +		~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE) |
> >  		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_MAIN) |
> >  		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_HIGH)),
> >  		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH);
>=20
> I'm not sure about this one.

Indeed, the decoder does support ASO/FMO, assuming the extra buffer
space is allocated as per the documentation (says that slice_save_size
should be the max_width * max_height * 3 / 4). Did you have that
implemented ? If not, I'd keep that patch, but add a comment to explain
that it can be enabled later.

>=20
> regards
> Philipp

--=-yA5jdyyuXrf/LlHFsfE9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXxXCjAAKCRBxUwItrAao
HDpKAJ9xt9juXaoVD+M9EL8J6QYMeyAXoQCfb3uh0OjL8388yFy/Mb2pLtk7RYg=
=IKyR
-----END PGP SIGNATURE-----

--=-yA5jdyyuXrf/LlHFsfE9--

