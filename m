Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3BA314807F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388632AbgAXLLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:11:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389900AbgAXLLl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:11:41 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2676D20663;
        Fri, 24 Jan 2020 11:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864300;
        bh=/LQIiRt807IdlrK/+uzK5Lu6KwVwbZWcH+XbI2h1q48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKAJlo8BaG4XtzyXX+FZJDB5afQQ8WVPryCNmCQxjcfOU3JF3y1SIvFUQ3qNKu74c
         5m0wR4L7jJDbjdrfnk72mdrYSLEy64jPQGR3CEjemzzqChW0QZqH9rXQnuXUbYcmrI
         o3U/q5Mq1QoQOcIW6rFAhXa7ztwW4NJX6RHS5p5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mansour Alharthi <malharthi9@gatech.edu>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 228/639] perf: Copy parents address filter offsets on clone
Date:   Fri, 24 Jan 2020 10:26:38 +0100
Message-Id: <20200124093115.438515303@linuxfoundation.org>
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

[ Upstream commit 18736eef12137c59f60cc9f56dc5bea05c92e0eb ]

When a child event is allocated in the inherit_event() path, the VMA
based filter offsets are not copied from the parent, even though the
address space mapping of the new task remains the same, which leads to
no trace for the new task until exec.

Reported-by: Mansour Alharthi <malharthi9@gatech.edu>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Tested-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Fixes: 375637bc5249 ("perf/core: Introduce address range filtering")
Link: http://lkml.kernel.org/r/20190215115655.63469-2-alexander.shishkin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 460d5fd3ec4e4..9a5559f5938a5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1254,6 +1254,7 @@ static void put_ctx(struct perf_event_context *ctx)
  *	      perf_event_context::lock
  *	    perf_event::mmap_mutex
  *	    mmap_sem
+ *	      perf_addr_filters_head::lock
  *
  *    cpu_hotplug_lock
  *      pmus_lock
@@ -10136,6 +10137,20 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 			goto err_per_task;
 		}
 
+		/*
+		 * Clone the parent's vma offsets: they are valid until exec()
+		 * even if the mm is not shared with the parent.
+		 */
+		if (event->parent) {
+			struct perf_addr_filters_head *ifh = perf_event_addr_filters(event);
+
+			raw_spin_lock_irq(&ifh->lock);
+			memcpy(event->addr_filters_offs,
+			       event->parent->addr_filters_offs,
+			       pmu->nr_addr_filters * sizeof(unsigned long));
+			raw_spin_unlock_irq(&ifh->lock);
+		}
+
 		/* force hw sync on the address filters */
 		event->addr_filters_gen = 1;
 	}
-- 
2.20.1



