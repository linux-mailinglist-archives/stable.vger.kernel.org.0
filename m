Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925B6232E08
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbgG3IK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729321AbgG3IKY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:10:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBA8E2070B;
        Thu, 30 Jul 2020 08:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096623;
        bh=oXEtJ6/1NuejKNuU+pt0QfOvmlq910ETyc27OArVSf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFIq+yV9WS7n3dYxF2dbe5PSQYwIqfJOi4v6Libw87luJj4KezbS9viRUE3kbQTnq
         Rd4eicAM4FUIxqYRyzTZXPOilLWw6fjmQaluumK3P1Mui/aGMcLQH9iN4zg/iybnmX
         wNJhSykk4EHGV+0TPpNX8aT95CqpBFyvVKacj2Ac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.9 59/61] perf annotate: Use asprintf when formatting objdump command line
Date:   Thu, 30 Jul 2020 10:05:17 +0200
Message-Id: <20200730074423.695853645@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.811058810@linuxfoundation.org>
References: <20200730074420.811058810@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/annotate.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1302,7 +1302,7 @@ fallback:
 int symbol__disassemble(struct symbol *sym, struct map *map, size_t privsize)
 {
 	struct dso *dso = map->dso;
-	char command[PATH_MAX * 2];
+	char *command;
 	FILE *file;
 	char symfs_filename[PATH_MAX];
 	struct kcore_extract kce;
@@ -1364,7 +1364,7 @@ int symbol__disassemble(struct symbol *s
 		strcpy(symfs_filename, tmp);
 	}
 
-	snprintf(command, sizeof(command),
+	err = asprintf(&command,
 		 "%s %s%s --start-address=0x%016" PRIx64
 		 " --stop-address=0x%016" PRIx64
 		 " -l -d %s %s -C %s 2>/dev/null|grep -v %s|expand",
@@ -1377,12 +1377,17 @@ int symbol__disassemble(struct symbol *s
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
@@ -1409,7 +1414,7 @@ int symbol__disassemble(struct symbol *s
 		 * If we were using debug info should retry with
 		 * original binary.
 		 */
-		goto out_remove_tmp;
+		goto out_free_command;
 	}
 
 	nline = 0;
@@ -1432,6 +1437,8 @@ int symbol__disassemble(struct symbol *s
 
 	fclose(file);
 	err = 0;
+out_free_command:
+	free(command);
 out_remove_tmp:
 	close(stdout_fd[0]);
 
@@ -1445,7 +1452,7 @@ out:
 
 out_close_stdout:
 	close(stdout_fd[1]);
-	goto out_remove_tmp;
+	goto out_free_command;
 }
 
 static void insert_source_line(struct rb_root *root, struct source_line *src_line)


