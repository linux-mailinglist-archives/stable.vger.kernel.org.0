Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E683E27D792
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 22:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgI2UGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 16:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728952AbgI2UGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 16:06:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DC662076A;
        Tue, 29 Sep 2020 20:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601409982;
        bh=MgkDxdhBMowd5jXoEvot8GmRj5AvJnoeDIsDFyxvu8I=;
        h=Date:From:To:Subject:From;
        b=iz76TOilL5L8zsnPYRvdkiLISAfHayLcidpZjfLlVb6aORTXwwQHBCCuSMvUuKi0m
         /hUuiDp6HNyClfVMvz1Z2p9ggvuRpieLQDPH116vjkGAteBTj67nwHLy7gfrvegwSx
         urNEB6kxeaf5hQcwNIuYkBELstop1SKYeVFWaMO0=
Date:   Tue, 29 Sep 2020 13:06:21 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, apais@microsoft.com,
        kirill.shutemov@linux.intel.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        pasha.tatashin@soleen.com, songliubraving@fb.com,
        stable@vger.kernel.org, vijayb@linux.microsoft.com
Subject:  +
 =?US-ASCII?Q?mm-khugepaged-recalculate-min=5Ffree=5Fkbytes-after-memor?=
 =?US-ASCII?Q?y-hotplug-as-expected-by-khugepaged-v5.patch?= added to -mm
 tree
Message-ID: <20200929200621.F1WOHZJsG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged-v5
has been added to the -mm tree.  Its filename is
     mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged-v5.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged-v5.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -7891,6 +7892,8 @@ int __meminit init_per_zone_wmark_min(vo
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
mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged-v5.patch

