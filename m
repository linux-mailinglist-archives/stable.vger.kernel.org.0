Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFB34E6902
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbfJ0Vdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727306AbfJ0VMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:12:33 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE453205C9;
        Sun, 27 Oct 2019 21:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210752;
        bh=gCYHcusNhWzJXqGWOeeOgWXiRT/up6syZSICKsJePtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ffc1NjRzQSldFTzav48Nhc2gDNm/vWr1Lb02WCpMvTvJCCH5S56F/FPqMJQbmpbm
         stx13ilW1o/NTYUCVw8UWG1wF48Y3/Vgl5hirZdBciyFw4WcI6prhA6A7YayxOcv6F
         HDe/57+jRaWmBO+2rJIva9hqFZ9qVuA1quv8b2Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 103/119] hugetlbfs: dont access uninitialized memmaps in pfn_range_valid_gigantic()
Date:   Sun, 27 Oct 2019 22:01:20 +0100
Message-Id: <20191027203349.118289051@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit f231fe4235e22e18d847e05cbe705deaca56580a upstream.

Uninitialized memmaps contain garbage and in the worst case trigger
kernel BUGs, especially with CONFIG_PAGE_POISONING.  They should not get
touched.

Let's make sure that we only consider online memory (managed by the
buddy) that has initialized memmaps.  ZONE_DEVICE is not applicable.

page_zone() will call page_to_nid(), which will trigger
VM_BUG_ON_PGFLAGS(PagePoisoned(page), page) with CONFIG_PAGE_POISONING
and CONFIG_DEBUG_VM_PGFLAGS when called on uninitialized memmaps.  This
can be the case when an offline memory block (e.g., never onlined) is
spanned by a zone.

Note: As explained by Michal in [1], alloc_contig_range() will verify
the range.  So it boils down to the wrong access in this function.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1081,11 +1081,10 @@ static bool pfn_range_valid_gigantic(str
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
 


