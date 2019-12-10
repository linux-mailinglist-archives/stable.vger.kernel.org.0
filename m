Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3574118D5E
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 17:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfLJQQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 11:16:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46956 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727178AbfLJQQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 11:16:53 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ieiBu-0006Vu-C4; Tue, 10 Dec 2019 16:16:50 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1ieiBt-0007Lp-Om; Tue, 10 Dec 2019 16:16:49 +0000
Message-ID: <0e0b5aca785e41cdb0819820dfed1059683f5f58.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 31/72] KVM: x86: Manually calculate reserved bits
 when loading PDPTRS
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        Doug Reiland <doug.reiland@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>
Date:   Tue, 10 Dec 2019 16:16:44 +0000
In-Reply-To: <20191209154913.GB4042@linux.intel.com>
References: <lsq.1575813164.154362148@decadent.org.uk>
         <lsq.1575813165.887619822@decadent.org.uk>
         <20191209154913.GB4042@linux.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-UA+Tt2Mq8es9NoOWXu2U"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-UA+Tt2Mq8es9NoOWXu2U
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-12-09 at 07:49 -0800, Sean Christopherson wrote:
> On Sun, Dec 08, 2019 at 01:53:15PM +0000, Ben Hutchings wrote:
> > 3.16.79-rc1 review patch.  If anyone has any objections, please let me =
know.
> >=20
> > ------------------
> >=20
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> >=20
> > commit 16cfacc8085782dab8e365979356ce1ca87fd6cc upstream.
>=20
> You'll also want to pull in two PAE related fixes (in this order):
>=20
>   d35b34a9a70e ("kvm: mmu: Don't read PDPTEs when paging is not enabled")

I've added this, thanks.

>   bf03d4f93347 ("KVM: x86: introduce is_pae_paging")
>
> The "introduce is_pae_paging" has an undocumented bug fix.  IIRC it
> manifests as an unexpected #GP on MOV CR3 in 64-bit mode.  Here's the blu=
rb
> I added to the backports for 4.x.
>=20
>   Moving to the common helper also fixes a subtle bug in kvm_set_cr3()
>   where it fails to check is_long_mode() and results in KVM incorrectly
>   attempting to load PDPTRs for a 64-bit guest.

The 3.16, 4.4, and 4.9 branches have slightly different conditions in
kvm_set_cr3():

	if (is_long_mode(vcpu)) {
		if (cr3 & CR3_L_MODE_RESERVED_BITS)
			return 1;
	} else if (is_pae(vcpu) && is_paging(vcpu) &&
		   !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
		return 1;

So load_pdptrs() already won't be called if is_long_mode() returns
true, and this fix shouldn't be needed.

Ben.

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed
                                                    - Carolyn Scheppner



--=-UA+Tt2Mq8es9NoOWXu2U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3vxO0ACgkQ57/I7JWG
EQno9BAAr6xdbmEcPcqgqcPzAiO5vPE2l2HY72KBwZumi24kIw7J3N8s5I12ad2f
gwE/mOb5lPQV+3cuT3qxnp3so4XCPydF0xpdVDMbt0zQMKZC/Jer4ydER5Pg6b6n
Je3/tgtcvOkR1X7Um9BppCBewPJhQHLmOa7xRguh6wffEM+JJv4a1WlRboYcjTXU
fD6U1IFgWnxYrOhhTuHcj/jNHpyVqrlM1Bde+O/ZZTg5fxGklkeLquSzoGbhgTrb
nBjGDtjoJnM+p4dqzz38tBZeghAhOSu6op6PFaQs8/k6l48muF+vAFihdn2ymNV3
dN4H5yevMlLowL66emhKXXsva/zywYxs8HMKGxwY0llw4fKqiMaNIG4TMWA4cisP
5aemU5W5xlIzAXG6emkVVvKv7R+C2TuY+mcX4Zg3V7WfvDcbMiSHJfVkZynInVzP
vji+3W7gz5AfuiU+iTplVkxGYoUMjqfsW79B+lC58oQBi9G+7m+MQoNSs5GhmoGo
UOO6wTMlogc2+gOrCOlXHdXXwp8z/X8EQuAc+1szQy6UXsoxySDsfzIV5UcZC9FM
/UUW6X1FgXHj5wPEh3fbB4HqNWH9EKuua8utBPu1HNt5t/3I+LpknWKbErG1zoPB
7VcpfU4l++zAWqiBIUhUk/EEFFdCT4ZTY/PnGNL+0wTqXgr+Zn0=
=k9xZ
-----END PGP SIGNATURE-----

--=-UA+Tt2Mq8es9NoOWXu2U--
