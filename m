Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952D62CA726
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 16:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390383AbgLAPeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 10:34:21 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:53960 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390298AbgLAPeV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 10:34:21 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3A72B1C0B81; Tue,  1 Dec 2020 16:33:38 +0100 (CET)
Date:   Tue, 1 Dec 2020 16:33:37 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: [PATCH 4.19 08/57] KVM: x86: Fix split-irqchip vs interrupt
 injection window request
Message-ID: <20201201153337.GA23661@amd>
References: <20201201084647.751612010@linuxfoundation.org>
 <20201201084648.690944071@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20201201084648.690944071@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> - in order to tell userspace we will inject its interrupt ("IRQ
>   window open" i.e. kvm_vcpu_ready_for_interrupt_injection), both
>   KVM and the vCPU need to be ready to accept the interrupt.
>=20
> ... and this is what the patch implements.
>=20
> Reported-by: David Woodhouse <dwmw@amazon.co.uk>
> Analyzed-by: David Woodhouse <dwmw@amazon.co.uk>
> Cc: stable@vger.kernel.org

This makes no difference for -stable, but the patch is confused about
types:

> +++ b/arch/x86/kvm/x86.c
> @@ -3351,21 +3351,23 @@ static int kvm_vcpu_ioctl_set_lapic(stru
> =20
>  static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
>  {
> +	/*
> +	 * We can accept userspace's request for interrupt injection
> +	 * as long as we have a place to store the interrupt number.
> +	 * The actual injection will happen when the CPU is able to
> +	 * deliver the interrupt.
> +	 */
> +	if (kvm_cpu_has_extint(vcpu))
> +		return false;

Since function is "static int" it should probably return 0.

Best regards,
								Pavel
--
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/GYlEACgkQMOfwapXb+vIPdQCcDBG2tt6CVMQOnnLOKgrBswZU
82MAn3FFa8jE27Vqr2cmRZRM46kpxH6P
=OH3i
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
