Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F8132910A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243175AbhCAUSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:18:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:40902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242705AbhCAULG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:11:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CE36653BE;
        Mon,  1 Mar 2021 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621639;
        bh=Ey67yGZnwAAZT1OYmZhmzXJPcjWAwAhOyZ7h+ci54EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQ/1S35akHRdo6UW3H4bqgmQxvMRzIhdkA+9nIed4PHN+nWmgC+G0HP06/0j7EdJo
         C3oAAIkqYlm8VSw6m10MsMtJPVgDHkFoLy0ClY4EIa2Ed+iwWCGCDWMJ2jr9Gy5eip
         Xrx6W0KrnNhjLTuvQL1Quz7Ar7UxPdwIYKx3BjIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>, Qian Cai <cai@lca.pw>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 562/775] mm: fix memory_failure() handling of dax-namespace metadata
Date:   Mon,  1 Mar 2021 17:12:10 +0100
Message-Id: <20210301161229.246909213@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 34dc45be4563f344d59ba0428416d0d265aa4f4d ]

Given 'struct dev_pagemap' spans both data pages and metadata pages be
careful to consult the altmap if present to delineate metadata.  In fact
the pfn_first() helper already identifies the first valid data pfn, so
export that helper for other code paths via pgmap_pfn_valid().

Other usage of get_dev_pagemap() are not a concern because those are
operating on known data pfns having been looked up by get_user_pages().
I.e.  metadata pfns are never user mapped.

Link: https://lkml.kernel.org/r/161058501758.1840162.4239831989762604527.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: 6100e34b2526 ("mm, memory_failure: Teach memory_failure() about dev_pagemap pages")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memremap.h |  6 ++++++
 mm/memory-failure.c      |  6 ++++++
 mm/memremap.c            | 15 +++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 79c49e7f5c304..f5b464daeeca5 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -137,6 +137,7 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
 void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
 struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 		struct dev_pagemap *pgmap);
+bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long vmem_altmap_offset(struct vmem_altmap *altmap);
 void vmem_altmap_free(struct vmem_altmap *altmap, unsigned long nr_pfns);
@@ -165,6 +166,11 @@ static inline struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 	return NULL;
 }
 
+static inline bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn)
+{
+	return false;
+}
+
 static inline unsigned long vmem_altmap_offset(struct vmem_altmap *altmap)
 {
 	return 0;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e9481632fcd1b..4e3684d694c12 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1308,6 +1308,12 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 		 */
 		put_page(page);
 
+	/* device metadata space is not recoverable */
+	if (!pgmap_pfn_valid(pgmap, pfn)) {
+		rc = -ENXIO;
+		goto out;
+	}
+
 	/*
 	 * Prevent the inode from being freed while we are interrogating
 	 * the address_space, typically this would be handled by
diff --git a/mm/memremap.c b/mm/memremap.c
index 16b2fb482da11..2455bac895066 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -80,6 +80,21 @@ static unsigned long pfn_first(struct dev_pagemap *pgmap, int range_id)
 	return pfn + vmem_altmap_offset(pgmap_altmap(pgmap));
 }
 
+bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn)
+{
+	int i;
+
+	for (i = 0; i < pgmap->nr_range; i++) {
+		struct range *range = &pgmap->ranges[i];
+
+		if (pfn >= PHYS_PFN(range->start) &&
+		    pfn <= PHYS_PFN(range->end))
+			return pfn >= pfn_first(pgmap, i);
+	}
+
+	return false;
+}
+
 static unsigned long pfn_end(struct dev_pagemap *pgmap, int range_id)
 {
 	const struct range *range = &pgmap->ranges[range_id];
-- 
2.27.0



