Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7C46CF669
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 11:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbfJHJtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 05:49:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35852 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729767AbfJHJtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 05:49:17 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 618B88037F; Tue,  8 Oct 2019 11:49:00 +0200 (CEST)
Date:   Tue, 8 Oct 2019 11:49:15 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 012/106] ipmi_si: Only schedule continuously in the
 thread in maintenance mode
Message-ID: <20191008094915.GC608@amd>
References: <20191006171124.641144086@linuxfoundation.org>
 <20191006171130.485953894@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Content-Disposition: inline
In-Reply-To: <20191006171130.485953894@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> @@ -1013,11 +1016,20 @@ static int ipmi_thread(void *data)
>  		spin_unlock_irqrestore(&(smi_info->si_lock), flags);
>  		busy_wait =3D ipmi_thread_busy_wait(smi_result, smi_info,
>  						  &busy_until);
> -		if (smi_result =3D=3D SI_SM_CALL_WITHOUT_DELAY)
> +		if (smi_result =3D=3D SI_SM_CALL_WITHOUT_DELAY) {
>  			; /* do nothing */
> -		else if (smi_result =3D=3D SI_SM_CALL_WITH_DELAY && busy_wait)
> -			schedule();
> -		else if (smi_result =3D=3D SI_SM_IDLE) {
> +		} else if (smi_result =3D=3D SI_SM_CALL_WITH_DELAY && busy_wait) {
> +			/*
> +			 * In maintenance mode we run as fast as
> +			 * possible to allow firmware updates to
> +			 * complete as fast as possible, but normally
> +			 * don't bang on the scheduler.
> +			 */
> +			if (smi_info->in_maintenance_mode)
> +				schedule();
> +			else
> +				usleep_range(100, 200);
> +		} else if (smi_result =3D=3D SI_SM_IDLE) {

This is quite crazy code. usleep() will need to do magic with high
resolution timers to provide 200usec sleep... when all you want to do
is unload the scheduler.

cond_resched() should be okay to call in a loop, can the code use that
instead?

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2cW5sACgkQMOfwapXb+vJ7eQCaAzXAg5l8bKuBD/+tQE+XpSfc
J6sAn05kFLCKSTjEBPozN5WdveX4pR9R
=82/+
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
