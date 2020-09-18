Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C99826EC82
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgIRCM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728760AbgIRCM0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:12:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 471AD238E6;
        Fri, 18 Sep 2020 02:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395135;
        bh=US5ETsLWrd3/juq7mHalJNvd8wcj2XxIxLJcZQif6TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rL1sGdzbizI1A0/R4/MOYDr7Mhxx6Gow1O0evYS55Su0v9zN65kwF01mFuWT5ax+w
         S+8w5wtAYQpRNFEjvAb16oOsgbxWXA3D+drikoI1uvaGiWu2e52v4K30IDG0Y9K+Ho
         UKeAtlNcgHucCj+eVmevrMECeloacJVtDhLR5Fqc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jin Yao <yao.jin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jin Yao <yao.jin@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 204/206] perf parse-events: Use strcmp() to compare the PMU name
Date:   Thu, 17 Sep 2020 22:08:00 -0400
Message-Id: <20200918020802.2065198-204-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jin Yao <yao.jin@linux.intel.com>

[ Upstream commit 8510895bafdbf7c4dd24c22946d925691135c2b2 ]

A big uncore event group is split into multiple small groups which only
include the uncore events from the same PMU. This has been supported in
the commit 3cdc5c2cb924a ("perf parse-events: Handle uncore event
aliases in small groups properly").

If the event's PMU name starts to repeat, it must be a new event.
That can be used to distinguish the leader from other members.
But now it only compares the pointer of pmu_name
(leader->pmu_name == evsel->pmu_name).

If we use "perf stat -M LLC_MISSES.PCIE_WRITE -a" on cascadelakex,
the event list is:

  evsel->name					evsel->pmu_name
  ---------------------------------------------------------------
  unc_iio_data_req_of_cpu.mem_write.part0		uncore_iio_4 (as leader)
  unc_iio_data_req_of_cpu.mem_write.part0		uncore_iio_2
  unc_iio_data_req_of_cpu.mem_write.part0		uncore_iio_0
  unc_iio_data_req_of_cpu.mem_write.part0		uncore_iio_5
  unc_iio_data_req_of_cpu.mem_write.part0		uncore_iio_3
  unc_iio_data_req_of_cpu.mem_write.part0		uncore_iio_1
  unc_iio_data_req_of_cpu.mem_write.part1		uncore_iio_4
  ......

For the event "unc_iio_data_req_of_cpu.mem_write.part1" with
"uncore_iio_4", it should be the event from PMU "uncore_iio_4".
It's not a new leader for this PMU.

But if we use "(leader->pmu_name == evsel->pmu_name)", the check
would be failed and the event is stored to leaders[] as a new
PMU leader.

So this patch uses strcmp to compare the PMU name between events.

Fixes: d4953f7ef1a2 ("perf parse-events: Fix 3 use after frees found with clang ASAN")
Signed-off-by: Jin Yao <yao.jin@linux.intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jin Yao <yao.jin@intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20200430003618.17002-1-yao.jin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 426f1984c143e..5ab5c69f50500 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1423,12 +1423,11 @@ parse_events__set_leader_for_uncore_aliase(char *name, struct list_head *list,
 		 * event. That can be used to distinguish the leader from
 		 * other members, even they have the same event name.
 		 */
-		if ((leader != evsel) && (leader->pmu_name == evsel->pmu_name)) {
+		if ((leader != evsel) &&
+		    !strcmp(leader->pmu_name, evsel->pmu_name)) {
 			is_leader = false;
 			continue;
 		}
-		/* The name is always alias name */
-		WARN_ON(strcmp(leader->name, evsel->name));
 
 		/* Store the leader event for each PMU */
 		leaders[nr_pmu++] = (uintptr_t) evsel;
-- 
2.25.1

