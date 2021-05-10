Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61E2378F06
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241150AbhEJN1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:27:13 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54224 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235030AbhEJME1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 08:04:27 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5F5B51C0B79; Mon, 10 May 2021 14:03:18 +0200 (CEST)
Date:   Mon, 10 May 2021 14:03:18 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wesley Cheng <wcheng@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 06/21] usb: dwc3: gadget: Ignore EP queue
 requests during bus reset
Message-ID: <20210510120318.GA3547@duo.ucw.cz>
References: <20210502140517.2719912-1-sashal@kernel.org>
 <20210502140517.2719912-6-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <20210502140517.2719912-6-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 71ca43f30df9c642970f9dc9b2d6f463f4967e7b ]
>=20
> The current dwc3_gadget_reset_interrupt() will stop any active
> transfers, but only addresses blocking of EP queuing for while we are
> coming from a disconnected scenario, i.e. after receiving the disconnect
> event.  If the host decides to issue a bus reset on the device, the
> connected parameter will still be set to true, allowing for EP queuing
> to continue while we are disabling the functions.  To avoid this, set the
> connected flag to false until the stop active transfers is complete.

This is mismerged / crazy. Will probably break the driver completely.


> +++ b/drivers/usb/dwc3/gadget.c
> @@ -2717,6 +2717,15 @@ static void dwc3_gadget_reset_interrupt(struct dwc=
3 *dwc)
> =20
>  	dwc->connected =3D true;
> =20
> +	/*
> +	 * Ideally, dwc3_reset_gadget() would trigger the function
> +	 * drivers to stop any active transfers through ep disable.
> +	 * However, for functions which defer ep disable, such as mass
> +	 * storage, we will need to rely on the call to stop active
> +	 * transfers here, and avoid allowing of request queuing.
> +	 */
> +	dwc->connected =3D false;
> +
>  	/*
>  	 * WORKAROUND: DWC3 revisions <1.88a have an issue which
>  	 * would cause a missing Disconnect Event if there's a

See how connected =3D true is immediately overwritten? In mainline
=3D true assignment is done below, so it does not have this problem.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYJkhBgAKCRAw5/Bqldv6
8vriAJ93Vdrcs7s+vSB1tVq38r7SCD99egCfdSw1Y5MmAJl3i9NZVrdpvDiQRqo=
=RSty
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
