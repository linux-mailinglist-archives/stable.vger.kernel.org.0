Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652BE22673A
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387593AbgGTQJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:09:54 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57442 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387587AbgGTQJx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 12:09:53 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: nicolas)
        with ESMTPSA id 411CC295F35
Message-ID: <4fee7fb9ded19cb9dab58561396e6f30393e42fa.camel@collabora.com>
Subject: Re: [PATCH 2/2] media: coda: Add more H264 levels for CODA960
From:   Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Robert Beckett <bob.beckett@collabora.com>,
        kernel@collabora.com, stable@vger.kernel.org
Date:   Mon, 20 Jul 2020 12:09:47 -0400
In-Reply-To: <05184a7c923c7e2aacca9da2bafe338ff5a7c16d.camel@pengutronix.de>
References: <20200717034923.219524-1-ezequiel@collabora.com>
                 <20200717034923.219524-2-ezequiel@collabora.com>
         <05184a7c923c7e2aacca9da2bafe338ff5a7c16d.camel@pengutronix.de>
Organization: Collabora
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-6QIMy4g9SukUt3RE3IU0"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-6QIMy4g9SukUt3RE3IU0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 17 juillet 2020 =C3=A0 09:48 +0200, Philipp Zabel a =C3=A9crit =
:
> Hi Ezequiel, Nicolas,
>=20
> On Fri, 2020-07-17 at 00:49 -0300, Ezequiel Garcia wrote:
> > From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> >=20
> > This add H264 level 4.1, 4.2 and 5.0 to the list of supported formats.
> > While the hardware does not fully support these levels, it do support
> > most of them.
>=20
> Could you clarify this? As far as I understand the hardware supports
> maximum frame size requirement for up to level 4.2 (8704 macroblocks),
> but not 5.0, and at least the implementation on i.MX6 does not support
> the max encoding speed requirements for levels 4.1 and higher.
>=20
> I don't think the firmware ever produces any output with a level higher
> than 4.0 either, so what is the purpose of pretending otherwise?

Nothing is very explicit in the user manual, they speak in term of
resolution and framerate. They claim 1080p 30fps for encoding, and
1080p 60fps for decoding. For the encoder, there is an auto selection
for the level, and the documentation is maxed to 4.0, and so I would
agree that 4.0 is the max encoding level. Wikipedia also list "1,920=C3=971=
,
080@30.1 (4)" so 1080p30 with 4 frame references as being an example of
4.0 maximum. So V2 of this patchset should make sure that for the
encoder this stays there.

On the decoding side, what I found is that there is an error bit
indicator called LEVELID (bit 19) that indicates that SPS level_idc
wasn't accepted. The error is described as "Supported up to 51.". So
basically there is some extra contraints that least to 4.2 as you
describe, and above 5.1 is an hard failure. That imho creates a grey-
zone. If we think of DASH/HLS, the information usually comes with
Resolution/Framerate/Codec/Profile/Level, and in this context, you can
enable 5.1 safely assuming the Resolition/Framerate/Profile are already
verified. But if you only wanted to use the level, then you could
prefer the driver to expose a max of 4.2.

So do you have an opinion on the way forward ? Personally I like the
idea of giving the list of level_idc that won't cause the parser to
reject it, and leave it to the user to validate the
Resolution/Framerate seperatly, we have the V4L2 API for that. Let me
know, as we'll use that for V2.

>=20
> regards
> Philipp
>=20

--=-6QIMy4g9SukUt3RE3IU0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXxXBzAAKCRBxUwItrAao
HK+GAKCYfD/TkbcW5mD2ej9TpGwqooECdQCg12D8JcaeELjApgm7pj4I9qeSoK4=
=dwdk
-----END PGP SIGNATURE-----

--=-6QIMy4g9SukUt3RE3IU0--

