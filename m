Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3545313CF0
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235280AbhBHSOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:14:01 -0500
Received: from aposti.net ([89.234.176.197]:44402 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235331AbhBHSM4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:12:56 -0500
From:   Paul Cercueil <paul@crapouillou.net>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, od@zcrc.me,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH] perf stat: Use nftw() instead of ftw()
Date:   Mon,  8 Feb 2021 18:11:57 +0000
Message-Id: <20210208181157.1324550-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ftw() has been obsolete for about 12 years now.

Fixes: bb1c15b60b98 ("perf stat: Support regex pattern in --for-each-cgroup")
CC: stable@vger.kernel.org
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---

Notes:
    NOTE: Not runtime-tested, I have no idea what I need to do in perf
    to test this. But at least it compiles now with my uClibc-based
    toolchain.

 tools/perf/util/cgroup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
index 5dff7e489921..f24ab4585553 100644
--- a/tools/perf/util/cgroup.c
+++ b/tools/perf/util/cgroup.c
@@ -161,7 +161,7 @@ void evlist__set_default_cgroup(struct evlist *evlist, struct cgroup *cgroup)
 
 /* helper function for ftw() in match_cgroups and list_cgroups */
 static int add_cgroup_name(const char *fpath, const struct stat *sb __maybe_unused,
-			   int typeflag)
+			   int typeflag, struct FTW *ftwbuf __maybe_unused)
 {
 	struct cgroup_name *cn;
 
@@ -209,12 +209,12 @@ static int list_cgroups(const char *str)
 			if (!s)
 				return -1;
 			/* pretend if it's added by ftw() */
-			ret = add_cgroup_name(s, NULL, FTW_D);
+			ret = add_cgroup_name(s, NULL, FTW_D, NULL);
 			free(s);
 			if (ret)
 				return -1;
 		} else {
-			if (add_cgroup_name("", NULL, FTW_D) < 0)
+			if (add_cgroup_name("", NULL, FTW_D, NULL) < 0)
 				return -1;
 		}
 
@@ -247,7 +247,7 @@ static int match_cgroups(const char *str)
 	prefix_len = strlen(mnt);
 
 	/* collect all cgroups in the cgroup_list */
-	if (ftw(mnt, add_cgroup_name, 20) < 0)
+	if (nftw(mnt, add_cgroup_name, 20, 0) < 0)
 		return -1;
 
 	for (;;) {
-- 
2.30.0

