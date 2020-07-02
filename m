Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E1221238E
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 14:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgGBMl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 08:41:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728893AbgGBMlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 08:41:55 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8F7220885;
        Thu,  2 Jul 2020 12:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593693715;
        bh=kz9q/RhKvafSLWFgHoh8hh0ChtTlciMAxIfZQi0OqxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHP5dLcicyn6W85b47Tq7ZIhcRyWB54E0NZZ4NxW37h5zwFxGKiZZz21fg4+95m6F
         s+b9/Ua7VJCj512+Lzjy4ys5/0/f/16/7kuXCbOD8mm/GIa9Iv8/LjlU9hLDmQx6ri
         8KcjGgLHq0u0g+bboIVBaZkk3eIXnW7vKhi5a/gU=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     stable@vger.kernel.org
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Changbin Du <changbin.du@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        mhiramat@kernel.org
Subject: [PATCH for 4.4.y 2/5] perf annotate: Use asprintf when formatting objdump command line
Date:   Thu,  2 Jul 2020 21:41:51 +0900
Message-Id: <159369371160.82195.6256832681408269888.stgit@devnote2>
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
 tools/perf/util/annotate.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 1dd1949b0e79..1e1c37a17355 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1077,7 +1077,7 @@ int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
 	struct dso *dso = map->dso;
 	char *filename = dso__build_id_filename(dso, NULL, 0);
 	bool free_filename = true;
-	char command[PATH_MAX * 2];
+	char *command;
 	FILE *file;
 	int err = 0;
 	char symfs_filename[PATH_MAX];
@@ -1192,7 +1192,7 @@ fallback:
 		strcpy(symfs_filename, tmp);
 	}
 
-	snprintf(command, sizeof(command),
+	err = asprintf(&command,
 		 "%s %s%s --start-address=0x%016" PRIx64
 		 " --stop-address=0x%016" PRIx64
 		 " -l -d %s %s -C %s 2>/dev/null|grep -v %s|expand",
@@ -1205,6 +1205,11 @@ fallback:
 		 symbol_conf.annotate_src ? "-S" : "",
 		 symfs_filename, filename);
 
+	if (err < 0) {
+		pr_err("Failure allocating memory for the command to run\n");
+		goto out_remove_tmp;
+	}
+
 	pr_debug("Executing: %s\n", command);
 
 	file = popen(command, "r");
@@ -1214,7 +1219,7 @@ fallback:
 		 * If we were using debug info should retry with
 		 * original binary.
 		 */
-		goto out_remove_tmp;
+		goto out_free_command;
 	}
 
 	nline = 0;
@@ -1237,6 +1242,9 @@ fallback:
 
 	pclose(file);
 
+out_free_command:
+	free(command);
+
 out_remove_tmp:
 	if (dso__needs_decompress(dso))
 		unlink(symfs_filename);

