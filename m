Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C701537C5D5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbhELPni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232942AbhELPjD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:39:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE8A36199B;
        Wed, 12 May 2021 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832834;
        bh=hm7zlPd3i6DhNWvRiqLjzlRdTb94Y6hFcTU5uPnT8Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWKv8UEExSsQeX7N1+Azr0oq635Hhz3pRVdBmIXrcLKWDKeguQEArZLJdUA2m74li
         TFsHsOkk/LES14+2sgPMxUED8Niudo1KwWWP7M8TG3lfsWmcgtplDag7KdDV7frMAV
         n9nBBIfGpDwJBH75U3RgilHya1qb3WyXf96EImvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Richter <rrichter@amd.com>,
        Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        =?UTF-8?q?Martin=20Li=C5=A1ka?= <mliska@suse.cz>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vijay Thakkar <vijaythakkar@me.com>,
        linux-perf-users@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [PATCH 5.10 408/530] perf vendor events amd: Fix broken L2 Cache Hits from L2 HWPF metric
Date:   Wed, 12 May 2021 16:48:38 +0200
Message-Id: <20210512144833.172352448@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>

[ Upstream commit 86c2bc3da769124e3e856b6e9457be3667c30919 ]

Commit 08ed77e414ab2342 ("perf vendor events amd: Add recommended events")
added the hits event "L2 Cache Hits from L2 HWPF" with the same metric
expression as the accesses event "L2 Cache Accesses from L2 HWPF":

$ perf list --details
...
  l2_cache_accesses_from_l2_hwpf
     [L2 Cache Accesses from L2 HWPF]
     [l2_pf_hit_l2 + l2_pf_miss_l2_hit_l3 + l2_pf_miss_l2_l3]
  l2_cache_hits_from_l2_hwpf
     [L2 Cache Hits from L2 HWPF]
     [l2_pf_hit_l2 + l2_pf_miss_l2_hit_l3 + l2_pf_miss_l2_l3]
...

This was wrong and led to counting hits the same as accesses. Section
2.1.15.2 "Performance Measurement" of "PPR for AMD Family 17h Model 31h
B0 - 55803 Rev 0.54 - Sep 12, 2019", documents the hits event with
EventCode 0x70 which is the same as l2_pf_hit_l2.

Fix this, and massage the description for l2_pf_hit_l2 as the hits event
is now the duplicate of l2_pf_hit_l2. AMD recommends using the recommended
event over other events if the duplicate exists and maintain both for
consistency. Hence, l2_cache_hits_from_l2_hwpf should override
l2_pf_hit_l2.

Before:

 # perf stat -M l2_cache_accesses_from_l2_hwpf,l2_cache_hits_from_l2_hwpf sleep 1

 Performance counter stats for 'sleep 1':

             1,436      l2_pf_miss_l2_l3          # 11114.00 l2_cache_accesses_from_l2_hwpf
                                                  # 11114.00 l2_cache_hits_from_l2_hwpf
             4,482      l2_pf_hit_l2
             5,196      l2_pf_miss_l2_hit_l3

       1.001765339 seconds time elapsed

After:

 # perf stat -M l2_cache_accesses_from_l2_hwpf sleep 1

 Performance counter stats for 'sleep 1':

             1,477      l2_pf_miss_l2_l3          # 10442.00 l2_cache_accesses_from_l2_hwpf
             3,978      l2_pf_hit_l2
             4,987      l2_pf_miss_l2_hit_l3

       1.001491186 seconds time elapsed

 # perf stat -e l2_cache_hits_from_l2_hwpf sleep 1

 Performance counter stats for 'sleep 1':

             3,983      l2_cache_hits_from_l2_hwpf

       1.001329970 seconds time elapsed

Note the difference in performance counter values for the accesses
versus the hits after the fix, and the hits event now counting the same
as l2_pf_hit_l2.

Fixes: 08ed77e414ab ("perf vendor events amd: Add recommended events")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Reviewed-by: Robert Richter <rrichter@amd.com>
Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Tested-by: Arnaldo Carvalho de Melo <acme@kernel.org> # On a 3900X
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kim Phillips <kim.phillips@amd.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin Liška <mliska@suse.cz>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vijay Thakkar <vijaythakkar@me.com>
Cc: linux-perf-users@vger.kernel.org
Link: https://lore.kernel.org/r/20210406215944.113332-2-Smita.KoralahalliChannabasappa@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/arch/x86/amdzen1/cache.json       | 2 +-
 tools/perf/pmu-events/arch/x86/amdzen1/recommended.json | 6 +++---
 tools/perf/pmu-events/arch/x86/amdzen2/cache.json       | 2 +-
 tools/perf/pmu-events/arch/x86/amdzen2/recommended.json | 6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/pmu-events/arch/x86/amdzen1/cache.json b/tools/perf/pmu-events/arch/x86/amdzen1/cache.json
index 4ea7ec4f496e..008f1683e540 100644
--- a/tools/perf/pmu-events/arch/x86/amdzen1/cache.json
+++ b/tools/perf/pmu-events/arch/x86/amdzen1/cache.json
@@ -275,7 +275,7 @@
   {
     "EventName": "l2_pf_hit_l2",
     "EventCode": "0x70",
-    "BriefDescription": "L2 prefetch hit in L2.",
+    "BriefDescription": "L2 prefetch hit in L2. Use l2_cache_hits_from_l2_hwpf instead.",
     "UMask": "0xff"
   },
   {
diff --git a/tools/perf/pmu-events/arch/x86/amdzen1/recommended.json b/tools/perf/pmu-events/arch/x86/amdzen1/recommended.json
index 2cfe2d2f3bfd..3c954543d1ae 100644
--- a/tools/perf/pmu-events/arch/x86/amdzen1/recommended.json
+++ b/tools/perf/pmu-events/arch/x86/amdzen1/recommended.json
@@ -79,10 +79,10 @@
     "UMask": "0x70"
   },
   {
-    "MetricName": "l2_cache_hits_from_l2_hwpf",
+    "EventName": "l2_cache_hits_from_l2_hwpf",
+    "EventCode": "0x70",
     "BriefDescription": "L2 Cache Hits from L2 HWPF",
-    "MetricExpr": "l2_pf_hit_l2 + l2_pf_miss_l2_hit_l3 + l2_pf_miss_l2_l3",
-    "MetricGroup": "l2_cache"
+    "UMask": "0xff"
   },
   {
     "EventName": "l3_accesses",
diff --git a/tools/perf/pmu-events/arch/x86/amdzen2/cache.json b/tools/perf/pmu-events/arch/x86/amdzen2/cache.json
index f61b982f83ca..8ba84a48188d 100644
--- a/tools/perf/pmu-events/arch/x86/amdzen2/cache.json
+++ b/tools/perf/pmu-events/arch/x86/amdzen2/cache.json
@@ -205,7 +205,7 @@
   {
     "EventName": "l2_pf_hit_l2",
     "EventCode": "0x70",
-    "BriefDescription": "L2 prefetch hit in L2.",
+    "BriefDescription": "L2 prefetch hit in L2. Use l2_cache_hits_from_l2_hwpf instead.",
     "UMask": "0xff"
   },
   {
diff --git a/tools/perf/pmu-events/arch/x86/amdzen2/recommended.json b/tools/perf/pmu-events/arch/x86/amdzen2/recommended.json
index 2ef91e25e661..1c624cee9ef4 100644
--- a/tools/perf/pmu-events/arch/x86/amdzen2/recommended.json
+++ b/tools/perf/pmu-events/arch/x86/amdzen2/recommended.json
@@ -79,10 +79,10 @@
     "UMask": "0x70"
   },
   {
-    "MetricName": "l2_cache_hits_from_l2_hwpf",
+    "EventName": "l2_cache_hits_from_l2_hwpf",
+    "EventCode": "0x70",
     "BriefDescription": "L2 Cache Hits from L2 HWPF",
-    "MetricExpr": "l2_pf_hit_l2 + l2_pf_miss_l2_hit_l3 + l2_pf_miss_l2_l3",
-    "MetricGroup": "l2_cache"
+    "UMask": "0xff"
   },
   {
     "EventName": "l3_accesses",
-- 
2.30.2



