Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6397B56787B
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 22:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiGEUgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 16:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiGEUgH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 16:36:07 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23CD192B4;
        Tue,  5 Jul 2022 13:36:05 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6867C1C0001; Tue,  5 Jul 2022 22:36:02 +0200 (CEST)
Date:   Tue, 5 Jul 2022 22:36:02 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 05/29] usbnet: make sure no NULL pointer is passed
 through
Message-ID: <20220705203601.GA3184@amd>
References: <20220705115605.742248854@linuxfoundation.org>
 <20220705115605.903898317@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20220705115605.903898317@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Oliver Neukum <oneukum@suse.com>
>=20
> commit 6c22fce07c97f765af1808ec3be007847e0b47d1 upstream.
>=20
> Coverity reports:
>=20
> ** CID 751368:  Null pointer dereferences  (FORWARD_NULL)
> /drivers/net/usb/usbnet.c: 1925 in __usbnet_read_cmd()
>=20
> _________________________________________________________________________=
_______________________________

There's something wrong here. Changelog is cut, so signed-offs are
missing. It is wrong in git, too.

There's something wrong with the whitespace in the patch (indentation
by 4 spaces instead of tab), too.

Best regards,
								Pavel
							=09
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -1960,8 +1960,13 @@ static int __usbnet_read_cmd(struct usbn
>  	err =3D usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
>  			      cmd, reqtype, value, index, buf, size,
>  			      USB_CTRL_GET_TIMEOUT);
> -	if (err > 0 && err <=3D size)
> -		memcpy(data, buf, err);
> +	if (err > 0 && err <=3D size) {
> +        if (data)
> +            memcpy(data, buf, err);
> +        else
> +            netdev_dbg(dev->net,
> +                "Huh? Data requested but thrown away.\n");
> +    }
>  	kfree(buf);
>  out:
>  	return err;
> @@ -1982,7 +1987,13 @@ static int __usbnet_write_cmd(struct usb
>  		buf =3D kmemdup(data, size, GFP_KERNEL);
>  		if (!buf)
>  			goto out;
> -	}
> +	} else {
> +        if (size) {
> +            WARN_ON_ONCE(1);
> +            err =3D -EINVAL;
> +            goto out;
> +        }
> +    }
> =20
>  	err =3D usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
>  			      cmd, reqtype, value, index, buf, size,
>=20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmLEoLEACgkQMOfwapXb+vIZqwCfX0mpHAw+0dynaI7ZHL1Nxgdg
fK8AnidRkrzg/vEgwd4aM0QcENMUoVx6
=arxU
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
