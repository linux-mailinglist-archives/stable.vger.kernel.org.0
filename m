Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97059227EFC
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 13:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgGULdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 07:33:03 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52246 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgGULdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 07:33:02 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4ABA11C0BE5; Tue, 21 Jul 2020 13:33:00 +0200 (CEST)
Date:   Tue, 21 Jul 2020 13:33:00 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH 4.19 094/133] USB: serial: iuu_phoenix: fix memory
 corruption
Message-ID: <20200721113259.GB17778@duo.ucw.cz>
References: <20200720152803.732195882@linuxfoundation.org>
 <20200720152808.264804020@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <20200720152808.264804020@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit e7b931bee739e8a77ae216e613d3b99342b6dec0 upstream.
>=20
> The driver would happily overwrite its write buffer with user data in
> 256 byte increments due to a removed buffer-space sanity check.

> +++ b/drivers/usb/serial/iuu_phoenix.c
> @@ -697,14 +697,16 @@ static int iuu_uart_write(struct tty_str
>  	struct iuu_private *priv =3D usb_get_serial_port_data(port);
>  	unsigned long flags;
> =20
> -	if (count > 256)
> -		return -ENOMEM;
> -
>  	spin_lock_irqsave(&priv->lock, flags);
> =20
> +	count =3D min(count, 256 - priv->writelen);
> +	if (count =3D=3D 0)
> +		goto out;
> +
>  	/* fill the buffer */
>  	memcpy(priv->writebuf + priv->writelen, buf, count);
>  	priv->writelen +=3D count;
> +out:
>  	spin_unlock_irqrestore(&priv->lock, flags);
> =20
>  	return count;

Ok, so... goto and label is unneccessary, memcpy will do the right
thing with count =3D=3D 0.

But what is worse, this changes return value in the error case;
returning 0 instead of -ENOMEM. I don't believe 0 is appropriate
return code here.

(It should block on the write buffer if blocking or return -EAGAIN if
nonblocking, right?)

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXxbSawAKCRAw5/Bqldv6
8u19AJ4jbQbSNaZ1GWiLP9mixxbtRG0ecQCgoh0GU+S4wV+Mg2PhT4LfUmgt0FE=
=7SXu
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
