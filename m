Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C9B498864
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbiAXSct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:32:49 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:42466 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbiAXSct (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:32:49 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC491-0007EB-22; Mon, 24 Jan 2022 19:32:47 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC490-00A1wH-Gh;
        Mon, 24 Jan 2022 19:32:46 +0100
Date:   Mon, 24 Jan 2022 19:32:46 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Xiao Guangrong <xiaoguangrong@tencent.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: [PATCH 4.9 1/2] KVM: nVMX: fix EPT permissions as reported in exit
 qualification
Message-ID: <Ye7wziIF+4bAna9E@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RncygzH9GHQCZJ8Z"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--RncygzH9GHQCZJ8Z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Paolo Bonzini <pbonzini@redhat.com>

commit 0780516a18f87e881e42ed815f189279b0a1743c upstream.

This fixes the new ept_access_test_read_only and ept_access_test_read_write
testcases from vmx.flat.

The problem is that gpte_access moves bits around to switch from EPT
bit order (XWR) to ACC_*_MASK bit order (RWX).  This results in an
incorrect exit qualification.  To fix this, make pt_access and
pte_access operate on raw PTE values (only with NX flipped to mean
"can execute") and call gpte_access at the end of the walk.  This
lets us use pte_access to compute the exit qualification with XWR
bit order.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Xiao Guangrong <xiaoguangrong@tencent.com>
Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
[bwh: Backported to 4.9:
 - There's no support for EPT accessed/dirty bits, so do not use
   have_ad flag
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/paging_tmpl.h | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index e03225e707b2..47ba1e1b35f9 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -285,9 +285,11 @@ static int FNAME(walk_addr_generic)(struct guest_walke=
r *walker,
 	pt_element_t pte;
 	pt_element_t __user *uninitialized_var(ptep_user);
 	gfn_t table_gfn;
-	unsigned index, pt_access, pte_access, accessed_dirty, pte_pkey;
+	u64 pt_access, pte_access;
+	unsigned index, accessed_dirty, pte_pkey;
 	gpa_t pte_gpa;
 	int offset;
+	u64 walk_nx_mask =3D 0;
 	const int write_fault =3D access & PFERR_WRITE_MASK;
 	const int user_fault  =3D access & PFERR_USER_MASK;
 	const int fetch_fault =3D access & PFERR_FETCH_MASK;
@@ -301,6 +303,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker=
 *walker,
 	pte           =3D mmu->get_cr3(vcpu);
=20
 #if PTTYPE =3D=3D 64
+	walk_nx_mask =3D 1ULL << PT64_NX_SHIFT;
 	if (walker->level =3D=3D PT32E_ROOT_LEVEL) {
 		pte =3D mmu->get_pdptr(vcpu, (addr >> 30) & 3);
 		trace_kvm_mmu_paging_element(pte, walker->level);
@@ -312,15 +315,14 @@ static int FNAME(walk_addr_generic)(struct guest_walk=
er *walker,
 	walker->max_level =3D walker->level;
 	ASSERT(!(is_long_mode(vcpu) && !is_pae(vcpu)));
=20
-	accessed_dirty =3D PT_GUEST_ACCESSED_MASK;
-	pt_access =3D pte_access =3D ACC_ALL;
+	pte_access =3D ~0;
 	++walker->level;
=20
 	do {
 		gfn_t real_gfn;
 		unsigned long host_addr;
=20
-		pt_access &=3D pte_access;
+		pt_access =3D pte_access;
 		--walker->level;
=20
 		index =3D PT_INDEX(addr, walker->level);
@@ -363,6 +365,12 @@ static int FNAME(walk_addr_generic)(struct guest_walke=
r *walker,
=20
 		trace_kvm_mmu_paging_element(pte, walker->level);
=20
+		/*
+		 * Inverting the NX it lets us AND it like other
+		 * permission bits.
+		 */
+		pte_access =3D pt_access & (pte ^ walk_nx_mask);
+
 		if (unlikely(!FNAME(is_present_gpte)(pte)))
 			goto error;
=20
@@ -371,14 +379,16 @@ static int FNAME(walk_addr_generic)(struct guest_walk=
er *walker,
 			goto error;
 		}
=20
-		accessed_dirty &=3D pte;
-		pte_access =3D pt_access & FNAME(gpte_access)(vcpu, pte);
-
 		walker->ptes[walker->level - 1] =3D pte;
 	} while (!is_last_gpte(mmu, walker->level, pte));
=20
 	pte_pkey =3D FNAME(gpte_pkeys)(vcpu, pte);
-	errcode =3D permission_fault(vcpu, mmu, pte_access, pte_pkey, access);
+	accessed_dirty =3D pte_access & PT_GUEST_ACCESSED_MASK;
+
+	/* Convert to ACC_*_MASK flags for struct guest_walker.  */
+	walker->pt_access =3D FNAME(gpte_access)(vcpu, pt_access ^ walk_nx_mask);
+	walker->pte_access =3D FNAME(gpte_access)(vcpu, pte_access ^ walk_nx_mask=
);
+	errcode =3D permission_fault(vcpu, mmu, walker->pte_access, pte_pkey, acc=
ess);
 	if (unlikely(errcode))
 		goto error;
=20
@@ -395,7 +405,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker=
 *walker,
 	walker->gfn =3D real_gpa >> PAGE_SHIFT;
=20
 	if (!write_fault)
-		FNAME(protect_clean_gpte)(&pte_access, pte);
+		FNAME(protect_clean_gpte)(&walker->pte_access, pte);
 	else
 		/*
 		 * On a write fault, fold the dirty bit into accessed_dirty.
@@ -413,10 +423,8 @@ static int FNAME(walk_addr_generic)(struct guest_walke=
r *walker,
 			goto retry_walk;
 	}
=20
-	walker->pt_access =3D pt_access;
-	walker->pte_access =3D pte_access;
 	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
-		 __func__, (u64)pte, pte_access, pt_access);
+		 __func__, (u64)pte, walker->pte_access, walker->pt_access);
 	return 1;
=20
 error:
@@ -444,7 +452,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker=
 *walker,
 	 */
 	if (!(errcode & PFERR_RSVD_MASK)) {
 		vcpu->arch.exit_qualification &=3D 0x187;
-		vcpu->arch.exit_qualification |=3D ((pt_access & pte) & 0x7) << 3;
+		vcpu->arch.exit_qualification |=3D (pte_access & 0x7) << 3;
 	}
 #endif
 	walker->fault.address =3D addr;


--RncygzH9GHQCZJ8Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHu8MkACgkQ57/I7JWG
EQl2/w//dWYeJtovADfJvpp4wttdG9GOEi/NN3JXAXE8OUXbboToQPfBwcQFeZ+n
OBX5JdguZm8p1hAD5UYePfNyHQIkxXq09Kx4zVKdOqMSae8bh9oDuuGIZAc6pmK4
zOkRveF0edB+HWPVBtlEYn/11Ya5ksd184T9nj3rFlCV04wKS/skmHwmcoJM0iM2
Oi4m8++HcEMYRlrsmviISp4Xh1dThqQsKXGM5c52HBWP6ltKeavBw7TaYLlDiQRM
VlKmDIGaYvDW3tFZeaDl3sxoHJ4nnFDM3q9csaN7jpUFFg/+246+n2Lng/nJICBf
tiE0yB94dotJJyISDDPNXOF0IsemfxZfVljZVu8vtH17mGhpQTTpDiPiZLwp0Z5+
3cTkbKpY8Vfy725amoNA7uLBlheNYFC1X3vwod54XMfHHADI3TZkNJbfgkNz5Bf3
5KY2G14S7uTun5x+PXkRMWsHo56ti4hkDgFG2Af3o2PiYnnxrIvH7FGruACeBdDJ
AZ0gHUxoSoWW4vcc5MQFzCX3jtpEYGGC5O66Gnic0h444lRUrqr4cv2DG2jgc/b1
bI17RbkPOUHfZboTBMKNtdmIdvQSoDb9edDu13iRMarPz+MWfNCgFMFHh/fFAMaU
CCt25ie9X8i10qQfu7hX3NQswxIjhTqIOGIVJjJQqjpNxpFRKaE=
=Nb3+
-----END PGP SIGNATURE-----

--RncygzH9GHQCZJ8Z--
