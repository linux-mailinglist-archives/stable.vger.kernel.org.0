Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DB127CA70
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732409AbgI2MTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:19:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728695AbgI2LgJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:36:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9FE723D9B;
        Tue, 29 Sep 2020 11:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379061;
        bh=eTDL6vr8Aya0VYJ1dGuyvssqLPRl6tZu8xDov9DgQRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3DmUc9/ysGu8roIGR5KSuPp5flqCSFBEWpq+rD9eAoJ+owqil9q3vKAV7f7GPYqD
         3SHZN3/nKSduLj65vncIVZB7zhCcgI7mqm5e0FCjj3Nw1apvRqLNQMk/8Vy+TL5rn6
         7mNly1N2AM3/lMTnNH2vIFKU3wHp5eebSnYdEBkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jin Yao <yao.jin@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 203/245] perf parse-events: Use strcmp() to compare the PMU name
Date:   Tue, 29 Sep 2020 13:00:54 +0200
Message-Id: <20200929105956.854267235@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 tools/perf/util/parse-events.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1421,12 +1421,11 @@ parse_events__set_leader_for_uncore_alia
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


