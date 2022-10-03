Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2333C5F2A18
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiJCHa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbiJCH3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:29:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53308E1B;
        Mon,  3 Oct 2022 00:20:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88D63B80E6E;
        Mon,  3 Oct 2022 07:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889F3C433D6;
        Mon,  3 Oct 2022 07:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781599;
        bh=b7bbnqElYgS804lPafWtrg/sJe6H9zS9nTluDJR+eZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QLxpQHSlu3SebZJYuSWT/E77SS1m81Ic+bti2JdKP4e3Rwa8/yjBlZJT3jLCl/BuG
         CpYABwsO3jRfrsYmXLAlsyc0MfyPkE45Kzl6IMkCblo9p7wd2d3KZhwvCgIXfVjA0M
         gHsAv2vykBv1BAHqaXGdcTfi9GSCKWKaIoCwORP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Li <liwei391@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Rui Xiang <rui.xiang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 78/83] perf tools: Enhance the matching of sub-commands abbreviations
Date:   Mon,  3 Oct 2022 09:11:43 +0200
Message-Id: <20221003070723.950614802@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Li <liwei391@huawei.com>

[ Upstream commit ae0f4eb34fc3014f7eba78fab90a0e98e441a4cd ]

We support short command 'rec*' for 'record' and 'rep*' for 'report' in
lots of sub-commands, but the matching is not quite strict currnetly.

It may be puzzling sometime, like we mis-type a 'recport' to report but
it will perform 'record' in fact without any message.

To fix this, add a check to ensure that the short cmd is valid prefix
of the real command.

Committer testing:

  [root@quaco ~]# perf c2c re sleep 1

   Usage: perf c2c {record|report}

      -v, --verbose         be more verbose (show counter open errors, etc)

  # perf c2c rec sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.038 MB perf.data (16 samples) ]
  # perf c2c recport sleep 1

   Usage: perf c2c {record|report}

      -v, --verbose         be more verbose (show counter open errors, etc)

  # perf c2c record sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.038 MB perf.data (15 samples) ]
  # perf c2c records sleep 1

   Usage: perf c2c {record|report}

      -v, --verbose         be more verbose (show counter open errors, etc)

  #

Signed-off-by: Wei Li <liwei391@huawei.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Rui Xiang <rui.xiang@huawei.com>
Link: http://lore.kernel.org/lkml/20220325092032.2956161-1-liwei391@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 71c86cda750b ("perf parse-events: Remove "not supported" hybrid cache events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-c2c.c       | 5 +++--
 tools/perf/builtin-kmem.c      | 2 +-
 tools/perf/builtin-kvm.c       | 9 +++++----
 tools/perf/builtin-lock.c      | 5 +++--
 tools/perf/builtin-mem.c       | 5 +++--
 tools/perf/builtin-sched.c     | 4 ++--
 tools/perf/builtin-script.c    | 4 ++--
 tools/perf/builtin-stat.c      | 4 ++--
 tools/perf/builtin-timechart.c | 3 ++-
 9 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 6d901ba6678f..ba798c64fed9 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -44,6 +44,7 @@
 #include "../perf.h"
 #include "pmu.h"
 #include "pmu-hybrid.h"
+#include "string2.h"
 
 struct c2c_hists {
 	struct hists		hists;
@@ -3026,9 +3027,9 @@ int cmd_c2c(int argc, const char **argv)
 	if (!argc)
 		usage_with_options(c2c_usage, c2c_options);
 
-	if (!strncmp(argv[0], "rec", 3)) {
+	if (strlen(argv[0]) > 2 && strstarts("record", argv[0])) {
 		return perf_c2c__record(argc, argv);
-	} else if (!strncmp(argv[0], "rep", 3)) {
+	} else if (strlen(argv[0]) > 2 && strstarts("report", argv[0])) {
 		return perf_c2c__report(argc, argv);
 	} else {
 		usage_with_options(c2c_usage, c2c_options);
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index da03a341c63c..8595e6a92d39 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -1946,7 +1946,7 @@ int cmd_kmem(int argc, const char **argv)
 			kmem_page = 1;
 	}
 
-	if (!strncmp(argv[0], "rec", 3)) {
+	if (strlen(argv[0]) > 2 && strstarts("record", argv[0])) {
 		symbol__init(NULL);
 		return __cmd_record(argc, argv);
 	}
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index aa1b127ffb5b..38735c405573 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -24,6 +24,7 @@
 #include "util/ordered-events.h"
 #include "util/kvm-stat.h"
 #include "ui/ui.h"
+#include "util/string2.h"
 
 #include <sys/prctl.h>
 #ifdef HAVE_TIMERFD_SUPPORT
@@ -1500,10 +1501,10 @@ static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 		goto perf_stat;
 	}
 
-	if (!strncmp(argv[1], "rec", 3))
+	if (strlen(argv[1]) > 2 && strstarts("record", argv[1]))
 		return kvm_events_record(&kvm, argc - 1, argv + 1);
 
-	if (!strncmp(argv[1], "rep", 3))
+	if (strlen(argv[1]) > 2 && strstarts("report", argv[1]))
 		return kvm_events_report(&kvm, argc - 1 , argv + 1);
 
 #ifdef HAVE_TIMERFD_SUPPORT
@@ -1631,9 +1632,9 @@ int cmd_kvm(int argc, const char **argv)
 		}
 	}
 
-	if (!strncmp(argv[0], "rec", 3))
+	if (strlen(argv[0]) > 2 && strstarts("record", argv[0]))
 		return __cmd_record(file_name, argc, argv);
-	else if (!strncmp(argv[0], "rep", 3))
+	else if (strlen(argv[0]) > 2 && strstarts("report", argv[0]))
 		return __cmd_report(file_name, argc, argv);
 	else if (!strncmp(argv[0], "diff", 4))
 		return cmd_diff(argc, argv);
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index d70131b7b1b1..24d402e84022 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -18,6 +18,7 @@
 #include "util/session.h"
 #include "util/tool.h"
 #include "util/data.h"
+#include "util/string2.h"
 
 #include <sys/types.h>
 #include <sys/prctl.h>
@@ -997,9 +998,9 @@ int cmd_lock(int argc, const char **argv)
 	if (!argc)
 		usage_with_options(lock_usage, lock_options);
 
-	if (!strncmp(argv[0], "rec", 3)) {
+	if (strlen(argv[0]) > 2 && strstarts("record", argv[0])) {
 		return __cmd_record(argc, argv);
-	} else if (!strncmp(argv[0], "report", 6)) {
+	} else if (strlen(argv[0]) > 2 && strstarts("report", argv[0])) {
 		trace_handler = &report_lock_ops;
 		if (argc) {
 			argc = parse_options(argc, argv,
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index fcf65a59bea2..9e435fd23503 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -20,6 +20,7 @@
 #include "util/symbol.h"
 #include "util/pmu.h"
 #include "util/pmu-hybrid.h"
+#include "util/string2.h"
 #include <linux/err.h>
 
 #define MEM_OPERATION_LOAD	0x1
@@ -496,9 +497,9 @@ int cmd_mem(int argc, const char **argv)
 			mem.input_name = "perf.data";
 	}
 
-	if (!strncmp(argv[0], "rec", 3))
+	if (strlen(argv[0]) > 2 && strstarts("record", argv[0]))
 		return __cmd_record(argc, argv, &mem);
-	else if (!strncmp(argv[0], "rep", 3))
+	else if (strlen(argv[0]) > 2 && strstarts("report", argv[0]))
 		return report_events(argc, argv, &mem);
 	else
 		usage_with_options(mem_usage, mem_options);
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 4527f632ebe4..2cf806d66b1c 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3554,7 +3554,7 @@ int cmd_sched(int argc, const char **argv)
 	if (!strcmp(argv[0], "script"))
 		return cmd_script(argc, argv);
 
-	if (!strncmp(argv[0], "rec", 3)) {
+	if (strlen(argv[0]) > 2 && strstarts("record", argv[0])) {
 		return __cmd_record(argc, argv);
 	} else if (!strncmp(argv[0], "lat", 3)) {
 		sched.tp_handler = &lat_ops;
@@ -3574,7 +3574,7 @@ int cmd_sched(int argc, const char **argv)
 		sched.tp_handler = &map_ops;
 		setup_sorting(&sched, latency_options, latency_usage);
 		return perf_sched__map(&sched);
-	} else if (!strncmp(argv[0], "rep", 3)) {
+	} else if (strlen(argv[0]) > 2 && strstarts("replay", argv[0])) {
 		sched.tp_handler = &replay_ops;
 		if (argc) {
 			argc = parse_options(argc, argv, replay_options, replay_usage, 0);
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index f346275c9d21..4baaf5652a42 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -3842,13 +3842,13 @@ int cmd_script(int argc, const char **argv)
 	if (symbol__validate_sym_arguments())
 		return -1;
 
-	if (argc > 1 && !strncmp(argv[0], "rec", strlen("rec"))) {
+	if (argc > 1 && strlen(argv[0]) > 2 && strstarts("record", argv[0])) {
 		rec_script_path = get_script_path(argv[1], RECORD_SUFFIX);
 		if (!rec_script_path)
 			return cmd_record(argc, argv);
 	}
 
-	if (argc > 1 && !strncmp(argv[0], "rep", strlen("rep"))) {
+	if (argc > 1 && strlen(argv[0]) > 2 && strstarts("report", argv[0])) {
 		rep_script_path = get_script_path(argv[1], REPORT_SUFFIX);
 		if (!rep_script_path) {
 			fprintf(stderr,
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index abf88a1ad455..002eecc59536 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2255,11 +2255,11 @@ int cmd_stat(int argc, const char **argv)
 	} else
 		stat_config.csv_sep = DEFAULT_SEPARATOR;
 
-	if (argc && !strncmp(argv[0], "rec", 3)) {
+	if (argc && strlen(argv[0]) > 2 && strstarts("record", argv[0])) {
 		argc = __cmd_record(argc, argv);
 		if (argc < 0)
 			return -1;
-	} else if (argc && !strncmp(argv[0], "rep", 3))
+	} else if (argc && strlen(argv[0]) > 2 && strstarts("report", argv[0]))
 		return __cmd_report(argc, argv);
 
 	interval = stat_config.interval;
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 43bf4d67edb0..afce731cec16 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -35,6 +35,7 @@
 #include "util/tool.h"
 #include "util/data.h"
 #include "util/debug.h"
+#include "util/string2.h"
 #include <linux/err.h>
 
 #ifdef LACKS_OPEN_MEMSTREAM_PROTOTYPE
@@ -1983,7 +1984,7 @@ int cmd_timechart(int argc, const char **argv)
 		return -1;
 	}
 
-	if (argc && !strncmp(argv[0], "rec", 3)) {
+	if (argc && strlen(argv[0]) > 2 && strstarts("record", argv[0])) {
 		argc = parse_options(argc, argv, timechart_record_options,
 				     timechart_record_usage,
 				     PARSE_OPT_STOP_AT_NON_OPTION);
-- 
2.35.1



