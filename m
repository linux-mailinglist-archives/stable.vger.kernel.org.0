Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3875119CB5
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfLJWc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:32:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:52892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729446AbfLJWcY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:32:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 690C221D7D;
        Tue, 10 Dec 2019 22:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017144;
        bh=oQzplFMP+y5yFU+IvOVhNLOVCl/yAAbUjzn6JjCaoBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZnu80GU7GA4Q2DMpNtHZQJKjMzG6s5bWWVVtPRZVDQSOrzyNCGVxszZVduHqZlJ1
         8bCnURKdjw16Qn1oG4PVEvqHnL5F115CbmWDKP5oPNyqr39M84lcxBd9neuUUEWfdE
         HHrgaDsNkr//BF38qQil58fii8Hdp6jelQcKAwcw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 90/91] perf intel-bts: Does not support AUX area sampling
Date:   Tue, 10 Dec 2019 17:30:34 -0500
Message-Id: <20191210223035.14270-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223035.14270-1-sashal@kernel.org>
References: <20191210223035.14270-1-sashal@kernel.org>
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
index cc1d865e31f1b..429a0b04d7374 100644
--- a/tools/perf/arch/x86/util/auxtrace.c
+++ b/tools/perf/arch/x86/util/auxtrace.c
@@ -35,6 +35,8 @@ struct auxtrace_record *auxtrace_record__init_intel(struct perf_evlist *evlist,
 
 	intel_pt_pmu = perf_pmu__find(INTEL_PT_PMU_NAME);
 	intel_bts_pmu = perf_pmu__find(INTEL_BTS_PMU_NAME);
+	if (intel_bts_pmu)
+		intel_bts_pmu->auxtrace = true;
 
 	if (evlist) {
 		evlist__for_each_entry(evlist, evsel) {
diff --git a/tools/perf/arch/x86/util/intel-bts.c b/tools/perf/arch/x86/util/intel-bts.c
index 5132775a044fd..400bb1a52d04a 100644
--- a/tools/perf/arch/x86/util/intel-bts.c
+++ b/tools/perf/arch/x86/util/intel-bts.c
@@ -121,6 +121,11 @@ static int intel_bts_recording_options(struct auxtrace_record *itr,
 	const struct cpu_map *cpus = evlist->cpus;
 	bool privileged = geteuid() == 0 || perf_event_paranoid() < 0;
 
+	if (opts->auxtrace_sample_mode) {
+		pr_err("Intel BTS does not support AUX area sampling\n");
+		return -EINVAL;
+	}
+
 	btsr->evlist = evlist;
 	btsr->snapshot_mode = opts->auxtrace_snapshot_mode;
 
-- 
2.20.1

