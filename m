Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31BD521EAE
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 21:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbfEQTlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 15:41:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbfEQTlS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 15:41:18 -0400
Received: from quaco.ghostprotocols.net (unknown [190.15.121.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C52A2087B;
        Fri, 17 May 2019 19:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558122077;
        bh=luzdGAA2LJsyKEDWGQK5/vr3WCNPK6fP1yzJtr5oWfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hK+k91IFWvDPKpEtfPs/IvDG/AlRcuUlrfe3NWARTxw5mMGt/g1Ugpw7bEksjENok
         wQzN7CdSO6U6UYsAm1UFvdTFVEEhC5urdT1tYesuex3QNfJ6I0Zwu90Qm0g4hj6HZM
         T/AnNX1DxT36/Cl5Nv3pjFyBmQMQr9300kXVC6Xw=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>, stable@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 67/73] perf intel-pt: Fix instructions sampling rate
Date:   Fri, 17 May 2019 16:36:05 -0300
Message-Id: <20190517193611.4974-68-acme@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190517193611.4974-1-acme@kernel.org>
References: <20190517193611.4974-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The timestamp used to determine if an instruction sample is made, is an
estimate based on the number of instructions since the last known
timestamp. A consequence is that it might go backwards, which results in
extra samples. Change it so that a sample is only made when the
timestamp goes forwards.

Note this does not affect a sampling period of 0 or sampling periods
specified as a count of instructions.

Example:

 Before:

 $ perf script --itrace=i10us
 ls 13812 [003] 2167315.222583:       3270 instructions:u:      7fac71e2e494 __GI___tunables_init+0xf4 (/lib/x86_64-linux-gnu/ld-2.28.so)
 ls 13812 [003] 2167315.222667:      30902 instructions:u:      7fac71e2da0f _dl_cache_libcmp+0x2f (/lib/x86_64-linux-gnu/ld-2.28.so)
 ls 13812 [003] 2167315.222667:         10 instructions:u:      7fac71e2d9ff _dl_cache_libcmp+0x1f (/lib/x86_64-linux-gnu/ld-2.28.so)
 ls 13812 [003] 2167315.222667:          8 instructions:u:      7fac71e2d9ea _dl_cache_libcmp+0xa (/lib/x86_64-linux-gnu/ld-2.28.so)
 ls 13812 [003] 2167315.222667:         14 instructions:u:      7fac71e2d9ea _dl_cache_libcmp+0xa (/lib/x86_64-linux-gnu/ld-2.28.so)
 ls 13812 [003] 2167315.222667:          6 instructions:u:      7fac71e2d9ff _dl_cache_libcmp+0x1f (/lib/x86_64-linux-gnu/ld-2.28.so)
 ls 13812 [003] 2167315.222667:         14 instructions:u:      7fac71e2d9ff _dl_cache_libcmp+0x1f (/lib/x86_64-linux-gnu/ld-2.28.so)
 ls 13812 [003] 2167315.222667:          4 instructions:u:      7fac71e2dab2 _dl_cache_libcmp+0xd2 (/lib/x86_64-linux-gnu/ld-2.28.so)
 ls 13812 [003] 2167315.222728:      16423 instructions:u:      7fac71e2477a _dl_map_object_deps+0x1ba (/lib/x86_64-linux-gnu/ld-2.28.so)
 ls 13812 [003] 2167315.222734:      12731 instructions:u:      7fac71e27938 _dl_name_match_p+0x68 (/lib/x86_64-linux-gnu/ld-2.28.so)
 ...

 After:
 $ perf script --itrace=i10us
 ls 13812 [003] 2167315.222583:       3270 instructions:u:      7fac71e2e494 __GI___tunables_init+0xf4 (/lib/x86_64-linux-gnu/ld-2.28.so)
 ls 13812 [003] 2167315.222667:      30902 instructions:u:      7fac71e2da0f _dl_cache_libcmp+0x2f (/lib/x86_64-linux-gnu/ld-2.28.so)
 ls 13812 [003] 2167315.222728:      16479 instructions:u:      7fac71e2477a _dl_map_object_deps+0x1ba (/lib/x86_64-linux-gnu/ld-2.28.so)
 ...

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Fixes: f4aa081949e7b ("perf tools: Add Intel PT decoder")
Link: http://lkml.kernel.org/r/20190510124143.27054-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
index 872fab163585..26dbf11e071a 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -888,16 +888,20 @@ static uint64_t intel_pt_next_period(struct intel_pt_decoder *decoder)
 	timestamp = decoder->timestamp + decoder->timestamp_insn_cnt;
 	masked_timestamp = timestamp & decoder->period_mask;
 	if (decoder->continuous_period) {
-		if (masked_timestamp != decoder->last_masked_timestamp)
+		if (masked_timestamp > decoder->last_masked_timestamp)
 			return 1;
 	} else {
 		timestamp += 1;
 		masked_timestamp = timestamp & decoder->period_mask;
-		if (masked_timestamp != decoder->last_masked_timestamp) {
+		if (masked_timestamp > decoder->last_masked_timestamp) {
 			decoder->last_masked_timestamp = masked_timestamp;
 			decoder->continuous_period = true;
 		}
 	}
+
+	if (masked_timestamp < decoder->last_masked_timestamp)
+		return decoder->period_ticks;
+
 	return decoder->period_ticks - (timestamp - masked_timestamp);
 }
 
@@ -926,7 +930,10 @@ static void intel_pt_sample_insn(struct intel_pt_decoder *decoder)
 	case INTEL_PT_PERIOD_TICKS:
 		timestamp = decoder->timestamp + decoder->timestamp_insn_cnt;
 		masked_timestamp = timestamp & decoder->period_mask;
-		decoder->last_masked_timestamp = masked_timestamp;
+		if (masked_timestamp > decoder->last_masked_timestamp)
+			decoder->last_masked_timestamp = masked_timestamp;
+		else
+			decoder->last_masked_timestamp += decoder->period_ticks;
 		break;
 	case INTEL_PT_PERIOD_NONE:
 	case INTEL_PT_PERIOD_MTC:
-- 
2.20.1

