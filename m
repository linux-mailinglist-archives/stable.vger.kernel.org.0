Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3333D6176
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhGZPcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237898AbhGZP32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E80CC61078;
        Mon, 26 Jul 2021 16:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315771;
        bh=og1zpUvHwjM+dEAn7FdBfMI8xndLHqto5K1ocfecIdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iiNRRju1eDmR97e8X8AJFeynfXsTjenOGmgGW7XUkv0M4fqgQrBg8oFWsioghcdWo
         tvQNu623/gMrX4lgneGor9sj+paT1TDLw//ntR7yM2B/P9YYJeCsvwZJsYmnU0K3u5
         dIo6r9elxOjXnbC35ZdyjwOQFjv6jbjS05eD9p0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 059/223] perf report: Free generated help strings for sort option
Date:   Mon, 26 Jul 2021 17:37:31 +0200
Message-Id: <20210726153848.191140457@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Mancini <rickyman7@gmail.com>

[ Upstream commit a37338aad8c4d8676173ead14e881d2ec308155c ]

ASan reports the memory leak of the strings allocated by sort_help() when
running perf report.

This patch changes the returned pointer to char* (instead of const
char*), saves it in a temporary variable, and finally deallocates it at
function exit.

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Fixes: 702fb9b415e7c99b ("perf report: Show all sort keys in help output")
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/a38b13f02812a8a6759200b9063c6191337f44d4.1626343282.git.rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-report.c | 33 ++++++++++++++++++++++-----------
 tools/perf/util/sort.c      |  2 +-
 tools/perf/util/sort.h      |  2 +-
 3 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 36f9ccfeb38a..ce420f910ff8 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1167,6 +1167,8 @@ int cmd_report(int argc, const char **argv)
 		.annotation_opts	 = annotation__default_options,
 		.skip_empty		 = true,
 	};
+	char *sort_order_help = sort_help("sort by key(s):");
+	char *field_order_help = sort_help("output field(s): overhead period sample ");
 	const struct option options[] = {
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
@@ -1201,9 +1203,9 @@ int cmd_report(int argc, const char **argv)
 	OPT_BOOLEAN(0, "header-only", &report.header_only,
 		    "Show only data header."),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   sort_help("sort by key(s):")),
+		   sort_order_help),
 	OPT_STRING('F', "fields", &field_order, "key[,keys...]",
-		   sort_help("output field(s): overhead period sample ")),
+		   field_order_help),
 	OPT_BOOLEAN(0, "show-cpu-utilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_BOOLEAN_FLAG(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
@@ -1336,11 +1338,11 @@ int cmd_report(int argc, const char **argv)
 	char sort_tmp[128];
 
 	if (ret < 0)
-		return ret;
+		goto exit;
 
 	ret = perf_config(report__config, &report);
 	if (ret)
-		return ret;
+		goto exit;
 
 	argc = parse_options(argc, argv, options, report_usage, 0);
 	if (argc) {
@@ -1354,8 +1356,10 @@ int cmd_report(int argc, const char **argv)
 		report.symbol_filter_str = argv[0];
 	}
 
-	if (annotate_check_args(&report.annotation_opts) < 0)
-		return -EINVAL;
+	if (annotate_check_args(&report.annotation_opts) < 0) {
+		ret = -EINVAL;
+		goto exit;
+	}
 
 	if (report.mmaps_mode)
 		report.tasks_mode = true;
@@ -1369,12 +1373,14 @@ int cmd_report(int argc, const char **argv)
 	if (symbol_conf.vmlinux_name &&
 	    access(symbol_conf.vmlinux_name, R_OK)) {
 		pr_err("Invalid file: %s\n", symbol_conf.vmlinux_name);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto exit;
 	}
 	if (symbol_conf.kallsyms_name &&
 	    access(symbol_conf.kallsyms_name, R_OK)) {
 		pr_err("Invalid file: %s\n", symbol_conf.kallsyms_name);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto exit;
 	}
 
 	if (report.inverted_callchain)
@@ -1398,12 +1404,14 @@ int cmd_report(int argc, const char **argv)
 
 repeat:
 	session = perf_session__new(&data, false, &report.tool);
-	if (IS_ERR(session))
-		return PTR_ERR(session);
+	if (IS_ERR(session)) {
+		ret = PTR_ERR(session);
+		goto exit;
+	}
 
 	ret = evswitch__init(&report.evswitch, session->evlist, stderr);
 	if (ret)
-		return ret;
+		goto exit;
 
 	if (zstd_init(&(session->zstd_data), 0) < 0)
 		pr_warning("Decompression initialization failed. Reported data may be incomplete.\n");
@@ -1638,5 +1646,8 @@ error:
 
 	zstd_fini(&(session->zstd_data));
 	perf_session__delete(session);
+exit:
+	free(sort_order_help);
+	free(field_order_help);
 	return ret;
 }
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 88ce47f2547e..568a88c001c6 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -3370,7 +3370,7 @@ static void add_hpp_sort_string(struct strbuf *sb, struct hpp_dimension *s, int
 		add_key(sb, s[i].name, llen);
 }
 
-const char *sort_help(const char *prefix)
+char *sort_help(const char *prefix)
 {
 	struct strbuf sb;
 	char *s;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 87a092645aa7..b67c469aba79 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -302,7 +302,7 @@ void reset_output_field(void);
 void sort__setup_elide(FILE *fp);
 void perf_hpp__set_elide(int idx, bool elide);
 
-const char *sort_help(const char *prefix);
+char *sort_help(const char *prefix);
 
 int report_parse_ignore_callees_opt(const struct option *opt, const char *arg, int unset);
 
-- 
2.30.2



