Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F81660FEA5
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbiJ0RHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237008AbiJ0RHG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:07:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07D119C064
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:07:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C874B82718
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49AFC433C1;
        Thu, 27 Oct 2022 17:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890422;
        bh=hqqrPyhcv5rwQUkHrvjHt1gA18NlL+WN0ilWmc3/K+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJHk4zqMkIpRtRYc0m4CuJSBL6v1UpwI88t1LYqs2MWDGlt1gU2jJgWfHVidpF335
         +F7YMFliMRXzeTeRHNXMp5xb/FND1IIRWeD/zcDoNurfm99UL++6L+AUlKFa+WT33M
         47QK+FH3OcPEsGv2ZBRWeeY7llmVNqurXmj3dHYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jin Yao <yao.jin@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 65/79] perf pmu: Validate raw event with sysfs exported format bits
Date:   Thu, 27 Oct 2022 18:56:15 +0200
Message-Id: <20221027165056.511106605@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
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

From: Jin Yao <yao.jin@linux.intel.com>

[ Upstream commit e40647762fb5881360874e08e03e972d58d63c42 ]

A raw PMU event (eventsel+umask) in the form of rNNN is supported
by perf but lacks of checking for the validity of raw encoding.

For example, bit 16 and bit 17 are not valid on KBL but perf doesn't
report warning when encoding with these bits.

Before:

  # ./perf stat -e cpu/r031234/ -a -- sleep 1

   Performance counter stats for 'system wide':

                   0      cpu/r031234/

         1.003798924 seconds time elapsed

It may silently measure the wrong event!

The kernel supported bits have been exported through
/sys/devices/<pmu>/format/. Perf collects the information to
'struct perf_pmu_format' and links it to 'pmu->format' list.

The 'struct perf_pmu_format' has a bitmap which records the
valid bits for this format. For example,

  root@kbl-ppc:/sys/devices/cpu/format# cat umask
  config:8-15

The valid bits (bit8-bit15) are recorded in bitmap of format 'umask'.

We collect total valid bits of all formats, save to a local variable
'masks' and reverse it. Now '~masks' represents total invalid bits.

bits = config & ~masks;

The set bits in 'bits' indicate the invalid bits used in config.
Finally we use bitmap_scnprintf to report the invalid bits.

Some architectures may not export supported bits through sysfs,
so if masks is 0, perf_pmu__warn_invalid_config directly returns.

After:

Single event without name:

  # ./perf stat -e cpu/r031234/ -a -- sleep 1
  WARNING: event 'N/A' not valid (bits 16-17 of config '31234' not supported by kernel)!

   Performance counter stats for 'system wide':

                   0      cpu/r031234/

         1.001597373 seconds time elapsed

Multiple events with names:

  # ./perf stat -e cpu/rf01234,name=aaa/,cpu/r031234,name=bbb/ -a -- sleep 1
  WARNING: event 'aaa' not valid (bits 20,22 of config 'f01234' not supported by kernel)!
  WARNING: event 'bbb' not valid (bits 16-17 of config '31234' not supported by kernel)!

   Performance counter stats for 'system wide':

                   0      aaa
                   0      bbb

         1.001573787 seconds time elapsed

Warnings are reported for invalid bits.

Co-developed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Jin Yao <yao.jin@linux.intel.com>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jin Yao <yao.jin@intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20210310051138.12154-1-yao.jin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: e552b7be12ed ("perf: Skip and warn on unknown format 'configN' attrs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.c |  3 +++
 tools/perf/util/pmu.c          | 33 +++++++++++++++++++++++++++++++++
 tools/perf/util/pmu.h          |  3 +++
 3 files changed, 39 insertions(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 3a0a7930cd10..36969fc8f1fc 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -356,6 +356,9 @@ __add_event(struct list_head *list, int *idx,
 	struct perf_cpu_map *cpus = pmu ? perf_cpu_map__get(pmu->cpus) :
 			       cpu_list ? perf_cpu_map__new(cpu_list) : NULL;
 
+	if (pmu && attr->type == PERF_TYPE_RAW)
+		perf_pmu__warn_invalid_config(pmu, attr->config, name);
+
 	if (init_attr)
 		event_attr_init(attr);
 
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index d41caeb35cf6..349012f7defb 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -1716,3 +1716,36 @@ int perf_pmu__caps_parse(struct perf_pmu *pmu)
 
 	return nr_caps;
 }
+
+void perf_pmu__warn_invalid_config(struct perf_pmu *pmu, __u64 config,
+				   char *name)
+{
+	struct perf_pmu_format *format;
+	__u64 masks = 0, bits;
+	char buf[100];
+	unsigned int i;
+
+	list_for_each_entry(format, &pmu->format, list)	{
+		if (format->value != PERF_PMU_FORMAT_VALUE_CONFIG)
+			continue;
+
+		for_each_set_bit(i, format->bits, PERF_PMU_FORMAT_BITS)
+			masks |= 1ULL << i;
+	}
+
+	/*
+	 * Kernel doesn't export any valid format bits.
+	 */
+	if (masks == 0)
+		return;
+
+	bits = config & ~masks;
+	if (bits == 0)
+		return;
+
+	bitmap_scnprintf((unsigned long *)&bits, sizeof(bits) * 8, buf, sizeof(buf));
+
+	pr_warning("WARNING: event '%s' not valid (bits %s of config "
+		   "'%llx' not supported by kernel)!\n",
+		   name ?: "N/A", buf, config);
+}
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index a64e9c9ce731..d9aa8c958d21 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -120,4 +120,7 @@ int perf_pmu__convert_scale(const char *scale, char **end, double *sval);
 
 int perf_pmu__caps_parse(struct perf_pmu *pmu);
 
+void perf_pmu__warn_invalid_config(struct perf_pmu *pmu, __u64 config,
+				   char *name);
+
 #endif /* __PMU_H */
-- 
2.35.1



