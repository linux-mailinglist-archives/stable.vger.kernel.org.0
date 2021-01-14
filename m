Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55D12F5654
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 02:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbhANBqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 20:46:16 -0500
Received: from mga06.intel.com ([134.134.136.31]:17200 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727137AbhANA7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 19:59:30 -0500
IronPort-SDR: czxvANEB56ykrJLzJB+TR+P6Dv1qOHRn0pdEMyfgPFsboE8ofMF8T7P1SjKjfIQ3tim1VlIh7F
 0zKsr06PX9Qg==
X-IronPort-AV: E=McAfee;i="6000,8403,9863"; a="239831069"
X-IronPort-AV: E=Sophos;i="5.79,345,1602572400"; 
   d="scan'208";a="239831069"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2021 16:43:32 -0800
IronPort-SDR: JKUz1UfliHzulnNuEcOPcLkaxSEvNZWPjdOW53CuaeLmvtVpWrng+EQUTdyhmgbeO7NW7Ev8+G
 fR/oy8U7L/rA==
X-IronPort-AV: E=Sophos;i="5.79,345,1602572400"; 
   d="scan'208";a="405000358"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2021 16:43:32 -0800
Subject: [PATCH v4 4/5] mm: Fix page reference leak in soft_offline_page()
From:   Dan Williams <dan.j.williams@intel.com>
To:     akpm@linux-foundation.org
Cc:     Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 13 Jan 2021 16:43:32 -0800
Message-ID: <161058501210.1840162.8108917599181157327.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <161058499000.1840162.702316708443239771.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <161058499000.1840162.702316708443239771.stgit@dwillia2-desk3.amr.corp.intel.com>
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
 

