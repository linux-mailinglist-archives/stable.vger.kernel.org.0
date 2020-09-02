Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C7625B61A
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 23:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgIBVrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 17:47:16 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4103 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgIBVrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 17:47:15 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5012630000>; Wed, 02 Sep 2020 14:45:07 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 02 Sep 2020 14:47:15 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 02 Sep 2020 14:47:15 -0700
Received: from [10.2.161.253] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 2 Sep
 2020 21:47:13 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     Ralph Campbell <rcampbell@nvidia.com>
CC:     <linux-mm@kvack.org>, <nouveau@lists.freedesktop.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Jerome Glisse" <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        "Alistair Popple" <apopple@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Ben Skeggs <bskeggs@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] mm/thp: fix __split_huge_pmd_locked() for
 migration PMD
Date:   Wed, 2 Sep 2020 17:47:10 -0400
X-Mailer: MailMate (1.13.1r5705)
Message-ID: <78B69571-13C6-4BF5-8478-6AAA4AB2C287@nvidia.com>
In-Reply-To: <20200902165830.5367-2-rcampbell@nvidia.com>
References: <20200902165830.5367-1-rcampbell@nvidia.com>
 <20200902165830.5367-2-rcampbell@nvidia.com>
MIME-Version: 1.0
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: multipart/signed;
        boundary="=_MailMate_73631622-91D5-4F7B-9B08-2022739FCA8C_=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599083107; bh=SZek1ZYQANXJT4VXlmp7MHjIQWueJPTMM8g01GnOGfQ=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:X-Mailer:Message-ID:
         In-Reply-To:References:MIME-Version:X-Originating-IP:
         X-ClientProxiedBy:Content-Type;
        b=Sxs0HfRXu2g3r8QL5KmEF7wT2mHFg/ypmWRuBkArGct5jJkkS5WzYJrumWzk7nc4c
         b55YSPGbQhBBwE/77G9wVGG7YNr8dGfe6PdFMrcDIyb4yK7o/TZ2Xlc93rXbKFhg9r
         EQRO9BhOZgZCtMaf5rXnzP2C2j6gOJeElK4waNbd19aGTpfRLgSAOHSUhJJ/EitGZ5
         LZVRadQNUj6VLmDXM1g5DCHaeMgTEYFjq9Wm1PaDeGB42HfvH3goVfzlyFOQHmf6JQ
         28ncSFI/lCOE/B47LXbsfq//gd4rP0Hs3PZUkmofJhtMJ0cBOF72amG6cZUYwQ4l0l
         Mb1+X4w/lDC5Q==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_73631622-91D5-4F7B-9B08-2022739FCA8C_=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On 2 Sep 2020, at 12:58, Ralph Campbell wrote:

> A migrating transparent huge page has to already be unmapped. Otherwise=
,
> the page could be modified while it is being copied to a new page and
> data could be lost. The function __split_huge_pmd() checks for a PMD
> migration entry before calling __split_huge_pmd_locked() leading one to=

> think that __split_huge_pmd_locked() can handle splitting a migrating P=
MD.
> However, the code always increments the page->_mapcount and adjusts the=

> memory control group accounting assuming the page is mapped.
> Also, if the PMD entry is a migration PMD entry, the call to
> is_huge_zero_pmd(*pmd) is incorrect because it calls pmd_pfn(pmd) inste=
ad
> of migration_entry_to_pfn(pmd_to_swp_entry(pmd)).
> Fix these problems by checking for a PMD migration entry.
>
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>

Thanks for the fix. You can add Reviewed-by: Zi Yan <ziy@nvidia.com>

I think you also want to add the Fixes tag and cc stable.

Fixes 84c3fc4e9c56 (=E2=80=9Cmm: thp: check pmd migration entry in common=
 path=E2=80=9D)
cc: stable@vger.kernel.org # 4.14+

> ---
>  mm/huge_memory.c | 42 +++++++++++++++++++++++-------------------
>  1 file changed, 23 insertions(+), 19 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2a468a4acb0a..606d712d9505 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2023,7 +2023,7 @@ static void __split_huge_pmd_locked(struct vm_are=
a_struct *vma, pmd_t *pmd,
>  		put_page(page);
>  		add_mm_counter(mm, mm_counter_file(page), -HPAGE_PMD_NR);
>  		return;
> -	} else if (is_huge_zero_pmd(*pmd)) {
> +	} else if (pmd_trans_huge(*pmd) && is_huge_zero_pmd(*pmd)) {
>  		/*
>  		 * FIXME: Do we want to invalidate secondary mmu by calling
>  		 * mmu_notifier_invalidate_range() see comments below inside
> @@ -2117,30 +2117,34 @@ static void __split_huge_pmd_locked(struct vm_a=
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
> -	lock_page_memcg(page);
> -	if (atomic_add_negative(-1, compound_mapcount_ptr(page))) {
> -		/* Last compound_mapcount is gone. */
> -		__dec_lruvec_page_state(page, NR_ANON_THPS);
> -		if (TestClearPageDoubleMap(page)) {
> -			/* No need in mapcount reference anymore */
> +	if (!pmd_migration) {
> +		/*
> +		 * Set PG_double_map before dropping compound_mapcount to avoid
> +		 * false-negative page_mapped().
> +		 */
> +		if (compound_mapcount(page) > 1 &&
> +		    !TestSetPageDoubleMap(page)) {
>  			for (i =3D 0; i < HPAGE_PMD_NR; i++)
> -				atomic_dec(&page[i]._mapcount);
> +				atomic_inc(&page[i]._mapcount);
> +		}
> +
> +		lock_page_memcg(page);
> +		if (atomic_add_negative(-1, compound_mapcount_ptr(page))) {
> +			/* Last compound_mapcount is gone. */
> +			__dec_lruvec_page_state(page, NR_ANON_THPS);
> +			if (TestClearPageDoubleMap(page)) {
> +				/* No need in mapcount reference anymore */
> +				for (i =3D 0; i < HPAGE_PMD_NR; i++)
> +					atomic_dec(&page[i]._mapcount);
> +			}
>  		}
> +		unlock_page_memcg(page);
>  	}
> -	unlock_page_memcg(page);
>
>  	smp_wmb(); /* make pte visible before pmd */
>  	pmd_populate(mm, pmd, pgtable);
> -- =

> 2.20.1


=E2=80=94
Best Regards,
Yan Zi

--=_MailMate_73631622-91D5-4F7B-9B08-2022739FCA8C_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEEh7yFAW3gwjwQ4C9anbJR82th+ooFAl9QEt4PHHppeUBudmlk
aWEuY29tAAoJEJ2yUfNrYfqK2RAP/jZpNOlzIVAWu/HetcUk0JekLJU2qVRUKD7w
+vSoB3QfAzbbHrEr44ZKzWHGYIADV2eun8GOlaY4U9I+V9d8VTJ7X6rPF4/P3Mj9
quvN3yVi9/GJnqYpBDD15L+p90SylE5lGwe+4zje5AYbq6BIj5l3fB6m3rNR0D9G
0Wx9BdnmPs6cMPkCz4Aj9nXX6LOVu7zlKb3FJPBO2NUoZnkQpda3wRzpd/0DVrj8
rGVNw+QtnjAcKZtH2St005dB/qb0Z1ng83dgmN3KNJRZWYRYetN3lF79vUU59iGn
Kwcc+T4vDX8ZkzldCILIYi4qsWH7oqqTkoOT8oqHFzj4u3ZXttnvdeiE+cavZrUr
QbgubSF9I7Sm4zheJ+LJEC53Wn8up8jbfdsbyzPXEFJbfozmTr8hK4gODmtAUNz9
KevDlttqqrf/BBGHoV94RnLt2wMMt9RyUwlpu6t1ETzRhO+vPKknji0h4DyX3o2v
T7n3dbRN8uPNOEBabzrXeGDwlsqXbnzYdVEZTojuD5Umer3+36832TAOndjj4Zep
pJEM3YCeoG4INtDDv0HlzNugZ9bwEaz1Hm4zicAlxqeiw7g19auPlNBvt3bsBALE
LwW82R2jQGTNn7OtuMz5d7WVNAjtCnmGndupISnL1VI1lPcS+g933m4KRGGgDytN
zdwgbnGP
=A3iO
-----END PGP SIGNATURE-----

--=_MailMate_73631622-91D5-4F7B-9B08-2022739FCA8C_=--
