Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08CFCDD64C
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 05:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfJSDTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 23:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727152AbfJSDTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 23:19:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E77A422459;
        Sat, 19 Oct 2019 03:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571455164;
        bh=l/VI9kDXQkTd4aRbcJqUBsQoR+nQzmxv97oh1WroD3A=;
        h=Date:From:To:Subject:From;
        b=KmZjel3u/uGoSiV5oc1mGc0tKMiKd+FoJIQ8RAgExy2fKK7wBb+1yvkld9OZZAzkX
         j3cIo3zcIWomkpoXUoAgkYGXkIrIxrgo9C4/noH7eJstllDD4Wa7C4uf2rh8U00Nik
         So3X3YTkZmWUPce4QfrnVt3gFJuToKFgqftlerCg=
Date:   Fri, 18 Oct 2019 20:19:23 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 03/26] mm/memory-failure.c: don't access
 uninitialized memmaps in memory_failure()
Message-ID: <20191019031923.qX4DsmfeJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory-failure.c: don't access uninitialized memmaps in memory_failure()

We should check for pfn_to_online_page() to not access uninitialized
memmaps. Reshuffle the code so 		we don't have to duplicate the error
message.

Link: http://lkml.kernel.org/r/20191009142435.3975-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")	[visible after d0dc12e86b319]
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>	[4.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-dont-access-uninitialized-memmaps-in-memory_failure
+++ a/mm/memory-failure.c
@@ -1257,17 +1257,19 @@ int memory_failure(unsigned long pfn, in
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
 
-	if (!pfn_valid(pfn)) {
+	p = pfn_to_online_page(pfn);
+	if (!p) {
+		if (pfn_valid(pfn)) {
+			pgmap = get_dev_pagemap(pfn, NULL);
+			if (pgmap)
+				return memory_failure_dev_pagemap(pfn, flags,
+								  pgmap);
+		}
 		pr_err("Memory failure: %#lx: memory outside kernel control\n",
 			pfn);
 		return -ENXIO;
 	}
 
-	pgmap = get_dev_pagemap(pfn, NULL);
-	if (pgmap)
-		return memory_failure_dev_pagemap(pfn, flags, pgmap);
-
-	p = pfn_to_page(pfn);
 	if (PageHuge(p))
 		return memory_failure_hugetlb(pfn, flags);
 	if (TestSetPageHWPoison(p)) {
_
