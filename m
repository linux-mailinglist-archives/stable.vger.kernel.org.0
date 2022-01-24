Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7770D498868
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244767AbiAXSdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:33:32 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:42488 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbiAXSdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:33:31 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC49i-0007Eq-9s; Mon, 24 Jan 2022 19:33:30 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC49h-00A1xT-Bz;
        Mon, 24 Jan 2022 19:33:29 +0100
Date:   Mon, 24 Jan 2022 19:33:29 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 4.9 2/2] KVM: X86: MMU: Use the correct inherited permissions
 to get shadow page
Message-ID: <Ye7w+SHXgvSxYyv/@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="b1h8futssbZDFl4p"
Content-Disposition: inline
In-Reply-To: <Ye7wziIF+4bAna9E@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--b1h8futssbZDFl4p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Lai Jiangshan <laijs@linux.alibaba.com>

commit b1bd5cba3306691c771d558e94baa73e8b0b96b7 upstream.

When computing the access permissions of a shadow page, use the effective
permissions of the walk up to that point, i.e. the logic AND of its parents'
permissions.  Two guest PxE entries that point at the same table gfn need to
be shadowed with different shadow pages if their parents' permissions are
different.  KVM currently uses the effective permissions of the last
non-leaf entry for all non-leaf entries.  Because all non-leaf SPTEs have
full ("uwx") permissions, and the effective permissions are recorded only
in role.access and merged into the leaves, this can lead to incorrect
reuse of a shadow page and eventually to a missing guest protection page
fault.

For example, here is a shared pagetable:

   pgd[]   pud[]        pmd[]            virtual address pointers
                     /->pmd1(u--)->pte1(uw-)->page1 <- ptr1 (u--)
        /->pud1(uw-)--->pmd2(uw-)->pte2(uw-)->page2 <- ptr2 (uw-)
   pgd-|           (shared pmd[] as above)
        \->pud2(u--)--->pmd1(u--)->pte1(uw-)->page1 <- ptr3 (u--)
                     \->pmd2(uw-)->pte2(uw-)->page2 <- ptr4 (u--)

  pud1 and pud2 point to the same pmd table, so:
  - ptr1 and ptr3 points to the same page.
  - ptr2 and ptr4 points to the same page.

(pud1 and pud2 here are pud entries, while pmd1 and pmd2 here are pmd entri=
es)

- First, the guest reads from ptr1 first and KVM prepares a shadow
  page table with role.access=3Du--, from ptr1's pud1 and ptr1's pmd1.
  "u--" comes from the effective permissions of pgd, pud1 and
  pmd1, which are stored in pt->access.  "u--" is used also to get
  the pagetable for pud1, instead of "uw-".

- Then the guest writes to ptr2 and KVM reuses pud1 which is present.
  The hypervisor set up a shadow page for ptr2 with pt->access is "uw-"
  even though the pud1 pmd (because of the incorrect argument to
  kvm_mmu_get_page in the previous step) has role.access=3D"u--".

- Then the guest reads from ptr3.  The hypervisor reuses pud1's
  shadow pmd for pud2, because both use "u--" for their permissions.
  Thus, the shadow pmd already includes entries for both pmd1 and pmd2.

- At last, the guest writes to ptr4.  This causes no vmexit or pagefault,
  because pud1's shadow page structures included an "uw-" page even though
  its role.access was "u--".

Any kind of shared pagetable might have the similar problem when in
virtual machine without TDP enabled if the permissions are different
=66rom different ancestors.

In order to fix the problem, we change pt->access to be an array, and
any access in it will not include permissions ANDed from child ptes.

The test code is: https://lore.kernel.org/kvm/20210603050537.19605-1-jiangs=
hanlai@gmail.com/
Remember to test it with TDP disabled.

The problem had existed long before the commit 41074d07c78b ("KVM: MMU:
Fix inherited permissions for emulated guest pte updates"), and it
is hard to find which is the culprit.  So there is no fixes tag here.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20210603052455.21023-1-jiangshanlai@gmail.com>
Cc: stable@vger.kernel.org
Fixes: cea0f0e7ea54 ("[PATCH] KVM: MMU: Shadow page table caching")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 4.9:
 - Keep passing vcpu argument to gpte_access functions
 - Adjust filenames, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/virtual/kvm/mmu.txt |  4 ++--
 arch/x86/kvm/paging_tmpl.h        | 14 +++++++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/=
mmu.txt
index 481b6a9c25d5..16ddfd6bd6a1 100644
--- a/Documentation/virtual/kvm/mmu.txt
+++ b/Documentation/virtual/kvm/mmu.txt
@@ -152,8 +152,8 @@ The following table shows translations encoded by leaf =
ptes, with higher-level
     shadow pages) so role.quadrant takes values in the range 0..3.  Each
     quadrant maps 1GB virtual address space.
   role.access:
-    Inherited guest access permissions in the form uwx.  Note execute
-    permission is positive, not negative.
+    Inherited guest access permissions from the parent ptes in the form uw=
x.
+    Note execute permission is positive, not negative.
   role.invalid:
     The page is invalid and should not be used.  It is a root page that is
     currently pinned (by a cpu hardware register pointing to it); once it =
is
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 47ba1e1b35f9..d92c7758efad 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -100,8 +100,8 @@ struct guest_walker {
 	gpa_t pte_gpa[PT_MAX_FULL_LEVELS];
 	pt_element_t __user *ptep_user[PT_MAX_FULL_LEVELS];
 	bool pte_writable[PT_MAX_FULL_LEVELS];
-	unsigned pt_access;
-	unsigned pte_access;
+	unsigned int pt_access[PT_MAX_FULL_LEVELS];
+	unsigned int pte_access;
 	gfn_t gfn;
 	struct x86_exception fault;
 };
@@ -380,13 +380,15 @@ static int FNAME(walk_addr_generic)(struct guest_walk=
er *walker,
 		}
=20
 		walker->ptes[walker->level - 1] =3D pte;
+
+		/* Convert to ACC_*_MASK flags for struct guest_walker.  */
+		walker->pt_access[walker->level - 1] =3D FNAME(gpte_access)(vcpu, pt_acc=
ess ^ walk_nx_mask);
 	} while (!is_last_gpte(mmu, walker->level, pte));
=20
 	pte_pkey =3D FNAME(gpte_pkeys)(vcpu, pte);
 	accessed_dirty =3D pte_access & PT_GUEST_ACCESSED_MASK;
=20
 	/* Convert to ACC_*_MASK flags for struct guest_walker.  */
-	walker->pt_access =3D FNAME(gpte_access)(vcpu, pt_access ^ walk_nx_mask);
 	walker->pte_access =3D FNAME(gpte_access)(vcpu, pte_access ^ walk_nx_mask=
);
 	errcode =3D permission_fault(vcpu, mmu, walker->pte_access, pte_pkey, acc=
ess);
 	if (unlikely(errcode))
@@ -424,7 +426,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker=
 *walker,
 	}
=20
 	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
-		 __func__, (u64)pte, walker->pte_access, walker->pt_access);
+		 __func__, (u64)pte, walker->pte_access,
+		 walker->pt_access[walker->level - 1]);
 	return 1;
=20
 error:
@@ -586,7 +589,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t ad=
dr,
 {
 	struct kvm_mmu_page *sp =3D NULL;
 	struct kvm_shadow_walk_iterator it;
-	unsigned direct_access, access =3D gw->pt_access;
+	unsigned int direct_access, access;
 	int top_level, ret;
 	gfn_t gfn, base_gfn;
=20
@@ -618,6 +621,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t ad=
dr,
 		sp =3D NULL;
 		if (!is_shadow_present_pte(*it.sptep)) {
 			table_gfn =3D gw->table_gfn[it.level - 2];
+			access =3D gw->pt_access[it.level - 2];
 			sp =3D kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
 					      false, access);
 		}

--b1h8futssbZDFl4p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHu8PkACgkQ57/I7JWG
EQkTBg//WnSskLk3e2ttU6wjtWGN4vypLpurdZtggt/28XngqSy061FoLH08DAEp
/ME7e/J2N5COsRdFgAaUxoikTCsr/qdpdOnOuhjH95WfFr0qGAJeV6HB6qYf1/dW
SM86VD3REjQTiqHzHoHICHJshYgyATscAa9OewBjYLEh85HK2VC3ehOq8Ems/niI
puyzw1/69RNV7S79L+B/MmEdUNimYw2RdB2JUMf1lbeyVaDzYp4fT1LCcKHc1MlK
yaQDWMe0iLPKDgwbEglxrpIklWAfIuRtT7CXyREHYMfVQLNvbmUSVIXT6UyKCG+z
aWwPQFyYpQBIPEgT40ybm0Wpj5Zo+LXU77enZiG29QNXG6NYlLmWB4pp+QFZPlCB
/NvPumoWmzoHEszgUB02cQ+atFdLuqpJdXhgVZWS3E3uMsSO3VLRuw5Y0fXNFbTa
yl98AaTI6cLgkmaFuC3QsVXs/LoXvp3pixHFZiF5Ch8RaBjDfOkCgAW43q7sZKPV
0Zic+RCmr7RPuOz0iu/ZlY7BF4KZJdXtgszlINT7eXy7b0C/MbiJHRYciiIBkZUX
NILwMFAE8XYnFQrvxN27ouBhvqnhlQBIFk1W7I0CmUwO/qLtniLTesPXRE13DCXS
9jkVA6i4jUsuKAEdJ05TQ76JAgFCpbOUAJ9nente4bApTg0Vqso=
=aJNK
-----END PGP SIGNATURE-----

--b1h8futssbZDFl4p--
