Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52605DD654
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 05:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfJSDUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 23:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727181AbfJSDUH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 23:20:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 778D32245A;
        Sat, 19 Oct 2019 03:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571455205;
        bh=QGcY+R8WdQTLLhix30lDEMJ+sG1VSyhWy0K+M9oeQxI=;
        h=Date:From:To:Subject:From;
        b=wV2bVCa4k0DTS2V/5tlCoGVcggRtDghN5Wqv9pTVIkqWDhmfUtpDYVka+rJGOUDW1
         54uoaH9p5ywdKdt3nVwZNgapPu9tK7i3lIPoxGAcpqWXK21ASDnvYvUi14aIpugpxQ
         j0DCCgxpk7776o8o6zqzTZxEKLgmVI0XvfUnyzIQ=
Date:   Fri, 18 Oct 2019 20:20:05 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        david@redhat.com, linux-mm@kvack.org, mhocko@kernel.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 14/26] hugetlbfs: don't access uninitialized
 memmaps in pfn_range_valid_gigantic()
Message-ID: <20191019032005.sgsUejgDW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: hugetlbfs: don't access uninitialized memmaps in pfn_range_valid_gigantic()

Uninitialized memmaps contain garbage and in the worst case trigger kernel
BUGs, especially with CONFIG_PAGE_POISONING.  They should not get touched.

Let's make sure that we only consider online memory (managed by the buddy)
that has initialized memmaps.  ZONE_DEVICE is not applicable.

page_zone() will call page_to_nid(), which will trigger
VM_BUG_ON_PGFLAGS(PagePoisoned(page), page) with CONFIG_PAGE_POISONING and
CONFIG_DEBUG_VM_PGFLAGS when called on uninitialized memmaps.  This can be
the case when an offline memory block (e.g., never onlined) is spanned by
a zone.

Note: As explained by Michal in [1], alloc_contig_range() will verify the
range.  So it boils down to the wrong access in this function.

[1] http://lkml.kernel.org/r/20180423000943.GO17484@dhcp22.suse.cz

Link: http://lkml.kernel.org/r/20191015120717.4858-1-david@redhat.com
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")	[visible after d0dc12e86b319]
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Michal Hocko <mhocko@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: <stable@vger.kernel.org>	[4.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlbfs-dont-access-uninitialized-memmaps-in-pfn_range_valid_gigantic
+++ a/mm/hugetlb.c
@@ -1084,11 +1084,10 @@ static bool pfn_range_valid_gigantic(str
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
 
_
