Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47AED167AC7
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 11:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbgBUK3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 05:29:52 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:50210 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgBUK3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 05:29:52 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5B8CF1C013E; Fri, 21 Feb 2020 11:29:50 +0100 (CET)
Date:   Fri, 21 Feb 2020 11:29:49 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 009/191] KVM: nVMX: Use correct root level for
 nested EPT shadow page tables
Message-ID: <20200221102949.GA14608@duo.ucw.cz>
References: <20200221072250.732482588@linuxfoundation.org>
 <20200221072252.173149129@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <20200221072252.173149129@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Hardcode the EPT page-walk level for L2 to be 4 levels, as KVM's MMU
> currently also hardcodes the page walk level for nested EPT to be 4
> levels.  The L2 guest is all but guaranteed to soft hang on its first
> instruction when L1 is using EPT, as KVM will construct 4-level page
> tables and then tell hardware to use 5-level page tables.

I don't get it. 7/191 reverts the patch, then 9/191 reverts the
revert. Can we simply drop both 7 and 9, for exactly the same result?

(Patch 8 is a unused file, so it does not change the picture).

Best regards,
								Pavel

> +++ b/arch/x86/kvm/vmx.c
> @@ -5302,6 +5302,9 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsi=
gned long cr0)
> =20
>  static int get_ept_level(struct kvm_vcpu *vcpu)
>  {
> +	/* Nested EPT currently only supports 4-level walks. */
> +	if (is_guest_mode(vcpu) && nested_cpu_has_ept(get_vmcs12(vcpu)))
> +		return 4;
>  	if (cpu_has_vmx_ept_5levels() && (cpuid_maxphyaddr(vcpu) > 48))
>  		return 5;
>  	return 4;
> --=20
> 2.20.1
>=20
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXk+xHQAKCRAw5/Bqldv6
8hA+AKCQjLR8b57M1oGVUuZ/FRnrtl89owCfaUobAb3Myu7jCjOJfB5Uab4UUyE=
=YRW/
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
