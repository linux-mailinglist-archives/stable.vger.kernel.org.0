Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52DF611944E
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfLJVNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:13:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729432AbfLJVNq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 880B8214AF;
        Tue, 10 Dec 2019 21:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012426;
        bh=m0ZVFx74lL3sNP67KLXPEw059uoX/SbE893gU5EVbEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1763J2gupb5iQBYxYJoFbTSdg82uncBg2pIeio4QyfavLoKlIfy8YQcGUDLmwGaYO
         BKCBDlHd5Z0/5taLC3FuTJ539dr3BrH1TcW/KG9G1N21MxWIhOOOQp9ZDLHlAeqwaY
         pK7BLvtLchjjESGV4cvX4e/2qKn/eEo0NC0bPOQs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 340/350] perf intel-bts: Does not support AUX area sampling
Date:   Tue, 10 Dec 2019 16:07:25 -0500
Message-Id: <20191210210735.9077-301-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 32a1ece4bdbde24734ab16484bad7316f03fc42d ]

Add an error message because Intel BTS does not support AUX area
sampling.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lore.kernel.org/lkml/20191115124225.5247-16-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/util/auxtrace.c  | 2 ++
 tools/perf/arch/x86/util/intel-bts.c | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/tools/perf/arch/x86/util/auxtrace.c b/tools/perf/arch/x86/util/auxtrace.c
index 96f4a2c118937..61042114a5cc8 100644
--- a/tools/perf/arch/x86/util/auxtrace.c
+++ b/tools/perf/arch/x86/util/auxtrace.c
@@ -27,6 +27,8 @@ struct auxtrace_record *auxtrace_record__init_intel(struct evlist *evlist,
 
 	intel_pt_pmu = perf_pmu__find(INTEL_PT_PMU_NAME);
 	intel_bts_pmu = perf_pmu__find(INTEL_BTS_PMU_NAME);
+	if (intel_bts_pmu)
+		intel_bts_pmu->auxtrace = true;
 
 	evlist__for_each_entry(evlist, evsel) {
 		if (intel_pt_pmu && evsel->core.attr.type == intel_pt_pmu->type)
diff --git a/tools/perf/arch/x86/util/intel-bts.c b/tools/perf/arch/x86/util/intel-bts.c
index f7f68a50a5cd5..27d9e214d0680 100644
--- a/tools/perf/arch/x86/util/intel-bts.c
+++ b/tools/perf/arch/x86/util/intel-bts.c
@@ -113,6 +113,11 @@ static int intel_bts_recording_options(struct auxtrace_record *itr,
 	const struct perf_cpu_map *cpus = evlist->core.cpus;
 	bool privileged = perf_event_paranoid_check(-1);
 
+	if (opts->auxtrace_sample_mode) {
+		pr_err("Intel BTS does not support AUX area sampling\n");
+		return -EINVAL;
+	}
+
 	btsr->evlist = evlist;
 	btsr->snapshot_mode = opts->auxtrace_snapshot_mode;
 
-- 
2.20.1

