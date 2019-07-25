Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7717430F
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 04:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388172AbfGYCDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 22:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387879AbfGYCDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 22:03:01 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14CC021951;
        Thu, 25 Jul 2019 02:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564020180;
        bh=rK6agn3oao6Gl3Ya2KKT17QkCmt4OfhOFlfE9mRndoU=;
        h=Date:From:To:Subject:From;
        b=SblkDcu1EpmtLofADlAjkliieV22ieyTafJU05WeSPSnhfPQ8M9Yshda1ereO76QX
         bokN0mtW+F6ZOXmTLVEee3Ox63RpOG/4vh5IofN5PnKIqzifdqLsu33qXX6F7447gF
         D98laYjq0tegrb0ClcUfjSuKLu8mmcXQ/HPA0oik=
Date:   Wed, 24 Jul 2019 19:02:58 -0700
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
Subject:  [to-be-updated]
 mm-document-zone-device-struct-page-field-usage.patch removed from -mm tree
Message-ID: <20190725020258.UNuNgD9Uq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: document zone device struct page field usage
has been removed from the -mm tree.  Its filename was
     mm-document-zone-device-struct-page-field-usage.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
=46rom: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm: document zone device struct page field usage

Patch series "mm/hmm: fixes for device private page migration", v2.

Testing the latest linux git tree turned up a few bugs with page migration
to and from ZONE_DEVICE private and anonymous pages.  Hopefully it
clarifies how ZONE_DEVICE private struct page uses the same mapping and
index fields from the source anonymous page mapping.


This patch (of 3):

Struct page for ZONE_DEVICE private pages uses the page->mapping and and
page->index fields while the source anonymous pages are migrated to device
private memory.  This is so rmap_walk() can find the page when migrating
the ZONE_DEVICE private page back to system memory.  ZONE_DEVICE pmem
backed fsdax pages also use the page->mapping and page->index fields when
files are mapped into a process address space.

Restructure struct page and add comments to make this more clear.

Link: http://lkml.kernel.org/r/20190719192955.30462-2-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   42 +++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 13 deletions(-)

--- a/include/linux/mm_types.h~mm-document-zone-device-struct-page-field-us=
age
+++ a/include/linux/mm_types.h
@@ -76,13 +76,35 @@ struct page {
 	 * avoid collision and false-positive PageTail().
 	 */
 	union {
-		struct {	/* Page cache and anonymous pages */
-			/**
-			 * @lru: Pageout list, eg. active_list protected by
-			 * pgdat->lru_lock.  Sometimes used as a generic list
-			 * by the page owner.
-			 */
-			struct list_head lru;
+		struct {	/* Page cache, anonymous, ZONE_DEVICE pages */
+			union {
+				/**
+				 * @lru: Pageout list, e.g., active_list
+				 * protected by pgdat->lru_lock. Sometimes
+				 * used as a generic list by the page owner.
+				 */
+				struct list_head lru;
+				/**
+				 * ZONE_DEVICE pages are never on the lru
+				 * list so they reuse the list space.
+				 * ZONE_DEVICE private pages are counted as
+				 * being mapped so the @mapping and @index
+				 * fields are used while the page is migrated
+				 * to device private memory.
+				 * ZONE_DEVICE MEMORY_DEVICE_FS_DAX pages also
+				 * use the @mapping and @index fields when pmem
+				 * backed DAX files are mapped.
+				 */
+				struct {
+					/**
+					 * @pgmap: Points to the hosting
+					 * device page map.
+					 */
+					struct dev_pagemap *pgmap;
+					/** @zone_device_data: opaque data. */
+					void *zone_device_data;
+				};
+			};
 			/* See page-flags.h for PAGE_MAPPING_FLAGS */
 			struct address_space *mapping;
 			pgoff_t index;		/* Our offset within mapping. */
@@ -155,12 +177,6 @@ struct page {
 			spinlock_t ptl;
 #endif
 		};
-		struct {	/* ZONE_DEVICE pages */
-			/** @pgmap: Points to the hosting device page map. */
-			struct dev_pagemap *pgmap;
-			void *zone_device_data;
-			unsigned long _zd_pad_1;	/* uses mapping */
-		};
=20
 		/** @rcu_head: You can use this to free a page by RCU. */
 		struct rcu_head rcu_head;
_

Patches currently in -mm which might be from rcampbell@nvidia.com are

mm-hmm-fix-zone_device-anon-page-mapping-reuse.patch
mm-hmm-fix-bad-subpage-pointer-in-try_to_unmap_one.patch
mm-migrate-initialize-pud_entry-in-migrate_vma.patch

