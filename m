Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361E132002C
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 22:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhBSVPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 16:15:11 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:49032 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhBSVPK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Feb 2021 16:15:10 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id EF3331C0BBD; Fri, 19 Feb 2021 22:14:27 +0100 (CET)
Date:   Fri, 19 Feb 2021 22:14:27 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 020/104] ARM: OMAP2+: Fix suspcious RCU usage splats
 for omap_enter_idle_coupled
Message-ID: <20210219211427.GA27750@amd>
References: <20210215152719.459796636@linuxfoundation.org>
 <20210215152720.133238537@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20210215152720.133238537@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 06862d789ddde8a99c1e579e934ca17c15a84755 ]
>=20
> We get suspcious RCU usage splats with cpuidle in several places in
> omap_enter_idle_coupled() with the kernel debug options enabled:
>=20
> RCU used illegally from extended quiescent state!
> ...
> (_raw_spin_lock_irqsave)
> (omap_enter_idle_coupled+0x17c/0x2d8)
> (omap_enter_idle_coupled)
> (cpuidle_enter_state)
> (cpuidle_enter_state_coupled)
> (cpuidle_enter)
>=20
> Let's use RCU_NONIDLE to suppress these splats. Things got changed around
> with commit 1098582a0f6c ("sched,idle,rcu: Push rcu_idle deeper into the
> idle path") that started triggering these warnings.

I just wanted to check... AFAICT RCU_NONIDLE puts some quite heavy
instrumentation around each statement; does it makes sense to group
the statements into one in cases like this?

Best regards,
								Pavel

> @@ -194,9 +194,9 @@ static int omap_enter_idle_coupled(struct cpuidle_dev=
ice *dev,
>  		    mpuss_can_lose_context)
>  			gic_dist_disable();
> =20
> -		clkdm_deny_idle(cpu_clkdm[1]);
> -		omap_set_pwrdm_state(cpu_pd[1], PWRDM_POWER_ON);
> -		clkdm_allow_idle(cpu_clkdm[1]);
> +		RCU_NONIDLE(clkdm_deny_idle(cpu_clkdm[1]));
> +		RCU_NONIDLE(omap_set_pwrdm_state(cpu_pd[1], PWRDM_POWER_ON));
> +		RCU_NONIDLE(clkdm_allow_idle(cpu_clkdm[1]));
> =20
>  		if (IS_PM44XX_ERRATUM(PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD) &&
>  		    mpuss_can_lose_context) {

--=20
http://www.livejournal.com/~pavelmachek

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAwKjIACgkQMOfwapXb+vIkpgCbBYhegccEuzEXI5im5gPXByE2
I8oAoJt92eg0+xb/8EHynMF9JMUnK2Yp
=WeMU
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
