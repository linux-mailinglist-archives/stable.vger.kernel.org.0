Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0315114848B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbgAXLLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:11:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:47786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389907AbgAXLLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:11:45 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75EE820708;
        Fri, 24 Jan 2020 11:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864304;
        bh=o9kL20K4nBF12avkhGXlJXa5iFUNjeSWzkC5e6D0Wko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lK3Fgga+1jRYMrb7RufRT07OYoKM+uyH9fYqxJ1E0IU2lqmh6L0c+gqS3ETmOw8gl
         Shzq/CNUOYiR9ggIlfVH8gA7PK9A7CUkJoj7pm4zibFsOg7WX71EGPOedtwxtsgnbQ
         WyZKTexyQZISccb99/CFsvZr1YKUI3Jp71Tg7Tl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 229/639] perf, pt, coresight: Fix address filters for vmas with non-zero offset
Date:   Fri, 24 Jan 2020 10:26:39 +0100
Message-Id: <20200124093115.555695191@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

[ Upstream commit c60f83b813e5b25ccd5de7e8c8925c31b3aebcc1 ]

Currently, the address range calculation for file-based filters works as
long as the vma that maps the matching part of the object file starts
from offset zero into the file (vm_pgoff==0). Otherwise, the resulting
filter range would be off by vm_pgoff pages. Another related problem is
that in case of a partially matching vma, that is, a vma that matches
part of a filter region, the filter range size wouldn't be adjusted.

Fix the arithmetics around address filter range calculations, taking
into account vma offset, so that the entire calculation is done before
the filter configuration is passed to the PMU drivers instead of having
those drivers do the final bit of arithmetics.

Based on the patch by Adrian Hunter <adrian.hunter.intel.com>.

Reported-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Tested-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Fixes: 375637bc5249 ("perf/core: Introduce address range filtering")
Link: http://lkml.kernel.org/r/20190215115655.63469-3-alexander.shishkin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/pt.c                    |  9 ++-
 .../hwtracing/coresight/coresight-etm-perf.c  |  7 +-
 include/linux/perf_event.h                    |  7 +-
 kernel/events/core.c                          | 81 +++++++++++--------
 4 files changed, 62 insertions(+), 42 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 8f4c98fdd03c5..f03100bc5fd12 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1213,7 +1213,8 @@ static int pt_event_addr_filters_validate(struct list_head *filters)
 static void pt_event_addr_filters_sync(struct perf_event *event)
 {
 	struct perf_addr_filters_head *head = perf_event_addr_filters(event);
-	unsigned long msr_a, msr_b, *offs = event->addr_filters_offs;
+	unsigned long msr_a, msr_b;
+	struct perf_addr_filter_range *fr = event->addr_filter_ranges;
 	struct pt_filters *filters = event->hw.addr_filters;
 	struct perf_addr_filter *filter;
 	int range = 0;
@@ -1222,12 +1223,12 @@ static void pt_event_addr_filters_sync(struct perf_event *event)
 		return;
 
 	list_for_each_entry(filter, &head->list, entry) {
-		if (filter->path.dentry && !offs[range]) {
+		if (filter->path.dentry && !fr[range].start) {
 			msr_a = msr_b = 0;
 		} else {
 			/* apply the offset */
-			msr_a = filter->offset + offs[range];
-			msr_b = filter->size + msr_a - 1;
+			msr_a = fr[range].start;
+			msr_b = msr_a + fr[range].size - 1;
 		}
 
 		filters->filter[range].msr_a  = msr_a;
diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/hwtracing/coresight/coresight-etm-perf.c
index c3c6452015142..567f46ca25998 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -437,15 +437,16 @@ static int etm_addr_filters_validate(struct list_head *filters)
 static void etm_addr_filters_sync(struct perf_event *event)
 {
 	struct perf_addr_filters_head *head = perf_event_addr_filters(event);
-	unsigned long start, stop, *offs = event->addr_filters_offs;
+	unsigned long start, stop;
+	struct perf_addr_filter_range *fr = event->addr_filter_ranges;
 	struct etm_filters *filters = event->hw.addr_filters;
 	struct etm_filter *etm_filter;
 	struct perf_addr_filter *filter;
 	int i = 0;
 
 	list_for_each_entry(filter, &head->list, entry) {
-		start = filter->offset + offs[i];
-		stop = start + filter->size;
+		start = fr[i].start;
+		stop = start + fr[i].size;
 		etm_filter = &filters->etm_filter[i];
 
 		switch (filter->action) {
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index b22bc81f3669a..d8b4d31acd18e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -494,6 +494,11 @@ struct perf_addr_filters_head {
 	unsigned int		nr_file_filters;
 };
 
+struct perf_addr_filter_range {
+	unsigned long		start;
+	unsigned long		size;
+};
+
 /**
  * enum perf_event_state - the states of an event:
  */
@@ -670,7 +675,7 @@ struct perf_event {
 	/* address range filters */
 	struct perf_addr_filters_head	addr_filters;
 	/* vma address array for file-based filders */
-	unsigned long			*addr_filters_offs;
+	struct perf_addr_filter_range	*addr_filter_ranges;
 	unsigned long			addr_filters_gen;
 
 	void (*destroy)(struct perf_event *);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9a5559f5938a5..4eef2d42d05c4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2804,7 +2804,7 @@ static int perf_event_stop(struct perf_event *event, int restart)
  *
  * (p1) when userspace mappings change as a result of (1) or (2) or (3) below,
  *      we update the addresses of corresponding vmas in
- *	event::addr_filters_offs array and bump the event::addr_filters_gen;
+ *	event::addr_filter_ranges array and bump the event::addr_filters_gen;
  * (p2) when an event is scheduled in (pmu::add), it calls
  *      perf_event_addr_filters_sync() which calls pmu::addr_filters_sync()
  *      if the generation has changed since the previous call.
@@ -4448,7 +4448,7 @@ static void _free_event(struct perf_event *event)
 
 	perf_event_free_bpf_prog(event);
 	perf_addr_filters_splice(event, NULL);
-	kfree(event->addr_filters_offs);
+	kfree(event->addr_filter_ranges);
 
 	if (event->destroy)
 		event->destroy(event);
@@ -6743,7 +6743,8 @@ static void perf_event_addr_filters_exec(struct perf_event *event, void *data)
 	raw_spin_lock_irqsave(&ifh->lock, flags);
 	list_for_each_entry(filter, &ifh->list, entry) {
 		if (filter->path.dentry) {
-			event->addr_filters_offs[count] = 0;
+			event->addr_filter_ranges[count].start = 0;
+			event->addr_filter_ranges[count].size = 0;
 			restart++;
 		}
 
@@ -7425,28 +7426,47 @@ static bool perf_addr_filter_match(struct perf_addr_filter *filter,
 	return true;
 }
 
+static bool perf_addr_filter_vma_adjust(struct perf_addr_filter *filter,
+					struct vm_area_struct *vma,
+					struct perf_addr_filter_range *fr)
+{
+	unsigned long vma_size = vma->vm_end - vma->vm_start;
+	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
+	struct file *file = vma->vm_file;
+
+	if (!perf_addr_filter_match(filter, file, off, vma_size))
+		return false;
+
+	if (filter->offset < off) {
+		fr->start = vma->vm_start;
+		fr->size = min(vma_size, filter->size - (off - filter->offset));
+	} else {
+		fr->start = vma->vm_start + filter->offset - off;
+		fr->size = min(vma->vm_end - fr->start, filter->size);
+	}
+
+	return true;
+}
+
 static void __perf_addr_filters_adjust(struct perf_event *event, void *data)
 {
 	struct perf_addr_filters_head *ifh = perf_event_addr_filters(event);
 	struct vm_area_struct *vma = data;
-	unsigned long off = vma->vm_pgoff << PAGE_SHIFT, flags;
-	struct file *file = vma->vm_file;
 	struct perf_addr_filter *filter;
 	unsigned int restart = 0, count = 0;
+	unsigned long flags;
 
 	if (!has_addr_filter(event))
 		return;
 
-	if (!file)
+	if (!vma->vm_file)
 		return;
 
 	raw_spin_lock_irqsave(&ifh->lock, flags);
 	list_for_each_entry(filter, &ifh->list, entry) {
-		if (perf_addr_filter_match(filter, file, off,
-					     vma->vm_end - vma->vm_start)) {
-			event->addr_filters_offs[count] = vma->vm_start;
+		if (perf_addr_filter_vma_adjust(filter, vma,
+						&event->addr_filter_ranges[count]))
 			restart++;
-		}
 
 		count++;
 	}
@@ -8806,26 +8826,19 @@ static void perf_addr_filters_splice(struct perf_event *event,
  * @filter; if so, adjust filter's address range.
  * Called with mm::mmap_sem down for reading.
  */
-static unsigned long perf_addr_filter_apply(struct perf_addr_filter *filter,
-					    struct mm_struct *mm)
+static void perf_addr_filter_apply(struct perf_addr_filter *filter,
+				   struct mm_struct *mm,
+				   struct perf_addr_filter_range *fr)
 {
 	struct vm_area_struct *vma;
 
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		struct file *file = vma->vm_file;
-		unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
-		unsigned long vma_size = vma->vm_end - vma->vm_start;
-
-		if (!file)
+		if (!vma->vm_file)
 			continue;
 
-		if (!perf_addr_filter_match(filter, file, off, vma_size))
-			continue;
-
-		return vma->vm_start;
+		if (perf_addr_filter_vma_adjust(filter, vma, fr))
+			return;
 	}
-
-	return 0;
 }
 
 /*
@@ -8859,15 +8872,15 @@ static void perf_event_addr_filters_apply(struct perf_event *event)
 
 	raw_spin_lock_irqsave(&ifh->lock, flags);
 	list_for_each_entry(filter, &ifh->list, entry) {
-		event->addr_filters_offs[count] = 0;
+		event->addr_filter_ranges[count].start = 0;
+		event->addr_filter_ranges[count].size = 0;
 
 		/*
 		 * Adjust base offset if the filter is associated to a binary
 		 * that needs to be mapped:
 		 */
 		if (filter->path.dentry)
-			event->addr_filters_offs[count] =
-				perf_addr_filter_apply(filter, mm);
+			perf_addr_filter_apply(filter, mm, &event->addr_filter_ranges[count]);
 
 		count++;
 	}
@@ -10129,10 +10142,10 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 		goto err_pmu;
 
 	if (has_addr_filter(event)) {
-		event->addr_filters_offs = kcalloc(pmu->nr_addr_filters,
-						   sizeof(unsigned long),
-						   GFP_KERNEL);
-		if (!event->addr_filters_offs) {
+		event->addr_filter_ranges = kcalloc(pmu->nr_addr_filters,
+						    sizeof(struct perf_addr_filter_range),
+						    GFP_KERNEL);
+		if (!event->addr_filter_ranges) {
 			err = -ENOMEM;
 			goto err_per_task;
 		}
@@ -10145,9 +10158,9 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 			struct perf_addr_filters_head *ifh = perf_event_addr_filters(event);
 
 			raw_spin_lock_irq(&ifh->lock);
-			memcpy(event->addr_filters_offs,
-			       event->parent->addr_filters_offs,
-			       pmu->nr_addr_filters * sizeof(unsigned long));
+			memcpy(event->addr_filter_ranges,
+			       event->parent->addr_filter_ranges,
+			       pmu->nr_addr_filters * sizeof(struct perf_addr_filter_range));
 			raw_spin_unlock_irq(&ifh->lock);
 		}
 
@@ -10169,7 +10182,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	return event;
 
 err_addr_filters:
-	kfree(event->addr_filters_offs);
+	kfree(event->addr_filter_ranges);
 
 err_per_task:
 	exclusive_event_destroy(event);
-- 
2.20.1



