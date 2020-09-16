Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5762926B6B4
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbgIPAJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:09:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727142AbgIPAJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 20:09:51 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C736220739;
        Wed, 16 Sep 2020 00:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600214990;
        bh=hYZK/bgXFqVldxBI+j0G33gBSXVhJ4Kam8PoUuSeBW4=;
        h=Date:From:To:Subject:From;
        b=r1Xm0J+hFz+0UP3k8b8ieGFThd2AC+PYwMMPGdTi3CM8SxJcuoD0jMuINbbTxmuDq
         mWDGYzGUooxsaouh7s5gg7cYTB3JVkMwB0oKr1+NqqW8HU+bbknZoA73lYz6AJFqud
         uD6lgfHveefYgpTztW8fTdf4eKsKqCOwKkOgvFUI=
Date:   Tue, 15 Sep 2020 17:09:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songliubraving@fb.com, pasha.tatashin@soleen.com, oleg@redhat.com,
        mhocko@suse.com, kirill.shutemov@linux.intel.com,
        apais@microsoft.com, aarcange@redhat.com,
        vijayb@linux.microsoft.com
Subject:  +
 =?us-ascii?Q?mm-khugepaged-recalculate-min=5Ffree=5Fkbytes-after-memory?=
 =?us-ascii?Q?-hotplug-as-expected-by-khugepaged.patch?= added to -mm tree
Message-ID: <20200916000948.N0vvr%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: recalculate min_free_kbytes after memory hotplug as expected by khugepaged
has been added to the -mm tree.  Its filename is
     mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged.patch

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
Subject: mm: khugepaged: recalculate min_free_kbytes after memory hotplug as expected by khugepaged

When memory is hotplug added or removed the min_free_kbytes must be
recalculated based on what is expected by khugepaged.  Currently after
hotplug, min_free_kbytes will be set to a lower default and higher default
set when THP enabled is lost.  This leaves the system with small
min_free_kbytes which isn't suitable for systems especially with network
intensive loads.  Typical failure symptoms include HW WATCHDOG reset, soft
lockup hang notices, NETDEVICE WATCHDOG timeouts, and OOM process kills.

Link: https://lkml.kernel.org/r/1600204258-13683-1-git-send-email-vijayb@linux.microsoft.com
Fixes: f000565adb77 ("thp: set recommended min free kbytes")
Signed-off-by: Vijay Balakrishna <vijayb@linux.microsoft.com>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Allen Pais <apais@microsoft.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/khugepaged.h |    5 +++++
 mm/khugepaged.c            |   13 +++++++++++--
 mm/memory_hotplug.c        |    3 +++
 3 files changed, 19 insertions(+), 2 deletions(-)

--- a/include/linux/khugepaged.h~mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged
+++ a/include/linux/khugepaged.h
@@ -15,6 +15,7 @@ extern int __khugepaged_enter(struct mm_
 extern void __khugepaged_exit(struct mm_struct *mm);
 extern int khugepaged_enter_vma_merge(struct vm_area_struct *vma,
 				      unsigned long vm_flags);
+extern void khugepaged_min_free_kbytes_update(void);
 #ifdef CONFIG_SHMEM
 extern void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr);
 #else
@@ -85,6 +86,10 @@ static inline void collapse_pte_mapped_t
 					   unsigned long addr)
 {
 }
+
+static inline void khugepaged_min_free_kbytes_update(void)
+{
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_KHUGEPAGED_H */
--- a/mm/khugepaged.c~mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged
+++ a/mm/khugepaged.c
@@ -56,6 +56,9 @@ enum scan_result {
 #define CREATE_TRACE_POINTS
 #include <trace/events/huge_memory.h>
 
+static struct task_struct *khugepaged_thread __read_mostly;
+static DEFINE_MUTEX(khugepaged_mutex);
+
 /* default scan 8*512 pte (or vmas) every 30 second */
 static unsigned int khugepaged_pages_to_scan __read_mostly;
 static unsigned int khugepaged_pages_collapsed;
@@ -2292,8 +2295,6 @@ static void set_recommended_min_free_kby
 
 int start_stop_khugepaged(void)
 {
-	static struct task_struct *khugepaged_thread __read_mostly;
-	static DEFINE_MUTEX(khugepaged_mutex);
 	int err = 0;
 
 	mutex_lock(&khugepaged_mutex);
@@ -2320,3 +2321,11 @@ fail:
 	mutex_unlock(&khugepaged_mutex);
 	return err;
 }
+
+void khugepaged_min_free_kbytes_update(void)
+{
+	mutex_lock(&khugepaged_mutex);
+	if (khugepaged_enabled() && khugepaged_thread)
+		set_recommended_min_free_kbytes();
+	mutex_unlock(&khugepaged_mutex);
+}
--- a/mm/memory_hotplug.c~mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged
+++ a/mm/memory_hotplug.c
@@ -36,6 +36,7 @@
 #include <linux/memblock.h>
 #include <linux/compaction.h>
 #include <linux/rmap.h>
+#include <linux/khugepaged.h>
 
 #include <asm/tlbflush.h>
 
@@ -857,6 +858,7 @@ int __ref online_pages(unsigned long pfn
 	zone_pcp_update(zone);
 
 	init_per_zone_wmark_min();
+	khugepaged_min_free_kbytes_update();
 
 	kswapd_run(nid);
 	kcompactd_run(nid);
@@ -1614,6 +1616,7 @@ static int __ref __offline_pages(unsigne
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 
 	init_per_zone_wmark_min();
+	khugepaged_min_free_kbytes_update();
 
 	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
_

Patches currently in -mm which might be from vijayb@linux.microsoft.com are

mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged.patch
mm-khugepaged-avoid-overriding-min_free_kbytes-set-by-user.patch

