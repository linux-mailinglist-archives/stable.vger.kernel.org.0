Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11E698F543
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 22:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731244AbfHOUB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 16:01:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731072AbfHOUB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 16:01:56 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5DB421721;
        Thu, 15 Aug 2019 20:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565899314;
        bh=3BtyMsyvaUK8wu11zqivK1jehovoupNgFfpGUyMT6EQ=;
        h=Date:From:To:Subject:From;
        b=ReJFL/5u7rX9Sj0Tufk3ZTMTLe822v8svgI6UoeBqfIWYi6j/UT92pAw4yLb5r5Td
         AKuMG1VoIW+iiN/TJZ7drGWiYS6Wuq0//KVG4aY3lGIgJhlKi8RVsX5Tn1MOc4Fgf9
         TgUfKi/wbxgjIj8vEryI+P6d5kvO40+u9UV5SsEM=
Date:   Thu, 15 Aug 2019 13:01:53 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, aryabinin@virtuozzo.com, cl@linux.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com, hch@lst.de,
        ira.weiny@intel.com, jack@suse.cz, jgg@mellanox.com,
        jglisse@redhat.com, jhubbard@nvidia.com, jiangshanlai@gmail.com,
        kirill.shutemov@linux.intel.com, logang@deltatee.com,
        mgorman@techsingularity.net, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rcampbell@nvidia.com, rdunlap@infradead.org,
        schwidefsky@de.ibm.com, stable@vger.kernel.org, vbabka@suse.cz,
        willy@infradead.org
Subject:  [merged]
 mm-hmm-fix-zone_device-anon-page-mapping-reuse.patch removed from -mm tree
Message-ID: <20190815200153.Lf-rnnuxC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hmm: fix ZONE_DEVICE anon page mapping reuse
has been removed from the -mm tree.  Its filename was
     mm-hmm-fix-zone_device-anon-page-mapping-reuse.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/hmm: fix ZONE_DEVICE anon page mapping reuse

When a ZONE_DEVICE private page is freed, the page->mapping field can be
set.  If this page is reused as an anonymous page, the previous value can
prevent the page from being inserted into the CPU's anon rmap table.  For
example, when migrating a pte_none() page to device memory:

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

Link: http://lkml.kernel.org/r/20190719192955.30462-3-rcampbell@nvidia.com
Fixes: b7a523109fb5c9d2d6dd ("mm: don't clear ->mapping in hmm_devmem_free")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
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
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/mm/memremap.c~mm-hmm-fix-zone_device-anon-page-mapping-reuse
+++ a/mm/memremap.c
@@ -403,6 +403,30 @@ void __put_devmap_managed_page(struct pa
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
_

Patches currently in -mm which might be from rcampbell@nvidia.com are


