Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E99D166C88
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 02:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgBUBxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 20:53:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:57260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729629AbgBUBxe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 20:53:34 -0500
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03A9D208E4;
        Fri, 21 Feb 2020 01:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582250013;
        bh=Jcesa/3mjAuRfrWhL3C7FVYdEiKEQcqA5XsgOnrv+PA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+iFV9tKFunDDZU0xBglPs+lpdU60rLQzAahtRhk/LQM+03cS0r7wMEDbOjLMBrtk
         a3H+obmaGSjbzVCLgr8idoUL2BrX3j0m5T1+Vrz62gVyeV0mFBf08TxADtTUZ2jj6A
         5KIeRyAi5q5he+XMCMVKTnqRnb7MRnsipJRO0gsc=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Wei Li <liwei391@huawei.com>, Jiri Olsa <jolsa@redhat.com>,
        Tan Xiaojun <tanxiaojun@huawei.com>, stable@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/8] perf intel-bts: Fix endless record after being terminated
Date:   Thu, 20 Feb 2020 22:53:06 -0300
Message-Id: <20200221015310.16914-5-acme@kernel.org>
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

If the intel_bts event is disabled, we don't enable it again here.

Note: This patch is NOT tested since i don't have such a machine with
intel_bts feature, but the code seems buggy same as arm-spe and
intel-pt.

Signed-off-by: Wei Li <liwei391@huawei.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Tan Xiaojun <tanxiaojun@huawei.com>
Cc: stable@vger.kernel.org # 5.4+
Link: http://lore.kernel.org/lkml/20200214132654.20395-3-adrian.hunter@intel.com
[ahunter: removed redundant 'else' after 'return']
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/x86/util/intel-bts.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/arch/x86/util/intel-bts.c b/tools/perf/arch/x86/util/intel-bts.c
index 27d9e214d068..39e363151ad7 100644
--- a/tools/perf/arch/x86/util/intel-bts.c
+++ b/tools/perf/arch/x86/util/intel-bts.c
@@ -420,9 +420,12 @@ static int intel_bts_read_finish(struct auxtrace_record *itr, int idx)
 	struct evsel *evsel;
 
 	evlist__for_each_entry(btsr->evlist, evsel) {
-		if (evsel->core.attr.type == btsr->intel_bts_pmu->type)
+		if (evsel->core.attr.type == btsr->intel_bts_pmu->type) {
+			if (evsel->disabled)
+				return 0;
 			return perf_evlist__enable_event_idx(btsr->evlist,
 							     evsel, idx);
+		}
 	}
 	return -EINVAL;
 }
-- 
2.21.1

