Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67850498512
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 17:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243842AbiAXQnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 11:43:52 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:42338 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243843AbiAXQnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 11:43:50 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC2RX-00072z-RA; Mon, 24 Jan 2022 17:43:47 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC2RX-009zJP-27;
        Mon, 24 Jan 2022 17:43:47 +0100
Date:   Mon, 24 Jan 2022 17:43:47 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Stevens <stevensd@google.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.9 2/4] KVM: do not assume PTE is writable after follow_pfn
Message-ID: <Ye7XQ+uWAtNM+OlG@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4QeLih73rQ0GAnPj"
Content-Disposition: inline
In-Reply-To: <Ye7WqMoYNyxOqWId@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4QeLih73rQ0GAnPj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Paolo Bonzini <pbonzini@redhat.com>

commit bd2fae8da794b55bf2ac02632da3a151b10e664c upstream.

In order to convert an HVA to a PFN, KVM usually tries to use
the get_user_pages family of functinso.  This however is not
possible for VM_IO vmas; in that case, KVM instead uses follow_pfn.

In doing this however KVM loses the information on whether the
PFN is writable.  That is usually not a problem because the main
use of VM_IO vmas with KVM is for BARs in PCI device assignment,
however it is a bug.  To fix it, use follow_pte and check pte_write
while under the protection of the PTE lock.  The information can
be used to fail hva_to_pfn_remapped or passed back to the
caller via *writable.

Usage of follow_pfn was introduced in commit add6a0cd1c5b ("KVM: MMU: try t=
o fix
up page faults before giving up", 2016-07-05); however, even older version
have the same issue, all the way back to commit 2e2e3738af33 ("KVM:
Handle vma regions with no backing page", 2008-07-20), as they also did
not check whether the PFN was writable.

Fixes: 2e2e3738af33 ("KVM: Handle vma regions with no backing page")
Reported-by: David Stevens <stevensd@google.com>
Cc: 3pvd@google.com
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[OP: backport to 4.19, adjust follow_pte() -> follow_pte_pmd()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backport to 4.9: follow_pte_pmd() does not take start or end
 parameters]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 virt/kvm/kvm_main.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index db859b595dba..2729704f836e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1519,9 +1519,11 @@ static int hva_to_pfn_remapped(struct vm_area_struct=
 *vma,
 			       kvm_pfn_t *p_pfn)
 {
 	unsigned long pfn;
+	pte_t *ptep;
+	spinlock_t *ptl;
 	int r;
=20
-	r =3D follow_pfn(vma, addr, &pfn);
+	r =3D follow_pte_pmd(vma->vm_mm, addr, &ptep, NULL, &ptl);
 	if (r) {
 		/*
 		 * get_user_pages fails for VM_IO and VM_PFNMAP vmas and does
@@ -1536,14 +1538,19 @@ static int hva_to_pfn_remapped(struct vm_area_struc=
t *vma,
 		if (r)
 			return r;
=20
-		r =3D follow_pfn(vma, addr, &pfn);
+		r =3D follow_pte_pmd(vma->vm_mm, addr, &ptep, NULL, &ptl);
 		if (r)
 			return r;
+	}
=20
+	if (write_fault && !pte_write(*ptep)) {
+		pfn =3D KVM_PFN_ERR_RO_FAULT;
+		goto out;
 	}
=20
 	if (writable)
-		*writable =3D true;
+		*writable =3D pte_write(*ptep);
+	pfn =3D pte_pfn(*ptep);
=20
 	/*
 	 * Get a reference here because callers of *hva_to_pfn* and
@@ -1558,6 +1565,8 @@ static int hva_to_pfn_remapped(struct vm_area_struct =
*vma,
 	 */=20
 	kvm_get_pfn(pfn);
=20
+out:
+	pte_unmap_unlock(ptep, ptl);
 	*p_pfn =3D pfn;
 	return 0;
 }


--4QeLih73rQ0GAnPj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHu10IACgkQ57/I7JWG
EQn9nw/+PycD1kYltDKXr4W+P1BIcYha7CJgYlqcVAELLqPBo2wm3SA7M5B5I6fm
Rb4dfQ0A3LbtrrJ3Nd2p+4BZ8q6BeNa5dtGKsi0ojLWcm0NvuT6IaC0S7pSKtFKW
+ND7shgoquIfEw2WfYKWj4Hoet3dGdwT8hP63Jom/Wywva4jJIIQxcLcZ+E3H+8P
KhUOCXRF7a/omwYyfFzIb7k1uvYFJQ1TCf2NKAs019FeDM8szMt/zqe//7rjL3qr
JoMN+O/CjAfn/azR02SvvcMK/PbbOXM/hJpUS0Bc1NoYyryg+dys7yRejfQrPhk7
bu5NiSfte9AdiLvS/FFDviBWxjqLd/ftDCdMOGQb1H0nZXEB26zaJFE3hnozHTFj
FDsnohcG/ciNTKdrc3h2V9nhuqhNP6PsTkT4nxmHoK+EkMyYT/vQJTyWt2TDC7+k
Re2KRsQvHCfGVvz5Zmq6hkdnZEOuSjs7UU+00ywKWb9BEIJrA+mp0Veatq/E4fzw
rbWKZpwwYaalG1IYfD46GUm0U8O0yWbwK8Oj8O/RlRKbJmqHZWny6MNX34yHl8AU
0PTs4eg3i/8TdGMU+p6+C7nI6XSf1JvOrAfFlQ3mAjPMJKLtg3SgO0xVJWJzFOvg
ijKngntjnUJIDBaRs9X1Kic/DUrNujuwvvt3b9SHPVEceti+PaA=
=EQVd
-----END PGP SIGNATURE-----

--4QeLih73rQ0GAnPj--
