Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 370347420D
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 01:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfGXX1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 19:27:17 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3090 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729776AbfGXX1P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 19:27:15 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d38e9580001>; Wed, 24 Jul 2019 16:27:20 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 24 Jul 2019 16:27:13 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 24 Jul 2019 16:27:13 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 24 Jul
 2019 23:27:12 +0000
Received: from hqnvemgw01.nvidia.com (172.20.150.20) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 24 Jul 2019 23:27:12 +0000
Received: from rcampbell-dev.nvidia.com (Not Verified[10.110.48.66]) by hqnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5d38e9500002>; Wed, 24 Jul 2019 16:27:12 -0700
From:   Ralph Campbell <rcampbell@nvidia.com>
To:     <linux-mm@kvack.org>
CC:     <linux-kernel@vger.kernel.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        <stable@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>,
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
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>
Subject: [PATCH v3 2/3] mm/hmm: fix ZONE_DEVICE anon page mapping reuse
Date:   Wed, 24 Jul 2019 16:26:59 -0700
Message-ID: <20190724232700.23327-3-rcampbell@nvidia.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190724232700.23327-1-rcampbell@nvidia.com>
References: <20190724232700.23327-1-rcampbell@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1564010840; bh=AGMennFGR3RQwqOaKvawxIvCw+p1UUJkNAyV14vll0s=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding;
        b=T/WkfrdvQlqhaZ1B4Gy+zyQ5343De2o15Dzo1m6FD/7MgNn5uKqnffF4dzB3dkmKY
         mmiUUmdHltbF6ltMVOwrDVa9GllkGYNiDoq8WmcIVGVqsC/Elp3l1WNPJ6CISgybvP
         AwRg2lBx7h+xQwmrhC5943YxhIcGH0bPZsj/InKaG0EwCLvi44iY7FVj6+e7E486BE
         0tj8W2NNZgnn4UEtqs7sUYEQXacImUiNmRFT/MsiwokLzZHmyOCJmraHOwsIzPppSV
         S/3nigz0kzkE415ZkUpGn5gyuXcicjh1ltdikJX7/SSNVGUDERXSqHLu4wTA/V2awn
         z6wm+r3AU1nPQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When a ZONE_DEVICE private page is freed, the page->mapping field can be
set. If this page is reused as an anonymous page, the previous value can
prevent the page from being inserted into the CPU's anon rmap table.
For example, when migrating a pte_none() page to device memory:
  migrate_vma(ops, vma, start, end, src, dst, private)
    migrate_vma_collect()
      src[] =3D MIGRATE_PFN_MIGRATE
    migrate_vma_prepare()
      /* no page to lock or isolate so OK */
    migrate_vma_unmap()
      /* no page to unmap so OK */
    ops->alloc_and_copy()
      /* driver allocates ZONE_DEVICE page for dst[] */
    migrate_vma_pages()
      migrate_vma_insert_page()
        page_add_new_anon_rmap()
          __page_set_anon_rmap()
            /* This check sees the page's stale mapping field */
            if (PageAnon(page))
              return
            /* page->mapping is not updated */

The result is that the migration appears to succeed but a subsequent CPU
fault will be unable to migrate the page back to system memory or worse.

Clear the page->mapping field when freeing the ZONE_DEVICE page so stale
pointer data doesn't affect future page use.

Fixes: b7a523109fb5c9d2d6dd ("mm: don't clear ->mapping in hmm_devmem_free"=
)
Cc: stable@vger.kernel.org
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Jan Kara <jack@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
---
 kernel/memremap.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index 6ee03a816d67..289a086e1467 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -397,6 +397,30 @@ void __put_devmap_managed_page(struct page *page)
=20
 		mem_cgroup_uncharge(page);
=20
+		/*
+		 * When a device_private page is freed, the page->mapping field
+		 * may still contain a (stale) mapping value. For example, the
+		 * lower bits of page->mapping may still identify the page as
+		 * an anonymous page. Ultimately, this entire field is just
+		 * stale and wrong, and it will cause errors if not cleared.
+		 * One example is:
+		 *
+		 *  migrate_vma_pages()
+		 *    migrate_vma_insert_page()
+		 *      page_add_new_anon_rmap()
+		 *        __page_set_anon_rmap()
+		 *          ...checks page->mapping, via PageAnon(page) call,
+		 *            and incorrectly concludes that the page is an
+		 *            anonymous page. Therefore, it incorrectly,
+		 *            silently fails to set up the new anon rmap.
+		 *
+		 * For other types of ZONE_DEVICE pages, migration is either
+		 * handled differently or not done at all, so there is no need
+		 * to clear page->mapping.
+		 */
+		if (is_device_private_page(page))
+			page->mapping =3D NULL;
+
 		page->pgmap->ops->page_free(page);
 	} else if (!count)
 		__put_page(page);
--=20
2.20.1

