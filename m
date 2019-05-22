Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0395262E7
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 13:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbfEVLU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 07:20:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46107 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728447AbfEVLU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 07:20:28 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 61BF0802AE; Wed, 22 May 2019 13:20:16 +0200 (CEST)
Date:   Wed, 22 May 2019 13:20:24 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4.19 093/105] KVM: x86: Skip EFER vs. guest CPUID checks
 for host-initiated writes
Message-ID: <20190522112024.GE8174@amd>
References: <20190520115247.060821231@linuxfoundation.org>
 <20190520115253.674476913@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WK3l2KTTmXPVedZ6"
Content-Disposition: inline
In-Reply-To: <20190520115253.674476913@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--WK3l2KTTmXPVedZ6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Sean Christopherson <sean.j.christopherson@intel.com>
>=20
> commit 11988499e62b310f3bf6f6d0a807a06d3f9ccc96 upstream.
>=20
> KVM allows userspace to violate consistency checks related to the
> guest's CPUID model to some degree.  Generally speaking, userspace has
> carte blanche when it comes to guest state so long as jamming invalid
> state won't negatively affect the host.
>=20
> Currently this is seems to be a non-issue as most of the interesting
> EFER checks are missing, e.g. NX and LME, but those will be added
> shortly.  Proactively exempt userspace from the CPUID checks so as not
> to break userspace.
>=20
> Note, the efer_reserved_bits check still applies to userspace writes as
> that mask reflects the host's capabilities, e.g. KVM shouldn't allow a
> guest to run with NX=3D1 if it has been disabled in the host.

>  arch/x86/kvm/x86.c |   37 ++++++++++++++++++++++++-------------
>  1 file changed, 24 insertions(+), 13 deletions(-)
>=20
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> =20
> -static int set_efer(struct kvm_vcpu *vcpu, u64 efer)
> +static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
>  	u64 old_efer =3D vcpu->arch.efer;
> +	u64 efer =3D msr_info->data;
> =20
> -	if (!kvm_valid_efer(vcpu, efer))
> -		return 1;
> +	if (efer & efer_reserved_bits)
> +		return false;
> =20
> -	if (is_paging(vcpu)
> -	    && (vcpu->arch.efer & EFER_LME) !=3D (efer & EFER_LME))
> -		return 1;
> +	if (!msr_info->host_initiated) {
> +		if (!__kvm_valid_efer(vcpu, efer))
> +			return 1;

We have "return false" in function returning int. Plus calling
convention here seems to be "nonzero on error" so it should be
returning 1?

> @@ -2356,7 +2367,7 @@ int kvm_set_msr_common(struct kvm_vcpu *
>  		vcpu->arch.arch_capabilities =3D data;
>  		break;
>  	case MSR_EFER:
> -		return set_efer(vcpu, data);
> +		return set_efer(vcpu, msr_info);
>  	case MSR_K7_HWCR:
>  		data &=3D ~(u64)0x40;	/* ignore flush filter disable */
>  		data &=3D ~(u64)0x100;	/* ignore ignne emulation enable */
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--WK3l2KTTmXPVedZ6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzlMHgACgkQMOfwapXb+vLGvACgjCD1Mk1oAsWhXnWGsBTi7BI0
ibIAoJcOY9QKFC77gzBqQAuZs+lpR2oB
=Guzq
-----END PGP SIGNATURE-----

--WK3l2KTTmXPVedZ6--
