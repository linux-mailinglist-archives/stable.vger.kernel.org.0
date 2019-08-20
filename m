Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9DD5966DC
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 18:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfHTQ4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 12:56:30 -0400
Received: from shelob.surriel.com ([96.67.55.147]:58172 "EHLO
        shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfHTQ4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 12:56:30 -0400
Received: from imladris.surriel.com ([96.67.55.152])
        by shelob.surriel.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <riel@shelob.surriel.com>)
        id 1i07Qi-0004hb-Uw; Tue, 20 Aug 2019 12:56:21 -0400
Message-ID: <5a765e1bda8ec399a29dbdb195d15faa79c44273.camel@surriel.com>
Subject: Re: [PATCH v2] x86/mm/pti: in pti_clone_pgtable() don't increase
 addr by PUD_SIZE
From:   Rik van Riel <riel@surriel.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
Date:   Tue, 20 Aug 2019 12:56:20 -0400
In-Reply-To: <9A7CA4D3-76FB-479B-AC7A-FC3FD03B24DF@fb.com>
References: <20190820075128.2912224-1-songliubraving@fb.com>
         <20190820100055.GI2332@hirez.programming.kicks-ass.net>
         <alpine.DEB.2.21.1908201315450.2223@nanos.tec.linutronix.de>
         <44EA504D-2388-49EF-A807-B9712903B146@fb.com>
         <d887e9e228440097b666bcd316aabc9827a4b01e.camel@fb.com>
         <9A7CA4D3-76FB-479B-AC7A-FC3FD03B24DF@fb.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-pEXkl0lR3wnHbNuZx5FO"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-pEXkl0lR3wnHbNuZx5FO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-08-20 at 10:00 -0400, Song Liu wrote:
>=20
> From 9ae74cff4faf4710a11cb8da4c4a3f3404bd9fdd Mon Sep 17 00:00:00
> 2001
> From: Song Liu <songliubraving@fb.com>
> Date: Mon, 19 Aug 2019 23:59:47 -0700
> Subject: [PATCH] x86/mm/pti: in pti_clone_pgtable(), increase addr
> properly
>=20
> Before 32-bit support, pti_clone_pmds() always adds PMD_SIZE to addr.
> This behavior changes after the 32-bit support:  pti_clone_pgtable()
> increases addr by PUD_SIZE for pud_none(*pud) case, and increases
> addr by
> PMD_SIZE for pmd_none(*pmd) case. However, this is not accurate
> because
> addr may not be PUD_SIZE/PMD_SIZE aligned.
>=20
> Fix this issue by properly rounding up addr to next PUD_SIZE/PMD_SIZE
> in these two cases.
>=20
> Cc: stable@vger.kernel.org # v4.19+
> Fixes: 16a3fe634f6a ("x86/mm/pti: Clone kernel-image on PTE level for
> 32 bit")
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>

This looks like it should do the trick!

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

--=-pEXkl0lR3wnHbNuZx5FO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAl1cJjQACgkQznnekoTE
3oP2CQf5AbKPnlETNpt54qUIOxEF1nXrAYDVtGeSK8Kss4VQHeyuezQYzNd2Yb64
ESHIJFxoeBzfElljfEsvT3BvYYcFtlyS87iND3pr9WWnQ5nFM/kASzp0fGmBzoTB
diU5pD5yg8fBWbXMAwSzDA57CCogWInsgI6UVjli37Y20F+LDS/duzlslae/sxWB
+hvpy43ewEgbQj/3hRrO7S56ssea8wMkwQrVVRpXzT6bbVGMmt8vRfluDn/hG8Cu
Prrk9i+Y2OuCpBiZ//0WAHLhyG74wh6i4iLzt3bqO9vWlB3LkD+C8MCnZBC22Ovw
9umcCc9SszqbVBoDM4zCCAmQ9Ru0ig==
=Wneu
-----END PGP SIGNATURE-----

--=-pEXkl0lR3wnHbNuZx5FO--

