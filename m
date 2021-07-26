Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593473D602C
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbhGZPVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237119AbhGZPVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:21:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16D8060F38;
        Mon, 26 Jul 2021 16:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315297;
        bh=AhXDNqkMw3K285oXKu6YHtYGonA6D+q/TkooyMl8qVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=edIzf2LSZD3fiN3QOE5qBjsI1WdyZ+tInUgevwRBT5dIglqNmNxYKFcCPvsvL54vr
         9t5bDvJXyez1zffp5UvBdmpV3EceeIts8qwhmhUznipCt23/ecEkTRlyMgEichgIAd
         //jNufNRUvdEmmRYG6KtUjZtlfnKddAYJzmnJxh0=
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
Subject: [PATCH 5.10 042/167] perf report: Free generated help strings for sort option
Date:   Mon, 26 Jul 2021 17:37:55 +0200
Message-Id: <20210726153840.808487257@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
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
index 3c74c9c0f3c3..5824aa24acfc 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1143,6 +1143,8 @@ int cmd_report(int argc, const char **argv)
 		.socket_filter		 = -1,
 		.annotation_opts	 = annotation__default_options,
 	};
+	char *sort_order_help = sort_help("sort by key(s):");
+	char *field_order_help = sort_help("output field(s): overhead period sample ");
 	const struct option options[] = {
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
@@ -1177,9 +1179,9 @@ int cmd_report(int argc, const char **argv)
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
@@ -1308,11 +1310,11 @@ int cmd_report(int argc, const char **argv)
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
@@ -1326,8 +1328,10 @@ int cmd_report(int argc, const char **argv)
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
@@ -1341,12 +1345,14 @@ int cmd_report(int argc, const char **argv)
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
@@ -1370,12 +1376,14 @@ int cmd_report(int argc, const char **argv)
 
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
@@ -1603,5 +1611,8 @@ error:
 
 	zstd_fini(&(session->zstd_data));
 	perf_session__delete(session);
+exit:
+	free(sort_order_help);
+	free(field_order_help);
 	return ret;
 }
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 8a3b7d5a4737..5e9e96452b9e 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -3177,7 +3177,7 @@ static void add_hpp_sort_string(struct strbuf *sb, struct hpp_dimension *s, int
 		add_key(sb, s[i].name, llen);
 }
 
-const char *sort_help(const char *prefix)
+char *sort_help(const char *prefix)
 {
 	struct strbuf sb;
 	char *s;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 66d39c4cfe2b..fc94dcd67abc 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -293,7 +293,7 @@ void reset_output_field(void);
 void sort__setup_elide(FILE *fp);
 void perf_hpp__set_elide(int idx, bool elide);
 
-const char *sort_help(const char *prefix);
+char *sort_help(const char *prefix);
 
 int report_parse_ignore_callees_opt(const struct option *opt, const char *arg, int unset);
 
-- 
2.30.2



