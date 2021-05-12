Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473CC37CEDE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbhELRHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244603AbhELQuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:50:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B84861C76;
        Wed, 12 May 2021 16:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836225;
        bh=lya4Eis2gaA2HHKEgyY1VtTilRUWD6mcSu/7R90kPQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OcsKXL/eTA8BzJFvrydrHpaINryg9e7/tKB1BOMlWZAD7a72VB+FN0zXFAOzLMwxY
         MZ5cPZmt9SVNMZXI7q7X8c4LL+U8A1tMjrQ+/WRnC5aWa1T6uMKJgN4dl0UT9+K3kS
         PvWJQhaT4pVu8BucsP0+SiWuYWJLkpuqRRZ4Bny4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steve MacLean <Steve.MacLean@Microsoft.com>,
        Yonatan Goldschmidt <yonatan.goldschmidt@granulate.io>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 661/677] perf jit: Let convert_timestamp() to be backwards-compatible
Date:   Wed, 12 May 2021 16:51:47 +0200
Message-Id: <20210512144859.323487981@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit aa616f5a8a2d22a179d5502ebd85045af66fa656 ]

Commit d110162cafc80dad ("perf tsc: Support cap_user_time_short for
event TIME_CONV") supports the extended parameters for event TIME_CONV,
but it broke the backwards compatibility, so any perf data file with old
event format fails to convert timestamp.

This patch introduces a helper event_contains() to check if an event
contains a specific member or not.  For the backwards-compatibility, if
the event size confirms the extended parameters are supported in the
event TIME_CONV, then copies these parameters.

Committer notes:

To make this compiler backwards compatible add this patch:

  -       struct perf_tsc_conversion tc = { 0 };
  +       struct perf_tsc_conversion tc = { .time_shift = 0, };

Fixes: d110162cafc8 ("perf tsc: Support cap_user_time_short for event TIME_CONV")
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steve MacLean <Steve.MacLean@Microsoft.com>
Cc: Yonatan Goldschmidt <yonatan.goldschmidt@granulate.io>
Link: https://lore.kernel.org/r/20210428120915.7123-3-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/include/perf/event.h |  2 ++
 tools/perf/util/jitdump.c           | 30 +++++++++++++++++++----------
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/tools/lib/perf/include/perf/event.h b/tools/lib/perf/include/perf/event.h
index 48583e441d9b..4d0c02ba3f7d 100644
--- a/tools/lib/perf/include/perf/event.h
+++ b/tools/lib/perf/include/perf/event.h
@@ -8,6 +8,8 @@
 #include <linux/bpf.h>
 #include <sys/types.h> /* pid_t */
 
+#define event_contains(obj, mem) ((obj).header.size > offsetof(typeof(obj), mem))
+
 struct perf_record_mmap {
 	struct perf_event_header header;
 	__u32			 pid, tid;
diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 9760d8e7b386..917a9c707371 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -396,21 +396,31 @@ static pid_t jr_entry_tid(struct jit_buf_desc *jd, union jr_entry *jr)
 
 static uint64_t convert_timestamp(struct jit_buf_desc *jd, uint64_t timestamp)
 {
-	struct perf_tsc_conversion tc;
+	struct perf_tsc_conversion tc = { .time_shift = 0, };
+	struct perf_record_time_conv *time_conv = &jd->session->time_conv;
 
 	if (!jd->use_arch_timestamp)
 		return timestamp;
 
-	tc.time_shift	       = jd->session->time_conv.time_shift;
-	tc.time_mult	       = jd->session->time_conv.time_mult;
-	tc.time_zero	       = jd->session->time_conv.time_zero;
-	tc.time_cycles	       = jd->session->time_conv.time_cycles;
-	tc.time_mask	       = jd->session->time_conv.time_mask;
-	tc.cap_user_time_zero  = jd->session->time_conv.cap_user_time_zero;
-	tc.cap_user_time_short = jd->session->time_conv.cap_user_time_short;
+	tc.time_shift = time_conv->time_shift;
+	tc.time_mult  = time_conv->time_mult;
+	tc.time_zero  = time_conv->time_zero;
 
-	if (!tc.cap_user_time_zero)
-		return 0;
+	/*
+	 * The event TIME_CONV was extended for the fields from "time_cycles"
+	 * when supported cap_user_time_short, for backward compatibility,
+	 * checks the event size and assigns these extended fields if these
+	 * fields are contained in the event.
+	 */
+	if (event_contains(*time_conv, time_cycles)) {
+		tc.time_cycles	       = time_conv->time_cycles;
+		tc.time_mask	       = time_conv->time_mask;
+		tc.cap_user_time_zero  = time_conv->cap_user_time_zero;
+		tc.cap_user_time_short = time_conv->cap_user_time_short;
+
+		if (!tc.cap_user_time_zero)
+			return 0;
+	}
 
 	return tsc_to_perf_time(timestamp, &tc);
 }
-- 
2.30.2



