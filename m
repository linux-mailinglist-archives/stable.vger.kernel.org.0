Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B50C4EDF7
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 19:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfFURlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 13:41:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbfFURlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Jun 2019 13:41:04 -0400
Received: from quaco.ghostprotocols.net (187-26-104-93.3g.claro.net.br [187.26.104.93])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8FA6208C3;
        Fri, 21 Jun 2019 17:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561138863;
        bh=QPJHaL3OS0GzfeK6O1ZxuGW8Vz75KPhsoGFuVduABng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wN1itsimpustKG30e0ueI6HXePSqD0jBieAjifNXTLIKDv96oumJMz4CnYPlN0F2T
         odHpXrDIn9m/RD6inXUwepvT5w1AmwYEX3WH3oxf4ayImFqnkKy57jKboPi1UOTXIR
         VgHmCfsFgqP+xi/zcLZGnZMi+MRDRVp8vtIWzcss=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com,
        stable@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/25] perf pmu: Fix uncore PMU alias list for ARM64
Date:   Fri, 21 Jun 2019 14:38:25 -0300
Message-Id: <20190621173831.13780-20-acme@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621173831.13780-1-acme@kernel.org>
References: <20190621173831.13780-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

In commit 292c34c10249 ("perf pmu: Fix core PMU alias list for X86
platform"), we fixed the issue of CPU events being aliased to uncore
events.

Fix this same issue for ARM64, since the said commit left the (broken)
behaviour untouched for ARM64.

Signed-off-by: John Garry <john.garry@huawei.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Hendrik Brueckner <brueckner@linux.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linuxarm@huawei.com
Cc: stable@vger.kernel.org
Fixes: 292c34c10249 ("perf pmu: Fix core PMU alias list for X86 platform")
Link: http://lkml.kernel.org/r/1560521283-73314-2-git-send-email-john.garry@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/pmu.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index e0429f4ef335..faa8eb231e1b 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -709,9 +709,7 @@ static void pmu_add_cpu_aliases(struct list_head *head, struct perf_pmu *pmu)
 {
 	int i;
 	struct pmu_events_map *map;
-	struct pmu_event *pe;
 	const char *name = pmu->name;
-	const char *pname;
 
 	map = perf_pmu__find_map(pmu);
 	if (!map)
@@ -722,28 +720,26 @@ static void pmu_add_cpu_aliases(struct list_head *head, struct perf_pmu *pmu)
 	 */
 	i = 0;
 	while (1) {
+		const char *cpu_name = is_arm_pmu_core(name) ? name : "cpu";
+		struct pmu_event *pe = &map->table[i++];
+		const char *pname = pe->pmu ? pe->pmu : cpu_name;
 
-		pe = &map->table[i++];
 		if (!pe->name) {
 			if (pe->metric_group || pe->metric_name)
 				continue;
 			break;
 		}
 
-		if (!is_arm_pmu_core(name)) {
-			pname = pe->pmu ? pe->pmu : "cpu";
-
-			/*
-			 * uncore alias may be from different PMU
-			 * with common prefix
-			 */
-			if (pmu_is_uncore(name) &&
-			    !strncmp(pname, name, strlen(pname)))
-				goto new_alias;
+		/*
+		 * uncore alias may be from different PMU
+		 * with common prefix
+		 */
+		if (pmu_is_uncore(name) &&
+		    !strncmp(pname, name, strlen(pname)))
+			goto new_alias;
 
-			if (strcmp(pname, name))
-				continue;
-		}
+		if (strcmp(pname, name))
+			continue;
 
 new_alias:
 		/* need type casts to override 'const' */
-- 
2.20.1

