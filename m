Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EE228B6AE
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730969AbgJLNgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730833AbgJLNfi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:35:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 459572222C;
        Mon, 12 Oct 2020 13:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509730;
        bh=fmW3+WNtypgBnhzxFnE4Gy7I1zsUGl/9BllpV+I2avY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+/c2VCczErs85Fq7FVbIDAtozvA26/rLmeqJEle2ZqX9on0YfhAyQnG9tSg6bqH9
         5aGV8tIcETAGBOHDA33WzAAy4voRYNjisD7nQIuuY9MQkQvJfNij/hIx7oMrLjRZK6
         TzIB5MOQ2xOh8SE1L7qYgnMefV6eW0zlaG9S7f9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vijay Balakrishna <vijayb@linux.microsoft.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Michal Hocko <mhocko@suse.com>,
        Allen Pais <apais@microsoft.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 53/54] mm: khugepaged: recalculate min_free_kbytes after memory hotplug as expected by khugepaged
Date:   Mon, 12 Oct 2020 15:27:15 +0200
Message-Id: <20201012132632.029610828@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vijay Balakrishna <vijayb@linux.microsoft.com>

commit 4aab2be0983031a05cb4a19696c9da5749523426 upstream.

When memory is hotplug added or removed the min_free_kbytes should be
recalculated based on what is expected by khugepaged.  Currently after
hotplug, min_free_kbytes will be set to a lower default and higher
default set when THP enabled is lost.

This change restores min_free_kbytes as expected for THP consumers.

[vijayb@linux.microsoft.com: v5]
  Link: https://lkml.kernel.org/r/1601398153-5517-1-git-send-email-vijayb@linux.microsoft.com

Fixes: f000565adb77 ("thp: set recommended min free kbytes")
Signed-off-by: Vijay Balakrishna <vijayb@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Allen Pais <apais@microsoft.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/1600305709-2319-2-git-send-email-vijayb@linux.microsoft.com
Link: https://lkml.kernel.org/r/1600204258-13683-1-git-send-email-vijayb@linux.microsoft.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/khugepaged.h |    5 +++++
 mm/khugepaged.c            |   13 +++++++++++--
 mm/page_alloc.c            |    3 +++
 3 files changed, 19 insertions(+), 2 deletions(-)

--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -13,6 +13,7 @@ extern int __khugepaged_enter(struct mm_
 extern void __khugepaged_exit(struct mm_struct *mm);
 extern int khugepaged_enter_vma_merge(struct vm_area_struct *vma,
 				      unsigned long vm_flags);
+extern void khugepaged_min_free_kbytes_update(void);
 
 #define khugepaged_enabled()					       \
 	(transparent_hugepage_flags &				       \
@@ -70,6 +71,10 @@ static inline int khugepaged_enter_vma_m
 {
 	return 0;
 }
+
+static inline void khugepaged_min_free_kbytes_update(void)
+{
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_KHUGEPAGED_H */
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -50,6 +50,9 @@ enum scan_result {
 #define CREATE_TRACE_POINTS
 #include <trace/events/huge_memory.h>
 
+static struct task_struct *khugepaged_thread __read_mostly;
+static DEFINE_MUTEX(khugepaged_mutex);
+
 /* default scan 8*512 pte (or vmas) every 30 second */
 static unsigned int khugepaged_pages_to_scan __read_mostly;
 static unsigned int khugepaged_pages_collapsed;
@@ -1948,8 +1951,6 @@ static void set_recommended_min_free_kby
 
 int start_stop_khugepaged(void)
 {
-	static struct task_struct *khugepaged_thread __read_mostly;
-	static DEFINE_MUTEX(khugepaged_mutex);
 	int err = 0;
 
 	mutex_lock(&khugepaged_mutex);
@@ -1976,3 +1977,11 @@ fail:
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
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -64,6 +64,7 @@
 #include <linux/page_owner.h>
 #include <linux/kthread.h>
 #include <linux/memcontrol.h>
+#include <linux/khugepaged.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -6785,6 +6786,8 @@ int __meminit init_per_zone_wmark_min(vo
 	setup_min_slab_ratio();
 #endif
 
+	khugepaged_min_free_kbytes_update();
+
 	return 0;
 }
 postcore_initcall(init_per_zone_wmark_min)


