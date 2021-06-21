Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDED3AF023
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhFUQq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233509AbhFUQoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:44:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2372861453;
        Mon, 21 Jun 2021 16:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293140;
        bh=R1yKl8uCh+vmHRowduVtXAF+6lt3Nqu38ZK+u/j3M1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c4oni1r8A95dzQSOLlK8yHwcsmeWTZThYl7h9doNYLI1+E9rVD9wUXdW6sN81LX5O
         Ja1OfUqkjD2L6PicSejVlvg6DTQvk05fpZDJWLN69kqdUeUSdfUENtx1eg4pvIP5cA
         eWnluu0qV6puOiN/ZYuNkqYXcOkLaX1atpZo8L1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 113/178] perf metricgroup: Fix find_evsel_group() event selector
Date:   Mon, 21 Jun 2021 18:15:27 +0200
Message-Id: <20210621154926.615920434@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit fc96ec4d5d4155c61cbafd49fb2dd403c899a9f4 ]

The following command segfaults on my x86 broadwell:

  $ ./perf stat  -M frontend_bound,retiring,backend_bound,bad_speculation sleep 1
  WARNING: grouped events cpus do not match, disabling group:
    anon group { raw 0x10e }
    anon group { raw 0x10e }
  perf: util/evsel.c:1596: get_group_fd: Assertion `!(!leader->core.fd)' failed.
  Aborted (core dumped)

The issue shows itself as a use-after-free in evlist__check_cpu_maps(),
whereby the leader of an event selector (evsel) has been deleted (yet we
still attempt to verify for an evsel).

Fundamentally the problem comes from metricgroup__setup_events() ->
find_evsel_group(), and has developed from the previous fix attempt in
commit 9c880c24cb0d ("perf metricgroup: Fix for metrics containing
duration_time").

The problem now is that the logic in checking if an evsel is in the same
group is subtly broken for the "cycles" event. For the "cycles" event,
the pmu_name is NULL; however the logic in find_evsel_group() may set an
event matched against "cycles" as used, when it should not be.

This leads to a condition where an evsel is set, yet its leader is not.

Fix the check for evsel pmu_name by not matching evsels when either has a
NULL pmu_name.

There is still a pre-existing metric issue whereby the ordering of the
metrics may break the 'stat' function, as discussed at:
https://lore.kernel.org/lkml/49c6fccb-b716-1bf0-18a6-cace1cdb66b9@huawei.com/

Fixes: 9c880c24cb0d ("perf metricgroup: Fix for metrics containing duration_time")
Signed-off-by: John Garry <john.garry@huawei.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com> # On a Thinkpad T450S
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/1623335580-187317-2-git-send-email-john.garry@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/metricgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 26c990e32378..1af71ac1cc68 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -162,10 +162,10 @@ static bool contains_event(struct evsel **metric_events, int num_events,
 	return false;
 }
 
-static bool evsel_same_pmu(struct evsel *ev1, struct evsel *ev2)
+static bool evsel_same_pmu_or_none(struct evsel *ev1, struct evsel *ev2)
 {
 	if (!ev1->pmu_name || !ev2->pmu_name)
-		return false;
+		return true;
 
 	return !strcmp(ev1->pmu_name, ev2->pmu_name);
 }
@@ -288,7 +288,7 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
 			 */
 			if (!has_constraint &&
 			    ev->leader != metric_events[i]->leader &&
-			    evsel_same_pmu(ev->leader, metric_events[i]->leader))
+			    evsel_same_pmu_or_none(ev->leader, metric_events[i]->leader))
 				break;
 			if (!strcmp(metric_events[i]->name, ev->name)) {
 				set_bit(ev->idx, evlist_used);
-- 
2.30.2



