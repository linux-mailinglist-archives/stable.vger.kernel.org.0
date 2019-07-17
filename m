Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D29B6B373
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 03:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbfGQBkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 21:40:16 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1365 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfGQBkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jul 2019 21:40:15 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d2e7c7b0000>; Tue, 16 Jul 2019 18:40:11 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 16 Jul 2019 18:40:13 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 16 Jul 2019 18:40:13 -0700
Received: from [10.110.48.28] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 17 Jul
 2019 01:40:09 +0000
Subject: Re: [PATCH 2/3] mm/hmm: fix ZONE_DEVICE anon page mapping reuse
To:     Ralph Campbell <rcampbell@nvidia.com>, <linux-mm@kvack.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        "Christoph Hellwig" <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "Logan Gunthorpe" <logang@deltatee.com>,
        Ira Weiny <ira.weiny@intel.com>,
        "Matthew Wilcox" <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        "Jan Kara" <jack@suse.cz>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Mike Kravetz" <mike.kravetz@oracle.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>
References: <20190717001446.12351-1-rcampbell@nvidia.com>
 <20190717001446.12351-3-rcampbell@nvidia.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <ebd1ea66-f8c0-7a03-594c-dce9ec4d0fa6@nvidia.com>
Date:   Tue, 16 Jul 2019 18:40:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190717001446.12351-3-rcampbell@nvidia.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL106.nvidia.com (172.18.146.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563327611; bh=4zW6WMS58NKwkK2EYGU0erGO3LAau6AlIU4w5xeRscI=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=NMQ9OBewREnnGi+MzFdTbeISiClUuUw26DewOW2/gLvttzLKSC1XGFYxlpGNrQX76
         VKZ6sM2Vrn3hs4a/KqcMLLarvtE7n9bdVrc/pixmxjDDxNbLYX+yP1MKKbW3j3MhJD
         EAElXQgWL2H1BcX1fP8k557RCIcWIJXff0FLDHEIV/d6O2SXxB3AnwPgo3z7T34t1Q
         aDnlxp0eegoOosDedPH/as6UFkO61/whGbcnxvOiTJkKqDKnc2NuJXMUcpffcJOE93
         F5/9V7Uq09XAxJeIcx82qR198xvNbwe4WkoAQeESsy2JsDBAPvvrZu+Q1vIE1+IGqN
         2TRvEOS/JW3gw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/16/19 5:14 PM, Ralph Campbell wrote:
> When a ZONE_DEVICE private page is freed, the page->mapping field can be
> set. If this page is reused as an anonymous page, the previous value can
> prevent the page from being inserted into the CPU's anon rmap table.
> For example, when migrating a pte_none() page to device memory:
>   migrate_vma(ops, vma, start, end, src, dst, private)
>     migrate_vma_collect()
>       src[] =3D MIGRATE_PFN_MIGRATE
>     migrate_vma_prepare()
>       /* no page to lock or isolate so OK */
>     migrate_vma_unmap()
>       /* no page to unmap so OK */
>     ops->alloc_and_copy()
>       /* driver allocates ZONE_DEVICE page for dst[] */
>     migrate_vma_pages()
>       migrate_vma_insert_page()
>         page_add_new_anon_rmap()
>           __page_set_anon_rmap()
>             /* This check sees the page's stale mapping field */
>             if (PageAnon(page))
>               return
>             /* page->mapping is not updated */
>=20
> The result is that the migration appears to succeed but a subsequent CPU
> fault will be unable to migrate the page back to system memory or worse.
>=20
> Clear the page->mapping field when freeing the ZONE_DEVICE page so stale
> pointer data doesn't affect future page use.
>=20
> Fixes: b7a523109fb5c9d2d6dd ("mm: don't clear ->mapping in hmm_devmem_fre=
e")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Jan Kara <jack@suse.cz>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
> ---
>  kernel/memremap.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index bea6f887adad..238ae5d0ae8a 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
> @@ -408,6 +408,10 @@ void __put_devmap_managed_page(struct page *page)
> =20
>  		mem_cgroup_uncharge(page);
> =20
> +		/* Clear anonymous page mapping to prevent stale pointers */

This is sufficiently complex, that some concise form of the documentation
that you've put in the commit description, needs to also exist right here, =
as
a comment.=20

How's this read:

diff --git a/kernel/memremap.c b/kernel/memremap.c
index 238ae5d0ae8a..e52e9da5d0a7 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -408,7 +408,27 @@ void __put_devmap_managed_page(struct page *page)
=20
                mem_cgroup_uncharge(page);
=20
-               /* Clear anonymous page mapping to prevent stale pointers *=
/
+               /*
+                * When a device_private page is freed, the page->mapping f=
ield
+                * may still contain a (stale) mapping value. For example, =
the
+                * lower bits of page->mapping may still identify the page =
an an
+                * anonymous page. Ultimately, this entire field is just st=
ale
+                * and wrong, and it will cause errors if not cleared. One
+                * example is:
+                *
+                *  migrate_vma_pages()
+                *    migrate_vma_insert_page()
+                *      page_add_new_anon_rmap()
+                *        __page_set_anon_rmap()
+                *          ...checks page->mapping, via PageAnon(page) cal=
l,
+                *            and incorrectly concludes that the page is an
+                *            anonymous page. Therefore, it incorrectly,
+                *            silently fails to set up the new anon rmap.
+                *
+                * For other types of ZONE_DEVICE pages, migration is eithe=
r
+                * handled differently or not done at all, so there is no n=
eed
+                * to clear page->mapping.
+                */
                if (is_device_private_page(page))
                        page->mapping =3D NULL;
=20
?

thanks,
--=20
John Hubbard
NVIDIA
