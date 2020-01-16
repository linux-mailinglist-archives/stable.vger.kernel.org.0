Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEA9913E36B
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388229AbgAPRB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:01:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:53886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388226AbgAPRB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:01:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 980BC21D56;
        Thu, 16 Jan 2020 17:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194117;
        bh=ylwMJWEEUgx9Jz1+skWKJV/2ksoOZollbQbmJVsr5VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2m/mq+vfTgRj2EEwBKm1hRNtMkBLYXqwnSLScXmcCut4HCPtI7HvS/56/oJqAH4oW
         Cfj29cmJoyEXCljLQJNlakPtEUs67xDJIJEx4vubvEZJRCcrhLCHSBoIhEKtK/xhG3
         cdh45+0pdWuqMuUNIhcOZ18F4axLlbqo1ienxxy0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mansour Alharthi <malharthi9@gatech.edu>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 212/671] perf: Copy parent's address filter offsets on clone
Date:   Thu, 16 Jan 2020 11:52:01 -0500
Message-Id: <20200116165940.10720-95-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 460d5fd3ec4e..9a5559f5938a 100644
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

