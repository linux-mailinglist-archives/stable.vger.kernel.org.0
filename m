Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01075286C4
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731726AbfEWTMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731662AbfEWTMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:12:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6862217D9;
        Thu, 23 May 2019 19:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638759;
        bh=+athbFoOd2Xxcsmu54xtO7qi37LKpNoQwFHL9MONUjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MIy0bs2Tw9z12IQd2knKBtaiF5SFcthbXllkNc5jI7EsskfV2+WCclsfBTYwbUrwB
         aXkkqFnVtRb1qtW3e+DUzpmFvh9zMgnykKAVyE1AiPUoP58aySj2od0TLnqYJwJeNJ
         IUB4bmwC5x3rMvy6rI67IaDYh4gjwCXDdoLDIbYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.14 37/77] perf intel-pt: Fix instructions sampling rate
Date:   Thu, 23 May 2019 21:05:55 +0200
Message-Id: <20190523181725.313797495@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
References: <20190523181719.982121681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 7ba8fa20e26eb3c0c04d747f7fd2223694eac4d5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -888,16 +888,20 @@ static uint64_t intel_pt_next_period(str
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
 
@@ -926,7 +930,10 @@ static void intel_pt_sample_insn(struct
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


