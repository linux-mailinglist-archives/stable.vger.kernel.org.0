Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A1420F779
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 16:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730954AbgF3Opy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 10:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgF3Opx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jun 2020 10:45:53 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BB6A20663;
        Tue, 30 Jun 2020 14:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593528352;
        bh=My22mPDN8mk4h9duRKk26JPgDQXI+269KgBzqZAi9oM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QC9K/96+5R/Z23tDANoAjZJWu7B+LRVpmBkaUiULwIEf4neqzTiaLojVDB8EtYJRR
         LbiJdI3SD4nAa5MRZj6NL/cWHZDLBW4tLzr4bXwGlp9eJ9apIyEzrLCM8VK6oX6rDz
         EHUzxHieK5/CRot86TxzVx1bagia0sZpaciVSDFU=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     stable@vger.kernel.org
Cc:     Changbin Du <changbin.du@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        mhiramat@kernel.org
Subject: [PATCH for 4.9 2/4] perf annotate: Use asprintf when formatting objdump command line
Date:   Tue, 30 Jun 2020 23:45:49 +0900
Message-Id: <159352834905.45385.1129399396205769928.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <159352833055.45385.11124685086393181445.stgit@devnote2>
References: <159352833055.45385.11124685086393181445.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 6810158d526e483868e519befff407b91e76b3db upstream.

We were using a local buffer with an arbitrary size, that would have to
get increased to avoid truncation as warned by gcc 8:

  util/annotate.c: In function 'symbol__disassemble':
  util/annotate.c:1488:4: error: '%s' directive output may be truncated writing up to 4095 bytes into a region of size between 3966 and 8086 [-Werror=format-truncation=]
      "%s %s%s --start-address=0x%016" PRIx64
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  util/annotate.c:1498:20:
      symfs_filename, symfs_filename);
                      ~~~~~~~~~~~~~~
  util/annotate.c:1490:50: note: format string is defined here
      " -l -d %s %s -C \"%s\" 2>/dev/null|grep -v \"%s:\"|expand",
                                                  ^~
  In file included from /usr/include/stdio.h:861,
                   from util/color.h:5,
                   from util/sort.h:8,
                   from util/annotate.c:14:
  /usr/include/bits/stdio2.h:67:10: note: '__builtin___snprintf_chk' output 116 or more bytes (assuming 8331) into a destination of size 8192
     return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          __bos (__s), __fmt, __va_arg_pack ());
          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

So switch to asprintf, that will make sure enough space is available.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>
Link: https://lkml.kernel.org/n/tip-qagoy2dmbjpc9gdnaj0r3mml@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 3336cbc6ec48..1d4807c46efd 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1302,7 +1302,7 @@ static int dso__disassemble_filename(struct dso *dso, char *filename, size_t fil
 int symbol__disassemble(struct symbol *sym, struct map *map, size_t privsize)
 {
 	struct dso *dso = map->dso;
-	char command[PATH_MAX * 2];
+	char *command;
 	FILE *file;
 	char symfs_filename[PATH_MAX];
 	struct kcore_extract kce;
@@ -1364,7 +1364,7 @@ int symbol__disassemble(struct symbol *sym, struct map *map, size_t privsize)
 		strcpy(symfs_filename, tmp);
 	}
 
-	snprintf(command, sizeof(command),
+	err = asprintf(&command,
 		 "%s %s%s --start-address=0x%016" PRIx64
 		 " --stop-address=0x%016" PRIx64
 		 " -l -d %s %s -C %s 2>/dev/null|grep -v %s|expand",
@@ -1377,12 +1377,17 @@ int symbol__disassemble(struct symbol *sym, struct map *map, size_t privsize)
 		 symbol_conf.annotate_src ? "-S" : "",
 		 symfs_filename, symfs_filename);
 
+	if (err < 0) {
+		pr_err("Failure allocating memory for the command to run\n");
+		goto out_remove_tmp;
+	}
+
 	pr_debug("Executing: %s\n", command);
 
 	err = -1;
 	if (pipe(stdout_fd) < 0) {
 		pr_err("Failure creating the pipe to run %s\n", command);
-		goto out_remove_tmp;
+		goto out_free_command;
 	}
 
 	pid = fork();
@@ -1409,7 +1414,7 @@ int symbol__disassemble(struct symbol *sym, struct map *map, size_t privsize)
 		 * If we were using debug info should retry with
 		 * original binary.
 		 */
-		goto out_remove_tmp;
+		goto out_free_command;
 	}
 
 	nline = 0;
@@ -1432,6 +1437,8 @@ int symbol__disassemble(struct symbol *sym, struct map *map, size_t privsize)
 
 	fclose(file);
 	err = 0;
+out_free_command:
+	free(command);
 out_remove_tmp:
 	close(stdout_fd[0]);
 
@@ -1445,7 +1452,7 @@ int symbol__disassemble(struct symbol *sym, struct map *map, size_t privsize)
 
 out_close_stdout:
 	close(stdout_fd[1]);
-	goto out_remove_tmp;
+	goto out_free_command;
 }
 
 static void insert_source_line(struct rb_root *root, struct source_line *src_line)

