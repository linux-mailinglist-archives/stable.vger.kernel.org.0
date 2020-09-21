Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B26273212
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 20:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgIUSl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 14:41:27 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13150 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgIUSl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 14:41:27 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f68f3ca0001>; Mon, 21 Sep 2020 11:41:14 -0700
Received: from [10.2.170.77] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 21 Sep
 2020 18:41:25 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     <stable@vger.kernel.org>
CC:     Zi Yan <ziy@nvidia.com>, Ralph Campbell <rcampbell@nvidia.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Yang Shi <shy828301@gmail.com>,
        "Jerome Glisse" <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        "Alistair Popple" <apopple@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Ben Skeggs <bskeggs@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm/thp: fix __split_huge_pmd_locked() for migration PMD
Date:   Mon, 21 Sep 2020 14:41:22 -0400
X-Mailer: MailMate (1.13.2r5673)
Message-ID: <3AFA067F-5635-459D-B8EE-B4B6FD7C7222@nvidia.com>
In-Reply-To: <20200921182748.2618107-1-zi.yan@sent.com>
References: <20200921182748.2618107-1-zi.yan@sent.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
        boundary="=_MailMate_CA060674-0B0E-406F-9E44-5ADB51D228E2_=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600713674; bh=sFsAhV4R32PGJR50vaoxmhZOoHsVk3f2I7OB3wPlfIk=;
        h=From:To:CC:Subject:Date:X-Mailer:Message-ID:In-Reply-To:
         References:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=Q01dEfoUqSvFTT/nFSilvlMegxBSD8XmzHFwVwAQno/6tNgpzf2pJdhBY51fg+LTm
         9QL0EQUSla8Y5y4qRhz0jZM7xfckdVHVhx1oTjRtE+qOdpp+mG8Tu40ms4LXFIf++k
         iQvU5e3fuGev8NalPykLocqIqnILce8y9vLqi8L/KsIw3VmwHoUIQPQoJ06sUjUt9Y
         IVRqpymXgUhr6YnGPwGTGjl/9f9FiobZKMQMgss7JY0D4cCwcdjdxTRkiGGbTLXmla
         LrLerFBbIwj+skvRJiiqS0MmkI6ASQi9ErF+49ATYlhDbKq7cBUujkXY+JNPCUeN2d
         2LdTZamH3QaPA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_CA060674-0B0E-406F-9E44-5ADB51D228E2_=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On 21 Sep 2020, at 14:27, Zi Yan wrote:

> From: Zi Yan <ziy@nvidia.com>
>
> For 4.19.

It applies to v5.4.y too.

>
> [Upstream commitid ec0abae6dcdf7ef88607c869bf35a4b63ce1b370]
>
> From: Ralph Campbell <rcampbell@nvidia.com>
> Date: Fri, 18 Sep 2020 21:20:24 -0700
> Subject: [PATCH] mm/thp: fix __split_huge_pmd_locked() for migration PM=
D
>
> A migrating transparent huge page has to already be unmapped.  Otherwis=
e,
> the page could be modified while it is being copied to a new page and d=
ata
> could be lost.  The function __split_huge_pmd() checks for a PMD migrat=
ion
> entry before calling __split_huge_pmd_locked() leading one to think tha=
t
> __split_huge_pmd_locked() can handle splitting a migrating PMD.
>
> However, the code always increments the page->_mapcount and adjusts the=

> memory control group accounting assuming the page is mapped.
>
> Also, if the PMD entry is a migration PMD entry, the call to
> is_huge_zero_pmd(*pmd) is incorrect because it calls pmd_pfn(pmd) inste=
ad
> of migration_entry_to_pfn(pmd_to_swp_entry(pmd)).  Fix these problems b=
y
> checking for a PMD migration entry.
>
> Fixes: 84c3fc4e9c56 ("mm: thp: check pmd migration entry in common path=
")
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Yang Shi <shy828301@gmail.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Cc: Jerome Glisse <jglisse@redhat.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Bharata B Rao <bharata@linux.ibm.com>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: <stable@vger.kernel.org>	[4.14+]
> Link: https://lkml.kernel.org/r/20200903183140.19055-1-rcampbell@nvidia=
=2Ecom
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  mm/huge_memory.c | 37 ++++++++++++++++++++-----------------
>  1 file changed, 20 insertions(+), 17 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1443ae6fee9b..811fb2477ecd 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2145,7 +2145,7 @@ static void __split_huge_pmd_locked(struct vm_are=
a_struct *vma, pmd_t *pmd,
>  		put_page(page);
>  		add_mm_counter(mm, mm_counter_file(page), -HPAGE_PMD_NR);
>  		return;
> -	} else if (is_huge_zero_pmd(*pmd)) {
> +	} else if (pmd_trans_huge(*pmd) && is_huge_zero_pmd(*pmd)) {
>  		/*
>  		 * FIXME: Do we want to invalidate secondary mmu by calling
>  		 * mmu_notifier_invalidate_range() see comments below inside
> @@ -2233,26 +2233,29 @@ static void __split_huge_pmd_locked(struct vm_a=
rea_struct *vma, pmd_t *pmd,
>  		pte =3D pte_offset_map(&_pmd, addr);
>  		BUG_ON(!pte_none(*pte));
>  		set_pte_at(mm, addr, pte, entry);
> -		atomic_inc(&page[i]._mapcount);
> -		pte_unmap(pte);
> -	}
> -
> -	/*
> -	 * Set PG_double_map before dropping compound_mapcount to avoid
> -	 * false-negative page_mapped().
> -	 */
> -	if (compound_mapcount(page) > 1 && !TestSetPageDoubleMap(page)) {
> -		for (i =3D 0; i < HPAGE_PMD_NR; i++)
> +		if (!pmd_migration)
>  			atomic_inc(&page[i]._mapcount);
> +		pte_unmap(pte);
>  	}
>
> -	if (atomic_add_negative(-1, compound_mapcount_ptr(page))) {
> -		/* Last compound_mapcount is gone. */
> -		__dec_node_page_state(page, NR_ANON_THPS);
> -		if (TestClearPageDoubleMap(page)) {
> -			/* No need in mapcount reference anymore */
> +	if (!pmd_migration) {
> +		/*
> +		 * Set PG_double_map before dropping compound_mapcount to avoid
> +		 * false-negative page_mapped().
> +		 */
> +		if (compound_mapcount(page) > 1 && !TestSetPageDoubleMap(page)) {
>  			for (i =3D 0; i < HPAGE_PMD_NR; i++)
> -				atomic_dec(&page[i]._mapcount);
> +				atomic_inc(&page[i]._mapcount);
> +		}
> +
> +		if (atomic_add_negative(-1, compound_mapcount_ptr(page))) {
> +			/* Last compound_mapcount is gone. */
> +			__dec_node_page_state(page, NR_ANON_THPS);
> +			if (TestClearPageDoubleMap(page)) {
> +				/* No need in mapcount reference anymore */
> +				for (i =3D 0; i < HPAGE_PMD_NR; i++)
> +					atomic_dec(&page[i]._mapcount);
> +			}
>  		}
>  	}
>
> -- =

> 2.28.0


=E2=80=94
Best Regards,
Yan Zi

--=_MailMate_CA060674-0B0E-406F-9E44-5ADB51D228E2_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEEh7yFAW3gwjwQ4C9anbJR82th+ooFAl9o89IPHHppeUBudmlk
aWEuY29tAAoJEJ2yUfNrYfqKfi4P/3R9ZBOKbkhZ9fQa+4oeOog7QBaIxMsGCo8c
Mi9Uueda4IDXNt6GGJUe8fP6WzStSNDO2nJxPVXIziASNP1satDoTYPd2Ab5zo44
npuCCjJgGhlLJp9VOyUdkBBNjY7wM8nuufnK811+vMnU0FRahRxpNBy52pkP8SNP
MdDqMVJmvxux69+Psb4kAmsja3a5g1qNUP5YufrEzI8WUTKbnwPVWkQsg7CvspMH
DvZoYPdGaizZ1X7Gfx8C8vWhwYNpT1Hr7dXGZV3FCGkG/NnmY+1t/i8ajxMup1id
MmCDqP0bCCtbOf+zAtOGgTFQcd30TbElec4yBqS9+KjO84LMN+Xj6dtFdQEiIo+V
yh4mhVx5JI3obKqEYziAs0MWHIpwWLx5BWVZ5sB1+mjaZBRGuJvWEHmwr2SqqlUJ
qIv6tf8MtxrBTic80XyKeZFGjs0nzaQfgUsrHmHYNWrLyt9mzvVBkYlGGEL4eu1e
GVeeAMRDahYmSlf6IvLAYL0OS6rmHDpI3t248fqayMNGqPrqIqqSCLkaqTW6V8jP
D1NxtdoVNHhBRyGpsj9GVLVO0twlityIhy77/UCw21GmWw8ESy7KYlgLTRwdUyB4
Na4GBXcewXV0Vve56+lEUl7LwqKhxxcLZ7je1Od3pAAO3G64VAumDSs/+loYFAJk
gz3PeASa
=7zqr
-----END PGP SIGNATURE-----

--=_MailMate_CA060674-0B0E-406F-9E44-5ADB51D228E2_=--
