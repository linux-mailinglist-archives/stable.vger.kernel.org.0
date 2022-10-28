Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48123611091
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiJ1MGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiJ1MGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:06:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EA8D2CC5
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:06:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE6A862809
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69EAC433D6;
        Fri, 28 Oct 2022 12:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958810;
        bh=D8tmYFUwURTmzNBZUNj9xhqDYKR5TByC+0OBkrbmtd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CGYnIEbXdrCwJ+9MVpIUiLR+nv+GHxx66Jqg0l9STH67asXCR8XoPZwUnLw5bB6US
         njpXL3F4a54FnRsoaSZNrwggBEknwlX31LATtwjYTGI/N7wWp+cc/5RKjS+yAZXYJO
         G5u7hX8Zea/LeFIGpdK8suff0WSSbjN0SSqK170s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
        Rob Herring <robh@kernel.org>, Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        James Clark <james.clark@arm.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 60/73] perf: Skip and warn on unknown format configN attrs
Date:   Fri, 28 Oct 2022 14:03:57 +0200
Message-Id: <20221028120234.990363295@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit e552b7be12ed62357df84392efa525ecb01910fb ]

If the kernel exposes a new perf_event_attr field in a format attr, perf
will return an error stating the specified PMU can't be found. For
example, a format attr with 'config3:0-63' causes an error as config3 is
unknown to perf. This causes a compatibility issue between a newer
kernel with older perf tool.

Before this change with a kernel adding 'config3' I get:

  $ perf record -e arm_spe// -- true
  event syntax error: 'arm_spe//'
                       \___ Cannot find PMU `arm_spe'. Missing kernel support?
  Run 'perf list' for a list of valid events

   Usage: perf record [<options>] [<command>]
      or: perf record [<options>] -- <command> [<options>]

      -e, --event <event>   event selector. use 'perf list' to list
  available events

After this change, I get:

  $ perf record -e arm_spe// -- true
  WARNING: 'arm_spe_0' format 'inv_event_filter' requires 'perf_event_attr::config3' which is not supported by this version of perf!
  [ perf record: Woken up 2 times to write data ]
  [ perf record: Captured and wrote 0.091 MB perf.data ]

To support unknown configN formats, rework the YACC implementation to
pass any config[0-9]+ format to perf_pmu__new_format() to handle with a
warning.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Tested-by: Leo Yan <leo.yan@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220914-arm-perf-tool-spe1-2-v2-v4-1-83c098e6212e@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.c |  3 +++
 tools/perf/util/pmu.c          | 17 +++++++++++++++++
 tools/perf/util/pmu.h          |  2 ++
 tools/perf/util/pmu.l          |  2 --
 tools/perf/util/pmu.y          | 15 ++++-----------
 5 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 36969fc8f1fc..c56a4d9c3be9 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -356,6 +356,9 @@ __add_event(struct list_head *list, int *idx,
 	struct perf_cpu_map *cpus = pmu ? perf_cpu_map__get(pmu->cpus) :
 			       cpu_list ? perf_cpu_map__new(cpu_list) : NULL;
 
+	if (pmu)
+		perf_pmu__warn_invalid_formats(pmu);
+
 	if (pmu && attr->type == PERF_TYPE_RAW)
 		perf_pmu__warn_invalid_config(pmu, attr->config, name);
 
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 349012f7defb..ac45da0302a7 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -862,6 +862,23 @@ static struct perf_pmu *pmu_lookup(const char *name)
 	return pmu;
 }
 
+void perf_pmu__warn_invalid_formats(struct perf_pmu *pmu)
+{
+	struct perf_pmu_format *format;
+
+	/* fake pmu doesn't have format list */
+	if (pmu == &perf_pmu__fake)
+		return;
+
+	list_for_each_entry(format, &pmu->format, list)
+		if (format->value >= PERF_PMU_FORMAT_VALUE_CONFIG_END) {
+			pr_warning("WARNING: '%s' format '%s' requires 'perf_event_attr::config%d'"
+				   "which is not supported by this version of perf!\n",
+				   pmu->name, format->name, format->value);
+			return;
+		}
+}
+
 static struct perf_pmu *pmu_find(const char *name)
 {
 	struct perf_pmu *pmu;
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index d9aa8c958d21..7d208b850769 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -15,6 +15,7 @@ enum {
 	PERF_PMU_FORMAT_VALUE_CONFIG,
 	PERF_PMU_FORMAT_VALUE_CONFIG1,
 	PERF_PMU_FORMAT_VALUE_CONFIG2,
+	PERF_PMU_FORMAT_VALUE_CONFIG_END,
 };
 
 #define PERF_PMU_FORMAT_BITS 64
@@ -122,5 +123,6 @@ int perf_pmu__caps_parse(struct perf_pmu *pmu);
 
 void perf_pmu__warn_invalid_config(struct perf_pmu *pmu, __u64 config,
 				   char *name);
+void perf_pmu__warn_invalid_formats(struct perf_pmu *pmu);
 
 #endif /* __PMU_H */
diff --git a/tools/perf/util/pmu.l b/tools/perf/util/pmu.l
index a15d9fbd7c0e..58b4926cfaca 100644
--- a/tools/perf/util/pmu.l
+++ b/tools/perf/util/pmu.l
@@ -27,8 +27,6 @@ num_dec         [0-9]+
 
 {num_dec}	{ return value(10); }
 config		{ return PP_CONFIG; }
-config1		{ return PP_CONFIG1; }
-config2		{ return PP_CONFIG2; }
 -		{ return '-'; }
 :		{ return ':'; }
 ,		{ return ','; }
diff --git a/tools/perf/util/pmu.y b/tools/perf/util/pmu.y
index bfd7e8509869..283efe059819 100644
--- a/tools/perf/util/pmu.y
+++ b/tools/perf/util/pmu.y
@@ -20,7 +20,7 @@ do { \
 
 %}
 
-%token PP_CONFIG PP_CONFIG1 PP_CONFIG2
+%token PP_CONFIG
 %token PP_VALUE PP_ERROR
 %type <num> PP_VALUE
 %type <bits> bit_term
@@ -47,18 +47,11 @@ PP_CONFIG ':' bits
 				      $3));
 }
 |
-PP_CONFIG1 ':' bits
+PP_CONFIG PP_VALUE ':' bits
 {
 	ABORT_ON(perf_pmu__new_format(format, name,
-				      PERF_PMU_FORMAT_VALUE_CONFIG1,
-				      $3));
-}
-|
-PP_CONFIG2 ':' bits
-{
-	ABORT_ON(perf_pmu__new_format(format, name,
-				      PERF_PMU_FORMAT_VALUE_CONFIG2,
-				      $3));
+				      $2,
+				      $4));
 }
 
 bits:
-- 
2.35.1



