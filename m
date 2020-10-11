Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D3A28A533
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 06:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730730AbgJKD7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Oct 2020 23:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729217AbgJKD7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Oct 2020 23:59:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C99DE207D3;
        Sun, 11 Oct 2020 03:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602388790;
        bh=RCzQwM8WtglLjJhSNFOU8wwaOJ5LC0iVDQpj1OHaNJg=;
        h=Date:From:To:Subject:From;
        b=fSiMy6BpJWTEzPZ90SrG6EJDHbi7z7iyLMCxc2LWjfHtFgaRGK9eIG4CXDWRht2Pr
         Sx+r7t3O8ahcx3zDnk6uD+KWMw6pU3zI9eCQyv5/whfRl1UyXqxjP7dBcmrI8lJZ5Z
         geKOaQ43tGN4IYIRhIee/3T/mZUcRTXDOQo1rMyc=
Date:   Sat, 10 Oct 2020 20:59:49 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, apais@microsoft.com,
        kirill.shutemov@linux.intel.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        pasha.tatashin@soleen.com, songliubraving@fb.com,
        stable@vger.kernel.org, vijayb@linux.microsoft.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-khugepaged-recalculate-min=5Ffree=5Fkbytes-after-memor?=
 =?US-ASCII?Q?y-hotplug-as-expected-by-khugepaged-v5.patch?= removed from
 -mm tree
Message-ID: <20201011035949.VI0FylRzZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged-v5
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged-v5.patch

This patch was dropped because it was folded into mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged.patch

------------------------------------------------------
From: Vijay Balakrishna <vijayb@linux.microsoft.com>
Subject: mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged-v5

made changes to move khugepaged_min_free_kbytes_update into
init_per_zone_wmark_min and rested changes

Link: https://lkml.kernel.org/r/1601398153-5517-1-git-send-email-vijayb@linux.microsoft.com
Fixes: f000565adb77 ("thp: set recommended min free kbytes")
Signed-off-by: Vijay Balakrishna <vijayb@linux.microsoft.com>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Allen Pais <apais@microsoft.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ---
 mm/page_alloc.c     |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory_hotplug.c~mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged-v5
+++ a/mm/memory_hotplug.c
@@ -36,7 +36,6 @@
 #include <linux/memblock.h>
 #include <linux/compaction.h>
 #include <linux/rmap.h>
-#include <linux/khugepaged.h>
 
 #include <asm/tlbflush.h>
 
@@ -858,7 +857,6 @@ int __ref online_pages(unsigned long pfn
 	zone_pcp_update(zone);
 
 	init_per_zone_wmark_min();
-	khugepaged_min_free_kbytes_update();
 
 	kswapd_run(nid);
 	kcompactd_run(nid);
@@ -1617,7 +1615,6 @@ static int __ref __offline_pages(unsigne
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 
 	init_per_zone_wmark_min();
-	khugepaged_min_free_kbytes_update();
 
 	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
--- a/mm/page_alloc.c~mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged-v5
+++ a/mm/page_alloc.c
@@ -69,6 +69,7 @@
 #include <linux/nmi.h>
 #include <linux/psi.h>
 #include <linux/padata.h>
+#include <linux/khugepaged.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -7904,6 +7905,8 @@ int __meminit init_per_zone_wmark_min(vo
 	setup_min_slab_ratio();
 #endif
 
+	khugepaged_min_free_kbytes_update();
+
 	return 0;
 }
 postcore_initcall(init_per_zone_wmark_min)
_

Patches currently in -mm which might be from vijayb@linux.microsoft.com are

mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged.patch

