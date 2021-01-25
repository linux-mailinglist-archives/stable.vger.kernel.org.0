Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589FF302F03
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 23:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732206AbhAYW11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 17:27:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732971AbhAYVhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 16:37:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AE1B22795;
        Mon, 25 Jan 2021 21:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611610519;
        bh=2IkpBXpcg4aiUDPMW1GIxXdkULJ16rqsy/VSY5JTYEs=;
        h=Date:From:To:Subject:From;
        b=lV5vFu3zUt8rQk/68jo+b0fnmoY2Whb+uP6rKosduTReYH+IEFoKKtjVihvI9L+QC
         gBptFZEHNsOBUv2288l/AllK2ht9vrA9oZPd5zqZaD5hd9HcLxX/YCav3qBnvJIk82
         UWEOBimpkeAimCZiJTBHey184xQd5f3xwvob64uE=
Date:   Mon, 25 Jan 2021 13:35:19 -0800
From:   akpm@linux-foundation.org
To:     cai@lca.pw, dan.j.williams@intel.com, david@redhat.com,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, stable@vger.kernel.org
Subject:  [merged]
 mm-fix-page-reference-leak-in-soft_offline_page.patch removed from -mm tree
Message-ID: <20210125213519.d3clJCbJB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix page reference leak in soft_offline_page()
has been removed from the -mm tree.  Its filename was
     mm-fix-page-reference-leak-in-soft_offline_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: fix page reference leak in soft_offline_page()

The conversion to move pfn_to_online_page() internal to
soft_offline_page() missed that the get_user_pages() reference taken by
the madvise() path needs to be dropped when pfn_to_online_page() fails. 
Note the direct sysfs-path to soft_offline_page() does not perform a
get_user_pages() lookup.

When soft_offline_page() is handed a pfn_valid() && !pfn_to_online_page()
pfn the kernel hangs at dax-device shutdown due to a leaked reference.

Link: https://lkml.kernel.org/r/161058501210.1840162.8108917599181157327.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: feec24a6139d ("mm, soft-offline: convert parameter to pfn")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c~mm-fix-page-reference-leak-in-soft_offline_page
+++ a/mm/memory-failure.c
@@ -1885,6 +1885,12 @@ static int soft_offline_free_page(struct
 	return rc;
 }
 
+static void put_ref_page(struct page *page)
+{
+	if (page)
+		put_page(page);
+}
+
 /**
  * soft_offline_page - Soft offline a page.
  * @pfn: pfn to soft-offline
@@ -1910,20 +1916,26 @@ static int soft_offline_free_page(struct
 int soft_offline_page(unsigned long pfn, int flags)
 {
 	int ret;
-	struct page *page;
 	bool try_again = true;
+	struct page *page, *ref_page = NULL;
+
+	WARN_ON_ONCE(!pfn_valid(pfn) && (flags & MF_COUNT_INCREASED));
 
 	if (!pfn_valid(pfn))
 		return -ENXIO;
+	if (flags & MF_COUNT_INCREASED)
+		ref_page = pfn_to_page(pfn);
+
 	/* Only online pages can be soft-offlined (esp., not ZONE_DEVICE). */
 	page = pfn_to_online_page(pfn);
-	if (!page)
+	if (!page) {
+		put_ref_page(ref_page);
 		return -EIO;
+	}
 
 	if (PageHWPoison(page)) {
 		pr_info("%s: %#lx page already poisoned\n", __func__, pfn);
-		if (flags & MF_COUNT_INCREASED)
-			put_page(page);
+		put_ref_page(ref_page);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-move-pfn_to_online_page-out-of-line.patch
mm-teach-pfn_to_online_page-to-consider-subsection-validity.patch
mm-teach-pfn_to_online_page-about-zone_device-section-collisions.patch
mm-teach-pfn_to_online_page-about-zone_device-section-collisions-fix.patch
mm-fix-memory_failure-handling-of-dax-namespace-metadata.patch

