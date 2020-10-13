Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DD928D57F
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 22:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgJMUln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 16:41:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbgJMUln (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Oct 2020 16:41:43 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C344920BED;
        Tue, 13 Oct 2020 20:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602621702;
        bh=ZyY+47kbvY8SklfK74cvyErGu/Z3tlvS1D6q5LzhAPk=;
        h=Date:From:To:Subject:From;
        b=EUUlQ5vQGwuqywjL0W3uOjYvz0h+ocAFfED26M5dm2Du4LOZxdXS/zLLjoFles9dD
         7hiACLiT3zBWUxSEV0nx/GwPqO65lk/GC40rjEItTEtawfYfbkcQJRRgcjIbs8q6Ld
         aVxTzsNF0vYvYklDa1pPI3nqYLtssrsaqEWwddjA=
Date:   Tue, 13 Oct 2020 13:41:41 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, apais@microsoft.com,
        kirill.shutemov@linux.intel.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        pasha.tatashin@soleen.com, songliubraving@fb.com,
        stable@vger.kernel.org, vijayb@linux.microsoft.com
Subject:  [merged]
 =?US-ASCII?Q?mm-khugepaged-recalculate-min=5Ffree=5Fkbytes-after-memory?=
 =?US-ASCII?Q?-hotplug-as-expected-by-khugepaged.patch?= removed from -mm
 tree
Message-ID: <20201013204141.by8a7SmOT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: recalculate min_free_kbytes after memory hotplug as expected by khugepaged
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vijay Balakrishna <vijayb@linux.microsoft.com>
Subject: mm: khugepaged: recalculate min_free_kbytes after memory hotplug as expected by khugepaged

When memory is hotplug added or removed the min_free_kbytes should be
recalculated based on what is expected by khugepaged.  Currently after
hotplug, min_free_kbytes will be set to a lower default and higher default
set when THP enabled is lost.  This change restores min_free_kbytes as
expected for THP consumers.

[vijayb@linux.microsoft.com: v5]
  Link: https://lkml.kernel.org/r/1601398153-5517-1-git-send-email-vijayb@linux.microsoft.com
Link: https://lkml.kernel.org/r/1600305709-2319-2-git-send-email-vijayb@linux.microsoft.com
Link: https://lkml.kernel.org/r/1600204258-13683-1-git-send-email-vijayb@linux.microsoft.com
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

 include/linux/khugepaged.h |    5 +++++
 mm/khugepaged.c            |   13 +++++++++++--
 mm/page_alloc.c            |    3 +++
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
@@ -2304,8 +2307,6 @@ static void set_recommended_min_free_kby
 
 int start_stop_khugepaged(void)
 {
-	static struct task_struct *khugepaged_thread __read_mostly;
-	static DEFINE_MUTEX(khugepaged_mutex);
 	int err = 0;
 
 	mutex_lock(&khugepaged_mutex);
@@ -2332,3 +2333,11 @@ fail:
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
--- a/mm/page_alloc.c~mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged
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


