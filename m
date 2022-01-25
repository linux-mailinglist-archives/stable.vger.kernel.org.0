Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3655949BC0C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 20:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiAYT15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 14:27:57 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:51024 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiAYT1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 14:27:37 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 58B371C0B98; Tue, 25 Jan 2022 20:27:36 +0100 (CET)
Date:   Tue, 25 Jan 2022 20:27:35 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 138/563] bpf: Remove config check to enable bpf
 support for branch records
Message-ID: <20220125192735.GD5395@duo.ucw.cz>
References: <20220124184024.407936072@linuxfoundation.org>
 <20220124184029.173197383@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NtwzykIc2mflq5ck"
Content-Disposition: inline
In-Reply-To: <20220124184029.173197383@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NtwzykIc2mflq5ck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Branch data available to BPF programs can be very useful to get stack tra=
ces
> out of userspace application.
>=20
> Commit fff7b64355ea ("bpf: Add bpf_read_branch_records() helper") added B=
PF
> support to capture branch records in x86. Enable this feature also for ot=
her
> architectures as well by removing checks specific to x86.
>=20
> If an architecture doesn't support branch records, bpf_read_branch_record=
s()
> still has appropriate checks and it will return an -EINVAL in that scenar=
io.
> Based on UAPI helper doc in include/uapi/linux/bpf.h, unsupported archite=
ctures
> should return -ENOENT in such case. Hence, update the appropriate check to
> return -ENOENT instead.
>=20
> Selftest 'perf_branches' result on power9 machine which has the branch st=
acks
> support:
>=20
>  - Before this patch:
>=20
>   [command]# ./test_progs -t perf_branches
>    #88/1 perf_branches/perf_branches_hw:FAIL
>    #88/2 perf_branches/perf_branches_no_hw:OK
>    #88 perf_branches:FAIL
>   Summary: 0/1 PASSED, 0 SKIPPED, 1 FAILED
>=20
>  - After this patch:
>=20
>   [command]# ./test_progs -t perf_branches
>    #88/1 perf_branches/perf_branches_hw:OK
>    #88/2 perf_branches/perf_branches_no_hw:OK
>    #88 perf_branches:OK
>   Summary: 1/2 PASSED, 0 SKIPPED, 0 FAILED
>=20
> Selftest 'perf_branches' result on power9 machine which doesn't have bran=
ch
> stack report:
>=20
>  - After this patch:
>=20
>   [command]# ./test_progs -t perf_branches
>    #88/1 perf_branches/perf_branches_hw:SKIP
>    #88/2 perf_branches/perf_branches_no_hw:OK
>    #88 perf_branches:OK
>   Summary: 1/1 PASSED, 1 SKIPPED, 0 FAILED

This makes me nervous, it is not really a bugfix and probably noone
tested it on the stable branch. It would be safer to keep it disabled.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--NtwzykIc2mflq5ck
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYfBPJwAKCRAw5/Bqldv6
8iEpAJ9sCL3h7VF39/KJbJcKOvb5z5BoVACgjZkTQY96JjevdX7yawuiLtAjLpc=
=Wh42
-----END PGP SIGNATURE-----

--NtwzykIc2mflq5ck--
