Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6ECE6B388
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 03:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfGQBvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 21:51:14 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15200 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfGQBvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jul 2019 21:51:14 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d2e7f170000>; Tue, 16 Jul 2019 18:51:19 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 16 Jul 2019 18:51:13 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 16 Jul 2019 18:51:13 -0700
Received: from [10.110.48.28] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 17 Jul
 2019 01:51:11 +0000
Subject: Re: [PATCH 3/3] mm/hmm: Fix bad subpage pointer in try_to_unmap_one
To:     Ralph Campbell <rcampbell@nvidia.com>, <linux-mm@kvack.org>
CC:     <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@mellanox.com>, <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20190717001446.12351-1-rcampbell@nvidia.com>
 <20190717001446.12351-4-rcampbell@nvidia.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <67107cc6-cc8a-c072-a323-b5c417fb45c6@nvidia.com>
Date:   Tue, 16 Jul 2019 18:51:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190717001446.12351-4-rcampbell@nvidia.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL106.nvidia.com (172.18.146.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563328279; bh=1dmjq+OnPGvrHvEejwkg5+2298h2fZxzldWUuZPTtbI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=AIh90U/Cm54D0y3Ou8lNAM1j8ozgoxqDzEIxoGg959X3ZDt/Gxbu0DLmQZjTpiPT3
         k0E4lrszsGcs4DXpbafUoCk0Tvr1JFCUh3CZ9+tmc1Pe9C7eW3+7L6m3TnM6zAoOOO
         uEW7HREvelwp9GSn7pMHEEYUvqSF5SL6ERgDBFqfOL5pI5l6ukeW8cmk2EOojUvVyW
         8HQDwvUHMa7xudjZMCkqEhRWCYTYCfWG1qPhlloRFCHHYVkNTRwrsQFxObgdrwQj01
         p9dtBgaPXQTk98EdNnY0m2+msq9M+krIEk6rKhqu9u/2MdjgnvwvxMKLi30pjZ3JBp
         kklI/IdXiI2ug==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/16/19 5:14 PM, Ralph Campbell wrote:
> When migrating an anonymous private page to a ZONE_DEVICE private page,
> the source page->mapping and page->index fields are copied to the
> destination ZONE_DEVICE struct page and the page_mapcount() is increased.
> This is so rmap_walk() can be used to unmap and migrate the page back to
> system memory. However, try_to_unmap_one() computes the subpage pointer
> from a swap pte which computes an invalid page pointer and a kernel panic
> results such as:
>=20
> BUG: unable to handle page fault for address: ffffea1fffffffc8
>=20
> Currently, only single pages can be migrated to device private memory so
> no subpage computation is needed and it can be set to "page".
>=20
> Fixes: a5430dda8a3a1c ("mm/migrate: support un-addressable ZONE_DEVICE pa=
ge in migration")
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>  mm/rmap.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/mm/rmap.c b/mm/rmap.c
> index e5dfe2ae6b0d..ec1af8b60423 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1476,6 +1476,7 @@ static bool try_to_unmap_one(struct page *page, str=
uct vm_area_struct *vma,
>  			 * No need to invalidate here it will synchronize on
>  			 * against the special swap migration pte.
>  			 */
> +			subpage =3D page;
>  			goto discard;
>  		}

The problem is clear, but the solution still leaves the code ever so slight=
ly
more confusing, and it was already pretty difficult to begin with.

I still hold out hope for some comment documentation at least, and maybe
even just removing the subpage variable (as Jerome mentioned, offline) as
well.

Jerome?


thanks,
--=20
John Hubbard
NVIDIA
