Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C95C3D0404
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 23:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhGTVEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 17:04:05 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:41514 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbhGTVEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 17:04:04 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3D63E1C0B77; Tue, 20 Jul 2021 23:44:39 +0200 (CEST)
Date:   Tue, 20 Jul 2021 23:44:38 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.4 175/188] virtio_console: Assure used length from
 device is limited
Message-ID: <20210720214438.GA704@amd>
References: <20210719144913.076563739@linuxfoundation.org>
 <20210719144942.209087475@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20210719144942.209087475@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Xie Yongji <xieyongji@bytedance.com>
>=20
> [ Upstream commit d00d8da5869a2608e97cfede094dfc5e11462a46 ]
>=20
> The buf->len might come from an untrusted device. This
> ensures the value would not exceed the size of the buffer
> to avoid data corruption or loss.

Since we are not trusting the other side, do we need to use _nospec
variants to prevent speculation attacks?

Best regards,
								Pavel

> +++ b/drivers/char/virtio_console.c
> @@ -487,7 +487,7 @@ static struct port_buffer *get_inbuf(struct port *por=
t)
> =20
>  	buf =3D virtqueue_get_buf(port->in_vq, &len);
>  	if (buf) {
> -		buf->len =3D len;
> +		buf->len =3D min_t(size_t, len, buf->size);
>  		buf->offset =3D 0;
>  		port->stats.bytes_received +=3D len;
>  	}
> @@ -1752,7 +1752,7 @@ static void control_work_handler(struct work_struct=
 *work)
>  	while ((buf =3D virtqueue_get_buf(vq, &len))) {
>  		spin_unlock(&portdev->c_ivq_lock);
> =20
> -		buf->len =3D len;
> +		buf->len =3D min_t(size_t, len, buf->size);
>  		buf->offset =3D 0;
> =20
>  		handle_control_message(vq->vdev, portdev, buf);

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmD3Q8YACgkQMOfwapXb+vKqCwCffZCpFKyIt0tiFNZIsq+ffY/j
7g0AnRf+GBNJfgmaVNDDa+qTu3JoZttl
=KJz6
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
