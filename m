Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CBD301996
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 06:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbhAXFCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 00:02:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbhAXFCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Jan 2021 00:02:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF1C322CAF;
        Sun, 24 Jan 2021 05:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611464514;
        bh=pcz3PCqxYzxs5kJ6kwRGGOcJPEtj0FCO0fqNHgQmnac=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wB3ctqADZRXjXwvFYSEMxjCWcjIlPnnBgID8LlbMEy6E6K84dIgHuqfg+PnVUCcoG
         /KW4J+zY68jzM7HrZrq78YOz5zAohY8RvhMko7xCegLjpXKu5M5rBI/s2mIkunHAgk
         qQBuBdlODqS29OzafpGTumdPRGJmlZfhZAYtdePU=
Date:   Sat, 23 Jan 2021 21:01:52 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, dan.j.williams@intel.com,
        david@redhat.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 13/19] mm: fix page reference leak in
 soft_offline_page()
Message-ID: <20210124050152.mIDl3p6sw%akpm@linux-foundation.org>
In-Reply-To: <20210123210029.a7c704d0cab204683e41ad10@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
