Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71919328B55
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240061AbhCASdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:33:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:41520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239810AbhCASZW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:25:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 206A464F4E;
        Mon,  1 Mar 2021 17:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619257;
        bh=5DhXtx9kKo3kRzgEeWebTup1xiSRs5kXg4p1DRulG2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bcbWsWxVYuXIEwWcaorHW/aHpuUtcB1Spv0jtXw+LhC0x46DK5Xun/6rMPJRiOJDY
         1J7YXaoJMsqo2zp+V2Bq347KOUDAmvsTkaZl6sHhd/PGDGe9DGltVd2088XWBsV2aF
         vgAH6JelCrRSxD+rKuJOHdRsPpDH2D6c9+7gq7tA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 388/663] perf test: Fix unaligned access in sample parsing test
Date:   Mon,  1 Mar 2021 17:10:36 +0100
Message-Id: <20210301161201.065358140@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit c5c97cadd7ed13381cb6b4bef5c841a66938d350 ]

The ubsan reported the following error.  It was because sample's raw
data missed u32 padding at the end.  So it broke the alignment of the
array after it.

The raw data contains an u32 size prefix so the data size should have
an u32 padding after 8-byte aligned data.

27: Sample parsing  :util/synthetic-events.c:1539:4:
  runtime error: store to misaligned address 0x62100006b9bc for type
  '__u64' (aka 'unsigned long long'), which requires 8 byte alignment
0x62100006b9bc: note: pointer points here
  00 00 00 00 ff ff ff ff  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff
              ^
    #0 0x561532a9fc96 in perf_event__synthesize_sample util/synthetic-events.c:1539:13
    #1 0x5615327f4a4f in do_test tests/sample-parsing.c:284:8
    #2 0x5615327f3f50 in test__sample_parsing tests/sample-parsing.c:381:9
    #3 0x56153279d3a1 in run_test tests/builtin-test.c:424:9
    #4 0x56153279c836 in test_and_print tests/builtin-test.c:454:9
    #5 0x56153279b7eb in __cmd_test tests/builtin-test.c:675:4
    #6 0x56153279abf0 in cmd_test tests/builtin-test.c:821:9
    #7 0x56153264e796 in run_builtin perf.c:312:11
    #8 0x56153264cf03 in handle_internal_command perf.c:364:8
    #9 0x56153264e47d in run_argv perf.c:408:2
    #10 0x56153264c9a9 in main perf.c:538:3
    #11 0x7f137ab6fbbc in __libc_start_main (/lib64/libc.so.6+0x38bbc)
    #12 0x561532596828 in _start ...

SUMMARY: UndefinedBehaviorSanitizer: misaligned-pointer-use
 util/synthetic-events.c:1539:4 in

Fixes: 045f8cd8542d ("perf tests: Add a sample parsing test")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: https://lore.kernel.org/r/20210214091638.519643-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/sample-parsing.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index a0bdaf390ac8e..33a58976222d3 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -193,7 +193,7 @@ static int do_test(u64 sample_type, u64 sample_regs, u64 read_format)
 		.data = {1, -1ULL, 211, 212, 213},
 	};
 	u64 regs[64];
-	const u64 raw_data[] = {0x123456780a0b0c0dULL, 0x1102030405060708ULL};
+	const u32 raw_data[] = {0x12345678, 0x0a0b0c0d, 0x11020304, 0x05060708, 0 };
 	const u64 data[] = {0x2211443366558877ULL, 0, 0xaabbccddeeff4321ULL};
 	const u64 aux_data[] = {0xa55a, 0, 0xeeddee, 0x0282028202820282};
 	struct perf_sample sample = {
-- 
2.27.0



