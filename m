Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE60EB49C
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 17:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbfJaQXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 12:23:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:50060 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728428AbfJaQXk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 31 Oct 2019 12:23:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 94264B833;
        Thu, 31 Oct 2019 16:23:38 +0000 (UTC)
Date:   Thu, 31 Oct 2019 17:23:34 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Valentin Schneider <valentin.schneider@arm.com>
Cc:     linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org,
        mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org,
        Dietmar.Eggemann@arm.com, morten.rasmussen@arm.com,
        qperret@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v4 1/2] sched/topology: Don't try to build empty sched
 domains
Message-ID: <20191031162334.GA18570@blackbody.suse.cz>
References: <20191023153745.19515-1-valentin.schneider@arm.com>
 <20191023153745.19515-2-valentin.schneider@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <20191023153745.19515-2-valentin.schneider@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2019 at 04:37:44PM +0100, Valentin Schneider <valentin.schn=
eider@arm.com> wrote:
> Prevent generate_sched_domains() from returning empty cpumasks, and add
> some assertion in build_sched_domains() to scream bloody murder if it
> happens again.
Good catch. It makes sense to prune the empty domains in
generate_sched_domains already.

> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index c52bc91f882b..c87ee6412b36 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -798,7 +798,8 @@ static int generate_sched_domains(cpumask_var_t **dom=
ains,
>  		    cpumask_subset(cp->cpus_allowed, top_cpuset.effective_cpus))
>  			continue;
> =20
> -		if (is_sched_load_balance(cp))
> +		if (is_sched_load_balance(cp) &&
> +		    !cpumask_empty(cp->effective_cpus))
>  			csa[csn++] =3D cp;
If I didn't overlook anything, cp->effective_cpus can contain CPUs
exluded by housekeeping_cpumask(HK_FLAG_DOMAIN) later, i.e. possibly
still returning domains with empty cpusets.

I'd suggest moving the emptiness check down into the loop where domain
cpumasks are ultimately constructed.

Michal

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAl27Cn4ACgkQia1+riC5
qSjwiw//aWG1NlJLTWdANaPNkP7nuGfeAYzGU/S0B9laDxFk9ADU3V43MjwxmExI
WIHDWQqzNlmbsbsQgIh4jQd2RnkKoV84bQVbEM3HPCsQcpGtpq5djPKIOXgAkEI4
yS4gIMiYhbTD0wcjEtiRA8+WNMWKgNUa96Tdg3s6q9JfdrrROJm07taXI3L3YXFM
w/N4Sj/XIMxgFEZunwU46ZoEihxPq7QwoChCE8qCXB9dPEbaftj3g0GlDSYQhXhu
POS2IrraxRC5msvr/Ehu51zom7uvS/B+29dXOfF/jq2zk8cdspSzgFTsSGrUQ+eI
cXI990mwxlT3XYi2fzmQZ6f3oTQhrQIS8Cjm0aGDY1vPbvH7Aacygcvu262jY0RF
aQW/jQeqH7daCsFZn99bbHFnTUPF/eCw02yI0JHkO+sQXnsH2w5bJ14l69QpHkXs
N7xqNgWVSwmfSecUKnpAq9VfQW473rs/nNGU3XsZrcErF4QhmCPwfMaw63YdYi5T
bOxvfg1luMnDMbkjKeBawTxJuUjvB0LGm6c2t/wvsHoMo+CVMxWTzfZmrcoh/0Es
rwLdn2pA+LVEmSdYsPndQo5xWBLns1muoa1vCvafthmHSGkEN1eLT03ZhXHwf1MK
feIc5qyw4KHNJtYYa8qQYCwQAJ8EB6mglSqbt4/qRWGBbr3a5wg=
=5/6w
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
