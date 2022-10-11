Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480135FB196
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 13:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiJKLgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 07:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiJKLgu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 07:36:50 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B627B28E;
        Tue, 11 Oct 2022 04:36:49 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B265C1C0025; Tue, 11 Oct 2022 13:36:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1665488206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yxy+ic3V+nB+6LJCyMa/op1PaWUXm936BcV18CjdBEg=;
        b=nFuquqLsOw/5lZzuX/B3bVKse0l4ZnzsAu36xhrAioiDW1ahFiFv4Wb2ewguXJgE88I22F
        wDlLvckguA5/6C5wtNhkfGGYRCZHqqAPM6+M+DgTazicv1OAcMsgQSUMiqBir7p0cPX0+P
        my776H1Urab2P6YlsSm+TY/QrkJ/tYo=
Date:   Tue, 11 Oct 2022 13:36:46 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Chen Yu <yu.c.chen@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        rafael@kernel.org, daniel.lezcano@linaro.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 4/4] thermal: intel_powerclamp: Use get_cpu()
 instead of smp_processor_id() to avoid crash
Message-ID: <20221011113646.GA12080@duo.ucw.cz>
References: <20221009205508.1204042-1-sashal@kernel.org>
 <20221009205508.1204042-4-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <20221009205508.1204042-4-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
>=20
> [ Upstream commit 68b99e94a4a2db6ba9b31fe0485e057b9354a640 ]
>=20
> When CPU 0 is offline and intel_powerclamp is used to inject
> idle, it generates kernel BUG:
>=20
> BUG: using smp_processor_id() in preemptible [00000000] code: bash/15687
> caller is debug_smp_processor_id+0x17/0x20
> CPU: 4 PID: 15687 Comm: bash Not tainted 5.19.0-rc7+ #57
> Call Trace:
> <TASK>
> dump_stack_lvl+0x49/0x63
> dump_stack+0x10/0x16
> check_preemption_disabled+0xdd/0xe0
> debug_smp_processor_id+0x17/0x20
> powerclamp_set_cur_state+0x7f/0xf9 [intel_powerclamp]
> ...
> ...
>=20
> Here CPU 0 is the control CPU by default and changed to the current CPU,
> if CPU 0 offlined. This check has to be performed under cpus_read_lock(),
> hence the above warning.
>=20
> Use get_cpu() instead of smp_processor_id() to avoid this BUG.

This has exactly the same problem as smp_processor_id(), you just
worked around the warning. If it is okay that control_cpu contains
stale value, could we have a comment explaining why?

Thanks,
								Pavel
							=09
> +++ b/drivers/thermal/intel_powerclamp.c
> @@ -519,8 +519,10 @@ static int start_power_clamp(void)
> =20
>  	/* prefer BSP */
>  	control_cpu =3D 0;
> -	if (!cpu_online(control_cpu))
> -		control_cpu =3D smp_processor_id();
> +	if (!cpu_online(control_cpu)) {
> +		control_cpu =3D get_cpu();
> +		put_cpu();
> +	}
> =20
>  	clamping =3D true;
>  	schedule_delayed_work(&poll_pkg_cstate_work, 0);
> --=20
> 2.35.1

--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY0VVTgAKCRAw5/Bqldv6
8m6WAKCKlzktekbyNr+tfsTO8t12rs87hACfX2jyIOacdHmc5UBLOJycqjXZ2Xs=
=FoLS
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
