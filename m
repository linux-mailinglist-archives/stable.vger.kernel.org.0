Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0235549851C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 17:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243876AbiAXQpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 11:45:05 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:42362 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243874AbiAXQpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 11:45:03 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC2Sj-00073r-OD; Mon, 24 Jan 2022 17:45:01 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC2Si-009zKv-Vk;
        Mon, 24 Jan 2022 17:45:00 +0100
Date:   Mon, 24 Jan 2022 17:45:00 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH 4.9 4/4] KVM: do not allow mapping valid but
 non-reference-counted pages
Message-ID: <Ye7XjLxf61gjp8w2@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bO0PXj4JUsqXi3Rq"
Content-Disposition: inline
In-Reply-To: <Ye7WqMoYNyxOqWId@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bO0PXj4JUsqXi3Rq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Nicholas Piggin <npiggin@gmail.com>

commit f8be156be163a052a067306417cd0ff679068c97 upstream.

It's possible to create a region which maps valid but non-refcounted
pages (e.g., tail pages of non-compound higher order allocations). These
host pages can then be returned by gfn_to_page, gfn_to_pfn, etc., family
of APIs, which take a reference to the page, which takes it from 0 to 1.
When the reference is dropped, this will free the page incorrectly.

Fix this by only taking a reference on valid pages if it was non-zero,
which indicates it is participating in normal refcounting (and can be
released with put_page).

This addresses CVE-2021-22543.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Tested-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 virt/kvm/kvm_main.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dc7b60c81039..d9b7001227e3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1513,6 +1513,13 @@ static bool vma_is_valid(struct vm_area_struct *vma,=
 bool write_fault)
 	return true;
 }
=20
+static int kvm_try_get_pfn(kvm_pfn_t pfn)
+{
+	if (kvm_is_reserved_pfn(pfn))
+		return 1;
+	return get_page_unless_zero(pfn_to_page(pfn));
+}
+
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       unsigned long addr, bool *async,
 			       bool write_fault, bool *writable,
@@ -1562,13 +1569,21 @@ static int hva_to_pfn_remapped(struct vm_area_struc=
t *vma,
 	 * Whoever called remap_pfn_range is also going to call e.g.
 	 * unmap_mapping_range before the underlying pages are freed,
 	 * causing a call to our MMU notifier.
+	 *
+	 * Certain IO or PFNMAP mappings can be backed with valid
+	 * struct pages, but be allocated without refcounting e.g.,
+	 * tail pages of non-compound higher order allocations, which
+	 * would then underflow the refcount when the caller does the
+	 * required put_page. Don't allow those pages here.
 	 */=20
-	kvm_get_pfn(pfn);
+	if (!kvm_try_get_pfn(pfn))
+		r =3D -EFAULT;
=20
 out:
 	pte_unmap_unlock(ptep, ptl);
 	*p_pfn =3D pfn;
-	return 0;
+
+	return r;
 }
=20
 /*

--bO0PXj4JUsqXi3Rq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHu14wACgkQ57/I7JWG
EQn9Ww//SPa5UkNujSgCZHSur49Srl/1wFkNWsVUNiEHzr6cI35Ykup1eZM1Amsf
Z75jznbNha2t1f4VfmJkgfvDSQ1XSdhIUOEdbBegMhoCuDRcZMk6oXC+mBqELXC3
IGBoPJAsGFwlm8sRI3RNcJSdGL+YFOEm30LeyuvPwCs36DOXDVr21RrccrVD02EX
xsXlsFkVWA5zATzdlUlL2pnVyII/kwCvkWzd6KPZiB9GcBVlIY0onEQOtOMfxFI+
Ni1xMNqiCWbtcTXs7cXM7FvD1Yb4+ZjrejwCNwurQ0XDwuvjKDIF6Dz9O/6gGeS8
Mk49r5c3vc+lrVtJNbNJ/mireQg/1YCAH87jUfUUABGlwXODoUIA4PGbWDFKnV1O
7ZtPBjy/7Nx3sqPeh7tGJjUo4e9EanvVCNIiqdffjrv/TlY+7bJlfMVnpc0PEXCD
2kjeo8lx/qGBieogKfvmZEW9hJdfTYqWx9XZxHDwnyMXn+ARtWsMGwLYP1DjILaD
9sfSKrJLmTB5Ye1Hfsb0JzWsOOtS+MPsNU5+ZezVmY+jo/AQnnJiRk8KkcQ6ql8E
ZZthm+J84Q4JzbmwWUBQ4oEyDcrczqVWZKZu+IyUjPCg/7UEA68BGMTNtF1ErZ23
h/ZJxj9AaKFPoRTMhB2YyxUVsr7SgfeiPc2Wew394YPx3X29g3I=
=dCPv
-----END PGP SIGNATURE-----

--bO0PXj4JUsqXi3Rq--
