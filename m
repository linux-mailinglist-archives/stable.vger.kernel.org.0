Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE9736ED43
	for <lists+stable@lfdr.de>; Sat, 20 Jul 2019 04:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733205AbfGTCD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 22:03:56 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1032 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733067AbfGTCD4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 22:03:56 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d3276920000>; Fri, 19 Jul 2019 19:04:02 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 19 Jul 2019 19:03:55 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 19 Jul 2019 19:03:55 -0700
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 20 Jul
 2019 02:03:54 +0000
Subject: Re: [PATCH] mm/migrate: initialize pud_entry in migrate_vma()
To:     Ralph Campbell <rcampbell@nvidia.com>, <linux-mm@kvack.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20190719233225.12243-1-rcampbell@nvidia.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <de0f0abd-d521-9b68-80b2-92e06c6bb8ac@nvidia.com>
Date:   Fri, 19 Jul 2019 19:03:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190719233225.12243-1-rcampbell@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563588242; bh=K89J2IEPJbk6VmuKgUrqZ1VHo+WQOc0Cte4m7yFZoOE=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=FxK9AQGwhecU2l9E5xWnRjCI47IQqIB1G9YP1qaTQccoxr6/fiLGGjY0YSYude6Ss
         ldx4YsThY7WOYGW4UCOdZSHrOrMLWRiaOTTqh477zVcFtymsttcJvuAtY4Kshpzop0
         05PJiu02FZmZ+NtH84hCL4TFh8r/ULQplJ+ck6f5iEkLuxOYPAGxEadkPzJhh3hB4q
         IUYfFsqgnuCrhIfSyTwbQMWR6k03sGAIe3VaTzUem3j/u0Ougpqao7phyGoi//a8jr
         hWzwc654tVQdZg+yMN4xCgTR00cQoYFuD3oWQHcYpWnpmuw23c/tdcZX3fkdD6w1+o
         8ynbqObsmbohw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/19/19 4:32 PM, Ralph Campbell wrote:
> When CONFIG_MIGRATE_VMA_HELPER is enabled, migrate_vma() calls
> migrate_vma_collect() which initializes a struct mm_walk but
> didn't initialize mm_walk.pud_entry. (Found by code inspection)
> Use a C structure initialization to make sure it is set to NULL.
>=20
> Fixes: 8763cb45ab967 ("mm/migrate: new memory migration helper for use wi=
th
> device memory")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  mm/migrate.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
>=20
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 515718392b24..a42858d8e00b 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2340,16 +2340,13 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  static void migrate_vma_collect(struct migrate_vma *migrate)
>  {
>  	struct mmu_notifier_range range;
> -	struct mm_walk mm_walk;
> -
> -	mm_walk.pmd_entry =3D migrate_vma_collect_pmd;
> -	mm_walk.pte_entry =3D NULL;
> -	mm_walk.pte_hole =3D migrate_vma_collect_hole;
> -	mm_walk.hugetlb_entry =3D NULL;
> -	mm_walk.test_walk =3D NULL;
> -	mm_walk.vma =3D migrate->vma;
> -	mm_walk.mm =3D migrate->vma->vm_mm;
> -	mm_walk.private =3D migrate;
> +	struct mm_walk mm_walk =3D {
> +		.pmd_entry =3D migrate_vma_collect_pmd,
> +		.pte_hole =3D migrate_vma_collect_hole,
> +		.vma =3D migrate->vma,
> +		.mm =3D migrate->vma->vm_mm,
> +		.private =3D migrate,
> +	};

Neatly done.

> =20
>  	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm_walk.mm,
>  				migrate->start,
>=20

Reviewed-by: John Hubbard <jhubbard@nvidia.com>

thanks,
--=20
John Hubbard
NVIDIA
