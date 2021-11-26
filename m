Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585ED45E5D2
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 04:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358635AbhKZCpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:45:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:50264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358670AbhKZCnX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:43:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F3E061251;
        Fri, 26 Nov 2021 02:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894132;
        bh=q0Mme3d1DVbEv0L+HjUgGXO6bOGqr8By/Vv7KHKla4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2snmn9mSuAeTmTC/ILIyWkJ3rc9mIrtP85hqzsdYZALDGmthhkCqFtx2NXZvAMYP
         zBPx0s/WIY4nQ/OxpRXvPPAcL/x1zDod9UN3IYdo5IR3Yw3FzE2IKduwrSBnZ0MG1x
         ceYjvMJlzCn1v9bYgy5V36xoW1w6xawst5iMZc3Ehp+wq9FxHyHiuiOvbMDt/PZaox
         z5uyy8E1qtvo05+b9IWueVgLXpPP7HjG62dWOyLDQ5WEIgTltYVyBLC1T3NYKK6rZz
         48Ugt6quCuRSM98CHxSGR/4+BPc8huVzIBeouSpCkcWwZhGJ9WR/LNOl2AoxM2l4LD
         mm0spFdAmbJHw==
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
Subject: [PATCH AUTOSEL 5.4 19/19] perf report: Fix memory leaks around perf_tip()
Date:   Thu, 25 Nov 2021 21:34:48 -0500
Message-Id: <20211126023448.442529-19-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023448.442529-1-sashal@kernel.org>
References: <20211126023448.442529-1-sashal@kernel.org>
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
index d3c0b04e2e22b..dc228bdf2bbc2 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -569,14 +569,17 @@ static int report__browse_hists(struct report *rep)
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
@@ -598,7 +601,7 @@ static int report__browse_hists(struct report *rep)
 		ret = perf_evlist__tty_browse_hists(evlist, rep, help);
 		break;
 	}
-
+	free(help);
 	return ret;
 }
 
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index ae56c766eda16..b3c1ae288b478 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -343,32 +343,32 @@ fetch_kernel_version(unsigned int *puint, char *str,
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
index 9969b8b46f7c3..e4a7e1cafc70a 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -37,7 +37,7 @@ int fetch_kernel_version(unsigned int *puint,
 #define KVER_FMT	"%d.%d.%d"
 #define KVER_PARAM(x)	KVER_VERSION(x), KVER_PATCHLEVEL(x), KVER_SUBLEVEL(x)
 
-const char *perf_tip(const char *dirpath);
+int perf_tip(char **strp, const char *dirpath);
 
 #ifndef HAVE_SCHED_GETCPU_SUPPORT
 int sched_getcpu(void);
-- 
2.33.0

