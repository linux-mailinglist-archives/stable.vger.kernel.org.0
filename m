Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB96D261CA8
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730976AbgIHTXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:23:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731096AbgIHQBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:01:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04DA423EAF;
        Tue,  8 Sep 2020 15:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579473;
        bh=3ahDVtPdEadssd8Vxb18CRDen5htLpWbWq5DrbGDtUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMsLE2Q0RC7Fn506i55HCvjukvjWUwyw5gCRcVc10uoVO7xjWglbWs2wzbbWtoFTx
         EYVbFti24aXsst6HBdaj2R+TwQl5NKsEPwJbsKTJbr+wIl/rfbMmqHaJqCzHCYmrXK
         KOXelm4fjAl8z4HJZz7s69fVZOtjQuM6JyDsYci0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Grant <al.grant@arm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 093/186] perf intel-pt: Fix corrupt data after perf inject from
Date:   Tue,  8 Sep 2020 17:23:55 +0200
Message-Id: <20200908152246.140021403@linuxfoundation.org>
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

[ Upstream commit a347306fbec5dcaf7c276777b11d530eab6a4526 ]

Commit 42bbabed09ce6208 ("perf tools: Add hw_idx in struct branch_stack")
changed the format of branch stacks in perf samples. When samples use
this new format, a flag must be set in the corresponding event.

Synthesized branch stacks generated from Intel PT were using the new
format, but not setting the event attribute, leading to consumers
seeing corrupt data. This patch fixes the issue by setting the event
attribute to indicate use of the new format.

Fixes: 42bbabed09ce6208 ("perf tools: Add hw_idx in struct branch_stack")
Signed-off-by: Al Grant <al.grant@arm.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lore.kernel.org/lkml/20200819084751.17686-2-leo.yan@linaro.org
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/intel-pt.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index cb3c1e569a2db..9357b5f62c273 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -2913,8 +2913,15 @@ static int intel_pt_synth_events(struct intel_pt *pt,
 
 	if (pt->synth_opts.callchain)
 		attr.sample_type |= PERF_SAMPLE_CALLCHAIN;
-	if (pt->synth_opts.last_branch)
+	if (pt->synth_opts.last_branch) {
 		attr.sample_type |= PERF_SAMPLE_BRANCH_STACK;
+		/*
+		 * We don't use the hardware index, but the sample generation
+		 * code uses the new format branch_stack with this field,
+		 * so the event attributes must indicate that it's present.
+		 */
+		attr.branch_sample_type |= PERF_SAMPLE_BRANCH_HW_INDEX;
+	}
 
 	if (pt->synth_opts.instructions) {
 		attr.config = PERF_COUNT_HW_INSTRUCTIONS;
-- 
2.25.1



