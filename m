Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECC4227F57
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 13:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgGULy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 07:54:56 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39598 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgGULy4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 07:54:56 -0400
Received: by mail-lf1-f65.google.com with SMTP id j21so11523501lfe.6;
        Tue, 21 Jul 2020 04:54:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aKnlqUdIqd1yeVpAwE7RkZ+lEAIKq+lQ6c33xOGVKIs=;
        b=Nzyu5B40eBV3veL7edrrtDQnB12sGovNSuM6uO4gtjQKQh47agz+dTgPlyN0mw8NDJ
         zS04NBE2VqlqD8JE2VUhY39/6k1UtKTmF4B6xNO819vhIXP9LKkEq+c/QphsMJOWhw1Y
         +p85b3s7K3bbI0+X6O9bJ7Fs6F6rFXoAIQmcgaM5JcvcD7zF/j4Uk/Gxnm+qW0WWooUN
         kW4QzROi3cLvppK8YV37YpjfThv7+R52K8yZ3E7/LxgPgMJPQ3hxRoHbiTTAByANXX8A
         t9ROZd9OcsZ1PJg52LViF/Cnbu6MZdnRVtUw5FU3rFVGjvmTuHy0WntO2kGy2asu1dFC
         uzCQ==
X-Gm-Message-State: AOAM532/HcBqHcsVTuaH2fuz4FmGvZzHwqyrN13N7zUE+ga2qPtEtiwe
        rS5hXQYsB9dXNMPZutElUF8=
X-Google-Smtp-Source: ABdhPJwmtFqXR2nS3KHRHBEQCRwu7jex1icAMMgQKD3Xk+Ugfhe3a/GsexzFMf6NQlWhCWrpCfocrw==
X-Received: by 2002:ac2:58d5:: with SMTP id u21mr3199128lfo.31.1595332493380;
        Tue, 21 Jul 2020 04:54:53 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id w5sm4350769lji.49.2020.07.21.04.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 04:54:52 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1jxqrB-0001PA-In; Tue, 21 Jul 2020 13:54:50 +0200
Date:   Tue, 21 Jul 2020 13:54:49 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH 4.19 094/133] USB: serial: iuu_phoenix: fix memory
 corruption
Message-ID: <20200721115449.GE3634@localhost>
References: <20200720152803.732195882@linuxfoundation.org>
 <20200720152808.264804020@linuxfoundation.org>
 <20200721113259.GB17778@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
In-Reply-To: <20200721113259.GB17778@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 21, 2020 at 01:33:00PM +0200, Pavel Machek wrote:
> Hi!
>=20
> > commit e7b931bee739e8a77ae216e613d3b99342b6dec0 upstream.
> >=20
> > The driver would happily overwrite its write buffer with user data in
> > 256 byte increments due to a removed buffer-space sanity check.
>=20
> > +++ b/drivers/usb/serial/iuu_phoenix.c
> > @@ -697,14 +697,16 @@ static int iuu_uart_write(struct tty_str
> >  	struct iuu_private *priv =3D usb_get_serial_port_data(port);
> >  	unsigned long flags;
> > =20
> > -	if (count > 256)
> > -		return -ENOMEM;
> > -
> >  	spin_lock_irqsave(&priv->lock, flags);
> > =20
> > +	count =3D min(count, 256 - priv->writelen);
> > +	if (count =3D=3D 0)
> > +		goto out;
> > +
> >  	/* fill the buffer */
> >  	memcpy(priv->writebuf + priv->writelen, buf, count);
> >  	priv->writelen +=3D count;
> > +out:
> >  	spin_unlock_irqrestore(&priv->lock, flags);
> > =20
> >  	return count;
>=20
> Ok, so... goto and label is unneccessary, memcpy will do the right
> thing with count =3D=3D 0.

That's generally too subtle. Better to clearly mark the error/exception
path.

> But what is worse, this changes return value in the error case;
> returning 0 instead of -ENOMEM. I don't believe 0 is appropriate
> return code here.
>=20
> (It should block on the write buffer if blocking or return -EAGAIN if
> nonblocking, right?)

No, zero is the correct return value here when the tty driver's buffer
is full. The line discipline will then handle nonblocking writes
correctly, etc.

Johan

--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQQHbPq+cpGvN/peuzMLxc3C7H1lCAUCXxbXgwAKCRALxc3C7H1l
CAM8AP9O08qNgW32ITKTGdqy0w/MgxW8AA2ZnPd/FbdhigGuBAEAgzI54Pclh3J0
RXH4qOhlID1KYjYXjXy73su2OoNn0gk=
=AyR+
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--
