Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CC321238F
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 14:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgGBMmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 08:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728893AbgGBMmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 08:42:05 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8D3720885;
        Thu,  2 Jul 2020 12:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593693724;
        bh=sAfvndzCaVEZ17RBM5MPMk7qYUeKGlbCPZsMSKGP6ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=To2Innsj7a/f3CTpjhuGrH5TWQlu11TWpfvZnV8e0R59/QFG2Eto20+ys2zHiCBSS
         Gq4J3QEe1d1kMIFrpJ5F3Txcg0k/18rPbGFOFppxeLE17tG8b8dbRlpnAggZO0o08H
         VVf4jIxbVca4qiIHLsO+gXLEqPTwhDoHA+53Aq+0=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     stable@vger.kernel.org
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Changbin Du <changbin.du@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        mhiramat@kernel.org
Subject: [PATCH for 4.4.y 3/5] perf tools: Fix snprint warnings for gcc 8
Date:   Thu,  2 Jul 2020 21:42:00 +0900
Message-Id: <159369372057.82195.11624669677445113892.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <159369369207.82195.5763005209795799082.stgit@devnote2>
References: <159369369207.82195.5763005209795799082.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

commit 77f18153c080855e1c3fb520ca31a4e61530121d upstream.

[Add an additional sprintf replacement in tools/perf/builtin-script.c]

With gcc 8 we get new set of snprintf() warnings that breaks the
compilation, one example:

  tests/mem.c: In function ‘check’:
  tests/mem.c:19:48: error: ‘%s’ directive output may be truncated writing \
        up to 99 bytes into a region of size 89 [-Werror=format-truncation=]
    snprintf(failure, sizeof failure, "unexpected %s", out);

The gcc docs says:

 To avoid the warning either use a bigger buffer or handle the
 function's return value which indicates whether or not its output
 has been truncated.

Given that all these warnings are harmless, because the code either
properly fails due to uncomplete file path or we don't care for
truncated output at all, I'm changing all those snprintf() calls to
scnprintf(), which actually 'checks' for the snprint return value so the
gcc stays silent.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Link: http://lkml.kernel.org/r/20180319082902.4518-1-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c    |   24 ++++++++++++------------
 tools/perf/tests/attr.c        |    4 ++--
 tools/perf/tests/pmu.c         |    2 +-
 tools/perf/util/cgroup.c       |    2 +-
 tools/perf/util/parse-events.c |    4 ++--
 tools/perf/util/pmu.c          |    2 +-
 6 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 20f0e27918dd..acd460303d1a 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1245,7 +1245,7 @@ static int is_directory(const char *base_path, const struct dirent *dent)
 	char path[PATH_MAX];
 	struct stat st;
 
-	sprintf(path, "%s/%s", base_path, dent->d_name);
+	scnprintf(path, PATH_MAX, "%s/%s", base_path, dent->d_name);
 	if (stat(path, &st))
 		return 0;
 
@@ -1426,8 +1426,8 @@ static int list_available_scripts(const struct option *opt __maybe_unused,
 		return -1;
 
 	for_each_lang(scripts_path, scripts_dir, lang_dirent) {
-		snprintf(lang_path, MAXPATHLEN, "%s/%s/bin", scripts_path,
-			 lang_dirent->d_name);
+		scnprintf(lang_path, MAXPATHLEN, "%s/%s/bin", scripts_path,
+			  lang_dirent->d_name);
 		lang_dir = opendir(lang_path);
 		if (!lang_dir)
 			continue;
@@ -1436,8 +1436,8 @@ static int list_available_scripts(const struct option *opt __maybe_unused,
 			script_root = get_script_root(script_dirent, REPORT_SUFFIX);
 			if (script_root) {
 				desc = script_desc__findnew(script_root);
-				snprintf(script_path, MAXPATHLEN, "%s/%s",
-					 lang_path, script_dirent->d_name);
+				scnprintf(script_path, MAXPATHLEN, "%s/%s",
+					  lang_path, script_dirent->d_name);
 				read_script_info(desc, script_path);
 				free(script_root);
 			}
@@ -1473,7 +1473,7 @@ static int check_ev_match(char *dir_name, char *scriptname,
 	int match, len;
 	FILE *fp;
 
-	sprintf(filename, "%s/bin/%s-record", dir_name, scriptname);
+	scnprintf(filename, MAXPATHLEN, "%s/bin/%s-record", dir_name, scriptname);
 
 	fp = fopen(filename, "r");
 	if (!fp)
@@ -1549,8 +1549,8 @@ int find_scripts(char **scripts_array, char **scripts_path_array)
 	}
 
 	for_each_lang(scripts_path, scripts_dir, lang_dirent) {
-		snprintf(lang_path, MAXPATHLEN, "%s/%s", scripts_path,
-			 lang_dirent->d_name);
+		scnprintf(lang_path, MAXPATHLEN, "%s/%s", scripts_path,
+			  lang_dirent->d_name);
 #ifdef NO_LIBPERL
 		if (strstr(lang_path, "perl"))
 			continue;
@@ -1605,8 +1605,8 @@ static char *get_script_path(const char *script_root, const char *suffix)
 		return NULL;
 
 	for_each_lang(scripts_path, scripts_dir, lang_dirent) {
-		snprintf(lang_path, MAXPATHLEN, "%s/%s/bin", scripts_path,
-			 lang_dirent->d_name);
+		scnprintf(lang_path, MAXPATHLEN, "%s/%s/bin", scripts_path,
+			  lang_dirent->d_name);
 		lang_dir = opendir(lang_path);
 		if (!lang_dir)
 			continue;
@@ -1617,8 +1617,8 @@ static char *get_script_path(const char *script_root, const char *suffix)
 				free(__script_root);
 				closedir(lang_dir);
 				closedir(scripts_dir);
-				snprintf(script_path, MAXPATHLEN, "%s/%s",
-					 lang_path, script_dirent->d_name);
+				scnprintf(script_path, MAXPATHLEN, "%s/%s",
+					  lang_path, script_dirent->d_name);
 				return strdup(script_path);
 			}
 			free(__script_root);
diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index 79547c225c14..9c81fbfb16d2 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -147,8 +147,8 @@ static int run_dir(const char *d, const char *perf)
 	if (verbose)
 		vcnt++;
 
-	snprintf(cmd, 3*PATH_MAX, PYTHON " %s/attr.py -d %s/attr/ -p %s %.*s",
-		 d, d, perf, vcnt, v);
+	scnprintf(cmd, 3*PATH_MAX, PYTHON " %s/attr.py -d %s/attr/ -p %s %.*s",
+		  d, d, perf, vcnt, v);
 
 	return system(cmd) ? TEST_FAIL : TEST_OK;
 }
diff --git a/tools/perf/tests/pmu.c b/tools/perf/tests/pmu.c
index faa04e9d5d5f..b776831ceeea 100644
--- a/tools/perf/tests/pmu.c
+++ b/tools/perf/tests/pmu.c
@@ -95,7 +95,7 @@ static char *test_format_dir_get(void)
 		struct test_format *format = &test_formats[i];
 		FILE *file;
 
-		snprintf(name, PATH_MAX, "%s/%s", dir, format->name);
+		scnprintf(name, PATH_MAX, "%s/%s", dir, format->name);
 
 		file = fopen(name, "w");
 		if (!file)
diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
index 32e12ecfe9c5..a32f0b34e3ed 100644
--- a/tools/perf/util/cgroup.c
+++ b/tools/perf/util/cgroup.c
@@ -64,7 +64,7 @@ static int open_cgroup(char *name)
 	if (cgroupfs_find_mountpoint(mnt, PATH_MAX + 1))
 		return -1;
 
-	snprintf(path, PATH_MAX, "%s/%s", mnt, name);
+	scnprintf(path, PATH_MAX, "%s/%s", mnt, name);
 
 	fd = open(path, O_RDONLY);
 	if (fd == -1)
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9351738df703..849ad278dd5d 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -194,8 +194,8 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 
 		for_each_event(sys_dirent, evt_dir, evt_dirent) {
 
-			snprintf(evt_path, MAXPATHLEN, "%s/%s/id", dir_path,
-				 evt_dirent->d_name);
+			scnprintf(evt_path, MAXPATHLEN, "%s/%s/id", dir_path,
+				  evt_dirent->d_name);
 			fd = open(evt_path, O_RDONLY);
 			if (fd < 0)
 				continue;
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 4f650ebd564a..5245fbd09106 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -302,7 +302,7 @@ static int pmu_aliases_parse(char *dir, struct list_head *head)
 		if (pmu_alias_info_file(name))
 			continue;
 
-		snprintf(path, PATH_MAX, "%s/%s", dir, name);
+		scnprintf(path, PATH_MAX, "%s/%s", dir, name);
 
 		file = fopen(path, "r");
 		if (!file) {

