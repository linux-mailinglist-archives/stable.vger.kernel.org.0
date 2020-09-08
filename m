Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1229A261C41
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731695AbgIHTQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730586AbgIHQDh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:03:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80E5D23E51;
        Tue,  8 Sep 2020 15:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579471;
        bh=GEs1BKnoPh7fQfVizAtRTSwMUcpvmSDLQbdXLXIp+f0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zCSDJ+5eqTDZn6aqqpuLaEHcI1N+E60Zsuba070aT0whNzGPMlMHyC/jgW4Kg+YHc
         xH9tFbBHPcBrBS58btIRYykw7EFDljED/0bMcA5Bd6ACvSWRR8zcxJAGQM+vF6Uip4
         d7Zph5WadaqFZDqc1XLr+Xya5jVhAsuaPGh5xPNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Grant <al.grant@arm.com>,
        Andrea Brunato <andrea.brunato@arm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, Leo Yan <leo.yan@linaro.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 092/186] perf cs-etm: Fix corrupt data after perf inject from
Date:   Tue,  8 Sep 2020 17:23:54 +0200
Message-Id: <20200908152246.099614619@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Grant <al.grant@arm.com>

[ Upstream commit f5f8e7e55fbdb4fdddec73518e23c48083108fbb ]

Commit 42bbabed09ce6208 ("perf tools: Add hw_idx in struct branch_stack")
changed the format of branch stacks in perf samples. When samples use
this new format, a flag must be set in the corresponding event.

Synthesized branch stacks generated from CoreSight ETM trace were using
the new format, but not setting the event attribute, leading to
consumers seeing corrupt data. This patch fixes the issue by setting the
event attribute to indicate use of the new format.

Fixes: 42bbabed09ce6208 ("perf tools: Add hw_idx in struct branch_stack")
Signed-off-by: Al Grant <al.grant@arm.com>
Reviewed-by: Andrea Brunato <andrea.brunato@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Link: http://lore.kernel.org/lkml/20200819084751.17686-1-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index c283223fb31f2..a2a369e2fbb67 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -1344,8 +1344,15 @@ static int cs_etm__synth_events(struct cs_etm_auxtrace *etm,
 		attr.sample_type &= ~(u64)PERF_SAMPLE_ADDR;
 	}
 
-	if (etm->synth_opts.last_branch)
+	if (etm->synth_opts.last_branch) {
 		attr.sample_type |= PERF_SAMPLE_BRANCH_STACK;
+		/*
+		 * We don't use the hardware index, but the sample generation
+		 * code uses the new format branch_stack with this field,
+		 * so the event attributes must indicate that it's present.
+		 */
+		attr.branch_sample_type |= PERF_SAMPLE_BRANCH_HW_INDEX;
+	}
 
 	if (etm->synth_opts.instructions) {
 		attr.config = PERF_COUNT_HW_INSTRUCTIONS;
-- 
2.25.1



