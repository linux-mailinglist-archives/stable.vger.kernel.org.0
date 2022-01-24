Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0A3498514
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 17:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243678AbiAXQoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 11:44:30 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:42354 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241172AbiAXQo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 11:44:29 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC2SC-00073Z-Oj; Mon, 24 Jan 2022 17:44:28 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC2SB-009zKK-WF;
        Mon, 24 Jan 2022 17:44:28 +0100
Date:   Mon, 24 Jan 2022 17:44:27 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Stevens <stevensd@google.com>
Subject: [PATCH 4.9 3/4] KVM: Use kvm_pfn_t for local PFN variable in
 hva_to_pfn_remapped()
Message-ID: <Ye7Xa599VFy2WEkC@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="h5kn63of9/+umgus"
Content-Disposition: inline
In-Reply-To: <Ye7WqMoYNyxOqWId@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--h5kn63of9/+umgus
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Sean Christopherson <seanjc@google.com>

commit a9545779ee9e9e103648f6f2552e73cfe808d0f4 upstream.

Use kvm_pfn_t, a.k.a. u64, for the local 'pfn' variable when retrieving
a so called "remapped" hva/pfn pair.  In theory, the hva could resolve to
a pfn in high memory on a 32-bit kernel.

This bug was inadvertantly exposed by commit bd2fae8da794 ("KVM: do not
assume PTE is writable after follow_pfn"), which added an error PFN value
to the mix, causing gcc to comlain about overflowing the unsigned long.

  arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function =E2=80=98hva_to_pf=
n_remapped=E2=80=99:
  include/linux/kvm_host.h:89:30: error: conversion from =E2=80=98long long=
 unsigned int=E2=80=99
                                  to =E2=80=98long unsigned int=E2=80=99 ch=
anges value from
                                  =E2=80=989218868437227405314=E2=80=99 to =
=E2=80=982=E2=80=99 [-Werror=3Doverflow]
   89 | #define KVM_PFN_ERR_RO_FAULT (KVM_PFN_ERR_MASK + 2)
      |                              ^
virt/kvm/kvm_main.c:1935:9: note: in expansion of macro =E2=80=98KVM_PFN_ER=
R_RO_FAULT=E2=80=99

Cc: stable@vger.kernel.org
Fixes: add6a0cd1c5b ("KVM: MMU: try to fix up page faults before giving up")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210208201940.1258328-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2729704f836e..dc7b60c81039 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1518,7 +1518,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct =
*vma,
 			       bool write_fault, bool *writable,
 			       kvm_pfn_t *p_pfn)
 {
-	unsigned long pfn;
+	kvm_pfn_t pfn;
 	pte_t *ptep;
 	spinlock_t *ptl;
 	int r;


--h5kn63of9/+umgus
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHu12sACgkQ57/I7JWG
EQmXBQ//fQpd7Vn46JRprSlHbIhSFi7S72VXVi+scUIBGyYDt/QVo2BhRpfJaW1w
/3KF3+fw6+PY541p+39lp5sM56vu10L6ZznTShF8z3Z2MnYkfx+q/PnGLBFuc5pd
ciGdDqf52sOuC375xoefSXjuEnibHal7FTuEhx3lKGREf84DBkUPqz+bEWW4rwCv
Fu1eJVaW28R9/1rq9LP6CC7QuoNpK+y9Le4jKxVKs01EzrKK23csFvn9Jc2AfdVh
wDfvw/z6o1/AZmkAEHPAXtF4Z8K0xMPn5h+moifgXy9vv3Y2jYeFmmMmgUNlNkVA
YMxTI/1AI2UeFjnGAm2ZiD5Q49qJtKej8dbbMiDejP+WuNcsFCMMIutXw4wwfxdf
8HHnPqfu1pQu8DrEtF9qkpP16giVm+Adj5/NbDpu+WG3HqQQiQ5Nzb4rEdseD6LH
1HGg6uSw4HK8r/JTsF5tvD78ApjOpyVIWGg3aoL386dDi9zMAsu+vxaNKWr2wKpd
7OTaUtPV3vAyklXDl46T8bQ/8QfTR4WNIAYcuyCb2pgrCNvRDBBRPU6gDlZnxOTF
/T4epDoboH4ybRyrd0xbd7nvAe4rU+PlbWksbhOhinM3cQ8xYsCwlvx3cPokLTZO
OSa85XkvXnwjg2oYiL1wRKheubifXQ4O+VQkF/s/35bdQqrerHc=
=8jjO
-----END PGP SIGNATURE-----

--h5kn63of9/+umgus--
