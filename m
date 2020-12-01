Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADAB2CA759
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 16:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389376AbgLAPoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 10:44:14 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55890 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388395AbgLAPoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 10:44:14 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E838D1C0B87; Tue,  1 Dec 2020 16:43:32 +0100 (CET)
Date:   Tue, 1 Dec 2020 16:43:32 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>, Lyude Paul <lyude@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>
Subject: Re: [PATCH 4.19 11/57] drm/atomic_helper: Stop modesets on
 unregistered connectors harder
Message-ID: <20201201154332.GB23661@amd>
References: <20201201084647.751612010@linuxfoundation.org>
 <20201201084648.982712007@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
In-Reply-To: <20201201084648.982712007@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Lyude Paul <lyude@redhat.com>
>=20
> commit de9f8eea5a44b0b756d3d6345af7f8e630a3c8c0 upstream.

So this says protected by mutex:

>  	/**
> -	 * @registered: Is this connector exposed (registered) with userspace?
> +	 * @registration_state: Is this connector initializing, exposed
> +	 * (registered) with userspace, or unregistered?
> +	 *
>  	 * Protected by @mutex.
>  	 */
> -	bool registered;
> +	enum drm_connector_registration_state registration_state;
> =20
>  	/**
>  	 * @modes:
> @@ -1165,6 +1214,24 @@ static inline void drm_connector_unrefer
>  	drm_connector_put(connector);
>  }
> =20
> +/**
> + * drm_connector_is_unregistered - has the connector been unregistered f=
rom
> + * userspace?
> + * @connector: DRM connector
> + *
> + * Checks whether or not @connector has been unregistered from userspace.
> + *
> + * Returns:
> + * True if the connector was unregistered, false if the connector is
> + * registered or has not yet been registered with userspace.
> + */
> +static inline bool
> +drm_connector_is_unregistered(struct drm_connector *connector)
> +{
> +	return READ_ONCE(connector->registration_state) =3D=3D
> +		DRM_CONNECTOR_UNREGISTERED;
> +}


But this uses READ_ONCE() for protection, and corresponding
WRITE_ONCE() is nowhere to be seen. Should this take the mutex, too?

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/GZKQACgkQMOfwapXb+vLdtwCgt/kT41bYBloUZ7+bCf5esRBA
CfIAn0nOmDFWfMTilErvK1DEZXP+URYh
=jIjo
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
