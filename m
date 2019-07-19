Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFD776EBD8
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 23:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388439AbfGSVEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 17:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727972AbfGSVEA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 17:04:00 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A8B521874;
        Fri, 19 Jul 2019 21:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563570239;
        bh=UdIQHBK8WSCwZEA6q2vBKn0xdea1OnNGjKqLoyrBuPc=;
        h=Date:From:To:Subject:From;
        b=JD0kIxunA3Hx9+rqhPDMuPeuM/sNUcL60vI6pAaLBxkUCK9NPJ+17WvjXQrKS/meB
         5nEsqQbZCraTllHp+mfM3NuXaHJnznXf7L1Demn57DfT+UVirngOoMn8drjE8IG7xj
         qhkINkk30WZtAr5jwkJjZ6yx1Ftgr+dbQnAMc2Z4=
Date:   Fri, 19 Jul 2019 14:03:58 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        stable@vger.kernel.org, schwidefsky@de.ibm.com,
        rdunlap@infradead.org, penberg@kernel.org, mike.kravetz@oracle.com,
        mhocko@suse.com, mgorman@techsingularity.net, logang@deltatee.com,
        kirill.shutemov@linux.intel.com, jiangshanlai@gmail.com,
        jhubbard@nvidia.com, jglisse@redhat.com, jgg@mellanox.com,
        jack@suse.cz, ira.weiny@intel.com, hch@lst.de,
        dave.hansen@linux.intel.com, dan.j.williams@intel.com,
        cl@linux.com, aryabinin@virtuozzo.com, aarcange@redhat.com,
        rcampbell@nvidia.com
Subject:  + mm-hmm-fix-zone_device-anon-page-mapping-reuse.patch
 added to -mm tree
Message-ID: <20190719210358.6T_MQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hmm: fix ZONE_DEVICE anon page mapping reuse
has been added to the -mm tree.  Its filename is
     mm-hmm-fix-zone_device-anon-page-mapping-reuse.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-fix-zone_device-anon-pa=
ge-mapping-reuse.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-fix-zone_device-anon-pa=
ge-mapping-reuse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
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
Cc: Christoph Hellwig <hch@lst.de>
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
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/memremap.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/kernel/memremap.c~mm-hmm-fix-zone_device-anon-page-mapping-reuse
+++ a/kernel/memremap.c
@@ -397,6 +397,30 @@ void __put_devmap_managed_page(struct pa
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

mm-document-zone-device-struct-page-field-usage.patch
mm-hmm-fix-zone_device-anon-page-mapping-reuse.patch
mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch

