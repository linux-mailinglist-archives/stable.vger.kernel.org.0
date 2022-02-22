Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFD44BFD2C
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 16:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiBVPiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 10:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiBVPiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 10:38:15 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82860163054;
        Tue, 22 Feb 2022 07:37:50 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4AAD81C0B85; Tue, 22 Feb 2022 16:37:49 +0100 (CET)
Date:   Tue, 22 Feb 2022 16:37:48 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 49/58] KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for
 PERF_TYPE_RAW
Message-ID: <20220222153748.GB27262@amd>
References: <20220221084911.895146879@linuxfoundation.org>
 <20220221084913.456697491@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
In-Reply-To: <20220221084913.456697491@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 710c476514313c74045c41c0571bb5178fd16e3d ]
>=20
> AMD's event select is 3 nybbles, with the high nybble in bits 35:32 of
> a PerfEvtSeln MSR. Don't mask off the high nybble when configuring a
> RAW perf event.

Ok, but this depends on b8bfee "KVM: x86/pmu: Don't truncate the
PerfEvtSeln MSR when creating a perf event", and that is backported to
5.10 but not 4.19... so we don't need this, either, right...?

Best regards,
								Pavel

> +++ b/arch/x86/kvm/pmu.c
> @@ -171,7 +171,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 ev=
entsel)
>  	}
> =20
>  	if (type =3D=3D PERF_TYPE_RAW)
> -		config =3D eventsel & X86_RAW_EVENT_MASK;
> +		config =3D eventsel & AMD64_RAW_EVENT_MASK;
> =20
>  	pmc_reprogram_counter(pmc, type, config,
>  			      !(eventsel & ARCH_PERFMON_EVENTSEL_USR),

--=20
http://www.livejournal.com/~pavelmachek

--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmIVA0wACgkQMOfwapXb+vLfFACgvMQ5hThWaFoiuxPemG2r6RU7
0UIAn13dppGITFWS18CmloU6xPvZShoe
=ArCk
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--
