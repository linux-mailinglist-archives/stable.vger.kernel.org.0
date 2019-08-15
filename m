Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAB168F544
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 22:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731808AbfHOUB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 16:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731072AbfHOUB7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 16:01:59 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDAD12173B;
        Thu, 15 Aug 2019 20:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565899317;
        bh=dtP5nrpHlD0ffnKaO8z0FpaRd3kBovfsD21CGjglbNU=;
        h=Date:From:To:Subject:From;
        b=y8IzIsgQqzWD8v9dxlBL6I5ji3bwSSm/6GVLBXsMzYaLUggp73oTpyeJcZEjvA4EP
         1Nq+tYshvxTchHzRe//QVeRnJVNdMq6fG9mi8g+CjcbO4wKZFTQ8zzi05Feg32Utho
         u4oYEd29yOlUTJbVrcnrIE67pLF5iJ3EllaCpQ74=
Date:   Thu, 15 Aug 2019 13:01:56 -0700
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
 mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch removed from -mm
 tree
Message-ID: <20190815200156.swEB71ibP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hmm: fix bad subpage pointer in try_to_unmap_one
has been removed from the -mm tree.  Its filename was
     mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/hmm: fix bad subpage pointer in try_to_unmap_one

When migrating an anonymous private page to a ZONE_DEVICE private page,
the source page->mapping and page->index fields are copied to the
destination ZONE_DEVICE struct page and the page_mapcount() is increased.=
=20
This is so rmap_walk() can be used to unmap and migrate the page back to
system memory.  However, try_to_unmap_one() computes the subpage pointer
from a swap pte which computes an invalid page pointer and a kernel panic
results such as:

BUG: unable to handle page fault for address: ffffea1fffffffc8

Currently, only single pages can be migrated to device private memory so
no subpage computation is needed and it can be set to "page".

[rcampbell@nvidia.com: add comment]
  Link: http://lkml.kernel.org/r/20190724232700.23327-4-rcampbell@nvidia.com
Link: http://lkml.kernel.org/r/20190719192955.30462-4-rcampbell@nvidia.com
Fixes: a5430dda8a3a1c ("mm/migrate: support un-addressable ZONE_DEVICE page=
 in migration")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/rmap.c~mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one
+++ a/mm/rmap.c
@@ -1475,7 +1475,15 @@ static bool try_to_unmap_one(struct page
 			/*
 			 * No need to invalidate here it will synchronize on
 			 * against the special swap migration pte.
+			 *
+			 * The assignment to subpage above was computed from a
+			 * swap PTE which results in an invalid pointer.
+			 * Since only PAGE_SIZE pages can currently be
+			 * migrated, just set it to page. This will need to be
+			 * changed when hugepage migrations to device private
+			 * memory are supported.
 			 */
+			subpage =3D page;
 			goto discard;
 		}
=20
_

Patches currently in -mm which might be from rcampbell@nvidia.com are


