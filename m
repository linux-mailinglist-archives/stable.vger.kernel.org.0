Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244042F4550
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 08:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbhAMHgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 02:36:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:51022 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbhAMHgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 02:36:24 -0500
IronPort-SDR: z62sIIfSwKnvnT74uLslIcc3VWzWnTOPsU4U88SEPOcDDnT3H/rZlrw3RnnPGL/l1tq+F7oD8b
 Rpa/eDNE92fA==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="196799249"
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="196799249"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 23:35:43 -0800
IronPort-SDR: ezqcf/6BUl4DeaFj02snXJ1RB3gza6UdaG1mXU+AXURDPOlEORbq7fRGK5E8JXNg2KsddJlPwd
 vbMgW9RkpGMg==
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="389412785"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 23:35:39 -0800
Subject: [PATCH v3 4/6] mm: Fix page reference leak in soft_offline_page()
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-mm@kvack.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, stable@vger.kernel.org,
        vishal.l.verma@intel.com, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 12 Jan 2021 23:35:38 -0800
Message-ID: <161052333875.1805594.3046789655044320351.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <161052331545.1805594.2356512831689786960.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <161052331545.1805594.2356512831689786960.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The conversion to move pfn_to_online_page() internal to
soft_offline_page() missed that the get_user_pages() reference taken by
the madvise() path needs to be dropped when pfn_to_online_page() fails.
Note the direct sysfs-path to soft_offline_page() does not perform a
get_user_pages() lookup.

When soft_offline_page() is handed a pfn_valid() &&
!pfn_to_online_page() pfn the kernel hangs at dax-device shutdown due to
a leaked reference.

Fixes: feec24a6139d ("mm, soft-offline: convert parameter to pfn")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/memory-failure.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 5a38e9eade94..78b173c7190c 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1885,6 +1885,12 @@ static int soft_offline_free_page(struct page *page)
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
@@ -1910,20 +1916,26 @@ static int soft_offline_free_page(struct page *page)
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
 

