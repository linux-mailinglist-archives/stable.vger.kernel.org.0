Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A87A6EBD9
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 23:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388445AbfGSVED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 17:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727972AbfGSVED (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 17:04:03 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77F5921880;
        Fri, 19 Jul 2019 21:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563570242;
        bh=N03CxXJVcKZ6aP+qdFNfGUbiqvLwN13PukXoWqiVTb4=;
        h=Date:From:To:Subject:From;
        b=shK81tobfzJEkW/sweIxSv8r06SuPlzHfMYKItqLgxYDzTTaxIBYNMcMtBArTEk2S
         oyMumtJK2HoV7Jeuu3YwocbdmD/ZZgNG7kUf3yU49adC/DyHVUAYi18BaLHMSSYcQ7
         el9/+tlHE+0KYm3jEqQzJM9m7PuwNlbigt1aXNu8=
Date:   Fri, 19 Jul 2019 14:04:01 -0700
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
Subject:  + mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch
 added to -mm tree
Message-ID: <20190719210401.LiiPx%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hmm: fix bad subpage pointer in try_to_unmap_one
has been added to the -mm tree.  Its filename is
     mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-fix-bad-subpage-pointer=
-in-try_to_unmap_one.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-fix-bad-subpage-pointer=
-in-try_to_unmap_one.patch

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

 mm/rmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/rmap.c~mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one
+++ a/mm/rmap.c
@@ -1476,6 +1476,7 @@ static bool try_to_unmap_one(struct page
 			 * No need to invalidate here it will synchronize on
 			 * against the special swap migration pte.
 			 */
+			subpage =3D page;
 			goto discard;
 		}
=20
_

Patches currently in -mm which might be from rcampbell@nvidia.com are

mm-document-zone-device-struct-page-field-usage.patch
mm-hmm-fix-zone_device-anon-page-mapping-reuse.patch
mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch

