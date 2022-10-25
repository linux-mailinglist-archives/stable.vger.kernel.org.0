Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49EB560C647
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 10:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiJYIUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 04:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiJYIUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 04:20:44 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1916DBBE4;
        Tue, 25 Oct 2022 01:20:42 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5C95B1C0016; Tue, 25 Oct 2022 10:20:41 +0200 (CEST)
Date:   Tue, 25 Oct 2022 10:20:40 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Yu <yu.c.chen@intel.com>
Subject: Re: [PATCH 4.9 158/159] thermal: intel_powerclamp: Use first online
 CPU as control_cpu
Message-ID: <20221025082040.GA9520@duo.ucw.cz>
References: <20221024112949.358278806@linuxfoundation.org>
 <20221024112955.194790075@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <20221024112955.194790075@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>=20
> commit 4bb7f6c2781e46fc5bd00475a66df2ea30ef330d upstream.
>=20
> Commit 68b99e94a4a2 ("thermal: intel_powerclamp: Use get_cpu() instead
> of smp_processor_id() to avoid crash") fixed an issue related to using
> smp_processor_id() in preemptible context by replacing it with a pair
> of get_cpu()/put_cpu(), but what is needed there really is any online
> CPU and not necessarily the one currently running the code.  Arguably,
> getting the one that's running the code in there is confusing.
>=20
> For this reason, simply give the control CPU role to the first online
> one which automatically will be CPU0 if it is online, so one check
> can be dropped from the code for an added benefit.

While this is nice cleanup (and I complained about original code being
interesting) original code still looks okay and we don't really need this in
stable.

Thanks and best regards,
								Pavel

> +++ b/drivers/thermal/intel_powerclamp.c
> @@ -518,11 +518,7 @@ static int start_power_clamp(void)
>  	get_online_cpus();
> =20
>  	/* prefer BSP */
> -	control_cpu =3D 0;
> -	if (!cpu_online(control_cpu)) {
> -		control_cpu =3D get_cpu();
> -		put_cpu();
> -	}
> +	control_cpu =3D cpumask_first(cpu_online_mask);
> =20
>  	clamping =3D true;
>  	schedule_delayed_work(&poll_pkg_cstate_work, 0);
>=20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY1ecWAAKCRAw5/Bqldv6
8s3mAKCbR0vVa1W+JRQLfgQAql33CH+iHACfQjWBQbswVB2wl1crgkfRXZOOqc8=
=XB+p
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
