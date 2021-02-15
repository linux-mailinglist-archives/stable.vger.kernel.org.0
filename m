Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3367031C1E7
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 19:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhBOSrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 13:47:51 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56648 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbhBOSrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 13:47:42 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BA50F1C0B76; Mon, 15 Feb 2021 19:46:45 +0100 (CET)
Date:   Mon, 15 Feb 2021 19:46:44 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 048/104] KVM: x86: cleanup CR3 reserved bits checks
Message-ID: <20210215184644.GA8689@amd>
References: <20210215152719.459796636@linuxfoundation.org>
 <20210215152721.031370031@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <20210215152721.031370031@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit c1c35cf78bfab31b8cb455259524395c9e4c7cd6 ]
>=20
> If not in long mode, the low bits of CR3 are reserved but not enforced to
> be zero, so remove those checks.  If in long mode, however, the MBZ bits
> extend down to the highest physical address bit of the guest, excluding
> the encryption bit.
>=20
> Make the checks consistent with the above, and match them between
> nested_vmcb_checks and KVM_SET_SREGS.

> +++ b/arch/x86/kvm/x86.c
> @@ -9558,6 +9558,8 @@ static int kvm_valid_sregs(struct kvm_vcpu *vcpu, s=
truct kvm_sregs *sregs)
>  		if (!(sregs->cr4 & X86_CR4_PAE)
>  		    || !(sregs->efer & EFER_LMA))
>  			return -EINVAL;
> +		if (sregs->cr3 & vcpu->arch.cr3_lm_rsvd_bits)
> +			return false;
>  	} else {

Function has different return type between 5.10 and 5.11, so this
needs fixing.

Best regards,
								Pavel

--=20
http://www.livejournal.com/~pavelmachek

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAqwZQACgkQMOfwapXb+vJgkACeN1p7SnT9C+Qaj6PP66/1I7Ed
XP8An34INGsMCRNTWHZAkXh661eaS0Ko
=zfyL
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
