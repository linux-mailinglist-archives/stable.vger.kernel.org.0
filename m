Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDFC3166C8B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 02:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgBUBxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 20:53:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:57384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729629AbgBUBxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 20:53:39 -0500
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7211206E2;
        Fri, 21 Feb 2020 01:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582250019;
        bh=kxnBMkPQlpPktAVe+rlFZ9ldhcYK8N2luly8CBV3iC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zVvhI6PcinajTRSoYMb3YJrVyX/4nT+k57baYRahrW/SSvbY2soMTu6UeUGFH/H6v
         EylSJW8KmPxmc2TRupD1wkQc1Rq+settujf+oKxrOp+8+cIH+QCrHzOwXJ9cblvD+y
         +vS6bK7uylbCU5Y9GD+CBF6ddwPH8+3PDSzah+cY=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Wei Li <liwei391@huawei.com>, Leo Yan <leo.yan@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Tan Xiaojun <tanxiaojun@huawei.com>, stable@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/8] perf cs-etm: Fix endless record after being terminated
Date:   Thu, 20 Feb 2020 22:53:07 -0300
Message-Id: <20200221015310.16914-6-acme@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200221015310.16914-1-acme@kernel.org>
References: <20200221015310.16914-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Li <liwei391@huawei.com>

In __cmd_record(), when receiving SIGINT(ctrl + c), a 'done' flag will
be set and the event list will be disabled by evlist__disable() once.

While in auxtrace_record.read_finish(), the related events will be
enabled again, if they are continuous, the recording seems to be
endless.

If the cs_etm event is disabled, we don't enable it again here.

Note: This patch is NOT tested since i don't have such a machine with
coresight feature, but the code seems buggy same as arm-spe and
intel-pt.

Tester notes:

Thanks for looping, Adrian.  Applied this patch and tested with
CoreSight on juno board, it works well.

Signed-off-by: Wei Li <liwei391@huawei.com>
Reviewed-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Tested-by: Leo Yan <leo.yan@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Tan Xiaojun <tanxiaojun@huawei.com>
Cc: stable@vger.kernel.org # 5.4+
Link: http://lore.kernel.org/lkml/20200214132654.20395-4-adrian.hunter@intel.com
[ahunter: removed redundant 'else' after 'return']
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/arm/util/cs-etm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/arch/arm/util/cs-etm.c b/tools/perf/arch/arm/util/cs-etm.c
index 2898cfdf8fe1..60141c3007a9 100644
--- a/tools/perf/arch/arm/util/cs-etm.c
+++ b/tools/perf/arch/arm/util/cs-etm.c
@@ -865,9 +865,12 @@ static int cs_etm_read_finish(struct auxtrace_record *itr, int idx)
 	struct evsel *evsel;
 
 	evlist__for_each_entry(ptr->evlist, evsel) {
-		if (evsel->core.attr.type == ptr->cs_etm_pmu->type)
+		if (evsel->core.attr.type == ptr->cs_etm_pmu->type) {
+			if (evsel->disabled)
+				return 0;
 			return perf_evlist__enable_event_idx(ptr->evlist,
 							     evsel, idx);
+		}
 	}
 
 	return -EINVAL;
-- 
2.21.1

