Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9716B2BF
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 02:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389117AbfGQAPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 20:15:48 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11612 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728597AbfGQAPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jul 2019 20:15:47 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d2e68b90000>; Tue, 16 Jul 2019 17:15:53 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 16 Jul 2019 17:15:46 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 16 Jul 2019 17:15:46 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL104.nvidia.com
 (172.18.146.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 17 Jul
 2019 00:15:43 +0000
Received: from hqnvemgw01.nvidia.com (172.20.150.20) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 17 Jul 2019 00:15:43 +0000
Received: from rcampbell-dev.nvidia.com (Not Verified[10.110.48.66]) by hqnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5d2e68af0000>; Tue, 16 Jul 2019 17:15:43 -0700
From:   Ralph Campbell <rcampbell@nvidia.com>
To:     <linux-mm@kvack.org>
CC:     <linux-kernel@vger.kernel.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@mellanox.com>, <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] mm/hmm: Fix bad subpage pointer in try_to_unmap_one
Date:   Tue, 16 Jul 2019 17:14:46 -0700
Message-ID: <20190717001446.12351-4-rcampbell@nvidia.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190717001446.12351-1-rcampbell@nvidia.com>
References: <20190717001446.12351-1-rcampbell@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563322553; bh=dQvYVBMTRYc3SjF1PkfCIGikt9DQJqiS5LuvPJGyR14=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding;
        b=OvNb5yTxS0yQJ/QFCE+O4SUPLwvoCMYAUHOjDwGSxYfeA1s4J/mA35mjyGpfefFUp
         073C33WyN1TcgFCRmljuxkv/yP/G7JpuRxl+7h3pCLo8uhRNryeGc3ILxOMvxAZYqI
         MsZ1qQWuqITEjYO9PQUmuc7GegYK+3RR6Rm1IMpon66Mk9LNCVjhy0crsVH35ow5X8
         PwWlDzE+p3qI1hdOSLU0ZhwcMc1aBC865suP4f+l7DrrSh23BlRaZ2I8dLfTO8rR5Z
         eOYvJA2qp1GRRBUkEmlbC4RJH3BuFWJIbrA8MKrcUq1TC22VYponvU4B+FIrlUKCv8
         I2xExWbJO+Kww==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When migrating an anonymous private page to a ZONE_DEVICE private page,
the source page->mapping and page->index fields are copied to the
destination ZONE_DEVICE struct page and the page_mapcount() is increased.
This is so rmap_walk() can be used to unmap and migrate the page back to
system memory. However, try_to_unmap_one() computes the subpage pointer
from a swap pte which computes an invalid page pointer and a kernel panic
results such as:

BUG: unable to handle page fault for address: ffffea1fffffffc8

Currently, only single pages can be migrated to device private memory so
no subpage computation is needed and it can be set to "page".

Fixes: a5430dda8a3a1c ("mm/migrate: support un-addressable ZONE_DEVICE page=
 in migration")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/rmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/rmap.c b/mm/rmap.c
index e5dfe2ae6b0d..ec1af8b60423 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1476,6 +1476,7 @@ static bool try_to_unmap_one(struct page *page, struc=
t vm_area_struct *vma,
 			 * No need to invalidate here it will synchronize on
 			 * against the special swap migration pte.
 			 */
+			subpage =3D page;
 			goto discard;
 		}
=20
--=20
2.20.1

