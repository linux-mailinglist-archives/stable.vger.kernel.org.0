Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091BC5F2A1B
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbiJCHbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiJCH3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:29:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D03178A3;
        Mon,  3 Oct 2022 00:20:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD39AB80E89;
        Mon,  3 Oct 2022 07:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFAEC433D6;
        Mon,  3 Oct 2022 07:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781596;
        bh=HFxNYfsVUsm8M5vjB+4YNyHRnJJ7GKVdKvGrd/NnvvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zEJkd0yBx6d3ttqsunetCbEQAo4O/PTzsJMUNzeIIpKjG43FjKC4whhAjArdPiSZc
         EyKXhX4Ze29MuFRD8TeWlp1LUf8zTmSxprPOnxPsa7kqX3IeooBBMhJ/EDhpt1ahr1
         LoET+VYxt5M5a6inX+dJmLPYYTlX2L7OOq4c/qOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Clark <james.clark@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Denis Nikitin <denik@chromium.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 77/83] perf tools: Check vmlinux/kallsyms arguments in all tools
Date:   Mon,  3 Oct 2022 09:11:42 +0200
Message-Id: <20221003070723.925595482@linuxfoundation.org>
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

From: James Clark <james.clark@arm.com>

[ Upstream commit 7cc72553ac03ec20afe2dec91dce4624ccd379b8 ]

Only perf report checked the validity of these arguments so apply the
same check to all tools that read them for consistency.

Signed-off-by: James Clark <james.clark@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Denis Nikitin <denik@chromium.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20211018134844.2627174-3-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 71c86cda750b ("perf parse-events: Remove "not supported" hybrid cache events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-annotate.c | 4 ++++
 tools/perf/builtin-c2c.c      | 4 ++++
 tools/perf/builtin-probe.c    | 5 +++++
 tools/perf/builtin-record.c   | 4 ++++
 tools/perf/builtin-sched.c    | 4 ++++
 tools/perf/builtin-script.c   | 3 +++
 tools/perf/builtin-top.c      | 4 ++++
 7 files changed, 28 insertions(+)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 05eb098cb0e3..490bb9b8cf17 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -591,6 +591,10 @@ int cmd_annotate(int argc, const char **argv)
 		return ret;
 	}
 
+	ret = symbol__validate_sym_arguments();
+	if (ret)
+		return ret;
+
 	if (quiet)
 		perf_quiet_option();
 
diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index e6f900c3accb..6d901ba6678f 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -2770,6 +2770,10 @@ static int perf_c2c__report(int argc, const char **argv)
 	if (c2c.stats_only)
 		c2c.use_stdio = true;
 
+	err = symbol__validate_sym_arguments();
+	if (err)
+		goto out;
+
 	if (!input_name || !strlen(input_name))
 		input_name = "perf.data";
 
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index e1dd51f2874b..c31627af75d4 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -21,6 +21,7 @@
 #include "util/build-id.h"
 #include "util/strlist.h"
 #include "util/strfilter.h"
+#include "util/symbol.h"
 #include "util/symbol_conf.h"
 #include "util/debug.h"
 #include <subcmd/parse-options.h>
@@ -629,6 +630,10 @@ __cmd_probe(int argc, const char **argv)
 		params.command = 'a';
 	}
 
+	ret = symbol__validate_sym_arguments();
+	if (ret)
+		return ret;
+
 	if (params.quiet) {
 		if (verbose != 0) {
 			pr_err("  Error: -v and -q are exclusive.\n");
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b3509d9d20cc..dcb3ed24fc4a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -2680,6 +2680,10 @@ int cmd_record(int argc, const char **argv)
 	if (quiet)
 		perf_quiet_option();
 
+	err = symbol__validate_sym_arguments();
+	if (err)
+		return err;
+
 	/* Make system wide (-a) the default target. */
 	if (!argc && target__none(&rec->opts.target))
 		rec->opts.target.system_wide = true;
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 635a6b5a9ec9..4527f632ebe4 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3538,6 +3538,7 @@ int cmd_sched(int argc, const char **argv)
 		.fork_event	    = replay_fork_event,
 	};
 	unsigned int i;
+	int ret;
 
 	for (i = 0; i < ARRAY_SIZE(sched.curr_pid); i++)
 		sched.curr_pid[i] = -1;
@@ -3598,6 +3599,9 @@ int cmd_sched(int argc, const char **argv)
 				parse_options_usage(NULL, timehist_options, "n", true);
 			return -EINVAL;
 		}
+		ret = symbol__validate_sym_arguments();
+		if (ret)
+			return ret;
 
 		return perf_sched__timehist(&sched);
 	} else {
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index c6c40191933d..f346275c9d21 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -3839,6 +3839,9 @@ int cmd_script(int argc, const char **argv)
 	data.path  = input_name;
 	data.force = symbol_conf.force;
 
+	if (symbol__validate_sym_arguments())
+		return -1;
+
 	if (argc > 1 && !strncmp(argv[0], "rec", strlen("rec"))) {
 		rec_script_path = get_script_path(argv[1], RECORD_SUFFIX);
 		if (!rec_script_path)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a3ae9176a83e..aa5190ecc72a 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1618,6 +1618,10 @@ int cmd_top(int argc, const char **argv)
 	if (argc)
 		usage_with_options(top_usage, options);
 
+	status = symbol__validate_sym_arguments();
+	if (status)
+		goto out_delete_evlist;
+
 	if (annotate_check_args(&top.annotation_opts) < 0)
 		goto out_delete_evlist;
 
-- 
2.35.1



