Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42B7304AA1
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbhAZFCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:02:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731157AbhAYSvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C907022D50;
        Mon, 25 Jan 2021 18:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600680;
        bh=qNMbMR6gSXD/xwqN1u5eSvEpKQ+ELG4nCxm4Rtt3GOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ywB4Qos2FMOdH/rhRj7ZsaYE+UVouK5HPAFMPdGPgAjyiodeX5U8UZyx1JnUWWPNX
         5XHxTL0UHxYB2b79eGqU7QrlOxKSKXu7D+2FU5IYYULhCLf68f1yYAt/XwacSrgb8F
         rKnMvmLuTTOKIvRpUNx/UZp41UKJPbxUGdfltFJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/199] perf evlist: Fix id index for heterogeneous systems
Date:   Mon, 25 Jan 2021 19:38:51 +0100
Message-Id: <20210125183220.858161972@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit fc705fecf3a0c9128933cc6db59159c050aaca33 ]

perf_evlist__set_sid_idx() updates perf_sample_id with the evlist map
index, CPU number and TID. It is passed indexes to the evsel's cpu and
thread maps, but references the evlist's maps instead. That results in
using incorrect CPU numbers on heterogeneous systems. Fix it by using
evsel maps.

The id index (PERF_RECORD_ID_INDEX) is used by AUX area tracing when in
sampling mode. Having an incorrect CPU number causes the trace data to
be attributed to the wrong CPU, and can result in decoder errors because
the trace data is then associated with the wrong process.

Committer notes:

Keep the class prefix convention in the function name, switching from
perf_evlist__set_sid_idx() to perf_evsel__set_sid_idx().

Fixes: 3c659eedada2fbf9 ("perf tools: Add id index")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lore.kernel.org/lkml/20210121125446.11287-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/evlist.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/tools/lib/perf/evlist.c b/tools/lib/perf/evlist.c
index cfcdbd7be066e..17465d454a0e3 100644
--- a/tools/lib/perf/evlist.c
+++ b/tools/lib/perf/evlist.c
@@ -367,21 +367,13 @@ static struct perf_mmap* perf_evlist__alloc_mmap(struct perf_evlist *evlist, boo
 	return map;
 }
 
-static void perf_evlist__set_sid_idx(struct perf_evlist *evlist,
-				     struct perf_evsel *evsel, int idx, int cpu,
-				     int thread)
+static void perf_evsel__set_sid_idx(struct perf_evsel *evsel, int idx, int cpu, int thread)
 {
 	struct perf_sample_id *sid = SID(evsel, cpu, thread);
 
 	sid->idx = idx;
-	if (evlist->cpus && cpu >= 0)
-		sid->cpu = evlist->cpus->map[cpu];
-	else
-		sid->cpu = -1;
-	if (!evsel->system_wide && evlist->threads && thread >= 0)
-		sid->tid = perf_thread_map__pid(evlist->threads, thread);
-	else
-		sid->tid = -1;
+	sid->cpu = perf_cpu_map__cpu(evsel->cpus, cpu);
+	sid->tid = perf_thread_map__pid(evsel->threads, thread);
 }
 
 static struct perf_mmap*
@@ -500,8 +492,7 @@ mmap_per_evsel(struct perf_evlist *evlist, struct perf_evlist_mmap_ops *ops,
 			if (perf_evlist__id_add_fd(evlist, evsel, cpu, thread,
 						   fd) < 0)
 				return -1;
-			perf_evlist__set_sid_idx(evlist, evsel, idx, cpu,
-						 thread);
+			perf_evsel__set_sid_idx(evsel, idx, cpu, thread);
 		}
 	}
 
-- 
2.27.0



