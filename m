Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A0C3BA933
	for <lists+stable@lfdr.de>; Sat,  3 Jul 2021 17:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhGCPY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Jul 2021 11:24:26 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:39152 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhGCPYV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Jul 2021 11:24:21 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 30F9A1C0B79; Sat,  3 Jul 2021 17:21:46 +0200 (CEST)
Date:   Sat, 3 Jul 2021 17:21:45 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fuad Tabba <tabba@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.10 049/101] KVM: selftests: Fix kvm_check_cap()
 assertion
Message-ID: <20210703152144.GB3004@amd>
References: <20210628142607.32218-1-sashal@kernel.org>
 <20210628142607.32218-50-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Content-Disposition: inline
In-Reply-To: <20210628142607.32218-50-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Fuad Tabba <tabba@google.com>
>=20
> [ Upstream commit d8ac05ea13d789d5491a5920d70a05659015441d ]
>=20
> KVM_CHECK_EXTENSION ioctl can return any negative value on error,
> and not necessarily -1. Change the assertion to reflect that.
>=20
> Signed-off-by: Fuad Tabba <tabba@google.com>

This is userland code, right?

> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -55,7 +55,7 @@ int kvm_check_cap(long cap)
>  		exit(KSFT_SKIP);
> =20
>  	ret =3D ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
> -	TEST_ASSERT(ret !=3D -1, "KVM_CHECK_EXTENSION IOCTL failed,\n"
> +	TEST_ASSERT(ret >=3D 0, "KVM_CHECK_EXTENSION IOCTL failed,\n"
>  		"  rc: %i errno: %i", ret, errno);

And syscalls return -1 on error in userland, not anything else. So
this should not be needed.

Best regards,
								Pavel
--
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDggIgACgkQMOfwapXb+vJhFQCgooH7ECT69tkzlu39sFmUrGsz
UYgAn38FUHq8FNb25jgvY4foy/szD7wj
=O1p7
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--
