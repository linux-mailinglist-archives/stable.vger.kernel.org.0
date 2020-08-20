Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4483324BEA4
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgHTJc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:32:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbgHTJcF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:32:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 097EB22BEA;
        Thu, 20 Aug 2020 09:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915924;
        bh=F7tmT7M/lQLNNkMo1EXCnbaRGMuqCLijhPq4j2DczAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QbNYk54xDfqlhjwu8nLaP4drIMjBxeZfdG4e0s5YLWV3xsCyBQV5rhwLYpH7EOqc+
         4VRkuvIgNyq2h7ZSDn0AUGtd3HiAe5EBLxgeHhynwAVO060W+ImtZI2DM5+qHvaSgQ
         bX5K3TPscKFQKHYXeaRL86d0ODXiRyZ8Sb0LqQro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jin Yao <yao.jin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>, Jin Yao <yao.jin@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 182/232] perf evsel: Dont set sample_regs_intr/sample_regs_user for dummy event
Date:   Thu, 20 Aug 2020 11:20:33 +0200
Message-Id: <20200820091621.619896502@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jin Yao <yao.jin@linux.intel.com>

[ Upstream commit c4735d990268399da9133b0ad445e488ece009ad ]

Since commit 0a892c1c9472 ("perf record: Add dummy event during system wide synthesis"),
a dummy event is added to capture mmaps.

But if we run perf-record as,

 # perf record -e cycles:p -IXMM0 -a -- sleep 1
 Error:
 dummy:HG: PMU Hardware doesn't support sampling/overflow-interrupts. Try 'perf stat'

The issue is, if we enable the extended regs (-IXMM0), but the
pmu->capabilities is not set with PERF_PMU_CAP_EXTENDED_REGS, the kernel
will return -EOPNOTSUPP error.

See following code:

/* in kernel/events/core.c */
static int perf_try_init_event(struct pmu *pmu, struct perf_event *event)

{
        ....
        if (!(pmu->capabilities & PERF_PMU_CAP_EXTENDED_REGS) &&
            has_extended_regs(event))
                ret = -EOPNOTSUPP;
        ....
}

For software dummy event, the PMU should not be set with
PERF_PMU_CAP_EXTENDED_REGS. But unfortunately now, the dummy
event has possibility to be set with PERF_REG_EXTENDED_MASK bit.

In evsel__config, /* tools/perf/util/evsel.c */

if (opts->sample_intr_regs) {
        attr->sample_regs_intr = opts->sample_intr_regs;
}

If we use -IXMM0, the attr>sample_regs_intr will be set with
PERF_REG_EXTENDED_MASK bit.

It doesn't make sense to set attr->sample_regs_intr for a
software dummy event.

This patch adds dummy event checking before setting
attr->sample_regs_intr and attr->sample_regs_user.

After:
  # ./perf record -e cycles:p -IXMM0 -a -- sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.413 MB perf.data (45 samples) ]

Committer notes:

Adrian said this when providing his Acked-by:

"
This is fine.  It will not break PT.

no_aux_samples is useful for evsels that have been added by the code rather
than requested by the user.  For old kernels PT adds sched_switch tracepoint
to track context switches (before the current context switch event was
added) and having auxiliary sample information unnecessarily uses up space
in the perf buffer.
"

Fixes: 0a892c1c9472 ("perf record: Add dummy event during system wide synthesis")
Signed-off-by: Jin Yao <yao.jin@linux.intel.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jin Yao <yao.jin@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20200720010013.18238-1-yao.jin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ef802f6d40c17..6a79cfdf96cb6 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1014,12 +1014,14 @@ void evsel__config(struct evsel *evsel, struct record_opts *opts,
 	if (callchain && callchain->enabled && !evsel->no_aux_samples)
 		evsel__config_callchain(evsel, opts, callchain);
 
-	if (opts->sample_intr_regs && !evsel->no_aux_samples) {
+	if (opts->sample_intr_regs && !evsel->no_aux_samples &&
+	    !evsel__is_dummy_event(evsel)) {
 		attr->sample_regs_intr = opts->sample_intr_regs;
 		evsel__set_sample_bit(evsel, REGS_INTR);
 	}
 
-	if (opts->sample_user_regs && !evsel->no_aux_samples) {
+	if (opts->sample_user_regs && !evsel->no_aux_samples &&
+	    !evsel__is_dummy_event(evsel)) {
 		attr->sample_regs_user |= opts->sample_user_regs;
 		evsel__set_sample_bit(evsel, REGS_USER);
 	}
-- 
2.25.1



