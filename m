Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB116D5F02
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 13:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbjDDLbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 07:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234908AbjDDLbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 07:31:31 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665A02691
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 04:31:29 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 302481C0DFE; Tue,  4 Apr 2023 13:31:28 +0200 (CEST)
Date:   Tue, 4 Apr 2023 13:31:27 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: Re: [PATCH 5.10 092/173] tee: amdtee: fix race condition in
 amdtee_open_session
Message-ID: <ZCwKjzsnhxkI+eFS@duo.ucw.cz>
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140417.410529300@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="axub2Scvp1yy5g1R"
Content-Disposition: inline
In-Reply-To: <20230403140417.410529300@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=SPF_HELO_NONE,SPF_NEUTRAL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--axub2Scvp1yy5g1R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit f8502fba45bd30e1a6a354d9d898bc99d1a11e6d upstream.
>=20
> There is a potential race condition in amdtee_open_session that may
> lead to use-after-free. For instance, in amdtee_open_session() after
> sess->sess_mask is set, and before setting:
>=20
>     sess->session_info[i] =3D session_info;
>=20
> if amdtee_close_session() closes this same session, then 'sess' data
> structure will be released, causing kernel panic when 'sess' is
> accessed within amdtee_open_session().
>=20
> The solution is to set the bit sess->sess_mask as the last step in
> amdtee_open_session().

Ok, but:

> +++ b/drivers/tee/amdtee/core.c
> @@ -267,35 +267,34 @@ int amdtee_open_session(struct tee_conte
>  		goto out;
>  	}
> =20
> +	/* Open session with loaded TA */
> +	handle_open_session(arg, &session_info, param);
> +	if (arg->ret !=3D TEEC_SUCCESS) {
> +		pr_err("open_session failed %d\n", arg->ret);
> +		handle_unload_ta(ta_handle);
> +		kref_put(&sess->refcount, destroy_session);
> +		goto out;
> +	}

rc needs to be set to something here, otherwise we'll return 0 below.

>  out:
>  	free_pages((u64)ta, get_order(ta_size));
>  	return rc;

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--axub2Scvp1yy5g1R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZCwKjwAKCRAw5/Bqldv6
8mLPAKCCcPMx0oU6k+9rcpTwfJfCkB0b4wCePrwAMHOULOyfaaaVFFvn1ABg+yM=
=9dBJ
-----END PGP SIGNATURE-----

--axub2Scvp1yy5g1R--
