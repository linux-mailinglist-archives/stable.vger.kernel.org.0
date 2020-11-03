Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D05E2A528E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731861AbgKCUvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:51:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731892AbgKCUvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2DAF20719;
        Tue,  3 Nov 2020 20:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436660;
        bh=aQ5aSdQp7TX/YQjR1D8fatRK/f8bsdBrids+DXenPhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4n9R1KJzqyPBQAa4ghFdPGysl4D/snlQsF8rDi1uHOdP0vHLR6xYKstsSjXXtimD
         NZ00a0Ff0luY+2TkM/DPsYt05Pf8WioDuy9RvBNIty8FDa3EOYp+9PPqybSjUWX3jx
         e50dqLwNcDpHQt/c4xCDj8Jh5MaVpv1KugngsYCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Jon Grimm <jon.grimm@amd.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin Jambor <mjambor@suse.cz>,
        =?UTF-8?q?Martin=20Li=C5=A1ka?= <mliska@suse.cz>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Vijay Thakkar <vijaythakkar@me.com>,
        William Cohen <wcohen@redhat.com>,
        Yunfeng Ye <yeyunfeng@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.9 309/391] perf vendor events amd: Add L2 Prefetch events for zen1
Date:   Tue,  3 Nov 2020 21:36:00 +0100
Message-Id: <20201103203407.957958940@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

commit 60d804521ec4cd01217a96f33cd1bb29e295333d upstream.

Later revisions of PPRs that post-date the original Family 17h events
submission patch add these events.

Specifically, they were not in this 2017 revision of the F17h PPR:

Processor Programming Reference (PPR) for AMD Family 17h Model 01h, Revision B1 Processors Rev 1.14 - April 15, 2017

But e.g., are included in this 2019 version of the PPR:

Processor Programming Reference (PPR) for AMD Family 17h Model 18h, Revision B1 Processors Rev. 3.14 - Sep 26, 2019

Fixes: 98c07a8f74f8 ("perf vendor events amd: perf PMU events for AMD Family 17h")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Jon Grimm <jon.grimm@amd.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin Jambor <mjambor@suse.cz>
Cc: Martin Liška <mliska@suse.cz>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Cc: Stephane Eranian <eranian@google.com>
Cc: Vijay Thakkar <vijaythakkar@me.com>
Cc: William Cohen <wcohen@redhat.com>
Cc: Yunfeng Ye <yeyunfeng@huawei.com>
Link: http://lore.kernel.org/lkml/20200901220944.277505-1-kim.phillips@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/pmu-events/arch/x86/amdzen1/cache.json |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/tools/perf/pmu-events/arch/x86/amdzen1/cache.json
+++ b/tools/perf/pmu-events/arch/x86/amdzen1/cache.json
@@ -250,6 +250,24 @@
     "UMask": "0x1"
   },
   {
+    "EventName": "l2_pf_hit_l2",
+    "EventCode": "0x70",
+    "BriefDescription": "L2 prefetch hit in L2.",
+    "UMask": "0xff"
+  },
+  {
+    "EventName": "l2_pf_miss_l2_hit_l3",
+    "EventCode": "0x71",
+    "BriefDescription": "L2 prefetcher hits in L3. Counts all L2 prefetches accepted by the L2 pipeline which miss the L2 cache and hit the L3.",
+    "UMask": "0xff"
+  },
+  {
+    "EventName": "l2_pf_miss_l2_l3",
+    "EventCode": "0x72",
+    "BriefDescription": "L2 prefetcher misses in L3. All L2 prefetches accepted by the L2 pipeline which miss the L2 and the L3 caches.",
+    "UMask": "0xff"
+  },
+  {
     "EventName": "l3_request_g1.caching_l3_cache_accesses",
     "EventCode": "0x01",
     "BriefDescription": "Caching: L3 cache accesses",


