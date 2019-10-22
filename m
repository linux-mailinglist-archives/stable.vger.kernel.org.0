Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0CCDFE65
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 09:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387692AbfJVHjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 03:39:48 -0400
Received: from mga12.intel.com ([192.55.52.136]:16528 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387623AbfJVHjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Oct 2019 03:39:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 00:39:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,326,1566889200"; 
   d="scan'208";a="227608210"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 22 Oct 2019 00:39:45 -0700
From:   Alexander Shishkin <alexander.shishkin@linux.intel.com>
To:     Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] perf: Fix AUX output stopping
Date:   Tue, 22 Oct 2019 10:39:40 +0300
Message-Id: <20191022073940.61814-1-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit

  8a58ddae2379 ("perf/core: Fix exclusive events' grouping")

allows CAP_EXCLUSIVE events to be grouped with other events. Since all
of those also happen to be AUX events (which is not the case the other
way around, because arch/s390), this changes the rules for stopping the
output: the AUX event may not be on its PMU's context any more, if it's
grouped with a HW event, in which case it will be on that HW event's
context instead. If that's the case, munmap() of the AUX buffer can't
find and stop the AUX event, potentially leaving the last reference with
the atomic context, which will then end up freeing the AUX buffer. This
will then trip warnings:

> WARNING: CPU: 2 PID: 318 at kernel/events/core.c:5615 perf_mmap_close+0x839/0x850
> Modules linked in:
> CPU: 2 PID: 318 Comm: exclusive-group Tainted: G W 5.4.0-rc3-00070-g39b656ee9f2c #846
> RIP: 0010:perf_mmap_close+0x839/0x850

Fix this by using the context's PMU context when looking for events
to stop, instead of the event's PMU context.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: stable@vger.kernel.org
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5bbaabdad068..77793ef0d8bc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6965,7 +6965,7 @@ static void __perf_event_output_stop(struct perf_event *event, void *data)
 static int __perf_pmu_output_stop(void *info)
 {
 	struct perf_event *event = info;
-	struct pmu *pmu = event->pmu;
+	struct pmu *pmu = event->ctx->pmu;
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
 	struct remote_output ro = {
 		.rb	= event->rb,
-- 
2.23.0

