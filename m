Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42F245E593
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 04:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358473AbhKZCng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:43:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358481AbhKZClX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:41:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C67E61155;
        Fri, 26 Nov 2021 02:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894086;
        bh=uyHjeqVGdSnFGny2L9uSilrTJtV1Hkq8Oi8TQNt2mus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VcHocegA70v6NzZUWmVBdxoIcexJMYz+lLexXMMFF70aUxzDluj3huF+hYniYaWVH
         LGF/HFYRNGj4uGhCLkyXZawCACfBQWbcb9yZ3uj1aTLdkNtU1F1lTArAFmgPII4fuF
         VqkITSRE5DKESkW4PC2aR86FxJgv/5hR5rtezuNDWTw6urG1xra4wHInFc4TfRlRj6
         /IMB8Fpdd3Za+Vt84JrQBVq6ZQT+UuJYFEOHZuNNzbiebNTFphxXtzwSME0jf7jCKb
         vxxKXNbYwi749EEBABVVt/MLOYmigmCwVCXcPo9OUj80lTIzRzBnA26AooBL5fOOPh
         eRPilssF8BrgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        acme@kernel.org, linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 28/28] perf report: Fix memory leaks around perf_tip()
Date:   Thu, 25 Nov 2021 21:33:43 -0500
Message-Id: <20211126023343.442045-28-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023343.442045-1-sashal@kernel.org>
References: <20211126023343.442045-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit d9fc706108c15f8bc2d4ccccf8e50f74830fabd9 ]

perf_tip() may allocate memory or use a literal, this means memory
wasn't freed if allocated. Change the API so that literals aren't used.

At the same time add missing frees for system_path. These issues were
spotted using leak sanitizer.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20211118073804.2149974-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-report.c | 15 +++++++++------
 tools/perf/util/util.c      | 14 +++++++-------
 tools/perf/util/util.h      |  2 +-
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5824aa24acfcc..91cab5cdfbc16 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -610,14 +610,17 @@ static int report__browse_hists(struct report *rep)
 	int ret;
 	struct perf_session *session = rep->session;
 	struct evlist *evlist = session->evlist;
-	const char *help = perf_tip(system_path(TIPDIR));
+	char *help = NULL, *path = NULL;
 
-	if (help == NULL) {
+	path = system_path(TIPDIR);
+	if (perf_tip(&help, path) || help == NULL) {
 		/* fallback for people who don't install perf ;-) */
-		help = perf_tip(DOCDIR);
-		if (help == NULL)
-			help = "Cannot load tips.txt file, please install perf!";
+		free(path);
+		path = system_path(DOCDIR);
+		if (perf_tip(&help, path) || help == NULL)
+			help = strdup("Cannot load tips.txt file, please install perf!");
 	}
+	free(path);
 
 	switch (use_browser) {
 	case 1:
@@ -644,7 +647,7 @@ static int report__browse_hists(struct report *rep)
 		ret = perf_evlist__tty_browse_hists(evlist, rep, help);
 		break;
 	}
-
+	free(help);
 	return ret;
 }
 
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 37a9492edb3eb..df3c4671be72a 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -379,32 +379,32 @@ fetch_kernel_version(unsigned int *puint, char *str,
 	return 0;
 }
 
-const char *perf_tip(const char *dirpath)
+int perf_tip(char **strp, const char *dirpath)
 {
 	struct strlist *tips;
 	struct str_node *node;
-	char *tip = NULL;
 	struct strlist_config conf = {
 		.dirname = dirpath,
 		.file_only = true,
 	};
+	int ret = 0;
 
+	*strp = NULL;
 	tips = strlist__new("tips.txt", &conf);
 	if (tips == NULL)
-		return errno == ENOENT ? NULL :
-			"Tip: check path of tips.txt or get more memory! ;-p";
+		return -errno;
 
 	if (strlist__nr_entries(tips) == 0)
 		goto out;
 
 	node = strlist__entry(tips, random() % strlist__nr_entries(tips));
-	if (asprintf(&tip, "Tip: %s", node->s) < 0)
-		tip = (char *)"Tip: get more memory! ;-)";
+	if (asprintf(strp, "Tip: %s", node->s) < 0)
+		ret = -ENOMEM;
 
 out:
 	strlist__delete(tips);
 
-	return tip;
+	return ret;
 }
 
 char *perf_exe(char *buf, int len)
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index ad737052e5977..9f0d36ba77f2d 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -39,7 +39,7 @@ int fetch_kernel_version(unsigned int *puint,
 #define KVER_FMT	"%d.%d.%d"
 #define KVER_PARAM(x)	KVER_VERSION(x), KVER_PATCHLEVEL(x), KVER_SUBLEVEL(x)
 
-const char *perf_tip(const char *dirpath);
+int perf_tip(char **strp, const char *dirpath);
 
 #ifndef HAVE_SCHED_GETCPU_SUPPORT
 int sched_getcpu(void);
-- 
2.33.0

