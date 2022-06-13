Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EBB5491D4
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383492AbiFMO0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383747AbiFMOX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:23:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D638A2E9C2;
        Mon, 13 Jun 2022 04:45:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FA4FB80EA7;
        Mon, 13 Jun 2022 11:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C9FC34114;
        Mon, 13 Jun 2022 11:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120706;
        bh=06+9PXrdkDuJuImsTy2TiDnZh4MD2/rw/WW0aM0IJN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6Gj3xxM5cYHGkaDrDmBnu7b0acnV+4GU62LLo/dPgxQBBInPtZt4nEbUmN6nCw3H
         q6ouSwqP71ZoqIBgsfIl+weraG2ttAs3/v8SiWIz+cRW/eCTmKQryAMV8Nv2ZZXBRL
         4Rd7ux/q1VDfqK1WmT2DsyKB1/R8cDmVE9yxo/nM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 128/298] perf evsel: Fixes topdown events in a weak group for the hybrid platform
Date:   Mon, 13 Jun 2022 12:10:22 +0200
Message-Id: <20220613094928.825030593@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 39d5f412da84784bcc7f39ed49e55376be526fc7 ]

The patch ("perf evlist: Keep topdown counters in weak group") fixes the
perf metrics topdown event issue when the topdown events are in a weak
group on a non-hybrid platform. However, it doesn't work for the hybrid
platform.

  $./perf stat -e '{cpu_core/slots/,cpu_core/topdown-bad-spec/,
  cpu_core/topdown-be-bound/,cpu_core/topdown-fe-bound/,
  cpu_core/topdown-retiring/,cpu_core/branch-instructions/,
  cpu_core/branch-misses/,cpu_core/bus-cycles/,cpu_core/cache-misses/,
  cpu_core/cache-references/,cpu_core/cpu-cycles/,cpu_core/instructions/,
  cpu_core/mem-loads/,cpu_core/mem-stores/,cpu_core/ref-cycles/,
  cpu_core/cache-misses/,cpu_core/cache-references/}:W' -a sleep 1

  Performance counter stats for 'system wide':

       751,765,068      cpu_core/slots/                        (84.07%)
   <not supported>      cpu_core/topdown-bad-spec/
   <not supported>      cpu_core/topdown-be-bound/
   <not supported>      cpu_core/topdown-fe-bound/
   <not supported>      cpu_core/topdown-retiring/
        12,398,197      cpu_core/branch-instructions/          (84.07%)
         1,054,218      cpu_core/branch-misses/                (84.24%)
       539,764,637      cpu_core/bus-cycles/                   (84.64%)
            14,683      cpu_core/cache-misses/                 (84.87%)
         7,277,809      cpu_core/cache-references/             (77.30%)
       222,299,439      cpu_core/cpu-cycles/                   (77.28%)
        63,661,714      cpu_core/instructions/                 (84.85%)
                 0      cpu_core/mem-loads/                    (77.29%)
        12,271,725      cpu_core/mem-stores/                   (77.30%)
       542,241,102      cpu_core/ref-cycles/                   (84.85%)
             8,854      cpu_core/cache-misses/                 (76.71%)
         7,179,013      cpu_core/cache-references/             (76.31%)

         1.003245250 seconds time elapsed

A hybrid platform has a different PMU name for the core PMUs, while
the current perf hard code the PMU name "cpu".

The evsel->pmu_name can be used to replace the "cpu" to fix the issue.
For a hybrid platform, the pmu_name must be non-NULL. Because there are
at least two core PMUs. The PMU has to be specified.
For a non-hybrid platform, the pmu_name may be NULL. Because there is
only one core PMU, "cpu". For a NULL pmu_name, we can safely assume that
it is a "cpu" PMU.

In case other PMUs also define the "slots" event, checking the PMU type
as well.

With the patch,

  $ perf stat -e '{cpu_core/slots/,cpu_core/topdown-bad-spec/,
  cpu_core/topdown-be-bound/,cpu_core/topdown-fe-bound/,
  cpu_core/topdown-retiring/,cpu_core/branch-instructions/,
  cpu_core/branch-misses/,cpu_core/bus-cycles/,cpu_core/cache-misses/,
  cpu_core/cache-references/,cpu_core/cpu-cycles/,cpu_core/instructions/,
  cpu_core/mem-loads/,cpu_core/mem-stores/,cpu_core/ref-cycles/,
  cpu_core/cache-misses/,cpu_core/cache-references/}:W' -a sleep 1

  Performance counter stats for 'system wide':

     766,620,266   cpu_core/slots/                                        (84.06%)
      73,172,129   cpu_core/topdown-bad-spec/ #    9.5% bad speculation   (84.06%)
     193,443,341   cpu_core/topdown-be-bound/ #    25.0% backend bound    (84.06%)
     403,940,929   cpu_core/topdown-fe-bound/ #    52.3% frontend bound   (84.06%)
     102,070,237   cpu_core/topdown-retiring/ #    13.2% retiring         (84.06%)
      12,364,429   cpu_core/branch-instructions/                          (84.03%)
       1,080,124   cpu_core/branch-misses/                                (84.24%)
     564,120,383   cpu_core/bus-cycles/                                   (84.65%)
          36,979   cpu_core/cache-misses/                                 (84.86%)
       7,298,094   cpu_core/cache-references/                             (77.30%)
     227,174,372   cpu_core/cpu-cycles/                                   (77.31%)
      63,886,523   cpu_core/instructions/                                 (84.87%)
               0   cpu_core/mem-loads/                                    (77.31%)
      12,208,782   cpu_core/mem-stores/                                   (77.31%)
     566,409,738   cpu_core/ref-cycles/                                   (84.87%)
          23,118   cpu_core/cache-misses/                                 (76.71%)
       7,212,602   cpu_core/cache-references/                             (76.29%)

       1.003228667 seconds time elapsed

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Link: https://lore.kernel.org/r/20220518143900.1493980-2-kan.liang@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/util/evsel.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/tools/perf/arch/x86/util/evsel.c b/tools/perf/arch/x86/util/evsel.c
index 0c9e56ab07b5..ff4561b7b600 100644
--- a/tools/perf/arch/x86/util/evsel.c
+++ b/tools/perf/arch/x86/util/evsel.c
@@ -31,10 +31,29 @@ void arch_evsel__fixup_new_cycles(struct perf_event_attr *attr)
 	free(env.cpuid);
 }
 
+/* Check whether the evsel's PMU supports the perf metrics */
+static bool evsel__sys_has_perf_metrics(const struct evsel *evsel)
+{
+	const char *pmu_name = evsel->pmu_name ? evsel->pmu_name : "cpu";
+
+	/*
+	 * The PERF_TYPE_RAW type is the core PMU type, e.g., "cpu" PMU
+	 * on a non-hybrid machine, "cpu_core" PMU on a hybrid machine.
+	 * The slots event is only available for the core PMU, which
+	 * supports the perf metrics feature.
+	 * Checking both the PERF_TYPE_RAW type and the slots event
+	 * should be good enough to detect the perf metrics feature.
+	 */
+	if ((evsel->core.attr.type == PERF_TYPE_RAW) &&
+	    pmu_have_event(pmu_name, "slots"))
+		return true;
+
+	return false;
+}
+
 bool arch_evsel__must_be_in_group(const struct evsel *evsel)
 {
-	if ((evsel->pmu_name && strcmp(evsel->pmu_name, "cpu")) ||
-	    !pmu_have_event("cpu", "slots"))
+	if (!evsel__sys_has_perf_metrics(evsel))
 		return false;
 
 	return evsel->name &&
-- 
2.35.1



