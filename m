Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216DE30CA8A
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239036AbhBBSwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:52:37 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:38002 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239016AbhBBSuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 13:50:08 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1F28A1C0B7A; Tue,  2 Feb 2021 19:49:21 +0100 (CET)
Date:   Tue, 2 Feb 2021 19:49:20 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rouven Czerwinski <r.czerwinski@pengutronix.de>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: Re: [PATCH 5.10 067/142] tee: optee: replace might_sleep with
 cond_resched
Message-ID: <20210202184920.GA6964@duo.ucw.cz>
References: <20210202132957.692094111@linuxfoundation.org>
 <20210202133000.488857996@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <20210202133000.488857996@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Rouven Czerwinski <r.czerwinski@pengutronix.de>
>=20
> commit dcb3b06d9c34f33a249f65c08805461fb0c4325b upstream.
>=20
> might_sleep() is a debugging aid and triggers rescheduling only for
> certain kernel configurations. Replace with an explicit check and
> reschedule to work for all kernel configurations. Fixes the following
> trace:

The need_resched() part is unneccessary/wrong AFAICT. And it seems
there's already a follow up patch that fixes this one.

(I'm not sure it causes any problem).

Best regards,
								Pavel
							=09
> @@ -148,7 +149,8 @@ u32 optee_do_call_with_arg(struct tee_co
>  			 */
>  			optee_cq_wait_for_completion(&optee->call_queue, &w);
>  		} else if (OPTEE_SMC_RETURN_IS_RPC(res.a0)) {
> -			might_sleep();
> +			if (need_resched())
> +				cond_resched();
>  			param.a0 =3D res.a0;
>  			param.a1 =3D res.a1;
>  			param.a2 =3D res.a2;
>=20

--=20
http://www.livejournal.com/~pavelmachek

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYBmesAAKCRAw5/Bqldv6
8rBBAJ48HfyU9GsPoYTA7njPW9uKITZJigCgoZXs5BkQ/YVNYF7oEueIyKZg7gM=
=id0X
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
