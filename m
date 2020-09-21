Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33D8272F0D
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbgIUQqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbgIUQqO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:46:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB1D423788;
        Mon, 21 Sep 2020 16:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706773;
        bh=xdJlPdiCNNsDWzWhtcp05rqdqjw7RGbcMQpvT2jkvo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yf4CLymRckCZGgMZO29Q591okXnE5Jqz5flZfcZmwxXxLuTFG6aEsqgs38zadX7E1
         IZB8br0G0uGPTy6AdUX4ULehqw6EGkTsxy1try6YBYzQd9TQN+4jReOUjazYTx9Qs7
         rRlDhHZdJOUX8cSSVrlaGuWM4zPZFuhoCtwJi+J4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 059/118] perf test: Free aliases for PMU event map aliases test
Date:   Mon, 21 Sep 2020 18:27:51 +0200
Message-Id: <20200921162039.093086284@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 22fe5a25b5d8c4f8008dc4a8738d6d8a5f5ddbe9 ]

The aliases were never released causing the following leaks:

  Indirect leak of 1224 byte(s) in 9 object(s) allocated from:
    #0 0x7feefb830628 in malloc (/lib/x86_64-linux-gnu/libasan.so.5+0x107628)
    #1 0x56332c8f1b62 in __perf_pmu__new_alias util/pmu.c:322
    #2 0x56332c8f401f in pmu_add_cpu_aliases_map util/pmu.c:778
    #3 0x56332c792ce9 in __test__pmu_event_aliases tests/pmu-events.c:295
    #4 0x56332c792ce9 in test_aliases tests/pmu-events.c:367
    #5 0x56332c76a09b in run_test tests/builtin-test.c:410
    #6 0x56332c76a09b in test_and_print tests/builtin-test.c:440
    #7 0x56332c76ce69 in __cmd_test tests/builtin-test.c:695
    #8 0x56332c76ce69 in cmd_test tests/builtin-test.c:807
    #9 0x56332c7d2214 in run_builtin /home/namhyung/project/linux/tools/perf/perf.c:312
    #10 0x56332c6701a8 in handle_internal_command /home/namhyung/project/linux/tools/perf/perf.c:364
    #11 0x56332c6701a8 in run_argv /home/namhyung/project/linux/tools/perf/perf.c:408
    #12 0x56332c6701a8 in main /home/namhyung/project/linux/tools/perf/perf.c:538
    #13 0x7feefb359cc9 in __libc_start_main ../csu/libc-start.c:308

Fixes: 956a78356c24c ("perf test: Test pmu-events aliases")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: John Garry <john.garry@huawei.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20200915031819.386559-11-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/pmu-events.c | 5 +++++
 tools/perf/util/pmu.c         | 2 +-
 tools/perf/util/pmu.h         | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/pmu-events.c b/tools/perf/tests/pmu-events.c
index ab64b4a4e2848..343d36965836a 100644
--- a/tools/perf/tests/pmu-events.c
+++ b/tools/perf/tests/pmu-events.c
@@ -274,6 +274,7 @@ static int __test__pmu_event_aliases(char *pmu_name, int *count)
 	int res = 0;
 	bool use_uncore_table;
 	struct pmu_events_map *map = __test_pmu_get_events_map();
+	struct perf_pmu_alias *a, *tmp;
 
 	if (!map)
 		return -1;
@@ -347,6 +348,10 @@ static int __test__pmu_event_aliases(char *pmu_name, int *count)
 			  pmu_name, alias->name);
 	}
 
+	list_for_each_entry_safe(a, tmp, &aliases, list) {
+		list_del(&a->list);
+		perf_pmu_free_alias(a);
+	}
 	free(pmu);
 	return res;
 }
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 93fe72a9dc0b2..97882e55321fe 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -272,7 +272,7 @@ static void perf_pmu_update_alias(struct perf_pmu_alias *old,
 }
 
 /* Delete an alias entry. */
-static void perf_pmu_free_alias(struct perf_pmu_alias *newalias)
+void perf_pmu_free_alias(struct perf_pmu_alias *newalias)
 {
 	zfree(&newalias->name);
 	zfree(&newalias->desc);
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index f971d9aa4570a..1db31cbd21887 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -111,6 +111,7 @@ void pmu_add_cpu_aliases_map(struct list_head *head, struct perf_pmu *pmu,
 
 struct pmu_events_map *perf_pmu__find_map(struct perf_pmu *pmu);
 bool pmu_uncore_alias_match(const char *pmu_name, const char *name);
+void perf_pmu_free_alias(struct perf_pmu_alias *alias);
 
 int perf_pmu__convert_scale(const char *scale, char **end, double *sval);
 
-- 
2.25.1



