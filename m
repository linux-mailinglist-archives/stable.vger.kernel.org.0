Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E98623A4AD
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbgHCM3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:29:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728921AbgHCM3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:29:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A32AB207DF;
        Mon,  3 Aug 2020 12:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457770;
        bh=MPorudU0yKZNviFiD8N6aBXJXOyf1iQeYGVYQZrt2hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aj07cbd/m81Mi9Mk2GXN4efO4QYJHvcCpvAn0vqOdozSbM3Ki/rUWBl86P5LpW2q8
         k3xTQgQPzT9vKRe4o47BulL2+QZBWw1OQ0QiSOu4g8wYFP0bnpMxomDXARMFSnqTK4
         0Ggg7POUa1MoTtYmY0bnfK9tUubeZTfl5xYRoxNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Li <liwei391@huawei.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Kim Phillips <kim.phillips@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Leo Yan <leo.yan@linaro.org>
Subject: [PATCH 5.4 68/90] perf tools: Fix record failure when mixed with ARM SPE event
Date:   Mon,  3 Aug 2020 14:19:30 +0200
Message-Id: <20200803121900.912821445@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Li <liwei391@huawei.com>

[ Upstream commit bd3c628f8fafa6cbd6a1ca440034b841f0080160 ]

When recording with cache-misses and arm_spe_x event, I found that it
will just fail without showing any error info if i put cache-misses
after 'arm_spe_x' event.

  [root@localhost 0620]# perf record -e cache-misses \
				-e arm_spe_0/ts_enable=1,pct_enable=1,pa_enable=1,load_filter=1,jitter=1,store_filter=1,min_latency=0/ sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.067 MB perf.data ]
  [root@localhost 0620]#
  [root@localhost 0620]# perf record -e arm_spe_0/ts_enable=1,pct_enable=1,pa_enable=1,load_filter=1,jitter=1,store_filter=1,min_latency=0/ \
				     -e  cache-misses sleep 1
  [root@localhost 0620]#

The current code can only work if the only event to be traced is an
'arm_spe_x', or if it is the last event to be specified. Otherwise the
last event type will be checked against all the arm_spe_pmus[i]->types,
none will match and an out of bound 'i' index will be used in
arm_spe_recording_init().

We don't support concurrent multiple arm_spe_x events currently, that
is checked in arm_spe_recording_options(), and it will show the relevant
info. So add the check and record of the first found 'arm_spe_pmu' to
fix this issue here.

Fixes: ffd3d18c20b8 ("perf tools: Add ARM Statistical Profiling Extensions (SPE) support")
Signed-off-by: Wei Li <liwei391@huawei.com>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Tested-by-by: Leo Yan <leo.yan@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kim Phillips <kim.phillips@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lore.kernel.org/lkml/20200724071111.35593-2-liwei391@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/arm/util/auxtrace.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/arch/arm/util/auxtrace.c b/tools/perf/arch/arm/util/auxtrace.c
index 0a6e75b8777a6..28a5d0c18b1d2 100644
--- a/tools/perf/arch/arm/util/auxtrace.c
+++ b/tools/perf/arch/arm/util/auxtrace.c
@@ -56,7 +56,7 @@ struct auxtrace_record
 	struct perf_pmu	*cs_etm_pmu;
 	struct evsel *evsel;
 	bool found_etm = false;
-	bool found_spe = false;
+	struct perf_pmu *found_spe = NULL;
 	static struct perf_pmu **arm_spe_pmus = NULL;
 	static int nr_spes = 0;
 	int i = 0;
@@ -74,12 +74,12 @@ struct auxtrace_record
 		    evsel->core.attr.type == cs_etm_pmu->type)
 			found_etm = true;
 
-		if (!nr_spes)
+		if (!nr_spes || found_spe)
 			continue;
 
 		for (i = 0; i < nr_spes; i++) {
 			if (evsel->core.attr.type == arm_spe_pmus[i]->type) {
-				found_spe = true;
+				found_spe = arm_spe_pmus[i];
 				break;
 			}
 		}
@@ -96,7 +96,7 @@ struct auxtrace_record
 
 #if defined(__aarch64__)
 	if (found_spe)
-		return arm_spe_recording_init(err, arm_spe_pmus[i]);
+		return arm_spe_recording_init(err, found_spe);
 #endif
 
 	/*
-- 
2.25.1



