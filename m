Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9F8148446
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390044AbgAXLRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:17:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388431AbgAXLRV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:17:21 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE50B20708;
        Fri, 24 Jan 2020 11:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864640;
        bh=8jsDoSQQObdWl/23S5S/Ie1KvLjzvlQpwUHF6wjzK/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTF8j8BAP1RnHnouY8jRkmQoHR1KyYbC9iELHWCUVrOljsj6bISyjvXKHy45VqPM+
         FHCQnHszcQn5L/evywsC78f/0X2Yj602oEeS2wmydlXSZHrzafu+4CmUM+TgbgwM9v
         qo6xLjIcu6y0u39R0YijKr72CAb1mpxXNgGrK8xM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 310/639] perf/core: Fix the address filtering fix
Date:   Fri, 24 Jan 2020 10:28:00 +0100
Message-Id: <20200124093125.759202603@linuxfoundation.org>
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

[ Upstream commit 52a44f83fc2d64a5e74d5d685fad2fecc7b7a321 ]

The following recent commit:

  c60f83b813e5 ("perf, pt, coresight: Fix address filters for vmas with non-zero offset")

changes the address filtering logic to communicate filter ranges to the PMU driver
via a single address range object, instead of having the driver do the final bit of
math.

That change forgets to take into account kernel filters, which are not calculated
the same way as DSO based filters.

Fix that by passing the kernel filters the same way as file-based filters.
This doesn't require any additional changes in the drivers.

Reported-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Fixes: c60f83b813e5 ("perf, pt, coresight: Fix address filters for vmas with non-zero offset")
Link: https://lkml.kernel.org/r/20190329091212.29870-1-alexander.shishkin@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4eef2d42d05c4..751888cbed5c0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8861,26 +8861,29 @@ static void perf_event_addr_filters_apply(struct perf_event *event)
 	if (task == TASK_TOMBSTONE)
 		return;
 
-	if (!ifh->nr_file_filters)
-		return;
-
-	mm = get_task_mm(event->ctx->task);
-	if (!mm)
-		goto restart;
+	if (ifh->nr_file_filters) {
+		mm = get_task_mm(event->ctx->task);
+		if (!mm)
+			goto restart;
 
-	down_read(&mm->mmap_sem);
+		down_read(&mm->mmap_sem);
+	}
 
 	raw_spin_lock_irqsave(&ifh->lock, flags);
 	list_for_each_entry(filter, &ifh->list, entry) {
-		event->addr_filter_ranges[count].start = 0;
-		event->addr_filter_ranges[count].size = 0;
+		if (filter->path.dentry) {
+			/*
+			 * Adjust base offset if the filter is associated to a
+			 * binary that needs to be mapped:
+			 */
+			event->addr_filter_ranges[count].start = 0;
+			event->addr_filter_ranges[count].size = 0;
 
-		/*
-		 * Adjust base offset if the filter is associated to a binary
-		 * that needs to be mapped:
-		 */
-		if (filter->path.dentry)
 			perf_addr_filter_apply(filter, mm, &event->addr_filter_ranges[count]);
+		} else {
+			event->addr_filter_ranges[count].start = filter->offset;
+			event->addr_filter_ranges[count].size  = filter->size;
+		}
 
 		count++;
 	}
@@ -8888,9 +8891,11 @@ static void perf_event_addr_filters_apply(struct perf_event *event)
 	event->addr_filters_gen++;
 	raw_spin_unlock_irqrestore(&ifh->lock, flags);
 
-	up_read(&mm->mmap_sem);
+	if (ifh->nr_file_filters) {
+		up_read(&mm->mmap_sem);
 
-	mmput(mm);
+		mmput(mm);
+	}
 
 restart:
 	perf_event_stop(event, 1);
-- 
2.20.1



