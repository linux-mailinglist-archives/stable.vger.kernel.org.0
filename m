Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3D2469C3D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346842AbhLFPV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:21:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37916 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345843AbhLFPTG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:19:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30F7E6130D;
        Mon,  6 Dec 2021 15:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE79C341C1;
        Mon,  6 Dec 2021 15:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803736;
        bh=uyHjeqVGdSnFGny2L9uSilrTJtV1Hkq8Oi8TQNt2mus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ldK49gIUSeOdmGeyopWQ1vt2NqnqCMKE24I62nn1jXOXitByw9rBwMeAgM+uQT6NE
         l/1Hr2lSJkkZwmxlWTkavZ5MHvztzjuB+OIiVSepDWBq/s+BIPWtlfM8H6ZNZwUTdK
         crTYbCw3PuvgBkLmcCwCsXDr7R1K7KY6/Q7T/Sp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/130] perf report: Fix memory leaks around perf_tip()
Date:   Mon,  6 Dec 2021 15:55:45 +0100
Message-Id: <20211206145600.613797456@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



