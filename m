Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A42CD75C5
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 14:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfJOMHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 08:07:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60176 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbfJOMHX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 08:07:23 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EE561106E288;
        Tue, 15 Oct 2019 12:07:22 +0000 (UTC)
Received: from t460s.redhat.com (ovpn-116-26.ams2.redhat.com [10.36.116.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B05A260C5D;
        Tue, 15 Oct 2019 12:07:18 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@kernel.org>, stable@vger.kernel.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v1] hugetlbfs: don't access uninitialized memmaps in pfn_range_valid_gigantic()
Date:   Tue, 15 Oct 2019 14:07:17 +0200
Message-Id: <20191015120717.4858-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Tue, 15 Oct 2019 12:07:23 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Uninitialized memmaps contain garbage and in the worst case trigger
kernel BUGs, especially with CONFIG_PAGE_POISONING. They should not get
touched.

Let's make sure that we only consider online memory (managed by the
buddy) that has initialized memmaps. ZONE_DEVICE is not applicable.

page_zone() will call page_to_nid(), which will trigger
VM_BUG_ON_PGFLAGS(PagePoisoned(page), page) with CONFIG_PAGE_POISONING
and CONFIG_DEBUG_VM_PGFLAGS when called on uninitialized memmaps. This
can be the case when an offline memory block (e.g., never onlined) is
spanned by a zone.

Note: As explained by Michal in [1], alloc_contig_range() will verify
the range. So it boils down to the wrong access in this function.

[1] http://lkml.kernel.org/r/20180423000943.GO17484@dhcp22.suse.cz

Reported-by: Michal Hocko <mhocko@kernel.org>
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online") # visible after d0dc12e86b319
Cc: stable@vger.kernel.org # v4.13+
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/hugetlb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ef37c85423a5..b45a95363a84 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1084,11 +1084,10 @@ static bool pfn_range_valid_gigantic(struct zone *z,
 	struct page *page;
 
 	for (i = start_pfn; i < end_pfn; i++) {
-		if (!pfn_valid(i))
+		page = pfn_to_online_page(i);
+		if (!page)
 			return false;
 
-		page = pfn_to_page(i);
-
 		if (page_zone(page) != z)
 			return false;
 
-- 
2.21.0

