Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B329A329084
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242972AbhCAUJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:09:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236040AbhCAUAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:00:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E12EF64E87;
        Mon,  1 Mar 2021 17:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621390;
        bh=ZJCkDw/nR+U8xtVTGsf2t3vBg3++R0XPXgYTv4AN+FY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BqwMAYqLj1mqmuRI+3LoFDdtpESTdXpa4zwMcYnqmyWUpDs81uryoB+hJMsHsxLSU
         HOaS5+JdIh9wt7y+w38MaVQG4FlrQfEP2zKeADkwKKUToxvKrS9ZK/L0bT4bVG8Acm
         DWC9kxwB6onbrRclvmZrlNC6J1jxrLOJczjg9Eb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 469/775] perf intel-pt: Fix IPC with CYC threshold
Date:   Mon,  1 Mar 2021 17:10:37 +0100
Message-Id: <20210301161224.717421465@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 6af4b60033e0ce0332fcdf256c965ad41942821a ]

The code assumed every CYC-eligible packet has a CYC packet, which is not
the case when CYC thresholds are used. Fix by checking if a CYC packet is
actually present in that case.

Fixes: 5b1dc0fd1da06 ("perf intel-pt: Add support for samples to contain IPC ratio")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: https://lore.kernel.org/r/20210205175350.23817-4-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../util/intel-pt-decoder/intel-pt-decoder.c  | 27 +++++++++++++++++++
 .../util/intel-pt-decoder/intel-pt-decoder.h  |  1 +
 tools/perf/util/intel-pt.c                    | 13 +++++++++
 3 files changed, 41 insertions(+)

diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
index ef29f6b25e60a..197eb58a39cb7 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -24,6 +24,13 @@
 #include "intel-pt-decoder.h"
 #include "intel-pt-log.h"
 
+#define BITULL(x) (1ULL << (x))
+
+/* IA32_RTIT_CTL MSR bits */
+#define INTEL_PT_CYC_ENABLE		BITULL(1)
+#define INTEL_PT_CYC_THRESHOLD		(BITULL(22) | BITULL(21) | BITULL(20) | BITULL(19))
+#define INTEL_PT_CYC_THRESHOLD_SHIFT	19
+
 #define INTEL_PT_BLK_SIZE 1024
 
 #define BIT63 (((uint64_t)1 << 63))
@@ -167,6 +174,8 @@ struct intel_pt_decoder {
 	uint64_t sample_tot_cyc_cnt;
 	uint64_t base_cyc_cnt;
 	uint64_t cyc_cnt_timestamp;
+	uint64_t ctl;
+	uint64_t cyc_threshold;
 	double tsc_to_cyc;
 	bool continuous_period;
 	bool overflow;
@@ -204,6 +213,14 @@ static uint64_t intel_pt_lower_power_of_2(uint64_t x)
 	return x << i;
 }
 
+static uint64_t intel_pt_cyc_threshold(uint64_t ctl)
+{
+	if (!(ctl & INTEL_PT_CYC_ENABLE))
+		return 0;
+
+	return (ctl & INTEL_PT_CYC_THRESHOLD) >> INTEL_PT_CYC_THRESHOLD_SHIFT;
+}
+
 static void intel_pt_setup_period(struct intel_pt_decoder *decoder)
 {
 	if (decoder->period_type == INTEL_PT_PERIOD_TICKS) {
@@ -245,12 +262,15 @@ struct intel_pt_decoder *intel_pt_decoder_new(struct intel_pt_params *params)
 
 	decoder->flags              = params->flags;
 
+	decoder->ctl                = params->ctl;
 	decoder->period             = params->period;
 	decoder->period_type        = params->period_type;
 
 	decoder->max_non_turbo_ratio    = params->max_non_turbo_ratio;
 	decoder->max_non_turbo_ratio_fp = params->max_non_turbo_ratio;
 
+	decoder->cyc_threshold = intel_pt_cyc_threshold(decoder->ctl);
+
 	intel_pt_setup_period(decoder);
 
 	decoder->mtc_shift = params->mtc_period;
@@ -2017,6 +2037,7 @@ static int intel_pt_hop_trace(struct intel_pt_decoder *decoder, bool *no_tip, in
 
 static int intel_pt_walk_trace(struct intel_pt_decoder *decoder)
 {
+	int last_packet_type = INTEL_PT_PAD;
 	bool no_tip = false;
 	int err;
 
@@ -2025,6 +2046,12 @@ static int intel_pt_walk_trace(struct intel_pt_decoder *decoder)
 		if (err)
 			return err;
 next:
+		if (decoder->cyc_threshold) {
+			if (decoder->sample_cyc && last_packet_type != INTEL_PT_CYC)
+				decoder->sample_cyc = false;
+			last_packet_type = decoder->packet.type;
+		}
+
 		if (decoder->hop) {
 			switch (intel_pt_hop_trace(decoder, &no_tip, &err)) {
 			case HOP_IGNORE:
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.h b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.h
index b52937b03c8c8..48adaa78acfc2 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.h
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.h
@@ -244,6 +244,7 @@ struct intel_pt_params {
 	void *data;
 	bool return_compression;
 	bool branch_enable;
+	uint64_t ctl;
 	uint64_t period;
 	enum intel_pt_period_type period_type;
 	unsigned max_non_turbo_ratio;
diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index d6d93ee030190..2fff6f760457f 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -893,6 +893,18 @@ static bool intel_pt_sampling_mode(struct intel_pt *pt)
 	return false;
 }
 
+static u64 intel_pt_ctl(struct intel_pt *pt)
+{
+	struct evsel *evsel;
+	u64 config;
+
+	evlist__for_each_entry(pt->session->evlist, evsel) {
+		if (intel_pt_get_config(pt, &evsel->core.attr, &config))
+			return config;
+	}
+	return 0;
+}
+
 static u64 intel_pt_ns_to_ticks(const struct intel_pt *pt, u64 ns)
 {
 	u64 quot, rem;
@@ -1026,6 +1038,7 @@ static struct intel_pt_queue *intel_pt_alloc_queue(struct intel_pt *pt,
 	params.data = ptq;
 	params.return_compression = intel_pt_return_compression(pt);
 	params.branch_enable = intel_pt_branch_enable(pt);
+	params.ctl = intel_pt_ctl(pt);
 	params.max_non_turbo_ratio = pt->max_non_turbo_ratio;
 	params.mtc_period = intel_pt_mtc_period(pt);
 	params.tsc_ctc_ratio_n = pt->tsc_ctc_ratio_n;
-- 
2.27.0



