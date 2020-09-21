Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17484272E77
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729902AbgIUQt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729759AbgIUQtU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:49:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3353238A1;
        Mon, 21 Sep 2020 16:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706959;
        bh=XWHNYLKAtL/yqdTyGOFKpnnu2c8j/SXn/xgLricUeBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3jnZNNQ3ycg4MOcIx4mKKkrw5yiaMwLNgK9w3U67KXdU7VyVaV/8IGqnOHXG2nXd
         ub+AawZB4dgZ++OI8Jixx0/potgXbz/Bj1AuB7jaeFy6fkWTwgDMuh58D4Zy4ijz04
         XRPSgpXF/kf//AE0H5nMmDzdqwUgkdakPqAols5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/72] perf test: Free formats for perf pmu parse test
Date:   Mon, 21 Sep 2020 18:31:21 +0200
Message-Id: <20200921163123.871473602@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit d26383dcb2b4b8629fde05270b4e3633be9e3d4b ]

The following leaks were detected by ASAN:

  Indirect leak of 360 byte(s) in 9 object(s) allocated from:
    #0 0x7fecc305180e in calloc (/lib/x86_64-linux-gnu/libasan.so.5+0x10780e)
    #1 0x560578f6dce5 in perf_pmu__new_format util/pmu.c:1333
    #2 0x560578f752fc in perf_pmu_parse util/pmu.y:59
    #3 0x560578f6a8b7 in perf_pmu__format_parse util/pmu.c:73
    #4 0x560578e07045 in test__pmu tests/pmu.c:155
    #5 0x560578de109b in run_test tests/builtin-test.c:410
    #6 0x560578de109b in test_and_print tests/builtin-test.c:440
    #7 0x560578de401a in __cmd_test tests/builtin-test.c:661
    #8 0x560578de401a in cmd_test tests/builtin-test.c:807
    #9 0x560578e49354 in run_builtin /home/namhyung/project/linux/tools/perf/perf.c:312
    #10 0x560578ce71a8 in handle_internal_command /home/namhyung/project/linux/tools/perf/perf.c:364
    #11 0x560578ce71a8 in run_argv /home/namhyung/project/linux/tools/perf/perf.c:408
    #12 0x560578ce71a8 in main /home/namhyung/project/linux/tools/perf/perf.c:538
    #13 0x7fecc2b7acc9 in __libc_start_main ../csu/libc-start.c:308

Fixes: cff7f956ec4a1 ("perf tests: Move pmu tests into separate object")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20200915031819.386559-12-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/pmu.c |  1 +
 tools/perf/util/pmu.c  | 11 +++++++++++
 tools/perf/util/pmu.h  |  1 +
 3 files changed, 13 insertions(+)

diff --git a/tools/perf/tests/pmu.c b/tools/perf/tests/pmu.c
index 74379ff1f7fa0..46cd1db85bd06 100644
--- a/tools/perf/tests/pmu.c
+++ b/tools/perf/tests/pmu.c
@@ -173,6 +173,7 @@ int test__pmu(struct test *test __maybe_unused, int subtest __maybe_unused)
 		ret = 0;
 	} while (0);
 
+	perf_pmu__del_formats(&formats);
 	test_format_dir_put(format);
 	return ret;
 }
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 5608da82ad239..628a6d5a5b384 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -1294,6 +1294,17 @@ void perf_pmu__set_format(unsigned long *bits, long from, long to)
 		set_bit(b, bits);
 }
 
+void perf_pmu__del_formats(struct list_head *formats)
+{
+	struct perf_pmu_format *fmt, *tmp;
+
+	list_for_each_entry_safe(fmt, tmp, formats, list) {
+		list_del(&fmt->list);
+		free(fmt->name);
+		free(fmt);
+	}
+}
+
 static int sub_non_neg(int a, int b)
 {
 	if (b > a)
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index f36ade6df76d1..9570d9b26250f 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -81,6 +81,7 @@ int perf_pmu__new_format(struct list_head *list, char *name,
 			 int config, unsigned long *bits);
 void perf_pmu__set_format(unsigned long *bits, long from, long to);
 int perf_pmu__format_parse(char *dir, struct list_head *head);
+void perf_pmu__del_formats(struct list_head *formats);
 
 struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu);
 
-- 
2.25.1



