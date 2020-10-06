Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67EF285286
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 21:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727155AbgJFTef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 15:34:35 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46470 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbgJFTef (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 15:34:35 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8A4F71C0B8C; Tue,  6 Oct 2020 21:34:32 +0200 (CEST)
Date:   Tue, 6 Oct 2020 21:34:32 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 07/38] vsock/virtio: stop workers during the
 .remove()
Message-ID: <20201006193432.GA8771@duo.ucw.cz>
References: <20201005142108.650363140@linuxfoundation.org>
 <20201005142109.015282314@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <20201005142109.015282314@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 17dd1367389cfe7f150790c83247b68e0c19d106 ]
>=20
> Before to call vdev->config->reset(vdev) we need to be sure that
> no one is accessing the device, for this reason, we add new variables
> in the struct virtio_vsock to stop the workers during the .remove().
>=20
> This patch also add few comments before vdev->config->reset(vdev)
> and vdev->config->del_vqs(vdev).


> @@ -621,12 +645,18 @@ static int virtio_vsock_probe(struct virtio_device =
*vdev)
>  	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
>  	INIT_WORK(&vsock->loopback_work, virtio_transport_loopback_work);
> =20
> +	mutex_lock(&vsock->tx_lock);
> +	vsock->tx_run =3D true;
> +	mutex_unlock(&vsock->tx_lock);
> +
>  	mutex_lock(&vsock->rx_lock);
>  	virtio_vsock_rx_fill(vsock);
> +	vsock->rx_run =3D true;
>  	mutex_unlock(&vsock->rx_lock);
> =20
>  	mutex_lock(&vsock->event_lock);
>  	virtio_vsock_event_fill(vsock);
> +	vsock->event_run =3D true;
>  	mutex_unlock(&vsock->event_lock);
>

This looks like some kind of voodoo code. Locks are just being
allocated few lines above, so there are no other threads accessing
*vsock. That means we don't need to take the locks... right?

At least taking the tx_lock is unneccessary, but probably the others,
too...

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX3zGyAAKCRAw5/Bqldv6
8jNjAJ0RTOmJL0/XsF4TzsN7iRY3oV27BgCfWmZs7mVTfHnYOW/ctdkYm62Rv1I=
=1+CH
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
